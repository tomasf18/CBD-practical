package pt.tmg.cbd.lab2.ex3.c;

import com.mongodb.client.*;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Sorts;

import org.bson.Document;
import java.util.Arrays;

import com.mongodb.client.model.*;


public class MongoQueries {

    public static void main(String[] args) {
        // connect to mongo server
        MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase database = mongoClient.getDatabase("cbd");
        MongoCollection<Document> collection = database.getCollection("restaurants");

        // 1 -> 4: Indique o total de restaurantes localizados no Bronx.
        long totalBronx = collection.countDocuments(Filters.eq("localidade", "Bronx"));
        System.out.println("Total de restaurantes no Bronx: " + totalBronx);

        // 2 -> 10: Liste o restaurant_id, o nome, a localidade e gastronomia dos restaurantes cujo nome começam por "Wil".
        System.out.println("Query 10 - Restaurantes cujo nome começa com 'Wil':");
        FindIterable<Document> wilRestaurants = collection.find(
            Filters.regex("nome", "^Wil")
        ).projection(Projections.fields(
            Projections.include("restaurant_id", "nome", "localidade", "gastronomia"),
            Projections.excludeId()));

        for (Document doc : wilRestaurants) {
            System.out.println(doc.toJson());
        }

        // 3 -> 17: Liste nome, gastronomia e localidade de todos os restaurantes ordenando por ordem crescente da gastronomia 
        //          e, em segundo, por ordem decrescente de localidade.
        System.out.println("\nQuery 17 - Restaurantes ordenados por gastronomia e localidade:");
        FindIterable<Document> sortedRestaurants = collection.find()
            .projection(Projections.fields(
                Projections.include("nome", "gastronomia", "localidade"),
                Projections.excludeId()))
            .sort(Sorts.orderBy(Sorts.ascending("gastronomia"), Sorts.descending("localidade")));

        // for (Document doc : sortedRestaurants) {
        //     System.out.println(doc.toJson());
        // }

        // 4 -> 20: Apresente o nome e número de avaliações (numGrades) dos 3 restaurantes com mais avaliações.
        System.out.println("\nQuery 20 - Os 3 restaurantes com mais avaliações:");
        AggregateIterable<Document> top3Restaurants = collection.aggregate(Arrays.asList(
            Aggregates.project(Projections.fields(
                Projections.include("nome"),
                Projections.computed("numGrades", new Document("$size", "$grades")))),
            Aggregates.sort(Sorts.descending("numGrades")),
            Aggregates.limit(3)
        ));

        for (Document doc : top3Restaurants) {
            System.out.println(doc.toJson());
        }

        // 5 -> 23: Indique os restaurantes que têm gastronomia "Portuguese", o somatório de score é superior a 50 e estão numa 
        //          latitude inferior a -60.
        System.out.println("\nQuery 23 - Restaurantes 'Portuguese' com somatório de score > 50 e latitude < -60:");
        AggregateIterable<Document> portugueseRestaurants = collection.aggregate(Arrays.asList(
            Aggregates.match(Filters.and(
                Filters.eq("gastronomia", "Portuguese"),
                Filters.lt("address.coord.0", -60))),
            Aggregates.project(Projections.fields(
                Projections.include("nome", "gastronomia", "address.coord"),
                Projections.computed("totalScore", new Document("$sum", "$grades.score")))),
            Aggregates.match(Filters.gt("totalScore", 50))
        ));

        for (Document doc : portugueseRestaurants) {
            System.out.println(doc.toJson());
        }

        mongoClient.close();
    }
}
