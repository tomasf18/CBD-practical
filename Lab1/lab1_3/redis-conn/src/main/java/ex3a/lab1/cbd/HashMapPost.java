package ex3a.lab1.cbd;

import redis.clients.jedis.Jedis; 
  
public class HashMapPost { 
    public static String USERS_KEY = "users"; // Key set (definida para) for users' name -> this means that the users' names are stored in the key "users" 
  
    public static void main(String[] args) { 
        Jedis jedis = new Jedis(); 
        // some users 
        String[] users = { "Ana", "Pedro", "Maria", "Luis" }; 
        jedis.del(USERS_KEY); // remove if exists to avoid wrong type 
        for (int i = 0; i < users.length; i++)  
            jedis.hset(USERS_KEY, users[i], String.valueOf(i));
            
        jedis.hgetAll(USERS_KEY).forEach((k, v) -> System.out.println(k + " -> " + v)); 
        jedis.close(); 
    } 
}
