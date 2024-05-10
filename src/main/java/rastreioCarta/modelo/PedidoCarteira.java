package rastreioCarta.modelo;

public class PedidoCarteira {
    private String nome;
    private String apelido;
    private String tipoPedido;
    private String dataPedido;
    private String dataLevantamento; // New field for pickup date
    private String status;

    // Constructor
    public PedidoCarteira(String nome, String apelido, String tipoPedido, String dataPedido, String dataLevantamento, String status) {
        this.nome = nome;
        this.apelido = apelido;
        this.tipoPedido = tipoPedido;
        this.dataPedido = dataPedido;
        this.dataLevantamento = dataLevantamento; // Initialize pickup date
        this.status = status;
    }

    // Getters and Setters
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getApelido() {
        return apelido;
    }

    public void setApelido(String apelido) {
        this.apelido = apelido;
    }

    public String getTipoPedido() {
        return tipoPedido;
    }

    public void setTipoPedido(String tipoPedido) {
        this.tipoPedido = tipoPedido;
    }

    public String getDataPedido() {
        return dataPedido;
    }

    public void setDataPedido(String dataPedido) {
        this.dataPedido = dataPedido;
    }

    public String getDataLevantamento() {
        return dataLevantamento;
    }

    public void setDataLevantamento(String dataLevantamento) {
        this.dataLevantamento = dataLevantamento;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
