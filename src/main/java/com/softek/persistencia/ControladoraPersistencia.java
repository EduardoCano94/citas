package com.softek.persistencia;

import com.softek.logica.Turno;
import com.softek.logica.Usuario;
import com.softek.logica.Tramite;
import com.softek.logica.Ciudadano;
import com.softek.persistencia.exceptions.NonexistentEntityException;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;

public class ControladoraPersistencia {

    private EntityManagerFactory emf;

    public ControladoraPersistencia() {
        this.emf = Persistence.createEntityManagerFactory("pruebatec2PU");
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    UsuarioJpaController usuarioJpa = new UsuarioJpaController();
    TramiteJpaController tramiteJpa = new TramiteJpaController();
    CiudadanoJpaController ciudadanoJpa = new CiudadanoJpaController();
    TurnoJpaController turnoJpa = new TurnoJpaController();

    public void crearUsuario(Usuario usuario) {
        usuarioJpa.create(usuario);
    }

    public Usuario buscarUsuario(String email) {
        return usuarioJpa.findUserByEmail(email);
    }

    public void eliminarUsuario(long id) throws NonexistentEntityException {
        usuarioJpa.destroy(id);
    }

    public List<Usuario> traerUsuarios() {
        return usuarioJpa.findAllUsuarios();
    }

    public void modificarUsuario(Usuario usuario) throws Exception {
        usuarioJpa.edit(usuario);
    }

    public void crearTramite(Tramite tramite) {
        tramiteJpa.create(tramite);
    }

    public Tramite buscarTramite(String nombre) {
        return tramiteJpa.findTramiteByName(nombre);
    }

    public Tramite buscarTramitePorId(long id) {
        return tramiteJpa.findTramite(id);
    }

    public List<Tramite> traerTramites() {
        return tramiteJpa.findAllTramites();
    }

    public void eliminarTramite(long id) throws NonexistentEntityException {
        tramiteJpa.destroy(id);
    }

    public void modificarTramite(Tramite tramite) {
        try {
            tramiteJpa.edit(tramite);
        } catch (Exception ex) {
            Logger.getLogger(ControladoraPersistencia.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void crearCiudadano(Ciudadano ciudadano) {
        ciudadanoJpa.create(ciudadano);
    }

    public Ciudadano buscarCiudadano(String claveIdentificacion) {
        return ciudadanoJpa.findCiudadanoByClaveIdentificacion(claveIdentificacion);
    }

    public Ciudadano buscarCiudadanoPorId(long id) {
        return ciudadanoJpa.findCiudadano(id);
    }

    public List<Ciudadano> traerCiudadanos() {
        return ciudadanoJpa.findAllCiudadanos();
    }

    public void eliminarCiudadano(long id) throws NonexistentEntityException {
        ciudadanoJpa.destroy(id);
    }

    public void modificarCiudadano(Ciudadano ciudadano) {
        try {
            ciudadanoJpa.edit(ciudadano);
        } catch (Exception ex) {
            Logger.getLogger(ControladoraPersistencia.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void crearTurno(Turno turno) {
        turnoJpa.create(turno);
    }

    public Turno buscarTurnoPorId(long id) {
        return turnoJpa.findTurno(id);
    }

    public List<Turno> findTurnoEntities() {
        return turnoJpa.findTurnoEntities();
    }

    public void modificarTurno(Turno turno) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Turno existingTurno = em.find(Turno.class, turno.getId());

            if (existingTurno == null) {
                throw new NonexistentEntityException("El turno con ID: " + turno.getId() + " no existe.");
            }

            existingTurno.setElUsuario(turno.getElUsuario());
            existingTurno.setElTramite(turno.getElTramite());
            existingTurno.setElCiudadano(turno.getElCiudadano());
            existingTurno.setFecha(turno.getFecha());
            existingTurno.setEstado(turno.getEstado());

            em.merge(existingTurno);
            em.getTransaction().commit();
        } catch (Exception ex) {
            handleException(ex);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void eliminarTurno(long id) throws NonexistentEntityException {
        EntityManager em = getEntityManager();
        try {
            Turno turno = em.find(Turno.class, id);
            if (turno == null) {
                throw new NonexistentEntityException("El turno con ID " + id + " no existe.");
            }
            em.getTransaction().begin();
            em.remove(turno);
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            em.close();
        }
    }

    public void marcarTurnoAtendido(long id) {
        Turno turno = turnoJpa.findTurno(id);
        if (turno != null) {
            turno.setEstado(Turno.EstadoTurno.YA_ATENDIDO);
            modificarTurno(turno);
        }
    }

    public void regresarTurnoEspera(long id) {
        Turno turno = turnoJpa.findTurno(id);
        if (turno != null) {
            turno.setEstado(Turno.EstadoTurno.EN_ESPERA);
            modificarTurno(turno);
        }
    }

    public List<Turno> traerTurnosPorEstado(Turno.EstadoTurno estadoEnum, int maxResults) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT t FROM Turno t WHERE t.estado = :estado", Turno.class);
            query.setParameter("estado", estadoEnum);
            query.setMaxResults(maxResults);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    private void handleException(Exception ex) {
        ex.printStackTrace();
    }
}
