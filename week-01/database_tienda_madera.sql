-- ============================================
-- PROYECTO SEMANAL: Conoce tu Dominio
-- Semana 01 — Introducción a Bases de Datos Relacionales
-- ============================================
-- Aprendiz: JISELT VALENTINA ZAMBRANO RUIZ
-- Ficha: 3407182
-- Bootcamp: bc-sql
-- Dominio asignado: Tienda de muebles
-- Entidades principales: products, materials, orders, deliveries
-- ============================================

-- ============================================
-- LIMPIEZA DE TABLAS
-- ============================================

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS products;

-- ============================================
-- PASO 1: Crear entidad principal
-- Tabla: products
-- ============================================

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL,
    stock INTEGER NOT NULL,
    is_active INTEGER DEFAULT 1
);

-- ============================================
-- PASO 2: Crear segunda entidad
-- Tabla: materials
-- ============================================

CREATE TABLE materials (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    supplier TEXT NOT NULL,
    unit_cost REAL NOT NULL
);

-- ============================================
-- PASO 3: Crear tercera entidad
-- Tabla: orders
-- ============================================

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    order_status TEXT NOT NULL,
    order_date TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ============================================
-- PASO 4: Crear cuarta entidad
-- Tabla: deliveries
-- ============================================

CREATE TABLE deliveries (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    delivery_address TEXT NOT NULL,
    city TEXT NOT NULL,
    delivery_status TEXT NOT NULL,
    delivery_date TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- ============================================
-- PASO 5: Insertar datos de prueba
-- Mínimo 5 registros por tabla
-- ============================================

INSERT INTO products (id, name, category, price, stock, is_active) VALUES
(1, 'Sofá moderno', 'Sala', 1200000, 5, 1),
(2, 'Mesa de comedor', 'Comedor', 850000, 3, 1),
(3, 'Cama doble', 'Habitación', 950000, 4, 1),
(4, 'Silla ergonómica', 'Oficina', 420000, 8, 1),
(5, 'Biblioteca de madera', 'Estudio', 690000, 2, 1);

INSERT INTO materials (id, name, type, supplier, unit_cost) VALUES
(1, 'Madera roble', 'Madera', 'Maderas del Norte', 150000),
(2, 'Tela lino', 'Tela', 'Textiles Colombia', 80000),
(3, 'Espuma alta densidad', 'Relleno', 'Espumas SAS', 60000),
(4, 'Tornillos industriales', 'Herraje', 'Ferretería Central', 12000),
(5, 'Barniz natural', 'Acabado', 'Pinturas Bogotá', 35000);

INSERT INTO orders (id, customer_name, product_id, quantity, order_status, order_date) VALUES
(1, 'Carlos Pérez', 1, 1, 'Pendiente', '2026-04-01'),
(2, 'Laura Gómez', 2, 2, 'Pagado', '2026-04-02'),
(3, 'Andrés Rodríguez', 3, 1, 'En preparación', '2026-04-03'),
(4, 'María Torres', 4, 3, 'Pagado', '2026-04-04'),
(5, 'Camila Rojas', 5, 1, 'Entregado', '2026-04-05');

INSERT INTO deliveries (id, order_id, delivery_address, city, delivery_status, delivery_date) VALUES
(1, 1, 'Calle 10 # 15-20', 'Bogotá', 'Programada', '2026-04-06'),
(2, 2, 'Carrera 8 # 22-40', 'Soacha', 'En camino', '2026-04-07'),
(3, 3, 'Avenida 68 # 45-10', 'Bogotá', 'Pendiente', '2026-04-08'),
(4, 4, 'Calle 80 # 90-15', 'Bogotá', 'Programada', '2026-04-09'),
(5, 5, 'Carrera 30 # 12-50', 'Chía', 'Entregada', '2026-04-10');

-- ============================================
-- PASO 6: Consultas SELECT básicas
-- ============================================

-- Mostrar todos los productos
SELECT * FROM products;

-- Mostrar solo los nombres de los productos ordenados alfabéticamente
SELECT name
FROM products
ORDER BY name;

-- Contar cuántos productos hay en total
SELECT COUNT(*) AS total_products
FROM products;

-- Mostrar todos los materiales
SELECT * FROM materials;

-- Mostrar materiales ordenados por tipo
SELECT name, type, supplier
FROM materials
ORDER BY type;

-- Contar cuántos materiales hay en total
SELECT COUNT(*) AS total_materials
FROM materials;

-- Mostrar todos los pedidos
SELECT * FROM orders;

-- Mostrar pedidos con nombre del producto
SELECT 
    orders.id AS order_id,
    orders.customer_name,
    products.name AS product_name,
    orders.quantity,
    orders.order_status,
    orders.order_date
FROM orders
INNER JOIN products
ON orders.product_id = products.id;

-- Mostrar todas las entregas
SELECT * FROM deliveries;

-- Mostrar entregas con información del pedido
SELECT 
    deliveries.id AS delivery_id,
    orders.customer_name,
    deliveries.delivery_address,
    deliveries.city,
    deliveries.delivery_status,
    deliveries.delivery_date
FROM deliveries
INNER JOIN orders
ON deliveries.order_id = orders.id;

-- Contar cuántas entregas hay en total
SELECT COUNT(*) AS total_deliveries
FROM deliveries;