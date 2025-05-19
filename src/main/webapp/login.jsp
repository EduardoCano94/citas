<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Acceso al Sistema</title>
    <link rel="stylesheet" href="css/styles.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #eaeaea;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        .login-container {
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
        }

        h1 {
            font-size: 22px;
            color: #333333;
            text-align: center;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 16px;
            color: #666666;
            text-align: center;
            margin-bottom: 20px;
        }

        #alerta {
            color: #a94442;
            background-color: #f2dede;
            border: 1px solid #ebccd1;
            padding: 10px;
            border-radius: 4px;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #333333;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 15px;
            border: 1px solid #cccccc;
            border-radius: 4px;
            font-size: 14px;
        }

        .radio-group {
            margin-bottom: 20px;
        }

        .radio-group label {
            font-weight: normal;
            margin-right: 15px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #004085;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            font-size: 15px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #002752;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h1>Acceso al Sistema de Turnos</h1>
        <% String mensaje = request.getParameter("mens"); %>
        <% if (mensaje != null) { %>
            <div id="alerta"><%= mensaje %></div>
        <% } else { %>
            <h2>Por favor, ingrese sus credenciales</h2>
        <% } %>

        <form action="LoginSv" method="POST" autocomplete="off">
            <label for="email">Correo electrónico:</label>
            <input type="email" id="email" name="email" placeholder="usuario@dominio.com" required>

            <label for="password">Contraseña:</label>
            <input type="password" id="password" name="password" placeholder="Mínimo 4 caracteres" minlength="4" required autocomplete="new-password">

            <input type="submit" value="Iniciar sesión">
        </form>
    </div>

</body>
</html>