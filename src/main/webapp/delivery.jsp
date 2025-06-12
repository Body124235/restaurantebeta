<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuestro Menú para Delivery - Restaurante</title>
    
    <style>
        /* CSS para el Layout General y Ajustes */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .delivery-container {
            width: 95%; /* Ajusta según necesites para acercarlo al borde */
            margin: 20px auto; /* Centrado, pero con más ancho */
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        /* Contenedor principal para el sidebar y los productos */
        .content-wrapper {
            display: flex; /* Usa flexbox para el diseño lado a lado */
            gap: 30px; /* Espacio entre el sidebar y los productos */
        }

        /* Sidebar de Filtros */
        .filters-sidebar {
            flex: 0 0 250px; /* Ancho fijo para el sidebar, ajusta si es necesario */
            padding-right: 20px; /* Espacio con los productos */
            border-right: 1px solid #eee; /* Separador opcional */
        }

        .filters-sidebar h3 {
            color: #555;
            margin-top: 0;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .search-filter input[type="text"] {
            width: calc(100% - 18px); /* Ancho completo menos padding/border */
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .search-filter button,
        .filters-sidebar button {
            background-color: #4CAF50;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9em;
            margin-top: 5px;
            margin-right: 5px;
        }

        .search-filter button:hover,
        .filters-sidebar button:hover {
            background-color: #45a049;
        }

        .categories-filter ul {
            list-style: none;
            padding: 0;
        }

        .categories-filter li {
            margin-bottom: 10px;
        }

        .category-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }

        .subcategories {
            list-style: none;
            padding-left: 15px; /* Indenta las subcategorías */
            margin-top: 5px;
        }

        .subcategories label {
            display: block; /* Cada checkbox en su propia línea */
            margin-bottom: 5px;
            cursor: pointer;
        }

        .subcategories input[type="checkbox"] {
            margin-right: 8px;
        }

        /* Área Principal de la Cuadrícula de Productos del Menú */
        .menu-products {
            flex-grow: 1; /* Ocupa el espacio restante */
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 4 columnas por fila */
            gap: 20px; /* Espacio entre los elementos del producto */
        }

        .product-item {
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .product-image {
            width: 100%;
            height: 120px; /* Altura fija para tamaño de imagen consistente */
            background-color: #e0e0e0; /* Marcador de posición para imagen */
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 10px;
            color: #888;
            font-size: 0.9em;
        }

        .product-item h3 {
            margin: 10px 0;
            color: #333;
            font-size: 1.1em;
        }

        .product-item .price {
            font-size: 1.2em;
            color: #ff5722; /* Color naranja para el precio */
            font-weight: bold;
            margin-bottom: 10px;
        }

        .quantity-control {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 10px;
        }

        .quantity-control input[type="number"] {
            width: 50px;
            padding: 5px;
            text-align: center;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin-right: 5px;
        }

        .add-to-cart {
            background-color: #007bff;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9em;
        }

        .add-to-cart:hover {
            background-color: #0056b3;
        }

        .add-to-cart.sold-out-btn {
            background-color: #dc3545; /* Rojo para el botón "Agotado" */
            cursor: not-allowed;
        }

        .availability {
            font-size: 0.85em;
            color: #666;
        }

        .sold-out {
            font-size: 0.85em;
            color: #dc3545;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <jsp:include page="UserMenu.jsp" />

    <main class="delivery-container">
        <h1>Nuestro Menú para Delivery</h1>

        <div class="content-wrapper">
            <aside class="filters-sidebar">
                <div class="search-filter">
                    <h3>Buscar Menú</h3>
                    <input type="text" id="menuSearchInput" placeholder="Buscar por nombre...">
                    <button onclick="applyFilters()">Buscar</button>
                </div>

                <div class="categories-filter">
                    <h3>Categorías </h3>
                    <ul id="categoryList">
                        <li>
                            <p class="category-title">Entradas / Aperitivos</p>
                            <ul class="subcategories">
                                <li><label><input type="checkbox" name="subcategory" value="Empanadas"> Empanadas</label></li>
                                <li><label><input type="checkbox" name="subcategory" value="Bruschettas"> Bruschettas</label></li>
                            </ul>
                        </li>
                        <li>
                            <p class="category-title">Platos Principales</p>
                            <ul class="subcategories">
                                <li><label><input type="checkbox" name="subcategory" value="Hamburguesas"> Hamburguesas</label></li>
                                <li><label><input type="checkbox" name="subcategory" value="Pizzas"> Pizzas</label></li>
                                <li><label><input type="checkbox" name="subcategory" value="Ensaladas"> Ensaladas</label></li>
                            </ul>
                        </li>
                         <li>
                            <p class="category-title">Postres</p>
                            <ul class="subcategories">
                                <li><label><input type="checkbox" name="subcategory" value="Tortas"> Tortas</label></li>
                                <li><label><input type="checkbox" name="subcategory" value="Helados"> Helados</label></li>
                            </ul>
                        </li>
                        <li>
                            <p class="category-title">Bebidas</p>
                            <ul class="subcategories">
                                <li><label><input type="checkbox" name="subcategory" value="BebidasSinAlcohol"> Bebidas sin alcohol</label></li>
                                <li><label><input type="checkbox" name="subcategory" value="BebidasConAlcohol"> Bebidas con alcohol</label></li>
                            </ul>
                        </li>
                        </ul>
                    <button onclick="applyFilters()">Aplicar Filtros</button>
                    <button onclick="clearFilters()">Limpiar Filtros</button>
                </div>
            </aside>

            <section class="menu-products">
                <div id="productList" class="product-grid">
                    <div class="product-item">
                        <div class="product-image">[IMAGEN HAMBURGUESA]</div>
                        <h3>Hamburguesa Clásica</h3>
                        <p class="price">S/ 25.00</p>
                        <div class="quantity-control">
                            <input type="number" value="1" min="1">
                            <button class="add-to-cart">Agregar</button>
                        </div>
                        <p class="availability">Disponibles: 10</p>
                    </div>
                    <div class="product-item">
                        <div class="product-image">[IMAGEN PIZZA]</div>
                        <h3>Pizza Pepperoni</h3>
                        <p class="price">S/ 45.50</p>
                        <div class="quantity-control">
                            <input type="number" value="1" min="1">
                            <button class="add-to-cart">Agregar</button>
                        </div>
                        <p class="availability">Disponibles: 5</p>
                    </div>
                    <div class="product-item">
                        <div class="product-image">[IMAGEN ENSALADA]</div>
                        <h3>Ensalada César</h3>
                        <p class="price">S/ 20.00</p>
                        <p class="sold-out">¡AGOTADO!</p>
                        <button class="add-to-cart sold-out-btn" disabled>Agotado</button>
                    </div>
                    <div class="product-item">
                        <div class="product-image">[IMAGEN DE OTRO PRODUCTO]</div>
                        <h3>Otro Producto</h3>
                        <p class="price">S/ 15.00</p>
                        <div class="quantity-control">
                            <input type="number" value="1" min="1">
                            <button class="add-to-cart">Agregar</button>
                        </div>
                        <p class="availability">Disponibles: 20</p>
                    </div>
                    </div>
            </section>
        </div>
    </main>

    <script>
        function applyFilters() {
            const selectedSubcategories = Array.from(document.querySelectorAll('input[name="subcategory"]:checked'))
                                                .map(checkbox => checkbox.value);
            const searchQuery = document.getElementById('menuSearchInput').value;

            console.log("Subcategorías seleccionadas:", selectedSubcategories);
            console.log("Búsqueda de menú:", searchQuery);

           
        }

        function clearFilters() {
            document.querySelectorAll('input[name="subcategory"]:checked').forEach(checkbox => {
                checkbox.checked = false;
            });
            document.getElementById('menuSearchInput').value = '';
            applyFilters();
        }

        document.addEventListener('DOMContentLoaded', applyFilters);
    </script>
</body>
</html>