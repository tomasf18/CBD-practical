
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

CREATE TABLE match_events (
    player_id           INT,
    home_team_name      TEXT,
    away_team_name      TEXT,
    date                DATE,
    event_type          TEXT,
    event_time          INT, -- Minute
    PRIMARY KEY ((player_id, home_team_name, away_team_name, date))
);

CREATE INDEX ON players (position);
CREATE INDEX ON teams (stadium);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 1', 'Amsterdam', 'Amsterdam Stadium', {26, 3, 20}, 'London', ['Achievement 2']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('London', 'Team 1', 'Amsterdam', 'Amsterdam Stadium', {26, 3, 20}, ['Achievement 2']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 2', 'Manchester', 'Manchester Stadium', {18, 11, 21, 30}, 'Paris', ['Achievement 3']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Paris', 'Team 2', 'Manchester', 'Manchester Stadium', {18, 11, 21, 30}, ['Achievement 3']);
INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('Team 3', 'Barcelona', 'Barcelona Stadium', {11, 21, 14}, 'Madrid', ['Achievement 5', 'Achievement 5', 'Achievement 1']);
INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('Madrid', 'Team 3', 'Barcelona', 'Barcelona Stadium', {11, 21, 14}, ['Achievement 5', 'Achievement 5', 'Achievement 1']);
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 1', 1, 'Team 3', 'Forward', 30, {'goals': 25, 'assists': 0, 'appearances': 36});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (1, 'Player 1', 'Team 3', 'Forward', 30, {'goals': 25, 'assists': 0, 'appearances': 36});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 1, 'Player 1', 'Forward', 30, {'goals': 25, 'assists': 0, 'appearances': 36});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 2', 2, 'Team 3', 'Midfielder', 33, {'goals': 76, 'assists': 21, 'appearances': 187});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (2, 'Player 2', 'Team 3', 'Midfielder', 33, {'goals': 76, 'assists': 21, 'appearances': 187});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 2, 'Player 2', 'Midfielder', 33, {'goals': 76, 'assists': 21, 'appearances': 187});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 3', 3, 'Team 2', 'Defender', 28, {'goals': 45, 'assists': 11, 'appearances': 38});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (3, 'Player 3', 'Team 2', 'Defender', 28, {'goals': 45, 'assists': 11, 'appearances': 38});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 3, 'Player 3', 'Defender', 28, {'goals': 45, 'assists': 11, 'appearances': 38});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 4', 4, 'Team 2', 'Forward', 27, {'goals': 98, 'assists': 13, 'appearances': 189});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (4, 'Player 4', 'Team 2', 'Forward', 27, {'goals': 98, 'assists': 13, 'appearances': 189});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 4, 'Player 4', 'Forward', 27, {'goals': 98, 'assists': 13, 'appearances': 189});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 5', 5, 'Team 3', 'Forward', 33, {'goals': 47, 'assists': 21, 'appearances': 94});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (5, 'Player 5', 'Team 3', 'Forward', 33, {'goals': 47, 'assists': 21, 'appearances': 94});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 5, 'Player 5', 'Forward', 33, {'goals': 47, 'assists': 21, 'appearances': 94});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 6', 6, 'Team 2', 'Forward', 25, {'goals': 46, 'assists': 35, 'appearances': 188});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (6, 'Player 6', 'Team 2', 'Forward', 25, {'goals': 46, 'assists': 35, 'appearances': 188});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 6, 'Player 6', 'Forward', 25, {'goals': 46, 'assists': 35, 'appearances': 188});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 7', 7, 'Team 1', 'Goalkeeper', 30, {'goals': 66, 'assists': 44, 'appearances': 63});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (7, 'Player 7', 'Team 1', 'Goalkeeper', 30, {'goals': 66, 'assists': 44, 'appearances': 63});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 7, 'Player 7', 'Goalkeeper', 30, {'goals': 66, 'assists': 44, 'appearances': 63});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 8', 8, 'Team 1', 'Midfielder', 33, {'goals': 68, 'assists': 38, 'appearances': 91});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (8, 'Player 8', 'Team 1', 'Midfielder', 33, {'goals': 68, 'assists': 38, 'appearances': 91});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 8, 'Player 8', 'Midfielder', 33, {'goals': 68, 'assists': 38, 'appearances': 91});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 9', 9, 'Team 3', 'Goalkeeper', 33, {'goals': 14, 'assists': 0, 'appearances': 33});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (9, 'Player 9', 'Team 3', 'Goalkeeper', 33, {'goals': 14, 'assists': 0, 'appearances': 33});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 9, 'Player 9', 'Goalkeeper', 33, {'goals': 14, 'assists': 0, 'appearances': 33});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 10', 10, 'Team 3', 'Midfielder', 20, {'goals': 8, 'assists': 45, 'appearances': 129});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (10, 'Player 10', 'Team 3', 'Midfielder', 20, {'goals': 8, 'assists': 45, 'appearances': 129});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 10, 'Player 10', 'Midfielder', 20, {'goals': 8, 'assists': 45, 'appearances': 129});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 11', 11, 'Team 3', 'Defender', 30, {'goals': 51, 'assists': 9, 'appearances': 199});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (11, 'Player 11', 'Team 3', 'Defender', 30, {'goals': 51, 'assists': 9, 'appearances': 199});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 11, 'Player 11', 'Defender', 30, {'goals': 51, 'assists': 9, 'appearances': 199});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 12', 12, 'Team 2', 'Midfielder', 34, {'goals': 32, 'assists': 29, 'appearances': 47});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (12, 'Player 12', 'Team 2', 'Midfielder', 34, {'goals': 32, 'assists': 29, 'appearances': 47});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 12, 'Player 12', 'Midfielder', 34, {'goals': 32, 'assists': 29, 'appearances': 47});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 13', 13, 'Team 2', 'Defender', 32, {'goals': 83, 'assists': 28, 'appearances': 138});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (13, 'Player 13', 'Team 2', 'Defender', 32, {'goals': 83, 'assists': 28, 'appearances': 138});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 13, 'Player 13', 'Defender', 32, {'goals': 83, 'assists': 28, 'appearances': 138});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 14', 14, 'Team 3', 'Forward', 27, {'goals': 5, 'assists': 5, 'appearances': 99});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (14, 'Player 14', 'Team 3', 'Forward', 27, {'goals': 5, 'assists': 5, 'appearances': 99});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 14, 'Player 14', 'Forward', 27, {'goals': 5, 'assists': 5, 'appearances': 99});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 15', 15, 'Team 3', 'Forward', 34, {'goals': 36, 'assists': 13, 'appearances': 108});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (15, 'Player 15', 'Team 3', 'Forward', 34, {'goals': 36, 'assists': 13, 'appearances': 108});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 15, 'Player 15', 'Forward', 34, {'goals': 36, 'assists': 13, 'appearances': 108});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 16', 16, 'Team 1', 'Defender', 29, {'goals': 49, 'assists': 43, 'appearances': 112});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (16, 'Player 16', 'Team 1', 'Defender', 29, {'goals': 49, 'assists': 43, 'appearances': 112});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 16, 'Player 16', 'Defender', 29, {'goals': 49, 'assists': 43, 'appearances': 112});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 17', 17, 'Team 3', 'Forward', 27, {'goals': 46, 'assists': 49, 'appearances': 85});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (17, 'Player 17', 'Team 3', 'Forward', 27, {'goals': 46, 'assists': 49, 'appearances': 85});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 17, 'Player 17', 'Forward', 27, {'goals': 46, 'assists': 49, 'appearances': 85});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 18', 18, 'Team 2', 'Forward', 28, {'goals': 27, 'assists': 3, 'appearances': 159});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (18, 'Player 18', 'Team 2', 'Forward', 28, {'goals': 27, 'assists': 3, 'appearances': 159});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 18, 'Player 18', 'Forward', 28, {'goals': 27, 'assists': 3, 'appearances': 159});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 19', 19, 'Team 1', 'Defender', 32, {'goals': 74, 'assists': 46, 'appearances': 90});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (19, 'Player 19', 'Team 1', 'Defender', 32, {'goals': 74, 'assists': 46, 'appearances': 90});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 19, 'Player 19', 'Defender', 32, {'goals': 74, 'assists': 46, 'appearances': 90});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 20', 20, 'Team 1', 'Goalkeeper', 23, {'goals': 66, 'assists': 39, 'appearances': 193});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (20, 'Player 20', 'Team 1', 'Goalkeeper', 23, {'goals': 66, 'assists': 39, 'appearances': 193});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 20, 'Player 20', 'Goalkeeper', 23, {'goals': 66, 'assists': 39, 'appearances': 193});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 21', 21, 'Team 1', 'Goalkeeper', 29, {'goals': 90, 'assists': 48, 'appearances': 82});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (21, 'Player 21', 'Team 1', 'Goalkeeper', 29, {'goals': 90, 'assists': 48, 'appearances': 82});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 21, 'Player 21', 'Goalkeeper', 29, {'goals': 90, 'assists': 48, 'appearances': 82});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 22', 22, 'Team 2', 'Forward', 18, {'goals': 3, 'assists': 50, 'appearances': 94});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (22, 'Player 22', 'Team 2', 'Forward', 18, {'goals': 3, 'assists': 50, 'appearances': 94});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 22, 'Player 22', 'Forward', 18, {'goals': 3, 'assists': 50, 'appearances': 94});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 23', 23, 'Team 2', 'Goalkeeper', 26, {'goals': 54, 'assists': 29, 'appearances': 82});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (23, 'Player 23', 'Team 2', 'Goalkeeper', 26, {'goals': 54, 'assists': 29, 'appearances': 82});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 23, 'Player 23', 'Goalkeeper', 26, {'goals': 54, 'assists': 29, 'appearances': 82});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 24', 24, 'Team 2', 'Forward', 27, {'goals': 35, 'assists': 48, 'appearances': 53});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (24, 'Player 24', 'Team 2', 'Forward', 27, {'goals': 35, 'assists': 48, 'appearances': 53});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 24, 'Player 24', 'Forward', 27, {'goals': 35, 'assists': 48, 'appearances': 53});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 25', 25, 'Team 1', 'Defender', 27, {'goals': 27, 'assists': 19, 'appearances': 193});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (25, 'Player 25', 'Team 1', 'Defender', 27, {'goals': 27, 'assists': 19, 'appearances': 193});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 1', 25, 'Player 25', 'Defender', 27, {'goals': 27, 'assists': 19, 'appearances': 193});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 26', 26, 'Team 3', 'Forward', 30, {'goals': 93, 'assists': 43, 'appearances': 101});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (26, 'Player 26', 'Team 3', 'Forward', 30, {'goals': 93, 'assists': 43, 'appearances': 101});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 26, 'Player 26', 'Forward', 30, {'goals': 93, 'assists': 43, 'appearances': 101});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 27', 27, 'Team 3', 'Defender', 30, {'goals': 93, 'assists': 42, 'appearances': 157});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (27, 'Player 27', 'Team 3', 'Defender', 30, {'goals': 93, 'assists': 42, 'appearances': 157});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 3', 27, 'Player 27', 'Defender', 30, {'goals': 93, 'assists': 42, 'appearances': 157});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 28', 28, 'Team 2', 'Defender', 23, {'goals': 71, 'assists': 20, 'appearances': 172});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (28, 'Player 28', 'Team 2', 'Defender', 23, {'goals': 71, 'assists': 20, 'appearances': 172});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 28, 'Player 28', 'Defender', 23, {'goals': 71, 'assists': 20, 'appearances': 172});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 29', 29, 'Team 2', 'Midfielder', 21, {'goals': 87, 'assists': 19, 'appearances': 69});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (29, 'Player 29', 'Team 2', 'Midfielder', 21, {'goals': 87, 'assists': 19, 'appearances': 69});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 29, 'Player 29', 'Midfielder', 21, {'goals': 87, 'assists': 19, 'appearances': 69});
INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('Player 30', 30, 'Team 2', 'Forward', 20, {'goals': 92, 'assists': 9, 'appearances': 183});
INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES (30, 'Player 30', 'Team 2', 'Forward', 20, {'goals': 92, 'assists': 9, 'appearances': 183});
INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('Team 2', 30, 'Player 30', 'Forward', 20, {'goals': 92, 'assists': 9, 'appearances': 183});
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 3', '2022-07-16', 1, 1, 5, ['Event 7', 'Event 3', 'Event 9', 'Event 5', 'Event 6']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 2', '2023-05-25', 2, 5, 4, ['Event 4', 'Event 7', 'Event 3', 'Event 3', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 2', '2023-05-21', 3, 3, 0, ['Event 8', 'Event 2']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 2', '2023-10-13', 4, 3, 3, ['Event 3', 'Event 8', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 1', '2023-12-05', 5, 1, 3, ['Event 3', 'Event 7', 'Event 3', 'Event 9', 'Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 3', '2022-03-22', 6, 4, 3, ['Event 9', 'Event 10', 'Event 7', 'Event 10', 'Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 3', '2022-12-22', 7, 4, 5, ['Event 4', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 1', '2022-01-08', 8, 5, 1, ['Event 3', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 3', '2023-07-13', 9, 3, 4, ['Event 1', 'Event 1', 'Event 8', 'Event 3', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 1', '2022-09-22', 10, 4, 2, ['Event 7']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 2', '2022-01-14', 11, 1, 4, ['Event 8', 'Event 10', 'Event 1', 'Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 1', '2023-07-28', 12, 4, 0, ['Event 9']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 2', '2023-07-28', 13, 2, 1, ['Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 3', '2022-11-19', 14, 5, 2, ['Event 4', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 1', '2023-10-28', 15, 1, 4, ['Event 8']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 3', '2022-12-06', 16, 2, 4, ['Event 3', 'Event 10', 'Event 4']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 2', '2023-04-15', 17, 1, 2, ['Event 7', 'Event 9', 'Event 4', 'Event 5', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 1', 'Team 3', '2023-05-02', 18, 0, 2, ['Event 3', 'Event 5']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 3', 'Team 3', '2022-05-15', 19, 5, 5, ['Event 7', 'Event 9', 'Event 10']);
INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('Team 2', 'Team 1', '2023-10-11', 20, 2, 0, ['Event 6']);
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 1', {'Team 2', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Rome', 'League 2', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Berlin', 'League 3', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 4', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 5', {'Team 2', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 6', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Lisbon', 'League 7', {'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 8', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Manchester', 'League 9', {'Team 2', 'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 10', {'Team 2', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 11', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 12', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Amsterdam', 'League 13', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 14', {'Team 2', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Berlin', 'League 15', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Madrid', 'League 16', {'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 17', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 18', {'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Madrid', 'League 19', {'Team 2', 'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Barcelona', 'League 20', {'Team 1', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 21', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('London', 'League 22', {'Team 2', 'Team 1'});
INSERT INTO leagues (country, name, teams) VALUES ('Lisbon', 'League 23', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Rome', 'League 24', {'Team 2', 'Team 3'});
INSERT INTO leagues (country, name, teams) VALUES ('Paris', 'League 25', {'Team 2', 'Team 1'});
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (24, 'Team 2', 'Team 1', '2022-06-11', 'Goal', 60);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (25, 'Team 3', 'Team 3', '2023-04-17', 'Substitution', 44);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (18, 'Team 1', 'Team 3', '2022-12-22', 'Yellow Card', 85);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (1, 'Team 1', 'Team 1', '2022-03-31', 'Foul', 46);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (27, 'Team 3', 'Team 3', '2023-08-19', 'Foul', 3);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (20, 'Team 3', 'Team 2', '2022-01-04', 'Goal', 10);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (10, 'Team 2', 'Team 3', '2023-05-24', 'Red Card', 5);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (19, 'Team 2', 'Team 1', '2022-08-04', 'Yellow Card', 87);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (24, 'Team 3', 'Team 3', '2022-04-10', 'Red Card', 53);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (17, 'Team 2', 'Team 3', '2023-10-07', 'Yellow Card', 73);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (26, 'Team 2', 'Team 1', '2022-02-24', 'Goal', 74);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (3, 'Team 1', 'Team 3', '2022-04-03', 'Yellow Card', 85);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (13, 'Team 3', 'Team 1', '2023-03-27', 'Substitution', 13);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (8, 'Team 1', 'Team 1', '2022-10-30', 'Red Card', 6);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (2, 'Team 3', 'Team 1', '2023-10-22', 'Goal', 86);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (17, 'Team 2', 'Team 1', '2022-09-17', 'Red Card', 30);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (25, 'Team 1', 'Team 1', '2023-10-20', 'Foul', 6);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (29, 'Team 3', 'Team 2', '2022-08-06', 'Red Card', 83);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (22, 'Team 2', 'Team 1', '2023-08-20', 'Substitution', 42);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (27, 'Team 1', 'Team 1', '2022-05-22', 'Yellow Card', 20);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (15, 'Team 3', 'Team 1', '2023-10-20', 'Red Card', 74);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (27, 'Team 2', 'Team 1', '2023-12-24', 'Yellow Card', 71);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (30, 'Team 3', 'Team 2', '2022-03-21', 'Goal', 42);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (29, 'Team 3', 'Team 1', '2023-10-10', 'Substitution', 12);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (4, 'Team 3', 'Team 2', '2023-08-04', 'Substitution', 7);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (22, 'Team 1', 'Team 1', '2023-10-20', 'Goal', 70);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (5, 'Team 3', 'Team 3', '2023-06-28', 'Red Card', 27);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (18, 'Team 3', 'Team 1', '2023-05-21', 'Goal', 87);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (25, 'Team 3', 'Team 1', '2022-03-01', 'Red Card', 20);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (21, 'Team 3', 'Team 1', '2023-05-26', 'Substitution', 44);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (19, 'Team 3', 'Team 2', '2023-05-12', 'Foul', 46);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (11, 'Team 2', 'Team 3', '2023-03-29', 'Yellow Card', 46);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (13, 'Team 2', 'Team 1', '2023-07-31', 'Goal', 72);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (10, 'Team 3', 'Team 1', '2023-11-07', 'Foul', 40);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (23, 'Team 1', 'Team 2', '2023-08-23', 'Yellow Card', 52);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (16, 'Team 1', 'Team 2', '2022-03-27', 'Red Card', 61);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (30, 'Team 1', 'Team 3', '2023-03-02', 'Goal', 6);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (22, 'Team 3', 'Team 2', '2022-11-29', 'Foul', 64);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (14, 'Team 3', 'Team 2', '2022-10-07', 'Substitution', 80);
INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES (27, 'Team 2', 'Team 2', '2022-07-24', 'Yellow Card', 88);
