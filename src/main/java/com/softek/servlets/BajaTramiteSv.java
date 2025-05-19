package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Tramite;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BajaTramiteSv", urlPatterns = {"/BajaTramiteSv"})
public class BajaTramiteSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        Tramite tramite = control.buscaTramite(nombre);
        HttpSession miSesion = request.getSession();
        if (tramite != null) {
            miSesion.setAttribute("tramite", tramite);
            response.sendRedirect("bajaTramite.jsp?mens=Tramite encontrado!"); 
        } else {
            response.sendRedirect("bajaTramite.jsp?mens=Tramite no encontrado!");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            String idString = request.getParameter("id");
            long id = Long.parseLong(idString);
            control.eliminaTramite(id);            
            response.sendRedirect("index.jsp?mens=Tramite eliminado con Exito!");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la eliminación de Tramites.";
    }
}
