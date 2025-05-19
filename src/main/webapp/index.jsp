<%@page import="com.softek.logica.Turno.EstadoTurno"%>
<%@page import="com.softek.logica.Turno"%>
<%@page import="com.softek.logica.ControladoraLogica"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menú Principal con Dashboard</title>
    <style>
        :root {
            --primary-color: #006400;
            --secondary-color: #00cc66;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --report-color: #9c27b0;
            --calendar-color: #2196f3;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html, body {
            height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
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
            margin-bottom: 30px;
            font-size: 1.5rem;
        }

        .welcome-message {
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

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
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

        /* Estilos para el dashboard */
        .dashboard-section {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            background-color: #f9f9f9;
        }

        .dashboard-title {
            font-weight: bold;
            color: var(--dark-color);
            font-size: 1.2rem;
            padding: 0 15px;
            margin-bottom: 15px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .stat-card {
            background-color: white;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: relative;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: var(--dark-color);
            margin: 5px 0;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .badge-success {
            background-color: var(--success-color);
            color: white;
        }

        .badge-warning {
            background-color: var(--warning-color);
            color: #333;
        }

        .data-debug {
            position: absolute;
            bottom: 5px;
            left: 0;
            right: 0;
            font-size: 0.7rem;
            color: #999;
        }

        /* Estilos para las secciones de menú */
        .menu-section {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            background-color: #f9f9f9;
        }

        .section-title {
            font-weight: bold;
            color: var(--dark-color);
            font-size: 1.2rem;
            padding: 0 15px;
            margin-bottom: 15px;
        }

        .menu-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
        }

        .menu-btn {
            background-color: var(--dark-color);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            font-size: 0.9rem;
        }

        .menu-btn:hover {
            background-color: #0059b3;
            transform: translateY(-2px);
        }

        .menu-btn.alt {
            background-color: var(--success-color);
        }

        .menu-btn.warning {
            background-color: var(--warning-color);
            color: #333;
        }

        .menu-btn.danger {
            background-color: var(--danger-color);
        }

        .menu-btn.report {
            background-color: var(--report-color);
        }

        .menu-btn.calendar {
            background-color: var(--calendar-color);
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .actions {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                margin-bottom: 10px;
            }

            .stats-container, .menu-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        HttpSession miSesion = request.getSession(false);
        if (miSesion != null && miSesion.getAttribute("email") != null) {
            String login = (String) miSesion.getAttribute("email");
            String mensaje = request.getParameter("mens");
            
            
            ControladoraLogica control = new ControladoraLogica();
            
         
            List<Turno> todosTurnos = control.traerTodosLosTurnos();
            int totalCount = todosTurnos != null ? todosTurnos.size() : 0;
            
           
            List<Turno> turnosEnEspera = control.traerTurnosPorEstado("EN_ESPERA");
            int enEsperaCount = turnosEnEspera != null ? turnosEnEspera.size() : 0;
            
            List<Turno> turnosAtendidos = control.traerTurnosPorEstado("YA_ATENDIDO");
            int atendidosCount = turnosAtendidos != null ? turnosAtendidos.size() : 0;
    %>
    <div class="container">
        <h1>Sistema de Gestión de Turnos</h1>
        <h2>Bienvenido, <%= login %></h2>
        
        <% if (mensaje != null) { %>
            <div class="welcome-message"><%= mensaje %></div>
        <% } %>

        <div class="actions">
            <form action="MenuSv" method="POST">
                <button type="submit" name="action" value="logout" class="btn btn-primary">Cerrar sesión</button>
            </form>
        </div>

        <div class="dashboard-section">
            <div class="dashboard-title">Resumen de Turnos</div>
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-value"><%= totalCount %></div>
                    <div class="stat-label">Total de Turnos</div>
                    <div class="data-debug">Actualizado: <%= new java.util.Date() %></div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= enEsperaCount %></div>
                    <div class="stat-label">
                        <span class="badge badge-warning">EN_ESPERA</span>
                    </div>
                    <div class="data-debug">
                        <% if (turnosEnEspera != null && !turnosEnEspera.isEmpty()) { %>
                            IDs: <%= turnosEnEspera.stream()
                                .map(t -> String.valueOf(t.getId()))
                                .collect(java.util.stream.Collectors.joining(", ")) %>
                        <% } %>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-value"><%= atendidosCount %></div>
                    <div class="stat-label">
                        <span class="badge badge-success">YA_ATENDIDO</span>
                    </div>
                    <div class="data-debug">
                        <% if (turnosAtendidos != null && !turnosAtendidos.isEmpty()) { %>
                            IDs: <%= turnosAtendidos.stream()
                                .map(t -> String.valueOf(t.getId()))
                                .collect(java.util.stream.Collectors.joining(", ")) %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Gestión de Turnos</div>
            <div class="menu-options">
                <form action="GestorTurnosSv" method="POST">
                    <button type="submit" name="action" value="alta" class="menu-btn alt">Registrar Turnos</button>
                </form>
                <form action="GestorTurnosSv" method="POST">
                    <button type="submit" name="action" value="listarTodos" class="menu-btn">Todos los Turnos</button>
                </form>
                <form action="GestorTurnosSv" method="POST">
                    <button type="submit" name="action" value="listarEspera" class="menu-btn warning">Turnos en Espera</button>
                </form>
                <form action="GestorTurnosSv" method="POST">
                    <button type="submit" name="action" value="listarAtendidos" class="menu-btn alt">Turnos Atendidos</button>
                </form>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Gestión de Ciudadanos</div>
            <div class="menu-options">
                <form action="GestorCiudadanosSv" method="POST">
                    <button type="submit" name="action" value="alta" class="menu-btn alt">Registrar Ciudadanos</button>
                </form>
                <form action="GestorCiudadanosSv" method="POST">
                    <button type="submit" name="action" value="buscar" class="menu-btn">Buscar Ciudadanos</button>
                </form>
                <form action="GestorCiudadanosSv" method="POST">
                    <button type="submit" name="action" value="editar" class="menu-btn warning">Editar Ciudadanos</button>
                </form>
                <form action="GestorCiudadanosSv" method="POST">
                    <button type="submit" name="action" value="borrar" class="menu-btn danger">Eliminar Ciudadanos</button>
                </form>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Gestión de Trámites</div>
            <div class="menu-options">
                <form action="GestorTramitesSv" method="POST">
                    <button type="submit" name="action" value="alta" class="menu-btn alt">Agregar Trámite</button>
                </form>
                <form action="GestorTramitesSv" method="POST">
                    <button type="submit" name="action" value="buscar" class="menu-btn">Buscar Trámite</button>
                </form>
                <form action="GestorTramitesSv" method="POST">
                    <button type="submit" name="action" value="editar" class="menu-btn warning">Editar Trámite</button>
                </form>
                <form action="GestorTramitesSv" method="POST">
                    <button type="submit" name="action" value="borrar" class="menu-btn danger">Eliminar Trámite</button>
                </form>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Gestión de Usuarios</div>
            <div class="menu-options">
                <form action="GestorUsuariosSv" method="POST">
                    <button type="submit" name="action" value="alta" class="menu-btn alt">Agregar Usuario</button>
                </form>
                <form action="GestorUsuariosSv" method="POST">
                    <button type="submit" name="action" value="buscar" class="menu-btn">Buscar Usuario</button>
                </form>
                <form action="GestorUsuariosSv" method="POST">
                    <button type="submit" name="action" value="editar" class="menu-btn warning">Editar Usuario</button>
                </form>
                <form action="GestorUsuariosSv" method="POST">
                    <button type="submit" name="action" value="baja" class="menu-btn danger">Eliminar Usuario</button>
                </form>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Generación de Reportes</div>
            <div class="menu-options">
                <form action="generarReportes.jsp" method="GET">
                    <button type="submit" class="menu-btn report">Generar Reportes</button>
                </form>
            </div>
        </div>

        <div class="menu-section">
            <div class="section-title">Visualización de Turnos</div>
            <div class="menu-options">
                <form action="calendario.jsp" method="GET">
                    <button type="submit" class="menu-btn calendar">Ver Agenda</button>
                </form>
            </div>
        </div>
    </div>
    <%
        } else {
            response.sendRedirect("login.jsp?mens=Primero Inicia Sesión!");
        }
    %>
</body>
</html>