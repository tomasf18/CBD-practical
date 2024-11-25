
-- Drop the keyspace if it exists to avoid conflicts
DROP KEYSPACE IF EXISTS football_keyspace;

-- Create keyspace
CREATE KEYSPACE football_keyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE football_keyspace;

-- Create tables
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

CREATE INDEX ON players (position);
CREATE INDEX ON teams (stadium);

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
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 1', 'Berlin', 'Berlin Stadium', {43, 44, 46, 48, 20}, 'Barcelona', ['Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Barcelona', 'Team 1', 'Berlin', 'Berlin Stadium', {43, 44, 46, 48, 20}, ['Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 2', 'Berlin', 'Berlin Stadium', {37, 1, 19, 13}, 'Paris', ['Achievement 4', 'Achievement 2', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 2', 'Berlin', 'Berlin Stadium', {37, 1, 19, 13}, ['Achievement 4', 'Achievement 2', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 3', 'Lisbon', 'Lisbon Stadium', {8, 13, 30}, 'Rome', ['Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 3', 'Lisbon', 'Lisbon Stadium', {8, 13, 30}, ['Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 4', 'Berlin', 'Berlin Stadium', {25, 2, 38, 6}, 'Milan', ['Achievement 5', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Milan', 'Team 4', 'Berlin', 'Berlin Stadium', {25, 2, 38, 6}, ['Achievement 5', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 5', 'Manchester', 'Manchester Stadium', {50, 43, 34}, 'Barcelona', ['Achievement 1', 'Achievement 2', 'Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Barcelona', 'Team 5', 'Manchester', 'Manchester Stadium', {50, 43, 34}, ['Achievement 1', 'Achievement 2', 'Achievement 5']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 6', 'Manchester', 'Manchester Stadium', {5, 38, 42, 12, 47, 23}, 'Rome', ['Achievement 1', 'Achievement 5', 'Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 6', 'Manchester', 'Manchester Stadium', {5, 38, 42, 12, 47, 23}, ['Achievement 1', 'Achievement 5', 'Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 7', 'Manchester', 'Manchester Stadium', {33, 39, 11, 23, 27}, 'Rome', ['Achievement 2', 'Achievement 4', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Rome', 'Team 7', 'Manchester', 'Manchester Stadium', {33, 39, 11, 23, 27}, ['Achievement 2', 'Achievement 4', 'Achievement 1']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 8', 'Milan', 'Milan Stadium', {40, 28, 6, 31}, 'Manchester', ['Achievement 5', 'Achievement 4']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Manchester', 'Team 8', 'Milan', 'Milan Stadium', {40, 28, 6, 31}, ['Achievement 5', 'Achievement 4']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 9', 'Barcelona', 'Barcelona Stadium', {24, 35}, 'Berlin', ['Achievement 1', 'Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Berlin', 'Team 9', 'Barcelona', 'Barcelona Stadium', {24, 35}, ['Achievement 1', 'Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 10', 'Amsterdam', 'Amsterdam Stadium', {44, 45, 47, 28, 31}, 'Lisbon', ['Achievement 5']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Lisbon', 'Team 10', 'Amsterdam', 'Amsterdam Stadium', {44, 45, 47, 28, 31}, ['Achievement 5']);
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 1', 1, 'Team 5', 'Goalkeeper', 24, {'goals': 65, 'assists': 33, 'appearances': 12});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (1, 'Player 1', 'Team 5', 'Goalkeeper', 24, {'goals': 65, 'assists': 33, 'appearances': 12});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 1, 'Player 1', 'Goalkeeper', 24, {'goals': 65, 'assists': 33, 'appearances': 12});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 2', 2, 'Team 4', 'Defender', 28, {'goals': 12, 'assists': 30, 'appearances': 157});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (2, 'Player 2', 'Team 4', 'Defender', 28, {'goals': 12, 'assists': 30, 'appearances': 157});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 2, 'Player 2', 'Defender', 28, {'goals': 12, 'assists': 30, 'appearances': 157});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 3', 3, 'Team 8', 'Defender', 23, {'goals': 27, 'assists': 14, 'appearances': 90});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (3, 'Player 3', 'Team 8', 'Defender', 23, {'goals': 27, 'assists': 14, 'appearances': 90});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 3, 'Player 3', 'Defender', 23, {'goals': 27, 'assists': 14, 'appearances': 90});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 4', 4, 'Team 8', 'Forward', 29, {'goals': 20, 'assists': 48, 'appearances': 112});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (4, 'Player 4', 'Team 8', 'Forward', 29, {'goals': 20, 'assists': 48, 'appearances': 112});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 4, 'Player 4', 'Forward', 29, {'goals': 20, 'assists': 48, 'appearances': 112});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 5', 5, 'Team 5', 'Defender', 31, {'goals': 68, 'assists': 26, 'appearances': 90});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (5, 'Player 5', 'Team 5', 'Defender', 31, {'goals': 68, 'assists': 26, 'appearances': 90});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 5, 'Player 5', 'Defender', 31, {'goals': 68, 'assists': 26, 'appearances': 90});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 6', 6, 'Team 3', 'Midfielder', 26, {'goals': 65, 'assists': 2, 'appearances': 128});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (6, 'Player 6', 'Team 3', 'Midfielder', 26, {'goals': 65, 'assists': 2, 'appearances': 128});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 6, 'Player 6', 'Midfielder', 26, {'goals': 65, 'assists': 2, 'appearances': 128});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 7', 7, 'Team 9', 'Goalkeeper', 35, {'goals': 25, 'assists': 22, 'appearances': 181});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (7, 'Player 7', 'Team 9', 'Goalkeeper', 35, {'goals': 25, 'assists': 22, 'appearances': 181});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 7, 'Player 7', 'Goalkeeper', 35, {'goals': 25, 'assists': 22, 'appearances': 181});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 8', 8, 'Team 8', 'Forward', 20, {'goals': 14, 'assists': 24, 'appearances': 199});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (8, 'Player 8', 'Team 8', 'Forward', 20, {'goals': 14, 'assists': 24, 'appearances': 199});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 8, 'Player 8', 'Forward', 20, {'goals': 14, 'assists': 24, 'appearances': 199});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 9', 9, 'Team 5', 'Goalkeeper', 34, {'goals': 32, 'assists': 18, 'appearances': 10});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (9, 'Player 9', 'Team 5', 'Goalkeeper', 34, {'goals': 32, 'assists': 18, 'appearances': 10});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 9, 'Player 9', 'Goalkeeper', 34, {'goals': 32, 'assists': 18, 'appearances': 10});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 10', 10, 'Team 9', 'Midfielder', 19, {'goals': 45, 'assists': 34, 'appearances': 11});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (10, 'Player 10', 'Team 9', 'Midfielder', 19, {'goals': 45, 'assists': 34, 'appearances': 11});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 10, 'Player 10', 'Midfielder', 19, {'goals': 45, 'assists': 34, 'appearances': 11});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 11', 11, 'Team 7', 'Forward', 19, {'goals': 80, 'assists': 14, 'appearances': 155});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (11, 'Player 11', 'Team 7', 'Forward', 19, {'goals': 80, 'assists': 14, 'appearances': 155});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 11, 'Player 11', 'Forward', 19, {'goals': 80, 'assists': 14, 'appearances': 155});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 12', 12, 'Team 1', 'Midfielder', 32, {'goals': 41, 'assists': 20, 'appearances': 96});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (12, 'Player 12', 'Team 1', 'Midfielder', 32, {'goals': 41, 'assists': 20, 'appearances': 96});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 12, 'Player 12', 'Midfielder', 32, {'goals': 41, 'assists': 20, 'appearances': 96});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 13', 13, 'Team 2', 'Goalkeeper', 27, {'goals': 24, 'assists': 41, 'appearances': 98});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (13, 'Player 13', 'Team 2', 'Goalkeeper', 27, {'goals': 24, 'assists': 41, 'appearances': 98});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 13, 'Player 13', 'Goalkeeper', 27, {'goals': 24, 'assists': 41, 'appearances': 98});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 14', 14, 'Team 2', 'Forward', 20, {'goals': 47, 'assists': 37, 'appearances': 64});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (14, 'Player 14', 'Team 2', 'Forward', 20, {'goals': 47, 'assists': 37, 'appearances': 64});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 14, 'Player 14', 'Forward', 20, {'goals': 47, 'assists': 37, 'appearances': 64});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 15', 15, 'Team 3', 'Forward', 22, {'goals': 4, 'assists': 40, 'appearances': 47});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (15, 'Player 15', 'Team 3', 'Forward', 22, {'goals': 4, 'assists': 40, 'appearances': 47});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 15, 'Player 15', 'Forward', 22, {'goals': 4, 'assists': 40, 'appearances': 47});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 16', 16, 'Team 6', 'Goalkeeper', 20, {'goals': 16, 'assists': 47, 'appearances': 62});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (16, 'Player 16', 'Team 6', 'Goalkeeper', 20, {'goals': 16, 'assists': 47, 'appearances': 62});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 16, 'Player 16', 'Goalkeeper', 20, {'goals': 16, 'assists': 47, 'appearances': 62});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 17', 17, 'Team 4', 'Defender', 31, {'goals': 98, 'assists': 3, 'appearances': 196});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (17, 'Player 17', 'Team 4', 'Defender', 31, {'goals': 98, 'assists': 3, 'appearances': 196});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 17, 'Player 17', 'Defender', 31, {'goals': 98, 'assists': 3, 'appearances': 196});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 18', 18, 'Team 8', 'Midfielder', 30, {'goals': 63, 'assists': 46, 'appearances': 30});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (18, 'Player 18', 'Team 8', 'Midfielder', 30, {'goals': 63, 'assists': 46, 'appearances': 30});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 18, 'Player 18', 'Midfielder', 30, {'goals': 63, 'assists': 46, 'appearances': 30});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 19', 19, 'Team 10', 'Midfielder', 21, {'goals': 13, 'assists': 47, 'appearances': 16});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (19, 'Player 19', 'Team 10', 'Midfielder', 21, {'goals': 13, 'assists': 47, 'appearances': 16});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 19, 'Player 19', 'Midfielder', 21, {'goals': 13, 'assists': 47, 'appearances': 16});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 20', 20, 'Team 1', 'Defender', 22, {'goals': 86, 'assists': 19, 'appearances': 158});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (20, 'Player 20', 'Team 1', 'Defender', 22, {'goals': 86, 'assists': 19, 'appearances': 158});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 20, 'Player 20', 'Defender', 22, {'goals': 86, 'assists': 19, 'appearances': 158});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 21', 21, 'Team 5', 'Goalkeeper', 19, {'goals': 53, 'assists': 11, 'appearances': 19});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (21, 'Player 21', 'Team 5', 'Goalkeeper', 19, {'goals': 53, 'assists': 11, 'appearances': 19});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 21, 'Player 21', 'Goalkeeper', 19, {'goals': 53, 'assists': 11, 'appearances': 19});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 22', 22, 'Team 5', 'Defender', 24, {'goals': 14, 'assists': 21, 'appearances': 46});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (22, 'Player 22', 'Team 5', 'Defender', 24, {'goals': 14, 'assists': 21, 'appearances': 46});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 22, 'Player 22', 'Defender', 24, {'goals': 14, 'assists': 21, 'appearances': 46});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 23', 23, 'Team 4', 'Goalkeeper', 33, {'goals': 94, 'assists': 27, 'appearances': 69});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (23, 'Player 23', 'Team 4', 'Goalkeeper', 33, {'goals': 94, 'assists': 27, 'appearances': 69});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 23, 'Player 23', 'Goalkeeper', 33, {'goals': 94, 'assists': 27, 'appearances': 69});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 24', 24, 'Team 8', 'Goalkeeper', 28, {'goals': 11, 'assists': 21, 'appearances': 49});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (24, 'Player 24', 'Team 8', 'Goalkeeper', 28, {'goals': 11, 'assists': 21, 'appearances': 49});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 24, 'Player 24', 'Goalkeeper', 28, {'goals': 11, 'assists': 21, 'appearances': 49});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 25', 25, 'Team 9', 'Forward', 33, {'goals': 44, 'assists': 45, 'appearances': 159});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (25, 'Player 25', 'Team 9', 'Forward', 33, {'goals': 44, 'assists': 45, 'appearances': 159});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 25, 'Player 25', 'Forward', 33, {'goals': 44, 'assists': 45, 'appearances': 159});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 26', 26, 'Team 3', 'Midfielder', 24, {'goals': 19, 'assists': 45, 'appearances': 34});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (26, 'Player 26', 'Team 3', 'Midfielder', 24, {'goals': 19, 'assists': 45, 'appearances': 34});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 26, 'Player 26', 'Midfielder', 24, {'goals': 19, 'assists': 45, 'appearances': 34});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 27', 27, 'Team 7', 'Defender', 24, {'goals': 92, 'assists': 9, 'appearances': 189});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (27, 'Player 27', 'Team 7', 'Defender', 24, {'goals': 92, 'assists': 9, 'appearances': 189});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 27, 'Player 27', 'Defender', 24, {'goals': 92, 'assists': 9, 'appearances': 189});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 28', 28, 'Team 1', 'Midfielder', 34, {'goals': 68, 'assists': 47, 'appearances': 97});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (28, 'Player 28', 'Team 1', 'Midfielder', 34, {'goals': 68, 'assists': 47, 'appearances': 97});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 28, 'Player 28', 'Midfielder', 34, {'goals': 68, 'assists': 47, 'appearances': 97});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 29', 29, 'Team 6', 'Defender', 20, {'goals': 94, 'assists': 25, 'appearances': 90});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (29, 'Player 29', 'Team 6', 'Defender', 20, {'goals': 94, 'assists': 25, 'appearances': 90});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 29, 'Player 29', 'Defender', 20, {'goals': 94, 'assists': 25, 'appearances': 90});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 30', 30, 'Team 8', 'Defender', 24, {'goals': 66, 'assists': 38, 'appearances': 154});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (30, 'Player 30', 'Team 8', 'Defender', 24, {'goals': 66, 'assists': 38, 'appearances': 154});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 30, 'Player 30', 'Defender', 24, {'goals': 66, 'assists': 38, 'appearances': 154});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 31', 31, 'Team 4', 'Goalkeeper', 32, {'goals': 91, 'assists': 50, 'appearances': 62});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (31, 'Player 31', 'Team 4', 'Goalkeeper', 32, {'goals': 91, 'assists': 50, 'appearances': 62});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 31, 'Player 31', 'Goalkeeper', 32, {'goals': 91, 'assists': 50, 'appearances': 62});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 32', 32, 'Team 4', 'Defender', 19, {'goals': 76, 'assists': 49, 'appearances': 120});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (32, 'Player 32', 'Team 4', 'Defender', 19, {'goals': 76, 'assists': 49, 'appearances': 120});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 32, 'Player 32', 'Defender', 19, {'goals': 76, 'assists': 49, 'appearances': 120});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 33', 33, 'Team 4', 'Midfielder', 32, {'goals': 70, 'assists': 28, 'appearances': 18});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (33, 'Player 33', 'Team 4', 'Midfielder', 32, {'goals': 70, 'assists': 28, 'appearances': 18});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 33, 'Player 33', 'Midfielder', 32, {'goals': 70, 'assists': 28, 'appearances': 18});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 34', 34, 'Team 10', 'Defender', 22, {'goals': 4, 'assists': 37, 'appearances': 17});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (34, 'Player 34', 'Team 10', 'Defender', 22, {'goals': 4, 'assists': 37, 'appearances': 17});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 10', 34, 'Player 34', 'Defender', 22, {'goals': 4, 'assists': 37, 'appearances': 17});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 35', 35, 'Team 6', 'Forward', 19, {'goals': 18, 'assists': 36, 'appearances': 123});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (35, 'Player 35', 'Team 6', 'Forward', 19, {'goals': 18, 'assists': 36, 'appearances': 123});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 6', 35, 'Player 35', 'Forward', 19, {'goals': 18, 'assists': 36, 'appearances': 123});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 36', 36, 'Team 8', 'Midfielder', 21, {'goals': 32, 'assists': 20, 'appearances': 21});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (36, 'Player 36', 'Team 8', 'Midfielder', 21, {'goals': 32, 'assists': 20, 'appearances': 21});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 36, 'Player 36', 'Midfielder', 21, {'goals': 32, 'assists': 20, 'appearances': 21});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 37', 37, 'Team 4', 'Midfielder', 29, {'goals': 46, 'assists': 43, 'appearances': 51});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (37, 'Player 37', 'Team 4', 'Midfielder', 29, {'goals': 46, 'assists': 43, 'appearances': 51});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 37, 'Player 37', 'Midfielder', 29, {'goals': 46, 'assists': 43, 'appearances': 51});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 38', 38, 'Team 1', 'Goalkeeper', 20, {'goals': 40, 'assists': 37, 'appearances': 137});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (38, 'Player 38', 'Team 1', 'Goalkeeper', 20, {'goals': 40, 'assists': 37, 'appearances': 137});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 38, 'Player 38', 'Goalkeeper', 20, {'goals': 40, 'assists': 37, 'appearances': 137});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 39', 39, 'Team 9', 'Defender', 23, {'goals': 97, 'assists': 38, 'appearances': 89});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (39, 'Player 39', 'Team 9', 'Defender', 23, {'goals': 97, 'assists': 38, 'appearances': 89});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 39, 'Player 39', 'Defender', 23, {'goals': 97, 'assists': 38, 'appearances': 89});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 40', 40, 'Team 8', 'Midfielder', 35, {'goals': 6, 'assists': 4, 'appearances': 131});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (40, 'Player 40', 'Team 8', 'Midfielder', 35, {'goals': 6, 'assists': 4, 'appearances': 131});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 40, 'Player 40', 'Midfielder', 35, {'goals': 6, 'assists': 4, 'appearances': 131});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 41', 41, 'Team 8', 'Midfielder', 26, {'goals': 39, 'assists': 40, 'appearances': 59});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (41, 'Player 41', 'Team 8', 'Midfielder', 26, {'goals': 39, 'assists': 40, 'appearances': 59});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 8', 41, 'Player 41', 'Midfielder', 26, {'goals': 39, 'assists': 40, 'appearances': 59});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 42', 42, 'Team 9', 'Goalkeeper', 26, {'goals': 39, 'assists': 11, 'appearances': 98});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (42, 'Player 42', 'Team 9', 'Goalkeeper', 26, {'goals': 39, 'assists': 11, 'appearances': 98});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 9', 42, 'Player 42', 'Goalkeeper', 26, {'goals': 39, 'assists': 11, 'appearances': 98});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 43', 43, 'Team 3', 'Goalkeeper', 29, {'goals': 68, 'assists': 31, 'appearances': 152});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (43, 'Player 43', 'Team 3', 'Goalkeeper', 29, {'goals': 68, 'assists': 31, 'appearances': 152});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 43, 'Player 43', 'Goalkeeper', 29, {'goals': 68, 'assists': 31, 'appearances': 152});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 44', 44, 'Team 1', 'Midfielder', 18, {'goals': 92, 'assists': 15, 'appearances': 171});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (44, 'Player 44', 'Team 1', 'Midfielder', 18, {'goals': 92, 'assists': 15, 'appearances': 171});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 44, 'Player 44', 'Midfielder', 18, {'goals': 92, 'assists': 15, 'appearances': 171});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 45', 45, 'Team 4', 'Midfielder', 23, {'goals': 66, 'assists': 19, 'appearances': 13});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (45, 'Player 45', 'Team 4', 'Midfielder', 23, {'goals': 66, 'assists': 19, 'appearances': 13});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 4', 45, 'Player 45', 'Midfielder', 23, {'goals': 66, 'assists': 19, 'appearances': 13});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 46', 46, 'Team 7', 'Forward', 19, {'goals': 32, 'assists': 45, 'appearances': 18});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (46, 'Player 46', 'Team 7', 'Forward', 19, {'goals': 32, 'assists': 45, 'appearances': 18});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 46, 'Player 46', 'Forward', 19, {'goals': 32, 'assists': 45, 'appearances': 18});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 47', 47, 'Team 5', 'Goalkeeper', 30, {'goals': 91, 'assists': 18, 'appearances': 187});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (47, 'Player 47', 'Team 5', 'Goalkeeper', 30, {'goals': 91, 'assists': 18, 'appearances': 187});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 5', 47, 'Player 47', 'Goalkeeper', 30, {'goals': 91, 'assists': 18, 'appearances': 187});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 48', 48, 'Team 7', 'Midfielder', 28, {'goals': 8, 'assists': 3, 'appearances': 87});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (48, 'Player 48', 'Team 7', 'Midfielder', 28, {'goals': 8, 'assists': 3, 'appearances': 87});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 48, 'Player 48', 'Midfielder', 28, {'goals': 8, 'assists': 3, 'appearances': 87});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 49', 49, 'Team 7', 'Defender', 21, {'goals': 29, 'assists': 42, 'appearances': 120});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (49, 'Player 49', 'Team 7', 'Defender', 21, {'goals': 29, 'assists': 42, 'appearances': 120});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 7', 49, 'Player 49', 'Defender', 21, {'goals': 29, 'assists': 42, 'appearances': 120});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 50', 50, 'Team 2', 'Midfielder', 27, {'goals': 82, 'assists': 8, 'appearances': 68});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (50, 'Player 50', 'Team 2', 'Midfielder', 27, {'goals': 82, 'assists': 8, 'appearances': 68});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 50, 'Player 50', 'Midfielder', 27, {'goals': 82, 'assists': 8, 'appearances': 68});
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 6', '2023-07-31', 1, 2, 2, ['Event 1', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 7', '2023-07-03', 2, 2, 2, ['Event 9', 'Event 2', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 3', '2022-01-16', 3, 4, 2, ['Event 6', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 3', '2022-05-31', 4, 3, 1, ['Event 3', 'Event 5', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 6', '2022-02-10', 5, 4, 5, ['Event 1', 'Event 1', 'Event 8', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 9', '2022-08-21', 6, 2, 1, ['Event 1', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 9', '2023-10-10', 7, 1, 3, ['Event 10', 'Event 2', 'Event 3', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 2', '2023-02-24', 8, 0, 4, ['Event 4', 'Event 10', 'Event 6', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 1', '2022-01-25', 9, 1, 3, ['Event 10', 'Event 10', 'Event 1', 'Event 1', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 7', '2022-12-20', 10, 3, 1, ['Event 5', 'Event 10', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 3', '2022-02-14', 11, 3, 2, ['Event 8', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 9', '2023-01-29', 12, 1, 4, ['Event 7', 'Event 2', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 5', '2022-07-27', 13, 5, 3, ['Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 4', '2023-03-03', 14, 3, 4, ['Event 1', 'Event 2', 'Event 3']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 7', 'Team 1', '2022-02-06', 15, 2, 5, ['Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 9', 'Team 6', '2022-07-14', 16, 2, 0, ['Event 9', 'Event 5', 'Event 1', 'Event 7', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 10', '2023-02-01', 17, 0, 0, ['Event 6', 'Event 6', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 8', 'Team 9', '2023-07-04', 18, 1, 1, ['Event 6', 'Event 9', 'Event 6', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 10', 'Team 7', '2023-12-25', 19, 5, 1, ['Event 7', 'Event 4', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 4', 'Team 6', '2023-12-14', 20, 5, 0, ['Event 4', 'Event 8', 'Event 8']);
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 1', {'Team 10', 'Team 3', 'Team 4', 'Team 5', 'Team 9'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 2', {'Team 1', 'Team 7', 'Team 4', 'Team 6', 'Team 5'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 3', {'Team 9', 'Team 2', 'Team 6', 'Team 7'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 4', {'Team 8', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Lisbon', 'League 5', {'Team 10', 'Team 4'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 6', {'Team 10', 'Team 1', 'Team 2', 'Team 7'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 7', {'Team 2', 'Team 6'});
INSERT INTO leagues (country, name, teams) VALUES ('Milan', 'League 8', {'Team 4', 'Team 2', 'Team 3', 'Team 8'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 9', {'Team 1', 'Team 8', 'Team 3', 'Team 4', 'Team 2'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 10', {'Team 7', 'Team 4', 'Team 8', 'Team 5'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 11', {'Team 1', 'Team 8', 'Team 3', 'Team 7', 'Team 5', 'Team 9'});
INSERT INTO leagues (country, name, teams) VALUES ('Madrid', 'League 12', {'Team 10', 'Team 1', 'Team 3', 'Team 6', 'Team 5'});
INSERT INTO leagues (country, name, teams) VALUES ('Milan', 'League 13', {'Team 10', 'Team 3', 'Team 4', 'Team 5', 'Team 2'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 14', {'Team 2', 'Team 7'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 15', {'Team 1', 'Team 4', 'Team 5', 'Team 2', 'Team 9'});
INSERT INTO leagues (country, name, teams) VALUES ('Lisbon', 'League 16', {'Team 2', 'Team 9', 'Team 6'});
INSERT INTO leagues (country, name, teams) VALUES ('Berlin', 'League 17', {'Team 3', 'Team 5'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 18', {'Team 3', 'Team 7', 'Team 4', 'Team 6', 'Team 5'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 19', {'Team 3', 'Team 7', 'Team 4', 'Team 6', 'Team 5', 'Team 2'});
INSERT INTO leagues (country, name, teams) VALUES ('Milan', 'League 20', {'Team 8', 'Team 6'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 21', {'Team 1', 'Team 9', 'Team 6', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 22', {'Team 9', 'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 23', {'Team 6'});
INSERT INTO leagues (country, name, teams) VALUES ('Berlin', 'League 24', {'Team 10', 'Team 4', 'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 25', {'Team 1', 'Team 8'});
