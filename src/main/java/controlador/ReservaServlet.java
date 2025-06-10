package controlador;

import dao.ReservaDAO;
import dao.ReservaDAOImpl;
import dao.UsuarioDAO;
import dao.UserDAOImpl;
import modelo.Reserva;
import modelo.Usuario;
import modelo.ReservaMesEstadistica; // Importa la clase de estadísticas
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReservaDAO reservaDAO;
    private UsuarioDAO usuarioDAO;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

    public void init() {
        reservaDAO = new ReservaDAOImpl();
        usuarioDAO = new UserDAOImpl();
        System.out.println("DEBUG: ReservaServlet inicializado. DAOs creados.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listarReservasAdmin"; 
        }
        System.out.println("DEBUG-RESERVA_GET: Action recibida: " + action);

        try {
            switch (action) {
                case "listarReservasAdmin":
                    listarReservasAdmin(request, response);
                    break;
              
                default:
                    listarReservasAdmin(request, response);
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("ERROR-RESERVA_GET: SQLException al procesar GET: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error de base de datos en operación GET de Reserva: " + ex.getMessage(), ex);
        } catch (Exception ex) {
            System.err.println("ERROR-RESERVA_GET: Excepción inesperada al procesar GET: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error inesperado en operación GET de Reserva: " + ex.getMessage(), ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "insertarReserva"; 
        }
        System.out.println("DEBUG-RESERVA_POST: Action recibida: " + action);

        try {
            switch (action) {
                case "insertarReserva":
                    insertarReserva(request, response);
                    break;
                case "cambiarEstadoReserva":
                    cambiarEstadoReserva(request, response);
                    break;
                case "eliminarReserva":
                    eliminarReserva(request, response);
                    break;
                
                default:
                    System.out.println("DEBUG-RESERVA_POST: Action por defecto no manejada. Redirigiendo a listar.");
                    listarReservasAdmin(request, response);
                    break;
            }
        } catch (SQLException ex) {
            System.err.println("ERROR-RESERVA_POST: SQLException al procesar POST: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error de base de datos en operación POST de Reserva: " + ex.getMessage(), ex);
        } catch (Exception ex) {
            System.err.println("ERROR-RESERVA_POST: Excepción inesperada al procesar POST: " + ex.getMessage());
            ex.printStackTrace();
            throw new ServletException("Error inesperado en operación POST de Reserva: " + ex.getMessage(), ex);
        }
    }

    private void insertarReserva(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            System.err.println("ERROR: Intento de insertar reserva sin usuario logueado.");
            request.setAttribute("mensajeError", "Debe iniciar sesión para realizar una reserva.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        int usuarioId = (int) session.getAttribute("usuarioId");

        LocalDate fechaReserva = null;
        LocalTime horaReserva = null;
        int numPersonas = 0;
        String estado = "pendiente";

        try {
            fechaReserva = LocalDate.parse(request.getParameter("fechaReserva"), DATE_FORMATTER);
            horaReserva = LocalTime.parse(request.getParameter("horaReserva"), TIME_FORMATTER);
            numPersonas = Integer.parseInt(request.getParameter("numPersonas"));
        } catch (DateTimeParseException | NumberFormatException e) {
            System.err.println("Error al parsear datos de reserva: " + e.getMessage());
            request.setAttribute("mensajeError", "Formato de fecha, hora o número de personas inválido.");
            request.getRequestDispatcher("/reservar.jsp").forward(request, response);
            return;
        }

        Reserva nuevaReserva = new Reserva(usuarioId, fechaReserva, horaReserva, numPersonas, estado);

        try {
            boolean insertado = reservaDAO.insertReserva(nuevaReserva);
            if (insertado) {
                request.setAttribute("reservaExitosa", nuevaReserva);
                request.getRequestDispatcher("/reserva_realizada.jsp").forward(request, response);
            } else {
                request.setAttribute("mensajeError", "No se pudo realizar la reserva. Intente de nuevo.");
                request.getRequestDispatcher("/reservar.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            System.err.println("Error al insertar reserva en el servlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error de base de datos al procesar su reserva. Contacte a soporte.");
            request.getRequestDispatcher("/reservar.jsp").forward(request, response);
        }
    }

    private void listarReservasAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        System.out.println("DEBUG: Listando reservas para administrador.");
        List<Reserva> listaReservas;
        String fechaParam = request.getParameter("fecha");

        if (fechaParam != null && !fechaParam.isEmpty()) {
            try {
                LocalDate fechaFiltro = LocalDate.parse(fechaParam, DATE_FORMATTER);
                listaReservas = reservaDAO.selectReservasByFecha(fechaFiltro);
                System.out.println("DEBUG: Reservas filtradas por fecha: " + fechaFiltro);
            } catch (DateTimeParseException e) {
                System.err.println("ERROR: Formato de fecha inválido para filtrar reservas: " + fechaParam);
                listaReservas = reservaDAO.selectAllReservas();
                request.setAttribute("error", "Formato de fecha inválido. Mostrando todas las reservas.");
            }
        } else {
            listaReservas = reservaDAO.selectAllReservas();
        }
        
        request.setAttribute("listaReservas", listaReservas);

        Map<Integer, String> nombresUsuarios = new HashMap<>();
        for (Reserva r : listaReservas) {
            Usuario u = usuarioDAO.getUserById(r.getUsuarioId());
            if (u != null) {
                nombresUsuarios.put(r.getUsuarioId(), u.getName());
            } else {
                nombresUsuarios.put(r.getUsuarioId(), "Usuario Desconocido");
            }
        }
        request.setAttribute("nombresUsuarios", nombresUsuarios);

        // Lógica para el gráfico de Estadísticas de Reservas
        try {
            List<ReservaMesEstadistica> estadisticasReservas = reservaDAO.getCantidadReservasPorMes();
            request.setAttribute("reservasEstadisticasMensuales", estadisticasReservas);
            System.out.println("DEBUG: Estadísticas de reservas para gráfico cargadas: " + estadisticasReservas.size() + " entradas.");
        } catch (SQLException e) {
            System.err.println("ERROR: Error al cargar estadísticas de reservas: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorEstadisticas", "No se pudieron cargar las estadísticas de reservas.");
        }

        request.getRequestDispatcher("/panelListaReserva.jsp").forward(request, response);
    }

    private void cambiarEstadoReserva(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int reservaId = Integer.parseInt(request.getParameter("id"));
        String nuevoEstado = request.getParameter("estado");

        System.out.println("DEBUG: Cambiando estado de reserva ID " + reservaId + " a " + nuevoEstado);
        reservaDAO.updateReservaEstado(reservaId, nuevoEstado);
        
        listarReservasAdmin(request, response);
    }

    private void eliminarReserva(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int reservaId = Integer.parseInt(request.getParameter("id"));
        System.out.println("DEBUG: Eliminando reserva con ID: " + reservaId);
        reservaDAO.deleteReserva(reservaId);
        listarReservasAdmin(request, response);
    }
}