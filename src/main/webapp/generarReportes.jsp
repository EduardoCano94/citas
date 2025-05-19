<%@page import="com.softek.logica.Turno"%>
<%@page import="com.softek.logica.Tramite"%>
<%@page import="com.softek.logica.ControladoraLogica"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Generador de Reportes</title>
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

        .report-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        h1, h2, h3 {
            margin-bottom: 15px;
        }

        .filter-section {
            background: var(--light-color);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #ddd;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        select, input, button {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }

        button {
            background-color: var(--dark-color);
            color: white;
            cursor: pointer;
            border: none;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #1a5276;
        }

        .report-results {
            margin-top: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: var(--dark-color);
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
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

        .export-options {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        .btn-export {
            padding: 8px 15px;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .btn-excel {
            background-color: var(--success-color);
        }

        .no-results {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }

        .button-container {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }

        .button {
            padding: 10px 15px;
            border-radius: 4px;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }

        .button-danger {
            background-color: var(--danger-color);
            color: white;
        }

        .button-secondary {
            background-color: var(--secondary-color);
            color: white;
        }

        @media (max-width: 768px) {
            .report-container {
                padding: 15px;
            }
            
            .export-options, .button-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="report-container">
        <div class="header">
            <h1>Generador de Reportes Personalizados</h1>
            <p>Bienvenido, <%= session.getAttribute("email") != null ? session.getAttribute("email") : "Usuario" %></p>
        </div>
        
        
    <div class="button-container">
        <form action="MenuSv" method="POST">
            <button type="submit" name="action" value="logout" class="button button-danger">Cerrar sesión</button>
        </form>
        <form action="MenuSv" method="POST">
            <button type="submit" name="menuAction" value="menu" class="button button-secondary">Menú Principal</button>
        </form>
    </div>

        <form method="POST" action="GenerarReporteSv">
            <div class="filter-section">
                <h3>Filtros de Búsqueda</h3>
                
                <div class="form-group">
                    <label for="tipoReporte">Tipo de Reporte:</label>
                    <select id="tipoReporte" name="tipoReporte" required>
                        <option value="">-- Seleccione --</option>
                        <option value="turnos" <%= "turnos".equals(request.getAttribute("tipoReporte")) ? "selected" : "" %>>Turnos</option>
                        <option value="tramites" <%= "tramites".equals(request.getAttribute("tipoReporte")) ? "selected" : "" %>>Trámites</option>
                    </select>
                </div>

                <div id="filtrosTurnos" class="filtro-tipo" <%= "turnos".equals(request.getAttribute("tipoReporte")) ? "" : "style='display:none;'" %>>
                    <div class="form-group">
                        <label for="estadoTurno">Estado del Turno:</label>
                        <select id="estadoTurno" name="estadoTurno">
                            <option value="">Todos</option>
                            <option value="EN_ESPERA" <%= "EN_ESPERA".equals(request.getParameter("estadoTurno")) ? "selected" : "" %>>En Espera</option>
                            <option value="YA_ATENDIDO" <%= "YA_ATENDIDO".equals(request.getParameter("estadoTurno")) ? "selected" : "" %>>Atendidos</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="fechaDesdeTurno">Desde:</label>
                        <input type="date" id="fechaDesdeTurno" name="fechaDesdeTurno" value="<%= request.getParameter("fechaDesdeTurno") != null ? request.getParameter("fechaDesdeTurno") : "" %>">
                    </div>

                    <div class="form-group">
                        <label for="fechaHastaTurno">Hasta:</label>
                        <input type="date" id="fechaHastaTurno" name="fechaHastaTurno" value="<%= request.getParameter("fechaHastaTurno") != null ? request.getParameter("fechaHastaTurno") : "" %>">
                    </div>
                </div>

                <div id="filtrosTramites" class="filtro-tipo" <%= "tramites".equals(request.getAttribute("tipoReporte")) ? "" : "style='display:none;'" %>>
                    <div class="form-group">
                        <label for="tipoTramite">Tipo de Trámite:</label>
                        <select id="tipoTramite" name="tipoTramite">
                            <option value="">Todos</option>
                            <%
                                ControladoraLogica control = new ControladoraLogica();
                                List<Tramite> tramites = control.traerTodosLosTramites();
                                for (Tramite tramite : tramites) {
                                    String selected = "";
                                    if (request.getParameter("tipoTramite") != null && 
                                        request.getParameter("tipoTramite").equals(String.valueOf(tramite.getId()))) {
                                        selected = "selected";
                                    }
                            %>
                            <option value="<%= tramite.getId() %>" <%= selected %>><%= tramite.getNombre() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <button type="submit" name="action" value="generar">Generar Reporte</button>
            </div>
        </form>

        <div class="report-results">
            <h3>Resultados del Reporte</h3>
            
            <% if (request.getAttribute("mensajeError") != null) { %>
                <div class="no-results" style="color: var(--danger-color);">
                    <%= request.getAttribute("mensajeError") %>
                </div>
            <% } %>
            
            <%
                List<?> resultados = (List<?>) request.getAttribute("resultados");
                String tipoReporte = (String) request.getAttribute("tipoReporte");
                
                if (resultados != null && !resultados.isEmpty()) {
            %>
            
            <div class="export-options">
                <form method="POST" action="GenerarReporteSv" style="display: inline;">
                    <input type="hidden" name="action" value="exportar">
                    <input type="hidden" name="formato" value="csv">
                    <input type="hidden" name="tipoReporte" value="<%= tipoReporte %>">
                    
                    <% if ("turnos".equals(tipoReporte)) { %>
                        <input type="hidden" name="estadoTurno" value="<%= request.getParameter("estadoTurno") != null ? request.getParameter("estadoTurno") : "" %>">
                        <input type="hidden" name="fechaDesdeTurno" value="<%= request.getParameter("fechaDesdeTurno") != null ? request.getParameter("fechaDesdeTurno") : "" %>">
                        <input type="hidden" name="fechaHastaTurno" value="<%= request.getParameter("fechaHastaTurno") != null ? request.getParameter("fechaHastaTurno") : "" %>">
                    <% } else if ("tramites".equals(tipoReporte)) { %>
                        <input type="hidden" name="tipoTramite" value="<%= request.getParameter("tipoTramite") != null ? request.getParameter("tipoTramite") : "" %>">
                    <% } %>
                    <button type="submit" class="btn-export btn-excel">Exportar a CSV</button>
                </form>
            </div>

            <% if ("turnos".equals(tipoReporte)) { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ciudadano</th>
                            <th>Trámite</th>
                            <th>Fecha</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Object item : resultados) { 
                            Turno turno = (Turno) item;
                            String badgeClass = turno.getEstado() == Turno.EstadoTurno.YA_ATENDIDO ? "badge-success" : "badge-warning";
                        %>
                        <tr>
                            <td><%= turno.getId() %></td>
                            <td><%= turno.getElCiudadano().getNombre() %> <%= turno.getElCiudadano().getApellido() %></td>
                            <td><%= turno.getElTramite().getNombre() %></td>
                            <td><%= turno.getFecha().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></td>
                            <td><span class="badge <%= badgeClass %>"><%= turno.getEstado() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            
            <% } else if ("tramites".equals(tipoReporte)) { %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Requisitos</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Object item : resultados) { 
                            Tramite tramite = (Tramite) item;
                        %>
                        <tr>
                            <td><%= tramite.getId() %></td>
                            <td><%= tramite.getNombre() %></td>
                            <td><%= tramite.getDescripcion() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <% } else if (resultados != null && resultados.isEmpty()) { %>
                <div class="no-results">
                    No se encontraron resultados con los filtros seleccionados
                </div>
            <% } %>
        </div>
    </div>

    <script>
        document.getElementById('tipoReporte').addEventListener('change', function() {
            const tipo = this.value;
            document.getElementById('filtrosTurnos').style.display = 'none';
            document.getElementById('filtrosTramites').style.display = 'none';
            
            if (tipo === 'turnos') {
                document.getElementById('filtrosTurnos').style.display = 'block';
            } else if (tipo === 'tramites') {
                document.getElementById('filtrosTramites').style.display = 'block';
            }
        });

        document.querySelector('form').addEventListener('submit', function(e) {
            const tipoReporte = document.getElementById('tipoReporte').value;
            if (tipoReporte === 'turnos') {
                const fechaDesde = document.getElementById('fechaDesdeTurno').value;
                const fechaHasta = document.getElementById('fechaHastaTurno').value;
                
                if (fechaDesde && fechaHasta && fechaDesde > fechaHasta) {
                    alert('La fecha "Desde" no puede ser mayor que la fecha "Hasta"');
                    e.preventDefault();
                }
            }
        });
        
        window.addEventListener('load', function() {
            const tipoReporte = '<%= tipoReporte %>';
            if (tipoReporte) {
                document.getElementById('tipoReporte').value = tipoReporte;
            }
        });
    </script>
    
</body>
</html>