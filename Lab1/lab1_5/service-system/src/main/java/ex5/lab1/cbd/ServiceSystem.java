package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;
import redis.clients.jedis.Jedis; 
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class ServiceSystem {
    private static final Logger logger = LogManager.getLogger(ServiceSystem.class);
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME; // convert to string for redis

    public static void main(String[] args) {

        Jedis jedis = new Jedis();
        jedis.flushAll();  // clear the database to avoid key errors

        Scanner sc = new Scanner(System.in);
        
        String username;
        String product;
        
        int limit = 5;      // 5 different products
        int timeslot = 30;  // per 30 seconds
        
        while (true) {
            logger.info("Press ENTER to exit.");
            logger.info("username: ");
            username = sc.nextLine();

            if (username.equals(""))
                break;

            // check if the user has reached the limit of stored resquests per 30 seconds
            if (jedis.scard(username) >= limit) {
                String oldestProduct = jedis.lindex(username + ":timestamps", 0);
                LocalDateTime oldestRequestTime = LocalDateTime.parse(oldestProduct, formatter);
                LocalDateTime now = LocalDateTime.now();

                Duration duration = Duration.between(oldestRequestTime, now);
                long secondsPassed = duration.getSeconds();

                if (secondsPassed > timeslot) {
                    // remove the oldest product and timestamp if the secondsPassed already surprassed the timeslot
                    jedis.spop(username);
                    jedis.lpop(username + ":timestamps");
                } else {
                    logger.warn("Username '{}' already reached the requests limit ({}/{} seconds).", username, limit, timeslot);
                    continue;
                }
            }

            logger.info("product: ");
            product = sc.nextLine();

            // add the new pair (user, product) to Redis and set the current timestamp
            jedis.sadd(username, product);
            jedis.rpush(username + ":timestamps", LocalDateTime.now().format(formatter));

        }

        jedis.close();
        sc.close();
    }
}
