package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BajaUsuarioSv", urlPatterns = {"/BajaUsuarioSv"})
public class BajaUsuarioSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        Usuario usuario = control.buscaUsuario(email);
        HttpSession miSesion = request.getSession();
        if (usuario != null) {
            miSesion.setAttribute("usuario", usuario);
            response.sendRedirect("bajaUsuario.jsp?mens=Usuario encontrado!"); 
        } else {
            response.sendRedirect("bajaUsuario.jsp?mens=Usuario no encontrado!");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

            String idString = request.getParameter("id");
            long id = Long.parseLong(idString);
            control.eliminaUsuario(id);            
            response.sendRedirect("index.jsp?mens=Usuario eliminado con Exito!");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la eliminación de usuarios.";
    }
}
