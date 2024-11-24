package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;
import java.util.Set;

public class MatchQueries {
    private final CqlSession session;

    public MatchQueries(CqlSession session) {
        this.session = session;
    }

    // Update 6: Add an event to a match's event list
    public void addMatchEvent(String homeTeam, String awayTeam, String date, String event) {
        String query = "UPDATE matches SET events = events + [?] WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, event, homeTeam, awayTeam, date);
    }

    // Update 7: Remove a specific event from a match's event list
    public void removeMatchEvent(String homeTeam, String awayTeam, String date, String event) {
        String query = "UPDATE matches SET events = events - [?] WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, event, homeTeam, awayTeam, date);
    }

    // Update 8: Add multiple events to a match
    public void addMultipleEventsToMatch(String homeTeam, String awayTeam, String date, Set<String> events) {
        String query = "UPDATE matches SET events = events + ? WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, events, homeTeam, awayTeam, date);
    }

    // Delete 4: Clear all events from a match
    public void clearMatchEvents(String homeTeam, String awayTeam, String date) {
        String query = "DELETE events FROM matches WHERE home_team_name = ? AND away_team_name = ? AND date = ?";
        session.execute(query, homeTeam, awayTeam, date);
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
