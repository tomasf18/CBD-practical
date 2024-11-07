import random
from datetime import datetime, timedelta

# Define the number of records to generate for each table
num_users = 17
num_videos = 25
num_comments = 30
num_followers = 15
num_events = 30
num_ratings = 30

commands = f"""
-- Drop the keyspace if it exists to avoid conflicts
DROP KEYSPACE IF EXISTS partilha_videos;

-- Create keyspace
CREATE KEYSPACE partilha_videos 
WITH replication = {{'class': 'SimpleStrategy', 'replication_factor': 1}};

USE partilha_videos;

-- Create tables
CREATE TABLE utilizadores (
    username        TEXT PRIMARY KEY,
    nome            TEXT,
    email           TEXT,
    data_registo    TIMESTAMP
);

CREATE TABLE videos (
    video_id            INT, 
    autor_username      TEXT, 
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((video_id), autor_username)
);

CREATE TABLE videos_por_data (
    video_id            INT, 
    autor_username      TEXT,
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((data_upload), video_id)
) WITH CLUSTERING ORDER BY (data_upload DESC);

CREATE TABLE videos_autor (
    autor_username      TEXT, 
    video_id            INT, 
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((autor_username), data_upload, video_id)
);

CREATE TABLE comentarios_por_video (
    video_id            INT,
    autor_username      TEXT,
    data_comentario     TIMESTAMP,
    comentario          TEXT,
    PRIMARY KEY ((video_id), data_comentario)
) WITH CLUSTERING ORDER BY (data_comentario DESC);

CREATE TABLE comentarios_por_utilizador (
    autor_username      TEXT,
    data_comentario     TIMESTAMP,
    video_id            INT,
    comentario          TEXT,
    PRIMARY KEY ((autor_username), video_id, data_comentario)
) WITH CLUSTERING ORDER BY (video_id ASC, data_comentario DESC);

CREATE TABLE seguidores_video (
    video_id            INT,
    username            TEXT,
    PRIMARY KEY ((video_id), username)
);

CREATE TABLE eventos_video (
    username            TEXT,
    video_id            INT, 
    tipo_evento         TEXT,
    data_evento         TIMESTAMP,
    tempo_video         INT,
    PRIMARY KEY ((username), video_id, data_evento, tempo_video)
);

CREATE TABLE ratings_video (
    video_id            INT,
    autor_rating        TEXT,
    data_rating         TIMESTAMP,
    rating              INT,
    PRIMARY KEY ((video_id), autor_rating, data_rating)
);
"""

# Helper functions to generate random data
def random_username():
    return f"user{random.randint(1, num_users)}"

def random_timestamp():
    return datetime.now() - timedelta(days=random.randint(1, 100))

def random_text():
    words = ["amazing", "beautiful", "great", "wonderful", "cool", "interesting", "awesome"]
    return " ".join(random.choice(words) for _ in range(3))

def random_tags():
    tags = ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10", "tag11", "tag12", "tag13", "tag14", "tag15"]
    return "{'" + "', '".join(random.choice(tags) for _ in range(random.randint(1, int(len(tags) / 5)))) + "'}"


# Open the output file
with open("insert_data.cql", "w") as file:
    
    file.write(commands)
    
    # Insert data into `utilizadores`
    for i in range(1, num_users + 1):
        username = f"user{i}"
        nome = f"User Name {i}"
        email = f"user{i}@example.com"
        data_registo = random_timestamp().isoformat()
        file.write(f"INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('{username}', '{nome}', '{email}', '{data_registo}');\n")

    # Insert data into `videos`
    for i in range(1, num_videos + 1):
        autor_username = random_username()
        video_id = i
        nome = f"Video {i}"
        descricao = random_text()
        tags = random_tags()
        data_upload = random_timestamp().isoformat()
        file.write(f"INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('{autor_username}', {video_id}, '{nome}', '{descricao}', {tags}, '{data_upload}');\n")

    # Insert data into 'videos_por_data'
    for i in range(1, num_videos + 1):
        autor_username = random_username()
        video_id = i
        nome = f"Video {i}"
        descricao = random_text()
        tags = random_tags()
        data_upload = random_timestamp().isoformat()
        file.write(f"INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES ({video_id}, '{autor_username}', '{data_upload}', '{nome}', '{descricao}', {tags});\n")

    # Insert data into `videos_autor`
    for i in range(1, num_videos + 1):
        autor_username = random_username()
        video_id = i
        nome = f"Video {i}"
        descricao = random_text()
        tags = random_tags()
        data_upload = random_timestamp().isoformat()
        file.write(f"INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('{autor_username}', {video_id}, '{nome}', '{descricao}', {tags}, '{data_upload}');\n")

    for _ in range(num_comments):
        video_id = random.randint(1, num_videos)
        autor_username = random_username()
        data_comentario = random_timestamp().isoformat()
        comentario = random_text()
        file.write(f"INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES ({video_id}, '{autor_username}', '{data_comentario}', '{comentario}');\n")

    # Insert data into `comentarios_por_utilizador`
    for _ in range(num_comments):
        autor_username = random_username()
        data_comentario = random_timestamp().isoformat()
        video_id = random.randint(1, num_videos)
        comentario = random_text()
        file.write(f"INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('{autor_username}', '{data_comentario}', {video_id}, '{comentario}');\n")

    # Insert data into `seguidores_video`
    for _ in range(num_followers):
        video_id = random.randint(1, num_videos)
        username = random_username()
        file.write(f"INSERT INTO seguidores_video (video_id, username) VALUES ({video_id}, '{username}');\n")

    # Insert data into `eventos_video`
    for _ in range(num_events):
        video_id = random.randint(1, num_videos)
        username = random_username()
        tipo_evento = random.choice(['play', 'pause', 'stop'])
        data_evento = random_timestamp().isoformat()
        tempo_video = random.randint(0, 500)
        file.write(f"INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES ({video_id}, '{username}', '{tipo_evento}', '{data_evento}', {tempo_video});\n")

    # Insert data into `ratings_video`
    for _ in range(num_ratings):
        video_id = random.randint(1, num_videos)
        autor_rating = random_username()
        data_rating = random_timestamp().isoformat()
        rating = random.randint(1, 5)
        file.write(f"INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES ({video_id}, '{autor_rating}', '{data_rating}', {rating});\n")

print("Data insertion script created: insert_data.cql")
