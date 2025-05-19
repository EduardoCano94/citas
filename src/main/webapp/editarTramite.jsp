<%@page import="com.softek.logica.Tramite"%>
<%@page import="com.softek.logica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar Trámites</title>
        <style>
            :root {
                --primary-color: #006400;
                --secondary-color: #00cc66;
                --dark-color: #2c3e50;
                --light-color: #f8f9fa;
                --success-color: #28a745;
                --warning-color: #ffc107;
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
                max-width: 800px;
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
            
            .form-container {
                margin-bottom: 30px;
            }
            
            fieldset {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 25px;
                margin-bottom: 25px;
                background-color: #f9f9f9;
            }
            
            legend {
                font-weight: bold;
                color: var(--dark-color);
                font-size: 1.2rem;
                padding: 0 15px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #444;
                font-size: 1rem;
            }
            
            input[type="text"],
            textarea {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 1rem;
                transition: all 0.3s;
                font-family: inherit;
            }
            
            textarea {
                min-height: 120px;
                resize: vertical;
            }
            
            input[type="text"]:focus,
            textarea:focus {
                border-color: var(--dark-color);
                outline: none;
                box-shadow: 0 0 0 3px rgba(44, 62, 80, 0.1);
            }
            
            .btn-submit {
                background-color: var(--success-color);
                color: white;
                padding: 12px 25px;
                font-size: 1.1rem;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s;
                display: block;
                margin: 30px auto 0;
                width: 250px;
                font-weight: 500;
            }
            
            .btn-submit:hover {
                background-color: #218838;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            
            .tramite-info {
                margin-bottom: 25px;
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
                
                .btn-submit {
                    width: 100%;
                }
                
                fieldset {
                    padding: 15px;
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
            <div class="alert"><%=mensaje%></div>
            <%} else {%>
            <h2>Modificar Trámite:</h2>
            <%}%>

            <div class="button-group">
                <form action="MenuSv" method="POST">
                    <button type="submit" name="action" value="logout" class="btn btn-primary">Cerrar sesión</button>
                </form>
                <form action="MenuSv" method="POST">
                    <button type="submit" name="menuAction" value="menu" class="btn btn-primary">Menú Principal</button>
                </form>
            </div>

            <div class="form-container">
                <% Tramite tramite = (Tramite) miSesion.getAttribute("tramite");
                    if (tramite == null) {
                %>
                <form action="EditarTramiteSv" method="GET" autocomplete="off">
                    <fieldset>
                        <legend>Nombre del Trámite a Editar:</legend>
                        <div class="form-group">
                            <label for="nombre">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" placeholder="Nombre del trámite" required>
                        </div>
                        <button type="submit" class="btn-submit">Buscar Trámite</button>
                    </fieldset>
                </form>
                <%} else {%>
                <form action="EditarTramiteSv" method="POST" autocomplete="off">
                    <fieldset>
                        <legend>Modificar Trámite:</legend>
                        <div class="form-group">
                            <label for="nombre">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" value="<%= tramite.getNombre()%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="descripcion">Descripción:</label>
                            <textarea id="descripcion" name="descripcion" required><%= tramite.getDescripcion()%></textarea>
                        </div>
                        
                        <input type="hidden" name="id" value="<%= tramite.getId()%>">
                        <button type="submit" class="btn-submit">Guardar Cambios</button>
                    </fieldset>
                </form>
                <%}%>
            </div>
        </div>
        <%} else {
                response.sendRedirect("login.jsp?mens=Primero Inicia Sesion!");
            }%>
    </body>
</html>