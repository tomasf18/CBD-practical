### Modelo de Dados 

#### Utilizadores

```sql
CREATE TABLE utilizadores (
    username TEXT,
    nome TEXT,
    email TEXT,
    data_registo TIMESTAMP,
    id UUID,
    PRIMARY KEY (username)
);
```

#### Vídeos

```sql
CREATE TABLE videos (
    autor TEXT,
    nome TEXT,
    data_upload TIMESTAMP,
    descricao TEXT,
    tags SET<TEXT>,
    video_id UUID,
    PRIMARY KEY (autor)
) WITH CLUSTERING ORDER BY (data_upload DESC);
```

#### Comentários

```sql
CREATE TABLE comentarios_por_video (
    nome_vid TEXT,
    autor_vid TEXT,
    data_comentario TIMESTAMP,
    autor TEXT,
    comentario TEXT,
    PRIMARY KEY ((nome_vid), autor_vid)
) WITH CLUSTERING ORDER BY (data_comentario DESC);

CREATE TABLE comentarios_por_utilizador (
    autor TEXT,
    data_comentario TIMESTAMP,
    nome_vid TEXT,
    autor_vid TEXT,
    comentario TEXT,
    PRIMARY KEY (autor)
) WITH CLUSTERING ORDER BY (data_comentario DESC);
```

#### Seguidores

```sql
CREATE TABLE seguidores_video (
    nome_vid TEXT,
    autor_vid TEXT,
    username TEXT,
    data_seguidor TIMESTAMP,
    PRIMARY KEY ((nome_vid, autor_vid), username)
);
```

#### Eventos

```sql
CREATE TABLE eventos_video (
    nome_vid TEXT,
    autor_vid TEXT,
    username TEXT,
    tipo_evento TEXT,
    data_evento TIMESTAMP,
    tempo_video INT,
    PRIMARY KEY ((nome_vid, autor_vid, username), data_evento)
) WITH CLUSTERING ORDER BY (data_evento DESC);
```

#### Rating de Vídeos

```sql
CREATE TABLE ratings_video (
    nome_vid TEXT,
    autor_vid TEXT,
    soma_ratings COUNTER,
    total_votos COUNTER,
    PRIMARY KEY ((nome_vid, autor_vid))
);
```

### 7

```sql
SELECT * FROM videos 
WHERE autor = 'autor';
```

#### 8

```sql
SELECT * FROM comentarios_por_utilizador 
WHERE autor = 'username';
```

#### 9

```sql
SELECT * FROM comentarios_por_video 
WHERE nome_vid = 'nome_vid'
AND autor_vid = 'autor_vid';
```

#### 10

```sql
SELECT total_votos, soma_ratings FROM ratings_video 
WHERE nome_vid = 'nome_vid'
AND autor_vid = 'autor_vid';
```