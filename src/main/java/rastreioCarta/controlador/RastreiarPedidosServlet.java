package rastreioCarta.controlador;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import rastreioCarta.DB.DB;
import rastreioCarta.modelo.PedidoCarteira;

@WebServlet("/rastreiarPedidos")
public class RastreiarPedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        String searchTerm = request.getParameter("search");

        try (Connection conn = DB.getConnection()) {
            String query = "SELECT pc.id, m.nome, m.apelido, pc.tipo_pedido, pc.data_pedido, m.data_de_levantamento, pc.status " +
                           "FROM pedido_carteira pc " +
                           "JOIN motorista m ON pc.motorista_id = m.id " +
                           "WHERE pc.cartNum = ?";

            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, searchTerm);
            ResultSet rs = stmt.executeQuery();

            List<PedidoCarteira> pedidos = new ArrayList<>();

            while (rs.next()) {
                PedidoCarteira pedido = new PedidoCarteira(
                    rs.getString("nome"),
                    rs.getString("apelido"),
                    rs.getString("tipo_pedido"),
                    rs.getString("data_pedido"),
                    rs.getString("data_de_levantamento"), // Retrieve pickup date
                    rs.getString("status")
                );
                pedidos.add(pedido);
            }

            // Serialize list of pedidos to JSON
            Gson gson = new Gson();
            String jsonOutput = gson.toJson(pedidos);

            // Write JSON response
            response.getWriter().println(jsonOutput);

        } catch (SQLException e) {
            response.getWriter().println("Erro ao consultar pedidos: " + e.getMessage());
        }
    }
}
