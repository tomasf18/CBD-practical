
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
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-08-29T22:57:08.909126');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-29', 'user1', 'User Name 1', 'user1@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-11-05T22:57:08.909187');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-05', 'user2', 'User Name 2', 'user2@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-09-18T22:57:08.909219');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-18', 'user3', 'User Name 3', 'user3@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-10-12T22:57:08.909239');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-12', 'user4', 'User Name 4', 'user4@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-09-26T22:57:08.909255');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-26', 'user5', 'User Name 5', 'user5@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-10-11T22:57:08.909271');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-11', 'user6', 'User Name 6', 'user6@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-09-03T22:57:08.909285');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-03', 'user7', 'User Name 7', 'user7@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-10-18T22:57:08.909299');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-18', 'user8', 'User Name 8', 'user8@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-10-07T22:57:08.909312');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-07', 'user9', 'User Name 9', 'user9@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-09-08T22:57:08.909374');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-08', 'user10', 'User Name 10', 'user10@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-11-13T22:57:08.909394');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-13', 'user11', 'User Name 11', 'user11@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-10-05T22:57:08.909407');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-10-05', 'user12', 'User Name 12', 'user12@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-11-05T22:57:08.909423');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-05', 'user13', 'User Name 13', 'user13@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-08-21T22:57:08.909436');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-08-21', 'user14', 'User Name 14', 'user14@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-11-22T22:57:08.909450');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-22', 'user15', 'User Name 15', 'user15@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-11-13T22:57:08.909463');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-11-13', 'user16', 'User Name 16', 'user16@example.com');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-09-03T22:57:08.909476');
INSERT INTO utilizadores_por_data (data_registo, username, nome, email) VALUES ('2024-09-03', 'user17', 'User Name 17', 'user17@example.com');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 1, 'Video 1', 'interesting awesome interesting', {'tag3', 'tag2', 'tag14'}, '2024-11-08T22:57:08.909641');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 1, 'user16', 'Video 1', 'interesting awesome interesting', '2024-11-08T22:57:08.909641');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 1, 'user16', 'Video 1', 'interesting awesome interesting', '2024-11-08T22:57:08.909641');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 1, 'user16', 'Video 1', 'interesting awesome interesting', '2024-11-08T22:57:08.909641');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 2, 'Video 2', 'great awesome cool', {'tag13'}, '2024-11-18T22:57:08.909722');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 2, 'user10', 'Video 2', 'great awesome cool', '2024-11-18T22:57:08.909722');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 3, 'Video 3', 'cool amazing beautiful', {'tag11'}, '2024-10-31T22:57:08.909801');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 3, 'user11', 'Video 3', 'cool amazing beautiful', '2024-10-31T22:57:08.909801');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 4, 'Video 4', 'amazing amazing wonderful', {'tag4'}, '2024-10-13T22:57:08.909863');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 4, 'user12', 'Video 4', 'amazing amazing wonderful', '2024-10-13T22:57:08.909863');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 5, 'Video 5', 'great great great', {'tag6', 'tag13', 'tag15'}, '2024-09-22T22:57:08.909929');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 5, 'user12', 'Video 5', 'great great great', '2024-09-22T22:57:08.909929');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 5, 'user12', 'Video 5', 'great great great', '2024-09-22T22:57:08.909929');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 5, 'user12', 'Video 5', 'great great great', '2024-09-22T22:57:08.909929');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 6, 'Video 6', 'wonderful interesting beautiful', {'tag8'}, '2024-11-15T22:57:08.910004');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 6, 'user13', 'Video 6', 'wonderful interesting beautiful', '2024-11-15T22:57:08.910004');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 7, 'Video 7', 'great beautiful interesting', {'tag11', 'tag14', 'tag12'}, '2024-10-02T22:57:08.910084');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 7, 'user2', 'Video 7', 'great beautiful interesting', '2024-10-02T22:57:08.910084');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 7, 'user2', 'Video 7', 'great beautiful interesting', '2024-10-02T22:57:08.910084');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 7, 'user2', 'Video 7', 'great beautiful interesting', '2024-10-02T22:57:08.910084');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 8, 'Video 8', 'wonderful amazing great', {'tag2'}, '2024-09-10T22:57:08.910183');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 8, 'user16', 'Video 8', 'wonderful amazing great', '2024-09-10T22:57:08.910183');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 9, 'Video 9', 'wonderful amazing cool', {'tag4'}, '2024-09-06T22:57:08.910272');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 9, 'user16', 'Video 9', 'wonderful amazing cool', '2024-09-06T22:57:08.910272');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 10, 'Video 10', 'awesome wonderful interesting', {'tag7'}, '2024-10-25T22:57:08.910385');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 10, 'user16', 'Video 10', 'awesome wonderful interesting', '2024-10-25T22:57:08.910385');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 11, 'Video 11', 'great cool wonderful', {'tag1', 'tag5'}, '2024-09-30T22:57:08.910445');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 11, 'user16', 'Video 11', 'great cool wonderful', '2024-09-30T22:57:08.910445');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 11, 'user16', 'Video 11', 'great cool wonderful', '2024-09-30T22:57:08.910445');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 12, 'Video 12', 'amazing wonderful wonderful', {'tag15'}, '2024-09-18T22:57:08.910481');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 12, 'user13', 'Video 12', 'amazing wonderful wonderful', '2024-09-18T22:57:08.910481');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 13, 'Video 13', 'wonderful interesting beautiful', {'tag5'}, '2024-10-07T22:57:08.910514');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 13, 'user1', 'Video 13', 'wonderful interesting beautiful', '2024-10-07T22:57:08.910514');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 14, 'Video 14', 'cool awesome cool', {'tag3', 'tag5'}, '2024-08-30T22:57:08.910548');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 14, 'user13', 'Video 14', 'cool awesome cool', '2024-08-30T22:57:08.910548');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 14, 'user13', 'Video 14', 'cool awesome cool', '2024-08-30T22:57:08.910548');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 15, 'Video 15', 'wonderful beautiful cool', {'tag10', 'tag8'}, '2024-10-22T22:57:08.910584');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 15, 'user3', 'Video 15', 'wonderful beautiful cool', '2024-10-22T22:57:08.910584');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 15, 'user3', 'Video 15', 'wonderful beautiful cool', '2024-10-22T22:57:08.910584');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 16, 'Video 16', 'wonderful awesome great', {'tag13', 'tag15'}, '2024-10-02T22:57:08.910618');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 16, 'user9', 'Video 16', 'wonderful awesome great', '2024-10-02T22:57:08.910618');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 16, 'user9', 'Video 16', 'wonderful awesome great', '2024-10-02T22:57:08.910618');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 17, 'Video 17', 'awesome wonderful wonderful', {'tag3', 'tag10'}, '2024-10-22T22:57:08.910669');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 17, 'user1', 'Video 17', 'awesome wonderful wonderful', '2024-10-22T22:57:08.910669');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 17, 'user1', 'Video 17', 'awesome wonderful wonderful', '2024-10-22T22:57:08.910669');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 18, 'Video 18', 'beautiful great wonderful', {'tag3', 'tag14'}, '2024-10-19T22:57:08.910780');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 18, 'user12', 'Video 18', 'beautiful great wonderful', '2024-10-19T22:57:08.910780');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 18, 'user12', 'Video 18', 'beautiful great wonderful', '2024-10-19T22:57:08.910780');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 19, 'Video 19', 'beautiful awesome beautiful', {'tag4'}, '2024-11-20T22:57:08.910820');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 19, 'user8', 'Video 19', 'beautiful awesome beautiful', '2024-11-20T22:57:08.910820');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 20, 'Video 20', 'awesome wonderful interesting', {'tag9'}, '2024-08-18T22:57:08.910850');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 20, 'user3', 'Video 20', 'awesome wonderful interesting', '2024-08-18T22:57:08.910850');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 21, 'Video 21', 'cool beautiful awesome', {'tag11', 'tag10'}, '2024-10-05T22:57:08.910882');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 21, 'user9', 'Video 21', 'cool beautiful awesome', '2024-10-05T22:57:08.910882');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 21, 'user9', 'Video 21', 'cool beautiful awesome', '2024-10-05T22:57:08.910882');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 22, 'Video 22', 'beautiful interesting awesome', {'tag10', 'tag4'}, '2024-10-29T22:57:08.910917');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 22, 'user16', 'Video 22', 'beautiful interesting awesome', '2024-10-29T22:57:08.910917');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 22, 'user16', 'Video 22', 'beautiful interesting awesome', '2024-10-29T22:57:08.910917');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 23, 'Video 23', 'interesting cool cool', {'tag2', 'tag9'}, '2024-08-28T22:57:08.910950');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 23, 'user4', 'Video 23', 'interesting cool cool', '2024-08-28T22:57:08.910950');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 23, 'user4', 'Video 23', 'interesting cool cool', '2024-08-28T22:57:08.910950');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 24, 'Video 24', 'awesome interesting cool', {'tag6', 'tag9', 'tag4'}, '2024-08-26T22:57:08.910985');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 24, 'user10', 'Video 24', 'awesome interesting cool', '2024-08-26T22:57:08.910985');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 24, 'user10', 'Video 24', 'awesome interesting cool', '2024-08-26T22:57:08.910985');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 24, 'user10', 'Video 24', 'awesome interesting cool', '2024-08-26T22:57:08.910985');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 25, 'Video 25', 'awesome awesome awesome', {'tag1', 'tag4'}, '2024-08-26T22:57:08.911020');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 25, 'user5', 'Video 25', 'awesome awesome awesome', '2024-08-26T22:57:08.911020');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 25, 'user5', 'Video 25', 'awesome awesome awesome', '2024-08-26T22:57:08.911020');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 1, 'Video 1', 'beautiful beautiful interesting', {'tag6', 'tag15', 'tag10'}, '2024-09-02T22:57:08.911061');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 1', 1, 'user11', '2024-09-02T22:57:08.911061', 'beautiful beautiful interesting', {'tag6', 'tag15', 'tag10'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 2, 'Video 2', 'amazing amazing interesting', {'tag6', 'tag5', 'tag8'}, '2024-09-24T22:57:08.911097');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 2', 2, 'user5', '2024-09-24T22:57:08.911097', 'amazing amazing interesting', {'tag6', 'tag5', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 3, 'Video 3', 'great interesting great', {'tag3', 'tag15', 'tag8'}, '2024-11-05T22:57:08.911131');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 3', 3, 'user3', '2024-11-05T22:57:08.911131', 'great interesting great', {'tag3', 'tag15', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 4, 'Video 4', 'beautiful cool cool', {'tag2'}, '2024-10-05T22:57:08.911161');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 4', 4, 'user3', '2024-10-05T22:57:08.911161', 'beautiful cool cool', {'tag2'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 5, 'Video 5', 'beautiful awesome cool', {'tag14'}, '2024-09-20T22:57:08.911191');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 5', 5, 'user12', '2024-09-20T22:57:08.911191', 'beautiful awesome cool', {'tag14'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 6, 'Video 6', 'awesome wonderful interesting', {'tag11', 'tag1', 'tag14'}, '2024-08-31T22:57:08.911224');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 6', 6, 'user4', '2024-08-31T22:57:08.911224', 'awesome wonderful interesting', {'tag11', 'tag1', 'tag14'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 7, 'Video 7', 'awesome beautiful great', {'tag9'}, '2024-09-21T22:57:08.911254');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 7', 7, 'user2', '2024-09-21T22:57:08.911254', 'awesome beautiful great', {'tag9'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 8, 'Video 8', 'great interesting cool', {'tag15', 'tag4'}, '2024-11-25T22:57:08.911286');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 8', 8, 'user10', '2024-11-25T22:57:08.911286', 'great interesting cool', {'tag15', 'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 9, 'Video 9', 'interesting great amazing', {'tag14', 'tag4'}, '2024-09-21T22:57:08.911317');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 9', 9, 'user13', '2024-09-21T22:57:08.911317', 'interesting great amazing', {'tag14', 'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 10, 'Video 10', 'amazing wonderful cool', {'tag11', 'tag1', 'tag15'}, '2024-10-15T22:57:08.911432');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 10', 10, 'user17', '2024-10-15T22:57:08.911432', 'amazing wonderful cool', {'tag11', 'tag1', 'tag15'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 11, 'Video 11', 'great wonderful wonderful', {'tag10', 'tag13', 'tag12'}, '2024-11-06T22:57:08.911469');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 11', 11, 'user11', '2024-11-06T22:57:08.911469', 'great wonderful wonderful', {'tag10', 'tag13', 'tag12'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 12, 'Video 12', 'interesting great cool', {'tag10', 'tag13', 'tag5'}, '2024-10-26T22:57:08.911502');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 12', 12, 'user1', '2024-10-26T22:57:08.911502', 'interesting great cool', {'tag10', 'tag13', 'tag5'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 13, 'Video 13', 'great wonderful amazing', {'tag6', 'tag9', 'tag4'}, '2024-10-17T22:57:08.911534');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 13', 13, 'user2', '2024-10-17T22:57:08.911534', 'great wonderful amazing', {'tag6', 'tag9', 'tag4'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 14, 'Video 14', 'interesting beautiful cool', {'tag7', 'tag1', 'tag8'}, '2024-10-29T22:57:08.911566');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 14', 14, 'user2', '2024-10-29T22:57:08.911566', 'interesting beautiful cool', {'tag7', 'tag1', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 15, 'Video 15', 'awesome amazing wonderful', {'tag3'}, '2024-09-08T22:57:08.911609');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 15', 15, 'user7', '2024-09-08T22:57:08.911609', 'awesome amazing wonderful', {'tag3'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 16, 'Video 16', 'wonderful amazing great', {'tag3', 'tag9', 'tag5'}, '2024-09-14T22:57:08.911643');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 16', 16, 'user1', '2024-09-14T22:57:08.911643', 'wonderful amazing great', {'tag3', 'tag9', 'tag5'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 17, 'Video 17', 'interesting interesting wonderful', {'tag3', 'tag9'}, '2024-10-03T22:57:08.911675');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 17', 17, 'user10', '2024-10-03T22:57:08.911675', 'interesting interesting wonderful', {'tag3', 'tag9'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 18, 'Video 18', 'amazing amazing amazing', {'tag14', 'tag12', 'tag5'}, '2024-11-09T22:57:08.911708');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 18', 18, 'user2', '2024-11-09T22:57:08.911708', 'amazing amazing amazing', {'tag14', 'tag12', 'tag5'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 19, 'Video 19', 'amazing awesome great', {'tag4', 'tag8'}, '2024-10-10T22:57:08.911739');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 19', 19, 'user8', '2024-10-10T22:57:08.911739', 'amazing awesome great', {'tag4', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 20, 'Video 20', 'beautiful amazing amazing', {'tag7', 'tag5', 'tag8'}, '2024-09-20T22:57:08.911770');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 20', 20, 'user13', '2024-09-20T22:57:08.911770', 'beautiful amazing amazing', {'tag7', 'tag5', 'tag8'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 21, 'Video 21', 'amazing wonderful cool', {'tag1'}, '2024-09-28T22:57:08.911800');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 21', 21, 'user11', '2024-09-28T22:57:08.911800', 'amazing wonderful cool', {'tag1'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 22, 'Video 22', 'amazing awesome great', {'tag3', 'tag6'}, '2024-09-18T22:57:08.911831');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 22', 22, 'user12', '2024-09-18T22:57:08.911831', 'amazing awesome great', {'tag3', 'tag6'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 23, 'Video 23', 'amazing amazing cool', {'tag2', 'tag13'}, '2024-08-25T22:57:08.911863');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 23', 23, 'user15', '2024-08-25T22:57:08.911863', 'amazing amazing cool', {'tag2', 'tag13'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 24, 'Video 24', 'amazing cool cool', {'tag10'}, '2024-09-22T22:57:08.911892');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 24', 24, 'user13', '2024-09-22T22:57:08.911892', 'amazing cool cool', {'tag10'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 25, 'Video 25', 'interesting amazing great', {'tag3', 'tag12', 'tag4'}, '2024-08-31T22:57:08.911925');
INSERT INTO videos_nome (nome, video_id, autor_username, data_upload, descricao, tags) VALUES ('Video 25', 25, 'user13', '2024-08-31T22:57:08.911925', 'interesting amazing great', {'tag3', 'tag12', 'tag4'});
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user13', '2024-09-07T22:57:08.911947', 'cool great great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user3', '2024-11-21T22:57:08.911976', 'awesome amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user9', '2024-08-31T22:57:08.912002', 'beautiful amazing amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user11', '2024-10-26T22:57:08.912027', 'interesting interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user13', '2024-10-28T22:57:08.912049', 'awesome awesome wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user13', '2024-09-17T22:57:08.912071', 'awesome wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user8', '2024-08-27T22:57:08.912094', 'wonderful beautiful interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user10', '2024-09-08T22:57:08.912116', 'cool awesome wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user11', '2024-10-24T22:57:08.912183', 'cool great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user14', '2024-10-12T22:57:08.912211', 'amazing cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user15', '2024-10-07T22:57:08.912236', 'wonderful beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (5, 'user7', '2024-09-15T22:57:08.912259', 'great cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user9', '2024-10-22T22:57:08.912282', 'wonderful wonderful interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user14', '2024-09-29T22:57:08.912304', 'wonderful beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user14', '2024-11-12T22:57:08.912362', 'wonderful cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user8', '2024-09-06T22:57:08.912393', 'wonderful wonderful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user14', '2024-09-11T22:57:08.912415', 'amazing great wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user2', '2024-11-07T22:57:08.912438', 'beautiful awesome amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user11', '2024-09-08T22:57:08.912460', 'cool interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user8', '2024-11-02T22:57:08.912482', 'cool awesome awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user2', '2024-10-13T22:57:08.912503', 'amazing wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user5', '2024-10-02T22:57:08.912525', 'beautiful interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user6', '2024-09-03T22:57:08.912547', 'interesting amazing cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user9', '2024-09-24T22:57:08.912569', 'amazing interesting wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user7', '2024-11-07T22:57:08.912591', 'cool cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (5, 'user1', '2024-10-21T22:57:08.912613', 'beautiful wonderful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user4', '2024-10-16T22:57:08.912634', 'beautiful interesting beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user12', '2024-10-17T22:57:08.912656', 'cool amazing beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user8', '2024-10-20T22:57:08.912678', 'interesting great wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user17', '2024-10-18T22:57:08.912700', 'cool awesome wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-09-17T22:57:08.912723', 1, 'great cool beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-11-24T22:57:08.912751', 3, 'awesome great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-06T22:57:08.912778', 2, 'amazing cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-09-21T22:57:08.912803', 4, 'beautiful amazing great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-08-28T22:57:08.912826', 20, 'great cool interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-11-18T22:57:08.912850', 14, 'great wonderful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-09-26T22:57:08.912873', 21, 'amazing great beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-20T22:57:08.912896', 12, 'interesting amazing great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-03T22:57:08.912920', 21, 'interesting beautiful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-09-15T22:57:08.912944', 14, 'beautiful wonderful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-10-12T22:57:08.912966', 12, 'amazing wonderful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-11-06T22:57:08.912989', 3, 'awesome cool great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-10-31T22:57:08.913013', 21, 'awesome awesome interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user11', '2024-09-06T22:57:08.913053', 23, 'wonderful amazing cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-09-19T22:57:08.913078', 9, 'awesome cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-11-12T22:57:08.913102', 12, 'cool wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-10-28T22:57:08.913125', 23, 'beautiful interesting cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-08-30T22:57:08.913148', 7, 'interesting great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-11-10T22:57:08.913172', 11, 'beautiful beautiful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-09-30T22:57:08.913193', 25, 'awesome cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-26T22:57:08.913215', 12, 'cool cool cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-09-23T22:57:08.913238', 6, 'wonderful great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-09-10T22:57:08.913261', 5, 'awesome cool cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-28T22:57:08.913284', 19, 'wonderful awesome wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-10-06T22:57:08.913308', 4, 'wonderful cool wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-10-10T22:57:08.913425', 9, 'interesting amazing awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-08-25T22:57:08.913459', 15, 'awesome beautiful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-03T22:57:08.913483', 1, 'interesting cool interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-09T22:57:08.913519', 24, 'beautiful wonderful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-09-21T22:57:08.913542', 21, 'great beautiful wonderful');
INSERT INTO seguidores_video (video_id, username) VALUES (22, 'user16');
INSERT INTO seguidores_video (video_id, username) VALUES (1, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (10, 'user11');
INSERT INTO seguidores_video (video_id, username) VALUES (1, 'user4');
INSERT INTO seguidores_video (video_id, username) VALUES (12, 'user16');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (14, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (2, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user11');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user13');
INSERT INTO seguidores_video (video_id, username) VALUES (21, 'user11');
INSERT INTO seguidores_video (video_id, username) VALUES (23, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user10');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user13');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user17', 1, 'user9', '2024-09-17T22:57:08.912723', 'great cool beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user17', 1, 'user8', '2024-09-03T22:57:08.913483', 'interesting cool interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user17', 5, 'user13', '2024-09-10T22:57:08.913261', 'awesome cool cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user4', 1, 'user9', '2024-09-17T22:57:08.912723', 'great cool beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user4', 1, 'user8', '2024-09-03T22:57:08.913483', 'interesting cool interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user16', 12, 'user16', '2024-11-20T22:57:08.912896', 'interesting amazing great');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user16', 12, 'user14', '2024-10-12T22:57:08.912966', 'amazing wonderful interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user16', 12, 'user1', '2024-11-12T22:57:08.913102', 'cool wonderful amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user16', 12, 'user8', '2024-09-26T22:57:08.913215', 'cool cool cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user15', 14, 'user15', '2024-11-18T22:57:08.912850', 'great wonderful cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user15', 14, 'user13', '2024-09-15T22:57:08.912944', 'beautiful wonderful wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user1', 2, 'user15', '2024-09-06T22:57:08.912778', 'amazing cool amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 5, 'user13', '2024-09-10T22:57:08.913261', 'awesome cool cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 21, 'user4', '2024-09-26T22:57:08.912873', 'amazing great beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 21, 'user16', '2024-10-03T22:57:08.912920', 'interesting beautiful awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 21, 'user4', '2024-10-31T22:57:08.913013', 'awesome awesome interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user11', 21, 'user5', '2024-09-21T22:57:08.913542', 'great beautiful wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user17', 23, 'user11', '2024-09-06T22:57:08.913053', 'wonderful amazing cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user17', 23, 'user5', '2024-10-28T22:57:08.913125', 'beautiful interesting cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user10', 20, 'user5', '2024-08-28T22:57:08.912826', 'great cool interesting');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user14', 'stop', '2024-10-19T22:57:08.913948', 437);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-10-19', 3, 437, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user2', 'stop', '2024-11-13T22:57:08.913985', 393);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user2', '2024-11-13', 3, 393, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (25, 'user17', 'pause', '2024-08-30T22:57:08.914012', 465);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user17', '2024-08-30', 25, 465, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user6', 'stop', '2024-10-31T22:57:08.914035', 386);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user6', '2024-10-31', 20, 386, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (18, 'user9', 'pause', '2024-10-21T22:57:08.914057', 485);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user9', '2024-10-21', 18, 485, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user3', 'stop', '2024-11-09T22:57:08.914078', 163);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user3', '2024-11-09', 17, 163, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user4', 'stop', '2024-11-25T22:57:08.914101', 115);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user4', '2024-11-25', 13, 115, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (18, 'user6', 'pause', '2024-10-04T22:57:08.914170', 47);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user6', '2024-10-04', 18, 47, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user13', 'play', '2024-10-18T22:57:08.914197', 275);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user13', '2024-10-18', 19, 275, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user6', 'play', '2024-09-17T22:57:08.914218', 417);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user6', '2024-09-17', 1, 417, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user4', 'pause', '2024-09-14T22:57:08.914240', 14);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user4', '2024-09-14', 5, 14, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user3', 'stop', '2024-09-12T22:57:08.914262', 300);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user3', '2024-09-12', 19, 300, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user14', 'pause', '2024-09-11T22:57:08.914283', 154);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-09-11', 1, 154, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user11', 'pause', '2024-09-12T22:57:08.914304', 128);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user11', '2024-09-12', 14, 128, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user14', 'pause', '2024-10-29T22:57:08.914350', 493);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user14', '2024-10-29', 1, 493, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user2', 'pause', '2024-11-18T22:57:08.914384', 385);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user2', '2024-11-18', 16, 385, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user9', 'stop', '2024-11-19T22:57:08.914406', 328);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user9', '2024-11-19', 14, 328, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (4, 'user5', 'play', '2024-10-14T22:57:08.914426', 424);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user5', '2024-10-14', 4, 424, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user16', 'stop', '2024-10-09T22:57:08.914447', 214);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user16', '2024-10-09', 10, 214, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user7', 'pause', '2024-10-14T22:57:08.914468', 211);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user7', '2024-10-14', 13, 211, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user8', 'play', '2024-11-22T22:57:08.914490', 33);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user8', '2024-11-22', 20, 33, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user11', 'stop', '2024-11-24T22:57:08.914510', 263);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user11', '2024-11-24', 9, 263, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (4, 'user17', 'pause', '2024-09-03T22:57:08.914531', 277);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user17', '2024-09-03', 4, 277, 'pause');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user6', 'play', '2024-09-14T22:57:08.914553', 123);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user6', '2024-09-14', 2, 123, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user9', 'play', '2024-09-16T22:57:08.914574', 341);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user9', '2024-09-16', 1, 341, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user15', 'play', '2024-09-25T22:57:08.914595', 300);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user15', '2024-09-25', 11, 300, 'play');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user5', 'stop', '2024-08-30T22:57:08.914616', 204);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user5', '2024-08-30', 22, 204, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user15', 'stop', '2024-09-04T22:57:08.914639', 40);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user15', '2024-09-04', 17, 40, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user15', 'stop', '2024-10-10T22:57:08.914661', 415);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user15', '2024-10-10', 8, 415, 'stop');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user10', 'play', '2024-08-22T22:57:08.914682', 93);
INSERT INTO eventos_video_data (username, data_evento, video_id, tempo_video, tipo_evento) VALUES ('user10', '2024-08-22', 20, 93, 'play');
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user16', '2024-08-27T22:57:08.914705', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user13', '2024-09-19T22:57:08.914725', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (7, 'user13', '2024-11-06T22:57:08.914744', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user10', '2024-11-18T22:57:08.914761', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (12, 'user2', '2024-10-17T22:57:08.914777', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user4', '2024-08-24T22:57:08.914794', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (13, 'user12', '2024-11-04T22:57:08.914810', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user8', '2024-10-15T22:57:08.914827', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user9', '2024-11-08T22:57:08.914843', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user4', '2024-10-04T22:57:08.914859', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user4', '2024-11-06T22:57:08.914875', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user7', '2024-08-23T22:57:08.914948', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (3, 'user12', '2024-10-20T22:57:08.914970', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user2', '2024-11-24T22:57:08.914988', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user16', '2024-08-18T22:57:08.915004', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user13', '2024-11-09T22:57:08.915021', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user10', '2024-10-22T22:57:08.915038', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user10', '2024-09-07T22:57:08.915054', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user11', '2024-09-22T22:57:08.915071', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user11', '2024-10-23T22:57:08.915087', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user3', '2024-09-12T22:57:08.915104', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user10', '2024-10-08T22:57:08.915120', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user7', '2024-09-30T22:57:08.915150', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user14', '2024-10-13T22:57:08.915167', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user5', '2024-09-14T22:57:08.915184', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user5', '2024-08-26T22:57:08.915200', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user2', '2024-10-29T22:57:08.915217', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user9', '2024-11-18T22:57:08.915235', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (4, 'user13', '2024-11-20T22:57:08.915251', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (3, 'user13', '2024-09-01T22:57:08.915268', 1);
