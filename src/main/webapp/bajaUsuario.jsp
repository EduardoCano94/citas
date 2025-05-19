<%@page import="com.softek.logica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Baja Usuarios</title>
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

            input[type="email"],
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

            .usuario-info {
                margin-bottom: 20px;
            }

            .usuario-info p {
                margin: 8px 0;
                padding: 8px;
                background-color: #f0f0f0;
                border-radius: 4px;
            }

            .usuario-info strong {
                color: #2c3e50;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 20px;
                    padding: 15px;
                }
                
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
            <h2>Por Favor Ingresa el Email del Usuario:</h2>
            <%}%>

            <div class="actions">
                <form action="MenuSv" method="POST" id="logoutForm">
                    <button type="submit" name="action" value="logout">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST" id="menuForm">
                    <button type="submit" name="menuAction" value="menu">Menú Principal</button>
                </form>
            </div>

            <% Usuario user = (Usuario) miSesion.getAttribute("usuario");
                if (user == null) {
            %>
            <form action="BajaUsuarioSv" method="POST" autocomplete="off">
                <fieldset>
                    <legend>Correo del Usuario a Eliminar:</legend>
                    <label for="email">Correo electrónico:</label>
                    <input type="email" id="email" name="email" placeholder="usuario@dominio.com" required>
                    <input type="submit" value="Buscar Usuario a eliminar">
                </fieldset>
            </form>
            <%} else {%>
            <form action="BajaUsuarioSv" method="GET" autocomplete="off">
                <fieldset>
                    <legend>Confirmar Usuario a Eliminar:</legend>
                    <div class="usuario-info">
                        <p><strong>Nombre:</strong> <%= user.getNombre()%></p>
                        <p><strong>Apellido:</strong> <%= user.getApellido()%></p>
                        <p><strong>Email:</strong> <%= user.getEmail()%></p>
                    </div>
                    <input type="hidden" name="id" value="<%= user.getId()%>">                
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