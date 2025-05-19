package com.softek.servlets;

import com.softek.logica.Ciudadano;
import com.softek.logica.ControladoraLogica;
import com.softek.logica.Tramite;
import com.softek.logica.Turno;
import com.softek.logica.Usuario;
import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AltaTurnoSv", urlPatterns = {"/AltaTurnoSv"})
public class AltaTurnoSv extends HttpServlet {

    private ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession miSesion = request.getSession(false);

        String usuarioEmail = (String) miSesion.getAttribute("email");
        String claveIdentificacion = request.getParameter("ciudadano");
        Long tramiteId = Long.parseLong(request.getParameter("tramite"));
        LocalDate fecha = LocalDate.parse(request.getParameter("fecha"));

        Usuario usuario = control.buscaUsuario(usuarioEmail);
        Ciudadano ciudadano = control.buscarCiudadano(claveIdentificacion);
        Tramite tramite = control.buscarTramitePorId(tramiteId);

        if (usuario != null && ciudadano != null && tramite != null) {
            Turno turno = new Turno(fecha, "Turno creado", usuario, tramite, ciudadano, Turno.EstadoTurno.EN_ESPERA);
            control.crearTurno(turno);
            response.sendRedirect("index.jsp?mens=Turno creado exitosamente!");
        } else {
            response.sendRedirect("altaTurno.jsp?mens=Error al crear el turno. Verifica los datos.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Alta de Turnos";
    }
}
