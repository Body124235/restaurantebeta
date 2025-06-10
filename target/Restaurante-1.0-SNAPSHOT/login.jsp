<%-- webapp/login.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Acceso - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f0f2f5;
        }
        .container-form {
            background-color: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin-top: 50px;
        }
        h3 {
            text-align: center;
            margin-bottom: 30px;
        }
        .btn-custom {
            width: 100%;
        }
        /* Estilo para mensajes de error */
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row container-form">
        <div class="col-md-6 border-end">
            <h3>
               <i class="bi bi-box-arrow-in-right"></i> Iniciar Sesión
            </h3>
            <%
                // Mensaje de error para el formulario de login
                String loginErrorMessage = (String) request.getAttribute("errorMessage");
                if (loginErrorMessage != null) {
                    // Solo mostrar el mensaje si el error fue causado por el login      
            %>
                    <p class="error-message"><%= loginErrorMessage %></p>
            <%
                }
            %>
            <form method="post" action="LoginServlet">
                <div class="mb-3">
                    <label for="correoLogin" class="form-label">Correo electrónico</label>          
                    <input type="email" class="form-control" id="correoLogin" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="claveLogin" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="claveLogin" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary btn-custom">Ingresar</button>
            </form>
        </div>
<!-------------- Formulario Registrar ----------------->
        <div class="col-md-6">
            <h3><i class="bi bi-person-plus"></i> Registrarse</h3>
            <%
                // Mensaje de error para el formulario de registro
                // Se usa una condición para intentar diferenciar si el error viene del login o registro
                // (aunque lo ideal sería usar atributos de sesión/request más específicos en los servlets)
                String registerErrorMessage = (String) request.getAttribute("errorMessage");
                if (registerErrorMessage != null && request.getParameter("nombreRegistro") != null) {
                    // Asumimos que si nombreRegistro tiene valor, el error viene del formulario de registro
            %>
                <p class="error-message"><%= registerErrorMessage %></p>
            <%
                }
            %>
            <%-- CAMBIO AQUI: action="RegisterServlet" --%>
            <form method="post" action="RegisterServlet">
                
                <div class="mb-3">
                    <label for="nombreRegistro" class="form-label">Nombre completo</label>
                    <input type="text" class="form-control" id="nombreRegistro" name="nombre" required>
                </div>
                   <div class="mb-3">
                    <label for="direccionRegistro" class="form-label">Dirección</label>
                    
                    <input type="text" class="form-control" id="direccionRegistro" name="direccion">
                </div> 
                    
                <div class="mb-3">
                    <label for="correoRegistro" class="form-label">Correo electrónico</label>        
                    <input type="email" class="form-control" id="correoRegistro" name="correo" required>
                </div>
                    
                    
                
                    
                <div class="mb-3">
                    <label for="claveRegistro" class="form-label">Contraseña</label>       
                    <input type="password" class="form-control" id="claveRegistro" name="contrasena" required>
                </div>
                    
                    
                <div class="mb-3">
                    <label for="claveConfirmar" class="form-label">Confirmar contraseña</label>
                    <input type="password" class="form-control" id="claveConfirmar" name="confirmar_contrasena" required>
                </div>
                    
                <button type="submit" class="btn btn-success btn-custom">Registrarme</button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>