package pt.ua.cbd.lab3.ex4;

import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.ResultSet;

public class Main {
    public static void main(String[] args) {
        try (CqlSession session = CqlSession.builder().withKeyspace("football_keyspace").build()) {
            PlayerQueries playerQueries = new PlayerQueries(session);
            TeamQueries teamQueries = new TeamQueries(session);
            MatchQueries matchQueries = new MatchQueries(session);


        }
    }
}
