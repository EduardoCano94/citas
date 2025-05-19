<%@page import="com.softek.logica.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar Usuarios</title>
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
                position: relative;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #444;
                font-size: 1rem;
            }
            
            input[type="text"],
            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 1rem;
                transition: all 0.3s;
            }
            
            input[type="text"]:focus,
            input[type="email"]:focus,
            input[type="password"]:focus {
                border-color: var(--dark-color);
                outline: none;
                box-shadow: 0 0 0 3px rgba(44, 62, 80, 0.1);
            }
            
            .password-container {
                position: relative;
            }
            
            .toggle-password {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                color: #666;
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
            
            .password-strength {
                margin-top: 5px;
                height: 5px;
                border-radius: 5px;
                background-color: #eee;
                overflow: hidden;
            }
            
            .strength-meter {
                height: 100%;
                width: 0;
                transition: width 0.3s, background-color 0.3s;
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
        <script>
            function togglePasswordVisibility(fieldId, iconId) {
                const field = document.getElementById(fieldId);
                const icon = document.getElementById(iconId);
                if (field.type === "password") {
                    field.type = "text";
                    icon.textContent = "visibility_off";
                } else {
                    field.type = "password";
                    icon.textContent = "visibility";
                }
            }
            
            function checkPasswordStrength() {
                const password = document.getElementById('password').value;
                const strengthMeter = document.getElementById('strength-meter');
                let strength = 0;
                
                if (password.length >= 8) strength++;
                if (password.match(/[a-z]/) strength++;
                if (password.match(/[A-Z]/)) strength++;
                if (password.match(/[0-9]/)) strength++;
                if (password.match(/[^a-zA-Z0-9]/)) strength++;
                
                let width = strength * 20;
                let color = '#dc3545'; // Rojo
                
                if (strength >= 4) {
                    color = '#28a745'; // Verde
                } else if (strength >= 2) {
                    color = '#ffc107'; // Amarillo
                }
                
                strengthMeter.style.width = width + '%';
                strengthMeter.style.backgroundColor = color;
            }
            
            function validatePasswords() {
                const password = document.getElementById('password').value;
                const password2 = document.getElementById('password2').value;
                const submitBtn = document.querySelector('.btn-submit');
                
                if (password !== password2) {
                    document.getElementById('password2').setCustomValidity('Las contraseñas no coinciden');
                    submitBtn.disabled = true;
                } else {
                    document.getElementById('password2').setCustomValidity('');
                    submitBtn.disabled = false;
                }
            }
            
            document.addEventListener('DOMContentLoaded', function() {
                document.getElementById('password').addEventListener('input', checkPasswordStrength);
                document.getElementById('password').addEventListener('input', validatePasswords);
                document.getElementById('password2').addEventListener('input', validatePasswords);
            });
        </script>
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
            <h2>Modificar Usuario:</h2>
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
                <% Usuario user = (Usuario) miSesion.getAttribute("usuario");
                    if (user == null) {
                %>
                <form action="EditarUsuarioSv" method="GET" autocomplete="off">
                    <fieldset>
                        <legend>Correo del Usuario a Editar:</legend>
                        <div class="form-group">
                            <label for="email">Correo electrónico:</label>
                            <input type="email" id="email" name="email" placeholder="usuario@dominio.com" required>
                        </div>
                        <button type="submit" class="btn-submit">Buscar Usuario</button>
                    </fieldset>
                </form>
                <%} else {%>
                <form action="EditarUsuarioSv" method="POST" autocomplete="off">
                    <fieldset>
                        <legend>Modificar Usuario:</legend>
                        
                        <div class="form-group">
                            <label for="nombre">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" value="<%= user.getNombre()%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="apellido">Apellido:</label>
                            <input type="text" id="apellido" name="apellido" value="<%= user.getApellido()%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" id="email" name="email" value="<%= user.getEmail()%>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Contraseña:</label>
                            <div class="password-container">
                                <input type="password" id="password" name="password" value="<%= user.getPassword()%>" required 
                                       minlength="8" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" 
                                       title="Debe contener al menos 8 caracteres, una mayúscula, una minúscula y un número">
                                <span class="toggle-password material-icons" id="toggle-password" 
                                      onclick="togglePasswordVisibility('password', 'toggle-password')">visibility</span>
                            </div>
                            <div class="password-strength">
                                <div id="strength-meter" class="strength-meter"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="password2">Repetir Contraseña:</label>
                            <div class="password-container">
                                <input type="password" id="password2" name="password2" placeholder="Repite la contraseña" required>
                                <span class="toggle-password material-icons" id="toggle-password2" 
                                      onclick="togglePasswordVisibility('password2', 'toggle-password2')">visibility</span>
                            </div>
                        </div>
                        
                        <input type="hidden" name="id" value="<%= user.getId()%>">
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