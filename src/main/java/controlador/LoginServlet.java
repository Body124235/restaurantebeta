package controlador; // Tu paquete, asegúrate de que sea el correcto

import dao.UsuarioDAO;
import dao.UserDAOImpl;
import modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;

    public LoginServlet() {
        super();
        this.usuarioDAO = new UserDAOImpl();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Podrías usar esto para mostrar la página de login si se accede directamente por GET
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // Asegura la codificación
        System.out.println("DEBUG: LoginServlet - Iniciando doPost.");

        String correo = request.getParameter("email");
        String password = request.getParameter("password"); // Contraseña sin hashear

        System.out.println("DEBUG: Intentando login con Correo: '" + correo + "'");

        String errorMessage = null;
        String successMessage = null;
        Usuario usuarioLogeado = null;

        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            errorMessage = "Por favor, ingresa tu correo y contraseña.";
            System.out.println("DEBUG: Login fallido - Campos vacíos.");
        } else {
            try {
                usuarioLogeado = usuarioDAO.autenticarUsuario(correo, password); // Método en el DAO

                if (usuarioLogeado != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("usuarioLogeado", usuarioLogeado);
                    session.setAttribute("usuarioId", usuarioLogeado.getId());    
                    successMessage = "¡Bienvenido, " + usuarioLogeado.getName() + "!";
                    System.out.println("DEBUG: Login exitoso para: " + usuarioLogeado.getEmail() + " con Rol: " + usuarioLogeado.getRole());

                    if ("admin".equalsIgnoreCase(usuarioLogeado.getRole())) {
                        response.sendRedirect("panel_adm.jsp");
                        return;
                    } else if ("usuario".equalsIgnoreCase(usuarioLogeado.getRole())) {
                        response.sendRedirect("inicio.jsp");
                        return;
                    } else {
                        errorMessage = "Rol de usuario desconocido. Contacta al soporte.";
                        System.out.println("DEBUG: Rol desconocido: " + usuarioLogeado.getRole());
                    }
                } else {
                    errorMessage = "Correo o contraseña incorrectos.";
                    System.out.println("DEBUG: Login fallido - Credenciales incorrectas para: " + correo);
                }
            } catch (Exception e) {
                errorMessage = "Error al intentar iniciar sesión: " + e.getMessage();
                System.err.println("ERROR: Excepción en LoginServlet: " + e.getMessage());
                e.printStackTrace();
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("successMessage", successMessage);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
