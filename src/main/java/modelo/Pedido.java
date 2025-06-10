package modelo;

import java.time.LocalDate;
import java.util.List; // Importar List

public class Pedido {
    private int id;
    private int usuarioId;
    private LocalDate fechaPedido;
    private double total;
    private String direccionEntrega;
    private String estado;
    private List<DetallePedido> detalles; // ¡NUEVO ATRIBUTO!
    private String nombresMenus;
    public Pedido() {
    }

    public Pedido(int id, int usuarioId, LocalDate fechaPedido, double total, String direccionEntrega, String estado) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.fechaPedido = fechaPedido;
        this.total = total;
        this.direccionEntrega = direccionEntrega;
        this.estado = estado;
        // No inicializamos 'detalles' aquí, ya que se cargará por separado
    }

    // Constructor que incluye detalles (opcional, pero útil si lo pasas completo)
    public Pedido(int id, int usuarioId, LocalDate fechaPedido, double total, 
              String direccionEntrega, String estado, String nombresMenus) {
            this.id = id;
            this.usuarioId = usuarioId;
            this.fechaPedido = fechaPedido;
            this.total = total;
            this.direccionEntrega = direccionEntrega;
            this.estado = estado;
            this.nombresMenus = nombresMenus;
}


    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public LocalDate getFechaPedido() {
        return fechaPedido;
    }

    public void setFechaPedido(LocalDate fechaPedido) {
        this.fechaPedido = fechaPedido;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getDireccionEntrega() {
        return direccionEntrega;
    }

    public void setDireccionEntrega(String direccionEntrega) {
        this.direccionEntrega = direccionEntrega;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    // ¡NUEVOS GETTER Y SETTER PARA DETALLES!
    public List<DetallePedido> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetallePedido> detalles) {
        this.detalles = detalles;
    }
    public String getNombresMenus() {
    return nombresMenus;
}

public void setNombresMenus(String nombresMenus) {
    this.nombresMenus = nombresMenus;
}
}