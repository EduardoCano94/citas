package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Ciudadano;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BuscarCiudadanoSv", urlPatterns = {"/BuscarCiudadanoSv"})
public class BuscarCiudadanoSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String claveIdentificacion = request.getParameter("claveIdentificacion");
        Ciudadano ciudadano = control.buscarCiudadano(claveIdentificacion);
        HttpSession miSesion = request.getSession();
        if (ciudadano != null) {
            miSesion.setAttribute("ciudadano", ciudadano);
            response.sendRedirect("buscarCiudadano.jsp?mens=Ciudadano encontrado!");
            miSesion.removeAttribute("ocultar");
        } else {
            response.sendRedirect("buscarCiudadano.jsp?mens=Ciudadano no encontrado!");
            miSesion.removeAttribute("ocultar");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        List<Ciudadano> ciudadanos = control.traerTodosLosCiudadanos();

        HttpSession miSesion = request.getSession();
        miSesion.setAttribute("listaCiudadanos", ciudadanos);
        miSesion.setAttribute("mens", "Lista de todos los Ciudadanos");
        miSesion.setAttribute("ocultar", "ocultar");
        response.sendRedirect("buscarCiudadano.jsp?mens=Lista de todos los Ciudadanos");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la búsqueda y listado de ciudadanos.";
    }
}
