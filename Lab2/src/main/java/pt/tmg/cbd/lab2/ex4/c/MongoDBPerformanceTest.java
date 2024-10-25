package pt.tmg.cbd.lab2.ex4.c;

import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;

import org.bson.Document;

public class MongoDBPerformanceTest {
    public static void main(String[] args) {
        try (var mongoClient = MongoClients.create("mongodb://localhost:27017")) {
            MongoDatabase database = mongoClient.getDatabase("cbd");
            MongoCollection<Document> collection = database.getCollection("service_system");

            int limit = 1000; // num of operations

            // write test
            long startWrite = System.nanoTime();
            for (int i = 0; i < limit; i++) {
                Document doc = new Document("username", "user" + i)
                        .append("product", "Product" + i);
                collection.insertOne(doc);
            }
            long endWrite = System.nanoTime();
            System.out.println("Total write time with MongoDB: " + (endWrite - startWrite) / 1000000 + " ms");

            // read test
            long startRead = System.nanoTime();
            for (int i = 0; i < limit; i++) {
                collection.find(Filters.eq("username", "user" + i)).first();
            }
            long endRead = System.nanoTime();
            System.out.println("Total read time with MongoDB: " + (endRead - startRead) / 1000000 + " ms");
        }
    }
}
