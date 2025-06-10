<%-- src/main/webapp/reservar.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reservar una Mesa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* Reset básicos para html y body (igual que en delivery.jsp) */
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100vh;
            background-color: #f8f8f8; /* Color de fondo general de la página */
            font-family: 'Poppins', sans-serif; /* Fuente Poppins para todo el body */
            color: #333; /* Color de texto general */
            box-sizing: border-box;
            display: block;
        }

        /* Estilos para el contenedor principal del contenido de Reservas */
        .container {
            background-color: #ffffff; /* Fondo blanco para el contenido principal */
            padding: 40px; /* Padding interno */
            border-radius: 15px; /* Bordes redondeados */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); /* Sombra suave */
            width: 100%; /* Ocupa el 100% del ancho disponible */
            max-width: 1200px; /* Ancho máximo para que no se extienda demasiado en pantallas grandes */
            margin-left: auto; /* Centra el contenedor */
            margin-right: auto; /* Centra el contenedor */
            margin-top: 30px; /* Espacio crucial: Margen superior para separar del menú */
            margin-bottom: 50px; /* Margen inferior */
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .formulario-reserva {
            padding: 20px;
            border-radius: 10px;
            /* Ya el .container padre tiene fondo blanco y sombra */
        }

        .formulario-reserva h2 {
            margin-bottom: 25px;
            color: #34495e;
            font-weight: 600;
        }

        .form-label {
            font-weight: 500;
            color: #555;
            margin-bottom: 5px;
        }

        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 10px 15px;
            font-size: 1em;
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

        .img-fluid.rounded {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

    <jsp:include page="UserMenu.jsp" />

    <div class="container">
        <h1>Reservar una Mesa</h1>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>
        <c:if test="${not empty mensajeExito}">
            <div class="alert alert-success" role="alert">
                ${mensajeExito}
            </div>
        </c:if>

        <div class="row">
            <div class="col-md-6">
                <div class="formulario-reserva">
                    <h2 class="text-center">Formulario de Reserva</h2>
                    <form action="${pageContext.request.contextPath}/ReservaServlet" method="post">
                        

                        <div class="mb-3">
                            <label for="nombre" class="form-label">Nombre</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" 
                                   value="<c:out value="${sessionScope.usuarioLogeado.name != null ? sessionScope.usuarioLogeado.name : 'No logueado'}"/>" 
                                   required readonly> 
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="<c:out value="${sessionScope.usuarioLogeado.email != null ? sessionScope.usuarioLogeado.email : 'No logueado'}"/>" 
                                   required readonly>
                        </div>
                               <div class="mb-3">
                            <label for="fecha" class="form-label">Fecha de Reserva</label>
                            <input type="date" class="form-control" id="fecha" name="fecha" required>
                        </div>
                        <div class="mb-3">
                            <label for="hora" class="form-label">Hora de Reserva</label>
                            <input type="time" class="form-control" id="hora" name="hora" required>
                        </div>
                        <div class="mb-3">
                            <label for="personas" class="form-label">Número de Personas</label>
                            <input type="number" class="form-control" id="personas" name="personas" required min="1">
                        </div>
                        <button type="submit" class="btn btn-primary">Reservar</button>
                    </form>
                </div>
            </div>

            <div class="col-md-6 d-flex align-items-center justify-content-center">
                <img src="img/restaurante.jpg" alt="Imagen del Restaurante" class="img-fluid rounded">
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>