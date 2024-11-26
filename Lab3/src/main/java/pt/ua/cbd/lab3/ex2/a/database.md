### Modelo de Dados 

#### Utilizadores

```sql
CREATE TABLE utilizadores (
    username        TEXT, -- Não é boa politica ter um id com comprimento variável (opção: limitar length)
    nome            TEXT,
    email           TEXT,
    data_registo    TIMESTAMP,
    PRIMARY KEY (username)
);

CREATE TABLE utilizadores_por_data (
    data_registo    DATE,
    username        TEXT, 
    nome            TEXT,
    email           TEXT,
    PRIMARY KEY ((data_registo), username)
);
```

#### Vídeos

```sql
CREATE TABLE videos (
    video_id            INT, 
    autor_username      TEXT, -- cluster key, opcional na query
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

```

#### Comentários

```sql
CREATE TABLE comentarios_por_video (
    video_id            INT, -- unique id of a video
    autor_username      TEXT,
    data_comentario     TIMESTAMP,
    comentario          TEXT,
    PRIMARY KEY ((video_id), autor_username, data_comentario) -- O mesmo user consegue fazer vários comentários ao mesmo vídeo, com a restrição de ter de ser em instantes diferentes
) WITH CLUSTERING ORDER BY (autor_username ASC, data_comentario DESC);

CREATE TABLE comentarios_por_utilizador (
    autor_username      TEXT,
    data_comentario     TIMESTAMP,
    video_id            INT, 
    comentario          TEXT,
    PRIMARY KEY ((autor_username), video_id, data_comentario) -- Permite ao mesmo user ter múltiplos comentários num mesmo video, em instantes diferentes
) WITH CLUSTERING ORDER BY (video_id ASC, data_comentario DESC);

CREATE TABLE comentarios_videos_seguidos (
    username_seguidor  TEXT,
    video_id           INT,
    autor_comentario   TEXT,
    data_comentario    TIMESTAMP,
    comentario         TEXT,
    PRIMARY KEY ((username_seguidor), video_id, data_comentario)
) WITH CLUSTERING ORDER BY (video_id ASC, data_comentario DESC);

```

#### Seguidores

```sql
CREATE TABLE seguidores_video (
    video_id            INT, 
    username            TEXT,
    PRIMARY KEY ((video_id), username)
);
```

#### Eventos

```sql
CREATE TABLE eventos_video (
    username            TEXT,
    video_id            INT, 
    tipo_evento         TEXT,
    data_evento         TIMESTAMP,
    tempo_video         INT,
    PRIMARY KEY ((username), video_id, data_evento, tempo_video)
);

CREATE TABLE eventos_video_data (
    video_id            INT, 
    data_evento         DATE,
    username            TEXT,
    tempo_video         INT,
    tipo_evento         TEXT,
    PRIMARY KEY ((video_id), data_evento, username, tempo_video)
);
```

#### Rating de Vídeos

```sql
CREATE TABLE ratings_video (
    video_id            INT,
    autor_rating        TEXT,
    data_rating         TIMESTAMP,
    rating              INT,
    PRIMARY KEY ((video_id), autor_rating, data_rating) 
    -- Composição da PK:
        -- video_id: para permitir ter ratings em diversos videos
        -- autor_rating: para permitir diversos users criarem um rating num video
        -- data_rating: para permitir um mesmo user criar diversos ratings a um mesmo video
    -- Se tivesse só PK=(video_id), apenas conseguiria ter um rating por video
);
```

### 7

```sql
SELECT * FROM videos 
WHERE autor_username = 'user2';
```

#### 8

```sql
SELECT * FROM comentarios_por_utilizador 
WHERE autor_username = 'user6';
```

#### 9

```sql
SELECT * FROM comentarios_por_video 
WHERE video_id = 8;
```

#### 10

```sql
SELECT AVG(rating), COUNT(rating) FROM ratings_video
WHERE video_id = 5;
```