package dao;

import modelo.Pedido;
import modelo.MenuVendidoMesEstadistica; 
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import modelo.Menu;

public interface PedidoDAO {
    
    boolean insertPedido(Pedido pedido) throws SQLException;
    Pedido selectPedidoById(int id) throws SQLException;
    List<Pedido> selectAllPedidos() throws SQLException;
    boolean deletePedido(int id) throws SQLException;
    boolean updatePedido(Pedido pedido) throws SQLException;
    List<Pedido> selectPedidosByUsuario(int usuarioId) throws SQLException;

    boolean updatePedidoEstado(int pedidoId, String estado) throws SQLException;
    List<Pedido> selectPedidosByFecha(LocalDate fecha) throws SQLException;

    List<MenuVendidoMesEstadistica> getTopMenuVendidoPorMes() throws SQLException;
    List<Pedido> selectAllPedidosWithMenuNames() throws SQLException;
    List<Pedido> selectPedidosByFechaWithMenuNames(LocalDate fecha) throws SQLException;

    public List<Menu> selectAllMenus() throws SQLException;
}