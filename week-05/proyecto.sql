USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: Operadores y Filtros
-- Semana 05 — BETWEEN, IN, LIKE
-- Dominio: Tienda de muebles / tienda de madera
-- Aprendiz: Jiselt Valentina Zambrano Ruiz
-- ============================================

-- ============================================
-- CONSULTA 1: Filtro con BETWEEN
-- ============================================

SELECT
    id AS [ID Producto],
    name AS [Nombre del producto],
    category AS [Categoría],
    price AS [Precio],
    stock AS [Cantidad en inventario],
    is_active AS [Producto activo]
FROM dbo.products
WHERE price BETWEEN 100000 AND 2000000
ORDER BY price ASC;
GO

-- ============================================
-- CONSULTA 2: Filtro con IN
-- ============================================

SELECT
    id AS [ID Producto],
    name AS [Nombre del producto],
    category AS [Categoría],
    price AS [Precio],
    stock AS [Cantidad en inventario]
FROM dbo.products
WHERE id IN (1, 2, 3, 4)
ORDER BY id ASC;
GO

-- ============================================
-- CONSULTA 3: Búsqueda de texto con LIKE
-- ============================================

SELECT
    id AS [ID Producto],
    name AS [Nombre del producto],
    category AS [Categoría],
    price AS [Precio],
    stock AS [Cantidad en inventario]
FROM dbo.products
WHERE LOWER(name) LIKE '%madera%'
   OR LOWER(name) LIKE '%mesa%'
ORDER BY name ASC;
GO

-- ============================================
-- CONSULTA 4: Filtro combinado con BETWEEN, IN, LIKE y AND
-- ============================================

SELECT
    id AS [ID Producto],
    name AS [Nombre del producto],
    category AS [Categoría],
    price AS [Precio],
    stock AS [Cantidad en inventario],
    is_active AS [Producto activo]
FROM dbo.products
WHERE price BETWEEN 100000 AND 2500000
  AND id IN (1, 2, 3, 4, 5)
  AND (
        LOWER(name) LIKE '%madera%'
        OR LOWER(name) LIKE '%mesa%'
        OR LOWER(category) LIKE '%mueble%'
      )
  AND is_active = 1
ORDER BY price DESC;
GO

-- ============================================
-- CONSULTA EXTRA: Filtro aplicado a pedidos
-- ============================================

SELECT
    o.id AS [ID Pedido],
    o.customer_name AS [Cliente],
    p.name AS [Producto],
    o.quantity AS [Cantidad],
    o.order_status AS [Estado del pedido],
    o.order_date AS [Fecha del pedido]
FROM dbo.orders AS o
INNER JOIN dbo.products AS p
    ON o.product_id = p.id
WHERE o.quantity BETWEEN 1 AND 5
  AND o.order_status IN ('Pendiente', 'En proceso', 'Entregado', 'Pagado')
  AND (
        LOWER(p.name) LIKE '%madera%'
        OR LOWER(p.name) LIKE '%mesa%'
      )
ORDER BY o.order_date DESC;
GO