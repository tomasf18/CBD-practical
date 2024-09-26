package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;
import redis.clients.jedis.Jedis;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class ServiceSystemQuantity {
    private static final Logger logger = LogManager.getLogger(ServiceSystem.class);
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public static void main(String[] args) {
        Jedis jedis = new Jedis();
        jedis.flushAll();  // Clear the database to avoid key errors

        Scanner sc = new Scanner(System.in);
        String username;
        String product;
        int quantity;

        int limit = 30;     // Max 30 units of products
        int timeslot = 30;  // Time window in seconds

        while (true) {
            logger.info("Press ENTER to exit.");
            logger.info("username: ");
            username = sc.nextLine();

            if (username.equals(""))
                break;

            logger.info("product: ");
            product = sc.nextLine();
            logger.info("quantity: ");
            quantity = Integer.parseInt(sc.nextLine());

            // Check the total quantity of products requested in the last 'timeslot' seconds
            String key = username + ":timestamps";
            long totalQuantity = calculateCurrentQuantity(jedis, key, timeslot);

            // Check if adding the new request exceeds the limit
            if (totalQuantity + quantity > limit) {
                logger.warn("Username '{}' has reached the product quantity limit ({} units / {} seconds).", username, limit, timeslot);
                continue;
            }

            // Store the new product request and its quantity in Redis
            addProductRequest(jedis, username, product, quantity);

            logger.info("Added {} units of {} for user '{}'.", quantity, product, username);
        }

        jedis.close();
        sc.close();
    }

    // Function to calculate the current quantity within the time window
    private static long calculateCurrentQuantity(Jedis jedis, String key, int timeslot) {
        LocalDateTime now = LocalDateTime.now();
        long totalQuantity = 0;

        // Get the list of timestamps and quantities
        int size = Math.toIntExact(jedis.llen(key));
        for (int i = 0; i < size; i++) {
            String[] requestInfo = jedis.lindex(key, i).split(":");
            LocalDateTime requestTime = LocalDateTime.parse(requestInfo[0], DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            int requestQuantity = Integer.parseInt(requestInfo[1]);

            Duration duration = Duration.between(requestTime, now);
            if (duration.getSeconds() <= timeslot) {
                totalQuantity += requestQuantity;
            } else {
                // Remove old timestamps that are outside the timeslot window
                jedis.ltrim(key, i + 1, -1);
                break;
            }
        }
        return totalQuantity;
    }

    // Function to add a product request and store the timestamp and quantity
    private static void addProductRequest(Jedis jedis, String username, String product, int quantity) {
        // Add the product to the user's list of products with its quantity
        jedis.hincrBy(username, product, quantity);

        // Store the request timestamp and quantity in the list
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        jedis.rpush(username + ":timestamps", timestamp + ":" + quantity);
    }
}
