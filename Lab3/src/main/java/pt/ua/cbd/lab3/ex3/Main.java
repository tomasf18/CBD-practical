package pt.ua.cbd.lab3.ex3;

import com.datastax.oss.driver.api.core.CqlSession;
import com.datastax.oss.driver.api.core.cql.ResultSet;

public class Main {
    public static void main(String[] args) {
        try (CqlSession session = CqlSession.builder().withKeyspace("partilha_videos").build()) {
            Queries q = new Queries(session);

            // inserir
            q.inserirUtilizador("ronaldo", "Cristiano Ronaldo", "ronaldo.soulindo@ua.pt");

            // editar
            q.atualizarUtilizador("ronaldo", "Cristiano Ronaldo Aveiro", "ronaldo.soumuitolindo@gmail.com");

            // eliminar
            q.eliminarUtilizador("ronaldo");

            System.out.println("\n========================= \n");

            // get utilizador
            ResultSet utilizador = q.getUtilizador("user13");
            utilizador.forEach(row -> {
                System.out.println("-------------------------------------------------");
                System.out.println("Username: " + row.getString("username"));
                System.out.println("Nome: " + row.getString("nome"));
                System.out.println("Email: " + row.getString("email"));
                System.out.println("Registration Timestamp: " + row.getInstant("data_registo"));
            });

            System.out.println("-------------------------------------------------");

            // 3. Todos os videos com a tag 'tag';
            System.out.println("\nVideos com a tag 'tag1':");
            ResultSet videos = q.query3("tag1");
            videos.forEach(row -> {
                System.out.println("-------------------------------------------------");
                System.out.println("ID Video: " + row.getInt("video_id"));
                System.out.println("Autor: " + row.getString("autor_username"));
                System.out.println("Data Upload: " + row.getInstant("data_upload"));
                System.out.println("Tag: " + row.getString("tag"));
            });

            System.out.println("-------------------------------------------------");

            // 4.a. Os últimos 5 eventos de determinado vídeo realizados por um utilizador;
            System.out.println("\nUltimos 5 eventos do video 10 feitos pelo user12:");
            ResultSet eventos = q.query4a("user12", 10);
            eventos.forEach(row -> {
                System.out.println("-------------------------------------------------");
                System.out.println("Tipo Evento: " + row.getString("tipo_evento"));
                System.out.println("Data Evento: " + row.getInstant("data_evento"));
                System.out.println("Tempo Video: " + row.getInt("tempo_video"));
            });
            
            System.out.println("-------------------------------------------------");

            // 4.c. Todos os eventos de determinado utilizador do tipo "pause"
            System.out.println("\nEventos de pause do user12:");
            ResultSet eventosPause = q.query4c("user12");
            eventosPause.forEach(row -> {
                System.out.println("-------------------------------------------------");
                System.out.println("Tipo Evento: " + row.getString("tipo_evento"));
                System.out.println("Data Evento: " + row.getInstant("data_evento"));
                System.out.println("Tempo Video: " + row.getInt("tempo_video"));
            });

            System.out.println("-------------------------------------------------");

            // 8. Todos os comentarios (dos videos) que determinado utilizador esta a seguir (following);
            System.out.println("\nComentarios dos videos que o user10 esta a seguir:");
            ResultSet comentarios = q.query8("user10");
            comentarios.forEach(row -> {
                System.out.println("-------------------------------------------------");
                System.out.println("ID Video: " + row.getInt("video_id"));
                System.out.println("Comentario: " + row.getString("comentario"));
            });


        }
    }
}