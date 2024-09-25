package ex5.lab1.cbd;

import java.util.Scanner;
import java.util.Set;
import redis.clients.jedis.Jedis; 

/**
 * Hello world!
 *
 */
public class ServiceFault {
    public static void main(String[] args) {

        Jedis jedis = new Jedis();

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

            Set<String> products = jedis.smembers(username);

            if (products.size() >= limit) {
                System.out.format("Username '%s' already reached the requests limit (%d/%ds).\n", username, limit, timeslot);
                continue;
            }

            System.out.print("product: ");
            product = sc.nextLine();

            jedis.sadd(username, product);

            jedis.expire(username, timeslot);
        }

        jedis.close();
        sc.close();
    }
}
