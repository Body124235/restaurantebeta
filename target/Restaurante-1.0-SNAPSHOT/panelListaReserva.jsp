<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="modelo.Reserva"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.ReservaMesEstadistica"%> <%-- ¡Nueva importación! --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - Listado de Reservas</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css"> <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script> <style>
        .container-fluid {
            margin-top: 20px;
        }
        .filter-section, .reservas-section, .stats-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .table-responsive {
            margin-top: 15px;
        }
        .btn-action {
            margin-right: 5px;
        }
        .chart-container {
            position: relative;
            height: 400px; /* Altura fija para el gráfico */
            width: 100%;
        }
        .col-md-8, .col-md-4 {
            padding: 10px; /* Añadir un poco de padding entre las columnas */
        }
    </style>
</head>
<body>
    <%-- Incluye el menú de administrador --%>
    <jsp:include page="AdminMenu.jsp"/>

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-8">
                <div class="reservas-section">
                    <h2>Lista de Reservas</h2>

                    <div class="filter-section">
                        <h4>Filtrar Reservas</h4>
                        <form action="ReservaServlet" method="GET" class="form-inline">
                            <input type="hidden" name="action" value="listarReservasAdmin">
                            <div class="form-group mb-2">
                                <label for="fecha" class="sr-only">Fecha</label>
                                <input type="text" class="form-control" id="fecha" name="fecha"
                                       placeholder="dd/MM/yyyy"
                                       value="${param.fecha != null ? param.fecha : ''}">
                            </div>
                            <button type="submit" class="btn btn-primary mb-2 ml-2">Buscar</button>
                            <a href="ReservaServlet?action=listarReservasAdmin" class="btn btn-secondary mb-2 ml-2">Mostrar todas</a>
                        </form>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-2" role="alert">
                                ${error}
                            </div>
                        </c:if>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="thead-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Fecha</th>
                                    <th>Hora</th>
                                    <th>Personas</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty listaReservas}">
                                        <c:forEach var="reserva" items="${listaReservas}">
                                            <tr>
                                                <td>${reserva.id}</td>
                                                <%-- Accede al nombre del usuario usando el mapa --%>
                                                <td>${nombresUsuarios[reserva.usuarioId]}</td>
                                                <td>${reserva.fechaReserva}</td>
                                                <td>${reserva.horaReserva}</td>
                                                <td>${reserva.numPersonas}</td>
                                                <td>${reserva.estado}</td>
                                                <td>
                                                    <%-- Formulario para cambiar estado (usando POST) --%>
                                                    <form action="ReservaServlet" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="cambiarEstadoReserva">
                                                        <input type="hidden" name="id" value="${reserva.id}">

                                                        <c:if test="${reserva.estado == 'pendiente'}">
                                                            <button type="submit" name="estado" value="confirmada" class="btn btn-success btn-sm btn-action">Confirmar</button>
                                                            <button type="submit" name="estado" value="cancelada" class="btn btn-danger btn-sm btn-action">Cancelar</button>
                                                        </c:if>
                                                        <c:if test="${reserva.estado == 'confirmada'}">
                                                            <button type="submit" name="estado" value="finalizada" class="btn btn-primary btn-sm btn-action">Finalizar</button>
                                                            <button type="submit" name="estado" value="cancelada" class="btn btn-danger btn-sm btn-action">Cancelar</button>
                                                        </c:if>
                                                        <a href="ReservaServlet?action=eliminarReserva&id=${reserva.id}" class="btn btn-warning btn-sm btn-action"
                                                           onclick="return confirm('¿Estás seguro de que quieres eliminar esta reserva?');">Eliminar</a>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center">No hay reservas para mostrar.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stats-section">
                    <h4>Estadísticas de Reservas por Mes</h4>
                    <div class="chart-container">
                        <canvas id="reservasChart"></canvas>
                    </div>
                     <div class="d-flex justify-content-center mt-3">
                        <button class="btn btn-info btn-sm mx-1" onclick="updateChart('bar')">Barras</button>
                        <button class="btn btn-info btn-sm mx-1" onclick="updateChart('doughnut')">Anillo</button>
                    </div>
                    <c:if test="${not empty errorEstadisticas}">
                        <div class="alert alert-warning mt-3" role="alert">
                            ${errorEstadisticas}
                        </div>
                    </c:if>
                     <c:if test="${empty reservasEstadisticasMensuales || reservasEstadisticasMensuales.size() == 0}">
                        <div class="alert alert-info mt-3" role="alert">
                            No hay datos de reservas para mostrar estadísticas.
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        // Datos de las estadísticas de reservas obtenidos del servidor
var estadisticasReservasData = [];
<c:forEach var="stat" items="${reservasEstadisticasMensuales}">
    estadisticasReservasData.push({
        anio: ${stat.anio},
        mes: ${stat.mes},
        cantidadReservas: ${stat.cantidadReservas}
    });
</c:forEach>

// Mapeamos los números de mes a nombres en español
const monthNames = [
    "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
];

// Ordenamos las estadísticas cronológicamente para el gráfico de barras
estadisticasReservasData.sort((a, b) => {
    if (a.anio !== b.anio) {
        return a.anio - b.anio;
    }
    return a.mes - b.mes;
});

// Preparamos los datos para el gráfico de barras
// Las etiquetas completas para el tooltip y la leyenda
const labelsReservasBarFull = estadisticasReservasData.map(item => `${monthNames[item.mes - 1]} ${item.anio}`);
// Las etiquetas para el eje X (mes y año para mayor claridad)
const labelsReservasBarShort = estadisticasReservasData.map(item => `${monthNames[item.mes - 1].substring(0, 3)} ${item.anio}`);
const dataValuesReservasBar = estadisticasReservasData.map(item => item.cantidadReservas);

