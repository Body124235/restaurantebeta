    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import dao.UserDAOImpl;
import dao.UsuarioDAO; // Necesitas un DAO para interactuar con la DB
import modelo.Usuario;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.annotation.WebServlet;

@WebServlet("/RegistrarAdminServlet") 
public class RegistrarAdminServlet extends HttpServlet {

   private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;

    public RegistrarAdminServlet() {
        super();
        this.usuarioDAO = new UserDAOImpl(); 
    }
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    
    @Override
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Usuario> administradores = usuarioDAO.getUsuariosByRol("admin");
            request.setAttribute("administradores", administradores);
            request.getRequestDispatcher("agregar_newAdmin.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error al cargar la lista de administradores: " + e.getMessage());
            e.printStackTrace();
            
            request.getRequestDispatcher("agregar_newAdmin.jsp").forward(request, response);
        }
    }
        
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      
        String name = request.getParameter("nombre");
        String email = request.getParameter("correo");
        String address = request.getParameter("direccion");
        String password = request.getParameter("contrasena");
        String confirmPassword = request.getParameter("confirmar_contrasena"); 


        String errorMessage = null;
        String successMessage = null;

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errorMessage = "Todos los campos obligatorios deben ser rellenados.";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "Las contraseñas no coinciden.";
        } else {
            try {
                // Verificar si el correo ya existe
                if (usuarioDAO.getUserByEmail(email) != null) {
                    errorMessage = "El correo electrónico ya está registrado.";
                } else {
                    Usuario nuevoAdmin = new Usuario();
                    nuevoAdmin.setName(name);
                    nuevoAdmin.setEmail(email);
                    nuevoAdmin.setAddress(address);
                    nuevoAdmin.setPassword(password); // La lógica de hasheo está en el DAO
                    nuevoAdmin.setRole("admin"); // Establecer el rol como administrador

                    boolean registrado = usuarioDAO.registerUser(nuevoAdmin);
                    if (registrado) {
                        successMessage = "Administrador registrado exitosamente.";
                    } else {
                        errorMessage = "No se pudo registrar el administrador. Intente de nuevo.";
                    }
                }
            } catch (SQLException e) {
                errorMessage = "Error al registrar el administrador: " + e.getMessage();
                e.printStackTrace();
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        } else {
            request.setAttribute("successMessage", successMessage);
        }
        
        // Siempre recargar la lista de administradores para mostrarla en la tabla
        try {
            List<Usuario> administradores = usuarioDAO.getUsuariosByRol("admin");
            request.setAttribute("administradores", administradores);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", (errorMessage == null ? "" : errorMessage + " ") + "Error al cargar la lista de administradores: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("agregar_newAdmin.jsp").forward(request, response);
    }

    
    @Override
    
    public String getServletInfo() {
        return "Short description";
    }

}
