package com.softek.servlets;

import com.softek.logica.Ciudadano;
import com.softek.logica.ControladoraLogica;
import com.softek.logica.Tramite;
import com.softek.logica.Turno;
import com.softek.logica.Turno.EstadoTurno;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditarTurnoSv", urlPatterns = {"/EditarTurnoSv"})
public class EditarTurnoSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

            request.getSession().setAttribute("turno", turno);
            cargarListasParaTurno(request.getSession());
            request.getRequestDispatcher("editarTurno.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno invalido.");
        }
    }

    private void cargarListasParaTurno(HttpSession session) {
        List<Ciudadano> listaCiudadanos = control.traerTodosLosCiudadanos();
        List<Tramite> listaTramites = control.traerTodosLosTramites();
        session.setAttribute("listaCiudadanos", listaCiudadanos);
        session.setAttribute("listaTramites", listaTramites);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            String estado = request.getParameter("estado");
            estado = estado.toUpperCase().replace(" ", "_"); 
            Ciudadano ciudadano = control.buscarCiudadano(ciudadanoClave);
            Tramite tramite = control.buscarTramitePorId(Long.parseLong(tramiteId));
            turno.setElCiudadano(ciudadano);
            turno.setElTramite(tramite);
            turno.setFecha(LocalDate.parse(fecha)); 
            turno.setEstado(EstadoTurno.valueOf(estado)); 

            try {
                control.modificarTurno(turno);
                response.sendRedirect("GestorTurnosSv?action=listarTodos");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("index.jsp?mens=Error al guardar el turno.");
            }
            response.sendRedirect("GestorTurnosSv?action=listarTodos");

        } catch (NumberFormatException e) {
            response.sendRedirect("index.jsp?mens=Error: ID de turno invalido.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?mens=Error al procesar la solicitud.");
        }
    }

}
