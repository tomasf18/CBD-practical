import random
from datetime import datetime, timedelta

# Constants
num_teams = 3
num_players = 30
num_matches = 20
num_leagues = 25
num_events = 40

# Helper functions for generating random data
def random_team():
    return f"Team {random.randint(1, num_teams)}"

def random_player_name():
    return f"Player {random.randint(1, num_players)}"

def random_city():
    cities = ["Madrid", "London", "Paris", "Milan", "Manchester", "Barcelona", "Lisbon", "Berlin", "Amsterdam", "Rome"]
    return random.choice(cities)

def random_position():
    positions = ["Forward", "Midfielder", "Defender", "Goalkeeper"]
    return random.choice(positions)

def random_date():
    start_date = datetime(2022, 1, 1)
    return start_date + timedelta(days=random.randint(1, 730))

def random_event():
    events = ["Goal", "Foul", "Yellow Card", "Red Card", "Substitution"]
    return random.choice(events)

# Write the CQL script
commands = f"""
-- Drop the keyspace if it exists to avoid conflicts
DROP KEYSPACE IF EXISTS football_keyspace;

-- Create keyspace
CREATE KEYSPACE football_keyspace
WITH replication = {{'class': 'SimpleStrategy', 'replication_factor': 1}};

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
"""

# Generate data and populate the database
with open("insert_data.cql", "w") as file:
    file.write(commands)
    
    # Insert data into teams
    for i in range(1, num_teams + 1):
        name = f"Team {i}"
        city = random_city()
        stadium = f"{city} Stadium"
        players = {random.randint(1, num_players) for _ in range(random.randint(3, 6))}
        achievements = [f"Achievement {random.randint(1, 5)}" for _ in range(random.randint(1, 3))]
        league_country = random_city()
        file.write(f"INSERT INTO teams (name, city, stadium, players, league_country, achievements) VALUES ('{name}', '{city}', '{stadium}', {players}, '{league_country}', {achievements});\n")
        file.write(f"INSERT INTO teams_by_league (league_country, name, city, stadium, players, achievements) VALUES ('{league_country}', '{name}', '{city}', '{stadium}', {players}, {achievements});\n")
    
    # Insert data into players
    for i in range(1, num_players + 1):
        name = f"Player {i}"
        player_id = i
        team_name = random_team()
        position = random_position()
        age = random.randint(18, 35)
        stats = {"goals": random.randint(0, 100), "assists": random.randint(0, 50), "appearances": random.randint(10, 200)}
        file.write(f"INSERT INTO players (name, player_id, team_name, position, age, stats) VALUES ('{name}', {player_id}, '{team_name}', '{position}', {age}, {stats});\n")
        file.write(f"INSERT INTO players_by_id (player_id, name, team_name, position, age, stats) VALUES ({player_id}, '{name}', '{team_name}', '{position}', {age}, {stats});\n")
        file.write(f"INSERT INTO players_by_team (team_name, player_id, name, position, age, stats) VALUES ('{team_name}', {player_id}, '{name}', '{position}', {age}, {stats});\n")
    
    # Insert data into matches
    for i in range(1, num_matches + 1):
        home_team_name = random_team()
        away_team_name = random_team()
        date = random_date().strftime('%Y-%m-%d')
        match_id = i
        goals_home = random.randint(0, 5)
        goals_away = random.randint(0, 5)
        events = [f"Event {random.randint(1, 10)}" for _ in range(random.randint(1, 5))]
        file.write(f"INSERT INTO matches (home_team_name, away_team_name, date, match_id, goals_home, goals_away, events) VALUES ('{home_team_name}', '{away_team_name}', '{date}', {match_id}, {goals_home}, {goals_away}, {events});\n")
    
    # Insert data into leagues
    for i in range(1, num_leagues + 1):
        country = random_city()
        name = f"League {i}"
        teams = {random_team() for _ in range(random.randint(2, num_teams))}
        file.write(f"INSERT INTO leagues (country, name, teams) VALUES ('{country}', '{name}', {teams});\n")

    # Insert data into match_events
    for i in range(1, num_events + 1):
        player_id = random.randint(1, num_players)
        home_team_name = random_team()
        away_team_name = random_team()
        date = random_date().strftime('%Y-%m-%d')
        event_type = random_event()
        event_time = random.randint(1, 90)
        file.write(f"INSERT INTO match_events (player_id, home_team_name, away_team_name, date, event_type, event_time) VALUES ({player_id}, '{home_team_name}', '{away_team_name}', '{date}', '{event_type}', {event_time});\n")

print("Data insertion script created: insert_data.cql")
