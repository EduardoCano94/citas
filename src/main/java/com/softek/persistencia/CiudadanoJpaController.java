package com.softek.persistencia;

import com.softek.logica.Ciudadano;
import com.softek.persistencia.exceptions.NonexistentEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;
import javax.persistence.NoResultException;
import javax.persistence.Query;
import javax.persistence.Persistence;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

public class CiudadanoJpaController implements Serializable {

    private EntityManagerFactory emf = null;

    public CiudadanoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    public CiudadanoJpaController() {
        emf = Persistence.createEntityManagerFactory("pruebatec2PU");
    }

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Ciudadano ciudadano) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(ciudadano);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Ciudadano ciudadano) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            ciudadano = em.merge(ciudadano);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                long id = ciudadano.getId();
                if (findCiudadano(id) == null) {
                    throw new NonexistentEntityException("The ciudadano with id " + id + " no longer exists.");
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
            Ciudadano ciudadano;
            try {
                ciudadano = em.getReference(Ciudadano.class, id);
                ciudadano.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The ciudadano with id " + id + " no longer exists.", enfe);
            }
            em.remove(ciudadano);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public Ciudadano findCiudadano(long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Ciudadano.class, id);
        } finally {
            em.close();
        }
    }

    public Ciudadano findCiudadanoByClaveIdentificacion(String claveIdentificacion) {
        EntityManager em = getEntityManager();
        try {
            String consulta = "SELECT c FROM Ciudadano c WHERE c.claveIdentificacion = :claveIdentificacion";
            Query query = em.createQuery(consulta);
            query.setParameter("claveIdentificacion", claveIdentificacion);
            return (Ciudadano) query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<Ciudadano> findAllCiudadanos() {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Ciudadano c", Ciudadano.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Ciudadano> findCiudadanoEntities() {
        return findCiudadanoEntities(true, -1, -1);
    }

    public List<Ciudadano> findCiudadanoEntities(int maxResults, int firstResult) {
        return findCiudadanoEntities(false, maxResults, firstResult);
    }

    private List<Ciudadano> findCiudadanoEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Ciudadano> cq = em.getCriteriaBuilder().createQuery(Ciudadano.class);
            cq.select(cq.from(Ciudadano.class));
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

    public int getCiudadanoCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery<Long> cq = em.getCriteriaBuilder().createQuery(Long.class);
            Root<Ciudadano> rt = cq.from(Ciudadano.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
}
