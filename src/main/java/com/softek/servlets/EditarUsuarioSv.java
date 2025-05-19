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

@WebServlet(name = "EditarUsuarioSv", urlPatterns = {"/EditarUsuarioSv"})
public class EditarUsuarioSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        Usuario usuario = control.buscaUsuario(email);
        HttpSession miSesion = request.getSession();
        if (usuario != null) {
            miSesion.setAttribute("usuario", usuario);
            response.sendRedirect("editarUsuario.jsp?mens=Usuario encontrado!"); 
        } else {
            response.sendRedirect("editarUsuario.jsp?mens=Usuario no encontrado!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");
        String id = request.getParameter("id");
        Usuario usuario = new Usuario();
        
        usuario.setId(Long.parseLong(id));
        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setEmail(email);
        usuario.setPassword(password);
        
        if (password.equals(password2)) {
            control.modificarUsuario(usuario);
            HttpSession miSesion = request.getSession(false);
            miSesion.removeAttribute("usuario");
            response.sendRedirect("index.jsp?mens=Usuario Modificado Exitosamente!");
        } else {
            response.sendRedirect("editarUsuario.jsp?mens=La Contrasenia no Coincide. Intenta Nuevamente!");
        }
    }


    @Override
    public String getServletInfo() {
        return "Servlet para gestionar la eliminacion de usuarios.";
    }
}
