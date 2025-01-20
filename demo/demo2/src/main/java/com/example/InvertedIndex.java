package com.example;

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

import org.apache.hadoop.io.LongWritable;

import java.io.IOException;
import java.util.HashMap;


public class InvertedIndex extends Configured implements Tool {

    public int run(String[] args) throws Exception {
        Configuration conf = getConf();
        FileSystem fs = FileSystem.get(conf);
        Job job = Job.getInstance(conf);
        job.setJarByClass(InvertedIndex.class);
        job.setJobName("InvertedIndex");
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
        job.setMapperClass(Map.class);
        job.setCombinerClass(Reduce.class);
        job.setReducerClass(Reduce.class);
        job.setInputFormatClass(TextInputFormat.class);
        job.setOutputFormatClass(TextOutputFormat.class);
        FileInputFormat.setInputPaths(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        if (fs.exists(new Path(args[1])))
            fs.delete(new Path(args[1]), true);
        return job.waitForCompletion(true) ? 0 : 1;
    }

    public static void main(String[] args) throws Exception {
        int ret = ToolRunner.run(new InvertedIndex(), args);
        System.exit(ret);
    }

    public static class Map extends Mapper<LongWritable, Text, Text, Text> {
        @Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            // System.out.println("\n\nMap: key = " + key.get() + ", value = " + value.toString());
            // System.out.println("Map: context = " + context + "\n\n");
            
            String line = value.toString();
            String[] words = line.split("[\t\n.,:; ?!-/()\\[\\]\"\']+");
            String documentName = ((org.apache.hadoop.mapreduce.lib.input.FileSplit) context.getInputSplit()).getPath().getName();

            for (String word : words) {
                if (word.trim().length() > 0) {
                    Text text = new Text();
                    text.set(word);
                    Text docName = new Text();
                    docName.set(documentName);
                    context.write(text, docName);
                }
            }
        }
    } // end class Map

    public static class Reduce extends Reducer<Text, Text, Text, Text> {
        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            // System.out.println("\n\nReduce: key = " + key.toString());
            // for (Text val : values) {
            //     System.out.println("        value = " + val.toString());
            // }
            // System.out.println("Reduce: context = " + context + "\n\n");

            java.util.Map<String, Integer> documentsCounts = new HashMap<String, Integer>();    // <DocumentName, Count>, Count is the number of times the word appears in the document

            for (Text val : values) {
                if (documentsCounts.containsKey(val.toString())) {
                    documentsCounts.put(val.toString(), documentsCounts.get(val.toString()) + 1);
                } else {
                    documentsCounts.put(val.toString(), 1);
                }
            }
    
            // construct the value
            StringBuilder documentsCountsString = new StringBuilder();
            for (String documentName : documentsCounts.keySet()) {
                documentsCountsString.append(documentName + ": " + documentsCounts.get(documentName) + "    ");
            }

            context.write(key, new Text(documentsCountsString.toString()));
        }
    } // end class Reduce
}
