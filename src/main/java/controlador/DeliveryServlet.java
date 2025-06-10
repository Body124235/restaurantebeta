package controlador;

import dao.PedidoDAO;
import dao.PedidoDAOImpl;
import dao.UsuarioDAO;
import dao.UserDAOImpl;
import modelo.Pedido;
import modelo.Usuario;
import modelo.Menu;
import modelo.MenuVendidoMesEstadistica;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/DeliveryServlet")
public class DeliveryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PedidoDAO pedidoDAO;
    private UsuarioDAO usuarioDAO;
    

    public void init() {
        pedidoDAO = new PedidoDAOImpl();
        usuarioDAO = new UserDAOImpl();
        
        System.out.println("DEBUG: DeliveryServlet inicializado. DAOs creados.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "verMenuDelivery";
        }
        System.out.println("DEBUG-DELIVERY_GET: Action recibida: " + action);

        try {
            switch (action) {
                case "listarPedidosAdmin":
                    listarPedidosAdmin(request, response);
                    break;
                case "eliminarPedido":
                    eliminarPedido(request, response);
                    break;
                case "verMenuDelivery": // Nueva acción para la página de delivery del usuario
                    verMenuDelivery(request, response);
                    break;
                default:  
                    System.out.println("DEBUG-DELIVERY_GET: Acción no reconocida: " + action + ". Redirigiendo a verMenuDelivery.");
                    verMenuDelivery(request, response); // Muestra el menú de delivery por defecto
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("ERROR-DELIVERY_GET: SQLException al procesar GET: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error de base de datos en operación GET de Delivery: " + ex.getMessage(), ex);
        } catch (Exception ex) {
            System.err.println("ERROR-DELIVERY_GET: Excepción inesperada al procesar GET: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error inesperado en operación GET de Delivery: " + ex.getMessage(), ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "insertarPedido"; 
        }
        System.out.println("DEBUG-DELIVERY_POST: Action recibida: " + action);

        try {
            switch (action) {
                case "insertarPedido":
                    
                    System.out.println("DEBUG-DELIVERY_POST: Acción 'insertarPedido' no implementada. Redirigiendo a verMenuDelivery.");
                    verMenuDelivery(request, response); 
                    break;
                case "agregarAlCarrito": 
                    agregarAlCarrito(request, response);
                    break;
                case "cambiarEstadoPedido":
                    cambiarEstadoPedido(request, response);
                    break;
                default:
                    System.out.println("DEBUG-DELIVERY_POST: Action por defecto no manejada. Redirigiendo a listar.");
                   
                    listarPedidosAdmin(request, response); 
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("ERROR-DELIVERY_POST: SQLException al procesar POST: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error de base de datos en operación POST de Delivery: " + ex.getMessage(), ex);
        } catch (Exception ex) {
            System.err.println("ERROR-DELIVERY_POST: Excepción inesperada al procesar POST: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error inesperado en operación POST de Delivery: " + ex.getMessage(), ex);
        }
    }

   
    private void verMenuDelivery(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        System.out.println("DEBUG: Preparando datos para delivery.jsp.");

        HttpSession session = request.getSession(false); 

        
        if (session != null) {
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioLogeado");
            if (usuarioLogueado != null) {
                System.out.println("DEBUG: Usuario logueado encontrado en sesión: " + usuarioLogueado.getName());
                request.setAttribute("nombreUsuario", usuarioLogueado.getName());
                request.setAttribute("direccionUsuario", usuarioLogueado.getAddress()); 
            } else {
                System.out.println("DEBUG: No hay usuario logueado en sesión.");
            }
        } else {
            System.out.println("DEBUG: No hay sesión activa.");
        }

        
        List<Menu> listaMenus = null;
        try {
            
            listaMenus = pedidoDAO.selectAllMenus(); 
          
            System.out.println("DEBUG: Menús cargados. Cantidad: " + (listaMenus != null ? listaMenus.size() : 0));
        } catch (Exception e) {
            System.err.println("ERROR: No se pudieron cargar los menús: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "No se pudieron cargar los menús en este momento.");
        }

        request.setAttribute("listaMenus", listaMenus);

        
        request.getRequestDispatcher("/delivery.jsp").forward(request, response);
    }

    
    private void agregarAlCarrito(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession(true); 

        Integer menuId = null;
        Integer cantidad = null;
        String mensajeExito = null;
        String errorMessage = null;

        try {
            menuId = Integer.parseInt(request.getParameter("menuId"));
            cantidad = Integer.parseInt(request.getParameter("cantidad"));

            

       
            mensajeExito = "Se ha agregado el menú ID " + menuId + " con cantidad " + cantidad + " al carrito (simulado).";
            System.out.println("DEBUG: " + mensajeExito);

        } catch (NumberFormatException e) {
            errorMessage = "Cantidad o ID de menú inválidos.";
            System.err.println("ERROR: " + errorMessage + " - " + e.getMessage());
        } catch (Exception e) {
            errorMessage = "Error al intentar agregar al carrito: " + e.getMessage();
            System.err.println("ERROR: " + errorMessage + " - " + e.getMessage());
            e.printStackTrace();
        }

        request.setAttribute("mensajeExito", mensajeExito);
        request.setAttribute("error", errorMessage);

       
        verMenuDelivery(request, response);
    }


    private void listarPedidosAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        System.out.println("DEBUG: Listando pedidos para administrador.");
        List<Pedido> listaPedidos;
        String fechaParam = request.getParameter("fecha");

        if (fechaParam != null && !fechaParam.isEmpty()) {
            try {
                LocalDate fechaFiltro = LocalDate.parse(fechaParam);
                listaPedidos = pedidoDAO.selectPedidosByFechaWithMenuNames(fechaFiltro);
                System.out.println("DEBUG: Pedidos filtrados por fecha: " + fechaFiltro);
            } catch (DateTimeParseException e) {
                System.err.println("ERROR: Formato de fecha inválido para filtrar pedidos: " + fechaParam);
                listaPedidos = pedidoDAO.selectAllPedidosWithMenuNames();
                request.setAttribute("error", "Formato de fecha inválido. Mostrando todos los pedidos.");
            }
        } else {
            listaPedidos = pedidoDAO.selectAllPedidosWithMenuNames();
        }

        request.setAttribute("listaPedidos", listaPedidos);

        List<MenuVendidoMesEstadistica> estadisticasMenus = pedidoDAO.getTopMenuVendidoPorMes();
        request.setAttribute("estadisticasMenus", estadisticasMenus);

        Map<Integer, String> nombresUsuarios = new HashMap<>();
        for (Pedido p : listaPedidos) {
            Usuario u = usuarioDAO.getUserById(p.getUsuarioId());
            if (u != null) {
                nombresUsuarios.put(p.getUsuarioId(), u.getName());
            } else {
                nombresUsuarios.put(p.getUsuarioId(), "Usuario Desconocido");
            }
        }
        request.setAttribute("nombresUsuarios", nombresUsuarios);

        request.getRequestDispatcher("/panelListaDelivery.jsp").forward(request, response);
    }

    private void cambiarEstadoPedido(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int pedidoId = Integer.parseInt(request.getParameter("id"));
        String nuevoEstado = request.getParameter("estado");

        System.out.println("DEBUG: Cambiando estado de pedido ID " + pedidoId + " a " + nuevoEstado);
        pedidoDAO.updatePedidoEstado(pedidoId, nuevoEstado);

        listarPedidosAdmin(request, response);
    }

    private void eliminarPedido(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int pedidoId = Integer.parseInt(request.getParameter("id"));
        System.out.println("DEBUG: Eliminando pedido con ID: " + pedidoId);
        pedidoDAO.deletePedido(pedidoId);
        listarPedidosAdmin(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para operaciones de Delivery (tanto de usuario como de admin)";
    }
}