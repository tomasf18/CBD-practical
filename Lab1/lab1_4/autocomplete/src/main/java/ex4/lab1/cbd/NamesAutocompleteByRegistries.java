package ex4.lab1.cbd;

import redis.clients.jedis.Jedis;

import java.util.List;
import java.util.Scanner;
import java.io.IOException;
import java.io.InputStream;

public class NamesAutocompleteByRegistries {
    public static void main(String[] args) {
        Jedis jedis = new Jedis();
        jedis.flushAll(); // clear db to avoid confilts

        // get file stream so I can read the file
        try (InputStream inputStream = NamesAutocompleteByRegistries.class.getResourceAsStream("/nomes-pt-2021.csv");
             Scanner fileScanner = new Scanner(inputStream)) {

            String line;
            String[] parts;
            String name;
            int n_registries;

            while (fileScanner.hasNextLine()) {
                line = fileScanner.nextLine();
                parts = line.split(";");
                name = parts[0];
                n_registries = Integer.parseInt(parts[1]);

                // Store in two different sets (to not cause set confusion)

                // Store by score
                jedis.zadd("names_popularity", n_registries, name);

                // Store by lex (with score=0)
                jedis.zadd("names_lex", 0, name);
            }

        } catch (IOException e) {
            System.out.println("File error - 'nomes-pt-2021.csv': " + e.getMessage());
            jedis.close();
            return;
        }

        Scanner sc = new Scanner(System.in);
        System.out.print("Search for (Enter for quit): ");
        String input = sc.nextLine();

        while (!input.isEmpty()) {
            System.out.println("Results:");

            // clear previous set keys to avoid conflicts
            jedis.del("filterKey");
            jedis.del("intersectionKey");

            // filter by name prefix (input) and store in a third set "filter_key"
            List<String> matchingNames = jedis.zrangeByLex("names_lex", "[" + input, "[" + input + "\uFFFF");

            for (String name : matchingNames) {
                jedis.zadd("filterKey", 0, name); 
            }

            // then, intersect the filtered results with the names_popularity, so i can get the names sorted by the "names_popularity" order (by scorses)
            jedis.zinterstore("intersectionKey", new String[]{"filterKey", "names_popularity"});

            // retrieve the sorted results by score in descending order
            List<String> results = jedis.zrevrange("intersectionKey", 0, -1);

            // print the results
            results.forEach(name -> {
                double score = jedis.zscore("names_popularity", name);
                System.out.printf("%s - %d\n", name, (int) score);
            });

            System.out.print("\n\nSearch for (Enter for quit): ");
            input = sc.nextLine();
        }

        sc.close();
        jedis.close();
    }
}
