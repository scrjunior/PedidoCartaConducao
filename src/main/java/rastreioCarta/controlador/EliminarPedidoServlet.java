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

@WebServlet("/eliminarPedido")
public class EliminarPedidoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String pedidoIdStr = request.getParameter("id");

        if (pedidoIdStr == null || pedidoIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("ID do pedido não fornecido.");
            return;
        }

        try {
            int pedidoId = Integer.parseInt(pedidoIdStr);
            Connection conn = DB.getConnection();
            PreparedStatement stmt = null;

            try {
                // Delete the pedido from the database
                String deleteQuery = "DELETE FROM pedido_carteira WHERE id = ?";
                stmt = conn.prepareStatement(deleteQuery);
                stmt.setInt(1, pedidoId);
                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Pedido successfully deleted
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.sendRedirect("MotoristaAdmin.jsp");
                } else {
                    // No pedido found with the specified ID
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().println("Pedido não encontrado para eliminar.");
                }
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().println("Erro ao eliminar pedido: " + e.getMessage());
            } finally {
                // Close resources
                if (stmt != null) {
                    try {
						stmt.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                }
                if (conn != null) {
                    try {
						conn.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("ID do pedido inválido.");
        }
    }
}
