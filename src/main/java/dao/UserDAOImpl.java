
package dao;

import modelo.Usuario;
import util.ConexionBD; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList; 
import java.util.List;     
import org.mindrot.jbcrypt.BCrypt; 

public class UserDAOImpl implements UsuarioDAO {

    @Override
    public boolean registerUser(Usuario user) throws SQLException {
    String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()); // Aquí se hashea
    System.out.println("DEBUG DAO: Hasheando contraseña para " + user.getEmail() + ". Hash: " + hashedPassword.substring(0, 10) + "..."); // Solo parte del hash
    String sql = "INSERT INTO usuarios (nombre, correo, clave, rol, direccion) VALUES (?, ?, ?, ?, ?)";
    try (Connection conn = ConexionBD.getConexion();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getName());
        ps.setString(2, user.getEmail());
        ps.setString(3, hashedPassword); 
        ps.setString(4, user.getRole());
        ps.setString(5, user.getAddress()); 
        
        int rowsAffected = ps.executeUpdate();
        System.out.println("DEBUG DAO: registerUser - Filas afectadas: " + rowsAffected);
        return rowsAffected > 0;
    } catch (SQLException e) {
        System.err.println("ERROR DAO: SQLException en registerUser: " + e.getMessage());
        e.printStackTrace();
        throw e; 
    } catch (Exception e) {
        System.err.println("ERROR DAO: Excepción inesperada en registerUser: " + e.getMessage());
        e.printStackTrace();
        return false; 
    }
}
    @Override
    public Usuario loginUser(String email, String password) throws SQLException {
       
        String sql = "SELECT id, nombre, correo, direccion, clave, rol FROM usuarios WHERE correo = ?";
        Usuario usuario = null;
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("clave");
                System.out.println("DEBUG: Contraseña hasheada recuperada de DB para " + email + ": " + storedHashedPassword);
                
                if (BCrypt.checkpw(password, storedHashedPassword)) {
                    usuario = new Usuario(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getString("correo"),
                        rs.getString("direccion"),
                        rs.getString("clave"),
                        rs.getString("rol")
                    );
                }
            }
        }
        return usuario; 
    }
    @Override
    
    public Usuario getUserByEmail(String email) throws SQLException {
    System.out.println("DEBUG DAO: Buscando usuario por correo: " + email);
    String sql = "SELECT id, nombre, correo, clave, rol, direccion FROM usuarios WHERE correo = ?";
    try (Connection conn = ConexionBD.getConexion();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            Usuario user = new Usuario();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("nombre"));
            user.setEmail(rs.getString("correo"));
            user.setPassword(rs.getString("clave")); // Esta es la clave hasheada
            user.setRole(rs.getString("rol"));
            user.setAddress(rs.getString("direccion"));
            System.out.println("DEBUG DAO: Usuario encontrado: " + user.getEmail() + " (Rol: " + user.getRole() + ")");
            return user;
        }
    } catch (SQLException e) {
        System.err.println("ERROR DAO: SQLException en getUserByEmail: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
    System.out.println("DEBUG DAO: Usuario no encontrado para correo: " + email);
    return null;
}
    
    @Override
    public List<Usuario> getUsuariosByRol(String role) throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT id, nombre, correo, direccion, clave, rol FROM usuarios WHERE rol = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                usuarios.add(new Usuario(
                    rs.getInt("id"),
                    rs.getString("nombre"),
                    rs.getString("correo"),
                    rs.getString("direccion"),
                    rs.getString("clave"), // En el modelo, puedes optar por no devolver la clave para seguridad
                    rs.getString("rol")
                ));
            }
        }
        return usuarios;
    }
    
    @Override
    public Usuario autenticarUsuario(String correo, String password) throws Exception {
        Usuario usuario = null;
        String sql = "SELECT id, nombre, correo, clave, rol FROM usuarios WHERE correo = ?"; // Asume 'usuarios' es tu tabla principal
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPasswordFromDB = rs.getString("clave");

                    // **** MUY IMPORTANTE: Comparar la contraseña ingresada con el hash de la DB ****
                    // Si estás usando BCrypt:
                    if (BCrypt.checkpw(password, hashedPasswordFromDB)) {
                    // Si NO estás usando hashing (MALO en producción, solo para pruebas iniciales):
                    // if (password.equals(hashedPasswordFromDB)) {
                        usuario = new Usuario();
                        usuario.setId(rs.getInt("id"));
                        usuario.setName(rs.getString("nombre"));
                        usuario.setEmail(rs.getString("correo"));
                        usuario.setRole(rs.getString("rol"));
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error al autenticar usuario: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Error en la base de datos al autenticar.");
        }
        return usuario;
    }
    @Override
    public boolean correoExiste(String correo) throws Exception {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE correo = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error al verificar existencia de correo: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Error en la base de datos al verificar correo.");
        }
        return false;
    }
    
    
    public boolean registrarUsuario(Usuario usuario) throws Exception {
        // Generar el hash de la contraseña antes de guardarla
        String hashedPassword = BCrypt.hashpw(usuario.getPassword(), BCrypt.gensalt());
        usuario.setPassword(hashedPassword); // Guardar el hash en el objeto usuario

        String sql = "INSERT INTO usuarios (nombre, correo, clave, rol) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usuario.getName());
            ps.setString(2, usuario.getEmail());
            ps.setString(3, usuario.getPassword()); // Guardar el hash
            ps.setString(4, usuario.getRole()); // Asigna el rol (ej. "usuario" o "administrador")
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Error en la base de datos al registrar.");
        }
    }
    

    @Override
    public Usuario getUserById(int id) throws SQLException {
        Usuario usuario = null;
        // Modifica la consulta SQL para usar 'correo' en lugar de 'email'
        String sql = "SELECT id, nombre, correo, direccion, clave, rol FROM usuarios WHERE id = ?";
        try (Connection conn = ConexionBD.getConexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // Asegúrate de que los nombres de las columnas aquí coincidan con los de tu tabla
                    int usuarioId = rs.getInt("id");
                    String nombre = rs.getString("nombre");
                    String correo = rs.getString("correo"); // <-- CAMBIO AQUÍ: de "email" a "correo"
                    String direccion = rs.getString("direccion");
                    String clave = rs.getString("clave");
                    String rol = rs.getString("rol");
                    usuario = new Usuario(usuarioId, nombre, correo, direccion, clave, rol);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return usuario;
    }
}
