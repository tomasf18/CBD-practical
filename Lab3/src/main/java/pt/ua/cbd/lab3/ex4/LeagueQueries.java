package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;

public class LeagueQueries {
    private final CqlSession session;

    public LeagueQueries(CqlSession session) {
        this.session = session;
    }

    // Update 9: Add a team to the league
    public void addTeamToLeague(String country, String teamName) {
        String query = "UPDATE leagues SET teams = teams + {?} WHERE country = ?";
        session.execute(query, teamName, country);
    }

    // Update 10: Remove a team from the league
    public void removeTeamFromLeague(String country, String teamName) {
        String query = "UPDATE leagues SET teams = teams - {?} WHERE country = ?";
        session.execute(query, teamName, country);
    }

    // Delete 5: Clear all teams from a league
    public void clearLeagueTeams(String country) {
        String query = "DELETE teams FROM leagues WHERE country = ?";
        session.execute(query, country);
    }

    // Get the number of teams per league
    public void getTeamsCountByLeague(String leagueCountry) {
        String query = "SELECT league_country, COUNT(*) AS n_teams_by_league FROM teams_by_league WHERE league_country = ? GROUP BY league_country";
        session.execute(query, leagueCountry);
    }
}
