// src/main/java/controlador/MenuServlet.java
package controlador;

import dao.MenuDAO; // Importa la interfaz
import dao.MenuDAOImpl; // Importa la implementación concreta
import modelo.Menu;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.annotation.WebServlet;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO; 

    public void init() {
        menuDAO = new MenuDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar"; 
        }
        try {
            switch (action) {
                case "insertar":
                    insertarMenu(request, response);
                    break;
                case "actualizar":
                    actualizarMenu(request, response);
                    break;
                case "buscar":
                    buscarMenus(request, response, "/agregar_menu.jsp");
                    break;
                default:
                    listarMenus(request, response, "/agregar_menu.jsp");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }
        try {
            switch (action) {
                case "eliminar":
                    eliminarMenu(request, response);
                    break;
                case "buscar":
                    buscarMenus(request, response, "/agregar_menu.jsp");
                    break;
                case "mostrarAgregar":
                    listarMenus(request, response, "/agregar_menu.jsp");
                    break;
                case "listarDeliveryMenus":
                    listarMenus(request, response, "/delivery.jsp");
                    break;
                default:
                    listarMenus(request, response, "/agregar_menu.jsp");
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listarMenus(HttpServletRequest request, HttpServletResponse response, String destinoJSP)
            throws SQLException, IOException, ServletException {
        
        List<Menu> listaMenus = menuDAO.selectAllMenus();
        request.setAttribute("listaMenus", listaMenus);
        RequestDispatcher dispatcher = request.getRequestDispatcher(destinoJSP);
        dispatcher.forward(request, response);
    }

    private void insertarMenu(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String nombre = request.getParameter("nombreMenu");
        String imagen = request.getParameter("imagenMenu");
        BigDecimal precio;
        int cantidad;
        try {
            precio = new BigDecimal(request.getParameter("precio"));
            cantidad = Integer.parseInt(request.getParameter("cantidad"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: Precio o Cantidad inválidos.");
            listarMenus(request, response, "/agregar_menu.jsp");
            return;
        }

        Menu nuevoMenu = new Menu(nombre, imagen, precio, cantidad);
       
        menuDAO.insertMenu(nuevoMenu);
        listarMenus(request, response, "/agregar_menu.jsp");
    }

    private void buscarMenus(HttpServletRequest request, HttpServletResponse response, String destinoJSP)
            throws SQLException, IOException, ServletException {
        String nombreBuscar = request.getParameter("nombreBuscar");
        List<Menu> listaMenus;
        if (nombreBuscar != null && !nombreBuscar.trim().isEmpty()) {
            
            listaMenus = menuDAO.selectMenusByNombre(nombreBuscar.trim());
        } else {
            
            listaMenus = menuDAO.selectAllMenus();
        }
        request.setAttribute("listaMenus", listaMenus);
        request.setAttribute("nombreBuscar", nombreBuscar);
        RequestDispatcher dispatcher = request.getRequestDispatcher(destinoJSP);
        dispatcher.forward(request, response);
    }

    private void eliminarMenu(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: ID de menú inválido.");
            listarMenus(request, response, "/agregar_menu.jsp");
            return;
        }

      
        menuDAO.deleteMenu(id);
        listarMenus(request, response, "/agregar_menu.jsp");
    }

    private void actualizarMenu(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id;
        BigDecimal precio;
        int cantidad;
        try {
            id = Integer.parseInt(request.getParameter("id"));
            precio = new BigDecimal(request.getParameter("precio"));
            cantidad = Integer.parseInt(request.getParameter("cantidad"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Error: ID, Precio o Cantidad inválidos.");
            listarMenus(request, response, "/agregar_menu.jsp");
            return;
        }

        String nombre = request.getParameter("nombreMenu");
        String imagen = request.getParameter("imagenMenu");

        Menu menu = new Menu(id, nombre, imagen, precio, cantidad);
        // Llama al método updateMenu()
        menuDAO.updateMenu(menu);
        listarMenus(request, response, "/agregar_menu.jsp");
    }
}