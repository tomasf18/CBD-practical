
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
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-10-08T18:15:41.590649');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-10-26T18:15:41.590662');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-09-26T18:15:41.590669');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-08-26T18:15:41.590674');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-10-05T18:15:41.590677');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-09-01T18:15:41.590681');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-09-20T18:15:41.590684');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-08-12T18:15:41.590686');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-10-29T18:15:41.590689');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-09-27T18:15:41.590692');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-11-03T18:15:41.590695');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-09-14T18:15:41.590698');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-09-08T18:15:41.590701');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-09-15T18:15:41.590704');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-09-27T18:15:41.590707');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-09-06T18:15:41.590710');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-09-23T18:15:41.590713');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 1, 'Video 1', 'cool interesting interesting', {'tag15'}, '2024-08-31T18:15:41.590727');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 2, 'Video 2', 'beautiful interesting wonderful', {'tag15'}, '2024-08-12T18:15:41.590737');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 3, 'Video 3', 'wonderful great interesting', {'tag1', 'tag7'}, '2024-08-29T18:15:41.590746');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 4, 'Video 4', 'beautiful great wonderful', {'tag13', 'tag2'}, '2024-10-16T18:15:41.590753');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 5, 'Video 5', 'awesome awesome cool', {'tag15', 'tag5'}, '2024-08-05T18:15:41.590760');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 6, 'Video 6', 'cool amazing beautiful', {'tag9', 'tag9'}, '2024-09-22T18:15:41.590767');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 7, 'Video 7', 'interesting interesting interesting', {'tag11', 'tag13'}, '2024-10-30T18:15:41.590774');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 8, 'Video 8', 'cool amazing wonderful', {'tag1', 'tag9'}, '2024-09-14T18:15:41.590781');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 9, 'Video 9', 'cool great interesting', {'tag15', 'tag14', 'tag13'}, '2024-09-28T18:15:41.590788');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 10, 'Video 10', 'awesome amazing amazing', {'tag12', 'tag1'}, '2024-10-24T18:15:41.590795');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 11, 'Video 11', 'cool beautiful wonderful', {'tag10'}, '2024-07-31T18:15:41.590802');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 12, 'Video 12', 'amazing beautiful beautiful', {'tag2', 'tag4'}, '2024-10-10T18:15:41.590808');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 13, 'Video 13', 'amazing wonderful great', {'tag8'}, '2024-10-18T18:15:41.590815');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 14, 'Video 14', 'wonderful awesome amazing', {'tag14', 'tag7', 'tag3'}, '2024-09-10T18:15:41.590825');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 15, 'Video 15', 'great awesome amazing', {'tag9', 'tag8'}, '2024-09-01T18:15:41.590832');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 16, 'Video 16', 'awesome beautiful wonderful', {'tag14', 'tag5', 'tag2'}, '2024-09-12T18:15:41.590839');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 17, 'Video 17', 'awesome cool beautiful', {'tag8', 'tag3', 'tag8'}, '2024-08-29T18:15:41.590846');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 18, 'Video 18', 'amazing wonderful wonderful', {'tag5'}, '2024-10-19T18:15:41.590875');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 19, 'Video 19', 'great amazing awesome', {'tag13', 'tag10'}, '2024-08-17T18:15:41.590883');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 20, 'Video 20', 'wonderful beautiful awesome', {'tag2', 'tag3'}, '2024-08-21T18:15:41.590890');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 21, 'Video 21', 'cool interesting interesting', {'tag6', 'tag13'}, '2024-08-20T18:15:41.590897');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 22, 'Video 22', 'great wonderful awesome', {'tag7'}, '2024-10-10T18:15:41.590903');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 23, 'Video 23', 'great wonderful interesting', {'tag7'}, '2024-09-28T18:15:41.590909');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 24, 'Video 24', 'beautiful interesting cool', {'tag8', 'tag4'}, '2024-10-26T18:15:41.590916');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 25, 'Video 25', 'awesome cool beautiful', {'tag4', 'tag9', 'tag2'}, '2024-10-08T18:15:41.590923');
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (1, 'user4', '2024-08-30T18:15:41.590930', 'Video 1', 'cool awesome great', {'tag14', 'tag8', 'tag13'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (2, 'user13', '2024-10-21T18:15:41.590937', 'Video 2', 'amazing great awesome', {'tag11'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (3, 'user7', '2024-08-30T18:15:41.590945', 'Video 3', 'beautiful beautiful wonderful', {'tag14', 'tag6', 'tag7'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (4, 'user6', '2024-10-29T18:15:41.590952', 'Video 4', 'amazing cool wonderful', {'tag14', 'tag6', 'tag3'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (5, 'user13', '2024-10-22T18:15:41.590958', 'Video 5', 'wonderful beautiful interesting', {'tag6'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (6, 'user11', '2024-09-12T18:15:41.590964', 'Video 6', 'beautiful great wonderful', {'tag10'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (7, 'user16', '2024-11-05T18:15:41.590971', 'Video 7', 'beautiful great interesting', {'tag3', 'tag8', 'tag12'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (8, 'user8', '2024-09-20T18:15:41.590978', 'Video 8', 'amazing wonderful beautiful', {'tag10'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (9, 'user11', '2024-10-15T18:15:41.590984', 'Video 9', 'amazing great wonderful', {'tag6'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (10, 'user14', '2024-08-11T18:15:41.590991', 'Video 10', 'cool interesting wonderful', {'tag10', 'tag6'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (11, 'user16', '2024-10-08T18:15:41.590998', 'Video 11', 'beautiful awesome great', {'tag6', 'tag2'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (12, 'user3', '2024-08-14T18:15:41.591004', 'Video 12', 'interesting wonderful great', {'tag13'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (13, 'user1', '2024-10-01T18:15:41.591011', 'Video 13', 'interesting cool amazing', {'tag2', 'tag1', 'tag7'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (14, 'user15', '2024-08-13T18:15:41.591018', 'Video 14', 'cool interesting great', {'tag9', 'tag8'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (15, 'user5', '2024-10-31T18:15:41.591024', 'Video 15', 'great interesting beautiful', {'tag10', 'tag3'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (16, 'user8', '2024-10-22T18:15:41.591031', 'Video 16', 'great wonderful beautiful', {'tag9'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (17, 'user12', '2024-08-05T18:15:41.591040', 'Video 17', 'awesome cool amazing', {'tag10', 'tag15'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (18, 'user16', '2024-11-03T18:15:41.591047', 'Video 18', 'interesting beautiful great', {'tag14'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (19, 'user10', '2024-10-03T18:15:41.591054', 'Video 19', 'beautiful awesome wonderful', {'tag2', 'tag7', 'tag4'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (20, 'user14', '2024-09-29T18:15:41.591061', 'Video 20', 'amazing interesting awesome', {'tag11', 'tag1', 'tag7'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (21, 'user7', '2024-08-15T18:15:41.591067', 'Video 21', 'awesome wonderful great', {'tag8', 'tag14', 'tag7'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (22, 'user1', '2024-10-19T18:15:41.591074', 'Video 22', 'amazing beautiful awesome', {'tag12', 'tag8'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (23, 'user3', '2024-10-16T18:15:41.591080', 'Video 23', 'cool beautiful beautiful', {'tag9'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (24, 'user6', '2024-10-05T18:15:41.591087', 'Video 24', 'beautiful great wonderful', {'tag9', 'tag7'});
INSERT INTO videos_por_data (video_id, autor_username, data_upload, nome, descricao, tags) VALUES (25, 'user4', '2024-09-22T18:15:41.591093', 'Video 25', 'amazing wonderful cool', {'tag6'});
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 1, 'Video 1', 'great interesting awesome', {'tag7', 'tag7', 'tag14'}, '2024-09-22T18:15:41.591101');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 2, 'Video 2', 'awesome beautiful awesome', {'tag8', 'tag14'}, '2024-08-02T18:15:41.591107');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 3, 'Video 3', 'interesting awesome amazing', {'tag12', 'tag3', 'tag8'}, '2024-09-11T18:15:41.591115');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 4, 'Video 4', 'wonderful cool beautiful', {'tag2', 'tag15'}, '2024-10-02T18:15:41.591121');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 5, 'Video 5', 'awesome beautiful amazing', {'tag3', 'tag4', 'tag2'}, '2024-11-01T18:15:41.591128');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 6, 'Video 6', 'wonderful wonderful interesting', {'tag13', 'tag3', 'tag15'}, '2024-11-05T18:15:41.591135');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 7, 'Video 7', 'cool beautiful wonderful', {'tag2', 'tag9'}, '2024-11-04T18:15:41.591142');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 8, 'Video 8', 'great awesome amazing', {'tag5', 'tag4', 'tag6'}, '2024-11-02T18:15:41.591160');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 9, 'Video 9', 'beautiful beautiful awesome', {'tag15', 'tag7'}, '2024-10-31T18:15:41.591167');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 10, 'Video 10', 'interesting beautiful amazing', {'tag3'}, '2024-09-06T18:15:41.591181');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 11, 'Video 11', 'great wonderful cool', {'tag12'}, '2024-10-01T18:15:41.591188');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 12, 'Video 12', 'great cool amazing', {'tag2'}, '2024-11-05T18:15:41.591194');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 13, 'Video 13', 'interesting beautiful cool', {'tag1'}, '2024-10-07T18:15:41.591200');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 14, 'Video 14', 'great amazing wonderful', {'tag4'}, '2024-08-31T18:15:41.591207');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 15, 'Video 15', 'interesting awesome amazing', {'tag6'}, '2024-09-10T18:15:41.591213');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 16, 'Video 16', 'interesting awesome beautiful', {'tag13'}, '2024-08-21T18:15:41.591219');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 17, 'Video 17', 'wonderful wonderful amazing', {'tag14'}, '2024-11-01T18:15:41.591225');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 18, 'Video 18', 'beautiful great beautiful', {'tag15'}, '2024-08-10T18:15:41.591232');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 19, 'Video 19', 'wonderful beautiful interesting', {'tag1'}, '2024-08-19T18:15:41.591238');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 20, 'Video 20', 'awesome great great', {'tag8', 'tag11'}, '2024-09-09T18:15:41.591245');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 21, 'Video 21', 'cool interesting great', {'tag8', 'tag7', 'tag13'}, '2024-08-23T18:15:41.591251');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 22, 'Video 22', 'wonderful great wonderful', {'tag12', 'tag15'}, '2024-09-16T18:15:41.591258');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 23, 'Video 23', 'amazing interesting awesome', {'tag1', 'tag7', 'tag7'}, '2024-08-27T18:15:41.591265');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 24, 'Video 24', 'interesting beautiful interesting', {'tag14'}, '2024-08-16T18:15:41.591271');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 25, 'Video 25', 'great wonderful wonderful', {'tag9', 'tag3'}, '2024-09-24T18:15:41.591277');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user4', '2024-08-07T18:15:41.591282', 'beautiful amazing amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user7', '2024-08-09T18:15:41.591288', 'cool amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user16', '2024-09-24T18:15:41.591295', 'awesome beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user11', '2024-08-14T18:15:41.591301', 'interesting wonderful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user11', '2024-07-30T18:15:41.591306', 'awesome amazing beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user6', '2024-08-09T18:15:41.591312', 'interesting great awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user6', '2024-08-26T18:15:41.591317', 'interesting awesome great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user10', '2024-10-01T18:15:41.591322', 'interesting awesome beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user7', '2024-09-08T18:15:41.591327', 'cool beautiful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user15', '2024-10-11T18:15:41.591332', 'cool beautiful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user4', '2024-09-15T18:15:41.591337', 'great beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (7, 'user9', '2024-08-26T18:15:41.591342', 'interesting beautiful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (2, 'user4', '2024-11-04T18:15:41.591347', 'great beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user3', '2024-09-08T18:15:41.591352', 'wonderful interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (24, 'user13', '2024-10-04T18:15:41.591358', 'great great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user7', '2024-08-13T18:15:41.591363', 'cool amazing great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user4', '2024-10-19T18:15:41.591368', 'beautiful awesome amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user11', '2024-10-10T18:15:41.591373', 'amazing interesting wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user7', '2024-08-21T18:15:41.591378', 'great cool awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user9', '2024-09-24T18:15:41.591383', 'wonderful awesome amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user1', '2024-08-12T18:15:41.591388', 'beautiful beautiful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user8', '2024-10-21T18:15:41.591394', 'great amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user4', '2024-09-13T18:15:41.591399', 'cool beautiful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (18, 'user12', '2024-11-01T18:15:41.591404', 'awesome beautiful cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user2', '2024-09-25T18:15:41.591409', 'beautiful awesome amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user2', '2024-10-12T18:15:41.591414', 'beautiful amazing great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user8', '2024-09-16T18:15:41.591419', 'great great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user14', '2024-10-11T18:15:41.591436', 'interesting amazing beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (8, 'user15', '2024-08-01T18:15:41.591443', 'cool cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user1', '2024-09-11T18:15:41.591448', 'wonderful wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user11', '2024-10-20T18:15:41.591453', 18, 'beautiful amazing beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user11', '2024-08-07T18:15:41.591459', 11, 'great cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-09-10T18:15:41.591464', 16, 'interesting amazing wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-10-07T18:15:41.591469', 17, 'interesting cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-08-17T18:15:41.591474', 23, 'awesome wonderful beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-17T18:15:41.591479', 12, 'beautiful interesting cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-08-16T18:15:41.591485', 7, 'wonderful interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-14T18:15:41.591490', 7, 'beautiful cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-10-21T18:15:41.591495', 10, 'amazing cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-09-08T18:15:41.591500', 10, 'cool interesting great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-08-26T18:15:41.591505', 4, 'great wonderful beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-10-12T18:15:41.591510', 2, 'awesome wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-10-12T18:15:41.591515', 23, 'wonderful amazing interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-08-29T18:15:41.591520', 21, 'great beautiful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-09-16T18:15:41.591525', 14, 'great amazing cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-08-11T18:15:41.591530', 8, 'interesting wonderful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-10-01T18:15:41.591535', 9, 'interesting great amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user3', '2024-10-26T18:15:41.591540', 17, 'great beautiful interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-08-01T18:15:41.591545', 16, 'cool great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-11-02T18:15:41.591550', 9, 'cool great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-10-20T18:15:41.591555', 18, 'beautiful awesome great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-20T18:15:41.591560', 3, 'awesome beautiful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-09-13T18:15:41.591565', 8, 'awesome interesting amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-10-27T18:15:41.591570', 19, 'amazing cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-09-18T18:15:41.591575', 13, 'great interesting wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-09-04T18:15:41.591580', 3, 'interesting great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-09-12T18:15:41.591585', 20, 'cool awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-09-19T18:15:41.591590', 25, 'interesting amazing beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-14T18:15:41.591595', 19, 'beautiful wonderful wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-02T18:15:41.591600', 24, 'amazing great wonderful');
INSERT INTO seguidores_video (video_id, username) VALUES (2, 'user2');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user14');
INSERT INTO seguidores_video (video_id, username) VALUES (6, 'user13');
INSERT INTO seguidores_video (video_id, username) VALUES (3, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (22, 'user2');
INSERT INTO seguidores_video (video_id, username) VALUES (19, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (23, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (23, 'user14');
INSERT INTO seguidores_video (video_id, username) VALUES (25, 'user7');
INSERT INTO seguidores_video (video_id, username) VALUES (10, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (1, 'user6');
INSERT INTO seguidores_video (video_id, username) VALUES (23, 'user7');
INSERT INTO seguidores_video (video_id, username) VALUES (19, 'user14');
INSERT INTO seguidores_video (video_id, username) VALUES (18, 'user17');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user13', 'pause', '2024-09-18T18:15:41.591629', 186);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user11', 'pause', '2024-08-05T18:15:41.591636', 461);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user14', 'pause', '2024-10-12T18:15:41.591641', 396);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user6', 'pause', '2024-10-11T18:15:41.591646', 155);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user12', 'play', '2024-10-25T18:15:41.591651', 163);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user9', 'pause', '2024-09-29T18:15:41.591656', 13);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user6', 'play', '2024-09-20T18:15:41.591660', 232);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (6, 'user4', 'pause', '2024-10-17T18:15:41.591664', 14);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user5', 'stop', '2024-10-14T18:15:41.591679', 402);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user15', 'play', '2024-10-07T18:15:41.591684', 188);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (4, 'user2', 'play', '2024-08-01T18:15:41.591688', 195);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user7', 'pause', '2024-09-23T18:15:41.591693', 311);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user10', 'pause', '2024-08-28T18:15:41.591698', 57);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user3', 'stop', '2024-09-15T18:15:41.591702', 169);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (21, 'user6', 'stop', '2024-09-10T18:15:41.591706', 308);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user3', 'stop', '2024-09-27T18:15:41.591711', 426);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user15', 'pause', '2024-09-04T18:15:41.591715', 266);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user11', 'play', '2024-08-08T18:15:41.591719', 346);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user12', 'stop', '2024-10-06T18:15:41.591724', 142);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (17, 'user11', 'stop', '2024-11-05T18:15:41.591728', 214);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user17', 'pause', '2024-08-09T18:15:41.591733', 192);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user15', 'pause', '2024-09-13T18:15:41.591737', 57);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (12, 'user6', 'stop', '2024-11-01T18:15:41.591741', 115);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user13', 'pause', '2024-09-07T18:15:41.591746', 393);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user11', 'play', '2024-08-16T18:15:41.591750', 291);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (9, 'user2', 'play', '2024-09-18T18:15:41.591754', 385);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user5', 'pause', '2024-10-02T18:15:41.591759', 107);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (13, 'user12', 'stop', '2024-09-06T18:15:41.591763', 42);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user13', 'play', '2024-08-12T18:15:41.591768', 156);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user14', 'play', '2024-10-15T18:15:41.591772', 339);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user6', '2024-10-16T18:15:41.591776', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user16', '2024-10-05T18:15:41.591781', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user7', '2024-10-31T18:15:41.591786', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user17', '2024-08-20T18:15:41.591790', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user5', '2024-09-03T18:15:41.591793', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (19, 'user5', '2024-10-19T18:15:41.591798', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user3', '2024-10-06T18:15:41.591801', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user7', '2024-11-05T18:15:41.591805', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (5, 'user17', '2024-09-18T18:15:41.591809', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user8', '2024-10-08T18:15:41.591813', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user7', '2024-08-02T18:15:41.591817', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user12', '2024-09-01T18:15:41.591821', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user5', '2024-08-06T18:15:41.591825', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user17', '2024-10-07T18:15:41.591828', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user8', '2024-08-30T18:15:41.591835', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user12', '2024-08-12T18:15:41.591839', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user8', '2024-09-05T18:15:41.591843', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (3, 'user2', '2024-10-27T18:15:41.591847', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user6', '2024-08-10T18:15:41.591851', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user3', '2024-11-02T18:15:41.591854', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user6', '2024-11-02T18:15:41.591858', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user9', '2024-09-20T18:15:41.591862', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user8', '2024-09-03T18:15:41.591866', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user13', '2024-08-17T18:15:41.591870', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (1, 'user8', '2024-08-28T18:15:41.591874', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user5', '2024-11-04T18:15:41.591878', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user14', '2024-08-09T18:15:41.591881', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (19, 'user14', '2024-09-02T18:15:41.591885', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user3', '2024-08-21T18:15:41.591889', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user7', '2024-10-29T18:15:41.591893', 2);
