package dao;

import java.math.BigDecimal;
import util.ConexionBD;
import modelo.Pedido;
import modelo.DetallePedido; 
import modelo.MenuVendidoMesEstadistica; 
import java.sql.Connection;
import java.sql.Date; 
import modelo.Menu; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement; 
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAOImpl implements PedidoDAO {

    public PedidoDAOImpl() {
        
    }

    @Override
    public boolean insertPedido(Pedido pedido) throws SQLException {
        String sql = "INSERT INTO pedidos (usuario_id, fecha_pedido, total, direccion_entrega, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, pedido.getUsuarioId());
            pstmt.setDate(2, Date.valueOf(pedido.getFechaPedido()));
            pstmt.setDouble(3, pedido.getTotal());
            pstmt.setString(4, pedido.getDireccionEntrega());
            pstmt.setString(5, pedido.getEstado());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        pedido.setId(generatedKeys.getInt(1)); 
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error al insertar pedido: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return false;
    }

    @Override
    public Pedido selectPedidoById(int id) throws SQLException {
        Pedido pedido = null;
        String sql = "SELECT id, usuario_id, fecha_pedido, total, direccion_entrega, estado FROM pedidos WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                double total = rs.getDouble("total");
                String direccionEntrega = rs.getString("direccion_entrega");
                String estado = rs.getString("estado");
                pedido = new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado);
                
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar pedido por ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedido;
    }

    @Override
    public List<Pedido> selectAllPedidos() throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_pedido, total, direccion_entrega, estado FROM pedidos ORDER BY fecha_pedido DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("id");
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                double total = rs.getDouble("total");
                String direccionEntrega = rs.getString("direccion_entrega");
                String estado = rs.getString("estado");
                pedidos.add(new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar todos los pedidos: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedidos;
    }

    @Override
    public boolean deletePedido(int id) throws SQLException {
        String sql = "DELETE FROM pedidos WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar pedido: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public boolean updatePedido(Pedido pedido) throws SQLException {
        String sql = "UPDATE pedidos SET usuario_id = ?, fecha_pedido = ?, total = ?, direccion_entrega = ?, estado = ? WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, pedido.getUsuarioId());
            pstmt.setDate(2, Date.valueOf(pedido.getFechaPedido()));
            pstmt.setDouble(3, pedido.getTotal());
            pstmt.setString(4, pedido.getDireccionEntrega());
            pstmt.setString(5, pedido.getEstado());
            pstmt.setInt(6, pedido.getId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar pedido: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Override
    public List<Pedido> selectPedidosByUsuario(int usuarioId) throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_pedido, total, direccion_entrega, estado FROM pedidos WHERE usuario_id = ? ORDER BY fecha_pedido DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuarioId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                double total = rs.getDouble("total");
                String direccionEntrega = rs.getString("direccion_entrega");
                String estado = rs.getString("estado");
               
                pedidos.add(new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar pedidos por ID de usuario: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedidos;
    }


    @Override
    public boolean updatePedidoEstado(int pedidoId, String estado) throws SQLException {
        String sql = "UPDATE pedidos SET estado = ? WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, estado);
            pstmt.setInt(2, pedidoId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar estado del pedido: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    
    @Override
    public List<Pedido> selectPedidosByFecha(LocalDate fecha) throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
       
        String sql = "SELECT p.id, p.usuario_id, p.fecha_pedido, p.direccion_entrega, p.total, p.estado " +
                     "FROM pedidos p WHERE p.fecha_pedido = ? ORDER BY p.fecha_pedido ASC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(fecha));
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                String direccionEntrega = rs.getString("direccion_entrega");
                double total = rs.getDouble("total");
                String estado = rs.getString("estado");
                // USAMOS EL CONSTRUCTOR QUE NO INCLUYE LOS DETALLES
                pedidos.add(new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar pedidos por fecha: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedidos;
    }

    public List<Pedido> selectPedidosByUsuarioAndFecha(int usuarioId, LocalDate fecha) throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT id, usuario_id, fecha_pedido, total, direccion_entrega, estado FROM pedidos WHERE usuario_id = ? AND fecha_pedido = ? ORDER BY fecha_pedido DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuarioId);
            pstmt.setDate(2, Date.valueOf(fecha));
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                double total = rs.getDouble("total");
                String direccionEntrega = rs.getString("direccion_entrega");
                String estado = rs.getString("estado");
                pedidos.add(new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar pedidos por ID de usuario y fecha: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedidos;
    }

    public List<DetallePedido> selectDetallesByPedidoId(int pedidoId) throws SQLException {
        List<DetallePedido> detalles = new ArrayList<>();
        // Asegúrate de que tu tabla 'detalle_pedidos' tenga estas columnas
        String sql = "SELECT id, pedido_id, menu_id, cantidad, precio_unitario FROM items_pedido WHERE pedido_id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, pedidoId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                int menuId = rs.getInt("menu_id");
                int cantidad = rs.getInt("cantidad");
                double precioUnitario = rs.getDouble("precio_unitario");
                detalles.add(new DetallePedido(id, pedidoId, menuId, cantidad, precioUnitario));
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar detalles de pedido por ID de pedido: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return detalles;
    }

    
   @Override
    public List<MenuVendidoMesEstadistica> getTopMenuVendidoPorMes() throws SQLException {
        List<MenuVendidoMesEstadistica> estadisticas = new ArrayList<>();   
        String sql = "SELECT " +
                     "    EXTRACT(YEAR FROM p.fecha_pedido) as anio, " +
                     "    EXTRACT(MONTH FROM p.fecha_pedido) as mes, " +
                     "    m.nombre as nombre_menu, " +
                     "    SUM(dp.cantidad) as total_vendido " +
                     "FROM pedidos p " +
                     "JOIN items_pedido dp ON p.id = dp.pedido_id " + 
                     "JOIN menus m ON dp.menu_id = m.id " +
                     "GROUP BY anio, mes, m.nombre " +
                     "ORDER BY anio DESC, mes DESC, total_vendido DESC";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                int anio = rs.getInt("anio");
                int mes = rs.getInt("mes");
                String nombreMenu = rs.getString("nombre_menu");
                long totalVendido = rs.getLong("total_vendido");
                estadisticas.add(new MenuVendidoMesEstadistica(anio, mes, nombreMenu, totalVendido));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener estadísticas de menú vendido por mes: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return estadisticas;
    }
    @Override
    public List<Pedido> selectAllPedidosWithMenuNames() throws SQLException {
    List<Pedido> pedidos = new ArrayList<>();
    String sql = "SELECT DISTINCT p.id, p.usuario_id, p.fecha_pedido, p.total, p.direccion_entrega, p.estado, " +
                 "GROUP_CONCAT(m.nombre SEPARATOR ', ') as nombres_menus " +
                 "FROM pedidos p " +
                 "LEFT JOIN items_pedido ip ON p.id = ip.pedido_id " +
                 "LEFT JOIN menus m ON ip.menu_id = m.id " +
                 "GROUP BY p.id, p.usuario_id, p.fecha_pedido, p.total, p.direccion_entrega, p.estado " +
                 "ORDER BY p.fecha_pedido DESC";
    
    try (Connection conn = ConexionBD.getConexion();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        while (rs.next()) {
            int id = rs.getInt("id");
            int usuarioId = rs.getInt("usuario_id");
            LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
            double total = rs.getDouble("total");
            String direccionEntrega = rs.getString("direccion_entrega");
            String estado = rs.getString("estado");
            String nombresMenus = rs.getString("nombres_menus");
            
            // Crear pedido con nombres de menús
            Pedido pedido = new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado);
            pedido.setNombresMenus(nombresMenus); // Necesitarás agregar este campo y método
            pedidos.add(pedido);
        }
    } catch (SQLException e) {
        System.err.println("Error al seleccionar pedidos con nombres de menús: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
    return pedidos;
}


    @Override
    public List<Pedido> selectPedidosByFechaWithMenuNames(LocalDate fecha) throws SQLException {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT DISTINCT p.id, p.usuario_id, p.fecha_pedido, p.total, p.direccion_entrega, p.estado, " +
                     "GROUP_CONCAT(m.nombre SEPARATOR ', ') as nombres_menus " +
                     "FROM pedidos p " +
                     "LEFT JOIN items_pedido ip ON p.id = ip.pedido_id " +
                     "LEFT JOIN menus m ON ip.menu_id = m.id " +
                     "WHERE p.fecha_pedido = ? " +
                     "GROUP BY p.id, p.usuario_id, p.fecha_pedido, p.total, p.direccion_entrega, p.estado " +
                     "ORDER BY p.fecha_pedido ASC";

        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, Date.valueOf(fecha));
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                int usuarioId = rs.getInt("usuario_id");
                LocalDate fechaPedido = rs.getDate("fecha_pedido").toLocalDate();
                double total = rs.getDouble("total");
                String direccionEntrega = rs.getString("direccion_entrega");
                String estado = rs.getString("estado");
                String nombresMenus = rs.getString("nombres_menus");

                Pedido pedido = new Pedido(id, usuarioId, fechaPedido, total, direccionEntrega, estado);
                pedido.setNombresMenus(nombresMenus);
                pedidos.add(pedido);
            }
        } catch (SQLException e) {
            System.err.println("Error al seleccionar pedidos por fecha con nombres de menús: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return pedidos;
    }


    @Override
    public List<Menu> selectAllMenus() throws SQLException {
            List<Menu> menus = new ArrayList<>();

            String sql = "SELECT id, nombre, descripcion, precio, disponible FROM menus WHERE disponible = TRUE ORDER BY nombre ASC";

            try (Connection conn = ConexionBD.getConexion();
                 PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String nombre = rs.getString("nombre");
                    String descripcion = rs.getString("descripcion");
                    BigDecimal precio = rs.getBigDecimal("precio");
                    boolean disponible = rs.getBoolean("disponible"); 


                    Menu menu = new Menu(id, nombre, descripcion, precio, disponible);
                    menus.add(menu);
                }
            } catch (SQLException e) {
                System.err.println("Error al seleccionar todos los menús: " + e.getMessage());
                e.printStackTrace();
                throw e; 
            }
            return menus;
        }
}