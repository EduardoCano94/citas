package com.softek.logica;

import com.softek.logica.Turno.EstadoTurno;
import com.softek.persistencia.ControladoraPersistencia;
import com.softek.persistencia.exceptions.NonexistentEntityException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ControladoraLogica {

    ControladoraPersistencia controlPersis = new ControladoraPersistencia();

    public boolean validarAcceso(String email, String password) {
        Usuario usu = controlPersis.buscarUsuario(email);
        if (usu != null && usu.getEmail().equals(email) && usu.getPassword().equals(password)) {
            return true;
        }
        return false;
    }

    public void crearUsuario(Usuario usuario) {
        controlPersis.crearUsuario(usuario);
    }

    public Usuario buscaUsuario(String email) {
        return controlPersis.buscarUsuario(email);
    }

    public void eliminaUsuario(long id) {
        try {
            controlPersis.eliminarUsuario(id);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(ControladoraLogica.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public List<Usuario> traerTodosLosUsuarios() {
        return controlPersis.traerUsuarios();
    }

    public void modificarUsuario(Usuario usuario) {
        try {
            controlPersis.modificarUsuario(usuario);
        } catch (Exception ex) {
            Logger.getLogger(ControladoraLogica.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void crearTramite(Tramite tramite) {
        controlPersis.crearTramite(tramite);
    }

    public void eliminaTramite(long id) {
        try {
            controlPersis.eliminarTramite(id);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(ControladoraLogica.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Tramite buscaTramite(String nombre) {
        return controlPersis.buscarTramite(nombre);
    }

    public Tramite buscarTramitePorId(long id) {
        return controlPersis.buscarTramitePorId(id);
    }

    public List<Tramite> traerTodosLosTramites() {
        return controlPersis.traerTramites();
    }

    public void modificarTramite(Tramite tramite) {
        controlPersis.modificarTramite(tramite);
    }

    public void crearCiudadano(Ciudadano ciudadano) {
        controlPersis.crearCiudadano(ciudadano);
    }

    public Ciudadano buscarCiudadano(String claveIdentificacion) {
        return controlPersis.buscarCiudadano(claveIdentificacion);
    }

    public Ciudadano buscarCiudadanoPorId(long id) {
        return controlPersis.buscarCiudadanoPorId(id);
    }

    public List<Ciudadano> traerTodosLosCiudadanos() {
        return controlPersis.traerCiudadanos();
    }

    public void eliminarCiudadano(long id) {
        try {
            controlPersis.eliminarCiudadano(id);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(ControladoraLogica.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void modificarCiudadano(Ciudadano ciudadano) {
        controlPersis.modificarCiudadano(ciudadano);
    }

    public void crearTurno(Turno turno) {
        controlPersis.crearTurno(turno);
    }

    public List<Turno> traerTodosLosTurnos() {
        return controlPersis.findTurnoEntities();
    }

    public Turno buscarTurnoPorId(long id) {
        return controlPersis.buscarTurnoPorId(id);
    }

    public void eliminarTurno(long id) {
        try {
            controlPersis.eliminarTurno(id);
        } catch (NonexistentEntityException ex) {
            Logger.getLogger(ControladoraLogica.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void modificarTurno(Turno turno) {
        controlPersis.modificarTurno(turno);
    }

    public List<Turno> traerTurnosPorEstado(String estado) {
        try {
            EstadoTurno estadoEnum = EstadoTurno.valueOf(estado.toUpperCase().replace(" ", "_"));
            return controlPersis.traerTurnosPorEstado(estadoEnum, 100); 
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Estado no válido: " + estado, e);
        }
    }

    public void marcarTurnoAtendido(long turnoId) {
        Turno turno = buscarTurnoPorId(turnoId);
        if (turno != null) {
            turno.setEstado(EstadoTurno.YA_ATENDIDO);
            controlPersis.modificarTurno(turno);
        }
    }

    public void regresarTurnoEspera(long turnoId) {
        Turno turno = buscarTurnoPorId(turnoId);
        if (turno != null) {
            turno.setEstado(EstadoTurno.EN_ESPERA);
            controlPersis.modificarTurno(turno);
        }
    }

}
