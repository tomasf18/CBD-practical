// 7. Permitir a pesquisa de todos os videos de determinado autor;

SELECT * FROM videos_autor 
WHERE autor_username = 'user2';

// 8. Permitir a pesquisa de comentarios por utilizador, ordenado inversamente pela data;

SELECT * FROM comentarios_por_utilizador 
WHERE autor_username = 'user6';

// 9. Permitir a pesquisa de comentarios por videos, ordenado inversamente pela data;

SELECT * FROM comentarios_por_video 
WHERE video_id = 8;

// 10. Permitir a pesquisa do rating medio de um video e quantas vezes foi votado;

SELECT AVG(rating), COUNT(rating) FROM ratings_video
WHERE video_id = 5;

----

// 1. Os ultimos 3 comentarios introduzidos para um video;

SELECT comentario FROM comentarios_por_video  
WHERE video_id = 14  
ORDER BY data_comentario DESC 
LIMIT 3;

# Usar por ordem mesmo que esteja especificado na tabela para melhor legibilidade

 comentario
-------------------------------
       great interesting great
          cool great beautiful
 awesome interesting wonderful


// 2. Lista das tags de determinado video;

SELECT tags FROM videos 
WHERE video_id = 3;

 tags
------------------
 {'tag2', 'tag3'}


// 3. Todos os videos com a tag Aveiro;

SELECT video_id, autor_username, data_upload 
FROM videos_por_tag
WHERE tag = 'tag1';

// 4.a. Os últimos 5 eventos de determinado vídeo realizados por um utilizador;

SELECT tipo_evento, data_evento, tempo_video FROM eventos_video
WHERE username = 'user13'
AND video_id = 21
ORDER BY data_evento DESC
LIMIT 5;

 tipo_evento | data_evento                     | tempo_video
-------------+---------------------------------+-------------
       pause | 2024-10-06 17:37:15.778000+0000 |         378
       pause | 2024-10-05 17:37:15.778000+0000 |          54
        play | 2024-09-30 17:37:15.778000+0000 |         252
        stop | 2024-09-18 17:37:15.778000+0000 |         367
        play | 2024-08-15 17:37:15.778000+0000 |         207

// 4.b. Todos os eventos de determinado utilizador;

SELECT * FROM eventos_video
WHERE username = 'user12';

 username | video_id | data_evento                     | tempo_video | tipo_evento
----------+----------+---------------------------------+-------------+-------------
   user12 |        4 | 2024-10-05 17:37:15.778000+0000 |          82 |       pause
   user12 |        9 | 2024-09-28 17:37:15.778000+0000 |          81 |       pause
   user12 |       16 | 2024-10-21 17:37:15.778000+0000 |         293 |       pause
   user12 |       19 | 2024-08-07 17:37:15.778000+0000 |         338 |        stop



// 4.c. Todos os eventos de determinado utilizador to tipo "pause"

CREATE INDEX ON eventos_video (tipo_evento);

SELECT * FROM eventos_video
WHERE username='user1'
AND tipo_evento='pause';


// 5. Videos partilhados por determinado utilizador (maria1987, por exemplo) num determinado periodo de tempo (Agosto de 2017, por exemplo);

SELECT * FROM videos_autor 
WHERE autor_username = 'user11'
AND data_upload >= '2024-09-01'
AND data_upload < '2024-12-01';

 autor_username | data_upload                     | video_id | descricao                 | nome     | tags
----------------+---------------------------------+----------+---------------------------+----------+-------------------
         user11 | 2024-09-26 18:05:44.550000+0000 |       16 | awesome beautiful amazing | Video 16 |          {'tag6'}
         user11 | 2024-11-04 18:05:44.551000+0000 |       23 |  wonderful cool wonderful | Video 23 | {'tag11', 'tag9'}


// 6. Os ultimos 10 videos, ordenado inversamente pela data da partilhada;

// TODO: Explicar melhor (detalhar)
PARA ORDENAR POR DATA, A DATA TEM DE ESTAR NA PARTITION KEY, MAS EU NAO CONSIGO ORDENAR PELA PARTITION KEY
EXERCICIO A DAR ERRO, REMOVER TABELA E INSERCAO DE DADOS vidoes_por_data
This query is not possible because we need to find the videos using the partition key and then sort by upload_timestamp. It is not possible to sort the data using the partition key, in this case, the upload_timestamp

// 7. Todos os seguidores (followers) de determinado video;

SELECT username FROM seguidores_video
WHERE video_id = 1;

// 8. Todos os comentarios (dos videos) que determinado utilizador esta a seguir (following);

# TODO: Consertar inserts
SELECT *
FROM comentarios_videos_seguidos
WHERE username_seguidor = 'user3';


// 9. Os 5 videos com maior rating;

# TODO: Explicar melhor
This query is not possible because we need to find the videos using the partition key (rating) and then order by it. It is not possible to simply sort the data using the partition key. It is the same problem og the query 6.

// 10. Uma query que retorne todos os videos e que mostre claramente a forma pela qual estao ordenados;

SELECT * FROM videos
# TODO EXPLICAR EM 2 FRASES COMO É QUE ELES APARECEM ORDENADOS

// 11. Lista com as Tags existentes e o numero de videos catalogados com cada uma delas;

SELECT tag, count(video_id) FROM videos_por_tag
group by tag;

// 12.

// 13.

// 14.