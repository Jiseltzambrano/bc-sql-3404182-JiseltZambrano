USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK
-- Dominio: Tienda de muebles / tienda de madera
-- Aprendiz: Jiselt Valentina Zambrano Ruiz
-- Motor: SQL Server / T-SQL
-- ============================================

-- IMPORTANTE:
-- Este archivo es autocontenido: recrea las tablas del dominio
-- para aplicar constraints correctamente.

-- ============================================
-- LIMPIEZA: eliminar primero las tablas hijas
-- ============================================
IF OBJECT_ID('dbo.deliveries', 'U') IS NOT NULL DROP TABLE dbo.deliveries;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL DROP TABLE dbo.orders;
IF OBJECT_ID('dbo.materials', 'U') IS NOT NULL DROP TABLE dbo.materials;
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL DROP TABLE dbo.products;
IF OBJECT_ID('dbo.product_categories', 'U') IS NOT NULL DROP TABLE dbo.product_categories;
GO

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS
-- ============================================

-- Tabla de referencia / categoría del dominio
CREATE TABLE dbo.product_categories (
    id INT PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(200) NULL
);
GO

-- Tabla principal: productos de la tienda de muebles
CREATE TABLE dbo.products (
    id INT PRIMARY KEY,
    sku VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    category_id INT NOT NULL,
    category VARCHAR(80) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    material_preferred VARCHAR(80) NULL,
    notes VARCHAR(200) NULL,
    is_active BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_products_price_positive CHECK (price > 0),
    CONSTRAINT CK_products_stock_not_negative CHECK (stock >= 0),
    CONSTRAINT FK_products_categories
        FOREIGN KEY (category_id)
        REFERENCES dbo.product_categories(id)
);
GO

-- Tabla secundaria: materiales usados para fabricar los muebles
CREATE TABLE dbo.materials (
    id INT PRIMARY KEY,
    material_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    type VARCHAR(80) NOT NULL,
    supplier VARCHAR(120) NULL,
    unit_cost DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,

    CONSTRAINT CK_materials_unit_cost_positive CHECK (unit_cost > 0),
    CONSTRAINT CK_materials_stock_not_negative CHECK (stock >= 0)
);
GO

-- Tabla hija: pedidos realizados por clientes
CREATE TABLE dbo.orders (
    id INT PRIMARY KEY,
    customer_name VARCHAR(120) NOT NULL,
    customer_phone VARCHAR(30) NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    order_date DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT CK_orders_quantity_positive CHECK (quantity > 0),
    CONSTRAINT CK_orders_status_valid
        CHECK (order_status IN ('Pendiente', 'Pagado', 'En preparación', 'Entregado', 'Cancelado')),
    CONSTRAINT FK_orders_products
        FOREIGN KEY (product_id)
        REFERENCES dbo.products(id)
);
GO

-- Tabla hija: entregas asociadas a pedidos
CREATE TABLE dbo.deliveries (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_address VARCHAR(160) NOT NULL,
    city VARCHAR(80) NOT NULL,
    delivery_status VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    delivery_date DATE NULL,

    CONSTRAINT CK_deliveries_status_valid
        CHECK (delivery_status IN ('Pendiente', 'Programada', 'En camino', 'Entregada', 'Cancelada')),
    CONSTRAINT FK_deliveries_orders
        FOREIGN KEY (order_id)
        REFERENCES dbo.orders(id)
);
GO

-- ============================================
-- PARTE 2: DATOS DE PRUEBA
-- Requisito semana 07: mínimo 30 filas en tabla principal
-- y columnas opcionales con NULL.
-- ============================================

INSERT INTO dbo.product_categories (id, category_name, description) VALUES
(1, 'Sala', 'Muebles principales para sala'),
(2, 'Comedor', 'Muebles para comedor'),
(3, 'Habitación', 'Muebles para dormitorio'),
(4, 'Oficina', 'Muebles de oficina y estudio'),
(5, 'Decoración', NULL);
GO

