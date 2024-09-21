package ex3a.lab1.cbd;

import redis.clients.jedis.Jedis; 
 
public class Forum { 
    public static void main(String[] args) { 
        // Ensure you have redis-server running 
        Jedis jedis = new Jedis(); 
        System.out.println("\n ---------------- \n jedis.ping(): \n" + jedis.ping()); 
        System.out.println("\n ---------------- \n jedis.info(): \n" + jedis.info()); 
        jedis.close(); 
    } 
} 

