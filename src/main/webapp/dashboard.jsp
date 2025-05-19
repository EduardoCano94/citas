<%@page import="com.softek.logica.Turno.EstadoTurno"%>
<%@page import="com.softek.logica.Turno"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard de Turnos</title>
    <style>
        :root {
            --primary-color: #006400;
            --secondary-color: #00cc66;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h1, h2 {
            margin-bottom: 15px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            position: relative;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 10px 0;
        }

        .stat-label {
            color: #666;
            font-size: 1rem;
        }

        .badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .badge-success {
            background-color: var(--success-color);
            color: white;
        }

        .badge-warning {
            background-color: var(--warning-color);
            color: #333;
        }

        .badge-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .table-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--dark-color);
            color: white;
            position: sticky;
            top: 0;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .action-btn {
            padding: 5px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
            font-size: 0.8rem;
        }

        .btn-primary {
            background-color: var(--dark-color);
            color: white;
        }

        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .data-debug {
            font-size: 0.8rem;
            color: #666;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .stats-container {
                grid-template-columns: 1fr;
            }
            
            th, td {
                padding: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>Dashboard de Turnos</h1>
            <p>Bienvenido, <%= session.getAttribute("email") != null ? session.getAttribute("email") : "Usuario" %></p>
        </div>

        <%
            // Obtener la lista de turnos desde la sesión
            List<Turno> turnos = (List<Turno>) session.getAttribute("listaTurnos");
            
            // Si no hay lista en sesión, redirigir al servlet para cargarla
            if (turnos == null) {
                response.sendRedirect("GestorTurnosSv?action=listarTodos");
                return;
            }
            
            // Conteos usando programación funcional
            long enEsperaCount = turnos.stream()
                .filter(t -> t.getEstado() == EstadoTurno.EN_ESPERA)
                .count();
                
            long atendidosCount = turnos.stream()
                .filter(t -> t.getEstado() == EstadoTurno.YA_ATENDIDO)
                .count();
                
            long totalCount = turnos.size();
        %>

        <!-- Panel de estadísticas -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-value"><%= totalCount %></div>
                <div class="stat-label">Total de Turnos</div>
                <div class="data-debug">Actualizado: <%= new java.util.Date() %></div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= enEsperaCount %></div>
                <div class="stat-label">En Espera</div>
                <div class="data-debug">
                    <% if (enEsperaCount > 0) { %>
                        IDs: <%= turnos.stream()
                            .filter(t -> t.getEstado() == EstadoTurno.EN_ESPERA)
                            .map(t -> String.valueOf(t.getId()))
                            .collect(java.util.stream.Collectors.joining(", ")) %>
                    <% } %>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= atendidosCount %></div>
                <div class="stat-label">Atendidos</div>
                <div class="data-debug">
                    <% if (atendidosCount > 0) { %>
                        IDs: <%= turnos.stream()
                            .filter(t -> t.getEstado() == EstadoTurno.YA_ATENDIDO)
                            .map(t -> String.valueOf(t.getId()))
                            .collect(java.util.stream.Collectors.joining(", ")) %>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Tabla de turnos -->
        <div class="table-container">
            <h2>Últimos Turnos</h2>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ciudadano</th>
                        <th>Trámite</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!turnos.isEmpty()) {
                        for (Turno turno : turnos) { 
                            String badgeClass;
                            if (turno.getEstado() == EstadoTurno.YA_ATENDIDO) {
                                badgeClass = "badge-success";
                            } else if (turno.getEstado() == EstadoTurno.EN_ESPERA) {
                                badgeClass = "badge-warning";
                            } else {
                                badgeClass = "badge-danger";
                            }
                    %>
                    <tr>
                        <td><%= turno.getId() %></td>
                        <td><%= turno.getElCiudadano().getNombre() + " " + turno.getElCiudadano().getApellido() %></td>
                        <td><%= turno.getElTramite().getNombre() %></td>
                        <td><%= turno.getFecha() %></td>
                        <td><span class="badge <%= badgeClass %>"><%= turno.getEstado() %></span></td>
                        <td>
                            <% if (turno.getEstado() == EstadoTurno.EN_ESPERA) { %>
                                <button class="action-btn btn-primary" 
                                        onclick="marcarAtendido(<%= turno.getId() %>)">
                                    Marcar atendido
                                </button>
                            <% } %>
                            <button class="action-btn btn-danger" 
                                    onclick="eliminarTurno(<%= turno.getId() %>)">
                                Eliminar
                            </button>
                        </td>
                    </tr>
                    <% } 
                    } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No hay turnos registrados</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function marcarAtendido(turnoId) {
            if (confirm("¿Marcar este turno como atendido?")) {
                window.location.href = "GestorTurnosSv?action=editar&id=" + turnoId + "&estado=YA_ATENDIDO";
            }
        }
        
        function eliminarTurno(turnoId) {
            if (confirm("¿Eliminar este turno permanentemente?")) {
                window.location.href = "GestorTurnosSv?action=baja&id=" + turnoId;
            }
        }
        
        // Actualizar la página cada 60 segundos
        setTimeout(function() {
            window.location.reload();
        }, 60000);
    </script>
</body>
</html>