// Función para generar colores dinámicos y atractivos
function generateColors(count) {
    const colors = [];
    const baseColors = [
        'rgba(255, 99, 132, 0.8)',   // Rosa
        'rgba(54, 162, 235, 0.8)',   // Azul
        'rgba(255, 205, 86, 0.8)',   // Amarillo
        'rgba(75, 192, 192, 0.8)',   // Verde agua
        'rgba(153, 102, 255, 0.8)',  // Púrpura
        'rgba(255, 159, 64, 0.8)',   // Naranja
        'rgba(199, 199, 199, 0.8)',  // Gris
        'rgba(83, 102, 255, 0.8)',   // Azul índigo
        'rgba(255, 99, 255, 0.8)',   // Magenta
        'rgba(99, 255, 132, 0.8)',   // Verde claro
        'rgba(255, 206, 84, 0.8)',   // Dorado
        'rgba(54, 235, 162, 0.8)'    // Verde menta
    ];
    
    for (let i = 0; i < count; i++) {
        if (i < baseColors.length) {
            colors.push(baseColors[i]);
        } else {
            // Si necesitamos más colores, generamos algunos aleatorios
            const r = Math.floor(Math.random() * 200) + 55; // Entre 55-255 para evitar colores muy oscuros
            const g = Math.floor(Math.random() * 200) + 55;
            const b = Math.floor(Math.random() * 200) + 55;
            colors.push(`rgba(${r}, ${g}, ${b}, 0.8)`);
        }
    }
    return colors;
}

// Generar colores para las barras
const backgroundColorsBar = generateColors(dataValuesReservasBar.length);
const borderColorsBar = backgroundColorsBar.map(color => color.replace('0.8', '1'));

// Para el gráfico de dona
const donutLabels = labelsReservasBarFull;
const donutData = dataValuesReservasBar;
const backgroundColorsDonut = generateColors(donutLabels.length);
const borderColorsDonut = backgroundColorsDonut.map(color => color.replace('0.8', '1'));

const ctxReservas = document.getElementById('reservasChart').getContext('2d');
let reservasChart; // Variable para mantener la instancia del gráfico

function createChart(type) {
    if (reservasChart) {
        reservasChart.destroy(); // Destruye el gráfico existente antes de crear uno nuevo
    }

    let chartData;
    let chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                position: 'top',
            },
            tooltip: {
                callbacks: {
                    title: function(tooltipItems) {
                        if (type === 'bar') {
                            // Para barras, mostramos el mes y año completo en el título del tooltip
                            const index = tooltipItems[0].dataIndex;
                            return labelsReservasBarFull[index];
                        }
                        return tooltipItems[0].label;
                    },
                    label: function(tooltipItem) {
                        const value = typeof tooltipItem.raw !== 'undefined' ? tooltipItem.raw : tooltipItem.value;
                        return `Reservas: ${value}`;
                    }
                }
            }
        }
    };

    if (type === 'bar') {
        chartData = {
            labels: labelsReservasBarShort, // Etiquetas cortas pero más descriptivas
            datasets: [{
                label: 'Número de Reservas',
                data: dataValuesReservasBar,
                backgroundColor: backgroundColorsBar, // Colores diferentes para cada barra
                borderColor: borderColorsBar,
                borderWidth: 2,
                hoverBackgroundColor: backgroundColorsBar.map(color => color.replace('0.8', '0.9')),
                hoverBorderColor: borderColorsBar,
                hoverBorderWidth: 3
            }]
        };
        chartOptions.scales = {
            yAxes: [{
                ticks: {
                    beginAtZero: true,
                    stepSize: 1,
                    callback: function(value) {
                        if (value % 1 === 0) {
                            return value;
                        }
                    }
                },
                scaleLabel: {
                    display: true,
                    labelString: 'Cantidad de Reservas',
                    fontSize: 12,
                    fontStyle: 'bold'
                },
                gridLines: {
                    color: 'rgba(0, 0, 0, 0.1)',
                    lineWidth: 1
                }
            }],
            xAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: 'Periodo',
                    fontSize: 12,
                    fontStyle: 'bold'
                },
                ticks: {
                    autoSkip: false,
                    maxRotation: 45,
                    minRotation: 45,
                    fontSize: 10
                },
                gridLines: {
                    display: false // Ocultar líneas de cuadrícula verticales para mayor claridad
                }
            }]
        };
    } else if (type === 'doughnut') {
        chartData = {
            labels: donutLabels,
            datasets: [{
                label: 'Número de Reservas',
                data: donutData,
                backgroundColor: backgroundColorsDonut,
                borderColor: borderColorsDonut,
                borderWidth: 2,
                hoverBackgroundColor: backgroundColorsDonut.map(color => color.replace('0.8', '0.9')),
                hoverBorderColor: borderColorsDonut,
                hoverBorderWidth: 3
            }]
        };
        chartOptions.scales = {};
        chartOptions.plugins.legend = {
            display: true,
            position: 'right',
            labels: {
                boxWidth: 15,
                fontSize: 10,
                padding: 10,
                usePointStyle: true
            }
        };
    }

    reservasChart = new Chart(ctxReservas, {
        type: type,
        data: chartData,
        options: chartOptions
    });
}

// Función para actualizar el tipo de gráfico
function updateChart(type) {
    createChart(type);
}

// Crea el gráfico inicial al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    if (estadisticasReservasData && estadisticasReservasData.length > 0) {
        createChart('bar');
    } else {
        console.warn("No hay datos de estadísticas de reservas para mostrar el gráfico.");
    }
});
    </script>
</body>
</html>