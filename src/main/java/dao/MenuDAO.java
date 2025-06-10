
package dao;

import modelo.Menu;
import java.sql.SQLException;
import java.util.List;
import java.math.BigDecimal; 

public interface MenuDAO {

    List<Menu> selectAllMenus() throws SQLException;
    List<Menu> selectMenusByNombre(String nombreBuscar) throws SQLException;
    void insertMenu(Menu menu) throws SQLException;
    boolean updateMenu(Menu menu) throws SQLException;
    boolean deleteMenu(int id) throws SQLException;

    Menu obtenerMenuPorId(int id) throws SQLException;
}