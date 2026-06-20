USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: JOINs aplicados al dominio
-- Semana 09 — INNER JOIN y LEFT JOIN
-- Dominio: Tienda de muebles / tienda de madera
-- Aprendiz: Jiselt Valentina Zambrano Ruiz
-- Motor: SQL Server / T-SQL
-- ============================================

-- Este archivo se debe ejecutar después del proyecto de la semana 07,
-- porque usa las tablas:
-- dbo.product_categories, dbo.products, dbo.materials, dbo.orders, dbo.deliveries

-- ============================================
-- VALIDACIÓN BÁSICA DEL ESQUEMA
-- ============================================
IF OBJECT_ID('dbo.products', 'U') IS NULL
BEGIN
    RAISERROR('Primero ejecuta week-07/proyecto.sql para crear las tablas del dominio.', 16, 1);
END;
GO

-- ============================================
-- COMPLEMENTO DE DATOS PARA JOINS
-- La guía de la semana 09 pide suficientes registros para que
-- los INNER JOIN y LEFT JOIN no sean triviales.
-- Se agregan productos hasta llegar a 80 filas y más datos hijos.
-- ============================================

DECLARE @i INT = 31;

WHILE @i <= 80
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE id = @i)
    BEGIN
        INSERT INTO dbo.products
        (id, sku, name, category_id, category, price, stock, material_preferred, notes, is_active)
        VALUES
        (
            @i,
            CONCAT('MUE-', RIGHT(CONCAT('000', @i), 3)),
            CONCAT('Producto madera ', @i),
            CASE
                WHEN @i % 5 = 0 THEN 5
                WHEN @i % 4 = 0 THEN 4
                WHEN @i % 3 = 0 THEN 3
                WHEN @i % 2 = 0 THEN 2
                ELSE 1
            END,
            CASE
                WHEN @i % 5 = 0 THEN 'Decoración'
                WHEN @i % 4 = 0 THEN 'Oficina'
                WHEN @i % 3 = 0 THEN 'Habitación'
                WHEN @i % 2 = 0 THEN 'Comedor'
                ELSE 'Sala'
            END,
            200000 + (@i * 15000),
            @i % 12,
            CASE WHEN @i % 7 = 0 THEN NULL ELSE 'Madera pino' END,
            CASE WHEN @i % 9 = 0 THEN NULL ELSE 'Registro agregado para joins' END,
            1
        );
    END;

    SET @i = @i + 1;
END;
GO

DECLARE @m INT = 7;

WHILE @m <= 20
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.materials WHERE id = @m)
    BEGIN
        INSERT INTO dbo.materials
        (id, material_code, name, type, supplier, unit_cost, stock)
        VALUES
        (
            @m,
            CONCAT('MAT-', RIGHT(CONCAT('000', @m), 3)),
            CONCAT('Material adicional ', @m),
            CASE
                WHEN @m % 4 = 0 THEN 'Herraje'
                WHEN @m % 3 = 0 THEN 'Acabado'
                WHEN @m % 2 = 0 THEN 'Tela'
                ELSE 'Madera'
            END,
            CASE WHEN @m % 5 = 0 THEN NULL ELSE CONCAT('Proveedor ', @m) END,
            10000 + (@m * 4500),
            10 + @m
        );
    END;

    SET @m = @m + 1;
END;
GO

DECLARE @o INT = 101;

WHILE @o <= 120
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.orders WHERE id = @o)
    BEGIN
        INSERT INTO dbo.orders
        (id, customer_name, customer_phone, product_id, quantity, order_status, order_date)
        VALUES
        (
            @o,
            CONCAT('Cliente prueba ', @o),
            CASE WHEN @o % 4 = 0 THEN NULL ELSE CONCAT('3000000', @o) END,
            @o - 100,
            CASE WHEN @o % 3 = 0 THEN 2 ELSE 1 END,
            CASE
                WHEN @o % 5 = 0 THEN 'Entregado'
                WHEN @o % 4 = 0 THEN 'En preparación'
                WHEN @o % 3 = 0 THEN 'Pagado'
                ELSE 'Pendiente'
            END,
            DATEADD(DAY, @o - 101, '2026-05-01')
        );
    END;

    SET @o = @o + 1;
END;
GO

DECLARE @d INT = 101;

