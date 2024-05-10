<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciamento de Pedidos de Carteira de Motorista</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
    body {
        /* Define a imagem de fundo e ajusta o posicionamento */
        background-image: url('https://images.pexels.com/photos/5214408/pexels-photo-5214408.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
        background-size: cover; /* Ajusta o tamanho da imagem para cobrir a tela */
        background-position: center; /* Centraliza a imagem na tela */
        height: 100vh; /* Ajusta a altura para preencher a tela */
    }
    
    .container {
        /* Exemplo de estilização para o conteúdo dentro do container */
        background-color: rgba(255, 255, 255, 0.2); /* Fundo com opacidade */
        padding: 20px;
        border-radius: 10px;
    }

    /* Estilos para o título h1 dentro do container */
    .container h1 {
        color: #333; /* Cor do texto */
        text-align: center; /* Centraliza o texto */
    }
</style>

	
</head>
<body class="bg-dark text-white">
    <div class="container mt-5">
        <h1 class="display-4 text-white fw-bold">Gerenciamento de Pedidos de Carteira de Motorista</h1>
        <hr>

        <!-- Formulário para cadastrar novo pedido -->
        <div class="mb-3">
            <h3>Cadastrar Novo Pedido de Carteira</h3>
            <form id="cadastroPedidoForm" action="inserirPedido" method="post">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="nome" class="form-label">Nome do Motorista</label>
                        <input type="text" class="form-control" id="nome" name="nome" placeholder="Nome" required>
                    </div>
                    <div class="col-md-6">
                        <label for="apelido" class="form-label">Apelido do Motorista</label>
                        <input type="text" class="form-control" id="apelido" name="apelido" placeholder="Apelido" required>
                    </div>
                </div>
                <div class="mb-3">
    <label for="bi" class="form-label">Número de Identificação (Máximo de 10 dígitos)</label>
    <input type="number" class="form-control" id="bi" name="cartNum" placeholder="Digite o número de identificação (máx. 10 dígitos)" required>
    <small class="text-muted">Por favor, insira até 10 dígitos.</small>
</div>

<script>
    // Get the input element
    const inputElement = document.getElementById('bi');

    // Add an event listener for input
    inputElement.addEventListener('input', function() {
        // Get the current value of the input
        let inputValue = this.value.trim();

        // Ensure the value is a number and limit it to 10 digits
        inputValue = inputValue.slice(0, 10); // Limit to 10 characters

        // Update the input value with the trimmed value
        this.value = inputValue;
    });
</script>


                <div class="mb-3">
                    <label for="tipoPedido" class="form-label">Tipo de Pedido</label>
                    <select class="form-select" id="tipoPedido" name="tipoPedido" required>
                        <option value="novo">Nova Carteira</option>
                        <option value="renovacao">Renovação</option>
                        <option value="criacao">Criação</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="dataPedido" class="form-label">Data do Pedido</label>
                    <input type="date" class="form-control" id="dataPedido" name="dataPedido" required>
                </div>
                <div class="mb-3">
                    <label for="dataLevantamento" class="form-label">Data de Levantamento</label>
                    <input type="date" class="form-control" id="dataLevantamento" name="dataLevantamento" required>
                </div>
                <button type="submit" class="btn btn-primary">Cadastrar Pedido</button>
            </form>
        </div>

        <!-- Bootstrap Modal for Editing Pedido -->

        
        
        <div>
    <h3>Lista de Pedidos de Carteira</h3>
    <table class="table text-white" id="pedidosTable" >
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Apelido</th>
                <th>Tipo de Pedido</th>
                <th>Data do Pedido</th>
                <th>Data de Levantamento</th>
                <th>Status</th>
                <th>Editar</th> 
                <th>Eliminar</th>
                <!-- New column for Edit button -->
            </tr>
        </thead>
        <tbody id="pedidosTableBody">
    <!-- Loop through pedidos and generate table rows -->
    <c:forEach var="pedido" items="${pedidos}">
        <tr id="pedido-${pedido.id}">
            <td>${pedido.id}</td>
            <td>${pedido.nomeMotorista}</td>
            <td>${pedido.apelidoMotorista}</td>
            <td>${pedido.tipoPedido}</td>
            <td>${pedido.dataPedido}</td>
            <td>${pedido.dataLevantamento}</td>
            
            <td>
                <!-- Use onclick to call the editPedido function with the pedido ID -->
                <button class="btn btn-primary" onclick="editPedido(${pedido.id})">Editar</button>
            </td>
            <td> <button class="btn btn-danger" onclick="eliminarPedido(${pedido.id})">Eliminar</button>
 </td>
 			<td>${pedido.status}</td>
            
        </tr>
    </c:forEach>
</tbody>


    </table>
</div>

<div class="modal" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <h5 class="modal-title text-dark">Editar Pedido</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <!-- Modal Body -->
            <div class="modal-body text-dark">
                <!-- Your edit form goes here -->
                <form id="editPedidoForm" action="atualizarPedido" method="POST">
                    <!-- Fields to populate with selected pedido data -->
                    <div class="mb-3">
                        <label for="editNome" class="form-label">Nome do Motorista</label>
                        <input type="text" class="form-control" id="editNome" name="nome" required>
                    </div>
                    <div class="mb-3">
                        <label for="editApelido" class="form-label">Apelido do Motorista</label>
                        <input type="text" class="form-control" id="editApelido" name="apelido" required>
                    </div>
                    <div class="mb-3">
                        <label for="editTipoPedido" class="form-label">Tipo de Pedido</label>
                        <select class="form-select" id="editTipoPedido" name="tipoPedido" required>
                            <option value="nova">Nova Carteira</option>
                            <option value="renovacao">Renovação</option>
                            <option value="criacao">Criação</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editDataPedido" class="form-label">Data do Pedido</label>
                        <input type="date" class="form-control" id="editDataPedido" name="dataPedido" required>
                    </div>
                    <div class="mb-3">
                        <label for="editDataLevantamento" class="form-label">Data de Levantamento</label>
                        <input type="date" class="form-control" id="editDataLevantamento" name="dataLevantamento" required>
                    </div>
                    <div class="mb-3">
                        <label for="editStatus" class="form-label">Status</label>
                        <select class="form-select" id="editStatus" name="status" required>
                            <option value="Pendente">Pendente</option>
                            <option value="Levantado">Levantado</option>
                        </select>
                    </div>
                    <!-- Hidden field to store pedido ID -->
                    <input type="hidden" id="editPedidoId" name="id">
                    <button type="submit" class="btn btn-primary">Salvar Alterações</button>
                </form>
            </div>
        </div>
    </div>
</div>


<div class="modal" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title text-dark">Confirmar Eliminação</h5>
                <!-- Apply text-dark class to make the modal title text black -->
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-dark">
                <!-- Apply text-dark class to make the modal body text black -->
                <p>Tem certeza que deseja eliminar este pedido?</p>
                <form id="deletePedidoForm" action="eliminarPedido" method="POST">
                    <div class="mb-3">
                        <input type="hidden" id="pedidoIdToDelete" name="id">
                        <!-- Hidden input to store the pedido ID -->
                    </div>
                    <!-- Buttons within the form -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <!-- Use type="submit" to trigger form submission -->
                        <button type="submit" class="btn btn-danger">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>







    </div>
    

    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
    <script>
    async function carregarPedidos() {
        try {
            const response = await axios.get('consultarPedidos');
            const pedidos = response.data;

            //console.log(pedidos); // Verify the data received in the console

            const tableBody = document.getElementById('pedidosTableBody');
            tableBody.innerHTML = ''; // Clear the current table content

            if (Array.isArray(pedidos)) {
                // If it's an array of pedidos
                pedidos.forEach(pedido => {
                    const row = document.createElement('tr');

                    const idCell = document.createElement('td');
                    idCell.textContent = pedido.id;
                    row.appendChild(idCell);

                    const nomeCell = document.createElement('td');
                    nomeCell.textContent = pedido.nomeMotorista;
                    row.appendChild(nomeCell);

                    const apelidoCell = document.createElement('td');
                    apelidoCell.textContent = pedido.apelidoMotorista;
                    row.appendChild(apelidoCell);

                    const tipoCell = document.createElement('td');
                    tipoCell.textContent = pedido.tipoPedido;
                    row.appendChild(tipoCell);

                    const dataPedidoCell = document.createElement('td');
                    dataPedidoCell.textContent = pedido.dataPedido;
                    row.appendChild(dataPedidoCell);

                    const dataLevantamentoCell = document.createElement('td');
                    dataLevantamentoCell.textContent = pedido.dataLevantamento;
                    row.appendChild(dataLevantamentoCell);
                    
                    const statusCell = document.createElement('td');
                    statusCell.textContent = pedido.status;
                    row.appendChild(statusCell);

                    const editCell = document.createElement('td');
                    
                    const eliminarCell = document.createElement('td');
                    
                    const editButton = document.createElement('button');
                    editButton.textContent = 'Editar';
                    editButton.classList.add('btn', 'btn-primary');
                    editButton.addEventListener('click', () => {
                        // Call your edit function here, passing the pedido object or ID
                        editPedido(pedido.id); // Example: Pass the pedido ID to the edit function
                    });
                    
                    const eliminarButton = document.createElement('button');
                    eliminarButton.textContent = 'Eliminar';
                    eliminarButton.classList.add('btn', 'btn-danger');
                    eliminarButton.addEventListener('click', () => {
                        eliminarPedido(pedido.id); // Pass the correct ID
                    });

                    
                    editCell.appendChild(editButton);
                    eliminarCell.appendChild(eliminarButton);
                    row.appendChild(editCell);
                    row.appendChild(eliminarCell);

                    tableBody.appendChild(row);
                });
            } else {
                // If it's a single pedido object (unlikely in this case)
                const row = document.createElement('tr');

                const idCell = document.createElement('td');
                idCell.textContent = pedidos.id;
                row.appendChild(idCell);

                const nomeCell = document.createElement('td');
                nomeCell.textContent = pedidos.nomeMotorista;
                row.appendChild(nomeCell);

                const apelidoCell = document.createElement('td');
                apelidoCell.textContent = pedidos.apelidoMotorista;
                row.appendChild(apelidoCell);

                const tipoCell = document.createElement('td');
                tipoCell.textContent = pedidos.tipoPedido;
                row.appendChild(tipoCell);

                const dataPedidoCell = document.createElement('td');
                dataPedidoCell.textContent = pedidos.dataPedido;
                row.appendChild(dataPedidoCell);

                const dataLevantamentoCell = document.createElement('td');
                dataLevantamentoCell.textContent = pedidos.dataLevantamento;
                row.appendChild(dataLevantamentoCell);
                
                const statusCell = document.createElement('td');
                statusCell.textContent = pedido.status;
                row.appendChild(statusCell);

                const editCell = document.createElement('td');
                
                
                const eliminarCell = document.createElement('td');
                
                const editButton = document.createElement('button');
                editButton.textContent = 'Editar';
                editButton.classList.add('btn', 'btn-primary');
                editButton.addEventListener('click', () => {
                    // Call your edit function here, passing the pedido object or ID
                    editPedido(pedidos.id); // Example: Pass the pedido ID to the edit function
                });
                
                const eliminarButton = document.createElement('button');
                eliminarButton.textContent = 'Eliminar';
                eliminarButton.classList.add('btn', 'btn-danger');
                eliminarButton.addEventListener('click', () => {
                    eliminarPedido(pedido.id); // Pass the correct ID
                });

                
                editCell.appendChild(editButton);
                eliminarCell.appendChild(eliminarButton);
                row.appendChild(editCell);
                row.appendChild(eliminarCell);

                tableBody.appendChild(row);
            }
        } catch (error) {
            console.error('Erro ao carregar pedidos:', error);
        }
    }

    async function editPedido(pedidoId) {
    	  try {
    	    const response = await axios.get(`consultarPedidos?id=${pedidoId}`);
    	    const pedidos = response.data; // This is a LIST of pedidos

    	    // Find the matching pedido based on the ID
    	    const pedido = pedidos.find(p => p.id === pedidoId); 
    	    console.log(pedido.id)

    	    if (pedido) {
    	      document.getElementById('editNome').value = pedido.nomeMotorista;
    	      document.getElementById('editApelido').value = pedido.apelidoMotorista;
    	      document.getElementById('editTipoPedido').value = pedido.tipoPedido;
    	      document.getElementById('editDataPedido').value = pedido.dataPedido; 
    	      document.getElementById('editDataLevantamento').value = pedido.dataLevantamento;
    	      document.getElementById('editPedidoId').value = pedido.id; 
    	      document.getElementById('editStatus').value = pedido.status;

    	      const editModal = new bootstrap.Modal(document.getElementById('editModal'));
    	      editModal.show();
    	    } else {
    	      console.error('Pedido não encontrado ou dados inválidos.');
    	    }
    	  } catch (error) {
    	    console.error('Erro ao carregar dados do pedido:', error);
    	  }
    	}
    
    async function eliminarPedido(pedidoId) {
        // Set the value of the hidden input field with the pedido ID
        document.getElementById('pedidoIdToDelete').value = pedidoId;

        // Display the delete modal
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
        deleteModal.show();

        // Handle form submission when the "Eliminar" button in the modal is clicked
        const eliminarButton = document.getElementById('confirmEliminarButton');
        eliminarButton.addEventListener('click', async () => {
            try {
                const deleteForm = document.getElementById('deletePedidoForm');
                const formData = new FormData(deleteForm);

                const response = await axios.post('eliminarPedido', formData);
                if (response.status === 200) {
                    // Reload or update the table upon successful deletion
                    carregarPedidos();
                } else {
                    console.error('Erro ao eliminar pedido:', response.data);
                }
            } catch (error) {
                console.error('Erro ao eliminar pedido:', error);
            }

            // Hide the delete modal after form submission
            deleteModal.hide();
        });
    }





    
    

		
  

    // Ensure carregarPedidos is called after the DOM content is loaded
    document.addEventListener('DOMContentLoaded', () => {
        carregarPedidos();
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>


