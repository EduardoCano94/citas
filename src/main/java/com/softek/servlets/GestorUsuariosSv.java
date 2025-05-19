package com.softek.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GestorUsuariosSv", urlPatterns = {"/GestorUsuariosSv"})
public class GestorUsuariosSv extends HttpServlet {
    

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "alta":
                response.sendRedirect("altaUsuario.jsp");
                break;
            case "editar":
                response.sendRedirect("editarUsuario.jsp");
                break;
            case "buscar":
                response.sendRedirect("buscarUsuario.jsp");
                break;
            case "baja":
                response.sendRedirect("bajaUsuario.jsp");
                break;
            default:
                response.sendRedirect("index.jsp?mens=Error Intenta Nuevamente");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
