# Queries

## Exercício 2.a)

### 7. Permitir a pesquisa de todos os videos de determinado autor;

```sql
SELECT * FROM videos_autor 
WHERE autor_username = 'user2';
```

```bash
 autor_username | data_upload                     | video_id | descricao                   | nome     | tags
----------------+---------------------------------+----------+-----------------------------+----------+-------------------
          user2 | 2024-09-02 16:00:44.511000+0000 |       25 | great interesting beautiful | Video 25 |          {'tag8'}
          user2 | 2024-10-28 16:00:44.511000+0000 |        8 |       awesome great awesome |  Video 8 | {'tag15', 'tag2'}
          user2 | 2024-11-14 16:00:44.511000+0000 |       16 |      amazing beautiful cool | Video 16 |         {'tag13'}
```

### 8. Permitir a pesquisa de comentarios por utilizador, ordenado inversamente pela data;

```sql
SELECT * FROM comentarios_por_utilizador 
WHERE autor_username = 'user8';
```
- A própria tabela já está ordenada pela data do comentário.
```bash
 autor_username | video_id | data_comentario                 | comentario
----------------+----------+---------------------------------+-------------------------------
          user8 |        2 | 2024-09-25 16:00:44.512000+0000 |       great beautiful awesome
          user8 |       14 | 2024-11-20 16:00:44.512000+0000 | wonderful beautiful wonderful
```

### 9. Permitir a pesquisa de comentarios por videos, ordenado inversamente pela data;

- A própria tabela já está ordenada pela data do comentário.
```sql
SELECT * FROM comentarios_por_video 
WHERE video_id = 10;
```

```bash
 video_id | data_comentario                 | autor_username | comentario
----------+---------------------------------+----------------+-----------------------------
       10 | 2024-10-13 16:00:44.512000+0000 |         user11 |   great awesome interesting
       10 | 2024-08-26 16:00:44.512000+0000 |          user8 | beautiful beautiful awesome
```

### 10. Permitir a pesquisa do rating medio de um video e quantas vezes foi votado;

```sql
SELECT AVG(rating) AS rating_medio, COUNT(rating) AS n_votos FROM ratings_video
WHERE video_id = 5;
```

```bash
 rating_medio | n_votos
--------------+---------
            2 |       3
```

---

## Exercício 2.d)

### 1. Os ultimos 3 comentarios introduzidos para um video;

```sql
SELECT comentario FROM comentarios_por_video  
WHERE video_id = 14  
ORDER BY data_comentario DESC  -- Especificar ordem, mesmo que esteja já feito na tabela, para melhor legibilidade
LIMIT 3;
```

```bash
  comentario
-------------------------------
        wonderful cool amazing
       interesting great great
 awesome beautiful interesting
```

### 2. Lista das tags de determinado video;

```sql
SELECT tags FROM videos 
WHERE video_id = 2;
```

```bash
 tags
------------------
 {'tag4', 'tag6'}
```

### 3. Todos os videos com a tag Aveiro;

```sql
SELECT video_id, autor_username, data_upload 
FROM videos_por_tag
WHERE tag = 'tag1';
```

```bash
  video_id | autor_username | data_upload
----------+----------------+---------------------------------
        5 |          user9 | 2024-10-10 16:00:44.511000+0000
       12 |         user13 | 2024-09-01 16:00:44.511000+0000
       23 |         user19 | 2024-11-20 16:00:44.511000+0000
       25 |          user4 | 2024-11-15 16:00:44.511000+0000
```

### 4.a. Os últimos 5 eventos de determinado vídeo realizados por um utilizador;

```sql
SELECT tipo_evento, data_evento, tempo_video FROM eventos_video
WHERE username = 'user12'
AND video_id = 10
ORDER BY data_evento DESC
LIMIT 5;
```

```bash
 tipo_evento | data_evento                     | tempo_video
-------------+---------------------------------+-------------
       pause | 2024-11-15 16:00:44.512000+0000 |          28
```

### 4.b. Todos os eventos de determinado utilizador;

```sql
SELECT * FROM eventos_video
WHERE username = 'user12';
```

