<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="modelo.Reserva" %>
<%@ page import="modelo.Pedido" %>
<%@ page import="modelo.DetallePedido" %> 
<%@ page import="modelo.Menu" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial - Restaurante</title>
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
        .section-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 30px;
        }
        .table-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }
        .table-title {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .table-title h3 {
            margin: 0;
            font-weight: 600;
        }
        .form-control[type="date"] {
            max-width: 200px;
        }
        table {
            text-align: center;
        }
        .estado-pendiente { color: orange; font-weight: bold; }
        .estado-confirmada { color: green; font-weight: bold; }
        .estado-cancelada { color: red; font-weight: bold; }
        .estado-en_ruta { color: blue; font-weight: bold; }
        .estado-entregado { color: green; font-weight: bold; }

        /* Estilo para los detalles del menú en pedidos */
        .menu-list {
            list-style: none;
            padding: 0;
            margin: 0;
            text-align: left;
        }
        .menu-item {
            font-size: 0.9em;
            margin-bottom: 2px;
        }
    </style>
</head>
<body>

<%-- Se incluye el menú para usuarios --%>
<jsp:include page="UserMenu.jsp" />

<div class="container">
    <h2 class="section-title">Historial del Usuario</h2>

    <%
        // Mensajes de éxito o error
        String mensaje = request.getParameter("mensaje");
        if (mensaje != null && !mensaje.isEmpty()) {
    %>
        <div class="alert alert-success" role="alert">
            <%= mensaje %>
        </div>
    <%
        }
        String error = (String) request.getAttribute("error");
        if (error != null && !error.isEmpty()) {
    %>
        <div class="alert alert-danger" role="alert">
            <%= error %>
        </div>
    <%
        }
    %>

    <div class="table-container">
        <div class="table-title">
            <h3>Reservas Realizadas</h3>
            <%-- Los filtros de fecha aquí necesitarán JS para llamar a un servlet --%>
            <div class="d-flex gap-2">
                <input type="date" class="form-control" name="fechaReserva" id="fechaReservaInput" 
                       value="<%= (request.getParameter("fechaReserva") != null) ? request.getParameter("fechaReserva") : "" %>">
                <button class="btn btn-primary btn-sm" onclick="filtrarHistorial('reservas')">Filtrar</button>
                <button class="btn btn-secondary btn-sm" onclick="limpiarFiltroHistorial('reservas')">Todas</button>
            </div>
        </div>
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID Reserva</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Personas</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody id="tablaReservas">
                <%
                    List<Reserva> listaReservas = (List<Reserva>) request.getAttribute("listaReservasUsuario");
                    if (listaReservas != null && !listaReservas.isEmpty()) {
                        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                        for (Reserva reserva : listaReservas) {
                %>
                    <tr>
                        <td><%= reserva.getId() %></td>
                        <td><%= reserva.getFechaReserva().format(dateFormatter) %></td>
                        <td><%= reserva.getHoraReserva().format(timeFormatter) %></td>
                        <td><%= reserva.getNumPersonas() %></td>
                        <td>
                            <span class="estado-<%= reserva.getEstado().toLowerCase() %>">
                                <%= reserva.getEstado() %>
                            </span>
                        </td>
                        <td>
                            <%-- Solo permitir cancelar si la reserva está pendiente --%>
                            <% if (reserva.getEstado().equalsIgnoreCase("pendiente")) { %>
                                <form action="<%= request.getContextPath() %>/ReservaServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="cambiarEstado">
                                    <input type="hidden" name="id" value="<%= reserva.getId() %>">
                                    <input type="hidden" name="estado" value="cancelada">
                                    <input type="hidden" name="redirect" value="historial"> <%-- Para redirigir de vuelta al historial --%>
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que quieres cancelar esta reserva?');">Cancelar</button>
                                </form>
                            <% } else { %>
                                <span class="text-muted">No cancelable</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="6" class="text-center">No tienes reservas realizadas.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <div class="d-grid gap-2 col-6 mx-auto mt-4">
            <a href="<%= request.getContextPath() %>/reservar.jsp" class="btn btn-primary">Realizar Nueva Reserva</a>
        </div>
    </div>

    <div class="table-container">
        <div class="table-title">
            <h3>Pedidos de Delivery Realizados</h3>
            <div class="d-flex gap-2">
                <input type="date" class="form-control" name="fechaPedido" id="fechaPedidoInput"
                       value="<%= (request.getParameter("fechaPedido") != null) ? request.getParameter("fechaPedido") : "" %>">
                <button class="btn btn-primary btn-sm" onclick="filtrarHistorial('pedidos')">Filtrar</button>
                <button class="btn btn-secondary btn-sm" onclick="limpiarFiltroHistorial('pedidos')">Todos</button>
            </div>
        </div>
        <table class="table table-bordered table-hover">
            <thead class="table-light">
                <tr>
                    <th>ID Pedido</th>
                    <th>Fecha</th>
                    <th>Total</th>
                    <th>Dirección</th>
                    <th>Menús</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody id="tablaPedidos">
                <%
                    List<Pedido> listaPedidos = (List<Pedido>) request.getAttribute("listaPedidosUsuario");
                    // Aquí se espera que el servlet también ponga un mapa de menú_id a objeto Menu para mostrar los nombres
                    Map<Integer, Menu> mapaMenus = (Map<Integer, Menu>) request.getAttribute("mapaMenus");

                    if (listaPedidos != null && !listaPedidos.isEmpty()) {
                        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        for (Pedido pedido : listaPedidos) {
                %>
                    <tr>
                        <td><%= pedido.getId() %></td>
                        <td><%= pedido.getFechaPedido().format(dateFormatter) %></td>
                        <td><%= String.format("%.2f", pedido.getTotal()) %></td>
                        <td><%= pedido.getDireccionEntrega() %></td>
                        <td>
                            <ul class="menu-list">
                                <%
                                    if (pedido.getDetalles() != null && !pedido.getDetalles().isEmpty()) {
                                        for (DetallePedido detalle : pedido.getDetalles()) {
                                            String nombreMenu = "Desconocido";
                                            if (mapaMenus != null && mapaMenus.containsKey(detalle.getMenuId())) {
                                                nombreMenu = mapaMenus.get(detalle.getMenuId()).getNombre();
                                            }
                                %>
                                    <li class="menu-item"><%= detalle.getCantidad() %> x <%= nombreMenu %></li>
                                <%
                                        }
                                    } else {
                                %>
                                    <li>Sin detalles de menú</li>
                                <%
                                    }
                                %>
                            </ul>
                        </td>
                        <td>
                            <span class="estado-<%= pedido.getEstado().toLowerCase().replace(" ", "_") %>">
                                <%= pedido.getEstado() %>
                            </span>
                        </td>
                        <td>
                            <%-- Solo permitir cancelar si el pedido está pendiente --%>
                            <% if (pedido.getEstado().equalsIgnoreCase("pendiente")) { %>
                                <form action="<%= request.getContextPath() %>/DeliveryServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="cambiarEstadoPedido">
                                    <input type="hidden" name="id" value="<%= pedido.getId() %>">
                                    <input type="hidden" name="estado" value="cancelado">
                                    <input type="hidden" name="redirect" value="historial"> <%-- Para redirigir de vuelta al historial --%>
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de que quieres cancelar este pedido?');">Cancelar</button>
                                </form>
                            <% } else { %>
                                <span class="text-muted">No cancelable</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center">No tienes pedidos de delivery realizados.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <div class="d-grid gap-2 col-6 mx-auto mt-4">
            <a href="<%= request.getContextPath() %>/delivery.jsp" class="btn btn-success">Realizar Nuevo Pedido</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function filtrarHistorial(tipo) {
        let fecha;
        let url = "<%= request.getContextPath() %>/";
        if (tipo === 'reservas') {
            fecha = document.getElementById('fechaReservaInput').value;
            if (fecha) {
                url += "ReservaServlet?action=listarReservasUsuario&fecha=" + fecha;
            } else {
                alert("Por favor, selecciona una fecha para filtrar las reservas.");
                return;
            }
        } else if (tipo === 'pedidos') {
            fecha = document.getElementById('fechaPedidoInput').value;
            if (fecha) {
                url += "DeliveryServlet?action=listarPedidosUsuario&fecha=" + fecha;
            } else {
                alert("Por favor, selecciona una fecha para filtrar los pedidos.");
                return;
            }
        }
        window.location.href = url;
    }

    function limpiarFiltroHistorial(tipo) {
        let url = "<%= request.getContextPath() %>/";
        if (tipo === 'reservas') {
            url += "ReservaServlet?action=listarReservasUsuario";
        } else if (tipo === 'pedidos') {
            url += "DeliveryServlet?action=listarPedidosUsuario";
        }
        window.location.href = url;
    }
</script>
</body>
</html>