import random
from datetime import datetime, timedelta

# Define the number of records to generate for each table
num_users = 20
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

CREATE TABLE utilizadores_por_data (
    data_registo    DATE,
    username        TEXT, 
    nome            TEXT,
    email           TEXT,
    PRIMARY KEY ((data_registo), username)
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

CREATE TABLE videos_autor (
    autor_username      TEXT, 
    video_id            INT, 
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((autor_username), data_upload, video_id)
);

CREATE TABLE videos_nome (
    nome                TEXT,
    video_id            INT, 
    autor_username      TEXT, 
    data_upload         TIMESTAMP,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((nome), video_id)
);

CREATE TABLE videos_por_tag (
    tag                 TEXT,
    video_id            INT,
    autor_username      TEXT,
    nome                TEXT,
    descricao           TEXT,
    data_upload         TIMESTAMP,
    PRIMARY KEY ((tag), video_id)
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

CREATE TABLE comentarios_videos_seguidos (
    username_seguidor  TEXT,
    video_id           INT,
    autor_comentario   TEXT,
    data_comentario    TIMESTAMP,
    comentario         TEXT,
    PRIMARY KEY ((username_seguidor), video_id, data_comentario)
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

CREATE TABLE eventos_video_data (
    username            TEXT,
    data_evento         DATE,
    video_id            INT, 
    tempo_video         INT,
    tipo_evento         TEXT,
    PRIMARY KEY ((username), data_evento, video_id, tempo_video)
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
    selected_tags = {random.choice(tags) for _ in range(random.randint(1, len(tags) // 5))}
    cql_tags = "{'" + "', '".join(selected_tags) + "'}"
    return cql_tags, selected_tags


# Open the output file
with open("CBD_L302_112981_SEEDDATA.cql", "w") as file:
    
    file.write(commands)
    
    # Insert data into `utilizadores`
    for i in range(1, num_users + 1):
        username = f"user{i}"
        nome = f"User Name {i}"
        email = f"user{i}@example.com"
        data_registo = random_timestamp().isoformat()
        file.write(f"INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('{username}', '{nome}', '{email}', '{data_registo}');\n")
        file.write(f"INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('{data_registo[:10]}', '{username}', '{nome}', '{email}');\n")

    # Insert data into `videos`
    for i in range(1, num_videos + 1):
        autor_username = random_username()
        video_id = i
        nome = f"Video {i}"
        descricao = random_text()
        tags, tags_set = random_tags()
        data_upload = random_timestamp().isoformat()
        file.write(f"INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('{autor_username}', {video_id}, '{nome}', '{descricao}', {tags}, '{data_upload}');\n")
        for tag in set(tags_set):
            file.write(f"INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('{tag}', {video_id}, '{autor_username}', '{nome}', '{descricao}', '{data_upload}');\n")

    # Insert data into `videos_autor` and `videos_nome`
    for i in range(1, num_videos + 1):
        autor_username = random_username()
        video_id = i
        nome = f"Video {i}"
        descricao = random_text()
        tags, tags_set = random_tags()
        data_upload = random_timestamp().isoformat()
        file.write(f"INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('{autor_username}', {video_id}, '{nome}', '{descricao}', {tags}, '{data_upload}');\n")
        file.write(f"INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('{nome}', {video_id}, '{autor_username}', '{data_upload}', '{descricao}', {tags});\n")

    for _ in range(num_comments):
        video_id = random.randint(1, num_videos)
        autor_username = random_username()
        data_comentario = random_timestamp().isoformat()
        comentario = random_text()
        file.write(f"INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES ({video_id}, '{autor_username}', '{data_comentario}', '{comentario}');\n")
        
        
    comentarios = []  # Armazena dados temporários de comentarios_por_utilizador
    seguidores = []   # Armazena dados temporários de seguidores_video

    # Inserir dados em `comentarios_por_utilizador`
    for _ in range(num_comments):
        autor_username = random_username()
        data_comentario = random_timestamp().isoformat()
        video_id = random.randint(1, num_videos)
        comentario = random_text()
        comentarios.append((autor_username, data_comentario, video_id, comentario))
        file.write(f"INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('{autor_username}', '{data_comentario}', {video_id}, '{comentario}');\n")

    # Inserir dados em `seguidores_video`
    for _ in range(num_followers):
        video_id = random.randint(1, num_videos)
        username = random_username()
        seguidores.append((video_id, username))
        file.write(f"INSERT INTO seguidores_video (video_id, username) VALUES ({video_id}, '{username}');\n")

    # Inserir dados em `comentarios_videos_seguidos`
    for video_id, username in seguidores:
        # Para cada seguidor de um vídeo, encontrar comentários no mesmo vídeo
        for autor_username, data_comentario, video_com_id, comentario in comentarios:
            if video_id == video_com_id:  # Se o vídeo corresponder
                file.write(
                    f"INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) "
                    f"VALUES ('{username}', {video_id}, '{autor_username}', '{data_comentario}', '{comentario}');\n"
                )

    # Insert data into `eventos_video`
    for _ in range(num_events):
        video_id = random.randint(1, num_videos)
        username = random_username()
        tipo_evento = random.choice(['play', 'pause', 'stop'])
        data_evento = random_timestamp().isoformat()
        tempo_video = random.randint(0, 500)
        file.write(f"INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES ({video_id}, '{username}', '{tipo_evento}', '{data_evento}', {tempo_video});\n")
        file.write(f"INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('{username}', '{data_evento[:10]}', {video_id}, {tempo_video}, '{tipo_evento}');\n")

    # Insert data into `ratings_video`
    for _ in range(num_ratings):
        video_id = random.randint(1, num_videos)
        autor_rating = random_username()
        data_rating = random_timestamp().isoformat()
        rating = random.randint(1, 5)
        file.write(f"INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES ({video_id}, '{autor_rating}', '{data_rating}', {rating});\n")

print("Data insertion script created: insert_data.cql")
