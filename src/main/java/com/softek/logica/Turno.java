package com.softek.logica;

import java.io.Serializable;
import java.time.LocalDate;
import javax.persistence.*;

@Entity
public class Turno implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false)
    private String descripcion;

    @ManyToOne(optional = false)
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario elUsuario;

    @ManyToOne(optional = false)
    @JoinColumn(name = "tramite_id", nullable = false)
    private Tramite elTramite;

    @ManyToOne(optional = false)
    @JoinColumn(name = "ciudadano_id", nullable = false)
    private Ciudadano elCiudadano;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private EstadoTurno estado;

    @Column(nullable = false)
    private boolean disponible;

    public Turno() {
    }

    public Turno(LocalDate fecha, String descripcion, Usuario elUsuario, Tramite elTramite, Ciudadano elCiudadano, EstadoTurno estado) {
        this.fecha = fecha;
        this.descripcion = descripcion;
        this.elUsuario = elUsuario;
        this.elTramite = elTramite;
        this.elCiudadano = elCiudadano;
        this.estado = estado;
        this.disponible = true;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Usuario getElUsuario() {
        return elUsuario;
    }

    public void setElUsuario(Usuario elUsuario) {
        this.elUsuario = elUsuario;
    }

    public Tramite getElTramite() {
        return elTramite;
    }

    public void setElTramite(Tramite elTramite) {
        this.elTramite = elTramite;
    }

    public Ciudadano getElCiudadano() {
        return elCiudadano;
    }

    public void setElCiudadano(Ciudadano elCiudadano) {
        this.elCiudadano = elCiudadano;
    }

    public EstadoTurno getEstado() {
        return estado;
    }

    public void setEstado(EstadoTurno estado) {
        this.estado = estado;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    public enum EstadoTurno {   //Use enums porque permiten manejar valores fijos de forma segura y legible.
        EN_ESPERA,
        YA_ATENDIDO
    }
}
