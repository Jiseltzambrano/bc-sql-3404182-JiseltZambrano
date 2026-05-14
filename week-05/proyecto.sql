-- ============================================
-- PROYECTO SEMANAL: Operadores y Filtros
-- Semana 05 — BETWEEN, IN, LIKE
-- Dominio: Tienda de muebles / tienda de madera
-- Aprendiz: Jiselt Valentina Zambrano Ruiz
-- ============================================

-- NOTA:
-- Usa el esquema cargado en la Semana 03.
-- Este archivo trabaja con las tablas:
-- products, materials, orders y deliveries.

-- ============================================
-- CONSULTA 1: Filtro con BETWEEN
-- ============================================
-- Objetivo:
-- Consultar productos de la tienda de madera cuyo precio
-- esté dentro de un rango determinado.

SELECT
    id AS "ID Producto",
    name AS "Nombre del producto",
    category AS "Categoría",
    price AS "Precio",
    stock AS "Cantidad en inventario",
    is_active AS "Producto activo"
FROM products
WHERE price BETWEEN 100000 AND 2000000
ORDER BY price ASC;


-- ============================================
-- CONSULTA 2: Filtro con IN
-- ============================================
-- Objetivo:
-- Consultar productos específicos de la tienda usando una lista
-- de identificadores.

SELECT
    id AS "ID Producto",
    name AS "Nombre del producto",
    category AS "Categoría",
    price AS "Precio",
    stock AS "Cantidad en inventario"
FROM products
WHERE id IN (1, 2, 3, 4)
ORDER BY id ASC;


-- ============================================
-- CONSULTA 3: Búsqueda de texto con LIKE
-- ============================================
-- Objetivo:
-- Buscar productos relacionados con madera o mesa dentro del nombre.

SELECT
    id AS "ID Producto",
    name AS "Nombre del producto",
    category AS "Categoría",
    price AS "Precio",
    stock AS "Cantidad en inventario"
FROM products
WHERE LOWER(name) LIKE '%madera%'
   OR LOWER(name) LIKE '%mesa%'
ORDER BY name ASC;


-- ============================================
-- CONSULTA 4: Filtro combinado (≥ 3 operadores)
-- ============================================
-- Objetivo:
-- Combinar BETWEEN, IN y LIKE para consultar productos activos,
-- con precio dentro de un rango, ciertos ids y coincidencia de texto.

SELECT
    id AS "ID Producto",
    name AS "Nombre del producto",
    category AS "Categoría",
    price AS "Precio",
    stock AS "Cantidad en inventario",
    is_active AS "Producto activo"
FROM products
WHERE price BETWEEN 100000 AND 2500000
  AND id IN (1, 2, 3, 4, 5)
  AND (
        LOWER(name) LIKE '%madera%'
        OR LOWER(name) LIKE '%mesa%'
        OR LOWER(category) LIKE '%mueble%'
      )
  AND is_active = 1
ORDER BY price DESC;


-- ============================================
-- CONSULTA EXTRA: Filtro aplicado a pedidos
-- ============================================
-- Esta consulta no es obligatoria, pero sirve para demostrar
-- filtros en una tabla relacionada del proyecto.

SELECT
    o.id AS "ID Pedido",
    o.customer_name AS "Cliente",
    p.name AS "Producto",
    o.quantity AS "Cantidad",
    o.order_status AS "Estado del pedido",
    o.order_date AS "Fecha del pedido"
FROM orders AS o
INNER JOIN products AS p
    ON o.product_id = p.id
WHERE o.quantity BETWEEN 1 AND 5
  AND o.order_status IN ('Pendiente', 'En proceso', 'Entregado')
  AND LOWER(p.name) LIKE '%madera%'
ORDER BY o.order_date DESC;