INSERT INTO dbo.products
(id, sku, name, category_id, category, price, stock, material_preferred, notes, is_active) VALUES
(1, 'MUE-001', 'Sofá moderno', 1, 'Sala', 1250000, 5, 'Madera roble', 'Producto premium de sala', 1),
(2, 'MUE-002', 'Mesa de centro', 1, 'Sala', 480000, 6, 'Madera cedro', NULL, 1),
(3, 'MUE-003', 'Poltrona individual', 1, 'Sala', 720000, 4, 'Tela lino', 'Disponible en varios colores', 1),
(4, 'MUE-004', 'Mueble para TV', 1, 'Sala', 890000, 3, 'Madera pino', NULL, 1),
(5, 'MUE-005', 'Sofá cama', 1, 'Sala', 1500000, 2, NULL, 'Requiere pedido anticipado', 1),
(6, 'MUE-006', 'Mesa de comedor 6 puestos', 2, 'Comedor', 1850000, 3, 'Madera roble', 'Incluye acabado natural', 1),
(7, 'MUE-007', 'Silla comedor clásica', 2, 'Comedor', 250000, 12, 'Madera pino', NULL, 1),
(8, 'MUE-008', 'Vitrina comedor', 2, 'Comedor', 1100000, 2, 'Vidrio y madera', 'Con puertas corredizas', 1),
(9, 'MUE-009', 'Bar auxiliar', 2, 'Comedor', 980000, 1, NULL, NULL, 1),
(10, 'MUE-010', 'Banco comedor', 2, 'Comedor', 360000, 5, 'Madera cedro', 'Ideal para espacios pequeños', 1),
(11, 'MUE-011', 'Cama doble', 3, 'Habitación', 950000, 4, 'Madera pino', 'Estructura reforzada', 1),
(12, 'MUE-012', 'Cama queen', 3, 'Habitación', 1350000, 2, 'Madera roble', NULL, 1),
(13, 'MUE-013', 'Nochero sencillo', 3, 'Habitación', 280000, 7, 'Madera cedro', 'Con dos cajones', 1),
(14, 'MUE-014', 'Cómoda grande', 3, 'Habitación', 890000, 3, NULL, 'Acabado mate', 1),
(15, 'MUE-015', 'Closet modular', 3, 'Habitación', 2100000, 1, 'Madera MDF', NULL, 1),
(16, 'MUE-016', 'Escritorio ejecutivo', 4, 'Oficina', 760000, 4, 'Madera roble', 'Diseño amplio', 1),
(17, 'MUE-017', 'Silla ergonómica', 4, 'Oficina', 441000, 8, 'Tela y metal', 'Con soporte lumbar', 1),
(18, 'MUE-018', 'Biblioteca de madera', 4, 'Oficina', 690000, 4, 'Madera pino', NULL, 1),
(19, 'MUE-019', 'Archivador de oficina', 4, 'Oficina', 530000, 6, NULL, 'Tres gavetas', 1),
(20, 'MUE-020', 'Mesa auxiliar oficina', 4, 'Oficina', 320000, 5, 'Madera MDF', NULL, 1),
(21, 'MUE-021', 'Repisa flotante', 5, 'Decoración', 120000, 15, 'Madera pino', 'Fácil instalación', 1),
(22, 'MUE-022', 'Marco decorativo', 5, 'Decoración', 90000, 20, NULL, NULL, 1),
(23, 'MUE-023', 'Espejo con marco', 5, 'Decoración', 300000, 6, 'Madera cedro', 'Marco artesanal', 1),
(24, 'MUE-024', 'Perchero de pared', 5, 'Decoración', 160000, 10, 'Madera pino', NULL, 1),
(25, 'MUE-025', 'Zapatero compacto', 5, 'Decoración', 420000, 3, 'Madera MDF', 'Diseño funcional', 1),
(26, 'MUE-026', 'Sofá esquinero', 1, 'Sala', 2300000, 1, 'Tela lino', NULL, 1),
(27, 'MUE-027', 'Mesa redonda comedor', 2, 'Comedor', 1450000, 2, 'Madera roble', 'Para cuatro puestos', 1),
(28, 'MUE-028', 'Cabecero doble', 3, 'Habitación', 520000, 4, NULL, 'Tapizado sencillo', 1),
(29, 'MUE-029', 'Mesa de reuniones', 4, 'Oficina', 1750000, 1, 'Madera cedro', NULL, 1),
(30, 'MUE-030', 'Organizador decorativo', 5, 'Decoración', 210000, 9, 'Madera pino', 'Producto liviano', 1);
GO

