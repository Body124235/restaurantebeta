    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.*" %>
    <%@ page session="true" %>

    <%
        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        // Verificación simple (puedes reemplazar esto con tu base de datos)
        if ("admin".equals(usuario) && "1234".equals(clave)) {
            session.setAttribute("usuario", usuario);
            response.sendRedirect("inicio.jsp");
        } else {
    %>
        <script>
            alert("Usuario o contraseña incorrectos");
            window.location.href = "login.jsp";
        </script>
    <%
        }
    %>
