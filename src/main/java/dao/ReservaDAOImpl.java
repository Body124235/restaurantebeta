package dao;

import util.ConexionBD;
import modelo.Reserva;
import modelo.ReservaMesEstadistica; 
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAOImpl implements ReservaDAO {

    public ReservaDAOImpl() {
       
    }

    @Override
    public boolean insertReserva(Reserva reserva) throws SQLException {
        String sql = "INSERT INTO reservas (usuario_id, fecha_reserva, hora_reserva, num_personas, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, reserva.getUsuarioId());
            pstmt.setDate(2, Date.valueOf(reserva.getFechaReserva()));
            pstmt.setTime(3, java.sql.Time.valueOf(reserva.getHoraReserva()));
            pstmt.setInt(4, reserva.getNumPersonas());
            pstmt.setString(5, reserva.getEstado());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        reserva.setId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error al insertar reserva: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return false;
    }

    @Override
    public Reserva selectReservaById(int id) throws SQLException {
        Reserva reserva = null;
        String sql = "SELECT id, usuario_id, fecha_reserva, hora_reserva, num_personas, estado FROM reservas WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaReserva = rs.getDate("fecha_reserva").toLocalDate();
                LocalTime horaReserva = rs.getTime("hora_reserva").toLocalTime();
                int numPersonas = rs.getInt("num_personas");
                String estado = rs.getString("estado");
                reserva = new Reserva(id, usuarioId, fechaReserva, horaReserva, numPersonas, estado);
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar reserva por ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return reserva;
    }

    @Override
    public List<Reserva> selectAllReservas() throws SQLException {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_reserva, hora_reserva, num_personas, estado FROM reservas ORDER BY fecha_reserva DESC, hora_reserva DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaReserva = rs.getDate("fecha_reserva").toLocalDate();
                LocalTime horaReserva = rs.getTime("hora_reserva").toLocalTime();
                int numPersonas = rs.getInt("num_personas");
                String estado = rs.getString("estado");
                reservas.add(new Reserva(id, usuarioId, fechaReserva, horaReserva, numPersonas, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar todas las reservas: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return reservas;
    }

    @Override
    public boolean deleteReserva(int id) throws SQLException {
        String sql = "DELETE FROM reservas WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar reserva: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public boolean updateReserva(Reserva reserva) throws SQLException {
        String sql = "UPDATE reservas SET usuario_id = ?, fecha_reserva = ?, hora_reserva = ?, num_personas = ?, estado = ? WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reserva.getUsuarioId());
            pstmt.setDate(2, Date.valueOf(reserva.getFechaReserva()));
            pstmt.setTime(3, java.sql.Time.valueOf(reserva.getHoraReserva()));
            pstmt.setInt(4, reserva.getNumPersonas());
            pstmt.setString(5, reserva.getEstado());
            pstmt.setInt(6, reserva.getId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar reserva: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<Reserva> selectReservasByUsuario(int usuarioId) throws SQLException {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_reserva, hora_reserva, num_personas, estado FROM reservas WHERE usuario_id = ? ORDER BY fecha_reserva DESC, hora_reserva DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuarioId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                LocalDate fechaReserva = rs.getDate("fecha_reserva").toLocalDate();
                LocalTime horaReserva = rs.getTime("hora_reserva").toLocalTime();
                int numPersonas = rs.getInt("num_personas");
                String estado = rs.getString("estado");
                reservas.add(new Reserva(id, usuarioId, fechaReserva, horaReserva, numPersonas, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar reservas por ID de usuario: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return reservas;
    }

    @Override
    public boolean updateReservaEstado(int reservaId, String estado) throws SQLException {
        String sql = "UPDATE reservas SET estado = ? WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, estado);
            pstmt.setInt(2, reservaId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar estado de la reserva: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<Reserva> selectReservasByFecha(LocalDate fecha) throws SQLException {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_reserva, hora_reserva, num_personas, estado FROM reservas WHERE fecha_reserva = ? ORDER BY fecha_reserva ASC, hora_reserva ASC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(fecha));
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaReserva = rs.getDate("fecha_reserva").toLocalDate();
                LocalTime horaReserva = rs.getTime("hora_reserva").toLocalTime();
                int numPersonas = rs.getInt("num_personas");
                String estado = rs.getString("estado");
                reservas.add(new Reserva(id, usuarioId, fechaReserva, horaReserva, numPersonas, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar reservas por fecha: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return reservas;
    }

    @Override
    public List<ReservaMesEstadistica> getCantidadReservasPorMes() throws SQLException {
        List<ReservaMesEstadistica> estadisticas = new ArrayList<>();
        
        String sql = "SELECT " +
                     "    EXTRACT(YEAR FROM fecha_reserva) as anio, " +
                     "    EXTRACT(MONTH FROM fecha_reserva) as mes, " +
                     "    COUNT(id) as total_reservas " +
                     "FROM reservas " +
                     "GROUP BY anio, mes " +
                     "ORDER BY anio ASC, mes ASC"; 

        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                int anio = rs.getInt("anio");
                int mes = rs.getInt("mes");
                long totalReservas = rs.getLong("total_reservas");
                estadisticas.add(new ReservaMesEstadistica(anio, mes, totalReservas));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas de reservas por mes: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return estadisticas;
    }
}