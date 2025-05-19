<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Alta Ciudadano</title>
    <link rel="stylesheet" href="css/<%= session.getAttribute("css") != null ? session.getAttribute("css") : "styles.css"%>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: linear-gradient(to bottom, #4caf50, #2e7d32);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-y: auto; /* Habilita scroll vertical */
        }

        .card-container {
            background-color: #ffffff;
            padding: 30px;
            margin: 40px auto;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            width: 95%;
            max-width: 600px;
        }

        h1, h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
        }

        #alerta {
            color: #155724;
            background-color: #d4edda;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        fieldset {
            border: none;
            padding: 0;
        }

        label {
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
            color: #333333;
        }

        input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #0d6efd;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #0b5ed7;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button-danger {
            background-color: #dc3545;
            color: white;
        }

        .button-danger:hover {
            background-color: #c82333;
        }

        .button-secondary {
            background-color: #6c757d;
            color: white;
        }

        .button-secondary:hover {
            background-color: #5a6268;
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
<div class="card-container">
    <h1>Bienvenido <%= login %></h1>
    <% if (mensaje != null) { %>
        <div id="alerta"><%= mensaje %></div>
    <% } else { %>
        <h2>Por Favor Ingresa los datos del Ciudadano:</h2>
    <% } %>

    <div class="button-container">
        <form action="MenuSv" method="POST">
            <button type="submit" name="action" value="logout" class="button button-danger">Cerrar sesión</button>
        </form>
        <form action="MenuSv" method="POST">
            <button type="submit" name="menuAction" value="menu" class="button button-secondary">Menú Principal</button>
        </form>
    </div>

    <form action="AltaCiudadanoSv" method="POST" autocomplete="off">
        <fieldset>
            <label for="nombre">Nombre:</label>
            <input type="text" id="nombre" name="nombre" placeholder="Nombre" required>

            <label for="apellido">Apellido:</label>
            <input type="text" id="apellido" name="apellido" placeholder="Apellido" required>

            <label for="claveIdentificacion">Clave de Identificación:</label>
            <input type="text" id="claveIdentificacion" name="claveIdentificacion" placeholder="Clave de Identificación" required>

            <input type="submit" value="Agregar Ciudadano">
        </fieldset>
    </form>
</div>
<% } else {
    response.sendRedirect("login.jsp?mens=Primero Inicia Sesion!");
} %>
</body>
</html>
