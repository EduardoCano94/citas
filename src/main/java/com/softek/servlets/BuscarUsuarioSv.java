package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BuscarUsuarioSv", urlPatterns = {"/BuscarUsuarioSv"})
public class BuscarUsuarioSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        Usuario usuario = control.buscaUsuario(email);
        HttpSession miSesion = request.getSession();
        if (usuario != null) {
            miSesion.setAttribute("usuario", usuario);
            response.sendRedirect("buscarUsuario.jsp?mens=Usuario encontrado!");
            miSesion.removeAttribute("ocultar");
        } else {
            response.sendRedirect("buscarUsuario.jsp?mens=Usuario no encontrado!");
            miSesion.removeAttribute("ocultar");
        }
    }

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        List<Usuario> usuarios = control.traerTodosLosUsuarios();

        HttpSession miSesion = request.getSession();
        miSesion.setAttribute("listaUsuarios", usuarios);
        miSesion.setAttribute("mens", "Lista de todos los Usuarios");
        miSesion.setAttribute("ocultar", "ocultar");
        response.sendRedirect("buscarUsuario.jsp?mens=Lista de todos los Usuarios");
    
}

    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la eliminacion de usuarios.";
    }
}
