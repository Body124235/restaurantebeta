
package controlador;

import dao.UsuarioDAO;
import dao.UserDAOImpl;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpSession;


@WebServlet("/RegisterServlet") 
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UsuarioDAO userDAO;

    public void init() {
        userDAO = new UserDAOImpl();
    }
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

     
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("nombre");
        String email = request.getParameter("correo");
        String address = request.getParameter("direccion");
        String password = request.getParameter("contrasena");
        String confirmPassword = request.getParameter("confirmar_contrasena");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        Usuario newUser = new Usuario(name, email, address, password, "usuario"); // El rol predeterminado es 'usuario'

        try {
            boolean registered = userDAO.registerUser(newUser);

            if (registered) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogeado", newUser); // Iniciar sesión automáticamente después del registro
                response.sendRedirect("inicio.jsp"); // Redirigir a la página de inicio después del registro exitoso
            } else {
                request.setAttribute("errorMessage", "Error al registrar usuario. El correo ya podría estar en uso.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error al registrar usuario: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
