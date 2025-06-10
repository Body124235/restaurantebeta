package modelo;

import java.time.LocalDate;
import java.time.LocalTime;

public class Reserva {
    private int id;
    private int usuarioId;
    private LocalDate fechaReserva;
    private LocalTime horaReserva;
    private int numPersonas;
    private String estado;

    // Constructor para cuando se crea una nueva reserva (sin ID, ya que la BD la generará)
    public Reserva(int usuarioId, LocalDate fechaReserva, LocalTime horaReserva, int numPersonas, String estado) {
        this.usuarioId = usuarioId;
        this.fechaReserva = fechaReserva;
        this.horaReserva = horaReserva;
        this.numPersonas = numPersonas;
        this.estado = estado;
    }

    // Constructor para cuando se recupera una reserva de la base de datos (con ID)
    public Reserva(int id, int usuarioId, LocalDate fechaReserva, LocalTime horaReserva, int numPersonas, String estado) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.fechaReserva = fechaReserva;
        this.horaReserva = horaReserva;
        this.numPersonas = numPersonas;
        this.estado = estado;
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

    public LocalDate getFechaReserva() {
        return fechaReserva;
    }

    public void setFechaReserva(LocalDate fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public LocalTime getHoraReserva() {
        return horaReserva;
    }

    public void setHoraReserva(LocalTime horaReserva) {
        this.horaReserva = horaReserva;
    }

    public int getNumPersonas() {
        return numPersonas;
    }

    public void setNumPersonas(int numPersonas) {
        this.numPersonas = numPersonas;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}