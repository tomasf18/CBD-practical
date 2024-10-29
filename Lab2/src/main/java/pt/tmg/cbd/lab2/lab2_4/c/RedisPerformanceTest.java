package pt.tmg.cbd.lab2.lab2_4.c;

import redis.clients.jedis.Jedis;

public class RedisPerformanceTest {
    private static Jedis jedis = new Jedis();

    public static void main(String[] args) {
        int limit = 1000; // num of operations
        
        // write test
        long startWrite = System.nanoTime();
        for (int i = 0; i < limit; i++) {
            jedis.hset("user:" + i, "product", "Product" + i);
        }
        long endWrite = System.nanoTime();
        System.out.println("Total write time with Redis: " + (endWrite - startWrite) / 1000000 + " ms");

        // read test
        long startRead = System.nanoTime();
        for (int i = 0; i < limit; i++) {
            jedis.hget("user:" + i, "product");
        }
        long endRead = System.nanoTime();
        System.out.println("Total read time with Redis: " + (endRead - startRead) / 1000000 + " ms");

        jedis.close();
    }
}
