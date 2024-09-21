package ex3a.lab1.cbd;

import redis.clients.jedis.Jedis; 
  
public class SimplePost { 
    public static String USERS_KEY = "users"; // Key set (definida para) for users' name -> this means that the users' names are stored in the key "users" 
  
    public static void main(String[] args) { 
        Jedis jedis = new Jedis(); 
        // some users 
        String[] users = { "Ana", "Pedro", "Maria", "Luis" }; 
        jedis.del(USERS_KEY); // remove if exists to avoid wrong type 
        for (String user : users)  
            jedis.sadd(USERS_KEY, user); 

        jedis.smembers(USERS_KEY).forEach(System.out::println); 
        jedis.close(); 
    } 
}
