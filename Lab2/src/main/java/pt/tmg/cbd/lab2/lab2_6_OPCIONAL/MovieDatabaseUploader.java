package pt.tmg.cbd.lab2.lab2_6_OPCIONAL;

import com.mongodb.client.*;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;

import org.bson.Document;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class MovieDatabaseUploader {

    public static void main(String[] args) throws CsvValidationException {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("movies");

        // limpar a coleção para evitar duplicados
        collection.drop();

        try (InputStream inputStream = MovieDatabaseUploader.class.getClassLoader().getResourceAsStream("movie.csv");
             CSVReader reader = new CSVReader(new InputStreamReader(inputStream))) {
                
            String[] line;
            reader.readNext();  // saltar cabeçalho
    
            while ((line = reader.readNext()) != null) {
                String name = line[0];
                String rating = line[1];
                String genre = line[2];
                int year = !line[3].isEmpty() ? Integer.parseInt(line[3]) : 0;  // default value 0 para ano
                String released = line[4];
                double score = !line[5].isEmpty() ? Double.parseDouble(line[5]) : 0.0;  
                int votes = !line[6].isEmpty() ? Integer.parseInt(line[6]) : 0; 
                String director = line[7];
                String writer = line[8];
                String star = line[9];
                String country = line[10];
                String budget = !line[11].isEmpty() ? line[11] : "Unknown";
                String gross = !line[12].isEmpty() ? line[12] : "Unknown";  
                String company = line[13];
                String runtime = !line[14].isEmpty() ? line[14] + " min" : "Unknown";  
    
                // criar documento
                Document movieDoc = new Document("name", name)
                        .append("rating", rating)
                        .append("genre", genre)
                        .append("year", year)
                        .append("released", released)
                        .append("score", score)
                        .append("votes", votes)
                        .append("director", director)
                        .append("writer", writer)
                        .append("star", star)
                        .append("country", country)
                        .append("budget", budget)
                        .append("gross", gross)
                        .append("company", company)
                        .append("runtime", runtime);
    
                // inserrir documento
                collection.insertOne(movieDoc);
            }

            System.out.println("Dados inseridos com sucesso");

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            mongoClient.close();
        }
    }
}
