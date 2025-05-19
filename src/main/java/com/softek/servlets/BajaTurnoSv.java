package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "BajaTurnoSv", urlPatterns = {"/BajaTurnoSv"})
public class BajaTurnoSv extends HttpServlet {

    ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String turnoIdParam = request.getParameter("turno");

        try {
            long turnoId = Long.parseLong(turnoIdParam);
            control.eliminarTurno(turnoId);
            response.sendRedirect("GestorTurnosSv?action=baja&mens=Turno eliminado exitosamente!");
        } catch (NumberFormatException e) {
            response.sendRedirect("GestorTurnosSv?action=baja&mens=Error: ID de turno invalido.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para eliminar un turno.";
    }
}
