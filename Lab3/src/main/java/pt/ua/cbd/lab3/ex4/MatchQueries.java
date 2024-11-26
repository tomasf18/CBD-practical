package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;

import java.util.List;
import java.util.Set;
import java.time.LocalDate;

public class MatchQueries {
    private final CqlSession session;

    public MatchQueries(CqlSession session) {
        this.session = session;
    }

    
    public void addMatchEvent(String homeTeam, String awayTeam, String date, List<String> event) {
        LocalDate matchDate = LocalDate.parse(date); // Convert date string to LocalDate
        String query = "UPDATE matches SET events = events + ? WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, event, homeTeam, awayTeam, matchDate);
    }
    
    public void removeMatchEvent(String homeTeam, String awayTeam, String date, List<String> event) {
        LocalDate matchDate = LocalDate.parse(date); // Convert date string to LocalDate
        String query = "UPDATE matches SET events = events - ? WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, event, homeTeam, awayTeam, matchDate);
    }
    
    public void addMultipleEventsToMatch(String homeTeam, String awayTeam, String date, Set<String> events) {
        LocalDate matchDate = LocalDate.parse(date); // Convert date string to LocalDate
        String query = "UPDATE matches SET events = events + ? WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, events, homeTeam, awayTeam, matchDate);
    }
    
    public void clearMatchEvents(String homeTeam, String awayTeam, String date) {
        LocalDate matchDate = LocalDate.parse(date); // Convert date string to LocalDate
        String query = "DELETE events FROM matches WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, homeTeam, awayTeam, matchDate);
    }
    

    // Get the last 3 matches between 2 teams
    public void getLast3Matches(String team1, String team2) {
        String query = "SELECT * FROM matches WHERE home_team_name = ? AND away_team_name = ? ORDER BY date DESC LIMIT 3";
        session.execute(query, team1, team2);
    }

    // Get the number of goals scored by the home team in the historical matches between 2 teams
    public void getHomeTeamGoalsHistory(String homeTeam, String awayTeam) {
        String query = "SELECT home_team_name, away_team_name, date, SUM(goals_home) FROM matches WHERE home_team_name = ? AND away_team_name = ? GROUP BY home_team_name, away_team_name";
        session.execute(query, homeTeam, awayTeam);
    }
}
