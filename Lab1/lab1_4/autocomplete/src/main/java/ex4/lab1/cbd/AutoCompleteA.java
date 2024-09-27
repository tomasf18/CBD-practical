package ex4.lab1.cbd;

import redis.clients.jedis.Jedis; 
import java.util.Scanner;
import java.io.IOException;
import java.io.InputStream;

public class AutoCompleteA {
    public static void main( String[] args ) {
        Jedis jedis = new Jedis();
        
        // get file stream so I can read the file
        try (InputStream inputStream = AutoCompleteA.class.getResourceAsStream("/names.txt");
                Scanner fileScanner = new Scanner(inputStream)) {

            while (fileScanner.hasNextLine()) {
                jedis.zadd("names", 0, fileScanner.nextLine());
            }

        } catch (IOException e) {
            System.out.println("File error - 'names.txt': " + e.getMessage());
            jedis.close();
            return; 
        }


        Scanner sc = new Scanner(System.in);
        System.out.print( "Search for (Enter for quit): " );
        String input = sc.nextLine();

        
        while (!input.isEmpty()) {
            jedis.zrangeByLex("names",  "[" + input, "[" + input + "\uFFFF").forEach(System.out::println);

            System.out.print("\n\nSearch for (Enter for quit): ");
            input = sc.nextLine();
        }

        jedis.close();
        sc.close();

    }
}
