package pt.tmg.cbd.lab2.ex4.b;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

import org.bson.Document;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;
import java.util.Arrays;

public class ServiceSystemB {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // format for MongoDB

    public static void main(String[] args) {

        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> usersCollection = database.getCollection("service_system");

        usersCollection.drop();  

        Scanner sc = new Scanner(System.in);

        String username;
        String product;
        int quantity;

        int limit = 30;    // 30 units
        int timeslot = 30; // 30 seconds

        while (true) {
            System.out.println("[" + LocalDateTime.now().format(formatter) + "] Press ENTER to exit.");
            System.out.print("[" + LocalDateTime.now().format(formatter) + "] username: ");
            username = sc.nextLine();

            if (username.equals(""))
                break;

            // verify if user already exists
            Document userDoc = usersCollection.find(Filters.eq("username", username)).first();

            if (userDoc != null) {
                LocalDateTime now = LocalDateTime.now();
                String timeLimit = now.minusSeconds(timeslot).format(formatter); // time 30s ago

                // calculate the total quantity of products requested within the last 30 seconds
                Document recentProductsQuantitiesDoc = usersCollection.aggregate(Arrays.asList(
                    Aggregates.match(Filters.eq("username", username)),
                    Aggregates.project(new Document("recentProducts", new Document("$filter", new Document()
                        .append("input", new Document("$objectToArray", "$products"))  // convert to array "(key, value)"
                        .append("as", "product")  // name for each item in the array
                        .append("cond", new Document("$gte", Arrays.asList("$$product.v.timestamp", timeLimit)))  // filter by timestamp
                    ))),
                    Aggregates.project(new Document("totalQuantity", new Document("$sum", "$recentProducts.v.quantity"))) // sum the quantities
                    )).first();

                System.out.print("[" + LocalDateTime.now().format(formatter) + "] product: ");
                product = sc.nextLine();

                System.out.print("[" + LocalDateTime.now().format(formatter) + "] quantity: ");
                quantity = Integer.parseInt(sc.nextLine());
                    
                int totalQuantityRequested = recentProductsQuantitiesDoc != null ? recentProductsQuantitiesDoc.getInteger("totalQuantity", 0) + quantity : quantity;

                if (totalQuantityRequested > limit) {
                    System.out.printf("ERROR: That product quantity surprasses the product quantity limit (%s units / %s seconds) for username '%s'.\n",  limit, timeslot, username);
                    continue;
                }


                // Add new product, timestamp, and quantity
                Document productDoc = new Document("timestamp", LocalDateTime.now().format(formatter))
                                        .append("quantity", quantity);
                
                usersCollection.updateOne(
                    Filters.eq("username", username),
                    Updates.set("products." + product, productDoc)
                );

            } else {
                // If user does not exist, create a new document
                System.out.print("[" + LocalDateTime.now().format(formatter) + "] product: ");
                product = sc.nextLine();

                System.out.print("[" + LocalDateTime.now().format(formatter) + "] quantity: ");
                quantity = Integer.parseInt(sc.nextLine());

                Document newProductDoc = new Document("timestamp", LocalDateTime.now().format(formatter))
                                          .append("quantity", quantity);

                Document newUserDoc = new Document("username", username)
                        .append("products", new Document(product, newProductDoc));

                usersCollection.insertOne(newUserDoc);
            }
        }

        mongoClient.close();
        sc.close();
    }
}
