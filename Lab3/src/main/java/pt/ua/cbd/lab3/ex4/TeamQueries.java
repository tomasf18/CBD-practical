package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;

import java.util.List;
import java.util.Set;

public class TeamQueries {
    private final CqlSession session;

    public TeamQueries(CqlSession session) {
        this.session = session;
    }

    // Update 2: Add multiple players to a team
    public void addMultiplePlayersToTeam(String teamName, Set<Integer> playerIds) {
        String query = "UPDATE teams SET players = players + ? WHERE name = ?";
        session.execute(query, playerIds, teamName);
    }

    // Update 3: Add an achievement to a team
    public void addAchievement(String teamName, List<String> achievement) {
        String query = "UPDATE teams SET achievements = achievements + ? WHERE name = ?";
        session.execute(query, achievement, teamName);
    }

    // Update 4: Remove players from a team
    public void removePlayersFromTeam(String teamName, Set<Integer> playerIds) {
        String query = "UPDATE teams SET players = players - ? WHERE name = ?";
        session.execute(query, playerIds, teamName);
    }

    // Update 5: Remove a specific achievement from a team
    public void removeAchievement(String teamName, List<String> achievement) {
        String query = "UPDATE teams SET achievements = achievements - ? WHERE name = ?";
        session.execute(query, achievement, teamName);
    }

    // Delete 3: Clear all players from a team
    public void clearTeamPlayers(String teamName) {
        String query = "DELETE players FROM teams WHERE name = ?";
        session.execute(query, teamName);
    }

    // Team with the stadium
    public void getTeamsByStadium(String stadium) {
        String query = "SELECT name, players, achievements FROM teams WHERE stadium = ?";
        session.execute(query, stadium);
    }

    // Average number of players per team (float number)
    public void getAverageNumberOfPlayersPerTeam() {
        String query = "SELECT avg_players_per_team(players) AS avg_players FROM teams";
        System.out.println("Query: " + query);
        session.execute(query);
    }

    // Number of players per team
    public void getNumberOfPlayersPerTeam(String teamName) {
        String query = "SELECT count_players(players) AS number_of_players FROM teams where name = ?";
        session.execute(query, teamName);
    }
}
