<%-- src/main/webapp/delivery.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Ya no necesitamos el taglib de JSTL core si quitamos todas las etiquetas <c:> --%>
<%-- <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> --%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Nuestro Menú para Delivery</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
       
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100vh;
            background-color: #f8f8f8; 
            font-family: 'Poppins', sans-serif; 
            color: #333; 
            box-sizing: border-box;
            display: block;
        }

        
        .container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            margin-top: 30px;
            margin-bottom: 50px;
        }

       
        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .user-info-delivery {
            background-color: #e9f7ef;
            border: 1px solid #d4edda;
            border-radius: 8px;
            padding: 15px 20px;
            margin-bottom: 30px;
            text-align: center;
        }
        .user-info-delivery p {
            margin-bottom: 5px;
            font-size: 0.95em;
        }
        .user-info-delivery strong {
            color: #28a745;
        }

       
        .menu-grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            padding: 0;
        }
        .menu-item {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            overflow: hidden;
            text-align: center;
            transition: transform 0.2s ease-in-out;
            display: flex;
            flex-direction: column;
        }
        .menu-item:hover {
            transform: translateY(-5px);
        }
      
        .image-placeholder {
            width: 100%;
            height: 200px; 
            background-color: #f0f0f0; 
            display: flex;
            align-items: center;
            justify-content: center;
            color: #888;
            font-size: 0.9em;
            text-align: center;
            border-bottom: 1px solid #e0e0e0;
            font-style: italic;
        }

        .menu-details {
            padding: 15px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .menu-details h2 {
            margin-top: 0;
            font-size: 1.5em;
            color: #34495e;
            margin-bottom: 10px;
        }
        .menu-details .price {
            font-size: 1.8em;
            font-weight: bold;
            color: #e67e22; 
            margin-bottom: 15px;
        }
        .menu-details .stock {
            font-size: 0.9em;
            color: #c0392b;
            font-weight: bold;
            margin-top: 5px;
        }
        .add-to-cart-section {
            margin-top: auto;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .no-menus {
            text-align: center;
            font-size: 1.2em;
            color: #7f8c8d;
            margin-top: 50px;
        }
        
        .btn-primary {
            background-color: #e67e22; 
            border-color: #e67e22;
            padding: 10px 30px;
            font-size: 1.1em;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #d35400; 
            border-color: #d35400;
        }
        .form-control.me-2 {
            width: 80px;
            text-align: center;
        }
    </style>
</head>
<body>

    <jsp:include page="UserMenu.jsp" />

    <div class="container">
        <h1>Nuestro Menú para Delivery</h1>

       
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <% if (request.getAttribute("mensajeExito") != null) { %>
            <div class="alert alert-success" role="alert">
                <%= request.getAttribute("mensajeExito") %>
            </div>
        <% } %>

       
        <div class="user-info-delivery">
            <p>¡Hola, <strong>[Nombre de Usuario]</strong>!</p>
            <p>Tu pedido será enviado a: <strong>[Dirección del Usuario]</strong></p>
            <small class="text-muted">Si esta dirección no es correcta, por favor actualiza tu perfil.</small>
        </div>

        
        <div class="menu-grid-container">
           
            <div class="menu-item">
                <div class="image-placeholder">
                    [IMAGEN DEL MENÚ AQUÍ]
                </div>
                <div class="menu-details">
                    <h2>Hamburguesa Clásica</h2>
                    <p class="price">S/ 25.00</p>
                    <div class="add-to-cart-section">
                        <form action="${pageContext.request.contextPath}/DeliveryServlet" method="post" class="d-flex align-items-center justify-content-center">
                            <input type="hidden" name="action" value="agregarAlCarrito">
                            <input type="hidden" name="menuId" value="1">
                            <input type="number" name="cantidad" value="1" min="1" max="10" class="form-control me-2" style="width: 80px;">
                            <button type="submit" class="btn btn-primary">Agregar</button>
                        </form>
                        <small class="text-muted mt-2">Disponibles: 10</small>
                    </div>
                </div>
            </div>

           
            <div class="menu-item">
                <div class="image-placeholder">
                    [IMAGEN DEL MENÚ AQUÍ]
                </div>
                <div class="menu-details">
                    <h2>Pizza Pepperoni</h2>
                    <p class="price">S/ 45.50</p>
                    <div class="add-to-cart-section">
                        <form action="${pageContext.request.contextPath}/DeliveryServlet" method="post" class="d-flex align-items-center justify-content-center">
                            <input type="hidden" name="action" value="agregarAlCarrito">
                            <input type="hidden" name="menuId" value="2">
                            <input type="number" name="cantidad" value="1" min="1" max="5" class="form-control me-2" style="width: 80px;">
                            <button type="submit" class="btn btn-primary">Agregar</button>
                        </form>
                        <small class="text-muted mt-2">Disponibles: 5</small>
                    </div>
                </div>
            </div>

            <div class="menu-item">
                <div class="image-placeholder">
                    [IMAGEN DEL MENÚ AQUÍ]
                </div>
                <div class="menu-details">
                    <h2>Ensalada César</h2>
                    <p class="price">S/ 20.00</p>
                    <div class="add-to-cart-section">
                        <%-- Ejemplo de un elemento "Agotado" --%>
                        <p class="stock">¡AGOTADO!</p>
                        <button class="btn btn-secondary" disabled>Agotado</button>
                    </div>
                </div>
            </div>

        </div>

       
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>