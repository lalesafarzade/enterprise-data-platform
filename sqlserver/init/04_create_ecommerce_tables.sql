USE [ecommerce_db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Orders'
)
BEGIN
    CREATE TABLE Orders
    (
        order_id INT PRIMARY KEY,
        customer_id INT NOT NULL,
        order_date DATETIME2 NOT NULL,
        order_status VARCHAR(30) NOT NULL,
        total_amount DECIMAL(12,2) NOT NULL,
        shipping_city VARCHAR(50),
        shipping_state VARCHAR(20),
        created_at DATETIME2 NOT NULL
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'OrderItems'
)
BEGIN
    CREATE TABLE OrderItems
    (
        order_item_id INT PRIMARY KEY,
        order_id INT NOT NULL,
        product_id INT NOT NULL,
        quantity INT NOT NULL,
        unit_price DECIMAL(12,2) NOT NULL,
        line_amount DECIMAL(12,2) NOT NULL,

        CONSTRAINT FK_OrderItems_Orders
            FOREIGN KEY (order_id)
            REFERENCES Orders(order_id)
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Payments'
)
BEGIN
    CREATE TABLE Payments
    (
        payment_id INT PRIMARY KEY,
        order_id INT NOT NULL,
        payment_date DATETIME2 NOT NULL,
        payment_method VARCHAR(30) NOT NULL,
        payment_status VARCHAR(30) NOT NULL,
        amount DECIMAL(12,2) NOT NULL,

        CONSTRAINT FK_Payments_Orders
            FOREIGN KEY (order_id)
            REFERENCES Orders(order_id)
    );
END
GO