<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Pedidos de Carteira de Motorista</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa; /* Cor de fundo */
            padding: 20px;
        }
        .container {
            background-color: #fff; /* Fundo branco */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.1); /* Sombra suave */
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="display-4 mb-4">Consulta de Pedidos de Carteira de Motorista</h1>
        
        <!-- Formulário de busca -->
        <form id="searchForm" class="mb-4">
            <div class="input-group">
                <input type="text" class="form-control" id="searchInput" placeholder="Buscar por nome ou tipo de pedido">
                <button type="submit" class="btn btn-primary">Buscar</button>
            </div>
        </form>
        
        <!-- Tabela de Pedidos -->
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Nome</th>
                    <th>Apelido</th>
                    <th>Tipo de Pedido</th>
                    <th>Data do Pedido</th>
                    <th>Data de Levantamento</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody id="pedidosBody">
                <!-- Linhas dos pedidos serão adicionadas aqui -->
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.getElementById('searchForm').addEventListener('submit', function(event) {
        event.preventDefault();
        const searchTerm = document.getElementById('searchInput').value.trim();

        if (searchTerm) {
            fetch('rastreiarPedidos?search=' + encodeURIComponent(searchTerm))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Dados recebidos:', data); 

                    const tableBody = document.getElementById('pedidosBody');
                    tableBody.innerHTML = ''; // Clear existing rows

                    data.forEach(pedido => {
                        const row = tableBody.insertRow();
                        row.insertCell().textContent = pedido.nome;
                        row.insertCell().textContent = pedido.apelido;
                        row.insertCell().textContent = pedido.tipoPedido;
                        row.insertCell().textContent = pedido.dataPedido;
                        row.insertCell().textContent = pedido.dataLevantamento;
                        row.insertCell().textContent = pedido.status;
                    });
                })
                .catch(error => {
                    console.error('Erro ao buscar pedidos:', error);
                    // Display an error message to the user here
                    tableBody.innerHTML = '<tr><td colspan="6">Erro ao carregar os pedidos.</td></tr>';
                });
        }
    });

    </script>
</body>
</html>
