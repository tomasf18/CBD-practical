```sql
-- Drop the keyspace if it exists to avoid conflicts
DROP KEYSPACE IF EXISTS partilha_videos;

-- Create keyspace
CREATE KEYSPACE partilha_videos 
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

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
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-11-14T16:00:44.510637');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-14', 'user1', 'User Name 1', 'user1@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-11-19T16:00:44.510677');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-19', 'user2', 'User Name 2', 'user2@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-10-18T16:00:44.510693');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-18', 'user3', 'User Name 3', 'user3@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-11-11T16:00:44.510703');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-11', 'user4', 'User Name 4', 'user4@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-08-29T16:00:44.510713');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-29', 'user5', 'User Name 5', 'user5@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-09-09T16:00:44.510722');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-09', 'user6', 'User Name 6', 'user6@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-11-06T16:00:44.510731');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-06', 'user7', 'User Name 7', 'user7@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-09-13T16:00:44.510740');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-13', 'user8', 'User Name 8', 'user8@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-08-25T16:00:44.510748');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-25', 'user9', 'User Name 9', 'user9@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-09-29T16:00:44.510762');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-29', 'user10', 'User Name 10', 'user10@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-09-18T16:00:44.510771');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-18', 'user11', 'User Name 11', 'user11@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-08-29T16:00:44.510780');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-29', 'user12', 'User Name 12', 'user12@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-10-19T16:00:44.510789');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-19', 'user13', 'User Name 13', 'user13@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-11-19T16:00:44.510798');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-19', 'user14', 'User Name 14', 'user14@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-08-25T16:00:44.510806');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-25', 'user15', 'User Name 15', 'user15@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-10-07T16:00:44.510815');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-07', 'user16', 'User Name 16', 'user16@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-10-05T16:00:44.510823');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-05', 'user17', 'User Name 17', 'user17@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user18', 'User Name 18', 'user18@example.com', '2024-10-13T16:00:44.510875');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-13', 'user18', 'User Name 18', 'user18@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user19', 'User Name 19', 'user19@example.com', '2024-11-25T16:00:44.510890');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-25', 'user19', 'User Name 19', 'user19@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user20', 'User Name 20', 'user20@example.com', '2024-09-24T16:00:44.510899');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-24', 'user20', 'User Name 20', 'user20@example.com');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user19', 1, 'Video 1', 'beautiful beautiful awesome', {'tag2', 'tag14', 'tag9'}, '2024-10-14T16:00:44.510936');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 1, 'user19', 'Video 1', 'beautiful beautiful awesome', '2024-10-14T16:00:44.510936');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 1, 'user19', 'Video 1', 'beautiful beautiful awesome', '2024-10-14T16:00:44.510936');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 1, 'user19', 'Video 1', 'beautiful beautiful awesome', '2024-10-14T16:00:44.510936');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 2, 'Video 2', 'amazing cool awesome', {'tag6', 'tag4'}, '2024-10-06T16:00:44.510969');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 2, 'user14', 'Video 2', 'amazing cool awesome', '2024-10-06T16:00:44.510969');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 2, 'user14', 'Video 2', 'amazing cool awesome', '2024-10-06T16:00:44.510969');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 3, 'Video 3', 'amazing great great', {'tag11'}, '2024-09-19T16:00:44.510993');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 3, 'user8', 'Video 3', 'amazing great great', '2024-09-19T16:00:44.510993');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 4, 'Video 4', 'awesome beautiful awesome', {'tag9'}, '2024-08-27T16:00:44.511014');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 4, 'user10', 'Video 4', 'awesome beautiful awesome', '2024-08-27T16:00:44.511014');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 5, 'Video 5', 'interesting cool great', {'tag6', 'tag10', 'tag1'}, '2024-10-10T16:00:44.511037');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 5, 'user9', 'Video 5', 'interesting cool great', '2024-10-10T16:00:44.511037');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 5, 'user9', 'Video 5', 'interesting cool great', '2024-10-10T16:00:44.511037');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 5, 'user9', 'Video 5', 'interesting cool great', '2024-10-10T16:00:44.511037');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user20', 6, 'Video 6', 'beautiful great awesome', {'tag10'}, '2024-11-09T16:00:44.511066');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 6, 'user20', 'Video 6', 'beautiful great awesome', '2024-11-09T16:00:44.511066');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 7, 'Video 7', 'interesting great amazing', {'tag12'}, '2024-08-23T16:00:44.511086');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 7, 'user11', 'Video 7', 'interesting great amazing', '2024-08-23T16:00:44.511086');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user20', 8, 'Video 8', 'interesting awesome cool', {'tag6', 'tag5', 'tag7'}, '2024-11-23T16:00:44.511114');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 8, 'user20', 'Video 8', 'interesting awesome cool', '2024-11-23T16:00:44.511114');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 8, 'user20', 'Video 8', 'interesting awesome cool', '2024-11-23T16:00:44.511114');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 8, 'user20', 'Video 8', 'interesting awesome cool', '2024-11-23T16:00:44.511114');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user19', 9, 'Video 9', 'amazing wonderful cool', {'tag14', 'tag9', 'tag8'}, '2024-08-24T16:00:44.511129');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 9, 'user19', 'Video 9', 'amazing wonderful cool', '2024-08-24T16:00:44.511129');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 9, 'user19', 'Video 9', 'amazing wonderful cool', '2024-08-24T16:00:44.511129');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 9, 'user19', 'Video 9', 'amazing wonderful cool', '2024-08-24T16:00:44.511129');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 10, 'Video 10', 'interesting beautiful awesome', {'tag7', 'tag3'}, '2024-11-18T16:00:44.511142');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 10, 'user1', 'Video 10', 'interesting beautiful awesome', '2024-11-18T16:00:44.511142');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 10, 'user1', 'Video 10', 'interesting beautiful awesome', '2024-11-18T16:00:44.511142');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 11, 'Video 11', 'cool interesting awesome', {'tag14', 'tag11', 'tag4'}, '2024-09-29T16:00:44.511154');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 11, 'user15', 'Video 11', 'cool interesting awesome', '2024-09-29T16:00:44.511154');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 11, 'user15', 'Video 11', 'cool interesting awesome', '2024-09-29T16:00:44.511154');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 11, 'user15', 'Video 11', 'cool interesting awesome', '2024-09-29T16:00:44.511154');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 12, 'Video 12', 'awesome beautiful amazing', {'tag14', 'tag3', 'tag1'}, '2024-09-01T16:00:44.511167');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 12, 'user13', 'Video 12', 'awesome beautiful amazing', '2024-09-01T16:00:44.511167');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 12, 'user13', 'Video 12', 'awesome beautiful amazing', '2024-09-01T16:00:44.511167');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 12, 'user13', 'Video 12', 'awesome beautiful amazing', '2024-09-01T16:00:44.511167');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 13, 'Video 13', 'beautiful cool amazing', {'tag11'}, '2024-10-19T16:00:44.511214');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 13, 'user3', 'Video 13', 'beautiful cool amazing', '2024-10-19T16:00:44.511214');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 14, 'Video 14', 'amazing wonderful cool', {'tag13'}, '2024-11-19T16:00:44.511236');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 14, 'user3', 'Video 14', 'amazing wonderful cool', '2024-11-19T16:00:44.511236');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user18', 15, 'Video 15', 'great beautiful amazing', {'tag3'}, '2024-09-04T16:00:44.511256');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 15, 'user18', 'Video 15', 'great beautiful amazing', '2024-09-04T16:00:44.511256');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 16, 'Video 16', 'amazing wonderful beautiful', {'tag7', 'tag5'}, '2024-11-11T16:00:44.511276');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 16, 'user8', 'Video 16', 'amazing wonderful beautiful', '2024-11-11T16:00:44.511276');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 16, 'user8', 'Video 16', 'amazing wonderful beautiful', '2024-11-11T16:00:44.511276');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user20', 17, 'Video 17', 'great great beautiful', {'tag3', 'tag15'}, '2024-09-11T16:00:44.511298');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 17, 'user20', 'Video 17', 'great great beautiful', '2024-09-11T16:00:44.511298');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 17, 'user20', 'Video 17', 'great great beautiful', '2024-09-11T16:00:44.511298');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 18, 'Video 18', 'great great wonderful', {'tag2', 'tag14', 'tag12'}, '2024-11-18T16:00:44.511320');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 18, 'user6', 'Video 18', 'great great wonderful', '2024-11-18T16:00:44.511320');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 18, 'user6', 'Video 18', 'great great wonderful', '2024-11-18T16:00:44.511320');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 18, 'user6', 'Video 18', 'great great wonderful', '2024-11-18T16:00:44.511320');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user18', 19, 'Video 19', 'amazing wonderful beautiful', {'tag12', 'tag4'}, '2024-11-08T16:00:44.511343');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 19, 'user18', 'Video 19', 'amazing wonderful beautiful', '2024-11-08T16:00:44.511343');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 19, 'user18', 'Video 19', 'amazing wonderful beautiful', '2024-11-08T16:00:44.511343');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 20, 'Video 20', 'cool beautiful cool', {'tag10'}, '2024-10-08T16:00:44.511364');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 20, 'user16', 'Video 20', 'cool beautiful cool', '2024-10-08T16:00:44.511364');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 21, 'Video 21', 'great great wonderful', {'tag8', 'tag4'}, '2024-08-25T16:00:44.511383');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 21, 'user3', 'Video 21', 'great great wonderful', '2024-08-25T16:00:44.511383');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 21, 'user3', 'Video 21', 'great great wonderful', '2024-08-25T16:00:44.511383');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 22, 'Video 22', 'beautiful great awesome', {'tag7', 'tag4', 'tag8'}, '2024-09-29T16:00:44.511406');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 22, 'user11', 'Video 22', 'beautiful great awesome', '2024-09-29T16:00:44.511406');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 22, 'user11', 'Video 22', 'beautiful great awesome', '2024-09-29T16:00:44.511406');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 22, 'user11', 'Video 22', 'beautiful great awesome', '2024-09-29T16:00:44.511406');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user19', 23, 'Video 23', 'great great awesome', {'tag3', 'tag1'}, '2024-11-20T16:00:44.511434');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 23, 'user19', 'Video 23', 'great great awesome', '2024-11-20T16:00:44.511434');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 23, 'user19', 'Video 23', 'great great awesome', '2024-11-20T16:00:44.511434');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 24, 'Video 24', 'cool wonderful awesome', {'tag2', 'tag15'}, '2024-10-29T16:00:44.511464');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 24, 'user16', 'Video 24', 'cool wonderful awesome', '2024-10-29T16:00:44.511464');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 24, 'user16', 'Video 24', 'cool wonderful awesome', '2024-10-29T16:00:44.511464');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 25, 'Video 25', 'awesome amazing awesome', {'tag6', 'tag11', 'tag1'}, '2024-11-15T16:00:44.511490');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 25, 'user4', 'Video 25', 'awesome amazing awesome', '2024-11-15T16:00:44.511490');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 25, 'user4', 'Video 25', 'awesome amazing awesome', '2024-11-15T16:00:44.511490');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 25, 'user4', 'Video 25', 'awesome amazing awesome', '2024-11-15T16:00:44.511490');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 1, 'Video 1', 'interesting beautiful beautiful', {'tag6', 'tag7', 'tag5'}, '2024-10-10T16:00:44.511519');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 1', 1, 'user9', '2024-10-10T16:00:44.511519', 'interesting beautiful beautiful', {'tag6', 'tag7', 'tag5'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 2, 'Video 2', 'cool wonderful awesome', {'tag5', 'tag1'}, '2024-10-29T16:00:44.511542');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 2', 2, 'user1', '2024-10-29T16:00:44.511542', 'cool wonderful awesome', {'tag5', 'tag1'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user18', 3, 'Video 3', 'cool wonderful beautiful', {'tag7', 'tag14', 'tag8'}, '2024-09-28T16:00:44.511567');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 3', 3, 'user18', '2024-09-28T16:00:44.511567', 'cool wonderful beautiful', {'tag7', 'tag14', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 4, 'Video 4', 'wonderful wonderful amazing', {'tag6', 'tag7', 'tag9'}, '2024-11-05T16:00:44.511614');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 4', 4, 'user9', '2024-11-05T16:00:44.511614', 'wonderful wonderful amazing', {'tag6', 'tag7', 'tag9'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 5, 'Video 5', 'wonderful interesting beautiful', {'tag12'}, '2024-11-08T16:00:44.511648');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 5', 5, 'user9', '2024-11-08T16:00:44.511648', 'wonderful interesting beautiful', {'tag12'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 6, 'Video 6', 'interesting cool amazing', {'tag3', 'tag9'}, '2024-10-09T16:00:44.511669');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 6', 6, 'user12', '2024-10-09T16:00:44.511669', 'interesting cool amazing', {'tag3', 'tag9'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 7, 'Video 7', 'amazing awesome interesting', {'tag7'}, '2024-10-15T16:00:44.511688');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 7', 7, 'user6', '2024-10-15T16:00:44.511688', 'amazing awesome interesting', {'tag7'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 8, 'Video 8', 'awesome great awesome', {'tag2', 'tag15'}, '2024-10-28T16:00:44.511707');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 8', 8, 'user2', '2024-10-28T16:00:44.511707', 'awesome great awesome', {'tag2', 'tag15'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user18', 9, 'Video 9', 'interesting wonderful interesting', {'tag7', 'tag12', 'tag1'}, '2024-10-27T16:00:44.511728');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 9', 9, 'user18', '2024-10-27T16:00:44.511728', 'interesting wonderful interesting', {'tag7', 'tag12', 'tag1'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 10, 'Video 10', 'cool interesting wonderful', {'tag14', 'tag15', 'tag4'}, '2024-11-12T16:00:44.511748');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 10', 10, 'user15', '2024-11-12T16:00:44.511748', 'cool interesting wonderful', {'tag14', 'tag15', 'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 11, 'Video 11', 'interesting great wonderful', {'tag6', 'tag7'}, '2024-11-21T16:00:44.511768');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 11', 11, 'user6', '2024-11-21T16:00:44.511768', 'interesting great wonderful', {'tag6', 'tag7'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 12, 'Video 12', 'beautiful interesting amazing', {'tag4'}, '2024-10-29T16:00:44.511793');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 12', 12, 'user16', '2024-10-29T16:00:44.511793', 'beautiful interesting amazing', {'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 13, 'Video 13', 'beautiful beautiful awesome', {'tag13'}, '2024-11-20T16:00:44.511813');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 13', 13, 'user6', '2024-11-20T16:00:44.511813', 'beautiful beautiful awesome', {'tag13'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user19', 14, 'Video 14', 'great awesome amazing', {'tag7', 'tag15'}, '2024-11-17T16:00:44.511835');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 14', 14, 'user19', '2024-11-17T16:00:44.511835', 'great awesome amazing', {'tag7', 'tag15'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 15, 'Video 15', 'interesting beautiful awesome', {'tag5', 'tag14', 'tag9'}, '2024-11-18T16:00:44.511856');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 15', 15, 'user8', '2024-11-18T16:00:44.511856', 'interesting beautiful awesome', {'tag5', 'tag14', 'tag9'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 16, 'Video 16', 'amazing beautiful cool', {'tag13'}, '2024-11-14T16:00:44.511867');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 16', 16, 'user2', '2024-11-14T16:00:44.511867', 'amazing beautiful cool', {'tag13'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 17, 'Video 17', 'wonderful beautiful awesome', {'tag1'}, '2024-09-11T16:00:44.511877');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 17', 17, 'user6', '2024-09-11T16:00:44.511877', 'wonderful beautiful awesome', {'tag1'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 18, 'Video 18', 'interesting amazing awesome', {'tag7'}, '2024-10-14T16:00:44.511886');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 18', 18, 'user5', '2024-10-14T16:00:44.511886', 'interesting amazing awesome', {'tag7'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 19, 'Video 19', 'amazing awesome wonderful', {'tag13', 'tag10', 'tag11'}, '2024-11-11T16:00:44.511897');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 19', 19, 'user12', '2024-11-11T16:00:44.511897', 'amazing awesome wonderful', {'tag13', 'tag10', 'tag11'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user18', 20, 'Video 20', 'amazing cool beautiful', {'tag14'}, '2024-08-26T16:00:44.511907');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 20', 20, 'user18', '2024-08-26T16:00:44.511907', 'amazing cool beautiful', {'tag14'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user20', 21, 'Video 21', 'beautiful interesting great', {'tag6', 'tag10', 'tag4'}, '2024-10-08T16:00:44.511917');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 21', 21, 'user20', '2024-10-08T16:00:44.511917', 'beautiful interesting great', {'tag6', 'tag10', 'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 22, 'Video 22', 'awesome wonderful awesome', {'tag8'}, '2024-09-01T16:00:44.511927');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 22', 22, 'user9', '2024-09-01T16:00:44.511927', 'awesome wonderful awesome', {'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 23, 'Video 23', 'amazing wonderful awesome', {'tag12'}, '2024-08-24T16:00:44.511936');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 23', 23, 'user8', '2024-08-24T16:00:44.511936', 'amazing wonderful awesome', {'tag12'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 24, 'Video 24', 'awesome wonderful beautiful', {'tag7', 'tag3', 'tag8'}, '2024-10-05T16:00:44.511978');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 24', 24, 'user5', '2024-10-05T16:00:44.511978', 'awesome wonderful beautiful', {'tag7', 'tag3', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 25, 'Video 25', 'great interesting beautiful', {'tag8'}, '2024-09-02T16:00:44.511999');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 25', 25, 'user2', '2024-09-02T16:00:44.511999', 'great interesting beautiful', {'tag8'});
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user16', '2024-11-23T16:00:44.512012', 'wonderful cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (18, 'user14', '2024-09-13T16:00:44.512028', 'cool beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user3', '2024-09-11T16:00:44.512043', 'wonderful great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user14', '2024-11-01T16:00:44.512058', 'interesting amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (22, 'user2', '2024-11-24T16:00:44.512072', 'great beautiful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user13', '2024-08-20T16:00:44.512086', 'amazing beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user5', '2024-08-21T16:00:44.512100', 'beautiful great amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user11', '2024-10-13T16:00:44.512114', 'great awesome interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user8', '2024-09-28T16:00:44.512128', 'amazing beautiful wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user19', '2024-09-20T16:00:44.512142', 'amazing amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user20', '2024-09-29T16:00:44.512156', 'interesting wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user8', '2024-08-26T16:00:44.512170', 'beautiful beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user14', '2024-09-26T16:00:44.512185', 'awesome wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user4', '2024-10-20T16:00:44.512204', 'cool great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user20', '2024-10-28T16:00:44.512213', 'cool interesting great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user9', '2024-10-19T16:00:44.512220', 'wonderful great beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user17', '2024-08-25T16:00:44.512228', 'cool interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user5', '2024-10-19T16:00:44.512235', 'wonderful amazing amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user12', '2024-10-07T16:00:44.512242', 'wonderful cool beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user11', '2024-09-19T16:00:44.512249', 'cool beautiful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (2, 'user7', '2024-11-17T16:00:44.512257', 'awesome wonderful wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user8', '2024-11-04T16:00:44.512264', 'awesome beautiful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user2', '2024-11-03T16:00:44.512271', 'interesting great great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (7, 'user1', '2024-09-30T16:00:44.512278', 'awesome amazing amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user16', '2024-11-25T16:00:44.512285', 'amazing cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user17', '2024-10-01T16:00:44.512292', 'awesome beautiful interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user7', '2024-11-03T16:00:44.512299', 'beautiful great awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user19', '2024-09-21T16:00:44.512306', 'great great awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user2', '2024-09-26T16:00:44.512313', 'awesome wonderful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user8', '2024-09-14T16:00:44.512320', 'wonderful great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-11-24T16:00:44.512327', 25, 'beautiful cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-24T16:00:44.512336', 6, 'beautiful wonderful beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-11-18T16:00:44.512345', 4, 'wonderful beautiful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user19', '2024-11-20T16:00:44.512353', 8, 'interesting interesting cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-11-06T16:00:44.512360', 24, 'awesome interesting interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-10-01T16:00:44.512368', 3, 'great interesting amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-11-24T16:00:44.512381', 13, 'great interesting interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-20T16:00:44.512389', 24, 'wonderful wonderful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-10-09T16:00:44.512397', 4, 'cool awesome interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-10-22T16:00:44.512404', 2, 'awesome interesting amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-08-28T16:00:44.512412', 21, 'cool amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-08-30T16:00:44.512419', 5, 'beautiful amazing awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-10-27T16:00:44.512450', 2, 'cool cool great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-11-07T16:00:44.512469', 2, 'amazing great beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-11-24T16:00:44.512484', 3, 'awesome cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-01T16:00:44.512498', 24, 'great wonderful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-04T16:00:44.512512', 16, 'awesome great wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-09-20T16:00:44.512526', 5, 'great great wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-08-27T16:00:44.512541', 1, 'wonderful great interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-11-22T16:00:44.512555', 18, 'beautiful cool wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-13T16:00:44.512569', 23, 'great amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-25T16:00:44.512583', 2, 'great beautiful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-11-21T16:00:44.512597', 1, 'great wonderful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-11-20T16:00:44.512611', 14, 'wonderful beautiful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-08-19T16:00:44.512646', 4, 'beautiful interesting beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user18', '2024-10-04T16:00:44.512663', 15, 'great beautiful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-11-20T16:00:44.512683', 9, 'amazing cool beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-10-15T16:00:44.512704', 21, 'wonderful cool cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-09-24T16:00:44.512718', 10, 'awesome cool wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-09-07T16:00:44.512726', 9, 'amazing beautiful wonderful');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (12, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (15, 'user9');
INSERT INTO seguidores_video (video_id, username) VALUES (18, 'user11');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user18');
INSERT INTO seguidores_video (video_id, username) VALUES (12, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user10');
INSERT INTO seguidores_video (video_id, username) VALUES (18, 'user10');
INSERT INTO seguidores_video (video_id, username) VALUES (14, 'user20');
INSERT INTO seguidores_video (video_id, username) VALUES (21, 'user19');
INSERT INTO seguidores_video (video_id, username) VALUES (2, 'user7');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (8, 'user7');
INSERT INTO seguidores_video (video_id, username) VALUES (22, 'user13');
INSERT INTO seguidores_video (video_id, username) VALUES (16, 'user7');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user9', 15, 'user18', '2024-10-04T16:00:44.512663', 'great beautiful awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 18, 'user17', '2024-11-22T16:00:44.512555', 'beautiful cool wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user18', 13, 'user3', '2024-11-24T16:00:44.512381', 'great interesting interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user10', 5, 'user13', '2024-08-30T16:00:44.512419', 'beautiful amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user10', 5, 'user2', '2024-09-20T16:00:44.512526', 'great great wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user10', 18, 'user17', '2024-11-22T16:00:44.512555', 'beautiful cool wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user20', 14, 'user8', '2024-11-20T16:00:44.512611', 'wonderful beautiful wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user19', 21, 'user3', '2024-08-28T16:00:44.512412', 'cool amazing amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user19', 21, 'user10', '2024-10-15T16:00:44.512704', 'wonderful cool cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 2, 'user5', '2024-10-22T16:00:44.512404', 'awesome interesting amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 2, 'user10', '2024-10-27T16:00:44.512450', 'cool cool great');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 2, 'user5', '2024-11-07T16:00:44.512469', 'amazing great beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 2, 'user8', '2024-09-25T16:00:44.512583', 'great beautiful awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user15', 5, 'user13', '2024-08-30T16:00:44.512419', 'beautiful amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user15', 5, 'user2', '2024-09-20T16:00:44.512526', 'great great wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 8, 'user19', '2024-11-20T16:00:44.512353', 'interesting interesting cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 16, 'user16', '2024-10-04T16:00:44.512512', 'awesome great wonderful');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user12', 'pause', '2024-11-15T16:00:44.512855', 28);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user12', '2024-11-15', 10, 28, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (21, 'user8', 'stop', '2024-09-05T16:00:44.512895', 241);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user8', '2024-09-05', 21, 241, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user5', 'stop', '2024-09-20T16:00:44.512914', 72);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user5', '2024-09-20', 13, 72, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user14', 'play', '2024-11-18T16:00:44.512929', 320);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-11-18', 23, 320, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user12', 'stop', '2024-11-22T16:00:44.512945', 348);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user12', '2024-11-22', 16, 348, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (6, 'user14', 'stop', '2024-09-15T16:00:44.512959', 409);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-09-15', 6, 409, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user8', 'stop', '2024-11-14T16:00:44.512973', 343);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user8', '2024-11-14', 2, 343, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user16', 'play', '2024-09-12T16:00:44.512986', 316);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user16', '2024-09-12', 12, 316, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user12', 'play', '2024-10-28T16:00:44.513000', 354);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user12', '2024-10-28', 7, 354, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (4, 'user4', 'pause', '2024-11-15T16:00:44.513014', 130);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user4', '2024-11-15', 4, 130, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user1', 'play', '2024-09-25T16:00:44.513028', 254);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user1', '2024-09-25', 8, 254, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user17', 'pause', '2024-09-20T16:00:44.513041', 69);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user17', '2024-09-20', 11, 69, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user12', 'stop', '2024-11-19T16:00:44.513055', 455);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user12', '2024-11-19', 15, 455, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (6, 'user2', 'play', '2024-11-07T16:00:44.513068', 411);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user2', '2024-11-07', 6, 411, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user19', 'play', '2024-10-05T16:00:44.513082', 426);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user19', '2024-10-05', 8, 426, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user1', 'play', '2024-09-30T16:00:44.513096', 4);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user1', '2024-09-30', 23, 4, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user14', 'play', '2024-09-28T16:00:44.513110', 76);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-09-28', 12, 76, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user3', 'pause', '2024-11-10T16:00:44.513132', 153);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user3', '2024-11-10', 22, 153, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user4', 'play', '2024-09-13T16:00:44.513140', 463);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user4', '2024-09-13', 23, 463, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user18', 'pause', '2024-10-23T16:00:44.513147', 117);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user18', '2024-10-23', 3, 117, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user12', 'play', '2024-08-27T16:00:44.513154', 221);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user12', '2024-08-27', 15, 221, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (18, 'user10', 'play', '2024-11-15T16:00:44.513161', 299);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user10', '2024-11-15', 18, 299, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user20', 'stop', '2024-09-08T16:00:44.513168', 111);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user20', '2024-09-08', 11, 111, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user8', 'pause', '2024-11-11T16:00:44.513176', 496);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user8', '2024-11-11', 12, 496, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user14', 'pause', '2024-09-05T16:00:44.513184', 488);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-09-05', 5, 488, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user8', 'stop', '2024-10-16T16:00:44.513191', 420);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user8', '2024-10-16', 19, 420, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user17', 'pause', '2024-09-13T16:00:44.513198', 272);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user17', '2024-09-13', 13, 272, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user18', 'pause', '2024-10-23T16:00:44.513212', 182);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user18', '2024-10-23', 19, 182, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user14', 'pause', '2024-10-18T16:00:44.513219', 260);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-10-18', 15, 260, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user4', 'pause', '2024-10-01T16:00:44.513251', 325);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user4', '2024-10-01', 9, 325, 'pause');
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user9', '2024-11-12T16:00:44.513270', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (13, 'user7', '2024-10-31T16:00:44.513285', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user14', '2024-11-03T16:00:44.513297', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user18', '2024-10-07T16:00:44.513319', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user8', '2024-10-25T16:00:44.513338', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (4, 'user6', '2024-09-28T16:00:44.513349', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user17', '2024-09-12T16:00:44.513360', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user15', '2024-08-20T16:00:44.513371', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user14', '2024-09-03T16:00:44.513386', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (4, 'user1', '2024-10-18T16:00:44.513397', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (13, 'user8', '2024-08-27T16:00:44.513408', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user9', '2024-10-02T16:00:44.513419', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user5', '2024-10-15T16:00:44.513441', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user3', '2024-11-25T16:00:44.513453', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (19, 'user19', '2024-09-04T16:00:44.513464', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user14', '2024-10-06T16:00:44.513478', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user20', '2024-09-05T16:00:44.513494', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (7, 'user6', '2024-10-12T16:00:44.513514', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user13', '2024-10-16T16:00:44.513528', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user9', '2024-10-09T16:00:44.513541', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user15', '2024-09-10T16:00:44.513555', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user10', '2024-11-18T16:00:44.513570', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user2', '2024-10-01T16:00:44.513582', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (4, 'user19', '2024-11-08T16:00:44.513595', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (13, 'user18', '2024-09-20T16:00:44.513609', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user13', '2024-10-25T16:00:44.513621', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user19', '2024-11-04T16:00:44.513658', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user13', '2024-09-12T16:00:44.513664', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user20', '2024-08-30T16:00:44.513670', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user5', '2024-10-20T16:00:44.513675', 4);
```