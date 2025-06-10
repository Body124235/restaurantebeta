package modelo;

import java.time.Month; 

public class ReservaMesEstadistica {
    private int anio;
    private int mes; 
    private long cantidadReservas;

    public ReservaMesEstadistica() {
    }

    public ReservaMesEstadistica(int anio, int mes, long cantidadReservas) {
        this.anio = anio;
        this.mes = mes;
        this.cantidadReservas = cantidadReservas;
    }

    // Getters y Setters
    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public int getMes() {
        return mes;
    }

    public void setMes(int mes) {
        this.mes = mes;
    }

    public long getCantidadReservas() {
        return cantidadReservas;
    }

    public void setCantidadReservas(long cantidadReservas) {
        this.cantidadReservas = cantidadReservas;
    }

    @Override
    public String toString() {
        return "ReservaMesEstadistica{" +
               "anio=" + anio +
               ", mes=" + mes +
               ", cantidadReservas=" + cantidadReservas +
               '}';
    }
}