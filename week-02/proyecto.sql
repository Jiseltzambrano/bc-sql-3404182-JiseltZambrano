USE tienda_madera;
GO

-- ============================================
-- PROYECTO SEMANAL: DDL de tu Dominio
-- Semana 02 — DDL: Diseño de Esquemas
-- Dominio: Tienda de madera / muebles
-- ============================================

-- ============================================
-- LIMPIEZA: eliminar tablas si existen
-- ============================================

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS materials;
DROP TABLE IF EXISTS items;
GO

-- ============================================
-- TABLA 1: Materiales
-- ============================================

CREATE TABLE materials (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(80) NOT NULL,
    supplier VARCHAR(100) NOT NULL,
    cost DECIMAL(12,2) NOT NULL CHECK (cost >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    is_active BIT NOT NULL DEFAULT 1
);
GO

-- ============================================
-- TABLA 2: Productos
-- ============================================

CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(80) NOT NULL,
    material_id INT NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    is_active BIT NOT NULL DEFAULT 1,

    CONSTRAINT FK_products_materials
        FOREIGN KEY (material_id) REFERENCES materials(id)
);
GO

-- ============================================
-- TABLA 3: Pedidos
-- ============================================

CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(120) NOT NULL,
    customer_phone VARCHAR(30) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    order_status VARCHAR(40) NOT NULL DEFAULT 'Pendiente',
    order_date DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_orders_products
        FOREIGN KEY (product_id) REFERENCES products(id)
);
GO

-- ============================================
-- TABLA 4: Entregas
-- ============================================

CREATE TABLE deliveries (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    delivery_address VARCHAR(180) NOT NULL,
    city VARCHAR(80) NOT NULL DEFAULT 'Bogotá',
    delivery_status VARCHAR(40) NOT NULL DEFAULT 'Pendiente',
    delivery_date DATE NULL,

    CONSTRAINT FK_deliveries_orders
        FOREIGN KEY (order_id) REFERENCES orders(id)
);
GO
