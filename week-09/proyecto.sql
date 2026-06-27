-- ============================================================
-- Bootcamp SQL - Proyecto por semanas hasta semana 09, excepto semana 08
-- Aprendiz: JISELT VALENTINA ZAMBRANO RUIZ
-- Ficha: 3407182
-- Dominio: Tienda de muebles
-- Entidades: products, materials, orders, deliveries
-- Motor: PostgreSQL 18 / pgAdmin
-- ============================================================

-- SEMANA 09 - JOINs: INNER JOIN y LEFT JOIN
-- Semana 08 omitida por solicitud.
-- Mínimo revisado: 80 filas en tabla principal y 20 en cada secundaria.
-- Requisitos cubiertos: 3 tablas relacionadas por FK, 5 consultas JOIN,
-- aliases de tabla, comentarios en español y sin SELECT *.


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

-- Completar datos mínimos exactos para semana 09
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
(10, 'MAT-010', 'Melamina blanca', 'Madera procesada', 'Maderas del Centro', 70000, 33),
(11, 'MAT-011', 'Pegante industrial', 'Adhesivo', 'Químicos Muebles', 28000, 50),
(12, 'MAT-012', 'Bisagras metálicas', 'Herraje', 'Herrajes Bogotá', 15000, 80),
(13, 'MAT-013', 'Rieles para cajón', 'Herraje', 'Herrajes Bogotá', 22000, 70),
(14, 'MAT-014', 'Pintura negra mate', 'Acabado', 'Pinturas Bogotá', 42000, 28),
(15, 'MAT-015', 'Pintura blanca', 'Acabado', 'Pinturas Bogotá', 39000, 32),
(16, 'MAT-016', 'Madera cedro', 'Madera', 'Maderas del Norte', 170000, 14),
(17, 'MAT-017', 'Tela terciopelo', 'Tela', 'Textiles Bogotá', 98000, 21),
(18, 'MAT-018', 'Ruedas pequeñas', 'Herraje', 'Ferretería Central', 18000, 60),
(19, 'MAT-019', 'Lámina MDF', 'Madera procesada', 'Maderas Andinas', 65000, 37),
(20, 'MAT-020', 'Caucho protector', 'Accesorio', 'Accesorios Mueblex', 9000, 90)
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
(30, 'MUE-030', 'Cabecera doble', 'Habitación', 5, 840000, 5, 'Producto disponible para venta en tienda', 'TRUE'),
(31, 'MUE-031', 'Silla auxiliar modelo 31', 'Comedor', 1, 862000, 8, NULL, 'TRUE'),
(32, 'MUE-032', 'Mesa rectangular modelo 32', 'Comedor', 2, 884000, 11, 'Producto disponible para venta en tienda', 'TRUE'),
(33, 'MUE-033', 'Sofá esquinero modelo 33', 'Sala', 3, 906000, 14, 'Producto disponible para venta en tienda', 'TRUE'),
(34, 'MUE-034', 'Repisa biblioteca modelo 34', 'Estudio', 4, 928000, 0, 'Producto disponible para venta en tienda', 'TRUE'),
(35, 'MUE-035', 'Mesa de estudio modelo 35', 'Estudio', NULL, 950000, 3, 'Producto disponible para venta en tienda', 'TRUE'),
(36, 'MUE-036', 'Clóset modular modelo 36', 'Habitación', 1, 972000, 6, 'Producto disponible para venta en tienda', 'TRUE'),
(37, 'MUE-037', 'Mesa de reuniones modelo 37', 'Oficina', 2, 994000, 9, 'Producto disponible para venta en tienda', 'TRUE'),
(38, 'MUE-038', 'Silla ejecutiva modelo 38', 'Oficina', 3, 1016000, 12, NULL, 'TRUE'),
(39, 'MUE-039', 'Mueble bar modelo 39', 'Sala', 4, 1038000, 15, 'Producto disponible para venta en tienda', 'TRUE'),
(40, 'MUE-040', 'Comedor seis puestos modelo 40', 'Comedor', 5, 1060000, 1, 'Producto disponible para venta en tienda', 'TRUE'),
(41, 'MUE-041', 'Silla auxiliar modelo 41', 'Comedor', 1, 1082000, 4, 'Producto disponible para venta en tienda', 'TRUE'),
(42, 'MUE-042', 'Mesa rectangular modelo 42', 'Comedor', NULL, 1104000, 7, 'Producto disponible para venta en tienda', 'TRUE'),
(43, 'MUE-043', 'Sofá esquinero modelo 43', 'Sala', 3, 1126000, 10, 'Producto disponible para venta en tienda', 'TRUE'),
(44, 'MUE-044', 'Repisa biblioteca modelo 44', 'Estudio', 4, 1148000, 13, 'Producto disponible para venta en tienda', 'TRUE'),
(45, 'MUE-045', 'Mesa de estudio modelo 45', 'Estudio', 5, 1170000, 16, 'Producto disponible para venta en tienda', 'TRUE'),
(46, 'MUE-046', 'Clóset modular modelo 46', 'Habitación', 1, 1192000, 2, 'Producto disponible para venta en tienda', 'FALSE'),
(47, 'MUE-047', 'Mesa de reuniones modelo 47', 'Oficina', 2, 1214000, 5, 'Producto disponible para venta en tienda', 'TRUE'),
(48, 'MUE-048', 'Silla ejecutiva modelo 48', 'Oficina', 3, 1236000, 8, 'Producto disponible para venta en tienda', 'TRUE'),
(49, 'MUE-049', 'Mueble bar modelo 49', 'Sala', NULL, 1258000, 11, 'Producto disponible para venta en tienda', 'TRUE'),
(50, 'MUE-050', 'Comedor seis puestos modelo 50', 'Comedor', 5, 1280000, 14, 'Producto disponible para venta en tienda', 'TRUE'),
(51, 'MUE-051', 'Silla auxiliar modelo 51', 'Comedor', 1, 1302000, 0, 'Producto disponible para venta en tienda', 'TRUE'),
(52, 'MUE-052', 'Mesa rectangular modelo 52', 'Comedor', 2, 1324000, 3, 'Producto disponible para venta en tienda', 'TRUE'),
(53, 'MUE-053', 'Sofá esquinero modelo 53', 'Sala', 3, 1346000, 6, 'Producto disponible para venta en tienda', 'TRUE'),
(54, 'MUE-054', 'Repisa biblioteca modelo 54', 'Estudio', 4, 1368000, 9, 'Producto disponible para venta en tienda', 'TRUE'),
(55, 'MUE-055', 'Mesa de estudio modelo 55', 'Estudio', 5, 1390000, 12, 'Producto disponible para venta en tienda', 'TRUE'),
(56, 'MUE-056', 'Clóset modular modelo 56', 'Habitación', NULL, 1412000, 15, 'Producto disponible para venta en tienda', 'TRUE'),
(57, 'MUE-057', 'Mesa de reuniones modelo 57', 'Oficina', 2, 1434000, 1, 'Producto disponible para venta en tienda', 'TRUE'),
(58, 'MUE-058', 'Silla ejecutiva modelo 58', 'Oficina', 3, 1456000, 4, 'Producto disponible para venta en tienda', 'TRUE'),
(59, 'MUE-059', 'Mueble bar modelo 59', 'Sala', 4, 1478000, 7, 'Producto disponible para venta en tienda', 'TRUE'),
(60, 'MUE-060', 'Comedor seis puestos modelo 60', 'Comedor', 5, 1500000, 10, 'Producto disponible para venta en tienda', 'TRUE'),
(61, 'MUE-061', 'Silla auxiliar modelo 61', 'Comedor', 1, 1522000, 13, 'Producto disponible para venta en tienda', 'TRUE'),
(62, 'MUE-062', 'Mesa rectangular modelo 62', 'Comedor', 2, 1544000, 16, 'Producto disponible para venta en tienda', 'TRUE'),
(63, 'MUE-063', 'Sofá esquinero modelo 63', 'Sala', NULL, 1566000, 2, 'Producto disponible para venta en tienda', 'TRUE'),
(64, 'MUE-064', 'Repisa biblioteca modelo 64', 'Estudio', 4, 1588000, 5, 'Producto disponible para venta en tienda', 'TRUE'),
(65, 'MUE-065', 'Mesa de estudio modelo 65', 'Estudio', 5, 1610000, 8, 'Producto disponible para venta en tienda', 'TRUE'),
(66, 'MUE-066', 'Clóset modular modelo 66', 'Habitación', 1, 1632000, 11, 'Producto disponible para venta en tienda', 'TRUE'),
(67, 'MUE-067', 'Mesa de reuniones modelo 67', 'Oficina', 2, 1654000, 14, 'Producto disponible para venta en tienda', 'TRUE'),
(68, 'MUE-068', 'Silla ejecutiva modelo 68', 'Oficina', 3, 1676000, 0, 'Producto disponible para venta en tienda', 'TRUE'),
(69, 'MUE-069', 'Mueble bar modelo 69', 'Sala', 4, 1698000, 3, 'Producto disponible para venta en tienda', 'FALSE'),
(70, 'MUE-070', 'Comedor seis puestos modelo 70', 'Comedor', NULL, 1720000, 6, 'Producto disponible para venta en tienda', 'TRUE'),
(71, 'MUE-071', 'Silla auxiliar modelo 71', 'Comedor', 1, 1742000, 9, 'Producto disponible para venta en tienda', 'TRUE'),
(72, 'MUE-072', 'Mesa rectangular modelo 72', 'Comedor', 2, 1764000, 12, 'Producto disponible para venta en tienda', 'TRUE'),
(73, 'MUE-073', 'Sofá esquinero modelo 73', 'Sala', 3, 1786000, 15, 'Producto disponible para venta en tienda', 'TRUE'),
(74, 'MUE-074', 'Repisa biblioteca modelo 74', 'Estudio', 4, 1808000, 1, 'Producto disponible para venta en tienda', 'TRUE'),
(75, 'MUE-075', 'Mesa de estudio modelo 75', 'Estudio', 5, 1830000, 4, 'Producto disponible para venta en tienda', 'TRUE'),
(76, 'MUE-076', 'Clóset modular modelo 76', 'Habitación', 1, 1852000, 7, 'Producto disponible para venta en tienda', 'TRUE'),
(77, 'MUE-077', 'Mesa de reuniones modelo 77', 'Oficina', 2, 1874000, 10, 'Producto disponible para venta en tienda', 'TRUE'),
(78, 'MUE-078', 'Silla ejecutiva modelo 78', 'Oficina', 3, 1896000, 13, 'Producto disponible para venta en tienda', 'TRUE'),
(79, 'MUE-079', 'Mueble bar modelo 79', 'Sala', 4, 1918000, 16, 'Producto disponible para venta en tienda', 'TRUE'),
(80, 'MUE-080', 'Comedor seis puestos modelo 80', 'Comedor', 5, 1940000, 2, 'Producto disponible para venta en tienda', 'TRUE')
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
(10, 'ORD-010', 'Natalia Mora', '3001110010', 10, 2, 'Cancelado', '2026-04-11'),
(11, 'ORD-011', 'Paula García', '3001110011', 11, 3, 'Pendiente', '2026-04-12'),
(12, 'ORD-012', 'Miguel Herrera', '3001110012', 12, 1, 'Pagado', '2026-04-13'),
(13, 'ORD-013', 'Valentina Ruiz', NULL, 13, 2, 'En preparación', '2026-04-14'),
(14, 'ORD-014', 'Santiago León', '3001110014', 14, 3, 'Entregado', '2026-04-15'),
(15, 'ORD-015', 'Luisa Cárdenas', '3001110015', 15, 1, 'Cancelado', '2026-04-16'),
(16, 'ORD-016', 'Ricardo Suárez', '3001110016', 16, 2, 'Pendiente', '2026-04-17'),
(17, 'ORD-017', 'Juliana Ríos', '3001110017', 17, 3, 'Pagado', '2026-04-18'),
(18, 'ORD-018', 'Óscar Pardo', NULL, 18, 1, 'En preparación', '2026-04-19'),
(19, 'ORD-019', 'Daniela Peña', '3001110019', 19, 2, 'Entregado', '2026-04-20'),
(20, 'ORD-020', 'Esteban Arias', '3001110020', 20, 3, 'Cancelado', '2026-04-21')
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
(10, 10, 'Calle 20 # 30-40', 'Funza', 'Cancelada', '2026-05-11'),
(11, 11, 'Calle 21 # 31-41', 'Bogotá', 'Pendiente', '2026-05-12'),
(12, 12, 'Calle 22 # 32-42', 'Soacha', 'Programada', '2026-05-13'),
(13, 13, 'Calle 23 # 33-43', 'Chía', 'En camino', NULL),
(14, 14, 'Calle 24 # 34-44', 'Mosquera', 'Entregada', '2026-05-15'),
(15, 15, 'Calle 25 # 35-45', 'Funza', 'Cancelada', '2026-05-16'),
(16, 16, 'Calle 26 # 36-46', 'Bogotá', 'Pendiente', '2026-05-17'),
(17, 17, 'Calle 27 # 37-47', 'Soacha', 'Programada', '2026-05-18'),
(18, 18, 'Calle 28 # 38-48', 'Chía', 'En camino', NULL),
(19, 19, 'Calle 29 # 39-49', 'Mosquera', 'Entregada', '2026-05-20'),
(20, 20, 'Calle 30 # 40-50', 'Funza', 'Cancelada', '2026-05-21')
ON CONFLICT (id) DO NOTHING;

