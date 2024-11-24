package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;
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
    public void addAchievement(String teamName, String achievement) {
        String query = "UPDATE teams SET achievements = achievements + [?] WHERE name = ?";
        session.execute(query, achievement, teamName);
    }

    // Update 4: Remove players from a team
    public void removePlayersFromTeam(String teamName, Set<Integer> playerIds) {
        String query = "UPDATE teams SET players = players - ? WHERE name = ?";
        session.execute(query, playerIds, teamName);
    }

    // Update 5: Remove a specific achievement from a team
    public void removeAchievement(String teamName, String achievement) {
        String query = "UPDATE teams SET achievements = achievements - [?] WHERE name = ?";
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
}
