package rastreioCarta.controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rastreioCarta.DB.DB;

@WebServlet("/atualizarPedido")
public class AtualizarPedidosServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
    	System.out.println("Received ID: " + request.getParameter("id"));
    	int pedidoId = Integer.parseInt(request.getParameter("id")); 
        String nome = request.getParameter("nome");
        String apelido = request.getParameter("apelido");
        String tipoPedido = request.getParameter("tipoPedido");
        String dataPedido = request.getParameter("dataPedido");
        String dataLevantamento = request.getParameter("dataLevantamento");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DB.getConnection();

            // Note: I assume you need to update both the 'motorista' and 'pedido_carteira' tables. 
            // If not, adjust the query and which fields it includes.
            String updateQuery = "UPDATE motorista m JOIN pedido_carteira pc ON m.id = pc.motorista_id SET " +
                                 "m.nome = ?, m.apelido = ?, pc.tipo_pedido = ?, pc.data_pedido = ?, m.data_de_levantamento = ? " +
                                 "WHERE pc.id = ?";

            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, nome);
            stmt.setString(2, apelido);
            stmt.setString(3, tipoPedido);
            stmt.setString(4, dataPedido);
            stmt.setString(5, dataLevantamento);
            stmt.setInt(6, pedidoId); 
            stmt.executeUpdate();

            // Success Handling
            response.sendRedirect("MotoristaAdmin.jsp"); // Example redirect, could send JSON status
 
        } catch (SQLException e) {
            response.getWriter().println("Erro ao atualizar pedido: " + e.getMessage());
        } finally {
            // Close resources as in your insertServlet example
        }
    }
}
