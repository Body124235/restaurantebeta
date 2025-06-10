package modelo;

public class DetallePedido {
    private int id;
    private int pedidoId;
    private int menuId;
    private String nombreMenu; 
    private double precioUnitario;
    private int cantidad;
    private double subtotal; 

    
    public DetallePedido() {
    }

    
    public DetallePedido(int id, int pedidoId, int menuId, String nombreMenu, double precioUnitario, int cantidad, double subtotal) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.menuId = menuId;
        this.nombreMenu = nombreMenu;
        this.precioUnitario = precioUnitario;
        this.cantidad = cantidad;
        this.subtotal = subtotal;
    }

    // Constructor para nuevas entradas (sin ID, sin pedidoId al inicio) 
    public DetallePedido(int menuId, String nombreMenu, double precioUnitario, int cantidad) {
        this.menuId = menuId;
        this.nombreMenu = nombreMenu;
        this.precioUnitario = precioUnitario;
        this.cantidad = cantidad;
        this.subtotal = precioUnitario * cantidad;
    }

    
    // Este constructor recibe los 5 parámetros que el DAO está extrayendo de la base de datos
    public DetallePedido(int id, int pedidoId, int menuId, int cantidad, double precioUnitario) {
        this.id = id;
        this.pedidoId = pedidoId;
        this.menuId = menuId;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.subtotal = precioUnitario * cantidad;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPedidoId() {
        return pedidoId;
    }

    public void setPedidoId(int pedidoId) {
        this.pedidoId = pedidoId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getNombreMenu() {
        return nombreMenu;
    }

    public void setNombreMenu(String nombreMenu) {
        this.nombreMenu = nombreMenu;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    @Override
    public String toString() {
        return "DetallePedido{" +
               "id=" + id +
               ", pedidoId=" + pedidoId +
               ", menuId=" + menuId +
               ", nombreMenu='" + nombreMenu + '\'' +
               ", precioUnitario=" + precioUnitario +
               ", cantidad=" + cantidad +
               ", subtotal=" + subtotal +
               '}';
    }
}