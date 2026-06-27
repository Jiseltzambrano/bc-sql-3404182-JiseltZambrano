-- ============================================================
-- Bootcamp SQL - Proyecto por semanas hasta semana 09, excepto semana 08
-- Aprendiz: JISELT VALENTINA ZAMBRANO RUIZ
-- Ficha: 3407182
-- Dominio: Tienda de muebles
-- Entidades: products, materials, orders, deliveries
-- Motor: PostgreSQL 18 / pgAdmin
-- ============================================================

-- SEMANA 06 - Funciones de agregación
-- Mínimo revisado: 30 filas en tabla principal con grupos desiguales.
-- Requisitos cubiertos: COUNT, SUM, AVG, MIN, MAX, GROUP BY y HAVING.


CREATE SCHEMA IF NOT EXISTS tienda_muebles;
SET search_path TO tienda_muebles;

CREATE TABLE IF NOT EXISTS materials (
    id INTEGER PRIMARY KEY,
    material_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    material_type VARCHAR(80) NOT NULL,
    supplier VARCHAR(120),
    unit_cost NUMERIC(12,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_materials_unit_cost_positive CHECK (unit_cost > 0),
    CONSTRAINT chk_materials_stock_not_negative CHECK (stock >= 0)
);

CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    material_id INTEGER,
    price NUMERIC(12,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    notes TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_products_price_positive CHECK (price > 0),
    CONSTRAINT chk_products_stock_not_negative CHECK (stock >= 0),
    CONSTRAINT fk_products_materials
        FOREIGN KEY (material_id)
        REFERENCES materials(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY,
    order_number VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(120) NOT NULL,
    customer_phone VARCHAR(30),
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    order_status VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT chk_orders_quantity_positive CHECK (quantity > 0),
    CONSTRAINT chk_orders_status_valid
        CHECK (order_status IN ('Pendiente', 'Pagado', 'En preparación', 'Entregado', 'Cancelado')),
    CONSTRAINT fk_orders_products
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS deliveries (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    delivery_address VARCHAR(160) NOT NULL,
    city VARCHAR(80) NOT NULL,
    delivery_status VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    delivery_date DATE,
    CONSTRAINT chk_deliveries_status_valid
        CHECK (delivery_status IN ('Pendiente', 'Programada', 'En camino', 'Entregada', 'Cancelada')),
    CONSTRAINT fk_deliveries_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Asegurar datos mínimos de semana 06
INSERT INTO materials (id, material_code, name, material_type, supplier, unit_cost, stock) VALUES
(1, 'MAT-001', 'Madera roble', 'Madera', 'Maderas del Norte', 150000, 25),
(2, 'MAT-002', 'Madera pino', 'Madera', 'Maderas Andinas', 95000, 40),
(3, 'MAT-003', 'Tela lino', 'Tela', 'Textiles Bogotá', 80000, 35),
(4, 'MAT-004', 'Espuma alta densidad', 'Relleno', 'Espumas SAS', 60000, 30),
(5, 'MAT-005', 'Tornillos industriales', 'Herraje', 'Ferretería Central', 12000, 100),
(6, 'MAT-006', 'Barniz natural', 'Acabado', 'Pinturas Bogotá', 35000, 45),
(7, 'MAT-007', 'Vidrio templado', 'Vidrio', 'Vidrios Capital', 110000, 18),
(8, 'MAT-008', 'Acero inoxidable', 'Metal', 'Aceros Colombia', 130000, 22),
(9, 'MAT-009', 'Cuero sintético', 'Tapizado', 'Tapizados del Sur', 90000, 26),
(10, 'MAT-010', 'Melamina blanca', 'Madera procesada', 'Maderas del Centro', 70000, 33)
ON CONFLICT (id) DO NOTHING;

INSERT INTO products (id, sku, name, category, material_id, price, stock, notes, is_active) VALUES
(1, 'MUE-001', 'Sofá moderno', 'Sala', 1, 202000, 3, 'Producto disponible para venta en tienda', 'TRUE'),
(2, 'MUE-002', 'Mesa de comedor familiar', 'Comedor', 2, 224000, 6, 'Producto disponible para venta en tienda', 'TRUE'),
(3, 'MUE-003', 'Cama doble clásica', 'Habitación', 3, 246000, 9, NULL, 'TRUE'),
(4, 'MUE-004', 'Silla ergonómica', 'Oficina', 4, 268000, 12, 'Producto disponible para venta en tienda', 'TRUE'),
(5, 'MUE-005', 'Biblioteca de madera', 'Estudio', 5, 290000, 15, 'Producto disponible para venta en tienda', 'TRUE'),
(6, 'MUE-006', 'Mesa de centro', 'Sala', 1, 312000, 1, 'Producto disponible para venta en tienda', 'TRUE'),
(7, 'MUE-007', 'Armario de dos puertas', 'Habitación', NULL, 334000, 4, 'Producto disponible para venta en tienda', 'TRUE'),
(8, 'MUE-008', 'Escritorio sencillo', 'Oficina', 3, 356000, 7, 'Producto disponible para venta en tienda', 'TRUE'),
(9, 'MUE-009', 'Comedor cuatro puestos', 'Comedor', 4, 378000, 10, 'Producto disponible para venta en tienda', 'TRUE'),
(10, 'MUE-010', 'Mesa auxiliar redonda', 'Sala', 5, 400000, 13, NULL, 'TRUE'),
(11, 'MUE-011', 'Base cama sencilla', 'Habitación', 1, 422000, 16, 'Producto disponible para venta en tienda', 'TRUE'),
(12, 'MUE-012', 'Archivador pequeño', 'Oficina', 2, 444000, 2, 'Producto disponible para venta en tienda', 'TRUE'),
(13, 'MUE-013', 'Repisa flotante', 'Estudio', 3, 466000, 5, 'Producto disponible para venta en tienda', 'TRUE'),
(14, 'MUE-014', 'Silla de comedor', 'Comedor', NULL, 488000, 8, 'Producto disponible para venta en tienda', 'TRUE'),
(15, 'MUE-015', 'Mueble para televisor', 'Sala', 5, 510000, 11, 'Producto disponible para venta en tienda', 'TRUE'),
(16, 'MUE-016', 'Sofá cama', 'Sala', 1, 532000, 14, 'Producto disponible para venta en tienda', 'TRUE'),
(17, 'MUE-017', 'Cajonera vertical', 'Habitación', 2, 554000, 0, NULL, 'TRUE'),
(18, 'MUE-018', 'Mesa de noche', 'Habitación', 3, 576000, 3, 'Producto disponible para venta en tienda', 'TRUE'),
(19, 'MUE-019', 'Escritorio ejecutivo', 'Oficina', 4, 598000, 6, 'Producto disponible para venta en tienda', 'TRUE'),
(20, 'MUE-020', 'Banco de madera', 'Comedor', 5, 620000, 9, 'Producto disponible para venta en tienda', 'TRUE'),
(21, 'MUE-021', 'Vitrina decorativa', 'Sala', NULL, 642000, 12, 'Producto disponible para venta en tienda', 'TRUE'),
(22, 'MUE-022', 'Zapatero compacto', 'Habitación', 2, 664000, 15, 'Producto disponible para venta en tienda', 'TRUE'),
(23, 'MUE-023', 'Mesa plegable', 'Comedor', 3, 686000, 1, 'Producto disponible para venta en tienda', 'FALSE'),
(24, 'MUE-024', 'Silla tapizada', 'Comedor', 4, 708000, 4, NULL, 'TRUE'),
(25, 'MUE-025', 'Centro de entretenimiento', 'Sala', 5, 730000, 7, 'Producto disponible para venta en tienda', 'TRUE'),
(26, 'MUE-026', 'Cómoda amplia', 'Habitación', 1, 752000, 10, 'Producto disponible para venta en tienda', 'TRUE'),
(27, 'MUE-027', 'Mesa lateral', 'Sala', 2, 774000, 13, 'Producto disponible para venta en tienda', 'TRUE'),
(28, 'MUE-028', 'Estante modular', 'Estudio', NULL, 796000, 16, 'Producto disponible para venta en tienda', 'TRUE'),
(29, 'MUE-029', 'Mueble organizador', 'Oficina', 4, 818000, 2, 'Producto disponible para venta en tienda', 'TRUE'),
(30, 'MUE-030', 'Cabecera doble', 'Habitación', 5, 840000, 5, 'Producto disponible para venta en tienda', 'TRUE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO orders (id, order_number, customer_name, customer_phone, product_id, quantity, order_status, order_date) VALUES
(1, 'ORD-001', 'Carlos Pérez', '3001110001', 1, 2, 'Pendiente', '2026-04-02'),
(2, 'ORD-002', 'Laura Gómez', '3001110002', 2, 3, 'Pagado', '2026-04-03'),
(3, 'ORD-003', 'Andrés Rodríguez', '3001110003', 3, 1, 'En preparación', '2026-04-04'),
(4, 'ORD-004', 'María Torres', NULL, 4, 2, 'Entregado', '2026-04-05'),
(5, 'ORD-005', 'Camila Rojas', '3001110005', 5, 3, 'Cancelado', '2026-04-06'),
(6, 'ORD-006', 'Diana Martínez', '3001110006', 6, 1, 'Pendiente', '2026-04-07'),
(7, 'ORD-007', 'Felipe Castro', '3001110007', 7, 2, 'Pagado', '2026-04-08'),
(8, 'ORD-008', 'Sandra López', NULL, 8, 3, 'En preparación', '2026-04-09'),
(9, 'ORD-009', 'Jorge Ramírez', '3001110009', 9, 1, 'Entregado', '2026-04-10'),
(10, 'ORD-010', 'Natalia Mora', '3001110010', 10, 2, 'Cancelado', '2026-04-11')
ON CONFLICT (id) DO NOTHING;

INSERT INTO deliveries (id, order_id, delivery_address, city, delivery_status, delivery_date) VALUES
(1, 1, 'Calle 11 # 21-31', 'Bogotá', 'Pendiente', '2026-05-02'),
(2, 2, 'Calle 12 # 22-32', 'Soacha', 'Programada', '2026-05-03'),
(3, 3, 'Calle 13 # 23-33', 'Chía', 'En camino', '2026-05-04'),
(4, 4, 'Calle 14 # 24-34', 'Mosquera', 'Entregada', NULL),
(5, 5, 'Calle 15 # 25-35', 'Funza', 'Cancelada', '2026-05-06'),
(6, 6, 'Calle 16 # 26-36', 'Bogotá', 'Pendiente', '2026-05-07'),
(7, 7, 'Calle 17 # 27-37', 'Soacha', 'Programada', '2026-05-08'),
(8, 8, 'Calle 18 # 28-38', 'Chía', 'En camino', '2026-05-09'),
(9, 9, 'Calle 19 # 29-39', 'Mosquera', 'Entregada', '2026-05-10'),
(10, 10, 'Calle 20 # 30-40', 'Funza', 'Cancelada', '2026-05-11')
ON CONFLICT (id) DO NOTHING;

-- Reporte de totales con varias funciones de agregación.
SELECT
    COUNT(*) AS "Total productos",
    SUM(p.stock) AS "Stock total",
    AVG(p.price) AS "Precio promedio",
    MIN(p.price) AS "Precio menor",
    MAX(p.price) AS "Precio mayor"
FROM products AS p;

-- Reporte agrupado por categoría.
SELECT
    p.category AS "Categoría",
    COUNT(*) AS "Cantidad productos",
    SUM(p.stock) AS "Stock por categoría",
    AVG(p.price) AS "Precio promedio"
FROM products AS p
GROUP BY p.category
ORDER BY "Cantidad productos" DESC;

-- HAVING: mostrar categorías con más de 4 productos.
SELECT
    p.category AS "Categoría",
    COUNT(*) AS "Cantidad productos",
    SUM(p.stock) AS "Stock total"
FROM products AS p
GROUP BY p.category
HAVING COUNT(*) > 4
ORDER BY "Stock total" DESC;

-- Reporte de pedidos por estado.
SELECT
    o.order_status AS "Estado pedido",
    COUNT(o.id) AS "Cantidad pedidos",
    SUM(o.quantity) AS "Unidades solicitadas",
    AVG(o.quantity) AS "Promedio unidades"
FROM orders AS o
GROUP BY o.order_status
ORDER BY "Cantidad pedidos" DESC;
