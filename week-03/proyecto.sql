-- ============================================
-- PROYECTO SEMANAL: DML — Manipulación de Datos
-- Semana 03 — INSERT INTO, UPDATE, DELETE
-- ============================================
-- Dominio asignado: Tienda de muebles
-- Entidades principales: products, materials, orders, deliveries
-- ============================================



-- ============================================
-- PARTE 1: INSERT INTO
-- ============================================

-- Tabla padre: products
INSERT INTO products (id, name, category, price, stock, is_active) VALUES
(1, 'Sofá moderno', 'Sala', 1200000, 5, 1),
(2, 'Mesa de comedor', 'Comedor', 850000, 3, 1),
(3, 'Cama doble', 'Habitación', 950000, 4, 1),
(4, 'Silla ergonómica', 'Oficina', 420000, 8, 1),
(5, 'Biblioteca de madera', 'Estudio', 690000, 2, 1);

-- Tabla independiente: materials
INSERT INTO materials (id, name, type, supplier, unit_cost) VALUES
(1, 'Madera roble', 'Madera', 'Maderas del Norte', 150000),
(2, 'Tela lino', 'Tela', 'Textiles Colombia', 80000),
(3, 'Espuma alta densidad', 'Relleno', 'Espumas SAS', 60000),
(4, 'Tornillos industriales', 'Herraje', 'Ferretería Central', 12000),
(5, 'Barniz natural', 'Acabado', 'Pinturas Bogotá', 35000);

-- Tabla hija: orders
-- Cada product_id existe en products
INSERT INTO orders (id, customer_name, product_id, quantity, order_status, order_date) VALUES
(1, 'Carlos Pérez', 1, 1, 'Pendiente', '2026-04-01'),
(2, 'Laura Gómez', 2, 2, 'Pagado', '2026-04-02'),
(3, 'Andrés Rodríguez', 3, 1, 'En preparación', '2026-04-03'),
(4, 'María Torres', 4, 3, 'Pagado', '2026-04-04'),
(5, 'Camila Rojas', 5, 1, 'Entregado', '2026-04-05');

-- Tabla hija: deliveries
-- Cada order_id existe en orders
INSERT INTO deliveries (id, order_id, delivery_address, city, delivery_status, delivery_date) VALUES
(1, 1, 'Calle 10 # 15-20', 'Bogotá', 'Programada', '2026-04-06'),
(2, 2, 'Carrera 8 # 22-40', 'Soacha', 'En camino', '2026-04-07'),
(3, 3, 'Avenida 68 # 45-10', 'Bogotá', 'Pendiente', '2026-04-08'),
(4, 4, 'Calle 80 # 90-15', 'Bogotá', 'Programada', '2026-04-09'),
(5, 5, 'Carrera 30 # 12-50', 'Chía', 'Entregada', '2026-04-10');

-- ============================================
-- PARTE 2: UPDATE
-- ============================================

-- Actualizar una columna de una fila específica por PK
UPDATE products
SET price = 1250000
WHERE id = 1;

-- Actualizar múltiples columnas de una fila específica
UPDATE products
SET stock = 4,
    is_active = 1
WHERE id = 5;

-- Actualizar múltiples filas con condición de negocio
-- Aumentar 5% a productos de oficina
UPDATE products
SET price = price * 1.05
WHERE category = 'Oficina';

-- Actualizar estado de un pedido
UPDATE orders
SET order_status = 'Pagado'
WHERE id = 1;

-- Actualizar estado y fecha de una entrega
UPDATE deliveries
SET delivery_status = 'Programada',
    delivery_date = '2026-04-11'
WHERE id = 3;

-- ============================================
-- PARTE 3: DELETE SEGURO
-- ============================================

-- Primero verificamos qué entrega se eliminará
SELECT id, order_id, city, delivery_status
FROM deliveries
WHERE city = 'Chía';

-- Luego eliminamos usando la misma condición
DELETE FROM deliveries
WHERE city = 'Chía';

-- Verificamos qué material se eliminará
SELECT id, name, supplier
FROM materials
WHERE supplier = 'Pinturas Bogotá';

-- Luego eliminamos usando la misma condición
DELETE FROM materials
WHERE supplier = 'Pinturas Bogotá';

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

SELECT *
FROM products
ORDER BY id;

SELECT *
FROM materials
ORDER BY id;

SELECT
    orders.id AS order_id,
    orders.customer_name,
    products.name AS product_name,
    orders.quantity,
    orders.order_status,
    orders.order_date
FROM orders
INNER JOIN products
    ON orders.product_id = products.id
ORDER BY orders.id;

SELECT
    deliveries.id AS delivery_id,
    orders.customer_name,
    deliveries.delivery_address,
    deliveries.city,
    deliveries.delivery_status,
    deliveries.delivery_date
FROM deliveries
INNER JOIN orders
    ON deliveries.order_id = orders.id
ORDER BY deliveries.id;   