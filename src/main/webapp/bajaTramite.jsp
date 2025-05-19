<%@page import="com.softek.logica.Tramite"%>
<%@page import="com.softek.logica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Baja Tramites</title>
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

            input[type="text"] {
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
                margin: 20px auto 0;
                width: 250px;
            }

            .botonrojo {
                background-color: #d9534f !important;
            }

            .botonrojo:hover {
                background-color: #c9302c !important;
            }

            .tramite-info {
                margin-bottom: 20px;
            }

            .tramite-info p {
                margin: 8px 0;
                padding: 8px;
                background-color: #f0f0f0;
                border-radius: 4px;
            }

            .tramite-info strong {
                color: #2c3e50;
            }

            @media (max-width: 768px) {
                .actions {
                    flex-direction: column;
                    align-items: center;
                }

                .actions form button {
                    width: 100%;
                    margin-bottom: 10px;
                }
                
                input[type="submit"] {
                    width: 100%;
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
            <h1>Bienvenido <%=login%></h1>
            <%if (mensaje != null) {%>
            <div class="mensaje"><%=mensaje%></div>
            <%} else {%>
            <h2>Por Favor Ingresa el nombre del Tramite:</h2>
            <%}%>

            <div class="actions">
                <form action="MenuSv" method="POST" id="logoutForm">
                    <button type="submit" name="action" value="logout">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST" id="menuForm">
                    <button type="submit" name="menuAction" value="menu">Menú Principal</button>
                </form>
            </div>

            <% Tramite tramite = (Tramite) miSesion.getAttribute("tramite");
                if (tramite == null) {
            %>
            <form action="BajaTramiteSv" method="POST" autocomplete="off">
                <fieldset>
                    <legend>Nombre del Tramite a Eliminar:</legend>
                    <label for="nombre">Nombre:</label>
                    <input type="text" id="nombre" name="nombre" placeholder="Nombre del tramite" required>
                    <input type="submit" value="Buscar Tramite a eliminar">
                </fieldset>
            </form>
            <%} else {%>
            <form action="BajaTramiteSv" method="GET" autocomplete="off">
                <fieldset>
                    <legend>Confirmar Tramite a Eliminar:</legend>
                    <div class="tramite-info">
                        <p><strong>Nombre:</strong> <%= tramite.getNombre()%></p>
                        <p><strong>Descripción:</strong> <%= tramite.getDescripcion()%></p>
                    </div>
                    <input type="hidden" name="id" value="<%= tramite.getId()%>">                
                    <input type="submit" class="botonrojo" value="Confirmar Eliminación">
                </fieldset>
            </form>
            <%}%>
        </div>
        <%} else {
                response.sendRedirect("login.jsp?mens=Primero Inicia Sesion!");
            }%>
    </body>
</html>