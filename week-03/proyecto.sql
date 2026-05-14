USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: DML de tu Dominio
-- Semana 03 — INSERT, UPDATE, DELETE
-- Dominio: Tienda de muebles / tienda de madera
-- ============================================

-- ============================================
-- LIMPIEZA DE DATOS
-- ============================================

DELETE FROM dbo.deliveries;
DELETE FROM dbo.orders;
DELETE FROM dbo.products;
DELETE FROM dbo.materials;
GO

-- Reiniciar IDs automáticos
DBCC CHECKIDENT ('dbo.deliveries', RESEED, 0);
DBCC CHECKIDENT ('dbo.orders', RESEED, 0);
DBCC CHECKIDENT ('dbo.products', RESEED, 0);
DBCC CHECKIDENT ('dbo.materials', RESEED, 0);
GO

-- ============================================
-- PARTE 1: INSERT
-- ============================================

-- Tabla independiente: materials
INSERT INTO materials (name, type, supplier, cost, stock, is_active)
VALUES
('Madera roble', 'Madera', 'Maderas del Norte', 150000, 20, 1),
('Tela lino', 'Tela', 'Textiles Colombia', 80000, 30, 1),
('Espuma alta densidad', 'Relleno', 'Espumas SAS', 60000, 25, 1),
('Tornillos industriales', 'Herraje', 'Ferretería Central', 12000, 100, 1),
('Barniz natural', 'Acabado', 'Pinturas Bogotá', 35000, 15, 1);
GO

-- Tabla principal: products
-- material_id debe existir en materials
INSERT INTO products (name, category, material_id, price, stock, is_active)
VALUES
('Sofá moderno', 'Sala', 2, 1200000, 5, 1),
('Mesa de comedor', 'Comedor', 1, 850000, 3, 1),
('Cama doble', 'Habitación', 1, 950000, 4, 1),
('Silla ergonómica', 'Oficina', 4, 420000, 8, 1),
('Biblioteca de madera', 'Estudio', 1, 690000, 2, 1);
GO

-- Tabla hija: orders
-- product_id debe existir en products
INSERT INTO orders (customer_name, customer_phone, product_id, quantity, order_status, order_date)
VALUES
('Carlos Pérez', '3104567890', 1, 1, 'Pendiente', '2026-04-01'),
('Laura Gómez', '3207894561', 2, 2, 'Pagado', '2026-04-02'),
('Andrés Rodríguez', '3152223344', 3, 1, 'En proceso', '2026-04-03'),
('María Torres', '3115558899', 4, 3, 'Pagado', '2026-04-04'),
('Camila Rojas', '3009876543', 5, 1, 'Entregado', '2026-04-05');
GO

-- Tabla hija: deliveries
-- order_id debe existir en orders
INSERT INTO deliveries (order_id, delivery_address, city, delivery_status, delivery_date)
VALUES
(1, 'Calle 10 # 15-20', 'Bogotá', 'Programada', '2026-04-06'),
(2, 'Carrera 8 # 22-40', 'Soacha', 'En camino', '2026-04-07'),
(3, 'Avenida 68 # 45-10', 'Bogotá', 'Pendiente', '2026-04-08'),
(4, 'Calle 80 # 90-15', 'Bogotá', 'Programada', '2026-04-09'),
(5, 'Carrera 30 # 12-50', 'Chía', 'Entregada', '2026-04-10');
GO

-- ============================================
-- PARTE 2: UPDATE
-- ============================================

-- Actualizar una columna de una fila específica por PK
UPDATE products
SET price = 1250000
WHERE id = 1;
GO

-- Actualizar múltiples columnas de una fila específica
UPDATE products
SET stock = 4,
    is_active = 1
WHERE id = 5;
GO

-- Actualizar múltiples filas con condición de negocio
-- Aumentar 5% a productos de oficina
UPDATE products
SET price = price * 1.05
WHERE category = 'Oficina';
GO

-- Actualizar estado de un pedido
UPDATE orders
SET order_status = 'Pagado'
WHERE id = 1;
GO

-- Actualizar estado y fecha de una entrega
UPDATE deliveries
SET delivery_status = 'Programada',
    delivery_date = '2026-04-11'
WHERE id = 3;
GO

-- ============================================
-- PARTE 3: DELETE SEGURO
-- ============================================

-- Primero verificamos qué entrega se eliminará
SELECT id, order_id, city, delivery_status
FROM deliveries
WHERE city = 'Chía';
GO

-- Luego eliminamos usando la misma condición
DELETE FROM deliveries
WHERE city = 'Chía';
GO

-- Primero verificamos qué material se eliminará
-- Este material no está relacionado con ningún producto
SELECT id, name, supplier
FROM materials
WHERE supplier = 'Pinturas Bogotá';
GO

-- Luego eliminamos usando la misma condición
DELETE FROM materials
WHERE supplier = 'Pinturas Bogotá';
GO

-- ============================================
-- VERIFICACIÓN FINAL
-- ============================================

SELECT *
FROM dbo.products
ORDER BY id;
GO

SELECT *
FROM dbo.materials
ORDER BY id;
GO

SELECT
    o.id AS order_id,
    o.customer_name,
    o.customer_phone,
    p.name AS product_name,
    o.quantity,
    o.order_status,
    o.order_date
FROM dbo.orders AS o
INNER JOIN dbo.products AS p
    ON o.product_id = p.id
ORDER BY o.id;
GO

SELECT
    d.id AS delivery_id,
    o.customer_name,
    d.delivery_address,
    d.city,
    d.delivery_status,
    d.delivery_date
FROM dbo.deliveries AS d
INNER JOIN dbo.orders AS o
    ON d.order_id = o.id
ORDER BY d.id;
GO
