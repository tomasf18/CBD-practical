package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.Iterator;
import redis.clients.jedis.Jedis; 
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

public class ServiceSystemQuantity {
    private static final Logger logger = LogManager.getLogger(ServiceSystemQuantity.class);

    public static void main(String[] args) {

        Jedis jedis = new Jedis();
        jedis.flushAll();

        Map<String, ArrayList<UserProductQuantity>> users = new HashMap<String, ArrayList<UserProductQuantity>>();
        Scanner sc = new Scanner(System.in);

        String username;
        String product;
        int quant;
        
        int limit = 30;     // 30 poducts quantity
        int timeslot = 30;  // per 30 seconds

        while (true) {
            logger.info("Press ENTER to exit.");
            
            logger.info("username: ");
            username = sc.nextLine();
            
            if (username.equals(""))
                break;
            
            logger.info("product: ");
            product = sc.nextLine();
            logger.info("Quantity: ");
            quant = Integer.parseInt(sc.nextLine());

            if (users.containsKey(username)) {
                ArrayList<UserProductQuantity> user_requests = users.get(username);
                int quantity_sum = 0;

                Iterator<UserProductQuantity> iterator = user_requests.iterator();
                while (iterator.hasNext()) {
                    UserProductQuantity prod_info = iterator.next();
                    LocalDateTime request_timestamp = prod_info.getTimestamp();
                    LocalDateTime now = LocalDateTime.now();
                    
                    Duration duration = Duration.between(request_timestamp, now);
                    long seconds_passed = duration.getSeconds();
                
                    if (seconds_passed > timeslot) {
                        iterator.remove();  
                    } else {
                        quantity_sum += prod_info.getQuantity();
                    }
                }

                if (quantity_sum + quant > limit) {
                    logger.warn("Username '{}' already reached the quantity limit ({} units / {} seconds).", username, limit, timeslot);
                    continue;
                }
                  
            } else {
                users.put(username, new ArrayList<UserProductQuantity>());
            }

            ArrayList<UserProductQuantity> user_requests = users.get(username);
            UserProductQuantity prod = null;
            for (UserProductQuantity prod_info : user_requests) {
                if (prod_info.getProductName().equals(product)) {
                    prod = prod_info;
                    prod.addQuantity(quant);
                    logger.info("Product {} - added {} units. Total: {}", prod.getProductName(), quant, prod.getQuantity());
                    break;  
                }
            }

            if (prod == null) {
                prod = new UserProductQuantity(product, quant, LocalDateTime.now());
                user_requests.add(prod);
                logger.info("Added new product: {} - {} units", prod.getProductName(), prod.getQuantity());
            }

            if (jedis.hget(username, product) == null) {
                jedis.hset(username, product, "0");
            }
            int previous_quantity = Integer.parseInt(jedis.hget(username, product));
            jedis.hset(username, product, String.valueOf(previous_quantity + quant));

            // logging help:
            // logger.info("Data stored in Redis for username '{}':", username);
            // Map<String, String> data = jedis.hgetAll(username);
            // data.forEach((key, value) -> logger.info("{} - {}", key, value));

            // logger.info("Data stored in the app for username '{}':", username);
            // for (UserProductQuantity prod_info : user_requests) {
            //     logger.info("Product name: {} | Quantity: {}", prod_info.getProductName(), prod_info.getQuantity());
            // }
        }

        jedis.close();
        sc.close();
    }
}



class UserProductQuantity {
    private String productName;
    private int quantity;
    private LocalDateTime timestamp;

    public UserProductQuantity(String product, int quant, LocalDateTime tsp) {
        productName = product;
        quantity = quant;
        timestamp = tsp;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void addQuantity(int quant) {
        quantity += quant; 
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }
}
