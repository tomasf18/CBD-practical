
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
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 1', 'Barcelona', 'Barcelona Stadium', {8, 77, 51, 93, 31}, 'Lisbon', ['Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 1', 'Barcelona', 'Barcelona Stadium', {8, 77, 51, 93, 31}, ['Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 2', 'Milan', 'Milan Stadium', {70, 42, 50, 82, 31}, 'Manchester', ['Achievement 3', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 2', 'Milan', 'Milan Stadium', {70, 42, 50, 82, 31}, ['Achievement 3', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 3', 'Barcelona', 'Barcelona Stadium', {33, 72, 41, 13, 48}, 'Madrid', ['Achievement 1', 'Achievement 1', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Madrid', 'Team 3', 'Barcelona', 'Barcelona Stadium', {33, 72, 41, 13, 48}, ['Achievement 1', 'Achievement 1', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 4', 'Manchester', 'Manchester Stadium', {10, 43, 76, 45, 18, 95}, 'Lisbon', ['Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 4', 'Manchester', 'Manchester Stadium', {10, 43, 76, 45, 18, 95}, ['Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 5', 'Lisbon', 'Lisbon Stadium', {48, 17, 19}, 'Rome', ['Achievement 1', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 5', 'Lisbon', 'Lisbon Stadium', {48, 17, 19}, ['Achievement 1', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 6', 'Madrid', 'Madrid Stadium', {80, 10, 51, 47}, 'London', ['Achievement 1', 'Achievement 5', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('London', 'Team 6', 'Madrid', 'Madrid Stadium', {80, 10, 51, 47}, ['Achievement 1', 'Achievement 5', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 7', 'Manchester', 'Manchester Stadium', {91, 6, 38, 71}, 'Lisbon', ['Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 7', 'Manchester', 'Manchester Stadium', {91, 6, 38, 71}, ['Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 8', 'London', 'London Stadium', {10, 78, 15, 51, 59}, 'Rome', ['Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 8', 'London', 'London Stadium', {10, 78, 15, 51, 59}, ['Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 9', 'Manchester', 'Manchester Stadium', {64, 44, 45, 76, 90, 91}, 'Lisbon', ['Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 9', 'Manchester', 'Manchester Stadium', {64, 44, 45, 76, 90, 91}, ['Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 10', 'Lisbon', 'Lisbon Stadium', {24, 17, 2, 68}, 'Berlin', ['Achievement 1', 'Achievement 3', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Berlin', 'Team 10', 'Lisbon', 'Lisbon Stadium', {24, 17, 2, 68}, ['Achievement 1', 'Achievement 3', 'Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 11', 'Rome', 'Rome Stadium', {33, 81, 89, 26, 28, 25}, 'Milan', ['Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Milan', 'Team 11', 'Rome', 'Rome Stadium', {33, 81, 89, 26, 28, 25}, ['Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 12', 'Paris', 'Paris Stadium', {80, 19, 68, 21}, 'Paris', ['Achievement 5', 'Achievement 3', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 12', 'Paris', 'Paris Stadium', {80, 19, 68, 21}, ['Achievement 5', 'Achievement 3', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 13', 'Barcelona', 'Barcelona Stadium', {9, 82, 43, 29}, 'Berlin', ['Achievement 4', 'Achievement 3', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Berlin', 'Team 13', 'Barcelona', 'Barcelona Stadium', {9, 82, 43, 29}, ['Achievement 4', 'Achievement 3', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 14', 'Lisbon', 'Lisbon Stadium', {65, 2, 66, 13}, 'Manchester', ['Achievement 5', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 14', 'Lisbon', 'Lisbon Stadium', {65, 2, 66, 13}, ['Achievement 5', 'Achievement 1', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 15', 'Rome', 'Rome Stadium', {24, 2, 42, 74}, 'Manchester', ['Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 15', 'Rome', 'Rome Stadium', {24, 2, 42, 74}, ['Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 16', 'Manchester', 'Manchester Stadium', {96, 4, 84, 22, 90}, 'London', ['Achievement 3', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('London', 'Team 16', 'Manchester', 'Manchester Stadium', {96, 4, 84, 22, 90}, ['Achievement 3', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 17', 'Milan', 'Milan Stadium', {2, 27, 70}, 'Paris', ['Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 17', 'Milan', 'Milan Stadium', {2, 27, 70}, ['Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 18', 'Amsterdam', 'Amsterdam Stadium', {3, 32, 50, 51}, 'Paris', ['Achievement 3', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 18', 'Amsterdam', 'Amsterdam Stadium', {3, 32, 50, 51}, ['Achievement 3', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 19', 'Milan', 'Milan Stadium', {18, 53, 90}, 'Madrid', ['Achievement 3', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Madrid', 'Team 19', 'Milan', 'Milan Stadium', {18, 53, 90}, ['Achievement 3', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 20', 'Paris', 'Paris Stadium', {100, 76, 52, 21, 90, 93}, 'Madrid', ['Achievement 4', 'Achievement 2', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Madrid', 'Team 20', 'Paris', 'Paris Stadium', {100, 76, 52, 21, 90, 93}, ['Achievement 4', 'Achievement 2', 'Achievement 1']);
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 1', 1, 'Team 1', 'Midfielder', 20, {'goals': 33, 'assists': 47, 'appearances': 27});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (1, 'Player 1', 'Team 1', 'Midfielder', 20, {'goals': 33, 'assists': 47, 'appearances': 27});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 1, 'Player 1', 'Midfielder', 20, {'goals': 33, 'assists': 47, 'appearances': 27});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 2', 2, 'Team 16', 'Midfielder', 31, {'goals': 54, 'assists': 37, 'appearances': 161});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (2, 'Player 2', 'Team 16', 'Midfielder', 31, {'goals': 54, 'assists': 37, 'appearances': 161});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 2, 'Player 2', 'Midfielder', 31, {'goals': 54, 'assists': 37, 'appearances': 161});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 3', 3, 'Team 14', 'Defender', 22, {'goals': 31, 'assists': 39, 'appearances': 150});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (3, 'Player 3', 'Team 14', 'Defender', 22, {'goals': 31, 'assists': 39, 'appearances': 150});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 3, 'Player 3', 'Defender', 22, {'goals': 31, 'assists': 39, 'appearances': 150});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 4', 4, 'Team 1', 'Midfielder', 31, {'goals': 96, 'assists': 13, 'appearances': 32});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (4, 'Player 4', 'Team 1', 'Midfielder', 31, {'goals': 96, 'assists': 13, 'appearances': 32});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 4, 'Player 4', 'Midfielder', 31, {'goals': 96, 'assists': 13, 'appearances': 32});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 5', 5, 'Team 10', 'Midfielder', 18, {'goals': 65, 'assists': 0, 'appearances': 29});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (5, 'Player 5', 'Team 10', 'Midfielder', 18, {'goals': 65, 'assists': 0, 'appearances': 29});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 5, 'Player 5', 'Midfielder', 18, {'goals': 65, 'assists': 0, 'appearances': 29});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 6', 6, 'Team 13', 'Forward', 34, {'goals': 67, 'assists': 47, 'appearances': 156});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (6, 'Player 6', 'Team 13', 'Forward', 34, {'goals': 67, 'assists': 47, 'appearances': 156});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 6, 'Player 6', 'Forward', 34, {'goals': 67, 'assists': 47, 'appearances': 156});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 7', 7, 'Team 17', 'Forward', 25, {'goals': 83, 'assists': 5, 'appearances': 103});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (7, 'Player 7', 'Team 17', 'Forward', 25, {'goals': 83, 'assists': 5, 'appearances': 103});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 7, 'Player 7', 'Forward', 25, {'goals': 83, 'assists': 5, 'appearances': 103});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 8', 8, 'Team 11', 'Defender', 26, {'goals': 34, 'assists': 14, 'appearances': 37});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (8, 'Player 8', 'Team 11', 'Defender', 26, {'goals': 34, 'assists': 14, 'appearances': 37});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 8, 'Player 8', 'Defender', 26, {'goals': 34, 'assists': 14, 'appearances': 37});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 9', 9, 'Team 6', 'Forward', 21, {'goals': 60, 'assists': 11, 'appearances': 27});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (9, 'Player 9', 'Team 6', 'Forward', 21, {'goals': 60, 'assists': 11, 'appearances': 27});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 9, 'Player 9', 'Forward', 21, {'goals': 60, 'assists': 11, 'appearances': 27});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 10', 10, 'Team 19', 'Midfielder', 21, {'goals': 73, 'assists': 29, 'appearances': 158});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (10, 'Player 10', 'Team 19', 'Midfielder', 21, {'goals': 73, 'assists': 29, 'appearances': 158});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 10, 'Player 10', 'Midfielder', 21, {'goals': 73, 'assists': 29, 'appearances': 158});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 11', 11, 'Team 5', 'Midfielder', 34, {'goals': 12, 'assists': 11, 'appearances': 63});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (11, 'Player 11', 'Team 5', 'Midfielder', 34, {'goals': 12, 'assists': 11, 'appearances': 63});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 11, 'Player 11', 'Midfielder', 34, {'goals': 12, 'assists': 11, 'appearances': 63});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 12', 12, 'Team 15', 'Goalkeeper', 25, {'goals': 70, 'assists': 14, 'appearances': 171});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (12, 'Player 12', 'Team 15', 'Goalkeeper', 25, {'goals': 70, 'assists': 14, 'appearances': 171});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 12, 'Player 12', 'Goalkeeper', 25, {'goals': 70, 'assists': 14, 'appearances': 171});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 13', 13, 'Team 17', 'Forward', 33, {'goals': 8, 'assists': 31, 'appearances': 131});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (13, 'Player 13', 'Team 17', 'Forward', 33, {'goals': 8, 'assists': 31, 'appearances': 131});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 13, 'Player 13', 'Forward', 33, {'goals': 8, 'assists': 31, 'appearances': 131});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 14', 14, 'Team 18', 'Forward', 34, {'goals': 28, 'assists': 32, 'appearances': 137});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (14, 'Player 14', 'Team 18', 'Forward', 34, {'goals': 28, 'assists': 32, 'appearances': 137});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 14, 'Player 14', 'Forward', 34, {'goals': 28, 'assists': 32, 'appearances': 137});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 15', 15, 'Team 10', 'Midfielder', 23, {'goals': 7, 'assists': 10, 'appearances': 91});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (15, 'Player 15', 'Team 10', 'Midfielder', 23, {'goals': 7, 'assists': 10, 'appearances': 91});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 15, 'Player 15', 'Midfielder', 23, {'goals': 7, 'assists': 10, 'appearances': 91});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 16', 16, 'Team 4', 'Defender', 19, {'goals': 93, 'assists': 4, 'appearances': 67});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (16, 'Player 16', 'Team 4', 'Defender', 19, {'goals': 93, 'assists': 4, 'appearances': 67});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 16, 'Player 16', 'Defender', 19, {'goals': 93, 'assists': 4, 'appearances': 67});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 17', 17, 'Team 12', 'Forward', 21, {'goals': 48, 'assists': 41, 'appearances': 10});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (17, 'Player 17', 'Team 12', 'Forward', 21, {'goals': 48, 'assists': 41, 'appearances': 10});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 17, 'Player 17', 'Forward', 21, {'goals': 48, 'assists': 41, 'appearances': 10});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 18', 18, 'Team 16', 'Midfielder', 22, {'goals': 97, 'assists': 44, 'appearances': 168});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (18, 'Player 18', 'Team 16', 'Midfielder', 22, {'goals': 97, 'assists': 44, 'appearances': 168});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 18, 'Player 18', 'Midfielder', 22, {'goals': 97, 'assists': 44, 'appearances': 168});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 19', 19, 'Team 20', 'Goalkeeper', 23, {'goals': 10, 'assists': 46, 'appearances': 140});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (19, 'Player 19', 'Team 20', 'Goalkeeper', 23, {'goals': 10, 'assists': 46, 'appearances': 140});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 19, 'Player 19', 'Goalkeeper', 23, {'goals': 10, 'assists': 46, 'appearances': 140});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 20', 20, 'Team 8', 'Midfielder', 32, {'goals': 82, 'assists': 28, 'appearances': 193});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (20, 'Player 20', 'Team 8', 'Midfielder', 32, {'goals': 82, 'assists': 28, 'appearances': 193});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 20, 'Player 20', 'Midfielder', 32, {'goals': 82, 'assists': 28, 'appearances': 193});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 21', 21, 'Team 1', 'Defender', 19, {'goals': 14, 'assists': 11, 'appearances': 186});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (21, 'Player 21', 'Team 1', 'Defender', 19, {'goals': 14, 'assists': 11, 'appearances': 186});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 21, 'Player 21', 'Defender', 19, {'goals': 14, 'assists': 11, 'appearances': 186});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 22', 22, 'Team 18', 'Defender', 34, {'goals': 52, 'assists': 37, 'appearances': 105});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (22, 'Player 22', 'Team 18', 'Defender', 34, {'goals': 52, 'assists': 37, 'appearances': 105});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 22, 'Player 22', 'Defender', 34, {'goals': 52, 'assists': 37, 'appearances': 105});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 23', 23, 'Team 19', 'Defender', 19, {'goals': 20, 'assists': 2, 'appearances': 162});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (23, 'Player 23', 'Team 19', 'Defender', 19, {'goals': 20, 'assists': 2, 'appearances': 162});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 23, 'Player 23', 'Defender', 19, {'goals': 20, 'assists': 2, 'appearances': 162});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 24', 24, 'Team 14', 'Goalkeeper', 35, {'goals': 11, 'assists': 40, 'appearances': 83});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (24, 'Player 24', 'Team 14', 'Goalkeeper', 35, {'goals': 11, 'assists': 40, 'appearances': 83});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 24, 'Player 24', 'Goalkeeper', 35, {'goals': 11, 'assists': 40, 'appearances': 83});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 25', 25, 'Team 4', 'Midfielder', 30, {'goals': 27, 'assists': 34, 'appearances': 55});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (25, 'Player 25', 'Team 4', 'Midfielder', 30, {'goals': 27, 'assists': 34, 'appearances': 55});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 25, 'Player 25', 'Midfielder', 30, {'goals': 27, 'assists': 34, 'appearances': 55});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 26', 26, 'Team 13', 'Midfielder', 32, {'goals': 37, 'assists': 34, 'appearances': 193});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (26, 'Player 26', 'Team 13', 'Midfielder', 32, {'goals': 37, 'assists': 34, 'appearances': 193});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 26, 'Player 26', 'Midfielder', 32, {'goals': 37, 'assists': 34, 'appearances': 193});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 27', 27, 'Team 11', 'Defender', 23, {'goals': 49, 'assists': 6, 'appearances': 125});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (27, 'Player 27', 'Team 11', 'Defender', 23, {'goals': 49, 'assists': 6, 'appearances': 125});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 27, 'Player 27', 'Defender', 23, {'goals': 49, 'assists': 6, 'appearances': 125});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 28', 28, 'Team 3', 'Goalkeeper', 29, {'goals': 58, 'assists': 5, 'appearances': 91});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (28, 'Player 28', 'Team 3', 'Goalkeeper', 29, {'goals': 58, 'assists': 5, 'appearances': 91});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 28, 'Player 28', 'Goalkeeper', 29, {'goals': 58, 'assists': 5, 'appearances': 91});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 29', 29, 'Team 3', 'Midfielder', 20, {'goals': 41, 'assists': 38, 'appearances': 138});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (29, 'Player 29', 'Team 3', 'Midfielder', 20, {'goals': 41, 'assists': 38, 'appearances': 138});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 29, 'Player 29', 'Midfielder', 20, {'goals': 41, 'assists': 38, 'appearances': 138});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 30', 30, 'Team 12', 'Forward', 33, {'goals': 45, 'assists': 9, 'appearances': 115});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (30, 'Player 30', 'Team 12', 'Forward', 33, {'goals': 45, 'assists': 9, 'appearances': 115});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 30, 'Player 30', 'Forward', 33, {'goals': 45, 'assists': 9, 'appearances': 115});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 31', 31, 'Team 14', 'Defender', 19, {'goals': 72, 'assists': 35, 'appearances': 150});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (31, 'Player 31', 'Team 14', 'Defender', 19, {'goals': 72, 'assists': 35, 'appearances': 150});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 31, 'Player 31', 'Defender', 19, {'goals': 72, 'assists': 35, 'appearances': 150});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 32', 32, 'Team 8', 'Goalkeeper', 18, {'goals': 11, 'assists': 43, 'appearances': 121});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (32, 'Player 32', 'Team 8', 'Goalkeeper', 18, {'goals': 11, 'assists': 43, 'appearances': 121});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 32, 'Player 32', 'Goalkeeper', 18, {'goals': 11, 'assists': 43, 'appearances': 121});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 33', 33, 'Team 8', 'Goalkeeper', 28, {'goals': 89, 'assists': 46, 'appearances': 50});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (33, 'Player 33', 'Team 8', 'Goalkeeper', 28, {'goals': 89, 'assists': 46, 'appearances': 50});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 33, 'Player 33', 'Goalkeeper', 28, {'goals': 89, 'assists': 46, 'appearances': 50});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 34', 34, 'Team 11', 'Midfielder', 25, {'goals': 77, 'assists': 36, 'appearances': 187});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (34, 'Player 34', 'Team 11', 'Midfielder', 25, {'goals': 77, 'assists': 36, 'appearances': 187});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 34, 'Player 34', 'Midfielder', 25, {'goals': 77, 'assists': 36, 'appearances': 187});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 35', 35, 'Team 20', 'Defender', 24, {'goals': 97, 'assists': 49, 'appearances': 23});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (35, 'Player 35', 'Team 20', 'Defender', 24, {'goals': 97, 'assists': 49, 'appearances': 23});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 35, 'Player 35', 'Defender', 24, {'goals': 97, 'assists': 49, 'appearances': 23});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 36', 36, 'Team 1', 'Goalkeeper', 35, {'goals': 88, 'assists': 24, 'appearances': 165});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (36, 'Player 36', 'Team 1', 'Goalkeeper', 35, {'goals': 88, 'assists': 24, 'appearances': 165});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 36, 'Player 36', 'Goalkeeper', 35, {'goals': 88, 'assists': 24, 'appearances': 165});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 37', 37, 'Team 17', 'Defender', 21, {'goals': 51, 'assists': 42, 'appearances': 68});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (37, 'Player 37', 'Team 17', 'Defender', 21, {'goals': 51, 'assists': 42, 'appearances': 68});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 37, 'Player 37', 'Defender', 21, {'goals': 51, 'assists': 42, 'appearances': 68});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 38', 38, 'Team 14', 'Midfielder', 21, {'goals': 5, 'assists': 18, 'appearances': 83});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (38, 'Player 38', 'Team 14', 'Midfielder', 21, {'goals': 5, 'assists': 18, 'appearances': 83});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 38, 'Player 38', 'Midfielder', 21, {'goals': 5, 'assists': 18, 'appearances': 83});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 39', 39, 'Team 6', 'Forward', 33, {'goals': 98, 'assists': 43, 'appearances': 93});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (39, 'Player 39', 'Team 6', 'Forward', 33, {'goals': 98, 'assists': 43, 'appearances': 93});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 39, 'Player 39', 'Forward', 33, {'goals': 98, 'assists': 43, 'appearances': 93});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 40', 40, 'Team 4', 'Midfielder', 21, {'goals': 74, 'assists': 0, 'appearances': 152});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (40, 'Player 40', 'Team 4', 'Midfielder', 21, {'goals': 74, 'assists': 0, 'appearances': 152});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 40, 'Player 40', 'Midfielder', 21, {'goals': 74, 'assists': 0, 'appearances': 152});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 41', 41, 'Team 14', 'Forward', 25, {'goals': 10, 'assists': 13, 'appearances': 139});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (41, 'Player 41', 'Team 14', 'Forward', 25, {'goals': 10, 'assists': 13, 'appearances': 139});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 41, 'Player 41', 'Forward', 25, {'goals': 10, 'assists': 13, 'appearances': 139});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 42', 42, 'Team 17', 'Midfielder', 34, {'goals': 26, 'assists': 34, 'appearances': 20});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (42, 'Player 42', 'Team 17', 'Midfielder', 34, {'goals': 26, 'assists': 34, 'appearances': 20});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 42, 'Player 42', 'Midfielder', 34, {'goals': 26, 'assists': 34, 'appearances': 20});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 43', 43, 'Team 20', 'Midfielder', 22, {'goals': 4, 'assists': 10, 'appearances': 114});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (43, 'Player 43', 'Team 20', 'Midfielder', 22, {'goals': 4, 'assists': 10, 'appearances': 114});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 43, 'Player 43', 'Midfielder', 22, {'goals': 4, 'assists': 10, 'appearances': 114});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 44', 44, 'Team 15', 'Defender', 26, {'goals': 2, 'assists': 28, 'appearances': 19});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (44, 'Player 44', 'Team 15', 'Defender', 26, {'goals': 2, 'assists': 28, 'appearances': 19});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 44, 'Player 44', 'Defender', 26, {'goals': 2, 'assists': 28, 'appearances': 19});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 45', 45, 'Team 3', 'Midfielder', 22, {'goals': 100, 'assists': 20, 'appearances': 156});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (45, 'Player 45', 'Team 3', 'Midfielder', 22, {'goals': 100, 'assists': 20, 'appearances': 156});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 45, 'Player 45', 'Midfielder', 22, {'goals': 100, 'assists': 20, 'appearances': 156});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 46', 46, 'Team 15', 'Midfielder', 21, {'goals': 89, 'assists': 27, 'appearances': 153});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (46, 'Player 46', 'Team 15', 'Midfielder', 21, {'goals': 89, 'assists': 27, 'appearances': 153});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 46, 'Player 46', 'Midfielder', 21, {'goals': 89, 'assists': 27, 'appearances': 153});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 47', 47, 'Team 16', 'Midfielder', 28, {'goals': 61, 'assists': 10, 'appearances': 41});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (47, 'Player 47', 'Team 16', 'Midfielder', 28, {'goals': 61, 'assists': 10, 'appearances': 41});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 47, 'Player 47', 'Midfielder', 28, {'goals': 61, 'assists': 10, 'appearances': 41});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 48', 48, 'Team 12', 'Forward', 33, {'goals': 53, 'assists': 13, 'appearances': 119});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (48, 'Player 48', 'Team 12', 'Forward', 33, {'goals': 53, 'assists': 13, 'appearances': 119});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 48, 'Player 48', 'Forward', 33, {'goals': 53, 'assists': 13, 'appearances': 119});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 49', 49, 'Team 2', 'Forward', 32, {'goals': 12, 'assists': 43, 'appearances': 132});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (49, 'Player 49', 'Team 2', 'Forward', 32, {'goals': 12, 'assists': 43, 'appearances': 132});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 49, 'Player 49', 'Forward', 32, {'goals': 12, 'assists': 43, 'appearances': 132});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 50', 50, 'Team 14', 'Midfielder', 18, {'goals': 30, 'assists': 45, 'appearances': 107});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (50, 'Player 50', 'Team 14', 'Midfielder', 18, {'goals': 30, 'assists': 45, 'appearances': 107});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 50, 'Player 50', 'Midfielder', 18, {'goals': 30, 'assists': 45, 'appearances': 107});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 51', 51, 'Team 1', 'Midfielder', 32, {'goals': 1, 'assists': 39, 'appearances': 174});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (51, 'Player 51', 'Team 1', 'Midfielder', 32, {'goals': 1, 'assists': 39, 'appearances': 174});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 51, 'Player 51', 'Midfielder', 32, {'goals': 1, 'assists': 39, 'appearances': 174});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 52', 52, 'Team 4', 'Forward', 18, {'goals': 5, 'assists': 31, 'appearances': 164});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (52, 'Player 52', 'Team 4', 'Forward', 18, {'goals': 5, 'assists': 31, 'appearances': 164});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 52, 'Player 52', 'Forward', 18, {'goals': 5, 'assists': 31, 'appearances': 164});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 53', 53, 'Team 18', 'Midfielder', 19, {'goals': 24, 'assists': 49, 'appearances': 82});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (53, 'Player 53', 'Team 18', 'Midfielder', 19, {'goals': 24, 'assists': 49, 'appearances': 82});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 53, 'Player 53', 'Midfielder', 19, {'goals': 24, 'assists': 49, 'appearances': 82});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 54', 54, 'Team 15', 'Goalkeeper', 34, {'goals': 24, 'assists': 1, 'appearances': 126});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (54, 'Player 54', 'Team 15', 'Goalkeeper', 34, {'goals': 24, 'assists': 1, 'appearances': 126});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 54, 'Player 54', 'Goalkeeper', 34, {'goals': 24, 'assists': 1, 'appearances': 126});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 55', 55, 'Team 1', 'Forward', 20, {'goals': 58, 'assists': 30, 'appearances': 10});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (55, 'Player 55', 'Team 1', 'Forward', 20, {'goals': 58, 'assists': 30, 'appearances': 10});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 55, 'Player 55', 'Forward', 20, {'goals': 58, 'assists': 30, 'appearances': 10});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 56', 56, 'Team 10', 'Defender', 29, {'goals': 14, 'assists': 20, 'appearances': 22});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (56, 'Player 56', 'Team 10', 'Defender', 29, {'goals': 14, 'assists': 20, 'appearances': 22});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 56, 'Player 56', 'Defender', 29, {'goals': 14, 'assists': 20, 'appearances': 22});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 57', 57, 'Team 9', 'Forward', 30, {'goals': 42, 'assists': 37, 'appearances': 94});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (57, 'Player 57', 'Team 9', 'Forward', 30, {'goals': 42, 'assists': 37, 'appearances': 94});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 57, 'Player 57', 'Forward', 30, {'goals': 42, 'assists': 37, 'appearances': 94});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 58', 58, 'Team 4', 'Goalkeeper', 28, {'goals': 61, 'assists': 15, 'appearances': 134});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (58, 'Player 58', 'Team 4', 'Goalkeeper', 28, {'goals': 61, 'assists': 15, 'appearances': 134});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 58, 'Player 58', 'Goalkeeper', 28, {'goals': 61, 'assists': 15, 'appearances': 134});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 59', 59, 'Team 11', 'Defender', 30, {'goals': 23, 'assists': 38, 'appearances': 129});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (59, 'Player 59', 'Team 11', 'Defender', 30, {'goals': 23, 'assists': 38, 'appearances': 129});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 59, 'Player 59', 'Defender', 30, {'goals': 23, 'assists': 38, 'appearances': 129});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 60', 60, 'Team 20', 'Goalkeeper', 34, {'goals': 26, 'assists': 20, 'appearances': 34});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (60, 'Player 60', 'Team 20', 'Goalkeeper', 34, {'goals': 26, 'assists': 20, 'appearances': 34});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 60, 'Player 60', 'Goalkeeper', 34, {'goals': 26, 'assists': 20, 'appearances': 34});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 61', 61, 'Team 2', 'Goalkeeper', 24, {'goals': 17, 'assists': 40, 'appearances': 11});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (61, 'Player 61', 'Team 2', 'Goalkeeper', 24, {'goals': 17, 'assists': 40, 'appearances': 11});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 61, 'Player 61', 'Goalkeeper', 24, {'goals': 17, 'assists': 40, 'appearances': 11});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 62', 62, 'Team 10', 'Midfielder', 22, {'goals': 0, 'assists': 24, 'appearances': 71});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (62, 'Player 62', 'Team 10', 'Midfielder', 22, {'goals': 0, 'assists': 24, 'appearances': 71});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 62, 'Player 62', 'Midfielder', 22, {'goals': 0, 'assists': 24, 'appearances': 71});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 63', 63, 'Team 18', 'Forward', 21, {'goals': 10, 'assists': 21, 'appearances': 112});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (63, 'Player 63', 'Team 18', 'Forward', 21, {'goals': 10, 'assists': 21, 'appearances': 112});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 63, 'Player 63', 'Forward', 21, {'goals': 10, 'assists': 21, 'appearances': 112});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 64', 64, 'Team 11', 'Midfielder', 28, {'goals': 29, 'assists': 19, 'appearances': 155});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (64, 'Player 64', 'Team 11', 'Midfielder', 28, {'goals': 29, 'assists': 19, 'appearances': 155});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 64, 'Player 64', 'Midfielder', 28, {'goals': 29, 'assists': 19, 'appearances': 155});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 65', 65, 'Team 6', 'Defender', 29, {'goals': 90, 'assists': 5, 'appearances': 198});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (65, 'Player 65', 'Team 6', 'Defender', 29, {'goals': 90, 'assists': 5, 'appearances': 198});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 65, 'Player 65', 'Defender', 29, {'goals': 90, 'assists': 5, 'appearances': 198});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 66', 66, 'Team 14', 'Defender', 26, {'goals': 11, 'assists': 25, 'appearances': 114});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (66, 'Player 66', 'Team 14', 'Defender', 26, {'goals': 11, 'assists': 25, 'appearances': 114});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 14', 66, 'Player 66', 'Defender', 26, {'goals': 11, 'assists': 25, 'appearances': 114});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 67', 67, 'Team 19', 'Defender', 26, {'goals': 83, 'assists': 31, 'appearances': 100});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (67, 'Player 67', 'Team 19', 'Defender', 26, {'goals': 83, 'assists': 31, 'appearances': 100});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 67, 'Player 67', 'Defender', 26, {'goals': 83, 'assists': 31, 'appearances': 100});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 68', 68, 'Team 1', 'Defender', 25, {'goals': 65, 'assists': 7, 'appearances': 64});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (68, 'Player 68', 'Team 1', 'Defender', 25, {'goals': 65, 'assists': 7, 'appearances': 64});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 68, 'Player 68', 'Defender', 25, {'goals': 65, 'assists': 7, 'appearances': 64});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 69', 69, 'Team 3', 'Defender', 30, {'goals': 26, 'assists': 26, 'appearances': 140});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (69, 'Player 69', 'Team 3', 'Defender', 30, {'goals': 26, 'assists': 26, 'appearances': 140});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 69, 'Player 69', 'Defender', 30, {'goals': 26, 'assists': 26, 'appearances': 140});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 70', 70, 'Team 3', 'Goalkeeper', 25, {'goals': 50, 'assists': 37, 'appearances': 77});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (70, 'Player 70', 'Team 3', 'Goalkeeper', 25, {'goals': 50, 'assists': 37, 'appearances': 77});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 70, 'Player 70', 'Goalkeeper', 25, {'goals': 50, 'assists': 37, 'appearances': 77});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 71', 71, 'Team 13', 'Forward', 25, {'goals': 65, 'assists': 7, 'appearances': 86});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (71, 'Player 71', 'Team 13', 'Forward', 25, {'goals': 65, 'assists': 7, 'appearances': 86});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 13', 71, 'Player 71', 'Forward', 25, {'goals': 65, 'assists': 7, 'appearances': 86});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 72', 72, 'Team 5', 'Goalkeeper', 19, {'goals': 3, 'assists': 20, 'appearances': 43});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (72, 'Player 72', 'Team 5', 'Goalkeeper', 19, {'goals': 3, 'assists': 20, 'appearances': 43});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 72, 'Player 72', 'Goalkeeper', 19, {'goals': 3, 'assists': 20, 'appearances': 43});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 73', 73, 'Team 3', 'Midfielder', 28, {'goals': 99, 'assists': 48, 'appearances': 197});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (73, 'Player 73', 'Team 3', 'Midfielder', 28, {'goals': 99, 'assists': 48, 'appearances': 197});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 73, 'Player 73', 'Midfielder', 28, {'goals': 99, 'assists': 48, 'appearances': 197});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 74', 74, 'Team 5', 'Midfielder', 25, {'goals': 59, 'assists': 24, 'appearances': 21});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (74, 'Player 74', 'Team 5', 'Midfielder', 25, {'goals': 59, 'assists': 24, 'appearances': 21});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 74, 'Player 74', 'Midfielder', 25, {'goals': 59, 'assists': 24, 'appearances': 21});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 75', 75, 'Team 3', 'Goalkeeper', 25, {'goals': 75, 'assists': 46, 'appearances': 41});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (75, 'Player 75', 'Team 3', 'Goalkeeper', 25, {'goals': 75, 'assists': 46, 'appearances': 41});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 75, 'Player 75', 'Goalkeeper', 25, {'goals': 75, 'assists': 46, 'appearances': 41});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 76', 76, 'Team 2', 'Midfielder', 30, {'goals': 87, 'assists': 22, 'appearances': 22});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (76, 'Player 76', 'Team 2', 'Midfielder', 30, {'goals': 87, 'assists': 22, 'appearances': 22});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 76, 'Player 76', 'Midfielder', 30, {'goals': 87, 'assists': 22, 'appearances': 22});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 77', 77, 'Team 17', 'Goalkeeper', 33, {'goals': 90, 'assists': 21, 'appearances': 60});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (77, 'Player 77', 'Team 17', 'Goalkeeper', 33, {'goals': 90, 'assists': 21, 'appearances': 60});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 77, 'Player 77', 'Goalkeeper', 33, {'goals': 90, 'assists': 21, 'appearances': 60});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 78', 78, 'Team 3', 'Goalkeeper', 24, {'goals': 8, 'assists': 6, 'appearances': 89});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (78, 'Player 78', 'Team 3', 'Goalkeeper', 24, {'goals': 8, 'assists': 6, 'appearances': 89});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 78, 'Player 78', 'Goalkeeper', 24, {'goals': 8, 'assists': 6, 'appearances': 89});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 79', 79, 'Team 12', 'Goalkeeper', 20, {'goals': 94, 'assists': 45, 'appearances': 46});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (79, 'Player 79', 'Team 12', 'Goalkeeper', 20, {'goals': 94, 'assists': 45, 'appearances': 46});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 79, 'Player 79', 'Goalkeeper', 20, {'goals': 94, 'assists': 45, 'appearances': 46});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 80', 80, 'Team 5', 'Forward', 31, {'goals': 89, 'assists': 33, 'appearances': 56});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (80, 'Player 80', 'Team 5', 'Forward', 31, {'goals': 89, 'assists': 33, 'appearances': 56});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 80, 'Player 80', 'Forward', 31, {'goals': 89, 'assists': 33, 'appearances': 56});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 81', 81, 'Team 17', 'Defender', 20, {'goals': 13, 'assists': 29, 'appearances': 192});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (81, 'Player 81', 'Team 17', 'Defender', 20, {'goals': 13, 'assists': 29, 'appearances': 192});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 17', 81, 'Player 81', 'Defender', 20, {'goals': 13, 'assists': 29, 'appearances': 192});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 82', 82, 'Team 20', 'Defender', 22, {'goals': 25, 'assists': 15, 'appearances': 144});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (82, 'Player 82', 'Team 20', 'Defender', 22, {'goals': 25, 'assists': 15, 'appearances': 144});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 20', 82, 'Player 82', 'Defender', 22, {'goals': 25, 'assists': 15, 'appearances': 144});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 83', 83, 'Team 6', 'Forward', 19, {'goals': 76, 'assists': 23, 'appearances': 51});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (83, 'Player 83', 'Team 6', 'Forward', 19, {'goals': 76, 'assists': 23, 'appearances': 51});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 83, 'Player 83', 'Forward', 19, {'goals': 76, 'assists': 23, 'appearances': 51});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 84', 84, 'Team 2', 'Forward', 34, {'goals': 23, 'assists': 0, 'appearances': 199});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (84, 'Player 84', 'Team 2', 'Forward', 34, {'goals': 23, 'assists': 0, 'appearances': 199});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 84, 'Player 84', 'Forward', 34, {'goals': 23, 'assists': 0, 'appearances': 199});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 85', 85, 'Team 16', 'Midfielder', 19, {'goals': 11, 'assists': 43, 'appearances': 156});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (85, 'Player 85', 'Team 16', 'Midfielder', 19, {'goals': 11, 'assists': 43, 'appearances': 156});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 85, 'Player 85', 'Midfielder', 19, {'goals': 11, 'assists': 43, 'appearances': 156});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 86', 86, 'Team 7', 'Goalkeeper', 24, {'goals': 65, 'assists': 8, 'appearances': 183});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (86, 'Player 86', 'Team 7', 'Goalkeeper', 24, {'goals': 65, 'assists': 8, 'appearances': 183});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 86, 'Player 86', 'Goalkeeper', 24, {'goals': 65, 'assists': 8, 'appearances': 183});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 87', 87, 'Team 9', 'Forward', 22, {'goals': 98, 'assists': 25, 'appearances': 194});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (87, 'Player 87', 'Team 9', 'Forward', 22, {'goals': 98, 'assists': 25, 'appearances': 194});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 87, 'Player 87', 'Forward', 22, {'goals': 98, 'assists': 25, 'appearances': 194});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 88', 88, 'Team 8', 'Goalkeeper', 34, {'goals': 72, 'assists': 42, 'appearances': 156});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (88, 'Player 88', 'Team 8', 'Goalkeeper', 34, {'goals': 72, 'assists': 42, 'appearances': 156});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 88, 'Player 88', 'Goalkeeper', 34, {'goals': 72, 'assists': 42, 'appearances': 156});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 89', 89, 'Team 19', 'Midfielder', 27, {'goals': 90, 'assists': 17, 'appearances': 20});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (89, 'Player 89', 'Team 19', 'Midfielder', 27, {'goals': 90, 'assists': 17, 'appearances': 20});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 89, 'Player 89', 'Midfielder', 27, {'goals': 90, 'assists': 17, 'appearances': 20});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 90', 90, 'Team 6', 'Goalkeeper', 35, {'goals': 13, 'assists': 31, 'appearances': 100});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (90, 'Player 90', 'Team 6', 'Goalkeeper', 35, {'goals': 13, 'assists': 31, 'appearances': 100});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 90, 'Player 90', 'Goalkeeper', 35, {'goals': 13, 'assists': 31, 'appearances': 100});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 91', 91, 'Team 16', 'Midfielder', 22, {'goals': 27, 'assists': 46, 'appearances': 159});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (91, 'Player 91', 'Team 16', 'Midfielder', 22, {'goals': 27, 'assists': 46, 'appearances': 159});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 16', 91, 'Player 91', 'Midfielder', 22, {'goals': 27, 'assists': 46, 'appearances': 159});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 92', 92, 'Team 9', 'Midfielder', 32, {'goals': 68, 'assists': 49, 'appearances': 148});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (92, 'Player 92', 'Team 9', 'Midfielder', 32, {'goals': 68, 'assists': 49, 'appearances': 148});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 92, 'Player 92', 'Midfielder', 32, {'goals': 68, 'assists': 49, 'appearances': 148});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 93', 93, 'Team 18', 'Forward', 31, {'goals': 53, 'assists': 24, 'appearances': 158});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (93, 'Player 93', 'Team 18', 'Forward', 31, {'goals': 53, 'assists': 24, 'appearances': 158});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 18', 93, 'Player 93', 'Forward', 31, {'goals': 53, 'assists': 24, 'appearances': 158});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 94', 94, 'Team 12', 'Goalkeeper', 18, {'goals': 0, 'assists': 21, 'appearances': 90});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (94, 'Player 94', 'Team 12', 'Goalkeeper', 18, {'goals': 0, 'assists': 21, 'appearances': 90});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 12', 94, 'Player 94', 'Goalkeeper', 18, {'goals': 0, 'assists': 21, 'appearances': 90});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 95', 95, 'Team 19', 'Defender', 31, {'goals': 70, 'assists': 20, 'appearances': 106});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (95, 'Player 95', 'Team 19', 'Defender', 31, {'goals': 70, 'assists': 20, 'appearances': 106});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 19', 95, 'Player 95', 'Defender', 31, {'goals': 70, 'assists': 20, 'appearances': 106});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 96', 96, 'Team 4', 'Midfielder', 32, {'goals': 12, 'assists': 35, 'appearances': 167});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (96, 'Player 96', 'Team 4', 'Midfielder', 32, {'goals': 12, 'assists': 35, 'appearances': 167});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 96, 'Player 96', 'Midfielder', 32, {'goals': 12, 'assists': 35, 'appearances': 167});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 97', 97, 'Team 11', 'Goalkeeper', 30, {'goals': 98, 'assists': 47, 'appearances': 36});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (97, 'Player 97', 'Team 11', 'Goalkeeper', 30, {'goals': 98, 'assists': 47, 'appearances': 36});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 97, 'Player 97', 'Goalkeeper', 30, {'goals': 98, 'assists': 47, 'appearances': 36});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 98', 98, 'Team 15', 'Midfielder', 21, {'goals': 19, 'assists': 39, 'appearances': 169});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (98, 'Player 98', 'Team 15', 'Midfielder', 21, {'goals': 19, 'assists': 39, 'appearances': 169});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 15', 98, 'Player 98', 'Midfielder', 21, {'goals': 19, 'assists': 39, 'appearances': 169});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 99', 99, 'Team 11', 'Goalkeeper', 29, {'goals': 49, 'assists': 6, 'appearances': 98});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (99, 'Player 99', 'Team 11', 'Goalkeeper', 29, {'goals': 49, 'assists': 6, 'appearances': 98});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 11', 99, 'Player 99', 'Goalkeeper', 29, {'goals': 49, 'assists': 6, 'appearances': 98});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 100', 100, 'Team 3', 'Midfielder', 31, {'goals': 49, 'assists': 46, 'appearances': 200});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (100, 'Player 100', 'Team 3', 'Midfielder', 31, {'goals': 49, 'assists': 46, 'appearances': 200});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 100, 'Player 100', 'Midfielder', 31, {'goals': 49, 'assists': 46, 'appearances': 200});
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 13', '2022-01-29', 1, 3, 0, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 10', '2023-07-12', 2, 0, 2, ['Event 10', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 9', '2022-09-11', 3, 4, 0, ['Event 6', 'Event 8', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 18', '2022-02-03', 4, 3, 2, ['Event 6', 'Event 8', 'Event 1', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 9', '2023-03-04', 5, 1, 0, ['Event 6', 'Event 4', 'Event 9', 'Event 7', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 2', '2022-07-14', 6, 3, 0, ['Event 2', 'Event 9', 'Event 2', 'Event 3', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 20', '2022-05-08', 7, 3, 1, ['Event 7', 'Event 10', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 4', '2022-06-26', 8, 3, 0, ['Event 2', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 14', '2023-12-06', 9, 4, 3, ['Event 4', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 13', '2023-04-09', 10, 4, 5, ['Event 2', 'Event 8', 'Event 9', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 17', 'Team 18', '2023-06-15', 11, 0, 0, ['Event 3', 'Event 7', 'Event 3', 'Event 2', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 20', 'Team 15', '2023-04-23', 12, 1, 0, ['Event 1', 'Event 1', 'Event 7', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 4', '2022-11-15', 13, 1, 0, ['Event 9', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 16', 'Team 2', '2022-02-26', 14, 1, 2, ['Event 5', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 2', '2023-10-08', 15, 3, 3, ['Event 8', 'Event 5', 'Event 2', 'Event 6', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 11', 'Team 12', '2022-06-27', 16, 1, 5, ['Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 13', 'Team 19', '2023-03-14', 17, 0, 1, ['Event 7', 'Event 8', 'Event 1', 'Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 11', '2023-03-06', 18, 0, 5, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 8', '2023-06-12', 19, 4, 2, ['Event 8', 'Event 8', 'Event 6', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 1', '2022-06-08', 20, 3, 1, ['Event 3', 'Event 10', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 6', 'Team 11', '2022-10-24', 21, 0, 3, ['Event 6', 'Event 10', 'Event 1', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 8', 'Team 5', '2023-05-19', 22, 0, 2, ['Event 4', 'Event 5', 'Event 9', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 8', 'Team 13', '2023-03-05', 23, 2, 2, ['Event 5', 'Event 4', 'Event 1', 'Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 11', '2023-11-28', 24, 5, 2, ['Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 10', '2023-01-12', 25, 4, 2, ['Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 8', '2022-08-02', 26, 5, 4, ['Event 1']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 12', 'Team 4', '2022-02-24', 27, 2, 0, ['Event 5', 'Event 10', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 14', 'Team 20', '2022-04-24', 28, 1, 1, ['Event 10', 'Event 8', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 6', '2023-04-14', 29, 2, 4, ['Event 9', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 12', '2023-10-25', 30, 5, 2, ['Event 1', 'Event 3', 'Event 9', 'Event 2', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 20', '2023-05-29', 31, 5, 3, ['Event 4', 'Event 5', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 5', 'Team 10', '2023-03-08', 32, 1, 5, ['Event 6', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 18', 'Team 3', '2023-06-08', 33, 4, 5, ['Event 1', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 20', 'Team 15', '2022-04-16', 34, 4, 0, ['Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 3', '2022-03-21', 35, 1, 3, ['Event 7', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 6', 'Team 11', '2022-02-22', 36, 1, 2, ['Event 5', 'Event 2', 'Event 5', 'Event 8', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 19', 'Team 5', '2023-12-17', 37, 0, 1, ['Event 1', 'Event 5', 'Event 9', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 13', 'Team 16', '2023-02-17', 38, 3, 1, ['Event 1', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 17', 'Team 14', '2022-05-28', 39, 2, 3, ['Event 6', 'Event 6', 'Event 8', 'Event 2', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 17', 'Team 10', '2022-08-28', 40, 2, 3, ['Event 8', 'Event 5']);
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 1', {'Team 4', 'Team 5', 'Team 9', 'Team 2', 'Team 1', 'Team 6', 'Team 13', 'Team 17', 'Team 20', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 2', {'Team 4', 'Team 5', 'Team 15', 'Team 8', 'Team 16'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 3', {'Team 18', 'Team 15', 'Team 19', 'Team 7', 'Team 2', 'Team 13', 'Team 14', 'Team 20', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 4', {'Team 18', 'Team 4', 'Team 3', 'Team 1', 'Team 16', 'Team 17', 'Team 20', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Rome', 'League 5', {'Team 3', 'Team 8', 'Team 19', 'Team 7', 'Team 2', 'Team 1', 'Team 6', 'Team 13', 'Team 16', 'Team 14', 'Team 12', 'Team 10'});
INSERT INTO leagues (country, name, teams) VALUES ('Lisbon', 'League 6', {'Team 18', 'Team 5', 'Team 3', 'Team 9', 'Team 15', 'Team 19', 'Team 8', 'Team 2', 'Team 6', 'Team 17'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 7', {'Team 20', 'Team 9'});