INSERT INTO dbo.materials
(id, material_code, name, type, supplier, unit_cost, stock) VALUES
(1, 'MAT-001', 'Madera roble', 'Madera', 'Maderas del Norte', 150000, 25),
(2, 'MAT-002', 'Madera pino', 'Madera', 'Maderas Bogotá', 95000, 40),
(3, 'MAT-003', 'Tela lino', 'Tela', 'Textiles Colombia', 80000, 30),
(4, 'MAT-004', 'Espuma alta densidad', 'Relleno', 'Espumas SAS', 60000, 20),
(5, 'MAT-005', 'Tornillos industriales', 'Herraje', NULL, 12000, 100),
(6, 'MAT-006', 'Barniz natural', 'Acabado', 'Pinturas Bogotá', 35000, 18);
GO

INSERT INTO dbo.orders
(id, customer_name, customer_phone, product_id, quantity, order_status, order_date) VALUES
(1, 'Carlos Pérez', '3001112233', 1, 1, 'Pagado', '2026-04-01'),
(2, 'Laura Gómez', NULL, 6, 1, 'Pendiente', '2026-04-02'),
(3, 'Andrés Rodríguez', '3112223344', 11, 1, 'En preparación', '2026-04-03'),
(4, 'María Torres', '3203334455', 17, 3, 'Pagado', '2026-04-04'),
(5, 'Camila Rojas', NULL, 21, 2, 'Entregado', '2026-04-05'),
(6, 'Sofía Martínez', '3015556677', 2, 1, 'Pendiente', '2026-04-06'),
(7, 'Juan López', NULL, 8, 1, 'Pagado', '2026-04-07'),
(8, 'Diana Castro', '3107778899', 18, 1, 'Entregado', '2026-04-08'),
(9, 'Pedro Sánchez', '3028889900', 23, 2, 'En preparación', '2026-04-09'),
(10, 'Natalia Ruiz', NULL, 29, 1, 'Pendiente', '2026-04-10'),
(11, 'Felipe Mora', '3130001111', 4, 1, 'Pagado', '2026-04-11'),
(12, 'Valentina Díaz', NULL, 27, 1, 'Cancelado', '2026-04-12');
GO

INSERT INTO dbo.deliveries
(id, order_id, delivery_address, city, delivery_status, delivery_date) VALUES
(1, 1, 'Calle 10 # 15-20', 'Bogotá', 'Entregada', '2026-04-06'),
(2, 2, 'Carrera 8 # 22-40', 'Soacha', 'Programada', '2026-04-07'),
(3, 3, 'Avenida 68 # 45-10', 'Bogotá', 'Pendiente', NULL),
(4, 4, 'Calle 80 # 90-15', 'Bogotá', 'En camino', '2026-04-09'),
(5, 5, 'Carrera 30 # 12-50', 'Chía', 'Entregada', '2026-04-10'),
(6, 7, 'Calle 50 # 20-15', 'Bogotá', 'Programada', NULL),
(7, 8, 'Transversal 15 # 110-30', 'Bogotá', 'Entregada', '2026-04-12'),
(8, 9, 'Calle 72 # 11-40', 'Bogotá', 'Pendiente', NULL);
GO

-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Consulta 1: productos donde la observación es desconocida / NULL
SELECT
    id,
    sku,
    name AS [Producto],
    category AS [Categoría],
    notes AS [Observación]
FROM dbo.products
WHERE notes IS NULL
ORDER BY id;
GO

-- Consulta 2: productos usando COALESCE para mostrar un texto cuando notes sea NULL
SELECT
    id,
    sku,
    name AS [Producto],
    category AS [Categoría],
    COALESCE(notes, 'Sin observación registrada') AS [Observación visible]
FROM dbo.products
ORDER BY id;
GO

-- Consulta 3: pedidos con teléfono NULL
SELECT
    id AS [Pedido],
    customer_name AS [Cliente],
    customer_phone AS [Teléfono]
FROM dbo.orders
WHERE customer_phone IS NULL
ORDER BY id;
GO

-- Consulta 4: pedidos mostrando teléfono con COALESCE
SELECT
    id AS [Pedido],
    customer_name AS [Cliente],
    COALESCE(customer_phone, 'Sin teléfono registrado') AS [Teléfono visible],
    order_status AS [Estado]
FROM dbo.orders
ORDER BY id;
GO

-- Consulta 5: verificación de constraints creados en las tablas del dominio
SELECT
    tc.TABLE_NAME AS [Tabla],
    tc.CONSTRAINT_NAME AS [Constraint],
    tc.CONSTRAINT_TYPE AS [Tipo]
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
WHERE tc.TABLE_SCHEMA = 'dbo'
  AND tc.TABLE_NAME IN ('product_categories', 'products', 'materials', 'orders', 'deliveries')
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_TYPE;
GO
