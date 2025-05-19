package com.softek.servlets;

import com.softek.logica.ControladoraLogica;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginSv", urlPatterns = {"/LoginSv"})
public class LoginSv extends HttpServlet {

    ControladoraLogica control = new ControladoraLogica();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean autorizado = control.validarAcceso(email, password);

        if (autorizado) {
            HttpSession miSesion = request.getSession();
            miSesion.setAttribute("email", email);

            

            response.sendRedirect("index.jsp");
        } else {
            response.sendRedirect("login.jsp?mens=Credenciales invalidas!");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet de inicio de sesion";
    }
}
