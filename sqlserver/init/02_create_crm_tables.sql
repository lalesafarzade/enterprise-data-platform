USE [crm-db];
GO

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Customers'
)
BEGIN
    CREATE TABLE Customers
    (
        customer_id INT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL,
        phone VARCHAR(20),
        created_at DATETIME2 NOT NULL,
        status VARCHAR(20) NOT NULL
    );
END
GO


IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Addresses'
)
BEGIN
    CREATE TABLE Addresses
    (
        address_id INT PRIMARY KEY,
        customer_id INT NOT NULL,
        street VARCHAR(100),
        city VARCHAR(50),
        state VARCHAR(20),
        zip_code VARCHAR(20),
        country VARCHAR(30),

        CONSTRAINT FK_Addresses_Customers
            FOREIGN KEY (customer_id)
            REFERENCES Customers(customer_id)
    );
END
GO