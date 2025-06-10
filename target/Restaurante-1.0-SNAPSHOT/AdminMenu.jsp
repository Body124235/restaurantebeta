<%-- webapp/AdminMenu.jsp --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario" %> <%-- ¡IMPORTANTE: Usar tu paquete 'modelo'! --%>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    
    <style>
      
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f4f4f4; 
            min-height: 100vh; 
            display: flex;
            flex-direction: column;
            margin: 0;
        }

       
        .navbar-admin {
            background-color: #343a40; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            margin-bottom: 20px; 
            border-bottom-left-radius: 10px; 
            border-bottom-right-radius: 10px;
        }

        .navbar-admin .navbar-brand {
            color: #fff; 
            font-weight: 600;
            font-size: 1.25rem;
        }

        .navbar-admin .nav-link {
            color: rgba(255, 255, 255, 0.75); 
            font-weight: 400;
            margin-right: 15px;
            transition: color 0.3s ease; 
        }

        .navbar-admin .nav-link:hover,
        .navbar-admin .nav-link.active {
            color: #fff;
        }

        .navbar-admin .dropdown-menu {
            background-color: #343a40; 
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .navbar-admin .dropdown-item {
            color: rgba(255, 255, 255, 0.75);
            transition: background-color 0.3s ease;
        }

        .navbar-admin .dropdown-item:hover {
            background-color: #495057; 
            color: #fff;
        }

        /* Estilo para la sección del administrador (nombre de usuario) */
        .admin-profile-section .nav-link {
            display: flex;
            align-items: center;
            padding-right: 0; /* Ajustar padding si es necesario */
        }

        .admin-profile-section .bi-person-circle {
            font-size: 1.5rem; /* Tamaño del icono de persona */
            margin-right: 8px; /* Espacio entre el icono y el texto */
            color: #fff; /* Color del icono */
        }
        
        .admin-profile-section .admin-name-label {
            font-weight: 600;
            color: #fff; /* Color del texto del nombre del admin */
            font-size: 0.95rem;
        }

        /* Responsive adjustments */
        @media (max-width: 991.98px) {
            .navbar-admin .navbar-collapse {
                background-color: #343a40; /* Fondo para el menú colapsado */
                padding: 15px;
                border-radius: 5px;
                margin-top: 10px;
            }
            .navbar-admin .nav-item {
                margin-bottom: 5px;
            }
            .navbar-admin .nav-link {
                margin-right: 0; /* Resetear margen en pantallas pequeñas */
                padding-left: 10px;
            }
            .admin-profile-section .nav-link {
                 justify-content: flex-start; /* Alinear a la izquierda en móvil */
                 padding-left: 10px;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-admin"> 
    <div class="container-fluid">
        <a class="navbar-brand" href="panel_adm.jsp">Restaurante - Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar"> 
           <ul class="navbar-nav me-auto mb-2 mb-lg-0"> 
    <li class="nav-item">
        <a class="nav-link active" aria-current="page" href="panel_adm.jsp">Inicio</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="<%= request.getContextPath() %>/ReservaServlet?action=listarReservasAdmin">Lista de Reservas</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="<%= request.getContextPath() %>/DeliveryServlet?action=listarPedidosAdmin">Pedidos de Delivery</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="MenuServlet">Agregar Menús</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="RegistrarAdminServlet">Agregar Nuevo Administrador</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="LogoutServlet">Cerrar Sesión</a>
    </li>
</ul>
            
            <ul class="navbar-nav ms-auto admin-profile-section"> 
                <li class="nav-item dropdown">
                    <%
                
                Usuario adminUser = (Usuario) session.getAttribute("usuarioLogeado"); 
                String adminName = "Invitado"; 

                if (adminUser != null && "admin".equals(adminUser.getRole())) { 
                    adminName = adminUser.getName(); 
                }
            %>
            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle"></i>
                <span class="admin-name-label">Administrador: <%= adminName %></span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="#">Perfil</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="LogoutServlet">Cerrar Sesión</a></li>
            </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>