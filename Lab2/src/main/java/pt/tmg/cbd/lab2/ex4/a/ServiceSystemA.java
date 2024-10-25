package pt.tmg.cbd.lab2.ex4.a;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

import java.time.Duration;
import org.bson.Document;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;
import java.util.Arrays;

public class ServiceSystemA {
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // format for MongoDB

    public static void main(String[] args) {

        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> usersCollection = database.getCollection("service_system");

        usersCollection.drop();  

        Scanner sc = new Scanner(System.in);

        String username;
        String product;

        int limit = 5;     // 5 products
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

                // retrieve the 5th most recent product's timestamp
                Document fifthRecentProductDoc = usersCollection.aggregate(Arrays.asList(
                    Aggregates.match(Filters.eq("username", username)),
                    Aggregates.project(new Document("recentProducts", new Document("$objectToArray", "$products"))),  // convert to array
                    Aggregates.unwind("$recentProducts"),  // make each array element a document and name it 'recentProducts'
                    Aggregates.sort(new Document("recentProducts.v", -1)),  // sort in descending order by timestamp
                    Aggregates.skip(limit - 1),  // skip the first 4 products
                    Aggregates.limit(1),  // limit to the 5th most recent product
                    Aggregates.project(new Document("timestamp", "$recentProducts.v"))  // get the timestamp
                )).first();

                if (fifthRecentProductDoc != null) {
                    // it exists, check if it was within the last 30 seconds
                    String fifthProductTimestampStr = fifthRecentProductDoc.getString("timestamp");
                    LocalDateTime fifthProductTimestamp = LocalDateTime.parse(fifthProductTimestampStr, formatter);
                    Duration durationSinceFifth = Duration.between(fifthProductTimestamp, now);
                    
                    if (durationSinceFifth.getSeconds() <= timeslot) {
                        System.out.printf("Username '%s' already reached the requests limit (%d/%d seconds).\n", username, limit, timeslot);
                        continue;
                    }
                    
                }

          
                System.out.print("[" + LocalDateTime.now().format(formatter) + "] product: ");
                product = sc.nextLine();

                // add new product and its timestamp
                usersCollection.updateOne(
                    Filters.eq("username", username),
                    Updates.set("products." + product, LocalDateTime.now().format(formatter))
                );

            } else {
                // create new document for user if 'username' does not exist
                System.out.print("[" + LocalDateTime.now().format(formatter) + "] product: ");
                product = sc.nextLine();

                Document newUserDoc = new Document("username", username)
                        .append("products", new Document(product, LocalDateTime.now().format(formatter)));

                usersCollection.insertOne(newUserDoc);
            }
        }

        mongoClient.close();
        sc.close();
    }
}
