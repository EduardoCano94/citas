package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Ciudadano;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EditarCiudadanoSv", urlPatterns = {"/EditarCiudadanoSv"})
public class EditarCiudadanoSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String claveIdentificacion = request.getParameter("claveIdentificacion");
        Ciudadano ciudadano = control.buscarCiudadano(claveIdentificacion);
        HttpSession miSesion = request.getSession();
        if (ciudadano != null) {
            miSesion.setAttribute("ciudadano", ciudadano);
            response.sendRedirect("editarCiudadano.jsp?mens=Ciudadano encontrado!");
        } else {
            response.sendRedirect("editarCiudadano.jsp?mens=Ciudadano no encontrado!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String claveIdentificacion = request.getParameter("claveIdentificacion");
        String id = request.getParameter("id");
        Ciudadano ciudadano = new Ciudadano();
        
        ciudadano.setId(Long.parseLong(id));
        ciudadano.setNombre(nombre);
        ciudadano.setApellido(apellido);
        ciudadano.setClaveIdentificacion(claveIdentificacion);
        
        control.modificarCiudadano(ciudadano);
        HttpSession miSesion = request.getSession(false);
        miSesion.removeAttribute("ciudadano");
        response.sendRedirect("index.jsp?mens=Ciudadano Modificado Exitosamente!");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la edicion de ciudadanos.";
    }
}
