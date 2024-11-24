package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;

public class PlayerQueries {
    private final CqlSession session;

    public PlayerQueries(CqlSession session) {
        this.session = session;
    }

    // Update 1: Update a stat in the player's stats map
    public void updatePlayerStat(String name, int playerId, String statKey, int new_stat) {
        String query = "UPDATE players SET stats[?] = ? WHERE name = ? AND player_id = ?";
        session.execute(query, statKey, statKey, new_stat, name, playerId);
        String query2 = "UPDATE players_by_id SET stats[?] = ? WHERE player_id = ?";
        session.execute(query2, statKey, new_stat, playerId);
    }

    // Deletes 1 & 2: Remove a specific stat from the stats map
    public void deletePlayerStat(String name, int playerId, String statKey) {
        String query = "DELETE stats[?] FROM players WHERE name = ? AND player_id = ?";
        session.execute(query, statKey, name, playerId);
        String query2 = "DELETE stats[?] FROM players_by_id WHERE player_id = ?";
        session.execute(query2, statKey, playerId);
    }

    // Obter os 5 jogadores mais jovens de uma equipa
    public void getYoungestPlayersByTeam(String teamName) {
        String query = "SELECT name, age FROM players_by_team WHERE team_name = ? ORDER BY age ASC LIMIT 5";
        session.execute(query, teamName);
    }

    // Get players older than a certain age
    public void getPlayersOlderThanAge(String teamName, int age) {
        String query = "SELECT name, age FROM players_by_team WHERE team_name = ? AND age > ?";
        session.execute(query, teamName, age);
    }

    // Count the number of scored goals by a team
    public void getGoalsScoredByTeam(String teamName) {
        String query = "SELECT team_name, SUM(stats['goals']) FROM players_by_team WHERE team_name = ?";
        session.execute(query, teamName);
    }

    // Get the youngest player in a team
    public void getYoungestPlayerInTeam(String teamName) {
        String query = "SELECT name, MIN(age) FROM players_by_team WHERE team_name = ?";
        session.execute(query, teamName);
    }

    // Count the number of players in a team
    public void getPlayersCountByTeam(String teamName) {
        String query = "SELECT team_name, COUNT(*) FROM players_by_team WHERE team_name = ?";
        session.execute(query, teamName);
    }

    // Get all players with a certain position
    public void getPlayersByPosition(String position) {
        String query = "SELECT name, team_name, position FROM players WHERE position = ?";
        session.execute(query, position);
    }
}
