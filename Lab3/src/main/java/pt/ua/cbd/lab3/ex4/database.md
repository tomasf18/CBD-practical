## Exemplo: Futebol (gestão de equipas, jogadores e jogos)

```sql
-- Drop the keyspace if it exists to avoid conflicts ---
DROP KEYSPACE IF EXISTS football_keyspace;

-- Keyspace ---
CREATE KEYSPACE football_keyspace
WITH replication = {{'class': 'SimpleStrategy', 'replication_factor': 1}};

USE football_keyspace;

-- Tables ---
CREATE TABLE teams (
    name                TEXT,
    city                TEXT,
    stadium             TEXT,
    players             SET<INT>,
    league_country      TEXT,
    achievements        LIST<TEXT>,
    PRIMARY KEY (name)
);

CREATE TABLE teams_by_league (
    league_country      TEXT,
    name                TEXT,
    city                TEXT,
    stadium             TEXT,
    players             SET<INT>,
    achievements        LIST<TEXT>,
    PRIMARY KEY ((league_country), name)
);

CREATE TABLE players (
    name                TEXT,
    player_id           INT,
    team_name           TEXT,
    position            TEXT,
    age                 INT,
    stats               MAP<TEXT, INT>,
    PRIMARY KEY ((name), player_id)
);

CREATE TABLE players_by_team (
    team_name           TEXT,
    player_id           INT,
    name                TEXT,
    position            TEXT,
    age                 INT,
    stats               MAP<TEXT, INT>,
    PRIMARY KEY ((team_name), age, player_id)
);


CREATE TABLE players_by_id (
    player_id           INT,
    name                TEXT,
    team_name           TEXT,
    position            TEXT,
    age                 INT,
    stats               MAP<TEXT, INT>,
    PRIMARY KEY ((player_id))
);

CREATE TABLE matches (
    home_team_name      TEXT,
    away_team_name      TEXT,
    date                DATE,
    match_id            INT,
    goals_home          INT,
    goals_away          INT,
    events              LIST<TEXT>,
    PRIMARY KEY ((home_team_name, away_team_name), date)
);

CREATE TABLE leagues (
    country TEXT,
    name TEXT,
    teams SET<TEXT>,
    PRIMARY KEY ((country)) -- Unique league in a country (only care about 1st division leagues)
);


--- Indexes ---
CREATE INDEX ON players (position);
CREATE INDEX ON teams (stadium);


--- UDA ---
CREATE FUNCTION IF NOT EXISTS football_keyspace.compute_avg_players(
    state frozen<tuple<int, int>>
)
CALLED ON NULL INPUT
RETURNS double
LANGUAGE java
AS $$
    int totalPlayers = state.get(0, Integer.class);
    int totalTeams = state.get(1, Integer.class);
    return totalTeams == 0 ? 0.0 : (double) totalPlayers / totalTeams;
$$;

CREATE FUNCTION IF NOT EXISTS football_keyspace.update_avg_players(
    state frozen<tuple<int, int>>, 
    players set<int>
)
CALLED ON NULL INPUT
RETURNS frozen<tuple<int, int>>
LANGUAGE java
AS $$
    return state.set(0, state.get(0, Integer.class) + players.size(), Integer.class)
                .set(1, state.get(1, Integer.class) + 1, Integer.class);
$$;

CREATE AGGREGATE IF NOT EXISTS football_keyspace.avg_players_per_team(set<int>)
SFUNC update_avg_players
STYPE frozen<tuple<int, int>>
FINALFUNC compute_avg_players
INITCOND (0, 0);

-----

-- UDF --
CREATE FUNCTION IF NOT EXISTS football_keyspace.count_players(
    players set<int>
)
CALLED ON NULL INPUT
RETURNS int
LANGUAGE java
AS $$
    return players.size();
$$;

-----

-- Example usage of the UDA
SELECT avg_players_per_team(players) AS avg_players FROM teams
-- Example usage of the count_players function
SELECT name, count_players(players) AS number_of_players FROM teams WHERE name = 'Team 1';
-----
```