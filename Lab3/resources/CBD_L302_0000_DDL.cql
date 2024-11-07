
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
    autor_username      TEXT,
    video_id            INT,
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((autor_username), video_id)
);

CREATE TABLE comentarios_por_video (
    video_id            INT,
    autor_username      TEXT,
    data_comentario     TIMESTAMP,
    comentario          TEXT,
    PRIMARY KEY ((video_id), autor_username, data_comentario)
) WITH CLUSTERING ORDER BY (autor_username ASC, data_comentario DESC);

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
    PRIMARY KEY ((video_id, username), data_evento)
) WITH CLUSTERING ORDER BY (data_evento DESC);

CREATE TABLE ratings_video (
    video_id            INT,
    autor_rating        TEXT,
    data_rating         TIMESTAMP,
    rating              INT,
    PRIMARY KEY ((video_id), autor_rating, data_rating)
);
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-08-19T12:58:49.251535');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-08-01T12:58:49.251562');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-09-03T12:58:49.251591');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-10-22T12:58:49.251611');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-09-03T12:58:49.251625');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-08-14T12:58:49.251633');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-10-04T12:58:49.251638');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-08-31T12:58:49.251644');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-10-20T12:58:49.251650');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-10-01T12:58:49.251656');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-10-30T12:58:49.251661');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-08-30T12:58:49.251667');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-10-31T12:58:49.251673');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-08-03T12:58:49.251679');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-08-31T12:58:49.251684');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-10-15T12:58:49.251690');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-08-21T12:58:49.251695');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 1, 'Video 1', 'great interesting great', {'tag1', 'tag3'}, '2024-10-07T12:58:49.251724');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 2, 'Video 2', 'interesting awesome interesting', {'tag8', 'tag9'}, '2024-09-27T12:58:49.251745');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 3, 'Video 3', 'interesting amazing great', {'tag1', 'tag9', 'tag11'}, '2024-08-15T12:58:49.251792');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 4, 'Video 4', 'amazing great cool', {'tag4', 'tag1'}, '2024-09-10T12:58:49.251815');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 5, 'Video 5', 'beautiful interesting wonderful', {'tag14'}, '2024-08-22T12:58:49.251834');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 6, 'Video 6', 'wonderful awesome wonderful', {'tag8', 'tag6', 'tag10'}, '2024-08-29T12:58:49.251853');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 7, 'Video 7', 'beautiful awesome cool', {'tag7', 'tag15'}, '2024-08-05T12:58:49.251871');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 8, 'Video 8', 'wonderful beautiful interesting', {'tag10'}, '2024-08-23T12:58:49.251890');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 9, 'Video 9', 'interesting great beautiful', {'tag13', 'tag6', 'tag6'}, '2024-08-30T12:58:49.251912');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 10, 'Video 10', 'beautiful interesting great', {'tag7'}, '2024-09-02T12:58:49.251937');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 11, 'Video 11', 'amazing great interesting', {'tag4'}, '2024-10-05T12:58:49.251949');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 12, 'Video 12', 'cool beautiful awesome', {'tag15', 'tag7'}, '2024-09-27T12:58:49.251972');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 13, 'Video 13', 'awesome beautiful great', {'tag2', 'tag12', 'tag2'}, '2024-08-22T12:58:49.252002');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 14, 'Video 14', 'interesting beautiful interesting', {'tag11', 'tag14', 'tag10'}, '2024-10-07T12:58:49.252016');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 15, 'Video 15', 'awesome awesome great', {'tag7', 'tag12', 'tag1'}, '2024-08-29T12:58:49.252028');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 16, 'Video 16', 'wonderful interesting cool', {'tag4', 'tag2'}, '2024-09-27T12:58:49.252039');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 17, 'Video 17', 'wonderful cool wonderful', {'tag10'}, '2024-10-11T12:58:49.252050');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 18, 'Video 18', 'beautiful great amazing', {'tag8'}, '2024-10-09T12:58:49.252068');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 19, 'Video 19', 'great beautiful great', {'tag3', 'tag3'}, '2024-11-04T12:58:49.252080');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 20, 'Video 20', 'interesting beautiful interesting', {'tag8', 'tag6'}, '2024-08-13T12:58:49.252091');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 21, 'Video 21', 'wonderful great wonderful', {'tag10', 'tag14'}, '2024-09-03T12:58:49.252140');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 22, 'Video 22', 'beautiful great wonderful', {'tag12'}, '2024-11-06T12:58:49.252153');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 23, 'Video 23', 'wonderful beautiful cool', {'tag1'}, '2024-09-24T12:58:49.252164');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 24, 'Video 24', 'beautiful beautiful great', {'tag4'}, '2024-09-29T12:58:49.252175');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 25, 'Video 25', 'awesome great awesome', {'tag10'}, '2024-10-17T12:58:49.252185');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user11', '2024-10-18T12:58:49.252193', 'wonderful wonderful wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user3', '2024-09-21T12:58:49.252203', 'beautiful interesting amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (3, 'user5', '2024-10-02T12:58:49.252213', 'amazing wonderful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user17', '2024-08-14T12:58:49.252222', 'amazing interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user15', '2024-08-25T12:58:49.252230', 'amazing beautiful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user9', '2024-08-13T12:58:49.252239', 'great interesting wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user15', '2024-08-14T12:58:49.252247', 'amazing great great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (3, 'user15', '2024-08-26T12:58:49.252255', 'amazing amazing amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user2', '2024-09-03T12:58:49.252263', 'awesome cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (3, 'user4', '2024-10-02T12:58:49.252272', 'beautiful interesting wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user4', '2024-08-28T12:58:49.252280', 'great interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user13', '2024-09-14T12:58:49.252289', 'interesting beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user15', '2024-08-05T12:58:49.252297', 'interesting cool cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user11', '2024-08-06T12:58:49.252306', 'amazing wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user3', '2024-08-21T12:58:49.252314', 'interesting great wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user9', '2024-08-27T12:58:49.252322', 'great great interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user2', '2024-09-17T12:58:49.252331', 'interesting beautiful interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user5', '2024-10-28T12:58:49.252339', 'great awesome cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user16', '2024-09-27T12:58:49.252348', 'amazing awesome cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user14', '2024-08-05T12:58:49.252356', 'interesting beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user3', '2024-08-17T12:58:49.252364', 'great interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (5, 'user1', '2024-10-26T12:58:49.252373', 'beautiful interesting great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user7', '2024-08-06T12:58:49.252381', 'amazing wonderful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user8', '2024-08-20T12:58:49.252389', 'amazing amazing interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user1', '2024-09-25T12:58:49.252398', 'wonderful awesome awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user16', '2024-08-10T12:58:49.252406', 'awesome great amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user17', '2024-10-30T12:58:49.252414', 'beautiful interesting amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user16', '2024-08-07T12:58:49.252422', 'amazing beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (18, 'user17', '2024-09-21T12:58:49.252431', 'cool wonderful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user4', '2024-10-19T12:58:49.252439', 'awesome great cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-08-17T12:58:49.252447', 15, 'cool amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-08-30T12:58:49.252456', 8, 'awesome interesting wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-25T12:58:49.252466', 10, 'awesome great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-21T12:58:49.252474', 15, 'awesome interesting awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-11-03T12:58:49.252482', 11, 'cool awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-11-06T12:58:49.252491', 20, 'cool great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-10-15T12:58:49.252499', 10, 'beautiful great interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-11-04T12:58:49.252513', 19, 'awesome interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-08-18T12:58:49.252522', 3, 'wonderful beautiful cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user1', '2024-10-01T12:58:49.252530', 11, 'amazing wonderful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-11-04T12:58:49.252538', 19, 'great wonderful awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-08-04T12:58:49.252546', 13, 'awesome awesome awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-05T12:58:49.252582', 13, 'awesome awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-09-15T12:58:49.252598', 9, 'wonderful great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-24T12:58:49.252607', 10, 'wonderful amazing wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-10-09T12:58:49.252615', 11, 'interesting wonderful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-08-24T12:58:49.252624', 24, 'great beautiful beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-11T12:58:49.252632', 16, 'cool awesome awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-02T12:58:49.252640', 6, 'amazing wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-10-10T12:58:49.252649', 21, 'cool cool interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-10-19T12:58:49.252657', 10, 'awesome cool great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-08-19T12:58:49.252665', 17, 'interesting interesting cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-18T12:58:49.252674', 21, 'cool cool wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-24T12:58:49.252682', 1, 'amazing cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-09-29T12:58:49.252690', 5, 'interesting great cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-19T12:58:49.252698', 12, 'beautiful amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-09-04T12:58:49.252706', 8, 'awesome beautiful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-04T12:58:49.252714', 23, 'amazing amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-11-01T12:58:49.252722', 14, 'great great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user11', '2024-08-16T12:58:49.252730', 8, 'amazing interesting beautiful');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (8, 'user16');
INSERT INTO seguidores_video (video_id, username) VALUES (6, 'user5');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (6, 'user5');
INSERT INTO seguidores_video (video_id, username) VALUES (8, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (14, 'user17');
INSERT INTO seguidores_video (video_id, username) VALUES (7, 'user14');
INSERT INTO seguidores_video (video_id, username) VALUES (4, 'user4');
INSERT INTO seguidores_video (video_id, username) VALUES (8, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (17, 'user4');
INSERT INTO seguidores_video (video_id, username) VALUES (1, 'user3');
INSERT INTO seguidores_video (video_id, username) VALUES (6, 'user6');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user15');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user17');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user8', 'play', '2024-11-02T12:58:49.252773', 16);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user17', 'play', '2024-09-09T12:58:49.252783', 469);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user3', 'pause', '2024-10-19T12:58:49.252792', 378);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user5', 'stop', '2024-09-04T12:58:49.252800', 204);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user16', 'play', '2024-10-08T12:58:49.252808', 343);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user1', 'pause', '2024-11-01T12:58:49.252816', 233);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user12', 'stop', '2024-08-21T12:58:49.252823', 363);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user11', 'play', '2024-10-10T12:58:49.252830', 366);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (21, 'user1', 'pause', '2024-10-07T12:58:49.252837', 282);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (25, 'user3', 'pause', '2024-10-06T12:58:49.252845', 114);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user12', 'pause', '2024-09-05T12:58:49.252852', 4);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user2', 'play', '2024-09-20T12:58:49.252859', 305);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (25, 'user17', 'stop', '2024-09-12T12:58:49.252867', 263);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user8', 'play', '2024-11-05T12:58:49.252874', 49);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user9', 'pause', '2024-11-02T12:58:49.252881', 92);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user11', 'pause', '2024-09-23T12:58:49.252889', 255);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (10, 'user17', 'play', '2024-09-07T12:58:49.252896', 294);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user16', 'pause', '2024-08-30T12:58:49.252903', 27);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (18, 'user13', 'play', '2024-09-05T12:58:49.252910', 257);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user16', 'play', '2024-09-30T12:58:49.252918', 219);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (1, 'user15', 'pause', '2024-08-27T12:58:49.252925', 220);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user9', 'stop', '2024-09-12T12:58:49.252932', 481);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user15', 'pause', '2024-10-17T12:58:49.252939', 472);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user13', 'pause', '2024-11-05T12:58:49.252946', 296);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user10', 'stop', '2024-10-16T12:58:49.252959', 273);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (18, 'user1', 'play', '2024-10-04T12:58:49.252967', 425);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user13', 'pause', '2024-10-27T12:58:49.252996', 229);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user6', 'stop', '2024-10-03T12:58:49.253005', 32);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user3', 'play', '2024-08-06T12:58:49.253013', 172);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user10', 'play', '2024-08-16T12:58:49.253020', 272);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user9', '2024-09-04T12:58:49.253028', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user2', '2024-09-10T12:58:49.253037', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user15', '2024-09-19T12:58:49.253044', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user6', '2024-10-23T12:58:49.253050', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user4', '2024-10-06T12:58:49.253057', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user2', '2024-09-07T12:58:49.253063', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user10', '2024-10-17T12:58:49.253070', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user11', '2024-10-31T12:58:49.253076', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user13', '2024-10-28T12:58:49.253082', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user5', '2024-11-01T12:58:49.253088', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user10', '2024-10-17T12:58:49.253095', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user2', '2024-08-09T12:58:49.253101', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user7', '2024-10-12T12:58:49.253107', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user3', '2024-10-29T12:58:49.253114', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user14', '2024-09-12T12:58:49.253125', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user16', '2024-08-03T12:58:49.253131', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user3', '2024-11-03T12:58:49.253137', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user1', '2024-08-01T12:58:49.253144', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user8', '2024-09-04T12:58:49.253150', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (12, 'user4', '2024-08-30T12:58:49.253156', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user12', '2024-10-25T12:58:49.253162', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (22, 'user16', '2024-08-10T12:58:49.253169', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user4', '2024-08-25T12:58:49.253175', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user9', '2024-10-29T12:58:49.253181', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user2', '2024-08-11T12:58:49.253187', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (12, 'user14', '2024-09-08T12:58:49.253194', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user6', '2024-08-08T12:58:49.253200', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user4', '2024-09-28T12:58:49.253206', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user11', '2024-08-07T12:58:49.253212', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user6', '2024-07-31T12:58:49.253218', 5);
