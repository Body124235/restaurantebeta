<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Pedido Confirmado - Restaurante</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
        }
        .navbar {
            border-radius: 15px;
            margin: 10px;
        }
        .container-delivery {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin: 40px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 1000px;
        }
        h3.text-success {
            font-weight: 600;
        }
    </style>
</head>
<body>

<!-- Menú de navegación -->
<jsp:include page="UserMenu.jsp" />
<!-- Contenido principal -->
<div class="container container-delivery">
    <h3 class="text-success mb-4">¡Tu pedido fue registrado exitosamente!</h3>

    <!-- Tabla de Menús seleccionados -->
    <table class="table table-bordered mb-5">
        <thead class="table-light">
            <tr>
                <th>Menú</th>
                <th>Cantidad</th>
                <th>Suma Unitaria Total (S/.)</th>
            </tr>
        </thead>
        <tbody>
            <%
                DecimalFormat df = new DecimalFormat("#0.00");
                double totalGeneral = 0;

                // Mapa de precios (nombre del menú → precio unitario)
                Map<String, Double> precios = new HashMap<>();
                precios.put("Ceviche", 15.0);
                precios.put("Lomo Saltado", 12.0);
                precios.put("Pollo a la Brasa", 18.0);
                precios.put("Arroz con Mariscos", 14.0);

                String[] menus = request.getParameterValues("menu");
                String[] cantidades = request.getParameterValues("cantidad");

                if (menus != null && cantidades != null) {
                    for (int i = 0; i < menus.length; i++) {
                        String menu = menus[i];
                        int cantidad = Integer.parseInt(cantidades[i]);
                        double precioUnitario = precios.getOrDefault(menu, 0.0);
                        double subtotal = cantidad * precioUnitario;
                        totalGeneral += subtotal;
            %>
            <tr>
                <td><%= menu %></td>
                <td><%= cantidad %></td>
                <td><%= df.format(subtotal) %></td>
            </tr>
            <% 
                    }
                } else { 
            %>
            <tr>
                <td colspan="3">No se recibieron datos del pedido.</td>
            </tr>
            <% } %>
        </tbody>
        <tfoot class="table-light">
            <tr>
                <th colspan="2" class="text-end">Total:</th>
                <th><%= df.format(totalGeneral) %></th>
            </tr>
        </tfoot>
    </table>

    <!-- Datos del cliente -->
    <h5 class="mb-3 fw-bold">Datos del Cliente</h5>
    <ul class="list-group">
        <li class="list-group-item"><strong>Nombre:</strong> <%= request.getParameter("nombre") %></li>
        <li class="list-group-item"><strong>Dirección:</strong> <%= request.getParameter("direccion") %></li>
        <li class="list-group-item"><strong>Teléfono:</strong> <%= request.getParameter("telefono") %></li>
        <li class="list-group-item"><strong>Comentario:</strong> <%= request.getParameter("comentario") %></li>
    </ul>
</div>

</body>
</html>