WHILE @d <= 115
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.deliveries WHERE id = @d)
    BEGIN
        INSERT INTO dbo.deliveries
        (id, order_id, delivery_address, city, delivery_status, delivery_date)
        VALUES
        (
            @d,
            @d,
            CONCAT('Dirección prueba ', @d),
            CASE
                WHEN @d % 4 = 0 THEN 'Soacha'
                WHEN @d % 3 = 0 THEN 'Chía'
                ELSE 'Bogotá'
            END,
            CASE
                WHEN @d % 5 = 0 THEN 'Entregada'
                WHEN @d % 4 = 0 THEN 'En camino'
                ELSE 'Programada'
            END,
            DATEADD(DAY, @d - 100, '2026-05-01')
        );
    END;

    SET @d = @d + 1;
END;
GO

-- ============================================
-- CONSULTA 1: INNER JOIN principal
-- Productos que sí tienen pedidos registrados.
-- ============================================
SELECT
    p.id AS [ID producto],
    p.name AS [Producto],
    p.category AS [Categoría],
    o.id AS [ID pedido],
    o.customer_name AS [Cliente],
    o.quantity AS [Cantidad],
    o.order_status AS [Estado pedido],
    o.order_date AS [Fecha pedido]
FROM dbo.products AS p
INNER JOIN dbo.orders AS o
    ON o.product_id = p.id
ORDER BY o.id;
GO

-- ============================================
-- CONSULTA 2: JOIN con tres tablas
-- Productos + categorías + pedidos.
-- ============================================
SELECT
    p.id AS [ID producto],
    p.name AS [Producto],
    c.category_name AS [Categoría oficial],
    o.id AS [ID pedido],
    o.customer_name AS [Cliente],
    o.quantity AS [Cantidad],
    o.order_status AS [Estado pedido]
FROM dbo.products AS p
INNER JOIN dbo.product_categories AS c
    ON p.category_id = c.id
INNER JOIN dbo.orders AS o
    ON o.product_id = p.id
ORDER BY c.category_name, p.name;
GO

-- ============================================
-- CONSULTA 3: LEFT JOIN — todos los productos
-- Muestra todos los productos, incluso los que no tienen pedidos.
-- ============================================
SELECT
    p.id AS [ID producto],
    p.name AS [Producto],
    c.category_name AS [Categoría],
    o.id AS [ID pedido],
    COALESCE(o.order_status, 'Sin pedido') AS [Estado pedido]
FROM dbo.products AS p
INNER JOIN dbo.product_categories AS c
    ON p.category_id = c.id
LEFT JOIN dbo.orders AS o
    ON o.product_id = p.id
ORDER BY p.id;
GO

-- ============================================
-- CONSULTA 4: Detectar huérfanos
-- Productos sin pedidos registrados.
-- ============================================
SELECT
    p.id AS [ID producto],
    p.sku AS [Código],
    p.name AS [Producto sin pedido],
    p.category AS [Categoría],
    p.stock AS [Stock disponible]
FROM dbo.products AS p
LEFT JOIN dbo.orders AS o
    ON o.product_id = p.id
WHERE o.id IS NULL
ORDER BY p.id;
GO

-- ============================================
-- CONSULTA 5: Reporte agregado con LEFT JOIN + COUNT
-- Cantidad de pedidos por producto, incluyendo productos con 0 pedidos.
-- ============================================
SELECT
    p.id AS [ID producto],
    p.name AS [Producto],
    p.category AS [Categoría],
    COUNT(o.id) AS [Total pedidos],
    COALESCE(SUM(o.quantity), 0) AS [Unidades solicitadas],
    COALESCE(SUM(o.quantity * p.price), 0) AS [Valor estimado vendido]
FROM dbo.products AS p
LEFT JOIN dbo.orders AS o
    ON o.product_id = p.id
GROUP BY
    p.id,
    p.name,
    p.category
ORDER BY [Total pedidos] DESC, [Valor estimado vendido] DESC;
GO

-- ============================================
-- CONSULTA EXTRA: pedidos con o sin entrega
-- Refuerza LEFT JOIN usando orders como tabla padre.
-- ============================================
SELECT
    o.id AS [ID pedido],
    o.customer_name AS [Cliente],
    p.name AS [Producto],
    d.id AS [ID entrega],
    COALESCE(d.delivery_status, 'Sin entrega asignada') AS [Estado entrega]
FROM dbo.orders AS o
INNER JOIN dbo.products AS p
    ON o.product_id = p.id
LEFT JOIN dbo.deliveries AS d
    ON d.order_id = o.id
ORDER BY o.id;
GO
