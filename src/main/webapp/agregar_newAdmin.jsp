<%-- 
    Document   : agregar_newAdmin
    Created on : 6 may 2025, 21:00:05
    Author     : USUARIO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Usuario" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Agregar Nuevo Administrador</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .navbar {
            margin-bottom: 30px;
        }

        .container-form {
            background: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .form-label {
            font-weight: 600;
        }

        .form-control, .form-control:read-only {
            border-radius: 8px;
        }

        .btn-primary {
            font-weight: 600;
            padding: 10px 20px;
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

        .table-container {
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            max-height: 500px;
            overflow-y: auto;
        }

        table th {
            font-weight: 600;
        }
    </style>
</head>
<body>
<jsp:include page="AdminMenu.jsp" /> <%-- Incluye el menú de administrador --%>


<!-- Contenido principal -->
<div class="container d-flex gap-4 flex-wrap">
    <%-- Mensajes de feedback --%>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% String successMessage = (String) request.getAttribute("successMessage"); %>
    <% if (errorMessage != null) { %>
        <p class="alert alert-danger" role="alert"><%= errorMessage %></p> <%-- Usar clases de Bootstrap para mejor visibilidad --%>
    <% } %>
    <% if (successMessage != null) { %>
        <p class="alert alert-success" role="alert"><%= successMessage %></p> <%-- Usar clases de Bootstrap para mejor visibilidad --%>
    <% } %>
    <div class="container-form flex-grow-1">
        <h4 class="mb-4 text-center">Formulario para agregar nuevo administrador</h4>
        <form action="RegistrarAdminServlet" method="post" id="adminForm"> <%-- ¡CAMBIO AQUÍ! --%>
            
            <div class="mb-3">
                    <label for="nombreRegistro" class="form-label">Nombre completo</label>
                    <input type="text" class="form-control" id="nombreRegistro" name="nombre" required>
                </div>
                    
                    
                <div class="mb-3">
                    <label for="correoRegistro" class="form-label">Correo electrónico</label>        
                    <input type="email" class="form-control" id="correoRegistro" name="correo" required>
                </div>
                    
                    
                <div class="mb-3">
                    <label for="direccionRegistro" class="form-label">Dirección</label>
                    <%-- CAMBIO AQUI: name="direccion" --%>
                    <input type="text" class="form-control" id="direccionRegistro" name="direccion">
                </div>
                    
                <div class="mb-3">
                    <label for="claveRegistro" class="form-label">Contraseña</label>       
                    <input type="password" class="form-control" id="claveRegistro" name="contrasena" required>
                </div>
                    
                   
                <div class="mb-3">
                    <label for="claveConfirmar" class="form-label">Confirmar contraseña</label>
                    <input type="password" class="form-control" id="claveConfirmar" name="confirmar_contrasena" required>
                </div>
            <div class="text-center">
                <button type="submit" class="btn btn-primary">Agregar Admin</button>
            </div>
        </form>
    </div>

    <!-- Tabla de administradores -->
    <div class="table-container flex-grow-1">
        <h5 class="mb-3">Lista de Administradores Registrados</h5>
        <table class="table table-bordered table-striped">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Dirección</th>
                </tr>
            </thead>
            <tbody>
                <%
                            List<Usuario> administradores = (List<Usuario>) request.getAttribute("administradores");
                            if (administradores != null && !administradores.isEmpty()) {
                                for (Usuario admin : administradores) {
                        %>
                                <tr>
                                    <td><%= admin.getId() %></td>
                                    <td><%= admin.getName() %></td>    <%-- getName() --%>
                                    <td><%= admin.getEmail() %></td>   <%-- getEmail() --%>
                                    <td><%= admin.getAddress() != null ? admin.getAddress() : "N/A" %></td> <%-- getAddress() --%>
                                    <td>
                                        <a href="EditarAdminServlet?id=<%= admin.getId() %>" class="btn btn-sm btn-warning me-2"><i class="bi bi-pencil"></i></a>
                                        <a href="EliminarAdminServlet?id=<%= admin.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar a este administrador?');"><i class="bi bi-trash"></i></a>
                                    </td>
                                </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="5" class="text-center">No hay administradores registrados.</td>
                                </tr>
                        <%
                            }
                        %>
            </tbody>
        </table>
    </div>
</div>

<!-- Script para autocompletar campos -->
<script>
    document.getElementById("rol").addEventListener("change", function () {
        const selected = this.options[this.selectedIndex];
        document.getElementById("nombre").value = selected.dataset.nombre || "";
        document.getElementById("correo").value = selected.dataset.correo || "";
        document.getElementById("direccion").value = selected.dataset.direccion || "";
        document.getElementById("password").value = "";
        document.getElementById("confirmar_password").value = "";
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

