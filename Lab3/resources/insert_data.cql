
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

CREATE TABLE videos (
    video_id            INT, 
    autor_username      TEXT, 
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((video_id), autor_username)
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
    video_id            INT, 
    username            TEXT,
    tipo_evento         TEXT,
    data_evento         TIMESTAMP,
    tempo_video         INT,
    PRIMARY KEY ((video_id, username), data_evento, tempo_video)
) WITH CLUSTERING ORDER BY (data_evento DESC, tempo_video DESC);

CREATE TABLE ratings_video (
    video_id            INT,
    autor_rating        TEXT,
    data_rating         TIMESTAMP,
    rating              INT,
    PRIMARY KEY ((video_id), autor_rating, data_rating)
);
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-08-06T14:30:29.048993');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-10-23T14:30:29.049011');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-09-18T14:30:29.049020');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-08-13T14:30:29.049025');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-09-08T14:30:29.049029');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-10-23T14:30:29.049033');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-10-07T14:30:29.049036');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-09-29T14:30:29.049040');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-10-04T14:30:29.049043');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-08-15T14:30:29.049047');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-09-16T14:30:29.049050');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-09-15T14:30:29.049054');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-10-23T14:30:29.049057');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-09-26T14:30:29.049061');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-10-27T14:30:29.049064');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-09-18T14:30:29.049067');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-10-28T14:30:29.049071');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 1, 'Video 1', 'great amazing beautiful', {'tag3', 'tag12'}, '2024-08-19T14:30:29.049088');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 2, 'Video 2', 'beautiful great beautiful', {'tag6'}, '2024-09-20T14:30:29.049100');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 3, 'Video 3', 'cool beautiful great', {'tag4', 'tag4'}, '2024-09-01T14:30:29.049111');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 4, 'Video 4', 'great great wonderful', {'tag14', 'tag9'}, '2024-08-16T14:30:29.049120');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 5, 'Video 5', 'great great cool', {'tag10'}, '2024-10-26T14:30:29.049128');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 6, 'Video 6', 'awesome beautiful cool', {'tag12'}, '2024-09-25T14:30:29.049136');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 7, 'Video 7', 'wonderful interesting beautiful', {'tag12', 'tag2'}, '2024-10-08T14:30:29.049144');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 8, 'Video 8', 'interesting great great', {'tag9', 'tag11'}, '2024-10-23T14:30:29.049156');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 9, 'Video 9', 'cool awesome interesting', {'tag8', 'tag6', 'tag9'}, '2024-11-04T14:30:29.049173');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 10, 'Video 10', 'wonderful cool amazing', {'tag3'}, '2024-08-03T14:30:29.049190');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 11, 'Video 11', 'wonderful wonderful cool', {'tag2', 'tag9'}, '2024-10-02T14:30:29.049199');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 12, 'Video 12', 'interesting interesting cool', {'tag10'}, '2024-08-16T14:30:29.049207');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 13, 'Video 13', 'awesome awesome great', {'tag13', 'tag1'}, '2024-10-30T14:30:29.049215');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 14, 'Video 14', 'beautiful cool wonderful', {'tag7', 'tag14'}, '2024-08-14T14:30:29.049223');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 15, 'Video 15', 'amazing great wonderful', {'tag8', 'tag1'}, '2024-10-26T14:30:29.049231');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 16, 'Video 16', 'interesting cool cool', {'tag8'}, '2024-09-11T14:30:29.049244');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 17, 'Video 17', 'great cool wonderful', {'tag12', 'tag7'}, '2024-11-02T14:30:29.049252');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 18, 'Video 18', 'great amazing wonderful', {'tag14'}, '2024-09-22T14:30:29.049260');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 19, 'Video 19', 'great great interesting', {'tag3', 'tag12'}, '2024-11-04T14:30:29.049268');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 20, 'Video 20', 'beautiful cool interesting', {'tag9', 'tag3'}, '2024-09-05T14:30:29.049276');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 21, 'Video 21', 'cool great wonderful', {'tag3'}, '2024-10-24T14:30:29.049284');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 22, 'Video 22', 'cool interesting interesting', {'tag3'}, '2024-10-17T14:30:29.049332');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 23, 'Video 23', 'cool cool amazing', {'tag3', 'tag1', 'tag14'}, '2024-08-13T14:30:29.049343');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 24, 'Video 24', 'beautiful interesting wonderful', {'tag11', 'tag3', 'tag8'}, '2024-08-04T14:30:29.049362');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 25, 'Video 25', 'great beautiful amazing', {'tag11'}, '2024-10-30T14:30:29.049371');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (24, 'user12', '2024-08-30T14:30:29.049377', 'amazing interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (7, 'user1', '2024-07-31T14:30:29.049384', 'amazing great interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user5', '2024-11-02T14:30:29.049391', 'beautiful great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (7, 'user7', '2024-08-13T14:30:29.049398', 'cool awesome cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user2', '2024-08-26T14:30:29.049404', 'amazing beautiful interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user6', '2024-08-15T14:30:29.049411', 'awesome beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user8', '2024-08-07T14:30:29.049417', 'wonderful amazing beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user10', '2024-08-26T14:30:29.049423', 'beautiful amazing awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (2, 'user10', '2024-09-20T14:30:29.049429', 'beautiful interesting amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user12', '2024-10-26T14:30:29.049435', 'wonderful great beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user14', '2024-09-06T14:30:29.049441', 'interesting wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user14', '2024-10-02T14:30:29.049447', 'wonderful awesome beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (2, 'user11', '2024-08-19T14:30:29.049453', 'awesome beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user2', '2024-08-26T14:30:29.049460', 'great cool wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user11', '2024-10-13T14:30:29.049465', 'amazing amazing interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user16', '2024-08-04T14:30:29.049472', 'wonderful wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user10', '2024-08-20T14:30:29.049478', 'beautiful awesome wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user9', '2024-11-03T14:30:29.049484', 'beautiful beautiful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user4', '2024-10-09T14:30:29.049490', 'cool interesting amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user1', '2024-09-23T14:30:29.049496', 'awesome amazing cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user8', '2024-09-14T14:30:29.049502', 'great great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user17', '2024-08-30T14:30:29.049509', 'great great awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user6', '2024-09-02T14:30:29.049515', 'amazing interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user2', '2024-08-21T14:30:29.049521', 'awesome beautiful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (5, 'user15', '2024-08-08T14:30:29.049527', 'beautiful cool cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (22, 'user1', '2024-09-14T14:30:29.049533', 'wonderful interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user17', '2024-10-13T14:30:29.049539', 'great wonderful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user9', '2024-08-14T14:30:29.049545', 'interesting interesting wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user4', '2024-10-09T14:30:29.049552', 'cool amazing awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user5', '2024-10-01T14:30:29.049558', 'interesting interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-11-02T14:30:29.049564', 8, 'interesting interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-09-12T14:30:29.049570', 2, 'awesome cool beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-10-09T14:30:29.049577', 3, 'awesome wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-09-09T14:30:29.049583', 1, 'amazing wonderful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-08-24T14:30:29.049589', 23, 'cool awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-10-13T14:30:29.049595', 15, 'awesome great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-08-04T14:30:29.049601', 22, 'great great wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-08-03T14:30:29.049608', 15, 'beautiful beautiful beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-10-27T14:30:29.049619', 5, 'beautiful awesome amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-01T14:30:29.049625', 18, 'great wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-08-04T14:30:29.049631', 9, 'cool interesting awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-09-25T14:30:29.049637', 9, 'interesting cool beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-09-07T14:30:29.049643', 14, 'wonderful interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-27T14:30:29.049664', 20, 'amazing awesome beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-08-16T14:30:29.049672', 3, 'great beautiful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-09-04T14:30:29.049678', 22, 'cool awesome wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-09-26T14:30:29.049684', 1, 'interesting wonderful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-09-03T14:30:29.049691', 17, 'beautiful wonderful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-21T14:30:29.049697', 3, 'awesome cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-11-05T14:30:29.049703', 10, 'interesting amazing cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-08-01T14:30:29.049709', 9, 'interesting awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-11-01T14:30:29.049715', 6, 'beautiful wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-08-17T14:30:29.049721', 7, 'cool wonderful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-10-15T14:30:29.049727', 21, 'awesome wonderful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user11', '2024-08-31T14:30:29.049733', 5, 'cool wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-11-04T14:30:29.049739', 14, 'beautiful interesting awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-11-06T14:30:29.049745', 3, 'amazing cool great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-08-20T14:30:29.049751', 22, 'beautiful beautiful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-08-30T14:30:29.049757', 6, 'wonderful beautiful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-10-09T14:30:29.049763', 1, 'beautiful interesting beautiful');
INSERT INTO seguidores_video (video_id, username) VALUES (12, 'user14');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user11');
INSERT INTO seguidores_video (video_id, username) VALUES (22, 'user5');
INSERT INTO seguidores_video (video_id, username) VALUES (14, 'user2');
INSERT INTO seguidores_video (video_id, username) VALUES (18, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (16, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user6');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user6');
INSERT INTO seguidores_video (video_id, username) VALUES (19, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (19, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (21, 'user5');
INSERT INTO seguidores_video (video_id, username) VALUES (10, 'user13');
INSERT INTO seguidores_video (video_id, username) VALUES (15, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (10, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user8');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user17', 'play', '2024-11-02T14:30:29.049797', 381);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user8', 'pause', '2024-10-16T14:30:29.049806', 11);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user13', 'play', '2024-09-16T14:30:29.049812', 365);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user6', 'stop', '2024-10-11T14:30:29.049818', 253);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user4', 'play', '2024-10-01T14:30:29.049824', 425);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user3', 'pause', '2024-09-09T14:30:29.049829', 395);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user9', 'stop', '2024-10-05T14:30:29.049835', 153);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user17', 'play', '2024-11-06T14:30:29.049840', 364);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user17', 'stop', '2024-10-15T14:30:29.049858', 442);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user14', 'pause', '2024-08-20T14:30:29.049864', 143);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user13', 'stop', '2024-08-05T14:30:29.049869', 170);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user3', 'play', '2024-10-13T14:30:29.049874', 435);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user8', 'pause', '2024-08-30T14:30:29.049880', 272);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user10', 'pause', '2024-07-30T14:30:29.049885', 180);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user7', 'pause', '2024-08-14T14:30:29.049890', 471);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (25, 'user16', 'stop', '2024-09-09T14:30:29.049895', 206);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user15', 'pause', '2024-10-30T14:30:29.049901', 109);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user3', 'pause', '2024-08-03T14:30:29.049906', 76);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user15', 'stop', '2024-09-19T14:30:29.049911', 111);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (6, 'user13', 'stop', '2024-08-03T14:30:29.049916', 99);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user14', 'pause', '2024-10-18T14:30:29.049922', 28);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user15', 'play', '2024-10-04T14:30:29.049927', 200);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user7', 'play', '2024-09-10T14:30:29.049935', 222);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (4, 'user9', 'stop', '2024-10-09T14:30:29.049940', 92);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user5', 'stop', '2024-10-04T14:30:29.049945', 71);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user17', 'pause', '2024-08-16T14:30:29.049951', 5);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user11', 'stop', '2024-08-24T14:30:29.049956', 96);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user4', 'play', '2024-08-13T14:30:29.049978', 60);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user10', 'pause', '2024-10-17T14:30:29.049985', 227);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user1', 'play', '2024-10-12T14:30:29.049990', 221);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user17', '2024-08-21T14:30:29.049996', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user2', '2024-10-30T14:30:29.050003', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user3', '2024-09-27T14:30:29.050008', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user14', '2024-09-11T14:30:29.050013', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user9', '2024-09-28T14:30:29.050018', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user4', '2024-09-23T14:30:29.050022', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user9', '2024-11-03T14:30:29.050027', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user12', '2024-10-23T14:30:29.050032', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user6', '2024-08-18T14:30:29.050036', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user15', '2024-09-29T14:30:29.050041', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user1', '2024-09-23T14:30:29.050045', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user9', '2024-09-29T14:30:29.050050', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user9', '2024-08-20T14:30:29.050055', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user17', '2024-11-04T14:30:29.050059', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user12', '2024-09-25T14:30:29.050069', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user10', '2024-10-30T14:30:29.050074', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user7', '2024-10-10T14:30:29.050079', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user17', '2024-08-22T14:30:29.050083', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user13', '2024-10-15T14:30:29.050088', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user1', '2024-09-12T14:30:29.050092', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user15', '2024-08-23T14:30:29.050097', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user8', '2024-08-07T14:30:29.050101', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (3, 'user2', '2024-10-31T14:30:29.050106', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user10', '2024-08-30T14:30:29.050111', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user7', '2024-08-01T14:30:29.050116', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user10', '2024-08-06T14:30:29.050120', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user8', '2024-10-21T14:30:29.050125', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user8', '2024-08-17T14:30:29.050129', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user7', '2024-09-15T14:30:29.050134', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user13', '2024-08-19T14:30:29.050138', 2);
