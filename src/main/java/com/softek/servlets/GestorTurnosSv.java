package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Ciudadano;
import com.softek.logica.Tramite;
import com.softek.logica.Turno;
import com.softek.logica.Turno.EstadoTurno;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "GestorTurnosSv", urlPatterns = {"/GestorTurnosSv"})
public class GestorTurnosSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            switch (action) {
                case "alta":
                    cargarListasParaTurno(session);
                    request.getRequestDispatcher("altaTurno.jsp").forward(request, response);
                    break;

                case "listarTodos":
                    procesarListadoTurnos("todos", session, request, response);
                    break;

                case "listarEspera":
                    procesarListadoTurnos("en espera", session, request, response);
                    break;

                case "listarAtendidos":
                    procesarListadoTurnos("ya atendido", session, request, response);
                    break;

                case "editar":
                    procesarEdicionTurno(request, response, session);
                    break;

                case "borrar":
                    List<Turno> turnosBorrar = control.traerTodosLosTurnos();
                    session.setAttribute("listaTurnos", turnosBorrar);
                    response.sendRedirect("bajaTurno.jsp");
                    break;

                default:
                    response.sendRedirect("error.jsp");
                    break;
            }
        } catch (Exception e) {
            response.sendRedirect("error.jsp?mens=Error procesando la solicitud.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("listarTodos".equals(action)) {
                List<Turno> turnos = control.traerTodosLosTurnos();
                session.setAttribute("listaTurnos", turnos);
                request.getRequestDispatcher("listarTurnos.jsp").forward(request, response);
            } else if ("baja".equals(action)) {
                String idParam = request.getParameter("id");
                eliminarTurno(idParam, response, session);
            } else {
                response.sendRedirect("error.jsp?mens=Acción no válida en GestorTurnosSv.");
            }
        } catch (Exception e) {
            response.sendRedirect("error.jsp?mens=Error procesando la solicitud.");
        }
    }
    
    //uso de programacion funcional con lambdas y streams para dar formato a los estados en la lista al formato de los ENUMS
    private void procesarListadoTurnos(String estado, HttpSession session, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Turno> turnos = control.traerTodosLosTurnos();

        if (!"todos".equals(estado)) { 
            turnos = turnos.stream() 
                    .filter(turno -> turno.getEstado().toString().equalsIgnoreCase(estado.replace(" ", "_")))
                    .collect(Collectors.toList());
        }

        session.setAttribute("listaTurnos", turnos);
        request.getRequestDispatcher("listarTurnos.jsp").forward(request, response);
    }

    private void procesarEdicionTurno(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno no proporcionado.");
            return;
        }

        try {
            long turnoId = Long.parseLong(idParam);
            Turno turno = control.buscarTurnoPorId(turnoId);

            if (turno == null) {
                response.sendRedirect("index.jsp?mens=Error: Turno no encontrado.");
                return;
            }

            String ciudadanoClave = request.getParameter("ciudadano");
            String tramiteId = request.getParameter("tramite");
            String fecha = request.getParameter("fecha");
            String estado = request.getParameter("estado").toUpperCase().replace(" ", "_");

            Ciudadano ciudadano = control.buscarCiudadano(ciudadanoClave);
            Tramite tramite = control.buscarTramitePorId(Long.parseLong(tramiteId));
            turno.setElCiudadano(ciudadano);
            turno.setElTramite(tramite);
            turno.setFecha(LocalDate.parse(fecha));
            turno.setEstado(EstadoTurno.valueOf(estado));

            control.modificarTurno(turno);

            List<Turno> turnosActualizados = control.traerTodosLosTurnos();
            session.setAttribute("listaTurnos", turnosActualizados);

            response.sendRedirect("GestorTurnosSv?action=listarTodos");
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno invalido.");
        } catch (Exception e) {
            response.sendRedirect("index.jsp?mens=Error al procesar la solicitud.");
        }
    }

    private void eliminarTurno(String idParam, HttpServletResponse response, HttpSession session) throws IOException {
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno no proporcionado.");
            return;
        }

        try {
            long turnoId = Long.parseLong(idParam);
            control.eliminarTurno(turnoId);

            List<Turno> turnosActualizados = control.traerTodosLosTurnos();
            session.setAttribute("listaTurnos", turnosActualizados);

            response.sendRedirect("GestorTurnosSv?action=listarTodos");
        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno invalido.");
        } catch (Exception e) {
            response.sendRedirect("index.jsp?mens=Error al eliminar el turno.");
        }
    }

    private void cargarListasParaTurno(HttpSession session) {
        List<Ciudadano> listaCiudadanos = control.traerTodosLosCiudadanos();
        List<Tramite> listaTramites = control.traerTodosLosTramites();
        session.setAttribute("listaCiudadanos", listaCiudadanos);
        session.setAttribute("listaTramites", listaTramites);
    }

    @Override
    public String getServletInfo() {
        return "Redirecciona a las paginas de gestion de turnos.";
    }
}
