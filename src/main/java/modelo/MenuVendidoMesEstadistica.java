package modelo;

import java.time.Month; 
public class MenuVendidoMesEstadistica {
    private String mesAnio; 
    private int anio;       
    private int mes;        
    private String nombreMenu;
    private long cantidadVendida;

    // Constructor existente (que toma String mesAnio)
    public MenuVendidoMesEstadistica(String mesAnio, String nombreMenu, long cantidadVendida) {
        this.mesAnio = mesAnio;
        this.nombreMenu = nombreMenu;
        this.cantidadVendida = cantidadVendida;
       
    }

  
    // Este constructor recibe los 4 parámetros que el DAO está extrayendo de la base de datos
    public MenuVendidoMesEstadistica(int anio, int mes, String nombreMenu, long cantidadVendida) {
        this.anio = anio;
        this.mes = mes;
        this.nombreMenu = nombreMenu;
        this.cantidadVendida = cantidadVendida;
       
        this.mesAnio = Month.of(mes).name() + " " + anio; 
        
    }

    // Getters
    public String getMesAnio() {
        return mesAnio;
    }

    public int getAnio() { 
        return anio;
    }

    public int getMes() { 
        return mes;
    }

    public String getNombreMenu() {
        return nombreMenu;
    }

    public long getCantidadVendida() {
        return cantidadVendida;
    }

    // Setters
    public void setMesAnio(String mesAnio) {
        this.mesAnio = mesAnio;
    }

    public void setAnio(int anio) { 
        this.anio = anio;
    }

    public void setMes(int mes) {
        this.mes = mes;
    }

    public void setNombreMenu(String nombreMenu) {
        this.nombreMenu = nombreMenu;
    }

    public void setCantidadVendida(long cantidadVendida) {
        this.cantidadVendida = cantidadVendida;
    }

    @Override
    public String toString() {
        return "MenuVendidoMesEstadistica{" +
               "mesAnio='" + mesAnio + '\'' +
               ", anio=" + anio + 
               ", mes=" + mes +  
               ", nombreMenu='" + nombreMenu + '\'' +
               ", cantidadVendida=" + cantidadVendida +
               '}';
    }
}