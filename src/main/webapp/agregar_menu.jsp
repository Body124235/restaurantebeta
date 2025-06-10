<%-- src/main/webapp/jsp/agregar_menu.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administrar Menú - Administrador</title>
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
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            padding: 40px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 1100px;
        }

        .menu-table {
            width: 100%;
            margin-top: 20px;
        }

        .menu-table th, .menu-table td {
            padding: 10px;
            text-align: center;
        }

        .menu-table th {
            background-color: #f8f9fa;
        }

        .menu-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .form-container {
            margin-top: 30px;
            width: 100%;
            max-width: 800px;
        }

        .form-container input {
            margin-bottom: 10px;
        }

       
        .menu-image {
            width: 70px; 
            height: 70px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        
        .acciones-tabla button {
            margin-right: 5px;
        }
    </style>
</head>
<body>

<jsp:include page="AdminMenu.jsp" />

<div class="main-container">
    <div class="panel-container">

        <div class="mb-4 w-100">
            <h4>Buscar Menú por Nombre</h4>
            <form action="${pageContext.request.contextPath}/MenuServlet" method="get" class="d-flex">
                <input type="hidden" name="action" value="buscar">
                <input type="text" class="form-control me-2" name="nombreBuscar"
                       placeholder="Buscar por nombre del menú" value="${nombreBuscar != null ? nombreBuscar : ''}">
                <button type="submit" class="btn btn-primary">Buscar</button>
            </form>
        </div>

        <h4 class="mt-4">Menús Disponibles</h4>
        <table class="table table-bordered menu-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre del Menú</th>
                    <th>Imagen</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty listaMenus}">
                        <c:forEach var="menu" items="${listaMenus}">
                            <tr>
                                <td><c:out value="${menu.id}"/></td>
                                <td><c:out value="${menu.nombre}"/></td>
                                <td><img src="${menu.imagen}" alt="${menu.nombre}" class="menu-image"></td>
                                <td>S/ <c:out value="${menu.precio}"/></td>
                                <td><c:out value="${menu.cantidad}"/></td>
                                <td class="acciones-tabla">
                                    <button class="btn btn-warning btn-sm"
                                            onclick="editarMenu(${menu.id}, '${menu.nombre}', '${menu.imagen}', ${menu.precio}, ${menu.cantidad})">
                                        Editar
                                    </button>
                                    <a href="${pageContext.request.contextPath}/MenuServlet?action=eliminar&id=${menu.id}"
                                       onclick="return confirm('¿Está seguro de que desea eliminar este menú?');"
                                       class="btn btn-danger btn-sm">
                                        Eliminar
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" class="text-center">No hay menús disponibles</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="form-container">
            <h5 class="mt-4" id="formTitle">Agregar Nuevo Menú</h5>
            <form action="${pageContext.request.contextPath}/MenuServlet" method="POST">
                <input type="hidden" name="action" id="formAction" value="insertar">
                <input type="hidden" name="id" id="menuId">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="nombreMenu" class="form-label">Nombre del Menú</label>
                        <input type="text" class="form-control" id="nombreMenu" name="nombreMenu" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="imagenMenu" class="form-label">URL de la Imagen</label>
                        <input type="text" class="form-control" id="imagenMenu" name="imagenMenu" placeholder="Ej: http://ejemplo.com/menu.jpg">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="precio" class="form-label">Precio</label>
                        <input type="number" class="form-control" id="precio" name="precio" step="0.01" min="0" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="cantidad" class="form-label">Cantidad (Stock)</label>
                        <input type="number" class="form-control" id="cantidad" name="cantidad" min="0" required>
                    </div>
                </div>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-3">
                    <button type="submit" class="btn btn-primary" id="btnGuardar">Agregar Menú</button>
                    <button type="button" class="btn btn-secondary" id="btnCancelar" style="display: none;">Cancelar Edición</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editarMenu(id, nombre, imagen, precio, cantidad) {
        document.getElementById('menuId').value = id;
        document.getElementById('nombreMenu').value = nombre;
        document.getElementById('imagenMenu').value = imagen;
        document.getElementById('precio').value = precio;
        document.getElementById('cantidad').value = cantidad;
        document.getElementById('formAction').value = 'actualizar'; // Cambiar la acción a 'actualizar'
        document.getElementById('formTitle').innerText = 'Editar Menú Existente';
        document.getElementById('btnGuardar').innerText = 'Actualizar Menú';
        document.getElementById('btnCancelar').style.display = 'inline-block'; // Mostrar botón Cancelar
    }

    document.getElementById('btnCancelar').addEventListener('click', function() {
        // Limpiar el formulario
        document.getElementById('menuId').value = '';
        document.getElementById('nombreMenu').value = '';
        document.getElementById('imagenMenu').value = '';
        document.getElementById('precio').value = '';
        document.getElementById('cantidad').value = '';
        document.getElementById('formAction').value = 'insertar'; // Volver a la acción 'insertar'
        document.getElementById('formTitle').innerText = 'Agregar Nuevo Menú';
        document.getElementById('btnGuardar').innerText = 'Agregar Menú';
        this.style.display = 'none'; // Ocultar botón Cancelar
    });

    // Cargar menús al cargar la página si no se hizo una búsqueda previa
   // ... tu función editarMenu y btnCancelar ...

    // ELIMINA O COMENTA ESTE BLOQUE COMPLETO
    /*
    window.onload = function() {
        <c:if test="${empty listaMenus && empty nombreBuscar}">
            // Si no hay lista de menús (primera carga o sin búsqueda), redirige para listar todo
            window.location.href = "${pageContext.request.contextPath}/MenuServlet?action=listar";
        </c:if>
    };
    */
</script>
</body>
</html>