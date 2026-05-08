-- ============================================
-- PROYECTO SEMANAL: Consultas SELECT
-- Semana 04 — SELECT, WHERE, ORDER BY, LIMIT/OFFSET
-- ============================================
-- Dominio: Tienda de muebles
-- Tabla principal: products
-- Tablas relacionadas: materials, orders, deliveries
-- ============================================

-- ============================================
-- CONSULTA 1: Listado general con columnas explícitas
-- ============================================
-- Lista al menos 4 columnas de la entidad principal
-- usando alias en español para cada columna

SELECT
    id        AS "Código del producto",
    name      AS "Nombre del producto",
    category  AS "Categoría",
    price     AS "Precio",
    stock     AS "Cantidad disponible"
FROM products;


-- ============================================
-- CONSULTA 2: Filtro por condición simple
-- ============================================
-- Filtrar productos que pertenecen a una categoría específica

SELECT
    id       AS "Código",
    name     AS "Producto",
    category AS "Categoría",
    price    AS "Precio"
FROM products
WHERE category = 'Sala';


-- ============================================
-- CONSULTA 3: Filtro combinado AND
-- ============================================
-- Mostrar productos activos que tengan stock disponible

SELECT
    id        AS "Código",
    name      AS "Producto",
    category  AS "Categoría",
    price     AS "Precio",
    stock     AS "Stock"
FROM products
WHERE is_active = 1
  AND stock > 0;


-- ============================================
-- CONSULTA 4: Top-N con ORDER BY + LIMIT
-- ============================================
-- Recuperar los 5 productos más costosos de la tienda

SELECT
    id       AS "Código",
    name     AS "Producto",
    category AS "Categoría",
    price    AS "Precio"
FROM products
ORDER BY price DESC;


-- ============================================
-- CONSULTA 5: Paginación
-- Página 1 y Página 2
-- ============================================
-- Implementar 2 páginas de 3 registros cada una
-- ordenados alfabéticamente por nombre del producto

-- Página 1
SELECT
    id       AS "Código",
    name     AS "Producto",
    category AS "Categoría",
    price    AS "Precio",
    stock    AS "Stock"
FROM products
ORDER BY name ASC;


-- Página 2
SELECT
    id       AS "Código",
    name     AS "Producto",
    category AS "Categoría",
    price    AS "Precio",
    stock    AS "Stock"
FROM products
ORDER BY name ASC;
