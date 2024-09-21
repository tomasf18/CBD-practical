package ex4.lab1.cbd;

import redis.clients.jedis.Jedis; 
import java.io.File;
import java.util.HashMap;
import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Set;

public class NamesAutocompleteByRegistries {
    public static void main( String[] args ) {
        Jedis jedis = new Jedis();
        Set<String> results;
        
        // get file stream so I can read the file
        try (InputStream inputStream = NamesAutocomplete.class.getResourceAsStream("/nomes-pt-2021.csv");
                Scanner fileScanner = new Scanner(inputStream)) {

            String line;
            String[] parts;
            String name;
            String n_registries;

            while (fileScanner.hasNextLine()) {
                line = fileScanner.nextLine();
                parts = line.split(";");
                name = parts[0];
                n_registries = parts[1];
                jedis.set(name, n_registries);
            }

        } catch (IOException e) {
            System.out.println("File error - 'nomes-pt-2021.csv': " + e.getMessage());
            return; 
        }


        Scanner sc = new Scanner(System.in);
        System.out.print( "Search for (Enter for quit): " );
        String input = sc.nextLine();

        /* 
            Slides: "CBD_05_KeyValue" 
            Slide 30: "KEYS pattern" - "finds all the keys matching a pattern"    
        */

        
        while (!input.isEmpty()) {
            String pattern = input + "*";

            System.out.println("Results:");
            results = jedis.keys(pattern);

            results.stream().sorted(
                (name1, name2) -> {
                    int n_reg_1 = Integer.parseInt(jedis.get(name1));
                    int n_reg_2 = Integer.parseInt(jedis.get(name2));
                    return n_reg_2 - n_reg_1;
                }).forEach(name -> {
                    System.out.println(name + " - " + jedis.get(name));
                });

            // the lambda function is using a comparator that compares the values of the keys in the redis database
            // and prints the names and the associated number of registries in descending order

            System.out.print("\n\nSearch for (Enter for quit): ");
            input = sc.nextLine();
        }

    }
}
