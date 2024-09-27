package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

import redis.clients.jedis.Jedis;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class ServiceSystemB {
    private static final Logger logger = LogManager.getLogger(ServiceSystemB.class);

    public static void main(String[] args) {
        Jedis jedis = new Jedis();
        jedis.flushAll();  // clear the database to avoid key errors

        Scanner sc = new Scanner(System.in);
        String username;
        String product;
        int quantity;

        int limit = 30;     // max 30 units of products
        int timeslot = 30;  // per timeslot of 30 seconds

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

            String key = username + ":timestamps";  // key of the list to the user timestamps

            // check the total quantity of products requested in the last 'timeslot' seconds
            long totalQuantity = calculateCurrentQuantity(jedis, key, timeslot);

            // check if adding the quantity of the new request exceeds the limit
            if (totalQuantity + quantity > limit) {
                logger.warn("ERROR: That product quantity surprasses the product quantity limit ({} units / {} seconds) for username '{}'.",  limit, timeslot, username);
                continue;
            }

            // store the new product request and its quantity in redis
            addProductRequest(jedis, username, product, quantity);

            logger.info("Added {} units of product '{}' for user '{}'.", quantity, product, username);
        }

        jedis.close();
        sc.close();
    }

    // calculate the current quantity in the last 'timeslot' seconds
    private static long calculateCurrentQuantity(Jedis jedis, String key, int timeslot) {
        LocalDateTime now = LocalDateTime.now();
        long totalQuantity = 0;

        // get the list of timestamps and quantities
        int size = (int) jedis.llen(key);
        for (int i = 0; i < size; i++) {
            String entry = jedis.lindex(key, i); // e.g.: 2024-09-26T17:40:45.296858263:3
            int last_colon_index = entry.lastIndexOf(':');

            // separate timestamp and quantity (the form of the entry is -> timestamp:quantity)
            String timestampPart = entry.substring(0, last_colon_index);
            String quantityPart = entry.substring(last_colon_index + 1);

            LocalDateTime requestTime;
            int requestQuantity;

            try {
                requestTime = LocalDateTime.parse(timestampPart, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                requestQuantity = Integer.parseInt(quantityPart);
            } catch (Exception e) {
                logger.warn("Failed to parse entry '{}'. Skipping this entry.", entry, e);
                continue;
            }

            Duration duration = Duration.between(requestTime, now);
            if (duration.getSeconds() <= timeslot) {
                totalQuantity += requestQuantity;
            } else {
                // remove old timestamps that are outside the timeslot window (those don't matter for the count)
                jedis.ltrim(key, i + 1, -1);
                break;
            }
        }
        return totalQuantity;
    }

    // add a product request and store its data in redis
    private static void addProductRequest(Jedis jedis, String username, String product, int quantity) {
        // increment the product to the user's list of products with its quantity
        jedis.hincrBy(username, product, quantity); // "If key does not exist, a new key holding a hash is created"

        
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        jedis.rpush(username + ":timestamps", timestamp + ":" + quantity);
    }
}
