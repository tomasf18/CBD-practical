package ex5.lab1.cbd;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import redis.clients.jedis.Jedis; 

/**
 * Hello world!
 *
 */
public class ServiceSystem {
    public static void main(String[] args) {

        Jedis jedis = new Jedis();

        // data structure where i can find the info -  username: product, timestamp
        Map<String, ArrayList<UserProduct>> users = new HashMap<String, ArrayList<UserProduct>>();

        Scanner sc = new Scanner(System.in);
        
        String username;
        String product;
        
        int limit = 5;      // 5 different products
        int timeslot = 30;  // per 30 seconds
        
        while (true) {
            System.out.println("Press ENTER to exit.");
    
            System.out.print("username: ");
            username = sc.nextLine();

            if (username.equals(""))
                break;

            if (users.containsKey(username)) {
                ArrayList<UserProduct> user_requests = users.get(username);
                if (user_requests.size() == limit) {
                    UserProduct obj = user_requests.get(0);
                    LocalDateTime request_timestamp = obj.getTimestamp();
                    LocalDateTime now = LocalDateTime.now();

                    // Calculate the time difference between now and the timestamp
                    Duration duration = Duration.between(request_timestamp, now);
                    long secondsPassed = duration.getSeconds();

                    if (secondsPassed > timeslot) { 
                        user_requests.remove(0);
                    } else { // If not, then none of the remaining products were requested >30s ago (index 0 was the first one)
                        System.out.format("Username '%s' already reached the requests limit (%d/%ds).\n", username, limit, timeslot);
                        continue;
                    }
                    
                }
            } else {
                users.put(username, new ArrayList<UserProduct>());
            }


            System.out.print("product: ");

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

    public UserProduct(String user, LocalDateTime tsp) {
        productName = user;
        timestamp = tsp;
    }

    public String getProductName() {
        return productName;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }
}
