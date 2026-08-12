USE [erp_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Suppliers'
)
BEGIN
    CREATE TABLE Suppliers
    (
        supplier_id INT PRIMARY KEY,
        supplier_name VARCHAR(100) NOT NULL,
        contact_email VARCHAR(100),
        country VARCHAR(50),
        created_at DATETIME2 NOT NULL,
        status VARCHAR(20) NOT NULL
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Products'
)
BEGIN
    CREATE TABLE Products
    (
        product_id INT PRIMARY KEY,
        supplier_id INT NOT NULL,
        product_name VARCHAR(100) NOT NULL,
        category VARCHAR(50),
        unit_price DECIMAL(12,2) NOT NULL,
        created_at DATETIME2 NOT NULL,
        status VARCHAR(20) NOT NULL,

        CONSTRAINT FK_Products_Suppliers
            FOREIGN KEY (supplier_id)
            REFERENCES Suppliers(supplier_id)
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Inventory'
)
BEGIN
    CREATE TABLE Inventory
    (
        inventory_id INT PRIMARY KEY,
        product_id INT NOT NULL,
        warehouse_location VARCHAR(100),
        quantity_on_hand INT NOT NULL,
        reorder_level INT NOT NULL,
        last_updated DATETIME2 NOT NULL,

        CONSTRAINT FK_Inventory_Products
            FOREIGN KEY (product_id)
            REFERENCES Products(product_id)
    );
END
GO