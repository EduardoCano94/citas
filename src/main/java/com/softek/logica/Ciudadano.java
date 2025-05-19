package com.softek.logica;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;

@Entity
public class Ciudadano implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false)
    private String nombre;

    @Column(nullable = false)
    private String apellido;

    @Column(nullable = false, unique = true)
    private String claveIdentificacion;

    @OneToMany(mappedBy = "elCiudadano", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Turno> turnos = new ArrayList<>();

    @Column(nullable = false)
    private boolean disponible;

    public Ciudadano() {
    }

    public Ciudadano(String nombre, String apellido, String claveIdentificacion, List<Turno> turnos, boolean disponible) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.claveIdentificacion = claveIdentificacion;
        this.turnos = turnos != null ? turnos : new ArrayList<>();
        this.disponible = disponible;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getClaveIdentificacion() {
        return claveIdentificacion;
    }

    public void setClaveIdentificacion(String claveIdentificacion) {
        this.claveIdentificacion = claveIdentificacion;
    }

    public List<Turno> getTurnos() {
        return turnos;
    }

    public void setTurnos(List<Turno> turnos) {
        this.turnos = turnos;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }
}
