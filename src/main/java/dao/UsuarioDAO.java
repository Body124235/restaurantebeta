/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import util.ConexionBD;
import java.sql.*;
import java.util.List; 
import modelo.Usuario;
import java.sql.SQLException;

public interface UsuarioDAO {
    boolean registerUser(Usuario user) throws SQLException;
    Usuario loginUser(String email, String password) throws SQLException;
    Usuario getUserByEmail(String email) throws SQLException; 
    List<Usuario> getUsuariosByRol(String role) throws SQLException;
    Usuario autenticarUsuario(String correo, String password) throws Exception;
    boolean correoExiste(String correo) throws Exception; 
    Usuario getUserById(int id) throws SQLException;
}