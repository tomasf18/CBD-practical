// 7. Permitir a pesquisa de todos os videos de determinado autor;

SELECT * FROM videos 
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
WHERE video_id = 4  
ORDER BY data_comentario DESC 
LIMIT 3;

// 2. Lista das tags de determinado video;

SELECT tags  
FROM videos 
WHERE video_id = 3;

// 3. Todos os videos com a tag Aveiro;



// 4.a. Os últimos 5 eventos de determinado vídeo realizados por um utilizador;

SELECT tipo_evento, data_evento, tempo_video
FROM eventos_video
WHERE video_id = 1 AND username = 'user10'
LIMIT 5;


// 4.b. Todos os eventos de determinado utilizador;

// 4.c. Todos os eventos de determinado utilizador to tipo "pause"

// 5. Videos partilhados por determinado utilizador (maria1987, por exemplo) num determinado periodo de tempo (Agosto de 2017, por exemplo);

// 6. Os ultimos 10 videos, ordenado inversamente pela data da partilhada;

// 7. Todos os seguidores (followers) de determinado video;

// 8. Todos os comentarios (dos videos) que determinado utilizador esta a seguir (following);

// 9. Os 5 videos com maior rating;

// 10. Uma query que retorne todos os videos e que mostre claramente a forma pela qual estao ordenados;

// 11. Lista com as Tags existentes e o numero de videos catalogados com cada uma delas;

// 12.

// 13.

// 14.