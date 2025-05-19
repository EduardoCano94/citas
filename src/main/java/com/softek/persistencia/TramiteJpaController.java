package com.softek.persistencia;

import com.softek.logica.Tramite;
import com.softek.logica.Turno;
import com.softek.persistencia.exceptions.NonexistentEntityException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.*;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

public class TramiteJpaController implements Serializable {

    private EntityManagerFactory emf = null;

    public TramiteJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public TramiteJpaController() {
        emf = Persistence.createEntityManagerFactory("pruebatec2PU");
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Tramite tramite) {
        if (tramite.getTurnos() == null) {
            tramite.setTurnos(new ArrayList<>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            List<Turno> attachedTurnos = new ArrayList<>();
            for (Turno turnosTurnoToAttach : tramite.getTurnos()) {
                turnosTurnoToAttach = em.getReference(turnosTurnoToAttach.getClass(), turnosTurnoToAttach.getId());
                attachedTurnos.add(turnosTurnoToAttach);
            }
            tramite.setTurnos(attachedTurnos);
            em.persist(tramite);
            for (Turno turnosTurno : tramite.getTurnos()) {
                Tramite oldElTramiteOfTurnosTurno = turnosTurno.getElTramite();
                turnosTurno.setElTramite(tramite);
                turnosTurno = em.merge(turnosTurno);
                if (oldElTramiteOfTurnosTurno != null) {
                    oldElTramiteOfTurnosTurno.getTurnos().remove(turnosTurno);
                    em.merge(oldElTramiteOfTurnosTurno);
                }
            }
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Tramite tramite) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Tramite persistentTramite = em.find(Tramite.class, tramite.getId());
            List<Turno> turnosOld = persistentTramite.getTurnos();
            List<Turno> turnosNew = tramite.getTurnos();
            List<Turno> attachedTurnosNew = new ArrayList<>();
            for (Turno turnosNewTurnoToAttach : turnosNew) {
                turnosNewTurnoToAttach = em.getReference(turnosNewTurnoToAttach.getClass(), turnosNewTurnoToAttach.getId());
                attachedTurnosNew.add(turnosNewTurnoToAttach);
            }
            turnosNew = attachedTurnosNew;
            tramite.setTurnos(turnosNew);
            tramite = em.merge(tramite);
            for (Turno turnosOldTurno : turnosOld) {
                if (!turnosNew.contains(turnosOldTurno)) {
                    turnosOldTurno.setElTramite(null);
                    em.merge(turnosOldTurno);
                }
            }
            for (Turno turnosNewTurno : turnosNew) {
                if (!turnosOld.contains(turnosNewTurno)) {
                    Tramite oldElTramiteOfTurnosNewTurno = turnosNewTurno.getElTramite();
                    turnosNewTurno.setElTramite(tramite);
                    turnosNewTurno = em.merge(turnosNewTurno);
                    if (oldElTramiteOfTurnosNewTurno != null && !oldElTramiteOfTurnosNewTurno.equals(tramite)) {
                        oldElTramiteOfTurnosNewTurno.getTurnos().remove(turnosNewTurno);
                        em.merge(oldElTramiteOfTurnosNewTurno);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                long id = tramite.getId();
                if (findTramite(id) == null) {
                    throw new NonexistentEntityException("The tramite with id " + id + " no longer exists.");
                }
            }
            throw ex;
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
            Tramite tramite;
            try {
                tramite = em.getReference(Tramite.class, id);
                tramite.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The tramite with id " + id + " no longer exists.", enfe);
            }
            for (Turno turnosTurno : tramite.getTurnos()) {
                turnosTurno.setElTramite(null);
                em.merge(turnosTurno);
            }
            em.remove(tramite);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Tramite> findTramiteEntities() {
        return findTramiteEntities(true, -1, -1);
    }

    public List<Tramite> findTramiteEntities(int maxResults, int firstResult) {
        return findTramiteEntities(false, maxResults, firstResult);
    }

    private List<Tramite> findTramiteEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Tramite> cq = em.getCriteriaBuilder().createQuery(Tramite.class);
            cq.select(cq.from(Tramite.class));
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

    public Tramite findTramite(long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Tramite.class, id);
        } finally {
            em.close();
        }
    }

    public int getTramiteCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<Tramite> rt = cq.from(Tramite.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }

    public Tramite findTramiteByName(String nombre) {
        EntityManager em = getEntityManager();
        try {
            String consulta = "SELECT tramite FROM Tramite tramite WHERE tramite.nombre = :nombre";
            Query query = em.createQuery(consulta);
            query.setParameter("nombre", nombre);
            return (Tramite) query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<Tramite> findAllTramites() {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT tramite FROM Tramite tramite", Tramite.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
