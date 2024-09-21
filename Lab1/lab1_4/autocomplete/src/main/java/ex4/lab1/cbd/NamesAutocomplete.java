package ex4.lab1.cbd;

import redis.clients.jedis.Jedis; 
import java.io.File;
import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Set;

public class NamesAutocomplete {
    public static void main( String[] args ) {
        Jedis jedis = new Jedis();
        Set<String> results;
        
        // get file stream so I can read the file
        try (InputStream inputStream = NamesAutocomplete.class.getResourceAsStream("/names.txt");
                Scanner fileScanner = new Scanner(inputStream)) {

            while (fileScanner.hasNextLine()) {
                jedis.set(fileScanner.nextLine(), "1");
            }

        } catch (IOException e) {
            System.out.println("File error - 'names.txt': " + e.getMessage());
            return; 
        }


        Scanner sc = new Scanner(System.in);
        System.out.print( "Search for (Enter for quit): " );
        String input = sc.nextLine();

        /* 
            Slides: "CBD_05_KeyValue" 
            Slide 30: "KEYS pattern" - "finds all the keys matching a pattern"    
        */

        
        while (!input.isEmpty()) {
            String pattern = input + "*";

            System.out.println("Results:");
            results = jedis.keys(pattern);
            results.stream().sorted().forEach(System.out::println);
            System.out.print("\n\nSearch for (Enter for quit): ");
            input = sc.nextLine();
        }

    }
}
