<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.softek.logica.Ciudadano" %>
<%@ page import="com.softek.logica.Tramite" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Alta Turno</title>
        <style>
            * {
                box-sizing: border-box;
            }

            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: 'Segoe UI', sans-serif;
                background: linear-gradient(to bottom, #006400, #00cc66);
                overflow-y: auto;
            }

            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 30px;
                background-color: white;
                border-radius: 12px;
                box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            }

            h1 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            h2 {
                text-align: center;
                color: #555;
                margin-bottom: 30px;
            }

            .mensaje {
                text-align: center;
                font-weight: bold;
                color: #006699;
                background-color: #e0f7ff;
                border: 1px solid #3399cc;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 20px;
            }

            .actions {
                display: flex;
                justify-content: center;
                gap: 20px;
                margin-bottom: 30px;
            }

            .actions form button {
                background-color: #003366;
                color: white;
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                font-size: 15px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .actions form button:hover {
                background-color: #0059b3;
            }

            fieldset {
                border: 1px solid #ccc;
                border-radius: 8px;
                margin-bottom: 25px;
                padding: 20px;
                background-color: #f9f9f9;
            }

            legend {
                font-weight: bold;
                color: #2c3e50;
                font-size: 16px;
                padding: 0 10px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
            }

            input[type="text"],
            input[type="date"],
            select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 15px;
                margin-bottom: 15px;
            }

            input[type="submit"] {
                background-color: #0059b3;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 10px 20px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
                display: block;
                margin: 0 auto;
            }

            input[type="submit"]:hover {
                background-color: #004080;
            }

            @media (max-width: 768px) {
                .actions {
                    flex-direction: column;
                    align-items: center;
                }

                form button {
                    width: 100%;
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%
            HttpSession miSesion = request.getSession(false);
            String usuarioEmail = (String) miSesion.getAttribute("email");
            List<Ciudadano> listaCiudadanos = (List<Ciudadano>) miSesion.getAttribute("listaCiudadanos");
            List<Tramite> listaTramites = (List<Tramite>) miSesion.getAttribute("listaTramites");
            String mensaje = request.getParameter("mens");
        %>

        <div class="container">
            <h1>Bienvenido <%= usuarioEmail %></h1>
            <% 
                if (usuarioEmail != null) {
                    if (mensaje != null) {
            %>
                        <div class="mensaje"><%= mensaje %></div>
            <% 
                    } else { 
            %>
                        <h2>Por Favor Ingresa los datos del Turno:</h2>
            <% 
                    }
                } else {
                    response.sendRedirect("login.jsp?mens=Primero Inicia Sesion!");
                    return; 
                }
            %>

            <div class="actions">
                <form action="MenuSv" method="POST" id="logoutForm">
                    <button type="submit" name="action" value="logout">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST" id="menuForm">
                    <button type="submit" name="menuAction" value="menu">Menú Principal</button>
                </form>
            </div>

            <form action="AltaTurnoSv" method="POST" autocomplete="off">
                <fieldset>
                    <legend>Capturar Nuevo Turno</legend>

                    <label for="ciudadano">Ciudadano:</label>
                    <select id="ciudadano" name="ciudadano" required>
                        <% 
                            if (listaCiudadanos != null) {
                                for (Ciudadano ciudadano : listaCiudadanos) {
                                    out.println("<option value=\"" + ciudadano.getClaveIdentificacion() + "\">" + ciudadano.getNombre() + " " + ciudadano.getApellido() + "</option>");
                                }
                            }
                        %>
                    </select>

                    <label for="tramite">Trámite:</label>
                    <select id="tramite" name="tramite" required>
                        <% 
                            if (listaTramites != null) {
                                for (Tramite tramite : listaTramites) {
                                    out.println("<option value=\"" + tramite.getId() + "\">" + tramite.getNombre() + "</option>");
                                }
                            }
                        %>
                    </select>

                    <label for="fecha">Fecha:</label>
                    <input type="date" id="fecha" name="fecha" required>

                    <input type="submit" value="Crear Turno">
                </fieldset>
            </form>
        </div>
    </body>
</html>