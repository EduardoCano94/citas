<%@page import="java.util.List"%>
<%@page import="com.softek.logica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Buscar Usuarios</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #006400, #00cc66);
                color: #333;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 1000px;
                margin: 0 auto;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 30px;
            }

            h1 {
                text-align: center;
                color: #2c3e50;
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
                background-color: #003366;
                color: white;
            }

            .btn-primary:hover {
                background-color: #0059b3;
                transform: translateY(-2px);
            }

            .form-container {
                margin-bottom: 30px;
            }

            fieldset {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 25px;
                background-color: #f9f9f9;
            }

            legend {
                font-weight: bold;
                color: #2c3e50;
                font-size: 1.1rem;
                padding: 0 10px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #444;
            }

            input[type="email"],
            input[type="text"] {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 1rem;
                transition: border 0.3s;
            }

            input[type="email"]:focus,
            input[type="text"]:focus {
                border-color: #0059b3;
                outline: none;
                box-shadow: 0 0 0 3px rgba(0, 89, 179, 0.1);
            }

            .btn-submit {
                background-color: #0059b3;
                color: white;
                padding: 12px 25px;
                font-size: 1rem;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s;
                display: block;
                margin: 25px auto 0;
                width: 250px;
            }

            .btn-submit:hover {
                background-color: #004080;
                transform: translateY(-2px);
            }

            .user-info {
                margin-bottom: 20px;
            }

            .user-info p {
                margin: 10px 0;
                padding: 10px;
                background-color: #f0f0f0;
                border-radius: 5px;
            }

            .user-info strong {
                color: #2c3e50;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin: 25px 0;
                box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
            }

            th {
                background-color: #003366;
                color: white;
                padding: 12px;
                text-align: left;
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

            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }

                .button-group {
                    flex-direction: column;
                    align-items: center;
                }

                .btn {
                    width: 100%;
                    margin-bottom: 10px;
                }

                .btn-submit {
                    width: 100%;
                }

                table {
                    display: block;
                    overflow-x: auto;
                }
            }
        </style>
    </head>
    <body>
        <%
            HttpSession miSesion = request.getSession(false);
            String login;
            if (miSesion != null && miSesion.getAttribute("email") != null) {
                login = (String) miSesion.getAttribute("email");
                String mensaje = request.getParameter("mens");
        %>
        <div class="container">
            <h1>Bienvenido <%= login %></h1>
            <% if (mensaje != null) { %>
            <div class="alert"><%= mensaje %></div>
            <% } else { %>
            <h2>Por Favor Ingresa el email del Usuario:</h2>
            <% } %>

            <div class="button-group">
                <form action="MenuSv" method="POST">
                    <button type="submit" name="action" value="logout" class="btn btn-primary">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST">
                    <button type="submit" name="menuAction" value="menu" class="btn btn-primary">Menú Principal</button>
                </form>
            </div>

            <div class="form-container">
                <%
                    String ocultar = (String) miSesion.getAttribute("ocultar");
                    if (ocultar == null) {
                        Usuario user = (Usuario) miSesion.getAttribute("usuario");
                        if (user != null) { 
                %>
                <fieldset>
                    <legend>Datos de <%= user.getEmail() %></legend>
                    <div class="user-info">
                        <p><strong>Nombre:</strong> <%= user.getNombre() %></p>
                        <p><strong>Apellido:</strong> <%= user.getApellido() %></p>
                        <p><strong>Email:</strong> <%= user.getEmail() %></p>
                    </div>
                </fieldset>
                <% } else { %>
                <form action="BuscarUsuarioSv" method="POST" autocomplete="off">
                    <fieldset>
                        <legend>Correo del Usuario a Buscar:</legend>
                        <div class="form-group">
                            <label for="email">Correo electrónico:</label>
                            <input type="email" id="email" name="email" placeholder="usuario@dominio.com" required>
                        </div>
                        <button type="submit" class="btn-submit">Buscar Usuario</button>
                    </fieldset>
                </form>
                <% } %>
                <% } %>

                <form action="BuscarUsuarioSv" method="GET" autocomplete="off">
                    <fieldset>
                        <legend>Mostrar todos los Usuarios</legend>
                        <%
                            List<Usuario> listaUsuarios = (List<Usuario>) miSesion.getAttribute("listaUsuarios");
                            if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
                        %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Nombre</th>
                                    <th>Apellido</th>
                                    <th>Email</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Usuario usuario : listaUsuarios) { %>
                                <tr>
                                    <td><%= usuario.getNombre() %></td>
                                    <td><%= usuario.getApellido() %></td>
                                    <td><%= usuario.getEmail() %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <% } %>
                        <button type="submit" class="btn-submit">Mostrar Todos</button>
                    </fieldset>
                </form>
            </div>
        </div>
        <% } else {
                response.sendRedirect("login.jsp?mens=Primero Inicia Sesion.");
            } %>
    </body>
</html>