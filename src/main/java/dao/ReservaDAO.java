package dao;

import modelo.Reserva;
import modelo.ReservaMesEstadistica; 
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public interface ReservaDAO {
    boolean insertReserva(Reserva reserva) throws SQLException;
    Reserva selectReservaById(int id) throws SQLException;
    List<Reserva> selectAllReservas() throws SQLException;
    boolean deleteReserva(int id) throws SQLException;
    boolean updateReserva(Reserva reserva) throws SQLException;
    List<Reserva> selectReservasByUsuario(int usuarioId) throws SQLException;
    boolean updateReservaEstado(int reservaId, String estado) throws SQLException;
    List<Reserva> selectReservasByFecha(LocalDate fecha) throws SQLException;

    List<ReservaMesEstadistica> getCantidadReservasPorMes() throws SQLException;
}

