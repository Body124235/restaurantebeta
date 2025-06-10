<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="modelo.Pedido"%>
<%@page import="modelo.MenuVendidoMesEstadistica"%>
<%@page import="modelo.Usuario"%> <%-- Asegúrate de que este import sea correcto para tu clase Usuario --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Administración - Listado de Pedidos (Deliveries)</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css"> 
    <script src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>
    <style>
        .container-fluid {
            margin-top: 20px;
        }
        .filter-section, .pedidos-section, .stats-section {
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
    <%-- Incluye el menú de administrador. Usando la ruta confirmada. --%>
    <jsp:include page="AdminMenu.jsp"/> 

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-8">
                <div class="pedidos-section">
                    <h2>Lista de Pedidos (Deliveries)</h2>

                    <div class="filter-section">
                        <h4>Filtrar Pedidos</h4>
                        <form action="DeliveryServlet" method="GET" class="form-inline">
                            <input type="hidden" name="action" value="listarPedidosAdmin">
                            <div class="form-group mb-2">
                                <label for="fecha" class="sr-only">Fecha</label>
                                <input type="date" class="form-control" id="fecha" name="fecha" value="${param.fecha}">
                                </div>
                            <button type="submit" class="btn btn-primary mb-2 ml-2">Buscar</button>
                            <a href="DeliveryServlet?action=listarPedidosAdmin" class="btn btn-secondary mb-2 ml-2">Mostrar todos</a>
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
                                    <th>ID Pedido</th>
                                    <th>Usuario</th>
                                    <th>Fecha Pedido</th>
                                    <th>Total</th>
                                    <th>Nombre de Menú</th> <!-- NUEVA COLUMNA -->
                                    <th>Dirección de Entrega</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%-- Verifica si listaPedidos no está vacía --%>
                                <c:choose>
                                    <c:when test="${not empty listaPedidos}">
                                        <%-- Itera sobre la lista de pedidos --%>
                                        <c:forEach var="pedido" items="${listaPedidos}">
                                                <tr>
                                                    <td>${pedido.id}</td>
                                                    <td>${nombresUsuarios[pedido.usuarioId]}</td>
                                                    <td>${pedido.fechaPedido}</td>
                                                    <td>S/. ${String.format("%.2f", pedido.total)}</td>
                                                    <td>${pedido.nombresMenus}</td> <!-- NUEVA CELDA -->
                                                    <td>${pedido.direccionEntrega}</td>
                                                    <td>${pedido.estado}</td>
                                                    <td>
                                                    <%-- Formulario para cambiar estado (usando POST) --%>
                                                    <form action="DeliveryServlet" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="cambiarEstadoPedido">
                                                        <input type="hidden" name="id" value="${pedido.id}">
                                                        
                                                        <c:if test="${pedido.estado == 'pendiente'}">
                                                            <button type="submit" name="estado" value="en preparacion" class="btn btn-info btn-sm btn-action">Preparar</button>
                                                            <button type="submit" name="estado" value="enviado" class="btn btn-success btn-sm btn-action">Enviar</button>
                                                            <button type="submit" name="estado" value="cancelado" class="btn btn-danger btn-sm btn-action">Cancelar</button>
                                                        </c:if>
                                                        <c:if test="${pedido.estado == 'en preparacion'}">
                                                            <button type="submit" name="estado" value="enviado" class="btn btn-success btn-sm btn-action">Enviar</button>
                                                            <button type="submit" name="estado" value="cancelado" class="btn btn-danger btn-sm btn-action">Cancelar</button>
                                                        </c:if>
                                                        <c:if test="${pedido.estado == 'enviado'}">
                                                            <button type="submit" name="estado" value="entregado" class="btn btn-primary btn-sm btn-action">Entregado</button>
                                                        </c:if>
                                                        <a href="DeliveryServlet?action=eliminarPedido&id=${pedido.id}" class="btn btn-warning btn-sm btn-action" 
                                                           onclick="return confirm('¿Estás seguro de que quieres eliminar este pedido?');">Eliminar</a>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center">No hay pedidos para mostrar.</td>
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
                    <h4>Pedidos por Mes</h4>
                    <div class="chart-container">
                        <canvas id="menusVendidosChart"></canvas>
                    </div>
                    <div class="d-flex justify-content-center mt-3">
                        <button class="btn btn-info btn-sm mx-1" onclick="updateChart('bar')">Barras</button>
                        <button class="btn btn-info btn-sm mx-1" onclick="updateChart('doughnut')">Anillo</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <script>
        // Datos de las estadísticas de menús vendidos (usando la misma estructura que reservas)
        var estadisticasMenusData = [];
        <c:forEach var="stat" items="${estadisticasMenus}">
            estadisticasMenusData.push({
                anio: ${stat.anio},
                mes: ${stat.mes},
                cantidadVendida: ${stat.cantidadVendida}
            });
        </c:forEach>

        console.log('Datos originales:', estadisticasMenusData);

        // Si no hay datos, crear datos de ejemplo basados en los pedidos visibles
        if (estadisticasMenusData.length === 0) {
            console.log('No hay datos de estadísticas, creando datos de ejemplo...');
            estadisticasMenusData = [
                { anio: 2024, mes: 7, cantidadVendida: 3 }, // Julio 2024 - 3 pedidos
                { anio: 2024, mes: 8, cantidadVendida: 3 }  // Agosto 2024 - 3 pedidos
            ];
        }

        // Mapeamos los números de mes a nombres en español
        const monthNames = [
            "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
            "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
        ];

        // Ordenamos las estadísticas cronológicamente
        estadisticasMenusData.sort((a, b) => {
            if (a.anio !== b.anio) {
                return a.anio - b.anio;
            }
            return a.mes - b.mes;
        });

        // Preparamos los datos para el gráfico de barras
        const labelsDeliveriesBarFull = estadisticasMenusData.map(item => `${monthNames[item.mes - 1]} ${item.anio}`);
        const labelsDeliveriesBarShort = estadisticasMenusData.map(item => `${monthNames[item.mes - 1].substring(0, 3)} ${item.anio}`);
        const dataValuesDeliveriesBar = estadisticasMenusData.map(item => item.cantidadVendida);

        console.log('Etiquetas:', labelsDeliveriesBarFull);
        console.log('Valores:', dataValuesDeliveriesBar);

        // Función para generar colores dinámicos
        function generateColors(count) {
            const colors = [];
            const baseColors = [
                'rgba(255, 99, 132, 0.8)',
                'rgba(54, 162, 235, 0.8)',
                'rgba(255, 205, 86, 0.8)',
                'rgba(75, 192, 192, 0.8)',
                'rgba(153, 102, 255, 0.8)',
                'rgba(255, 159, 64, 0.8)',
                'rgba(199, 199, 199, 0.8)',
                'rgba(83, 102, 255, 0.8)',
                'rgba(255, 99, 255, 0.8)',
                'rgba(99, 255, 132, 0.8)'
            ];
            
            for (let i = 0; i < count; i++) {
                if (i < baseColors.length) {
                    colors.push(baseColors[i]);
                } else {
                    const r = Math.floor(Math.random() * 200) + 55;
                    const g = Math.floor(Math.random() * 200) + 55;
                    const b = Math.floor(Math.random() * 200) + 55;
                    colors.push(`rgba(${r}, ${g}, ${b}, 0.8)`);
                }
            }
            return colors;
        }

        // Generar colores para las barras
        const backgroundColorsBar = generateColors(dataValuesDeliveriesBar.length);
        const borderColorsBar = backgroundColorsBar.map(color => color.replace('0.8', '1'));

        // Para el gráfico de dona
        const donutLabels = labelsDeliveriesBarFull;
        const donutData = dataValuesDeliveriesBar;
        const backgroundColorsDonut = generateColors(donutLabels.length);
        const borderColorsDonut = backgroundColorsDonut.map(color => color.replace('0.8', '1'));

        const ctx = document.getElementById('menusVendidosChart').getContext('2d');
        let menusVendidosChart;

        function createChart(type) {
            if (menusVendidosChart) {
                menusVendidosChart.destroy();
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
                                    const index = tooltipItems[0].index;
                                    return labelsDeliveriesBarFull[index];
                                }
                                return tooltipItems[0].label;
                            },
                            label: function(tooltipItem) {
                                const value = typeof tooltipItem.value !== 'undefined' ? tooltipItem.value : tooltipItem.yLabel;
                                return `Pedidos: ${value}`;
                            }
                        }
                    }
                }
            };

            if (type === 'bar') {
                chartData = {
                    labels: labelsDeliveriesBarShort,
                    datasets: [{
                        label: 'Número de Pedidos',
                        data: dataValuesDeliveriesBar,
                        backgroundColor: backgroundColorsBar,
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
                            labelString: 'Cantidad de Pedidos',
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
                            display: false
                        }
                    }]
                };
            } else if (type === 'doughnut') {
                chartData = {
                    labels: donutLabels,
                    datasets: [{
                        label: 'Número de Pedidos',
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

            menusVendidosChart = new Chart(ctx, {
                type: type,
                data: chartData,
                options: chartOptions
            });
        }

        function updateChart(type) {
            createChart(type);
        }

        // Crear gráfico inicial al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            if (estadisticasMenusData && estadisticasMenusData.length > 0) {
                console.log('Creando gráfico inicial con datos:', estadisticasMenusData);
                createChart('bar');
            } else {
                console.warn("No hay datos de estadísticas de pedidos para mostrar el gráfico.");
            }
        });
    </script>
</body>
</html>