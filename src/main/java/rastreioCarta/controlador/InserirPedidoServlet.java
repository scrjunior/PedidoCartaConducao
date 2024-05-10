package rastreioCarta.controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rastreioCarta.DB.DB;

@WebServlet("/inserirPedido")
public class InserirPedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String nome = request.getParameter("nome");
        String apelido = request.getParameter("apelido");
        String tipoPedido = request.getParameter("tipoPedido");
        String dataPedido = request.getParameter("dataPedido");
        String dataLevantamento = request.getParameter("dataLevantamento");
        String cartNumStr = request.getParameter("cartNum");
        long cartNum; // Use long instead of int for large numbers

     // Verifica se a string contém apenas dígitos antes de converter para long
     if (cartNumStr != null && cartNumStr.matches("\\d+")) {
         try {
             cartNum = Long.parseLong(cartNumStr); // Use Long.parseLong for large numbers
         } catch (NumberFormatException e) {
             response.getWriter().println("Número de identificação inválido: " + cartNumStr);
             return; // Retorna ou lança uma exceção, dependendo do tratamento desejado
         }
     } else {
         // Se a string não contiver apenas dígitos, trate o erro aqui
         response.getWriter().println("Número de identificação inválido: " + cartNumStr);
         return; // Retorna ou lança uma exceção, dependendo do tratamento desejado
     }



        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DB.getConnection();
            String insertMotoristaQuery = "INSERT INTO motorista (nome, apelido, data_de_levantamento) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(insertMotoristaQuery, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, nome);
            stmt.setString(2, apelido);
            stmt.setString(3, dataLevantamento);
            stmt.executeUpdate();

            // Obter o ID do motorista recém-inserido
            int motoristaId;
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    motoristaId = generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Falha ao obter o ID do motorista recém-inserido.");
                }
            }

            String insertPedidoQuery = "INSERT INTO pedido_carteira (motorista_id, tipo_pedido, data_pedido, cartNum) VALUES (?, ?, ?, ?)";
            stmt = conn.prepareStatement(insertPedidoQuery);
            stmt.setInt(1, motoristaId);
            stmt.setString(2, tipoPedido);
            stmt.setString(3, dataPedido);
            stmt.setLong(4, cartNum);
            stmt.executeUpdate();

            
            response.sendRedirect("MotoristaAdmin.jsp");
        } catch (SQLException e) {
            response.getWriter().println("Erro ao cadastrar pedido: " + e.getMessage());
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