```bash
 username | video_id | data_evento                     | tempo_video | tipo_evento
----------+----------+---------------------------------+-------------+-------------
   user12 |        7 | 2024-10-28 16:00:44.513000+0000 |         354 |        play
   user12 |       10 | 2024-11-15 16:00:44.512000+0000 |          28 |       pause
   user12 |       15 | 2024-08-27 16:00:44.513000+0000 |         221 |        play
   user12 |       15 | 2024-11-19 16:00:44.513000+0000 |         455 |        stop
   user12 |       16 | 2024-11-22 16:00:44.512000+0000 |         348 |        stop
```

### 4.c. Todos os eventos de determinado utilizador do tipo "pause"

- Para esta query, criei um índice para o campo `tipo_evento`, visto que não faz parte da chave primária.

```sql
CREATE INDEX ON eventos_video (tipo_evento);
```

```sql
SELECT * FROM eventos_video
WHERE username='user12'
AND tipo_evento='pause';
```

```bash
 username | video_id | data_evento                     | tempo_video | tipo_evento
----------+----------+---------------------------------+-------------+-------------
   user12 |       10 | 2024-11-15 16:00:44.512000+0000 |          28 |       pause
```

### 5. Videos partilhados por determinado utilizador (maria1987, por exemplo) num determinado periodo de tempo (Agosto de 2017, por exemplo);

- Query feita para o período de Setembro a Novembro de 2024.

```sql
SELECT * FROM videos_autor 
WHERE autor_username = 'user12'
AND data_upload >= '2024-09-01'
AND data_upload < '2024-12-01';
```

```bash
 autor_username | data_upload                     | video_id | descricao                 | nome     | tags
----------------+---------------------------------+----------+---------------------------+----------+-----------------------------
         user12 | 2024-10-09 16:00:44.511000+0000 |        6 |  interesting cool amazing |  Video 6 |            {'tag3', 'tag9'}
         user12 | 2024-11-11 16:00:44.511000+0000 |       19 | amazing awesome wonderful | Video 19 | {'tag10', 'tag11', 'tag13'}
```

### 6. Os ultimos 10 videos, ordenado inversamente pela data da partilhada;

Neste momento, todas as tabelas (principal e auxiliares) têm como partition key uma coluna que não a data de de partilha. 
Ou seja, para fazer uma query, é necessário fornecer o dado para a partition key. Só depois, com a data em cluster key, é que seria possível ordenar pela mesma de modo a poder utilizar "limit 10" para obter os últimos 10 vídeos. Mas, dessa forma, estaríamos a obter dados filtrados pelo dado fornecido para a partition key, o que não era o pretendido.
Um caminho alternativo seria criar uma nova tabela com a data de partilha como partition key. Mas, novamente, ia dar errado, visto que iríamos acabar por ter de ordenar os dados resultantes pela data de partilha (para obter os últimos/mais recentes), isto é, pela partition key, o que não é possível em Cassandra, dado que a cláusula "ORDER BY" apenas ordena os dados por cluster columns/key (a partition key tem de ser restrita a uma igualdade ou a uma pertença).

Fonte: Aula TP sobre column oriented databases e slides 60 e 64 da mesma aula.

### 7. Todos os seguidores (followers) de determinado video;

```sql
SELECT username FROM seguidores_video
WHERE video_id = 5;
```

```bash
 username
----------
   user10
   user15
```

### 8. Todos os comentarios (dos videos) que determinado utilizador esta a seguir (following);

```sql
SELECT * FROM comentarios_videos_seguidos
WHERE username_seguidor = 'user3';
```

```bash
 username_seguidor | video_id | data_comentario                 | autor_comentario | comentario
-------------------+----------+---------------------------------+------------------+-------------------------
             user9 |       15 | 2024-10-04 16:00:44.512000+0000 |           user18 | great beautiful awesome
```

### 9. Os 5 videos com maior rating;

Não é possível pelo mesmo motivo da query 6:

