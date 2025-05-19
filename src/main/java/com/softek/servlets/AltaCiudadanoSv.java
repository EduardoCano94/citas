package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Ciudadano;
import javax.persistence.PersistenceException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AltaCiudadanoSv", urlPatterns = {"/AltaCiudadanoSv"})
public class AltaCiudadanoSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String claveIdentificacion = request.getParameter("claveIdentificacion");

        Ciudadano ciudadano = new Ciudadano(nombre, apellido, claveIdentificacion, null, true);

        try {
            control.crearCiudadano(ciudadano);
            response.sendRedirect("index.jsp?mens=Ciudadano Creado Exitosamente!");
        } catch (PersistenceException e) {
            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause.getMessage() != null && cause.getMessage().contains("Duplicate entry")) {
                    response.sendRedirect("altaCiudadano.jsp?mens=La clave de identificacion ya esta registrada.");
                    return;
                }
                cause = cause.getCause();
            }
            response.sendRedirect("altaCiudadano.jsp?mens=Error al crear el ciudadano. Intentalo mas tarde.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para dar de alta un nuevo Ciudadano";
    }
}
