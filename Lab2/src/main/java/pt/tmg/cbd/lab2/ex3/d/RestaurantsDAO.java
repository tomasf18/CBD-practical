package pt.tmg.cbd.lab2.ex3.d;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import org.bson.Document;

import java.util.*;
import java.util.stream.Collectors;

public class RestaurantsDAO {
    private final MongoCollection<Document> mongoCollection;

    public static void main(String[] args) {
        // connect to mongo server
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd"); // Nome da base de dados
        MongoCollection<Document> collection = database.getCollection("restaurants"); // Nome da coleção

        RestaurantsDAO dao = new RestaurantsDAO(collection);

        int totalLocalidades = dao.countLocalidades();
        System.out.println("Total de localidades distintas: " + totalLocalidades);

        Map<String, Integer> restByLocalidade = dao.countRestByLocalidade();
        System.out.println("Número de restaurantes por localidade:");
        restByLocalidade.forEach((localidade, count) -> {
            System.out.println(localidade + ": " + count);
        });

        List<String> similarRestaurants = dao.getRestWithNameCloserTo("Park");
        System.out.println("Restaurantes cujo nome contém 'Park':");
        similarRestaurants.forEach(System.out::println);

        mongoClient.close();
    }

    public RestaurantsDAO(MongoCollection<Document> mongoCollection) {
        this.mongoCollection = mongoCollection;
    }

    // distinct localities
    public int countLocalidades() {
        return (int) mongoCollection.distinct("localidade", String.class).into(new ArrayList<>()).size();
    }

    // num of rest per loc
    public Map<String, Integer> countRestByLocalidade() {
        List<Document> results = mongoCollection.aggregate(Arrays.asList(
            Aggregates.group("$localidade", Accumulators.sum("count", 1))
        )).into(new ArrayList<>());

        // convert to Map<String, Integer>
        Map<String, Integer> countByLocalidade = new LinkedHashMap<>();
        for (Document doc : results) {
            countByLocalidade.put(doc.getString("_id"), doc.getInteger("count"));
        }

        return countByLocalidade;
    }

    // restaurants which name contains "name"
    public List<String> getRestWithNameCloserTo(String name) {
        return mongoCollection.find(Filters.regex("nome", name, "i"))
            .projection(Projections.include("nome"))
            .into(new ArrayList<>())
            .stream()
            .map(doc -> doc.getString("nome"))
            .collect(Collectors.toList());
    }
}
