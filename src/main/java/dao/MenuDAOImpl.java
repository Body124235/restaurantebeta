
package dao;

import modelo.Menu;
import util.ConexionBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class MenuDAOImpl implements MenuDAO {

    
    @Override
    public List<Menu> selectAllMenus() throws SQLException {
        List<Menu> menus = new ArrayList<>();
        String sql = "SELECT id, nombre, precio, imagen, cantidad FROM menus"; // Asegúrate de que 'cantidad' exista en tu tabla 'menus'
        try (Connection conn = ConexionBD.getConexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Menu menu = new Menu();
                menu.setId(rs.getInt("id"));
                menu.setNombre(rs.getString("nombre"));
                menu.setPrecio(rs.getBigDecimal("precio")); // Importante: Usar getBigDecimal si tu Menu tiene BigDecimal
                menu.setImagen(rs.getString("imagen"));
                menu.setCantidad(rs.getInt("cantidad")); // Obtener la cantidad (stock)
                menus.add(menu);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener todos los menús (selectAllMenus): " + e.getMessage());
            e.printStackTrace();
            throw e; // Propagamos la excepción para que el Servlet la maneje
        }
        return menus;
    }

   
    @Override
    public List<Menu> selectMenusByNombre(String nombreBuscar) throws SQLException {
        List<Menu> menus = new ArrayList<>();
        // Usamos LIKE para búsqueda parcial
        String sql = "SELECT id, nombre, precio, imagen, cantidad FROM menus WHERE nombre LIKE ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + nombreBuscar + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Menu menu = new Menu();
                menu.setId(rs.getInt("id"));
                menu.setNombre(rs.getString("nombre"));
                menu.setPrecio(rs.getBigDecimal("precio")); // Usar getBigDecimal
                menu.setImagen(rs.getString("imagen"));
                menu.setCantidad(rs.getInt("cantidad"));
                menus.add(menu);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar menús por nombre (selectMenusByNombre): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return menus;
    }

   
    @Override
    public void insertMenu(Menu menu) throws SQLException {
        String sql = "INSERT INTO menus (nombre, imagen, precio, cantidad) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, menu.getNombre());
            pstmt.setString(2, menu.getImagen()); // La imagen va en la segunda posición
            pstmt.setBigDecimal(3, menu.getPrecio()); // Usar setBigDecimal
            pstmt.setInt(4, menu.getCantidad());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error al insertar menú (insertMenu): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    
    @Override
    public boolean updateMenu(Menu menu) throws SQLException {
        String sql = "UPDATE menus SET nombre = ?, imagen = ?, precio = ?, cantidad = ? WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, menu.getNombre());
            pstmt.setString(2, menu.getImagen());
            pstmt.setBigDecimal(3, menu.getPrecio()); // Usar setBigDecimal
            pstmt.setInt(4, menu.getCantidad());
            pstmt.setInt(5, menu.getId());

            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar menú (updateMenu): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

   
    @Override
    public boolean deleteMenu(int id) throws SQLException {
        String sql = "DELETE FROM menus WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar menú (deleteMenu): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    
    @Override
    public Menu obtenerMenuPorId(int id) throws SQLException {
        String sql = "SELECT id, nombre, precio, imagen, cantidad FROM menus WHERE id = ?";
        Menu menu = null;
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                menu = new Menu();
                menu.setId(rs.getInt("id"));
                menu.setNombre(rs.getString("nombre"));
                menu.setPrecio(rs.getBigDecimal("precio"));
                menu.setImagen(rs.getString("imagen"));
                menu.setCantidad(rs.getInt("cantidad"));
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener menú por ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return menu;
    }

   
    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}