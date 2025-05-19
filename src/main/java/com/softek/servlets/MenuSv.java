package com.softek.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "MenuSv", urlPatterns = {"/MenuSv"})
public class MenuSv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession miSesion = request.getSession(false);

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            if (miSesion != null) {
                miSesion.removeAttribute("email");
                response.sendRedirect("login.jsp?mens=Sesion cerrada correctamente.");
            }
        }

        String menuAction = request.getParameter("menuAction");
        if ("menu".equals(menuAction)) {
            if (miSesion != null) {
                miSesion.removeAttribute("usuario");
                miSesion.removeAttribute("ocultar");
                miSesion.removeAttribute("listaUsuarios");
                miSesion.removeAttribute("listaTramites");
                miSesion.removeAttribute("listaCiudadanos");
                miSesion.removeAttribute("tramite");
                miSesion.removeAttribute("ciudadano");
                miSesion.removeAttribute("listaUsuarios");
            }
            response.sendRedirect("index.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para manejar la sesion y redirigir al menu principal o cerrar sesion.";
    }
}
