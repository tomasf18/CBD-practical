
-- Drop the keyspace if it exists to avoid conflicts ---
DROP KEYSPACE IF EXISTS football_keyspace;

-- Keyspace ---
CREATE KEYSPACE football_keyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

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
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 1', 'Lisbon', 'Lisbon Stadium', {64, 90, 11, 93}, 'Manchester', ['Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 1', 'Lisbon', 'Lisbon Stadium', {64, 90, 11, 93}, ['Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 2', 'London', 'London Stadium', {1, 46, 15}, 'Barcelona', ['Achievement 1', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Barcelona', 'Team 2', 'London', 'London Stadium', {1, 46, 15}, ['Achievement 1', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 3', 'Barcelona', 'Barcelona Stadium', {6, 71, 40, 72, 76, 93}, 'London', ['Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('London', 'Team 3', 'Barcelona', 'Barcelona Stadium', {6, 71, 40, 72, 76, 93}, ['Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 4', 'Amsterdam', 'Amsterdam Stadium', {64, 96, 66, 98, 38, 79}, 'Berlin', ['Achievement 3', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Berlin', 'Team 4', 'Amsterdam', 'Amsterdam Stadium', {64, 96, 66, 98, 38, 79}, ['Achievement 3', 'Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 5', 'Manchester', 'Manchester Stadium', {67, 28, 39}, 'Berlin', ['Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Berlin', 'Team 5', 'Manchester', 'Manchester Stadium', {67, 28, 39}, ['Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 6', 'Lisbon', 'Lisbon Stadium', {64, 75, 84, 91, 61}, 'Lisbon', ['Achievement 2', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 6', 'Lisbon', 'Lisbon Stadium', {64, 75, 84, 91, 61}, ['Achievement 2', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 7', 'Paris', 'Paris Stadium', {78, 51, 84, 28, 63, 95}, 'Paris', ['Achievement 2', 'Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 7', 'Paris', 'Paris Stadium', {78, 51, 84, 28, 63, 95}, ['Achievement 2', 'Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 8', 'Madrid', 'Madrid Stadium', {65, 28, 46, 79}, 'Manchester', ['Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 8', 'Madrid', 'Madrid Stadium', {65, 28, 46, 79}, ['Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 9', 'Barcelona', 'Barcelona Stadium', {57, 66, 2, 30}, 'Amsterdam', ['Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Amsterdam', 'Team 9', 'Barcelona', 'Barcelona Stadium', {57, 66, 2, 30}, ['Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 10', 'Paris', 'Paris Stadium', {8, 34, 11, 94}, 'Manchester', ['Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 10', 'Paris', 'Paris Stadium', {8, 34, 11, 94}, ['Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 11', 'Lisbon', 'Lisbon Stadium', {100, 40, 15, 87, 27}, 'Manchester', ['Achievement 5', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 11', 'Lisbon', 'Lisbon Stadium', {100, 40, 15, 87, 27}, ['Achievement 5', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 12', 'Paris', 'Paris Stadium', {56, 13, 22}, 'Milan', ['Achievement 1', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Milan', 'Team 12', 'Paris', 'Paris Stadium', {56, 13, 22}, ['Achievement 1', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 13', 'Rome', 'Rome Stadium', {98, 28, 20, 90}, 'Amsterdam', ['Achievement 4', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Amsterdam', 'Team 13', 'Rome', 'Rome Stadium', {98, 28, 20, 90}, ['Achievement 4', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 14', 'Paris', 'Paris Stadium', {29, 61, 21, 98}, 'Rome', ['Achievement 3', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 14', 'Paris', 'Paris Stadium', {29, 61, 21, 98}, ['Achievement 3', 'Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 15', 'Amsterdam', 'Amsterdam Stadium', {52, 86, 31}, 'Rome', ['Achievement 1', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 15', 'Amsterdam', 'Amsterdam Stadium', {52, 86, 31}, ['Achievement 1', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 16', 'Manchester', 'Manchester Stadium', {97, 100, 6, 40, 14, 63}, 'Rome', ['Achievement 4', 'Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 16', 'Manchester', 'Manchester Stadium', {97, 100, 6, 40, 14, 63}, ['Achievement 4', 'Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 17', 'Milan', 'Milan Stadium', {1, 3, 40, 8, 93}, 'Milan', ['Achievement 4', 'Achievement 3', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Milan', 'Team 17', 'Milan', 'Milan Stadium', {1, 3, 40, 8, 93}, ['Achievement 4', 'Achievement 3', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 18', 'Lisbon', 'Lisbon Stadium', {67, 46, 47, 49, 51}, 'Barcelona', ['Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Barcelona', 'Team 18', 'Lisbon', 'Lisbon Stadium', {67, 46, 47, 49, 51}, ['Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 19', 'Manchester', 'Manchester Stadium', {17, 60, 13}, 'Milan', ['Achievement 1', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Milan', 'Team 19', 'Manchester', 'Manchester Stadium', {17, 60, 13}, ['Achievement 1', 'Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 20', 'Madrid', 'Madrid Stadium', {72, 78, 24, 56, 91}, 'Paris', ['Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 20', 'Madrid', 'Madrid Stadium', {72, 78, 24, 56, 91}, ['Achievement 5']);
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 1', 1, 'Team 8', 'Forward', 21, {'goals': 7, 'assists': 45, 'appearances': 180});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (1, 'Player 1', 'Team 8', 'Forward', 21, {'goals': 7, 'assists': 45, 'appearances': 180});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 1, 'Player 1', 'Forward', 21, {'goals': 7, 'assists': 45, 'appearances': 180});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 2', 2, 'Team 5', 'Defender', 21, {'goals': 53, 'assists': 15, 'appearances': 200});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (2, 'Player 2', 'Team 5', 'Defender', 21, {'goals': 53, 'assists': 15, 'appearances': 200});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 2, 'Player 2', 'Defender', 21, {'goals': 53, 'assists': 15, 'appearances': 200});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 3', 3, 'Team 2', 'Midfielder', 35, {'goals': 3, 'assists': 42, 'appearances': 170});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (3, 'Player 3', 'Team 2', 'Midfielder', 35, {'goals': 3, 'assists': 42, 'appearances': 170});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 3, 'Player 3', 'Midfielder', 35, {'goals': 3, 'assists': 42, 'appearances': 170});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 4', 4, 'Team 17', 'Goalkeeper', 22, {'goals': 65, 'assists': 20, 'appearances': 170});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (4, 'Player 4', 'Team 17', 'Goalkeeper', 22, {'goals': 65, 'assists': 20, 'appearances': 170});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 4, 'Player 4', 'Goalkeeper', 22, {'goals': 65, 'assists': 20, 'appearances': 170});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 5', 5, 'Team 7', 'Goalkeeper', 33, {'goals': 75, 'assists': 0, 'appearances': 188});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (5, 'Player 5', 'Team 7', 'Goalkeeper', 33, {'goals': 75, 'assists': 0, 'appearances': 188});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 5, 'Player 5', 'Goalkeeper', 33, {'goals': 75, 'assists': 0, 'appearances': 188});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 6', 6, 'Team 17', 'Forward', 34, {'goals': 7, 'assists': 47, 'appearances': 56});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (6, 'Player 6', 'Team 17', 'Forward', 34, {'goals': 7, 'assists': 47, 'appearances': 56});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 6, 'Player 6', 'Forward', 34, {'goals': 7, 'assists': 47, 'appearances': 56});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 7', 7, 'Team 20', 'Forward', 18, {'goals': 33, 'assists': 36, 'appearances': 138});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (7, 'Player 7', 'Team 20', 'Forward', 18, {'goals': 33, 'assists': 36, 'appearances': 138});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 7, 'Player 7', 'Forward', 18, {'goals': 33, 'assists': 36, 'appearances': 138});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 8', 8, 'Team 11', 'Defender', 31, {'goals': 21, 'assists': 37, 'appearances': 48});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (8, 'Player 8', 'Team 11', 'Defender', 31, {'goals': 21, 'assists': 37, 'appearances': 48});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 8, 'Player 8', 'Defender', 31, {'goals': 21, 'assists': 37, 'appearances': 48});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 9', 9, 'Team 1', 'Forward', 28, {'goals': 16, 'assists': 24, 'appearances': 75});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (9, 'Player 9', 'Team 1', 'Forward', 28, {'goals': 16, 'assists': 24, 'appearances': 75});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 9, 'Player 9', 'Forward', 28, {'goals': 16, 'assists': 24, 'appearances': 75});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 10', 10, 'Team 15', 'Forward', 28, {'goals': 33, 'assists': 49, 'appearances': 194});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (10, 'Player 10', 'Team 15', 'Forward', 28, {'goals': 33, 'assists': 49, 'appearances': 194});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 10, 'Player 10', 'Forward', 28, {'goals': 33, 'assists': 49, 'appearances': 194});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 11', 11, 'Team 2', 'Goalkeeper', 23, {'goals': 95, 'assists': 30, 'appearances': 128});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (11, 'Player 11', 'Team 2', 'Goalkeeper', 23, {'goals': 95, 'assists': 30, 'appearances': 128});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 11, 'Player 11', 'Goalkeeper', 23, {'goals': 95, 'assists': 30, 'appearances': 128});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 12', 12, 'Team 14', 'Midfielder', 21, {'goals': 14, 'assists': 5, 'appearances': 12});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (12, 'Player 12', 'Team 14', 'Midfielder', 21, {'goals': 14, 'assists': 5, 'appearances': 12});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 12, 'Player 12', 'Midfielder', 21, {'goals': 14, 'assists': 5, 'appearances': 12});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 13', 13, 'Team 14', 'Goalkeeper', 24, {'goals': 31, 'assists': 5, 'appearances': 197});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (13, 'Player 13', 'Team 14', 'Goalkeeper', 24, {'goals': 31, 'assists': 5, 'appearances': 197});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 13, 'Player 13', 'Goalkeeper', 24, {'goals': 31, 'assists': 5, 'appearances': 197});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 14', 14, 'Team 17', 'Midfielder', 26, {'goals': 28, 'assists': 4, 'appearances': 55});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (14, 'Player 14', 'Team 17', 'Midfielder', 26, {'goals': 28, 'assists': 4, 'appearances': 55});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 14, 'Player 14', 'Midfielder', 26, {'goals': 28, 'assists': 4, 'appearances': 55});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 15', 15, 'Team 1', 'Midfielder', 19, {'goals': 81, 'assists': 45, 'appearances': 162});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (15, 'Player 15', 'Team 1', 'Midfielder', 19, {'goals': 81, 'assists': 45, 'appearances': 162});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 15, 'Player 15', 'Midfielder', 19, {'goals': 81, 'assists': 45, 'appearances': 162});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 16', 16, 'Team 16', 'Midfielder', 18, {'goals': 3, 'assists': 14, 'appearances': 113});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (16, 'Player 16', 'Team 16', 'Midfielder', 18, {'goals': 3, 'assists': 14, 'appearances': 113});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 16, 'Player 16', 'Midfielder', 18, {'goals': 3, 'assists': 14, 'appearances': 113});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 17', 17, 'Team 3', 'Forward', 29, {'goals': 97, 'assists': 16, 'appearances': 184});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (17, 'Player 17', 'Team 3', 'Forward', 29, {'goals': 97, 'assists': 16, 'appearances': 184});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 17, 'Player 17', 'Forward', 29, {'goals': 97, 'assists': 16, 'appearances': 184});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 18', 18, 'Team 20', 'Goalkeeper', 34, {'goals': 0, 'assists': 45, 'appearances': 115});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (18, 'Player 18', 'Team 20', 'Goalkeeper', 34, {'goals': 0, 'assists': 45, 'appearances': 115});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 18, 'Player 18', 'Goalkeeper', 34, {'goals': 0, 'assists': 45, 'appearances': 115});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 19', 19, 'Team 2', 'Goalkeeper', 27, {'goals': 72, 'assists': 19, 'appearances': 44});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (19, 'Player 19', 'Team 2', 'Goalkeeper', 27, {'goals': 72, 'assists': 19, 'appearances': 44});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 19, 'Player 19', 'Goalkeeper', 27, {'goals': 72, 'assists': 19, 'appearances': 44});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 20', 20, 'Team 14', 'Goalkeeper', 23, {'goals': 35, 'assists': 32, 'appearances': 150});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (20, 'Player 20', 'Team 14', 'Goalkeeper', 23, {'goals': 35, 'assists': 32, 'appearances': 150});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 20, 'Player 20', 'Goalkeeper', 23, {'goals': 35, 'assists': 32, 'appearances': 150});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 21', 21, 'Team 7', 'Midfielder', 19, {'goals': 84, 'assists': 41, 'appearances': 42});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (21, 'Player 21', 'Team 7', 'Midfielder', 19, {'goals': 84, 'assists': 41, 'appearances': 42});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 21, 'Player 21', 'Midfielder', 19, {'goals': 84, 'assists': 41, 'appearances': 42});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 22', 22, 'Team 18', 'Midfielder', 31, {'goals': 27, 'assists': 41, 'appearances': 134});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (22, 'Player 22', 'Team 18', 'Midfielder', 31, {'goals': 27, 'assists': 41, 'appearances': 134});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 22, 'Player 22', 'Midfielder', 31, {'goals': 27, 'assists': 41, 'appearances': 134});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 23', 23, 'Team 5', 'Defender', 29, {'goals': 35, 'assists': 27, 'appearances': 39});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (23, 'Player 23', 'Team 5', 'Defender', 29, {'goals': 35, 'assists': 27, 'appearances': 39});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 23, 'Player 23', 'Defender', 29, {'goals': 35, 'assists': 27, 'appearances': 39});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 24', 24, 'Team 1', 'Forward', 26, {'goals': 43, 'assists': 29, 'appearances': 112});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (24, 'Player 24', 'Team 1', 'Forward', 26, {'goals': 43, 'assists': 29, 'appearances': 112});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 24, 'Player 24', 'Forward', 26, {'goals': 43, 'assists': 29, 'appearances': 112});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 25', 25, 'Team 17', 'Defender', 20, {'goals': 64, 'assists': 46, 'appearances': 95});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (25, 'Player 25', 'Team 17', 'Defender', 20, {'goals': 64, 'assists': 46, 'appearances': 95});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 25, 'Player 25', 'Defender', 20, {'goals': 64, 'assists': 46, 'appearances': 95});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 26', 26, 'Team 11', 'Defender', 22, {'goals': 76, 'assists': 48, 'appearances': 166});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (26, 'Player 26', 'Team 11', 'Defender', 22, {'goals': 76, 'assists': 48, 'appearances': 166});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 26, 'Player 26', 'Defender', 22, {'goals': 76, 'assists': 48, 'appearances': 166});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 27', 27, 'Team 17', 'Forward', 26, {'goals': 81, 'assists': 45, 'appearances': 102});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (27, 'Player 27', 'Team 17', 'Forward', 26, {'goals': 81, 'assists': 45, 'appearances': 102});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 27, 'Player 27', 'Forward', 26, {'goals': 81, 'assists': 45, 'appearances': 102});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 28', 28, 'Team 18', 'Defender', 18, {'goals': 40, 'assists': 12, 'appearances': 172});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (28, 'Player 28', 'Team 18', 'Defender', 18, {'goals': 40, 'assists': 12, 'appearances': 172});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 28, 'Player 28', 'Defender', 18, {'goals': 40, 'assists': 12, 'appearances': 172});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 29', 29, 'Team 14', 'Midfielder', 35, {'goals': 44, 'assists': 22, 'appearances': 55});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (29, 'Player 29', 'Team 14', 'Midfielder', 35, {'goals': 44, 'assists': 22, 'appearances': 55});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 29, 'Player 29', 'Midfielder', 35, {'goals': 44, 'assists': 22, 'appearances': 55});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 30', 30, 'Team 12', 'Forward', 34, {'goals': 61, 'assists': 42, 'appearances': 52});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (30, 'Player 30', 'Team 12', 'Forward', 34, {'goals': 61, 'assists': 42, 'appearances': 52});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 30, 'Player 30', 'Forward', 34, {'goals': 61, 'assists': 42, 'appearances': 52});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 31', 31, 'Team 4', 'Forward', 19, {'goals': 40, 'assists': 20, 'appearances': 182});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (31, 'Player 31', 'Team 4', 'Forward', 19, {'goals': 40, 'assists': 20, 'appearances': 182});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 31, 'Player 31', 'Forward', 19, {'goals': 40, 'assists': 20, 'appearances': 182});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 32', 32, 'Team 16', 'Goalkeeper', 21, {'goals': 31, 'assists': 14, 'appearances': 18});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (32, 'Player 32', 'Team 16', 'Goalkeeper', 21, {'goals': 31, 'assists': 14, 'appearances': 18});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 32, 'Player 32', 'Goalkeeper', 21, {'goals': 31, 'assists': 14, 'appearances': 18});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 33', 33, 'Team 15', 'Defender', 29, {'goals': 78, 'assists': 9, 'appearances': 80});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (33, 'Player 33', 'Team 15', 'Defender', 29, {'goals': 78, 'assists': 9, 'appearances': 80});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 33, 'Player 33', 'Defender', 29, {'goals': 78, 'assists': 9, 'appearances': 80});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 34', 34, 'Team 7', 'Defender', 35, {'goals': 32, 'assists': 14, 'appearances': 178});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (34, 'Player 34', 'Team 7', 'Defender', 35, {'goals': 32, 'assists': 14, 'appearances': 178});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 34, 'Player 34', 'Defender', 35, {'goals': 32, 'assists': 14, 'appearances': 178});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 35', 35, 'Team 3', 'Goalkeeper', 33, {'goals': 91, 'assists': 34, 'appearances': 35});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (35, 'Player 35', 'Team 3', 'Goalkeeper', 33, {'goals': 91, 'assists': 34, 'appearances': 35});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 35, 'Player 35', 'Goalkeeper', 33, {'goals': 91, 'assists': 34, 'appearances': 35});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 36', 36, 'Team 14', 'Forward', 33, {'goals': 55, 'assists': 37, 'appearances': 36});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (36, 'Player 36', 'Team 14', 'Forward', 33, {'goals': 55, 'assists': 37, 'appearances': 36});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 36, 'Player 36', 'Forward', 33, {'goals': 55, 'assists': 37, 'appearances': 36});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 37', 37, 'Team 7', 'Goalkeeper', 35, {'goals': 84, 'assists': 48, 'appearances': 96});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (37, 'Player 37', 'Team 7', 'Goalkeeper', 35, {'goals': 84, 'assists': 48, 'appearances': 96});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 37, 'Player 37', 'Goalkeeper', 35, {'goals': 84, 'assists': 48, 'appearances': 96});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 38', 38, 'Team 5', 'Forward', 23, {'goals': 3, 'assists': 37, 'appearances': 17});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (38, 'Player 38', 'Team 5', 'Forward', 23, {'goals': 3, 'assists': 37, 'appearances': 17});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 38, 'Player 38', 'Forward', 23, {'goals': 3, 'assists': 37, 'appearances': 17});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 39', 39, 'Team 16', 'Forward', 26, {'goals': 63, 'assists': 39, 'appearances': 126});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (39, 'Player 39', 'Team 16', 'Forward', 26, {'goals': 63, 'assists': 39, 'appearances': 126});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 39, 'Player 39', 'Forward', 26, {'goals': 63, 'assists': 39, 'appearances': 126});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 40', 40, 'Team 19', 'Defender', 25, {'goals': 69, 'assists': 16, 'appearances': 118});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (40, 'Player 40', 'Team 19', 'Defender', 25, {'goals': 69, 'assists': 16, 'appearances': 118});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 40, 'Player 40', 'Defender', 25, {'goals': 69, 'assists': 16, 'appearances': 118});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 41', 41, 'Team 18', 'Defender', 31, {'goals': 57, 'assists': 3, 'appearances': 104});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (41, 'Player 41', 'Team 18', 'Defender', 31, {'goals': 57, 'assists': 3, 'appearances': 104});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 41, 'Player 41', 'Defender', 31, {'goals': 57, 'assists': 3, 'appearances': 104});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 42', 42, 'Team 19', 'Defender', 26, {'goals': 86, 'assists': 44, 'appearances': 108});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (42, 'Player 42', 'Team 19', 'Defender', 26, {'goals': 86, 'assists': 44, 'appearances': 108});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 42, 'Player 42', 'Defender', 26, {'goals': 86, 'assists': 44, 'appearances': 108});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 43', 43, 'Team 2', 'Defender', 32, {'goals': 94, 'assists': 44, 'appearances': 131});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (43, 'Player 43', 'Team 2', 'Defender', 32, {'goals': 94, 'assists': 44, 'appearances': 131});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 43, 'Player 43', 'Defender', 32, {'goals': 94, 'assists': 44, 'appearances': 131});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 44', 44, 'Team 2', 'Defender', 20, {'goals': 92, 'assists': 29, 'appearances': 24});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (44, 'Player 44', 'Team 2', 'Defender', 20, {'goals': 92, 'assists': 29, 'appearances': 24});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 44, 'Player 44', 'Defender', 20, {'goals': 92, 'assists': 29, 'appearances': 24});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 45', 45, 'Team 6', 'Forward', 31, {'goals': 80, 'assists': 8, 'appearances': 46});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (45, 'Player 45', 'Team 6', 'Forward', 31, {'goals': 80, 'assists': 8, 'appearances': 46});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 45, 'Player 45', 'Forward', 31, {'goals': 80, 'assists': 8, 'appearances': 46});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 46', 46, 'Team 12', 'Forward', 27, {'goals': 57, 'assists': 14, 'appearances': 185});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (46, 'Player 46', 'Team 12', 'Forward', 27, {'goals': 57, 'assists': 14, 'appearances': 185});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 46, 'Player 46', 'Forward', 27, {'goals': 57, 'assists': 14, 'appearances': 185});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 47', 47, 'Team 11', 'Midfielder', 18, {'goals': 92, 'assists': 36, 'appearances': 195});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (47, 'Player 47', 'Team 11', 'Midfielder', 18, {'goals': 92, 'assists': 36, 'appearances': 195});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 47, 'Player 47', 'Midfielder', 18, {'goals': 92, 'assists': 36, 'appearances': 195});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 48', 48, 'Team 17', 'Forward', 35, {'goals': 24, 'assists': 33, 'appearances': 83});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (48, 'Player 48', 'Team 17', 'Forward', 35, {'goals': 24, 'assists': 33, 'appearances': 83});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 48, 'Player 48', 'Forward', 35, {'goals': 24, 'assists': 33, 'appearances': 83});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 49', 49, 'Team 17', 'Defender', 32, {'goals': 97, 'assists': 6, 'appearances': 99});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (49, 'Player 49', 'Team 17', 'Defender', 32, {'goals': 97, 'assists': 6, 'appearances': 99});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 49, 'Player 49', 'Defender', 32, {'goals': 97, 'assists': 6, 'appearances': 99});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 50', 50, 'Team 13', 'Defender', 21, {'goals': 70, 'assists': 7, 'appearances': 199});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (50, 'Player 50', 'Team 13', 'Defender', 21, {'goals': 70, 'assists': 7, 'appearances': 199});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 50, 'Player 50', 'Defender', 21, {'goals': 70, 'assists': 7, 'appearances': 199});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 51', 51, 'Team 3', 'Defender', 18, {'goals': 72, 'assists': 49, 'appearances': 28});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (51, 'Player 51', 'Team 3', 'Defender', 18, {'goals': 72, 'assists': 49, 'appearances': 28});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 51, 'Player 51', 'Defender', 18, {'goals': 72, 'assists': 49, 'appearances': 28});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 52', 52, 'Team 15', 'Goalkeeper', 18, {'goals': 70, 'assists': 32, 'appearances': 115});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (52, 'Player 52', 'Team 15', 'Goalkeeper', 18, {'goals': 70, 'assists': 32, 'appearances': 115});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 52, 'Player 52', 'Goalkeeper', 18, {'goals': 70, 'assists': 32, 'appearances': 115});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 53', 53, 'Team 4', 'Goalkeeper', 25, {'goals': 35, 'assists': 47, 'appearances': 39});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (53, 'Player 53', 'Team 4', 'Goalkeeper', 25, {'goals': 35, 'assists': 47, 'appearances': 39});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 53, 'Player 53', 'Goalkeeper', 25, {'goals': 35, 'assists': 47, 'appearances': 39});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 54', 54, 'Team 10', 'Defender', 34, {'goals': 45, 'assists': 50, 'appearances': 28});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (54, 'Player 54', 'Team 10', 'Defender', 34, {'goals': 45, 'assists': 50, 'appearances': 28});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 54, 'Player 54', 'Defender', 34, {'goals': 45, 'assists': 50, 'appearances': 28});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 55', 55, 'Team 4', 'Defender', 28, {'goals': 75, 'assists': 41, 'appearances': 54});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (55, 'Player 55', 'Team 4', 'Defender', 28, {'goals': 75, 'assists': 41, 'appearances': 54});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 55, 'Player 55', 'Defender', 28, {'goals': 75, 'assists': 41, 'appearances': 54});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 56', 56, 'Team 5', 'Defender', 19, {'goals': 99, 'assists': 0, 'appearances': 56});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (56, 'Player 56', 'Team 5', 'Defender', 19, {'goals': 99, 'assists': 0, 'appearances': 56});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 56, 'Player 56', 'Defender', 19, {'goals': 99, 'assists': 0, 'appearances': 56});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 57', 57, 'Team 2', 'Defender', 20, {'goals': 93, 'assists': 15, 'appearances': 194});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (57, 'Player 57', 'Team 2', 'Defender', 20, {'goals': 93, 'assists': 15, 'appearances': 194});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 57, 'Player 57', 'Defender', 20, {'goals': 93, 'assists': 15, 'appearances': 194});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 58', 58, 'Team 1', 'Forward', 25, {'goals': 33, 'assists': 21, 'appearances': 125});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (58, 'Player 58', 'Team 1', 'Forward', 25, {'goals': 33, 'assists': 21, 'appearances': 125});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 58, 'Player 58', 'Forward', 25, {'goals': 33, 'assists': 21, 'appearances': 125});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 59', 59, 'Team 10', 'Goalkeeper', 35, {'goals': 17, 'assists': 17, 'appearances': 183});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (59, 'Player 59', 'Team 10', 'Goalkeeper', 35, {'goals': 17, 'assists': 17, 'appearances': 183});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 59, 'Player 59', 'Goalkeeper', 35, {'goals': 17, 'assists': 17, 'appearances': 183});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 60', 60, 'Team 19', 'Midfielder', 24, {'goals': 96, 'assists': 43, 'appearances': 14});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (60, 'Player 60', 'Team 19', 'Midfielder', 24, {'goals': 96, 'assists': 43, 'appearances': 14});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 60, 'Player 60', 'Midfielder', 24, {'goals': 96, 'assists': 43, 'appearances': 14});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 61', 61, 'Team 13', 'Defender', 27, {'goals': 80, 'assists': 26, 'appearances': 59});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (61, 'Player 61', 'Team 13', 'Defender', 27, {'goals': 80, 'assists': 26, 'appearances': 59});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 61, 'Player 61', 'Defender', 27, {'goals': 80, 'assists': 26, 'appearances': 59});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 62', 62, 'Team 8', 'Goalkeeper', 34, {'goals': 46, 'assists': 40, 'appearances': 56});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (62, 'Player 62', 'Team 8', 'Goalkeeper', 34, {'goals': 46, 'assists': 40, 'appearances': 56});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 62, 'Player 62', 'Goalkeeper', 34, {'goals': 46, 'assists': 40, 'appearances': 56});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 63', 63, 'Team 13', 'Midfielder', 35, {'goals': 62, 'assists': 21, 'appearances': 19});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (63, 'Player 63', 'Team 13', 'Midfielder', 35, {'goals': 62, 'assists': 21, 'appearances': 19});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 63, 'Player 63', 'Midfielder', 35, {'goals': 62, 'assists': 21, 'appearances': 19});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 64', 64, 'Team 11', 'Goalkeeper', 31, {'goals': 14, 'assists': 50, 'appearances': 189});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (64, 'Player 64', 'Team 11', 'Goalkeeper', 31, {'goals': 14, 'assists': 50, 'appearances': 189});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 64, 'Player 64', 'Goalkeeper', 31, {'goals': 14, 'assists': 50, 'appearances': 189});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 65', 65, 'Team 14', 'Defender', 35, {'goals': 71, 'assists': 21, 'appearances': 20});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (65, 'Player 65', 'Team 14', 'Defender', 35, {'goals': 71, 'assists': 21, 'appearances': 20});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 65, 'Player 65', 'Defender', 35, {'goals': 71, 'assists': 21, 'appearances': 20});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 66', 66, 'Team 12', 'Midfielder', 28, {'goals': 83, 'assists': 13, 'appearances': 65});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (66, 'Player 66', 'Team 12', 'Midfielder', 28, {'goals': 83, 'assists': 13, 'appearances': 65});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 66, 'Player 66', 'Midfielder', 28, {'goals': 83, 'assists': 13, 'appearances': 65});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 67', 67, 'Team 1', 'Forward', 18, {'goals': 52, 'assists': 3, 'appearances': 147});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (67, 'Player 67', 'Team 1', 'Forward', 18, {'goals': 52, 'assists': 3, 'appearances': 147});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 67, 'Player 67', 'Forward', 18, {'goals': 52, 'assists': 3, 'appearances': 147});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 68', 68, 'Team 5', 'Defender', 26, {'goals': 81, 'assists': 22, 'appearances': 152});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (68, 'Player 68', 'Team 5', 'Defender', 26, {'goals': 81, 'assists': 22, 'appearances': 152});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 68, 'Player 68', 'Defender', 26, {'goals': 81, 'assists': 22, 'appearances': 152});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 69', 69, 'Team 2', 'Goalkeeper', 27, {'goals': 92, 'assists': 50, 'appearances': 98});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (69, 'Player 69', 'Team 2', 'Goalkeeper', 27, {'goals': 92, 'assists': 50, 'appearances': 98});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 69, 'Player 69', 'Goalkeeper', 27, {'goals': 92, 'assists': 50, 'appearances': 98});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 70', 70, 'Team 9', 'Midfielder', 31, {'goals': 95, 'assists': 5, 'appearances': 111});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (70, 'Player 70', 'Team 9', 'Midfielder', 31, {'goals': 95, 'assists': 5, 'appearances': 111});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 70, 'Player 70', 'Midfielder', 31, {'goals': 95, 'assists': 5, 'appearances': 111});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 71', 71, 'Team 10', 'Goalkeeper', 22, {'goals': 26, 'assists': 6, 'appearances': 145});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (71, 'Player 71', 'Team 10', 'Goalkeeper', 22, {'goals': 26, 'assists': 6, 'appearances': 145});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 71, 'Player 71', 'Goalkeeper', 22, {'goals': 26, 'assists': 6, 'appearances': 145});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 72', 72, 'Team 13', 'Defender', 18, {'goals': 62, 'assists': 36, 'appearances': 200});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (72, 'Player 72', 'Team 13', 'Defender', 18, {'goals': 62, 'assists': 36, 'appearances': 200});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 72, 'Player 72', 'Defender', 18, {'goals': 62, 'assists': 36, 'appearances': 200});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 73', 73, 'Team 7', 'Defender', 18, {'goals': 23, 'assists': 6, 'appearances': 148});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (73, 'Player 73', 'Team 7', 'Defender', 18, {'goals': 23, 'assists': 6, 'appearances': 148});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 73, 'Player 73', 'Defender', 18, {'goals': 23, 'assists': 6, 'appearances': 148});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 74', 74, 'Team 6', 'Defender', 30, {'goals': 75, 'assists': 34, 'appearances': 67});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (74, 'Player 74', 'Team 6', 'Defender', 30, {'goals': 75, 'assists': 34, 'appearances': 67});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 74, 'Player 74', 'Defender', 30, {'goals': 75, 'assists': 34, 'appearances': 67});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 75', 75, 'Team 5', 'Forward', 22, {'goals': 3, 'assists': 33, 'appearances': 27});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (75, 'Player 75', 'Team 5', 'Forward', 22, {'goals': 3, 'assists': 33, 'appearances': 27});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 75, 'Player 75', 'Forward', 22, {'goals': 3, 'assists': 33, 'appearances': 27});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 76', 76, 'Team 15', 'Goalkeeper', 27, {'goals': 58, 'assists': 39, 'appearances': 185});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (76, 'Player 76', 'Team 15', 'Goalkeeper', 27, {'goals': 58, 'assists': 39, 'appearances': 185});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 76, 'Player 76', 'Goalkeeper', 27, {'goals': 58, 'assists': 39, 'appearances': 185});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 77', 77, 'Team 7', 'Midfielder', 29, {'goals': 31, 'assists': 38, 'appearances': 174});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (77, 'Player 77', 'Team 7', 'Midfielder', 29, {'goals': 31, 'assists': 38, 'appearances': 174});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 77, 'Player 77', 'Midfielder', 29, {'goals': 31, 'assists': 38, 'appearances': 174});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 78', 78, 'Team 14', 'Forward', 24, {'goals': 47, 'assists': 41, 'appearances': 181});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (78, 'Player 78', 'Team 14', 'Forward', 24, {'goals': 47, 'assists': 41, 'appearances': 181});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 78, 'Player 78', 'Forward', 24, {'goals': 47, 'assists': 41, 'appearances': 181});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 79', 79, 'Team 18', 'Defender', 25, {'goals': 78, 'assists': 31, 'appearances': 32});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (79, 'Player 79', 'Team 18', 'Defender', 25, {'goals': 78, 'assists': 31, 'appearances': 32});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 79, 'Player 79', 'Defender', 25, {'goals': 78, 'assists': 31, 'appearances': 32});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 80', 80, 'Team 18', 'Goalkeeper', 19, {'goals': 2, 'assists': 48, 'appearances': 100});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (80, 'Player 80', 'Team 18', 'Goalkeeper', 19, {'goals': 2, 'assists': 48, 'appearances': 100});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 80, 'Player 80', 'Goalkeeper', 19, {'goals': 2, 'assists': 48, 'appearances': 100});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 81', 81, 'Team 16', 'Forward', 28, {'goals': 21, 'assists': 27, 'appearances': 165});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (81, 'Player 81', 'Team 16', 'Forward', 28, {'goals': 21, 'assists': 27, 'appearances': 165});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 81, 'Player 81', 'Forward', 28, {'goals': 21, 'assists': 27, 'appearances': 165});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 82', 82, 'Team 2', 'Midfielder', 25, {'goals': 56, 'assists': 8, 'appearances': 73});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (82, 'Player 82', 'Team 2', 'Midfielder', 25, {'goals': 56, 'assists': 8, 'appearances': 73});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 82, 'Player 82', 'Midfielder', 25, {'goals': 56, 'assists': 8, 'appearances': 73});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 83', 83, 'Team 8', 'Forward', 21, {'goals': 19, 'assists': 23, 'appearances': 59});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (83, 'Player 83', 'Team 8', 'Forward', 21, {'goals': 19, 'assists': 23, 'appearances': 59});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 83, 'Player 83', 'Forward', 21, {'goals': 19, 'assists': 23, 'appearances': 59});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 84', 84, 'Team 11', 'Defender', 29, {'goals': 30, 'assists': 16, 'appearances': 87});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (84, 'Player 84', 'Team 11', 'Defender', 29, {'goals': 30, 'assists': 16, 'appearances': 87});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 84, 'Player 84', 'Defender', 29, {'goals': 30, 'assists': 16, 'appearances': 87});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 85', 85, 'Team 8', 'Forward', 28, {'goals': 21, 'assists': 3, 'appearances': 94});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (85, 'Player 85', 'Team 8', 'Forward', 28, {'goals': 21, 'assists': 3, 'appearances': 94});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 85, 'Player 85', 'Forward', 28, {'goals': 21, 'assists': 3, 'appearances': 94});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 86', 86, 'Team 13', 'Forward', 27, {'goals': 73, 'assists': 19, 'appearances': 17});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (86, 'Player 86', 'Team 13', 'Forward', 27, {'goals': 73, 'assists': 19, 'appearances': 17});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 86, 'Player 86', 'Forward', 27, {'goals': 73, 'assists': 19, 'appearances': 17});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 87', 87, 'Team 2', 'Midfielder', 28, {'goals': 65, 'assists': 0, 'appearances': 135});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (87, 'Player 87', 'Team 2', 'Midfielder', 28, {'goals': 65, 'assists': 0, 'appearances': 135});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 87, 'Player 87', 'Midfielder', 28, {'goals': 65, 'assists': 0, 'appearances': 135});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 88', 88, 'Team 10', 'Defender', 27, {'goals': 78, 'assists': 1, 'appearances': 75});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (88, 'Player 88', 'Team 10', 'Defender', 27, {'goals': 78, 'assists': 1, 'appearances': 75});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 88, 'Player 88', 'Defender', 27, {'goals': 78, 'assists': 1, 'appearances': 75});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 89', 89, 'Team 19', 'Goalkeeper', 21, {'goals': 87, 'assists': 10, 'appearances': 70});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (89, 'Player 89', 'Team 19', 'Goalkeeper', 21, {'goals': 87, 'assists': 10, 'appearances': 70});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 89, 'Player 89', 'Goalkeeper', 21, {'goals': 87, 'assists': 10, 'appearances': 70});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 90', 90, 'Team 8', 'Midfielder', 21, {'goals': 100, 'assists': 43, 'appearances': 198});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (90, 'Player 90', 'Team 8', 'Midfielder', 21, {'goals': 100, 'assists': 43, 'appearances': 198});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 90, 'Player 90', 'Midfielder', 21, {'goals': 100, 'assists': 43, 'appearances': 198});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 91', 91, 'Team 6', 'Forward', 29, {'goals': 74, 'assists': 42, 'appearances': 139});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (91, 'Player 91', 'Team 6', 'Forward', 29, {'goals': 74, 'assists': 42, 'appearances': 139});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 91, 'Player 91', 'Forward', 29, {'goals': 74, 'assists': 42, 'appearances': 139});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 92', 92, 'Team 1', 'Forward', 18, {'goals': 99, 'assists': 2, 'appearances': 196});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (92, 'Player 92', 'Team 1', 'Forward', 18, {'goals': 99, 'assists': 2, 'appearances': 196});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 92, 'Player 92', 'Forward', 18, {'goals': 99, 'assists': 2, 'appearances': 196});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 93', 93, 'Team 15', 'Midfielder', 18, {'goals': 80, 'assists': 42, 'appearances': 149});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (93, 'Player 93', 'Team 15', 'Midfielder', 18, {'goals': 80, 'assists': 42, 'appearances': 149});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 93, 'Player 93', 'Midfielder', 18, {'goals': 80, 'assists': 42, 'appearances': 149});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 94', 94, 'Team 8', 'Defender', 26, {'goals': 73, 'assists': 40, 'appearances': 193});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (94, 'Player 94', 'Team 8', 'Defender', 26, {'goals': 73, 'assists': 40, 'appearances': 193});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 94, 'Player 94', 'Defender', 26, {'goals': 73, 'assists': 40, 'appearances': 193});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 95', 95, 'Team 2', 'Forward', 21, {'goals': 21, 'assists': 44, 'appearances': 61});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (95, 'Player 95', 'Team 2', 'Forward', 21, {'goals': 21, 'assists': 44, 'appearances': 61});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 95, 'Player 95', 'Forward', 21, {'goals': 21, 'assists': 44, 'appearances': 61});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 96', 96, 'Team 1', 'Defender', 29, {'goals': 70, 'assists': 41, 'appearances': 98});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (96, 'Player 96', 'Team 1', 'Defender', 29, {'goals': 70, 'assists': 41, 'appearances': 98});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 96, 'Player 96', 'Defender', 29, {'goals': 70, 'assists': 41, 'appearances': 98});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 97', 97, 'Team 20', 'Defender', 18, {'goals': 71, 'assists': 3, 'appearances': 103});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (97, 'Player 97', 'Team 20', 'Defender', 18, {'goals': 71, 'assists': 3, 'appearances': 103});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 97, 'Player 97', 'Defender', 18, {'goals': 71, 'assists': 3, 'appearances': 103});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 98', 98, 'Team 19', 'Midfielder', 18, {'goals': 22, 'assists': 44, 'appearances': 53});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (98, 'Player 98', 'Team 19', 'Midfielder', 18, {'goals': 22, 'assists': 44, 'appearances': 53});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 98, 'Player 98', 'Midfielder', 18, {'goals': 22, 'assists': 44, 'appearances': 53});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 99', 99, 'Team 5', 'Midfielder', 20, {'goals': 3, 'assists': 36, 'appearances': 40});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (99, 'Player 99', 'Team 5', 'Midfielder', 20, {'goals': 3, 'assists': 36, 'appearances': 40});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 99, 'Player 99', 'Midfielder', 20, {'goals': 3, 'assists': 36, 'appearances': 40});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 100', 100, 'Team 2', 'Defender', 26, {'goals': 27, 'assists': 28, 'appearances': 25});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (100, 'Player 100', 'Team 2', 'Defender', 26, {'goals': 27, 'assists': 28, 'appearances': 25});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 100, 'Player 100', 'Defender', 26, {'goals': 27, 'assists': 28, 'appearances': 25});
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 5', '2022-04-19', 1, 0, 2, ['Event 2', 'Event 9', 'Event 8', 'Event 9', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 1', '2023-07-08', 2, 3, 2, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 20', 'Team 5', '2023-11-15', 3, 3, 4, ['Event 3', 'Event 6', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 1', '2023-06-22', 4, 1, 0, ['Event 9', 'Event 8', 'Event 3', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 8', 'Team 17', '2023-01-26', 5, 2, 3, ['Event 1', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 18', '2023-12-22', 6, 4, 2, ['Event 6', 'Event 10', 'Event 3', 'Event 8', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 18', 'Team 1', '2023-06-24', 7, 2, 2, ['Event 9', 'Event 3', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 5', '2023-04-13', 8, 1, 2, ['Event 3', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 12', '2023-07-28', 9, 5, 3, ['Event 10', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 12', 'Team 9', '2023-05-09', 10, 0, 2, ['Event 2', 'Event 6', 'Event 9', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 19', '2022-11-17', 11, 5, 5, ['Event 6', 'Event 10', 'Event 6', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 15', 'Team 12', '2023-10-18', 12, 0, 5, ['Event 5', 'Event 2', 'Event 10', 'Event 7', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 2', '2022-05-13', 13, 0, 0, ['Event 10', 'Event 10', 'Event 3', 'Event 5', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 13', 'Team 9', '2023-04-01', 14, 2, 5, ['Event 9', 'Event 10', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 16', '2023-07-10', 15, 4, 4, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 6', 'Team 12', '2022-04-15', 16, 3, 4, ['Event 3', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 5', '2022-01-30', 17, 4, 3, ['Event 4', 'Event 4', 'Event 2', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 5', '2022-08-12', 18, 0, 2, ['Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 15', '2022-03-17', 19, 4, 3, ['Event 10', 'Event 2', 'Event 7', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 18', 'Team 20', '2023-10-25', 20, 3, 1, ['Event 3', 'Event 5', 'Event 8', 'Event 5', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 9', '2022-11-21', 21, 3, 3, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 14', 'Team 4', '2023-09-27', 22, 5, 5, ['Event 8', 'Event 3', 'Event 3', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 4', '2023-07-09', 23, 5, 3, ['Event 1', 'Event 8', 'Event 4', 'Event 8', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 20', 'Team 17', '2023-12-12', 24, 1, 1, ['Event 2', 'Event 3', 'Event 3', 'Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 17', '2022-02-24', 25, 4, 4, ['Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 3', '2022-12-05', 26, 5, 2, ['Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 14', 'Team 14', '2022-07-07', 27, 0, 1, ['Event 6', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 6', '2023-09-05', 28, 5, 0, ['Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 4', '2022-10-18', 29, 3, 3, ['Event 2', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 11', 'Team 7', '2022-07-13', 30, 4, 5, ['Event 2', 'Event 1', 'Event 9', 'Event 9', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 7', '2022-11-29', 31, 2, 1, ['Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 19', '2022-08-13', 32, 0, 5, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 12', 'Team 6', '2023-10-30', 33, 5, 2, ['Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 17', '2023-01-25', 34, 2, 2, ['Event 8', 'Event 9', 'Event 10', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 3', '2022-08-04', 35, 5, 5, ['Event 9', 'Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 11', '2022-10-27', 36, 0, 2, ['Event 8', 'Event 7', 'Event 4', 'Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 6', 'Team 4', '2022-01-18', 37, 1, 3, ['Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 12', 'Team 7', '2022-03-05', 38, 5, 3, ['Event 3', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 13', '2023-12-28', 39, 3, 3, ['Event 10', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 5', '2023-02-06', 40, 3, 2, ['Event 5', 'Event 3']);
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 1', {'Team 16', 'Team 17', 'Team 8', 'Team 18', 'Team 5', 'Team 6', 'Team 1', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 2', {'Team 16', 'Team 19', 'Team 9', 'Team 4', 'Team 6', 'Team 11', 'Team 7', 'Team 15', 'Team 14', 'Team 12', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 3', {'Team 16', 'Team 17', 'Team 8', 'Team 18', 'Team 9', 'Team 7', 'Team 3', 'Team 11', 'Team 20', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 4', {'Team 14', 'Team 7', 'Team 1', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 5', {'Team 2', 'Team 20', 'Team 8'});
INSERT INTO leagues (country, name, teams) VALUES ('Rome', 'League 6', {'Team 8', 'Team 15', 'Team 6', 'Team 13', 'Team 2', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 7', {'Team 17', 'Team 13', 'Team 18', 'Team 9', 'Team 3', 'Team 11', 'Team 15', 'Team 4', 'Team 12', 'Team 10'});
