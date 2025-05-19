<%@page import="com.softek.logica.Turno.EstadoTurno"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.softek.logica.Turno" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Listar Turnos</title>
        <style>
            :root {
                --primary-color: #006400;
                --secondary-color: #00cc66;
                --dark-color: #2c3e50;
                --light-color: #f8f9fa;
                --success-color: #28a745;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
                --info-color: #17a2b8;
            }
            
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: #333;
                line-height: 1.6;
                padding: 20px;
                min-height: 100vh;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 30px;
                animation: fadeIn 0.5s ease-in-out;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(-20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            h1 {
                text-align: center;
                color: var(--dark-color);
                margin-bottom: 15px;
                font-size: 2.2rem;
            }
            
            h2 {
                text-align: center;
                color: #555;
                margin-bottom: 25px;
                font-size: 1.5rem;
                font-weight: normal;
            }
            
            .alert {
                text-align: center;
                padding: 12px;
                margin-bottom: 20px;
                border-radius: 5px;
                background-color: #e0f7ff;
                color: #006699;
                border: 1px solid #3399cc;
                font-weight: bold;
            }
            
            .button-group {
                display: flex;
                justify-content: center;
                gap: 15px;
                margin-bottom: 30px;
            }
            
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }
            
            .btn-primary {
                background-color: var(--dark-color);
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #1a5276;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            
            .table-container {
                overflow-x: auto;
                margin-bottom: 30px;
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 25px 0;
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
            }
            
            th {
                background-color: var(--dark-color);
                color: white;
                padding: 12px;
                text-align: left;
                position: sticky;
                top: 0;
            }
            
            td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
            }
            
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            
            tr:hover {
                background-color: #f1f1f1;
            }
            
            .status-en-espera {
                color: var(--warning-color);
                font-weight: 500;
            }
            
            .status-atendido {
                color: var(--success-color);
                font-weight: 500;
            }
            
            .action-link {
                color: var(--dark-color);
                text-decoration: none;
                margin-right: 10px;
                transition: color 0.3s;
            }
            
            .action-link:hover {
                color: var(--secondary-color);
                text-decoration: underline;
            }
            
            .action-link.delete {
                color: var(--danger-color);
            }
            
            .action-link.delete:hover {
                color: #c82333;
            }
            
            .empty-message {
                text-align: center;
                padding: 20px;
                font-size: 1.1rem;
                color: #666;
            }
            
            @media (max-width: 768px) {
                .container {
                    padding: 20px;
                }
                
                .button-group {
                    flex-direction: column;
                    align-items: center;
                }
                
                .btn {
                    width: 100%;
                    margin-bottom: 10px;
                }
                
                th, td {
                    padding: 8px;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>
    <body>
        <%
            HttpSession miSesion = request.getSession(false);
            String login;
            if (miSesion.getAttribute("email") != null) {
                login = (String) miSesion.getAttribute("email");
                String mensaje = request.getParameter("mens");
        %>
        <div class="container">
            <h1>Bienvenido <%= login%></h1>
            <% if (mensaje != null) {%>
            <div class="alert"><%= mensaje%></div>
            <% } else { %>
            <h2>Listado de Turnos</h2>
            <% } %>

            <div class="button-group">
                <form action="MenuSv" method="POST">
                    <button type="submit" name="action" value="logout" class="btn btn-primary">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST">
                    <button type="submit" name="menuAction" value="menu" class="btn btn-primary">Menú Principal</button>
                </form>
            </div>

            <div class="table-container">
                <%
                    List<Turno> listaTurnos = (List<Turno>) session.getAttribute("listaTurnos");
                    if (listaTurnos != null && !listaTurnos.isEmpty()) {
                %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ciudadano</th>
                            <th>Trámite</th>
                            <th>Fecha</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Turno turno : listaTurnos) { 
                            String estadoClass = turno.getEstado() == EstadoTurno.EN_ESPERA ? "status-en-espera" : "status-atendido";
                        %>
                        <tr>
                            <td><%= turno.getId()%></td>
                            <td><%= turno.getElCiudadano().getNombre() + " " + turno.getElCiudadano().getApellido() %></td>
                            <td>
                                <strong><%= turno.getElTramite().getNombre() %></strong><br>
                                <small><%= turno.getElTramite().getDescripcion() %></small>
                            </td>
                            <td><%= turno.getFecha()%></td>
                            <td class="<%= estadoClass %>"><%= turno.getEstado()%></td>
                            <td>
                                <a href="EditarTurnoSv?id=<%= turno.getId()%>" class="action-link">Editar</a>
                                <a href="GestorTurnosSv?action=baja&id=<%= turno.getId()%>" class="action-link delete">Eliminar</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <p class="empty-message">No hay turnos disponibles</p>
                <% } %>
            </div>
        </div>
        <% } else {
                response.sendRedirect("login.jsp?mens=Primero Inicia Sesion!");
            }
        %>
    </body>
</html>