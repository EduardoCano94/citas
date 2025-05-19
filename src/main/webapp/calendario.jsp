<%@page import="java.util.stream.Collectors"%>
<%@page import="com.softek.logica.Turno"%>
<%@page import="com.softek.logica.ControladoraLogica"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.TextStyle"%>
<%@page import="java.time.DayOfWeek"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Calendario de Turnos</title>
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
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f9f9f9;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .nav-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 15px;
            background-color: var(--dark-color);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .btn:hover {
            background-color: #1a5276;
        }

        .month {
            padding: 20px 25px;
            background: var(--primary-color);
            text-align: center;
            color: white;
            border-radius: 8px 8px 0 0;
        }

        .month ul {
            margin: 0;
            padding: 0;
            list-style-type: none;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .month ul li {
            padding: 0 10px;
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 3px;
        }

        .month .prev, .month .next {
            cursor: pointer;
            font-size: 24px;
        }

        .month .prev:hover, .month .next:hover {
            color: #ddd;
        }

        .weekdays {
            margin: 0;
            padding: 10px 0;
            background-color: #ddd;
            display: flex;
            flex-wrap: wrap;
        }

        .weekdays li {
            display: inline-block;
            width: 14.2%;
            text-align: center;
            font-weight: bold;
        }

        .days {
            padding: 10px 0;
            background: #fff;
            margin: 0;
            display: flex;
            flex-wrap: wrap;
            border-radius: 0 0 8px 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .days li {
            list-style-type: none;
            display: inline-block;
            width: 14.2%;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
            color: #333;
            min-height: 80px;
            position: relative;
            padding: 5px;
            border: 1px solid #eee;
        }

        .day-number {
            font-weight: bold;
            margin-bottom: 5px;
            display: block;
            text-align: right;
            padding: 2px 5px;
        }

        .day-number.active {
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            display: inline-block;
            width: 24px;
            height: 24px;
            line-height: 24px;
            text-align: center;
        }

        .turno-item {
            font-size: 0.7rem;
            padding: 2px;
            margin: 2px 0;
            border-radius: 3px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .turno-espera {
            background-color: var(--warning-color);
            color: #333;
        }

        .turno-atendido {
            background-color: var(--success-color);
            color: white;
        }

        .other-month {
            background-color: #f9f9f9;
            color: #aaa !important;
        }

        @media screen and (max-width: 768px) {
            .weekdays li, .days li {
                width: 14.1%;
            }

            .days li {
                min-height: 60px;
                font-size: 12px;
            }

            .turno-item {
                font-size: 0.6rem;
            }
        }

        @media screen and (max-width: 420px) {
            .weekdays li, .days li {
                width: 13.8%;
            }

            .days li {
                min-height: 40px;
            }

            .turno-item {
                display: none;
            }

            .day-number {
                font-size: 10px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Calendario de Turnos</h1>
        <div class="nav-buttons">
            <a href="index.jsp" class="btn">Menú Principal</a>
            <a href="login.jsp?mens=Sesion%20cerrada%20correctamente.t" class="btn">Cerrar Sesión</a>
        </div>
    </div>

    <%
        // Obtener parámetros de mes y año de la URL
        int currentMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : LocalDate.now().getMonthValue();
        int currentYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : LocalDate.now().getYear();

        // Ajustar si se desborda hacia año anterior o siguiente
        if (currentMonth < 1) {
            currentMonth = 12;
            currentYear--;
        } else if (currentMonth > 12) {
            currentMonth = 1;
            currentYear++;
        }

        LocalDate today = LocalDate.now();
        LocalDate firstDayOfMonth = LocalDate.of(currentYear, currentMonth, 1);
        DayOfWeek firstDayOfWeek = firstDayOfMonth.getDayOfWeek();
        int daysInMonth = firstDayOfMonth.lengthOfMonth();

        LocalDate lastDayOfPrevMonth = firstDayOfMonth.minusDays(1);
        int daysInPrevMonth = lastDayOfPrevMonth.lengthOfMonth();
        int prevMonthDaysToShow = firstDayOfWeek.getValue() - 1;
        int nextMonthDaysToShow = (7 - ((prevMonthDaysToShow + daysInMonth) % 7)) % 7;

        ControladoraLogica control = new ControladoraLogica();
        List<Turno> todosTurnos = control.traerTodosLosTurnos();
    %>

    <div class="month" id="monthHeader">
        <ul>
            <li class="prev" onclick="location.href='calendario.jsp?month=<%= currentMonth - 1 %>&year=<%= currentYear %>'">&#10094;</li>
            <li class="next" onclick="location.href='calendario.jsp?month=<%= currentMonth + 1 %>&year=<%= currentYear %>'">&#10095;</li>
            <li id="monthTitle"><%= firstDayOfMonth.getMonth().getDisplayName(TextStyle.FULL, new Locale("es", "ES")) %> <br><span id="yearTitle" style="font-size:18px"><%= currentYear %></span></li>
        </ul>
    </div>

    <ul class="weekdays">
        <li>Lun</li>
        <li>Mar</li>
        <li>Mié</li>
        <li>Jue</li>
        <li>Vie</li>
        <li>Sáb</li>
        <li>Dom</li>
    </ul>

    <ul class="days" id="calendarDays">
        <%-- Días del mes anterior --%>
        <%
            for (int i = prevMonthDaysToShow; i > 0; i--) {
                int day = daysInPrevMonth - i + 1;
        %>
            <li class="other-month"><span class="day-number"><%= day %></span></li>
        <%
            }

            for (int i = 1; i <= daysInMonth; i++) {
                LocalDate currentDate = LocalDate.of(currentYear, currentMonth, i);
                boolean isToday = currentDate.equals(today);

                List<Turno> turnosDelDia = todosTurnos.stream()
                        .filter(t -> t.getFecha().equals(currentDate))
                        .collect(Collectors.toList());
        %>
            <li>
                <span class="day-number <%= isToday ? "active" : "" %>"><%= i %></span>
                <%
                    for (Turno turno : turnosDelDia) {
                        String claseEstado = turno.getEstado().toString().equalsIgnoreCase("ya_atendido") ? "turno-atendido" : "turno-espera";
                        String nombreCompleto = turno.getElCiudadano().getNombre() + " " + turno.getElCiudadano().getApellido();
                        String tramite = turno.getElTramite().getNombre();
                %>
                    <div class="turno-item <%= claseEstado %>" title="<%= nombreCompleto %>: <%= tramite %>">
                        <%= nombreCompleto %>: <%= tramite %>
                    </div>
                <%
                    }
                %>
            </li>
        <%
            }

            for (int i = 1; i <= nextMonthDaysToShow; i++) {
        %>
            <li class="other-month"><span class="day-number"><%= i %></span></li>
        <%
            }
        %>
    </ul>
</div>
</body>
</html>