- A tabela de ratings tem como partition ley o video_id, ou seja, para fazer uma query, é necessário fornecer o dado para a partition key. Só depois, com o rating em cluster key, é que seria possível ordenar pelo mesmo de modo a poder utilizar "limit 5" para obter os últimos 5 ratings (por ordem descendente). Mas, dessa forma, estaríamos a obter dados filtrados pelo dado fornecido para a partition key, o que não era o pretendido (neste caso, até era só aquele relativo ao vídeo com `video_id`).
- Um caminho alternativo seria criar uma nova tabela com o rating como partition key. Mas, novamente, ia dar errado, visto que iríamos acabar por ter de ordenar os dados resultantes pelo rating (para obter os últimos/mais elevados), isto é, pela partition key, o que não é possível em Cassandra, dado que a cláusula "ORDER BY" apenas ordena os dados por cluster columns/key (a partition key tem de ser restrita a uma igualdade ou a uma pertença).

### 10. Uma query que retorne todos os videos e que mostre claramente a forma pela qual estao ordenados;

SELECT * FROM videos;

#### Explicação da ordenação:

- Os resultados da query estão ordenados pelas `partition keys` e, dentro destas, pelas `clustering keys`. 
- Isto é, a partition key é usada para indicar a partição onde os dados estão armazenados, e dentro dessa partição, os dados são ordenados pelas clustering keys.
- No caso desta tabela, os vídeos são agrupados por `video_id` (partition key), seguidos pela ordenação baseada em `autor_username` (clustering key).

```bash
 video_id | autor_username | data_upload                     | descricao                     | nome     | tags
----------+----------------+---------------------------------+-------------------------------+----------+----------------------------
       23 |         user19 | 2024-11-20 16:00:44.511000+0000 |           great great awesome | Video 23 |           {'tag1', 'tag3'}
        5 |          user9 | 2024-10-10 16:00:44.511000+0000 |        interesting cool great |  Video 5 |  {'tag1', 'tag10', 'tag6'}
       10 |          user1 | 2024-11-18 16:00:44.511000+0000 | interesting beautiful awesome | Video 10 |           {'tag3', 'tag7'}
       16 |          user8 | 2024-11-11 16:00:44.511000+0000 |   amazing wonderful beautiful | Video 16 |           {'tag5', 'tag7'}
       13 |          user3 | 2024-10-19 16:00:44.511000+0000 |        beautiful cool amazing | Video 13 |                  {'tag11'}
       11 |         user15 | 2024-09-29 16:00:44.511000+0000 |      cool interesting awesome | Video 11 | {'tag11', 'tag14', 'tag4'}
        1 |         user19 | 2024-10-14 16:00:44.510000+0000 |   beautiful beautiful awesome |  Video 1 |  {'tag14', 'tag2', 'tag9'}
       19 |         user18 | 2024-11-08 16:00:44.511000+0000 |   amazing wonderful beautiful | Video 19 |          {'tag12', 'tag4'}
        8 |         user20 | 2024-11-23 16:00:44.511000+0000 |      interesting awesome cool |  Video 8 |   {'tag5', 'tag6', 'tag7'}
        2 |         user14 | 2024-10-06 16:00:44.510000+0000 |          amazing cool awesome |  Video 2 |           {'tag4', 'tag6'}
        4 |         user10 | 2024-08-27 16:00:44.511000+0000 |     awesome beautiful awesome |  Video 4 |                   {'tag9'}
       18 |          user6 | 2024-11-18 16:00:44.511000+0000 |         great great wonderful | Video 18 | {'tag12', 'tag14', 'tag2'}
       15 |         user18 | 2024-09-04 16:00:44.511000+0000 |       great beautiful amazing | Video 15 |                   {'tag3'}
       22 |         user11 | 2024-09-29 16:00:44.511000+0000 |       beautiful great awesome | Video 22 |   {'tag4', 'tag7', 'tag8'}
       20 |         user16 | 2024-10-08 16:00:44.511000+0000 |           cool beautiful cool | Video 20 |                  {'tag10'}
        7 |         user11 | 2024-08-23 16:00:44.511000+0000 |     interesting great amazing |  Video 7 |                  {'tag12'}
        6 |         user20 | 2024-11-09 16:00:44.511000+0000 |       beautiful great awesome |  Video 6 |                  {'tag10'}
        9 |         user19 | 2024-08-24 16:00:44.511000+0000 |        amazing wonderful cool |  Video 9 |  {'tag14', 'tag8', 'tag9'}
       14 |          user3 | 2024-11-19 16:00:44.511000+0000 |        amazing wonderful cool | Video 14 |                  {'tag13'}
       21 |          user3 | 2024-08-25 16:00:44.511000+0000 |         great great wonderful | Video 21 |           {'tag4', 'tag8'}
       17 |         user20 | 2024-09-11 16:00:44.511000+0000 |         great great beautiful | Video 17 |          {'tag15', 'tag3'}
       24 |         user16 | 2024-10-29 16:00:44.511000+0000 |        cool wonderful awesome | Video 24 |          {'tag15', 'tag2'}
       25 |          user4 | 2024-11-15 16:00:44.511000+0000 |       awesome amazing awesome | Video 25 |  {'tag1', 'tag11', 'tag6'}
       12 |         user13 | 2024-09-01 16:00:44.511000+0000 |     awesome beautiful amazing | Video 12 |  {'tag1', 'tag14', 'tag3'}
        3 |          user8 | 2024-09-19 16:00:44.510000+0000 |           amazing great great |  Video 3 |                  {'tag11'}
```

