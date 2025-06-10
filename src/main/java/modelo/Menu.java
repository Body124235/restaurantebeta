package modelo;

import java.math.BigDecimal; 

public class Menu {
    private int id;
    private String nombre;
    private String imagen; 
    private BigDecimal precio;
    private int cantidad; 
    private String descripcion;
    private boolean disponible; 

   
    public Menu() {
    }

   
    public Menu(int id, String nombre, String imagen, BigDecimal precio, int cantidad) {
        this.id = id;
        this.nombre = nombre;
        this.imagen = imagen;
        this.precio = precio;
        this.cantidad = cantidad;
    }

    // Constructor para agregar (sin id)
    public Menu(String nombre, String imagen, BigDecimal precio, int cantidad) {
        this.nombre = nombre;
        this.imagen = imagen;
        this.precio = precio;
        this.cantidad = cantidad;
    }

    
    // Este constructor está bien, pero el problema es el tipo de 'precio' (BigDecimal vs double)
    public Menu(int id, String nombre, String descripcion, BigDecimal precio, boolean disponible) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.precio = precio;
        this.disponible = disponible;
    }

    // Getters y Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    // ¡NUEVOS GETTERS Y SETTERS QUE FALTABAN!
    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public boolean isDisponible() { // Para booleanos, se suele usar 'is' en lugar de 'get'
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }
}