package pt.tmg.cbd.lab2.lab2_3.b;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.MongoCursor;
import org.bson.Document;
import java.util.Arrays;

public class IndexSearchTime {

    public static void main(String[] args) throws InterruptedException {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        System.out.println("Database: " + database.getName());
        System.out.println("Collection: " + collection.getNamespace().getCollectionName());

        Document doc = new Document("nome", "Restaurante1")
                .append("localidade", "Aveiro")
                .append("gastronomia", "American")
                .append("address", new Document("building", "71")
                    .append("coord", Arrays.asList(-70.8500, 34.2300))
                    .append("rua", "São Brás")
                    .append("zipcode", "12345"))
                .append("grades", Arrays.asList(
                    new Document("grade", "A").append("score", 13),
                    new Document("grade", "B").append("score", 15)
                ));

        System.out.printf("\nA inserir restaurante: {%s} \n", doc.toJson());
        collection.insertOne(doc);
        System.out.println("\nRestaurante inserido\n");

        long startTime = System.currentTimeMillis();
        
        collection.updateOne(
            Filters.eq("nome", "Restaurante1"),
            Updates.set("nome", "Restaurante2")
        );
        System.out.println("\nRestaurante atualizado\n");

        MongoCursor<Document> cursor = collection.find(Filters.eq("gastronomia", "Chicken")).iterator();
        System.out.println("\nRestaurantes em Aveiro:");

        try {
            while (cursor.hasNext()) {
                Document result = cursor.next();
                System.out.println(result.toJson());
            }
        } finally {
            cursor.close();
        }

        collection.deleteOne(Filters.eq("localidade", "Aveiro"));
        System.out.println("\nRestaurante eliminado\n");

        long endTime = System.currentTimeMillis();
        System.out.println("Tempo de execução sem índices: " + (endTime - startTime) + " ms");
        
        System.out.printf("\n========== Indexes ==========\n", doc.toJson());
        System.out.printf("\nA inserir restaurante: {%s} \n", doc.toJson());
        collection.insertOne(doc);
        System.out.println("\nRestaurante inserido\n");

        // indexes
        collection.createIndex(new Document("localidade", 1)); 
        collection.createIndex(new Document("gastronomia", 1)); 
        collection.createIndex(new Document("nome", "text"));  
        Thread.sleep(10000);

        startTime = System.currentTimeMillis();

        collection.updateOne(
            Filters.eq("nome", "Restaurante1"),
            Updates.set("nome", "Restaurante2")
        );
        System.out.println("\nRestaurante atualizado com índices\n");

        cursor = collection.find(Filters.eq("gastronomia", "Chicken")).iterator();
        System.out.println("\nRestaurantes em Aveiro com índices:");
        try {
            while (cursor.hasNext()) {
                Document result = cursor.next();
                System.out.println(result.toJson());
            }
        } finally {
            cursor.close();
        }

        collection.deleteOne(Filters.eq("localidade", "Aveiro"));
        System.out.println("\nRestaurante eliminado\n");

        endTime = System.currentTimeMillis();
        System.out.println("Tempo de execução com índices: " + (endTime - startTime) + " ms");

        // delete indexes


        mongoClient.close();
    }
}

