package pt.tmg.cbd.lab2.ex3.a;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.util.Arrays;

public class CollectionOps {

    public static void main(String[] args) {
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");

        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        System.out.println("Database: " + database.getName());
        System.out.println("Collection: " + collection.getNamespace().getCollectionName());

        Document doc = new Document("nome", "Restaurante")
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

        System.out.printf("\nA inserir documento: {%s} \n", doc.toJson());
        collection.insertOne(doc);

        System.out.println("\nRestaurante inserido\n");

        collection.updateOne(
            Filters.eq("nome", "Restaurante"),
            Updates.set("nome", "Updated Restaurant")
        );

        System.out.println("\nRestaurante atualizado\n");


        MongoCursor<Document> cursor = collection.find(Filters.eq("localidade", "Aveiro")).iterator();
        
        System.out.println("\nRestaurantes em Aveiro:");
        try {
            while (cursor.hasNext()) {
                Document result = cursor.next();
                System.out.println(result.toJson());
            }
        } finally {
            cursor.close();
        }

        collection.deleteOne(Filters.eq("nome", "Updated Restaurant"));
        System.out.println("\nRestaurante eliminado\n");

        mongoClient.close();
    }
}
