package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import com.softek.logica.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.persistence.PersistenceException;
import java.io.IOException;

@WebServlet(name = "AltaUsuarioSv", urlPatterns = {"/AltaUsuarioSv"})
public class AltaUsuarioSv extends HttpServlet {

    private final ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        if (!password.equals(password2)) {
            response.sendRedirect("altaUsuario.jsp?mens=Las contrasenias no coinciden. Intentalo nuevamente.");
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setApellido(apellido);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setPassword(password);

        try {
            control.crearUsuario(nuevoUsuario);
            response.sendRedirect("index.jsp?mens=Usuario creado exitosamente.");
        } catch (PersistenceException e) {
            Throwable cause = e.getCause();
            while (cause != null) {
                if (cause.getMessage() != null && cause.getMessage().contains("Duplicate entry")) {
                    response.sendRedirect("altaUsuario.jsp?mens=El email ya está registrado.");
                    return;
                }
                cause = cause.getCause();
            }
            response.sendRedirect("altaUsuario.jsp?mens=Error al crear el usuario. Intentalo más tarde.");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para alta de usuarios";
    }
}
