USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: Funciones de Agregación
-- Semana 06 — COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING
-- Dominio: Tienda de muebles / tienda de madera
-- Aprendiz: Jiselt Valentina Zambrano Ruiz
-- ============================================

-- NOTA:
-- Antes de ejecutar este archivo, debes haber ejecutado:
-- Semana 02: creación de tablas
-- Semana 03: inserción de datos
--
-- Tablas usadas:
-- dbo.products
-- dbo.materials
-- dbo.orders
-- dbo.deliveries

-- ============================================
-- REPORTE 1: Totales globales
-- ============================================
-- Objetivo:
-- Calcular el total de productos registrados, el inventario total,
-- el valor total estimado del inventario y el precio promedio.

SELECT
    COUNT(*) AS [Total de productos],
    SUM(stock) AS [Inventario total],
    SUM(price * stock) AS [Valor total del inventario],
    AVG(CAST(price AS DECIMAL(18,2))) AS [Precio promedio]
FROM dbo.products;
GO


-- ============================================
-- REPORTE 2: Valores extremos
-- ============================================
-- Objetivo:
-- Identificar el producto con precio mínimo, precio máximo,
-- menor stock y mayor stock.

SELECT
    MIN(price) AS [Precio mínimo],
    MAX(price) AS [Precio máximo],
    MIN(stock) AS [Stock mínimo],
    MAX(stock) AS [Stock máximo]
FROM dbo.products;
GO


-- ============================================
-- REPORTE 3: Subtotales por categoría
-- ============================================
-- Objetivo:
-- Agrupar los productos por categoría y calcular cuántos productos
-- hay en cada una, su inventario total y su precio promedio.

SELECT
    category AS [Categoría],
    COUNT(*) AS [Cantidad de productos],
    SUM(stock) AS [Stock total por categoría],
    SUM(price * stock) AS [Valor inventario por categoría],
    AVG(CAST(price AS DECIMAL(18,2))) AS [Precio promedio],
    MIN(price) AS [Precio más bajo],
    MAX(price) AS [Precio más alto]
FROM dbo.products
GROUP BY category
ORDER BY [Valor inventario por categoría] DESC;
GO


-- ============================================
-- REPORTE 4: Filtro de grupos con HAVING
-- ============================================
-- Objetivo:
-- Mostrar solo las categorías cuyo inventario total sea mayor
-- o igual a 4 unidades.

SELECT
    category AS [Categoría],
    COUNT(*) AS [Cantidad de productos],
    SUM(stock) AS [Stock total],
    AVG(CAST(price AS DECIMAL(18,2))) AS [Precio promedio]
FROM dbo.products
GROUP BY category
HAVING SUM(stock) >= 4
ORDER BY [Stock total] DESC;
GO


-- ============================================
-- REPORTE 5: Resumen de pedidos por estado
-- ============================================
-- Objetivo:
-- Agrupar los pedidos por estado y calcular cantidad de pedidos,
-- unidades solicitadas y valor estimado de ventas.

SELECT
    o.order_status AS [Estado del pedido],
    COUNT(o.id) AS [Cantidad de pedidos],
    SUM(o.quantity) AS [Unidades solicitadas],
    SUM(o.quantity * p.price) AS [Valor estimado de ventas],
    AVG(CAST(o.quantity AS DECIMAL(18,2))) AS [Promedio de unidades por pedido]
FROM dbo.orders AS o
INNER JOIN dbo.products AS p
    ON o.product_id = p.id
GROUP BY o.order_status
ORDER BY [Valor estimado de ventas] DESC;
GO


-- ============================================
-- REPORTE 6: Productos con pedidos registrados
-- ============================================
-- Objetivo:
-- Consultar cuántas veces fue pedido cada producto y el valor
-- estimado generado por producto.

SELECT
    p.name AS [Producto],
    p.category AS [Categoría],
    COUNT(o.id) AS [Cantidad de pedidos],
    SUM(o.quantity) AS [Unidades vendidas],
    SUM(o.quantity * p.price) AS [Valor estimado vendido]
FROM dbo.products AS p
INNER JOIN dbo.orders AS o
    ON p.id = o.product_id
GROUP BY
    p.name,
    p.category
HAVING SUM(o.quantity) >= 1
ORDER BY [Valor estimado vendido] DESC;
GO


-- ============================================
-- REPORTE 7: Costos de materiales por tipo
-- ============================================
-- Objetivo:
-- Agrupar los materiales por tipo y calcular el costo promedio,
-- costo mínimo, costo máximo y stock total de materiales.

SELECT
    type AS [Tipo de material],
    COUNT(*) AS [Cantidad de materiales],
    SUM(stock) AS [Stock total de materiales],
    AVG(CAST(cost AS DECIMAL(18,2))) AS [Costo promedio],
    MIN(cost) AS [Costo mínimo],
    MAX(cost) AS [Costo máximo]
FROM dbo.materials
GROUP BY type
ORDER BY [Costo promedio] DESC;
GO


-- ============================================
-- REPORTE 8: Entregas por ciudad
-- ============================================
-- Objetivo:
-- Agrupar las entregas por ciudad y calcular cuántas entregas
-- hay registradas por cada una.

SELECT
    city AS [Ciudad],
    COUNT(*) AS [Cantidad de entregas]
FROM dbo.deliveries
GROUP BY city
HAVING COUNT(*) >= 1
ORDER BY [Cantidad de entregas] DESC;
GO