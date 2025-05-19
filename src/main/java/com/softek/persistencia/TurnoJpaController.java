package com.softek.persistencia;

import com.softek.logica.Turno;
import com.softek.logica.Usuario;
import com.softek.logica.Tramite;
import com.softek.logica.Ciudadano;
import com.softek.logica.Turno.EstadoTurno;
import com.softek.persistencia.exceptions.NonexistentEntityException;

import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

public class TurnoJpaController implements Serializable {

    private final EntityManagerFactory emf;

    public TurnoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("pruebatec2PU");
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Turno turno) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            if (turno.getElUsuario() != null) {
                turno.setElUsuario(em.getReference(Usuario.class, turno.getElUsuario().getId()));
            }
            if (turno.getElTramite() != null) {
                turno.setElTramite(em.getReference(Tramite.class, turno.getElTramite().getId()));
            }
            if (turno.getElCiudadano() != null) {
                turno.setElCiudadano(em.getReference(Ciudadano.class, turno.getElCiudadano().getId()));
            }
            em.persist(turno);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Turno turno) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Turno persistentTurno = em.find(Turno.class, turno.getId());
            if (persistentTurno == null) {
                throw new NonexistentEntityException("The turno with id " + turno.getId() + " no longer exists.");
            }
            if (turno.getElUsuario() != null) {
                turno.setElUsuario(em.getReference(Usuario.class, turno.getElUsuario().getId()));
            }
            if (turno.getElTramite() != null) {
                turno.setElTramite(em.getReference(Tramite.class, turno.getElTramite().getId()));
            }
            if (turno.getElCiudadano() != null) {
                turno.setElCiudadano(em.getReference(Ciudadano.class, turno.getElCiudadano().getId()));
            }
            em.merge(turno);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(long id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Turno turno = em.find(Turno.class, id);
            if (turno == null) {
                throw new NonexistentEntityException("The turno with id " + id + " no longer exists.");
            }
            em.remove(turno);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Turno> findTurnoEntities() {
        return findTurnoEntities(true, -1, -1);
    }

    public List<Turno> findTurnoEntities(int maxResults, int firstResult) {
        return findTurnoEntities(false, maxResults, firstResult);
    }

    private List<Turno> findTurnoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Turno> cq = em.getCriteriaBuilder().createQuery(Turno.class);
            cq.select(cq.from(Turno.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }

    public Turno findTurno(long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Turno.class, id);
        } finally {
            em.close();
        }
    }

    public int getTurnoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<Turno> rt = cq.from(Turno.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public List<Turno> findTurnosByEstado(EstadoTurno estado) {
        if (estado == null) {
            throw new IllegalArgumentException("El estado no puede ser nulo.");
        }
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT t FROM Turno t WHERE t.estado = :estado", Turno.class);
            query.setParameter("estado", estado);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
