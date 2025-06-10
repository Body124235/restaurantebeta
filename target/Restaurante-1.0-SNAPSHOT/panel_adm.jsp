<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.List"%>
<%@page import="modelo.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel del Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0;
        }

        .navbar {
            margin-bottom: 20px;
            border-radius: 10px;
        }

        .profile-img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
        }

        .admin-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #333;
        }

        .main-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .panel-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 40px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 1100px;
            min-height: 400px;
        }

        .panel-buttons {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 45%;
        }

        .panel-buttons button {
            font-weight: 600;
            font-size: 1.05rem;
        }

        .restaurant-image {
            width: 100%;
            max-width: 420px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<jsp:include page="AdminMenu.jsp" />
<!-- Barra de navegación -->



<!-- Contenido principal -->
<div class="main-container">
    <div class="panel-container">
        <!-- Botones del panel de administración -->
        <div class="panel-buttons">
            <!-- no tiene servlets son ver listado de reservas y ver pedidod de delivery -->
            <button class="btn btn-primary" onclick="window.location.href='_notegoservlet'">Ver Lista de Reservas</button>
            <button class="btn btn-warning" onclick="window.location.href='_notegoservlet'">Ver Pedidos de Delivery</button>
            <!-- si tienen servlet -->
            <button class="btn btn-success" onclick="window.location.href='MenuServlet'">Agregar Nuevo Menú</button>
            <button class="btn btn-success" onclick="window.location.href='RegistrarAdminServlet'">Agregar Nuevo administrador</button>
        </div>
        
        <!-- Imagen del restaurante -->
        <div>
            <img src="img/restaurant.jpg" alt="Imagen del restaurante" class="restaurant-image">
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
