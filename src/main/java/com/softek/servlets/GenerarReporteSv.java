package com.softek.servlets;

import com.softek.logica.Ciudadano;
import com.softek.logica.ControladoraLogica;
import com.softek.logica.Tramite;
import com.softek.logica.Turno;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "GenerarReporteSv", urlPatterns = {"/GenerarReporteSv"})
public class GenerarReporteSv extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ControladoraLogica control = new ControladoraLogica();
        String tipoReporte = request.getParameter("tipoReporte");
        String action = request.getParameter("action");
        
        // Validación básica
        if (tipoReporte == null || tipoReporte.isEmpty()) {
            request.setAttribute("mensajeError", "Debe seleccionar un tipo de reporte");
            request.getRequestDispatcher("generarReportes.jsp").forward(request, response);
            return;
        }

        List<?> resultados = new ArrayList<>();
        
        try {
            // Procesar según el tipo de reporte
            switch (tipoReporte) {
                case "turnos":
                    resultados = procesarReporteTurnos(request, control);
                    break;
                case "tramites":
                    resultados = procesarReporteTramites(request, control);
                    break;
                case "ciudadanos":
                    resultados = procesarReporteCiudadanos(request, control);
                    break;
                default:
                    request.setAttribute("mensajeError", "Tipo de reporte no válido");
                    request.getRequestDispatcher("generarReportes.jsp").forward(request, response);
                    return;
            }

            // Manejar acción de exportación
            if ("exportar".equals(action)) {
                String formato = request.getParameter("formato");
                if ("csv".equalsIgnoreCase(formato)) {
                    exportarCSV(response, tipoReporte, resultados);
                    return;
                } else if ("html".equalsIgnoreCase(formato)) {
                    exportarHTML(response, tipoReporte, resultados);
                    return;
                }
            }

            // Mostrar resultados en JSP
            request.setAttribute("resultados", resultados);
            request.setAttribute("tipoReporte", tipoReporte);
            request.getRequestDispatcher("generarReportes.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error al generar el reporte: " + e.getMessage());
            request.getRequestDispatcher("generarReportes.jsp").forward(request, response);
        }
    }

    private List<Turno> procesarReporteTurnos(HttpServletRequest request, ControladoraLogica control) {
        String estadoTurno = request.getParameter("estadoTurno");
        String fechaDesdeStr = request.getParameter("fechaDesdeTurno");
        String fechaHastaStr = request.getParameter("fechaHastaTurno");

        List<Turno> resultados;

        // Filtrar por estado si se especificó
        if (estadoTurno != null && !estadoTurno.isEmpty()) {
            resultados = control.traerTurnosPorEstado(estadoTurno);
        } else {
            resultados = control.traerTodosLosTurnos();
        }

        // Filtrar por rango de fechas si se especificó
        if ((fechaDesdeStr != null && !fechaDesdeStr.isEmpty()) ||
            (fechaHastaStr != null && !fechaHastaStr.isEmpty())) {

            List<Turno> filtrados = new ArrayList<>();
            LocalDate desde = (fechaDesdeStr != null && !fechaDesdeStr.isEmpty()) ? 
                LocalDate.parse(fechaDesdeStr) : null;
            LocalDate hasta = (fechaHastaStr != null && !fechaHastaStr.isEmpty()) ? 
                LocalDate.parse(fechaHastaStr) : null;

            for (Turno t : resultados) {
                LocalDate fecha = t.getFecha();
                boolean incluir = true;
                if (desde != null && fecha.isBefore(desde)) incluir = false;
                if (hasta != null && fecha.isAfter(hasta)) incluir = false;
                if (incluir) filtrados.add(t);
            }

            return filtrados;
        }

        return resultados;
    }

    private List<Tramite> procesarReporteTramites(HttpServletRequest request, ControladoraLogica control) {
        String tipoTramite = request.getParameter("tipoTramite");
        List<Tramite> tramites = control.traerTodosLosTramites();

        // Filtrar por tipo de trámite si se especificó
        if (tipoTramite != null && !tipoTramite.isEmpty()) {
            List<Tramite> filtrados = new ArrayList<>();
            try {
                long id = Long.parseLong(tipoTramite);
                Tramite encontrado = control.buscarTramitePorId(id);
                if (encontrado != null) filtrados.add(encontrado);
            } catch (NumberFormatException e) {
                // Si hay error en el formato, no filtrar
                return tramites;
            }
            return filtrados;
        }

        return tramites;
    }

    private List<Ciudadano> procesarReporteCiudadanos(HttpServletRequest request, ControladoraLogica control) {
        String tipoDocumento = request.getParameter("tipoDocumento");
        List<Ciudadano> ciudadanos = control.traerTodosLosCiudadanos();

        // Filtrar por tipo de documento si se especificó
        if (tipoDocumento != null && !tipoDocumento.isEmpty()) {
            List<Ciudadano> filtrados = new ArrayList<>();
            for (Ciudadano c : ciudadanos) {
                String clave = c.getClaveIdentificacion();
                boolean coincide = false;
                if ("DNI".equals(tipoDocumento)) coincide = clave != null && clave.matches("\\d{8}");
                else if ("PASAPORTE".equals(tipoDocumento)) coincide = clave != null && clave.matches("[A-Z]\\d{7}");
                else if ("CEDULA".equals(tipoDocumento)) coincide = clave != null && clave.matches("[A-Z]-\\d{7}");
                if (coincide) filtrados.add(c);
            }
            return filtrados;
        }

        return ciudadanos;
    }

    private void exportarCSV(HttpServletResponse response, String tipo, List<?> datos) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=reporte_" + tipo + ".csv");

        PrintWriter writer = response.getWriter();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        switch (tipo) {
            case "turnos":
                writer.println("ID,Fecha,Ciudadano,Trámite,Estado");
                for (Object item : datos) {
                    Turno t = (Turno) item;
                    writer.printf("%d,%s,%s %s,%s,%s%n", 
                            t.getId(),
                            t.getFecha().format(dateFormatter),
                            t.getElCiudadano().getNombre(),
                            t.getElCiudadano().getApellido(),
                            t.getElTramite().getNombre(),
                            t.getEstado().toString());
                }
                break;
                
            case "tramites":
                writer.println("ID,Nombre,Descripción");
                for (Object item : datos) {
                    Tramite tr = (Tramite) item;
                    writer.printf("%d,%s,\"%s\"%n", 
                            tr.getId(),
                            tr.getNombre(),
                            tr.getDescripcion().replace("\"", "\"\""));
                }
                break;
                
            case "ciudadanos":
                writer.println("ID,Nombre,Apellido,Tipo Documento,Documento");
                for (Object item : datos) {
                    Ciudadano c = (Ciudadano) item;
                    String tipoDoc = determinarTipoDocumento(c.getClaveIdentificacion());
                    writer.printf("%d,%s,%s,%s,%s,%s%n", 
                            c.getId(),
                            c.getNombre(),
                            c.getApellido(),
                            tipoDoc,
                            c.getClaveIdentificacion());
                }
                break;
        }
        writer.flush();
    }

    private void exportarHTML(HttpServletResponse response, String tipo, List<?> datos) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Reporte de " + tipo + "</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
        out.println("h1 { color: #006400; }");
        out.println("table { border-collapse: collapse; width: 100%; margin-top: 20px; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #006400; color: white; }");
        out.println("tr:nth-child(even) { background-color: #f2f2f2; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.printf("<h1>Reporte de %s</h1>", tipo.toUpperCase());
        out.println("<table>");

        switch (tipo) {
            case "turnos":
                out.println("<tr><th>ID</th><th>Fecha</th><th>Ciudadano</th><th>Trámite</th><th>Estado</th></tr>");
                for (Object item : datos) {
                    Turno t = (Turno) item;
                    out.printf("<tr><td>%d</td><td>%s</td><td>%s %s</td><td>%s</td><td>%s</td></tr>",
                            t.getId(),
                            t.getFecha().format(dateFormatter),
                            t.getElCiudadano().getNombre(),
                            t.getElCiudadano().getApellido(),
                            t.getElTramite().getNombre(),
                            t.getEstado().toString());
                }
                break;
                
            case "tramites":
                out.println("<tr><th>ID</th><th>Nombre</th><th>Descripción</th></tr>");
                for (Object item : datos) {
                    Tramite tr = (Tramite) item;
                    out.printf("<tr><td>%d</td><td>%s</td><td>%s</td></tr>",
                            tr.getId(),
                            tr.getNombre(),
                            tr.getDescripcion());
                }
                break;
                
            case "ciudadanos":
                out.println("<tr><th>ID</th><th>Nombre</th><th>Apellido</th><th>Tipo Documento</th><th>Documento</th><th>Teléfono</th></tr>");
                for (Object item : datos) {
                    Ciudadano c = (Ciudadano) item;
                    String tipoDoc = determinarTipoDocumento(c.getClaveIdentificacion());
                    out.printf("<tr><td>%d</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
                            c.getId(),
                            c.getNombre(),
                            c.getApellido(),
                            tipoDoc,
                            c.getClaveIdentificacion());
                }
                break;
        }

        out.println("</table>");
        out.println("</body>");
        out.println("</html>");
    }

    private String determinarTipoDocumento(String clave) {
        if (clave == null) return "DESCONOCIDO";
        if (clave.matches("\\d{8}")) return "DNI";
        if (clave.matches("[A-Z]\\d{7}")) return "PASAPORTE";
        if (clave.matches("[A-Z]-\\d{7}")) return "CEDULA";
        return "OTRO";
    }

    @Override
    public String getServletInfo() {
        return "Servlet para generar reportes y exportar a CSV/HTML";
    }
}