### 11. Lista com as Tags existentes e o numero de videos catalogados com cada uma delas;

```sql
SELECT tag, count(video_id) FROM videos_por_tag
GROUP BY tag;
```

```bash
 tag   | system.count(video_id)
-------+------------------------
 tag14 |                      5
 tag15 |                      2
  tag6 |                      4
 tag10 |                      3
  tag9 |                      3
  tag3 |                      5
 tag11 |                      4
  tag5 |                      2
  tag2 |                      3
  tag1 |                      4
 tag12 |                      3
  tag4 |                      5
  tag7 |                      4
 tag13 |                      1
  tag8 |                      3

```

### 12. Todos os utilizadores que se registaram no dia <data_registo>

- Para resolver esta query, criei uma nova tabela `utilizadores_por_data` com a data de registo como partition key.

```sql
CREATE TABLE utilizadores_por_data (
    data_registo    TIMESTAMP,
    username        TEXT, 
    nome            TEXT,
    email           TEXT,
    PRIMARY KEY ((data_registo), username)
);
```

```sql
SELECT data_registo, COUNT(*) AS numero_utilizadores FROM utilizadores_por_data WHERE data_registo = '2024-08-25';
```

```bash
 data_registo | numero_utilizadores
--------------+---------------------
   2024-08-25 |                   2
```

### 13. Numero de videos com o mesmo nome, ordenados por video id

- Para resolver esta query, criei uma nova tabela `videos_nome` com o nome do video como partition key, e com o video_id como clustering key para permitir a ordenação.

```sql
CREATE TABLE videos_nome (
    nome                TEXT,
    video_id            INT, 
    autor_username      TEXT, 
    data_upload         TIMESTAMP,
    descricao           TEXT,
    tags                SET<TEXT>,
    PRIMARY KEY ((nome), video_id)
);
```

```sql
SELECT nome, COUNT(*) AS num_videos
FROM videos_nome
WHERE nome = 'Video 6'
ORDER BY video_id ASC;
```

```bash
 nome    | num_videos
---------+------------
 Video 6 |          1
```

### 14. Todos os eventos de determinado utilizador num determinado periodo de tempo;

- Para resolver esta query, criei uma nova tabela `eventos_video_data` com o usrname como partition key, e a data do evento como clustering key para permitir a definição de um intervalo de tempo.

```sql
CREATE TABLE eventos_video_data (
    username            TEXT,
    data_evento         DATA,
    video_id            INT, 
    tempo_video         INT,
    tipo_evento         TEXT,
    PRIMARY KEY ((username), data_evento, video_id, tempo_video)
);
```

```sql
SELECT video_id, data_evento, tempo_video, tipo_evento 
FROM eventos_video_data 
WHERE username = 'user14' 
AND data_evento > '2024-09-11';
```

```bash
 video_id | data_evento | tempo_video | tipo_evento
----------+-------------+-------------+-------------
        6 |  2024-09-15 |         409 |        stop
       12 |  2024-09-28 |          76 |        play
       15 |  2024-10-18 |         260 |       pause
       23 |  2024-11-18 |         320 |        play
```
