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

@WebServlet("/consultarPedidos")
public class ConsultarPedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");

        try (Connection conn = DB.getConnection()) {
            String query = "SELECT pc.id, m.nome, m.apelido, pc.tipo_pedido, pc.data_pedido, m.data_de_levantamento " +
                           "FROM pedido_carteira pc " +
                           "JOIN motorista m ON pc.motorista_id = m.id";

            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            List<Pedido> pedidos = new ArrayList<>();
            while (rs.next()) {
                int id = rs.getInt("id");
                String nomeMotorista = rs.getString("nome");
                String apelidoMotorista = rs.getString("apelido");
                String tipoPedido = rs.getString("tipo_pedido");
                String dataPedido = rs.getString("data_pedido");
                String dataLevantamento = rs.getString("data_de_levantamento");

                Pedido pedido = new Pedido(id, nomeMotorista, apelidoMotorista, tipoPedido, dataPedido, dataLevantamento);
                pedidos.add(pedido);
            }

            // Converter lista de pedidos para JSON
            Gson gson = new Gson();
            String jsonPedidos = gson.toJson(pedidos);

            // Escrever JSON na resposta
            response.getWriter().print(jsonPedidos);
        } catch (SQLException e) {
            response.getWriter().println("Erro ao consultar pedidos: " + e.getMessage());
        }
    }

    // Classe de modelo para representar um pedido
    private static class Pedido {
        private int id;
        private String nomeMotorista;
        private String apelidoMotorista;
        private String tipoPedido;
        private String dataPedido;
        private String dataLevantamento;

        public Pedido(int id, String nomeMotorista, String apelidoMotorista, String tipoPedido, String dataPedido, String dataLevantamento) {
            this.id = id;
            this.nomeMotorista = nomeMotorista;
            this.apelidoMotorista = apelidoMotorista;
            this.tipoPedido = tipoPedido;
            this.dataPedido = dataPedido;
            this.dataLevantamento = dataLevantamento;
        }
    }
}
