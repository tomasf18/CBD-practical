package pt.ua.cbd.lab3.ex4;

import java.util.List;
import java.util.Set;

import com.datastax.oss.driver.api.core.CqlSession;

public class Main {
    public static void main(String[] args) {
        try (CqlSession session = CqlSession.builder().withKeyspace("football_keyspace").build()) {
            PlayerQueries playerQueries = new PlayerQueries(session);
            TeamQueries teamQueries = new TeamQueries(session);
            MatchQueries matchQueries = new MatchQueries(session);
            LeagueQueries leagueQueries = new LeagueQueries(session);

            // Test PlayerQueries
            System.out.println("Updating Player 1 stats...");
            playerQueries.updatePlayerStat("Player 1", 1, "goals", 25);

            System.out.println("Deleting 'assists' stat from Player 2...");
            playerQueries.deletePlayerStat("Player 2", 2, "assists");

            System.out.println("Getting youngest players in Team 1:");
            playerQueries.getYoungestPlayersByTeam("Team 1");

            System.out.println("Getting players older than 30 in Team 2:");
            playerQueries.getPlayersOlderThanAge("Team 2", 30);

            System.out.println("Getting total goals scored by Team 1:");
            playerQueries.getGoalsScoredByTeam("Team 1");

            System.out.println("Getting youngest player in Team 3:");
            playerQueries.getYoungestPlayerInTeam("Team 3");

            System.out.println("Counting players in Team 4:");
            playerQueries.getPlayersCountByTeam("Team 4");

            System.out.println("Getting all players in position Forward:");
            playerQueries.getPlayersByPosition("Forward");

            // Test TeamQueries
            System.out.println("Adding multiple players to Team 5...");
            teamQueries.addMultiplePlayersToTeam("Team 5", Set.of(27, 82));

            System.out.println("Adding achievement to Team 6...");
            teamQueries.addAchievement("Team 6", List.of("Championship 2023"));

            System.out.println("Removing player 11 from Team 7...");
            teamQueries.removePlayersFromTeam("Team 7", Set.of(11));

            System.out.println("Removing achievement 'Championship 2024' from Team 8...");
            teamQueries.removeAchievement("Team 6", List.of("Championship 2024"));

            System.out.println("Clearing all players from Team 9...");
            teamQueries.clearTeamPlayers("Team 9");

            System.out.println("Getting teams by stadium 'Manchester Stadium':");
            teamQueries.getTeamsByStadium("Manchester Stadium");

            // System.out.println("Getting average number of players per team:");
            // teamQueries.getAverageNumberOfPlayersPerTeam();
            
            // cqlsh:football_keyspace> SELECT avg_players_per_team(players) AS avg_players FROM teams;

            // avg_players
            // -------------
            //         4.5

            System.out.println("Getting number of players in Team 10:");
            teamQueries.getNumberOfPlayersPerTeam("Team 10");

            // Test MatchQueries
            System.out.println("Adding match event 'Goal by Player 5' for match Team 7 vs Team 4 on 2022-11-15...");
            matchQueries.addMatchEvent("Team 7", "Team 4", "2022-11-15", List.of("Goal by Player 5"));
            
            System.out.println("Removing match event 'Yellow Card to Player 7' for match Team 7 vs Team 4 on 2022-11-15...");
            matchQueries.removeMatchEvent("Team 7", "Team 4", "2022-11-15", List.of("Yellow Card to Player 7"));
            
            System.out.println("Adding multiple events (Goal, Red Card) to match Team 13 vs Team 4 on 2023-12-08...");
            matchQueries.addMultipleEventsToMatch("Team 13", "Team 4", "2023-12-08", Set.of("Goal", "Red Card"));
            
            System.out.println("Clearing all events for match Team 8 vs Team 5 on 2023-06-17...");
            matchQueries.clearMatchEvents("Team 8", "Team 5", "2023-06-17");
            
            System.out.println("Getting last 3 matches between Team 7 and Team 1:");
            matchQueries.getLast3Matches("Team 7", "Team 1");
            
            System.out.println("Getting total goals scored by Team 7 as home team in history vs Team 1:");
            matchQueries.getHomeTeamGoalsHistory("Team 7", "Team 1");            

            // Test LeagueQueries
            System.out.println("Adding Team 6 to League 6 in Madrid...");
            leagueQueries.addTeamToLeague("Madrid", Set.of("Team 6"));
            
            System.out.println("Removing Team 7 from League 5 in Paris...");
            leagueQueries.removeTeamFromLeague("Paris", Set.of("Team 7"));
            
            System.out.println("Clearing all teams from League 6 in Madrid...");
            leagueQueries.clearLeagueTeams("Madrid");
            
            System.out.println("Getting number of teams in League 7 in Berlin:");
            leagueQueries.getTeamsCountByLeague("Berlin");
            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
