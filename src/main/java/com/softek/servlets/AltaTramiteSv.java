package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Tramite;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.persistence.PersistenceException;
import java.io.IOException;

@WebServlet(name = "AltaTramiteSv", urlPatterns = {"/AltaTramiteSv"})
public class AltaTramiteSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");

        Tramite tramite = new Tramite();
        tramite.setNombre(nombre);
        tramite.setDescripcion(descripcion);

        try {
            control.crearTramite(tramite);
            response.sendRedirect("index.jsp?mens=Tramite creado exitosamente!");
        } catch (PersistenceException e) {
            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause.getMessage() != null && cause.getMessage().contains("Duplicate entry")) {
                    response.sendRedirect("altaTramite.jsp?mens=El nombre del tramite ya esta registrado.");
                    return;
                }
                cause = cause.getCause();
            }
            response.sendRedirect("altaTramite.jsp?mens=Error al crear el tramite. Intentalo más tarde.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para alta de tramites";
    }
}
