<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- ¡Asegúrate de que esta línea esté presente y correcta! --%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reserva Realizada - Restaurante</title>
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
        .container-reserva {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin: 40px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 1000px;
        }
        .success-image {
            max-width: 100%;
            border-radius: 10px;
        }
        .table td, .table th {
            vertical-align: middle;
        }
        h3.text-success {
            font-weight: 600;
        }
        .error-message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="UserMenu.jsp" />

<div class="container container-reserva">
    <div class="row">
        <div class="col-md-7">
            <h3 class="text-success mb-4">¡Reserva realizada con éxito!</h3>
            <table class="table table-bordered">
                <tbody>
                    <%-- Usando Expression Language (EL) --%>
                    <c:choose>
                        <c:when test="${not empty requestScope.reservaExitosa && not empty requestScope.usuarioActual}">
                            <tr>
                                <th>ID de Reserva</th>
                                <td><c:out value="${requestScope.reservaExitosa.id}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Fecha</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.reservaExitosa.fecha}">
                                            <fmt:formatDate value="${requestScope.reservaExitosa.fecha}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="error-message">Fecha no disponible</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Hora</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.reservaExitosa.hora}">
                                            <fmt:formatDate value="${requestScope.reservaExitosa.hora}" pattern="HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="error-message">Hora no disponible</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Cantidad de Personas</th>
                                <td><c:out value="${requestScope.reservaExitosa.numPersonas}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Nombre</th>
                                <td><c:out value="${requestScope.usuarioActual.nombre}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Correo</th>
                                <td><c:out value="${requestScope.usuarioActual.email}" default="N/A"/></td>
                            </tr>
                        </c:when>
                        <%-- Mensaje de error si los atributos principales no están disponibles --%>
                        <c:otherwise>
                            <tr>
                                <td colspan="2" class="text-danger">No se pudieron cargar los detalles de la reserva. Por favor, revise el historial de reservas para verificar.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            <div class="mt-4">
                <a href="ReservaServlet?action=viewUserReservations" class="btn btn-info">Ver mis Reservas</a>
                <a href="inicio.jsp" class="btn btn-secondary">Volver al Inicio</a>
            </div>
        </div>

        <div class="col-md-5 text-center">
            <img src="img/reserva_ok.png" alt="Reserva Exitosa" class="success-image mb-3">
            <p class="text-success fs-5">Gracias por confiar en nosotros.</p>
        </div>
    </div>
</div>

</body>
</html><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- ¡Asegúrate de que esta línea esté presente y correcta! --%>
<%@page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reserva Realizada - Restaurante</title>
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
        .container-reserva {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin: 40px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 1000px;
        }
        .success-image {
            max-width: 100%;
            border-radius: 10px;
        }
        .table td, .table th {
            vertical-align: middle;
        }
        h3.text-success {
            font-weight: 600;
        }
        .error-message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<jsp:include page="UserMenu.jsp" />

<div class="container container-reserva">
    <div class="row">
        <div class="col-md-7">
            <h3 class="text-success mb-4">¡Reserva realizada con éxito!</h3>
            <table class="table table-bordered">
                <tbody>
                    <%-- Usando Expression Language (EL) --%>
                    <c:choose>
                        <c:when test="${not empty requestScope.reservaExitosa && not empty requestScope.usuarioActual}">
                            <tr>
                                <th>ID de Reserva</th>
                                <td><c:out value="${requestScope.reservaExitosa.id}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Fecha</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.reservaExitosa.fecha}">
                                            <fmt:formatDate value="${requestScope.reservaExitosa.fecha}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="error-message">Fecha no disponible</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Hora</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.reservaExitosa.hora}">
                                            <fmt:formatDate value="${requestScope.reservaExitosa.hora}" pattern="HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="error-message">Hora no disponible</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Cantidad de Personas</th>
                                <td><c:out value="${requestScope.reservaExitosa.numPersonas}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Nombre</th>
                                <td><c:out value="${requestScope.usuarioActual.nombre}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Correo</th>
                                <td><c:out value="${requestScope.usuarioActual.email}" default="N/A"/></td>
                            </tr>
                        </c:when>
                        <%-- Mensaje de error si los atributos principales no están disponibles --%>
                        <c:otherwise>
                            <tr>
                                <td colspan="2" class="text-danger">No se pudieron cargar los detalles de la reserva. Por favor, revise el historial de reservas para verificar.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            <div class="mt-4">
                <a href="ReservaServlet?action=viewUserReservations" class="btn btn-info">Ver mis Reservas</a>
                <a href="inicio.jsp" class="btn btn-secondary">Volver al Inicio</a>
            </div>
        </div>

        <div class="col-md-5 text-center">
            <img src="img/reserva_ok.png" alt="Reserva Exitosa" class="success-image mb-3">
            <p class="text-success fs-5">Gracias por confiar en nosotros.</p>
        </div>
    </div>
</div>

</body>
</html>