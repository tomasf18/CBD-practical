
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

CREATE TABLE videos_autor (
    autor_username      TEXT, 
    video_id            INT, 
    data_upload         TIMESTAMP,
    nome                TEXT,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((autor_username), data_upload, video_id)
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

CREATE TABLE ratings_video (
    video_id            INT,
    autor_rating        TEXT,
    data_rating         TIMESTAMP,
    rating              INT,
    PRIMARY KEY ((video_id), autor_rating, data_rating)
);
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user1', 'User Name 1', 'user1@example.com', '2024-11-03T10:39:09.498883');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user2', 'User Name 2', 'user2@example.com', '2024-10-17T10:39:09.498906');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user3', 'User Name 3', 'user3@example.com', '2024-09-28T10:39:09.498916');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user4', 'User Name 4', 'user4@example.com', '2024-11-14T10:39:09.498922');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user5', 'User Name 5', 'user5@example.com', '2024-10-10T10:39:09.498927');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user6', 'User Name 6', 'user6@example.com', '2024-11-02T10:39:09.498932');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user7', 'User Name 7', 'user7@example.com', '2024-11-06T10:39:09.498936');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user8', 'User Name 8', 'user8@example.com', '2024-10-30T10:39:09.498940');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user9', 'User Name 9', 'user9@example.com', '2024-09-07T10:39:09.498944');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user10', 'User Name 10', 'user10@example.com', '2024-10-24T10:39:09.498948');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user11', 'User Name 11', 'user11@example.com', '2024-09-05T10:39:09.498952');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user12', 'User Name 12', 'user12@example.com', '2024-11-18T10:39:09.498956');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user13', 'User Name 13', 'user13@example.com', '2024-11-10T10:39:09.498960');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user14', 'User Name 14', 'user14@example.com', '2024-10-09T10:39:09.498964');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user15', 'User Name 15', 'user15@example.com', '2024-09-24T10:39:09.498968');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user16', 'User Name 16', 'user16@example.com', '2024-08-15T10:39:09.498972');
INSERT INTO utilizadores (username, nome, email, data_registo) VALUES ('user17', 'User Name 17', 'user17@example.com', '2024-09-11T10:39:09.498976');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 1, 'Video 1', 'awesome beautiful beautiful', {'tag15', 'tag6'}, '2024-11-01T10:39:09.499003');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 1, 'user9', 'Video 1', 'awesome beautiful beautiful', '2024-11-01T10:39:09.499003');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 1, 'user9', 'Video 1', 'awesome beautiful beautiful', '2024-11-01T10:39:09.499003');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 2, 'Video 2', 'great great amazing', {'tag9', 'tag7', 'tag2'}, '2024-10-30T10:39:09.499031');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 2, 'user8', 'Video 2', 'great great amazing', '2024-10-30T10:39:09.499031');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 2, 'user8', 'Video 2', 'great great amazing', '2024-10-30T10:39:09.499031');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 2, 'user8', 'Video 2', 'great great amazing', '2024-10-30T10:39:09.499031');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 3, 'Video 3', 'awesome cool amazing', {'tag15', 'tag6'}, '2024-11-11T10:39:09.499048');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 3, 'user17', 'Video 3', 'awesome cool amazing', '2024-11-11T10:39:09.499048');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 3, 'user17', 'Video 3', 'awesome cool amazing', '2024-11-11T10:39:09.499048');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 4, 'Video 4', 'interesting amazing amazing', {'tag8'}, '2024-09-24T10:39:09.499060');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag8', 4, 'user17', 'Video 4', 'interesting amazing amazing', '2024-09-24T10:39:09.499060');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 5, 'Video 5', 'beautiful great amazing', {'tag7'}, '2024-08-25T10:39:09.499070');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag7', 5, 'user14', 'Video 5', 'beautiful great amazing', '2024-08-25T10:39:09.499070');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 6, 'Video 6', 'cool beautiful wonderful', {'tag15', 'tag6'}, '2024-10-13T10:39:09.499081');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 6, 'user17', 'Video 6', 'cool beautiful wonderful', '2024-10-13T10:39:09.499081');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 6, 'user17', 'Video 6', 'cool beautiful wonderful', '2024-10-13T10:39:09.499081');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 7, 'Video 7', 'interesting great interesting', {'tag9', 'tag1'}, '2024-09-01T10:39:09.499143');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 7, 'user11', 'Video 7', 'interesting great interesting', '2024-09-01T10:39:09.499143');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 7, 'user11', 'Video 7', 'interesting great interesting', '2024-09-01T10:39:09.499143');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 8, 'Video 8', 'great cool amazing', {'tag13', 'tag6'}, '2024-09-02T10:39:09.499157');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 8, 'user11', 'Video 8', 'great cool amazing', '2024-09-02T10:39:09.499157');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag6', 8, 'user11', 'Video 8', 'great cool amazing', '2024-09-02T10:39:09.499157');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user13', 9, 'Video 9', 'awesome awesome awesome', {'tag9'}, '2024-08-30T10:39:09.499168');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 9, 'user13', 'Video 9', 'awesome awesome awesome', '2024-08-30T10:39:09.499168');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 10, 'Video 10', 'amazing cool great', {'tag10', 'tag3', 'tag4'}, '2024-11-14T10:39:09.499179');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 10, 'user17', 'Video 10', 'amazing cool great', '2024-11-14T10:39:09.499179');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 10, 'user17', 'Video 10', 'amazing cool great', '2024-11-14T10:39:09.499179');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 10, 'user17', 'Video 10', 'amazing cool great', '2024-11-14T10:39:09.499179');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 11, 'Video 11', 'interesting wonderful great', {'tag14'}, '2024-09-19T10:39:09.499191');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 11, 'user16', 'Video 11', 'interesting wonderful great', '2024-09-19T10:39:09.499191');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 12, 'Video 12', 'amazing interesting beautiful', {'tag5', 'tag12', 'tag4'}, '2024-10-11T10:39:09.499203');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 12, 'user2', 'Video 12', 'amazing interesting beautiful', '2024-10-11T10:39:09.499203');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 12, 'user2', 'Video 12', 'amazing interesting beautiful', '2024-10-11T10:39:09.499203');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag4', 12, 'user2', 'Video 12', 'amazing interesting beautiful', '2024-10-11T10:39:09.499203');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 13, 'Video 13', 'beautiful wonderful amazing', {'tag11', 'tag10'}, '2024-09-19T10:39:09.499214');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 13, 'user6', 'Video 13', 'beautiful wonderful amazing', '2024-09-19T10:39:09.499214');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 13, 'user6', 'Video 13', 'beautiful wonderful amazing', '2024-09-19T10:39:09.499214');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 14, 'Video 14', 'awesome wonderful cool', {'tag9', 'tag3', 'tag15'}, '2024-11-17T10:39:09.499227');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 14, 'user10', 'Video 14', 'awesome wonderful cool', '2024-11-17T10:39:09.499227');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 14, 'user10', 'Video 14', 'awesome wonderful cool', '2024-11-17T10:39:09.499227');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 14, 'user10', 'Video 14', 'awesome wonderful cool', '2024-11-17T10:39:09.499227');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 15, 'Video 15', 'cool awesome interesting', {'tag15', 'tag14'}, '2024-09-06T10:39:09.499238');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 15, 'user3', 'Video 15', 'cool awesome interesting', '2024-09-06T10:39:09.499238');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 15, 'user3', 'Video 15', 'cool awesome interesting', '2024-09-06T10:39:09.499238');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user9', 16, 'Video 16', 'wonderful wonderful interesting', {'tag5'}, '2024-10-09T10:39:09.499249');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 16, 'user9', 'Video 16', 'wonderful wonderful interesting', '2024-10-09T10:39:09.499249');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 17, 'Video 17', 'beautiful awesome interesting', {'tag5', 'tag3', 'tag2'}, '2024-08-20T10:39:09.499260');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 17, 'user2', 'Video 17', 'beautiful awesome interesting', '2024-08-20T10:39:09.499260');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 17, 'user2', 'Video 17', 'beautiful awesome interesting', '2024-08-20T10:39:09.499260');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 17, 'user2', 'Video 17', 'beautiful awesome interesting', '2024-08-20T10:39:09.499260');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 18, 'Video 18', 'cool great beautiful', {'tag13', 'tag11'}, '2024-11-01T10:39:09.499272');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag13', 18, 'user7', 'Video 18', 'cool great beautiful', '2024-11-01T10:39:09.499272');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 18, 'user7', 'Video 18', 'cool great beautiful', '2024-11-01T10:39:09.499272');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 19, 'Video 19', 'cool interesting amazing', {'tag15', 'tag14'}, '2024-10-20T10:39:09.499283');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 19, 'user17', 'Video 19', 'cool interesting amazing', '2024-10-20T10:39:09.499283');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 19, 'user17', 'Video 19', 'cool interesting amazing', '2024-10-20T10:39:09.499283');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 20, 'Video 20', 'wonderful cool amazing', {'tag15', 'tag11', 'tag3'}, '2024-08-13T10:39:09.499294');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 20, 'user1', 'Video 20', 'wonderful cool amazing', '2024-08-13T10:39:09.499294');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 20, 'user1', 'Video 20', 'wonderful cool amazing', '2024-08-13T10:39:09.499294');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag3', 20, 'user1', 'Video 20', 'wonderful cool amazing', '2024-08-13T10:39:09.499294');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 21, 'Video 21', 'great great cool', {'tag15', 'tag5'}, '2024-10-12T10:39:09.499323');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag15', 21, 'user2', 'Video 21', 'great great cool', '2024-10-12T10:39:09.499323');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 21, 'user2', 'Video 21', 'great great cool', '2024-10-12T10:39:09.499323');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user16', 22, 'Video 22', 'great great wonderful', {'tag9', 'tag12'}, '2024-10-19T10:39:09.499335');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag9', 22, 'user16', 'Video 22', 'great great wonderful', '2024-10-19T10:39:09.499335');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag12', 22, 'user16', 'Video 22', 'great great wonderful', '2024-10-19T10:39:09.499335');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 23, 'Video 23', 'cool wonderful interesting', {'tag1', 'tag11', 'tag2'}, '2024-09-11T10:39:09.499346');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag1', 23, 'user10', 'Video 23', 'cool wonderful interesting', '2024-09-11T10:39:09.499346');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag11', 23, 'user10', 'Video 23', 'cool wonderful interesting', '2024-09-11T10:39:09.499346');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag2', 23, 'user10', 'Video 23', 'cool wonderful interesting', '2024-09-11T10:39:09.499346');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 24, 'Video 24', 'great great beautiful', {'tag5'}, '2024-08-29T10:39:09.499357');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 24, 'user12', 'Video 24', 'great great beautiful', '2024-08-29T10:39:09.499357');
INSERT INTO videos (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 25, 'Video 25', 'amazing great interesting', {'tag10', 'tag5', 'tag14'}, '2024-10-23T10:39:09.499368');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag10', 25, 'user4', 'Video 25', 'amazing great interesting', '2024-10-23T10:39:09.499368');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag5', 25, 'user4', 'Video 25', 'amazing great interesting', '2024-10-23T10:39:09.499368');
INSERT INTO videos_por_tag (tag, video_id, autor_username, nome, descricao, data_upload) VALUES ('tag14', 25, 'user4', 'Video 25', 'amazing great interesting', '2024-10-23T10:39:09.499368');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 1, 'Video 1', 'awesome wonderful amazing', {'tag15'}, '2024-10-10T10:39:09.499381');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 2, 'Video 2', 'awesome great great', {'tag9', 'tag5'}, '2024-08-23T10:39:09.499392');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 3, 'Video 3', 'awesome beautiful cool', {'tag1', 'tag15'}, '2024-09-13T10:39:09.499403');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 4, 'Video 4', 'beautiful awesome amazing', {'tag3', 'tag2'}, '2024-10-28T10:39:09.499412');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user12', 5, 'Video 5', 'great great amazing', {'tag15'}, '2024-10-11T10:39:09.499421');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 6, 'Video 6', 'cool awesome great', {'tag2'}, '2024-09-28T10:39:09.499430');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 7, 'Video 7', 'beautiful wonderful interesting', {'tag14'}, '2024-11-03T10:39:09.499441');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 8, 'Video 8', 'interesting amazing beautiful', {'tag14'}, '2024-11-13T10:39:09.499450');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user8', 9, 'Video 9', 'cool interesting amazing', {'tag5'}, '2024-08-28T10:39:09.499459');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user7', 10, 'Video 10', 'awesome amazing awesome', {'tag3'}, '2024-10-28T10:39:09.499468');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 11, 'Video 11', 'wonderful interesting beautiful', {'tag10', 'tag13', 'tag2'}, '2024-10-03T10:39:09.499478');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 12, 'Video 12', 'amazing beautiful wonderful', {'tag9', 'tag1', 'tag15'}, '2024-10-07T10:39:09.499488');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user15', 13, 'Video 13', 'beautiful awesome wonderful', {'tag9', 'tag14'}, '2024-11-04T10:39:09.499498');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user1', 14, 'Video 14', 'interesting cool amazing', {'tag2', 'tag13', 'tag14'}, '2024-08-19T10:39:09.499507');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user2', 15, 'Video 15', 'amazing wonderful interesting', {'tag13', 'tag5'}, '2024-09-14T10:39:09.499516');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 16, 'Video 16', 'great amazing amazing', {'tag15', 'tag6'}, '2024-11-10T10:39:09.499526');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user17', 17, 'Video 17', 'cool cool wonderful', {'tag12', 'tag5', 'tag6'}, '2024-09-08T10:39:09.499535');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user3', 18, 'Video 18', 'wonderful awesome beautiful', {'tag11', 'tag12'}, '2024-11-07T10:39:09.499545');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user5', 19, 'Video 19', 'interesting great wonderful', {'tag8', 'tag4'}, '2024-08-13T10:39:09.499559');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user6', 20, 'Video 20', 'great interesting great', {'tag2'}, '2024-09-18T10:39:09.499568');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user10', 21, 'Video 21', 'interesting interesting amazing', {'tag11', 'tag10'}, '2024-09-30T10:39:09.499577');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 22, 'Video 22', 'great beautiful great', {'tag4', 'tag14'}, '2024-10-31T10:39:09.499587');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user14', 23, 'Video 23', 'cool wonderful amazing', {'tag7', 'tag5', 'tag12'}, '2024-11-02T10:39:09.499596');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user4', 24, 'Video 24', 'great great cool', {'tag15', 'tag11', 'tag12'}, '2024-10-05T10:39:09.499636');
INSERT INTO videos_autor (autor_username, video_id, nome, descricao, tags, data_upload) VALUES ('user11', 25, 'Video 25', 'interesting amazing wonderful', {'tag15'}, '2024-10-10T10:39:09.499644');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (2, 'user10', '2024-11-07T10:39:09.499650', 'great amazing great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (24, 'user8', '2024-09-09T10:39:09.499658', 'wonderful cool awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (13, 'user11', '2024-09-03T10:39:09.499665', 'wonderful great cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (5, 'user7', '2024-11-04T10:39:09.499672', 'awesome awesome beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user12', '2024-09-22T10:39:09.499678', 'beautiful cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (22, 'user10', '2024-09-29T10:39:09.499684', 'wonderful cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (6, 'user10', '2024-09-23T10:39:09.499690', 'beautiful interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user15', '2024-10-07T10:39:09.499696', 'amazing great wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (17, 'user13', '2024-09-28T10:39:09.499702', 'wonderful interesting amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user5', '2024-10-25T10:39:09.499709', 'interesting cool great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (4, 'user11', '2024-09-14T10:39:09.499715', 'beautiful awesome wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (20, 'user9', '2024-11-12T10:39:09.499722', 'beautiful interesting great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user14', '2024-09-19T10:39:09.499728', 'beautiful interesting beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (11, 'user1', '2024-09-16T10:39:09.499734', 'awesome awesome amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user7', '2024-10-22T10:39:09.499741', 'amazing cool amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (19, 'user12', '2024-11-19T10:39:09.499748', 'great beautiful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (14, 'user13', '2024-09-06T10:39:09.499754', 'interesting wonderful great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (12, 'user4', '2024-10-21T10:39:09.499760', 'wonderful beautiful amazing');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user1', '2024-11-08T10:39:09.499767', 'great beautiful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (15, 'user7', '2024-11-07T10:39:09.499773', 'cool interesting interesting');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (25, 'user17', '2024-11-03T10:39:09.499780', 'cool beautiful beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user4', '2024-10-28T10:39:09.499786', 'awesome amazing beautiful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (23, 'user8', '2024-11-12T10:39:09.499810', 'amazing interesting cool');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (10, 'user9', '2024-10-27T10:39:09.499818', 'wonderful amazing wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (16, 'user5', '2024-09-06T10:39:09.499824', 'cool great great');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (21, 'user14', '2024-09-27T10:39:09.499830', 'awesome great awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (3, 'user10', '2024-09-22T10:39:09.499837', 'beautiful amazing awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (7, 'user10', '2024-08-22T10:39:09.499843', 'awesome wonderful awesome');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (9, 'user14', '2024-09-16T10:39:09.499850', 'awesome great wonderful');
INSERT INTO comentarios_por_video (video_id, autor_username, data_comentario, comentario) VALUES (1, 'user12', '2024-10-21T10:39:09.499856', 'awesome great wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-02T10:39:09.499863', 9, 'wonderful great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-11-06T10:39:09.499873', 11, 'great interesting beautiful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-10-17T10:39:09.499882', 14, 'great amazing cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-09-23T10:39:09.499890', 9, 'interesting wonderful amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-09-27T10:39:09.499897', 24, 'beautiful awesome wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-10-01T10:39:09.499905', 15, 'interesting amazing awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-10-19T10:39:09.499920', 6, 'amazing awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-10-07T10:39:09.499928', 18, 'amazing beautiful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user9', '2024-09-21T10:39:09.499936', 18, 'great great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-11-20T10:39:09.499947', 12, 'interesting amazing wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user10', '2024-10-06T10:39:09.499955', 19, 'interesting cool awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-10-25T10:39:09.499961', 8, 'interesting amazing awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user8', '2024-09-28T10:39:09.499968', 20, 'cool amazing awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-09-14T10:39:09.499977', 5, 'interesting cool interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-10-27T10:39:09.499987', 12, 'awesome awesome great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-11-15T10:39:09.500049', 1, 'cool great wonderful');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user14', '2024-10-29T10:39:09.500062', 21, 'amazing great interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user2', '2024-09-14T10:39:09.500069', 1, 'awesome great amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user5', '2024-09-29T10:39:09.500076', 22, 'interesting great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-09-21T10:39:09.500083', 25, 'beautiful great great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user16', '2024-11-04T10:39:09.500089', 24, 'wonderful amazing amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-08-16T10:39:09.500096', 16, 'beautiful awesome cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user15', '2024-10-02T10:39:09.500102', 4, 'awesome beautiful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user6', '2024-09-01T10:39:09.500111', 4, 'amazing great awesome');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user7', '2024-09-03T10:39:09.500119', 6, 'awesome great cool');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user17', '2024-08-31T10:39:09.500127', 18, 'great awesome great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-09-09T10:39:09.500135', 23, 'awesome cool amazing');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user4', '2024-10-27T10:39:09.500142', 21, 'amazing cool interesting');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user13', '2024-10-31T10:39:09.500149', 5, 'great wonderful great');
INSERT INTO comentarios_por_utilizador (autor_username, data_comentario, video_id, comentario) VALUES ('user12', '2024-10-06T10:39:09.500158', 12, 'interesting beautiful awesome');
INSERT INTO seguidores_video (video_id, username) VALUES (6, 'user2');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user3');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user13');
INSERT INTO seguidores_video (video_id, username) VALUES (23, 'user4');
INSERT INTO seguidores_video (video_id, username) VALUES (13, 'user1');
INSERT INTO seguidores_video (video_id, username) VALUES (11, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (15, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (1, 'user4');
INSERT INTO seguidores_video (video_id, username) VALUES (22, 'user9');
INSERT INTO seguidores_video (video_id, username) VALUES (11, 'user9');
INSERT INTO seguidores_video (video_id, username) VALUES (4, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (15, 'user8');
INSERT INTO seguidores_video (video_id, username) VALUES (4, 'user12');
INSERT INTO seguidores_video (video_id, username) VALUES (20, 'user7');
INSERT INTO seguidores_video (video_id, username) VALUES (5, 'user3');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user2', 6, 'user16', '2024-10-19T10:39:09.499920', 'amazing awesome cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user2', 6, 'user7', '2024-09-03T10:39:09.500119', 'awesome great cool');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user3', 20, 'user8', '2024-09-28T10:39:09.499968', 'cool amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user13', 20, 'user8', '2024-09-28T10:39:09.499968', 'cool amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user4', 23, 'user12', '2024-09-09T10:39:09.500135', 'awesome cool amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user8', 11, 'user4', '2024-11-06T10:39:09.499873', 'great interesting beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user12', 15, 'user7', '2024-10-01T10:39:09.499905', 'interesting amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user4', 1, 'user6', '2024-11-15T10:39:09.500049', 'cool great wonderful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user4', 1, 'user2', '2024-09-14T10:39:09.500069', 'awesome great amazing');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user9', 22, 'user5', '2024-09-29T10:39:09.500076', 'interesting great great');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user9', 11, 'user4', '2024-11-06T10:39:09.499873', 'great interesting beautiful');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user8', 4, 'user15', '2024-10-02T10:39:09.500102', 'awesome beautiful great');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user8', 4, 'user6', '2024-09-01T10:39:09.500111', 'amazing great awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user8', 15, 'user7', '2024-10-01T10:39:09.499905', 'interesting amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user12', 4, 'user15', '2024-10-02T10:39:09.500102', 'awesome beautiful great');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user12', 4, 'user6', '2024-09-01T10:39:09.500111', 'amazing great awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user7', 20, 'user8', '2024-09-28T10:39:09.499968', 'cool amazing awesome');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user3', 5, 'user15', '2024-09-14T10:39:09.499977', 'interesting cool interesting');
INSERT INTO comentarios_videos_seguidos (username_seguidor, video_id, autor_comentario, data_comentario, comentario) VALUES ('user3', 5, 'user13', '2024-10-31T10:39:09.500149', 'great wonderful great');
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (6, 'user8', 'stop', '2024-11-04T10:39:09.500366', 262);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user15', 'play', '2024-08-13T10:39:09.500386', 452);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user11', 'pause', '2024-10-07T10:39:09.500395', 162);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user9', 'stop', '2024-10-07T10:39:09.500404', 77);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user11', 'pause', '2024-10-01T10:39:09.500458', 254);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (24, 'user9', 'pause', '2024-08-31T10:39:09.500467', 352);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (3, 'user1', 'stop', '2024-09-13T10:39:09.500476', 210);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user14', 'stop', '2024-09-06T10:39:09.500482', 263);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (16, 'user4', 'stop', '2024-09-06T10:39:09.500488', 227);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user1', 'stop', '2024-08-25T10:39:09.500496', 91);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user9', 'play', '2024-11-07T10:39:09.500502', 13);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user14', 'pause', '2024-11-20T10:39:09.500509', 22);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (8, 'user2', 'play', '2024-11-19T10:39:09.500515', 487);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user10', 'pause', '2024-10-21T10:39:09.500521', 299);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (19, 'user8', 'pause', '2024-11-11T10:39:09.500528', 363);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (15, 'user6', 'stop', '2024-10-23T10:39:09.500534', 450);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user8', 'stop', '2024-10-01T10:39:09.500543', 63);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (22, 'user6', 'stop', '2024-09-05T10:39:09.500552', 253);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (23, 'user9', 'stop', '2024-09-14T10:39:09.500570', 302);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (24, 'user3', 'play', '2024-11-01T10:39:09.500581', 358);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (20, 'user5', 'pause', '2024-11-17T10:39:09.500592', 410);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user10', 'stop', '2024-11-02T10:39:09.500599', 301);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (14, 'user17', 'stop', '2024-11-03T10:39:09.500606', 309);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (5, 'user1', 'pause', '2024-08-29T10:39:09.500612', 56);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (7, 'user5', 'pause', '2024-08-30T10:39:09.500618', 374);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (11, 'user16', 'play', '2024-09-13T10:39:09.500623', 304);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (24, 'user14', 'stop', '2024-10-20T10:39:09.500629', 3);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (2, 'user7', 'pause', '2024-10-26T10:39:09.500636', 194);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (24, 'user11', 'pause', '2024-10-23T10:39:09.500649', 279);
INSERT INTO eventos_video (video_id, username, tipo_evento, data_evento, tempo_video) VALUES (24, 'user2', 'play', '2024-08-20T10:39:09.500656', 114);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user12', '2024-11-07T10:39:09.500664', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (15, 'user10', '2024-09-02T10:39:09.500675', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user13', '2024-09-11T10:39:09.500682', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (8, 'user3', '2024-11-06T10:39:09.500687', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user14', '2024-08-26T10:39:09.500693', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (17, 'user16', '2024-08-27T10:39:09.500700', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user2', '2024-08-17T10:39:09.500706', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user6', '2024-10-14T10:39:09.500712', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (2, 'user16', '2024-09-01T10:39:09.500718', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (24, 'user2', '2024-11-02T10:39:09.500726', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user12', '2024-11-11T10:39:09.500731', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user4', '2024-09-04T10:39:09.500736', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user8', '2024-11-18T10:39:09.500755', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (3, 'user5', '2024-09-20T10:39:09.500760', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user11', '2024-10-02T10:39:09.500765', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user17', '2024-09-02T10:39:09.500771', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (14, 'user7', '2024-09-13T10:39:09.500776', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (20, 'user8', '2024-10-02T10:39:09.500781', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (11, 'user8', '2024-10-22T10:39:09.500787', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (9, 'user5', '2024-09-17T10:39:09.500791', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (25, 'user4', '2024-09-21T10:39:09.500797', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user7', '2024-11-13T10:39:09.500803', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user4', '2024-10-26T10:39:09.500807', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user8', '2024-09-13T10:39:09.500815', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (18, 'user17', '2024-08-28T10:39:09.500820', 5);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (10, 'user14', '2024-11-16T10:39:09.500825', 2);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (16, 'user9', '2024-11-04T10:39:09.500832', 1);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (23, 'user17', '2024-08-26T10:39:09.500836', 4);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (6, 'user1', '2024-09-19T10:39:09.500842', 3);
INSERT INTO ratings_video (video_id, autor_rating, data_rating, rating) VALUES (21, 'user5', '2024-10-12T10:39:09.500846', 4);
