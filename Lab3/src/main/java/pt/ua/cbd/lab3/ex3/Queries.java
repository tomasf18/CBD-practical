package pt.ua.cbd.lab3.ex3;

import com.datastax.oss.driver.api.core.cql.ResultSet;

import com.datastax.oss.driver.api.core.CqlSession;

public class Queries {
    private final CqlSession session;

    public Queries(CqlSession session) {
        this.session = session;
    }

    public void inserirUtilizador(String username, String nome, String email) {
        String inserirUtilizador = "INSERT INTO utilizadores (username, nome, email, data_registo) VALUES (?, ?, ?, toTimeStamp(now()))";
        this.session.execute(inserirUtilizador, username, nome, email);
    }

    public void atualizarUtilizador(String username, String nome, String email) {
        String atualizarUtilizador = "UPDATE utilizadores SET nome = ?, email = ? WHERE username = ?";
        this.session.execute(atualizarUtilizador, nome, email, username);
    }

    public void eliminarUtilizador(String username) {
        String eliminarUtilizador = "DELETE FROM utilizadores WHERE username = ?";
        this.session.execute(eliminarUtilizador, username);
    }

    public ResultSet getUtilizador(String username) {
        String getUtilizador = "SELECT * FROM utilizadores WHERE username = ?";
        return this.session.execute(getUtilizador, username);
    }

    // 3. Todos os videos com a tag 'tag';
    public ResultSet query3(String tag) {
        String query = "SELECT video_id, autor_username, data_upload, tag \r\n" + //
                        "FROM videos_por_tag\r\n" + //
                        "WHERE tag = ?";
        return this.session.execute(query, tag);
    }

    // 4.a. Os últimos 5 eventos de determinado vídeo realizados por um utilizador;
    public ResultSet query4a(String username, int video_id) {
        String query = "SELECT tipo_evento, data_evento, tempo_video FROM eventos_video\r\n" + //
                        "WHERE username = ?\r\n" + //
                        "AND video_id = ?\r\n" + //
                        "ORDER BY data_evento DESC\r\n" + //
                        "LIMIT 5";
        return this.session.execute(query, username, video_id);
    } 

    // 4.c. Todos os eventos de determinado utilizador do tipo "pause"
    public ResultSet query4c(String username) {
        String query = "SELECT * FROM eventos_video\r\n" + //
                        "WHERE username= ? \r\n" + //
                        "AND tipo_evento='pause'";
        return this.session.execute(query, username);
    }

    // 8. Todos os comentarios (dos videos) que determinado utilizador esta a seguir (following);
    public ResultSet query8(String username) {
        String query = "SELECT *\r\n" + //
                        "FROM comentarios_videos_seguidos\r\n" + //
                        "WHERE username_seguidor = ?;";
        return this.session.execute(query, username);
    }
}
