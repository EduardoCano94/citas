<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error del Sistema</title>
    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom, #8B0000, #FF6347);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .error-container {
            background-color: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }

        h1 {
            color: #cc0000;
            font-size: 28px;
            margin-bottom: 10px;
        }

        p {
            color: #333;
            font-size: 16px;
            margin-bottom: 20px;
        }

        a.button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #003366;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 15px;
            transition: background-color 0.3s;
        }

        a.button:hover {
            background-color: #0059b3;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>¡Ha ocurrido un error!</h1>
        <p>Se ha producido un problema en el sistema. Por favor, intente nuevamente más tarde.</p>
        <a href="index.jsp" class="button">Volver al Menú Principal</a>
    </div>
</body>
</html>
