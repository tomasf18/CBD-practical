package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import redis.clients.jedis.Jedis; 
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class ServiceSystem {
    private static final Logger logger = LogManager.getLogger(ServiceSystem.class);

    public static void main(String[] args) {

        Jedis jedis = new Jedis();
        jedis.flushAll();

        Map<String, ArrayList<UserProduct>> users = new HashMap<>();

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

            if (users.containsKey(username)) {
                ArrayList<UserProduct> user_requests = users.get(username);
                if (user_requests.size() == limit) {
                    UserProduct obj = user_requests.get(0);
                    LocalDateTime request_timestamp = obj.getTimestamp();
                    LocalDateTime now = LocalDateTime.now();

                    Duration duration = Duration.between(request_timestamp, now);
                    long seconds_passed = duration.getSeconds();

                    if (seconds_passed > timeslot) { 
                        user_requests.remove(0);
                    } else {
                        logger.warn("Username '{}' already reached the requests limit ({}/{}) seconds.", username, limit, timeslot);
                        continue;
                    }
                }
            } else {
                users.put(username, new ArrayList<UserProduct>());
            }

            logger.info("product: ");
            product = sc.nextLine();
            jedis.sadd(username, product);

            users.get(username).add(new UserProduct(product, LocalDateTime.now()));

        }

        jedis.close();
        sc.close();
    }
}

class UserProduct {
    private String productName;
    private LocalDateTime timestamp;

    public UserProduct(String product, LocalDateTime tsp) {
        productName = product;
        timestamp = tsp;
    }

    public String getProductName() {
        return productName;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }
}
