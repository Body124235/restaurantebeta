
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menú de Usuario</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
        }

        .menu-container {
            background-color: #ffffff;
            margin: 10px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 8px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .restaurant-name {
            font-size: 1.5em;
            font-weight: 600;
            color: #333;
            margin-right: auto;
        }

        nav.user-nav {
            display: flex;
            align-items: center;
        }

        nav.user-nav a {
            text-decoration: none;
            color: #555;
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 8px;
            transition: background-color 0.3s ease, color 0.3s ease;
            font-weight: 500;
            white-space: nowrap;
        }
        nav.user-nav a:hover {
            background-color: #e8e8e8;
            color: #333;
        }
        
        .profile-wrapper {
            display: flex;
            align-items: center;
            margin-left: 15px;
            cursor: pointer;
        }

        .profile-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: #007bff;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 1.2em;
            font-weight: bold;
            border: 1px solid rgba(0,0,0,0.1);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-decoration: none;
        }
        .profile-icon span {
            color: white;
        }
        
        .user-name-display {
            color: #333;
            font-weight: 500;
            margin-left: 8px;
            white-space: nowrap;
        }

        
        .modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 100px;
        }
        .modal-content {
            background-color: #fefefe;
            padding: 25px;
            border: none;
            width: 90%;
            max-width: 450px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            animation-name: animatetop;
            animation-duration: 0.4s;
            border-radius: 15px;
            text-align: center;
            position: relative;
        }
        @keyframes animatetop {
            from { top: -200px; opacity: 0; }
            to { top: 0; opacity: 1; }
        }
        .close-button {
            color: #aaa;
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 30px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.2s ease;
        }
        .close-button:hover,
        .close-button:focus {
            color: #333;
        }
        .modal-buttons {
            margin-top: 20px;
        }
        .modal-buttons button {
            background-color: #007bff;
            color: white;
            padding: 10px 25px;
            border: none;
            cursor: pointer;
            border-radius: 8px;
            margin: 5px;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .modal-buttons button:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
        .modal-content h2 {
            margin-top: 10px;
            color: #333;
            font-weight: 600;
        }
        .modal-content p {
            font-size: 1.1em;
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .modal-content p strong {
            font-weight: 700;
            color: #5C4033;
        }
    </style>
</head>
<body>

    <div class="menu-container">
        <div class="restaurant-name">Restaurante</div>
        <nav class="user-nav">
            <a href="inicio.jsp">Inicio</a>
            <%
                Usuario debugUsuario = (Usuario) session.getAttribute("usuarioLogeado");
                if (debugUsuario != null) {
                    System.out.println("DEBUG: Usuario en sesión (JSP): " + debugUsuario.getName());
                } else {
                    System.out.println("DEBUG: No hay usuario en sesión (JSP)");
                }
            %>
            <%-- Obtener el usuario logueado  --%>
            <c:set var="usuarioLogeado" value="${sessionScope.usuarioLogeado}" />

           
            <c:choose>
                <c:when test="${usuarioLogeado eq null}">
                    <%-- Si NO hay sesión, los enlaces abren el modal --%>
                    <a href="#" onclick="showLoginModal('reservar.jsp', 'Si quieres <strong>reservar</strong> una mesa, ¡regístrate y accede!'); return false;">Reserva</a>
                    <a href="#" onclick="showLoginModal('delivery.jsp', 'Si quieres hacer un <strong>delivery</strong> de tu plato favorito, ¡regístrate y accede!'); return false;">Delivery</a>
                    <a href="#" onclick="showLoginModal('historial.jsp', 'Para ver tu <strong>historial</strong> de pedidos, debes estar registrado. Por favor, regístrate aquí para acceder.'); return false;">Historial</a>
                    <a href="login.jsp">Iniciar Sesión</a>
                </c:when>
                <c:otherwise>
                    <%-- Si SÍ hay sesión, los enlaces van directamente a la página --%>
                    
                    <%--a class="nav-link" href="${pageContext.request.contextPath}/ReservaServlet?action=mostrarFormulario">Reservar</a--%>
                    <a href="reservar.jsp">Reservar</a>
                    <a href="delivery.jsp">pedido</a>
                    <a href="historial.jsp">Historial</a>
                    
                    <div class="profile-wrapper">
                        <a href="perfil.jsp" class="profile-icon">
                            <%-- Extraer la primera letra del nombre directamente con JSTL/EL --%>
                            <c:if test="${not empty usuarioLogeado.name}">
                                <%= ((Usuario)pageContext.getAttribute("usuarioLogeado")).getName().substring(0, 1).toUpperCase() %>
                            </c:if>
                            <c:if test="${empty usuarioLogeado.name}">
                                &#128100; <%-- Icono genérico si el nombre está vacío --%>
                            </c:if>
                        </a>
                        <span class="user-name-display d-none d-md-block">
                            <c:if test="${not empty usuarioLogeado.name}">
                                ${usuarioLogeado.name.split(" ")[0]}
                            </c:if>
                        </span>
                        <a href="LogoutServlet" class="btn btn-outline-secondary btn-sm ms-2">Salir</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>

    <div id="loginModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeModal()">&times;</span>
            <h2>¡Acceso Requerido!</h2>
            <p id="modalMessage">Para acceder a esta sección, debes estar registrado. Por favor, regístrate aquí para acceder.</p>
            <div class="modal-buttons">
                <button onclick="window.location.href='login.jsp'">Ir a Iniciar Sesión / Registrarse</button>
            </div>
        </div>
    </div>

    <script>
        
        var modal = document.getElementById("loginModal");
        var modalMessage = document.getElementById("modalMessage");

        
        function closeModal() {
            modal.style.display = "none";
        }

        
        window.onclick = function(event) {
            if (event.target == modal) {
                closeModal();
            }
        }

       
        function showLoginModal(targetPage, customMessage) {
            modalMessage.innerHTML = customMessage;
            modal.style.display = "flex";
        }
        
        
        document.querySelector('.modal-content .close-button').addEventListener('click', closeModal);
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>