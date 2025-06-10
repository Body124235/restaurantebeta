<%-- webapp/inicio.jsp --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<!DOCTYPE html>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio - Restaurante</title>
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
        .bienvenida {
            padding: 60px 30px 30px 30px;
            text-align: center;
            background: linear-gradient(135deg, #f7c59f, #f27c38);
            color: white;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .bienvenida h1 {
            font-size: 3rem;
            font-weight: bold;
        }
        .bienvenida p {
            font-size: 1.2rem;
        }
        .opciones {
            display: flex;
            justify-content: center;
            gap: 30px;
        }
        .opcion-box {
            background-color: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
            width: 250px;
        }
        .opcion-box h5 {
            margin-bottom: 15px;
            font-weight: 600;
        }
        .avatar-circle {
            display: inline-block;
            width: 40px;
            height: 40px;
            background-color: #007bff;
            color: white;
            font-weight: bold;
            border-radius: 50%;
            text-align: center;
            line-height: 40px;
            font-size: 18px;
        }
        /* Estilo para el nombre del usuario si está logueado */
        .user-name-display {
            display: flex;
            align-items: center;
            margin-right: 15px; /* Espacio entre el nombre y el ícono */
            color: #333; /* Color de texto para el nombre */
            font-weight: 500;
        }
    </style>
</head>
<body>
    <jsp:include page="UserMenu.jsp" />

<div class="container">
    <div class="bienvenida">
        <h1>Bienvenido a Nuestro Restaurante</h1>
        <p>Donde cada comida es una experiencia inolvidable.</p>
    </div>

    <div class="opciones">
        <div class="opcion-box">
            <h5>¿Deseas reservar una mesa?</h5>
            <%-- Obtener el usuario logueado en una variable JSTL --%>
            <c:set var="usuarioLogeado" value="${sessionScope.usuarioLogeado}" />

            <c:choose>
                <c:when test="${usuarioLogeado eq null}">
                    <a href="#" onclick="showLoginModal('reservar.jsp', 'Si quieres <strong>reservar</strong> una mesa, ¡regístrate y accede!'); return false;" class="btn btn-warning">Hacer Reserva</a>
                </c:when>
                <c:otherwise>
                    <a href="reservar.jsp" class="btn btn-warning">Hacer Reserva</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="opcion-box">
            <h5>¿Prefieres disfrutar en casa?</h5>
            <%-- Obtener el usuario logueado en una variable JSTL --%>
            <c:set var="usuarioLogeado" value="${sessionScope.usuarioLogeado}" />

            <c:choose>
                <c:when test="${usuarioLogeado eq null}">
                    <a href="#" onclick="showLoginModal('delivery.jsp', 'Si quieres hacer un <strong>delivery</strong> de tu plato favorito, ¡regístrate y accede!'); return false;" class="btn btn-success">Pedir Delivery</a>
                </c:when>
                <c:otherwise>
                    <a href="delivery.jsp" class="btn btn-success">Hacer Pedido</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- El script del modal y showLoginModal ya está en UserMenu.jsp, no lo repitas aquí --%>
</body>
</html>