-- Consulta 1: INNER JOIN principal entre pedidos y productos.
SELECT
    o.order_number AS "Pedido",
    o.customer_name AS "Cliente",
    p.name AS "Producto",
    o.quantity AS "Cantidad",
    o.order_status AS "Estado"
FROM orders AS o
INNER JOIN products AS p
    ON o.product_id = p.id
ORDER BY o.id;

-- Consulta 2: JOIN con tres tablas: pedidos, productos y entregas.
SELECT
    o.order_number AS "Pedido",
    p.name AS "Producto",
    d.city AS "Ciudad entrega",
    d.delivery_status AS "Estado entrega",
    d.delivery_date AS "Fecha entrega"
FROM orders AS o
INNER JOIN products AS p
    ON o.product_id = p.id
INNER JOIN deliveries AS d
    ON d.order_id = o.id
ORDER BY o.id;

-- Consulta 3: LEFT JOIN para mostrar todos los productos, tengan o no pedidos.
SELECT
    p.id AS "Id producto",
    p.name AS "Producto",
    o.order_number AS "Pedido relacionado",
    o.customer_name AS "Cliente"
FROM products AS p
LEFT JOIN orders AS o
    ON o.product_id = p.id
ORDER BY p.id;

-- Consulta 4: detectar productos sin pedidos usando LEFT JOIN + IS NULL.
SELECT
    p.id AS "Id producto",
    p.name AS "Producto sin pedido",
    p.category AS "Categoría"
FROM products AS p
LEFT JOIN orders AS o
    ON o.product_id = p.id
WHERE o.id IS NULL
ORDER BY p.id;

-- Consulta 5: reporte agregado con LEFT JOIN, GROUP BY y COUNT.
SELECT
    p.category AS "Categoría",
    COUNT(DISTINCT p.id) AS "Productos registrados",
    COUNT(o.id) AS "Pedidos relacionados"
FROM products AS p
LEFT JOIN orders AS o
    ON o.product_id = p.id
GROUP BY p.category
ORDER BY "Pedidos relacionados" DESC, p.category;

-- Consulta adicional útil: productos con su material principal.
SELECT
    p.name AS "Producto",
    COALESCE(m.name, 'Sin material asignado') AS "Material principal",
    p.price AS "Precio"
FROM products AS p
LEFT JOIN materials AS m
    ON p.material_id = m.id
ORDER BY p.id
LIMIT 25;
