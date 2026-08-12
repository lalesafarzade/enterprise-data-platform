USE [erp_db];
GO

INSERT INTO Suppliers
(
    supplier_id,
    supplier_name,
    contact_email,
    country,
    created_at,
    status
)
VALUES
(2001, 'Atlantic Distribution', 'contact@atlantic.example.com',
 'USA', '2024-01-10', 'ACTIVE'),

(2002, 'Carolina Supply Co', 'sales@carolinasupply.example.com',
 'USA', '2024-01-15', 'ACTIVE'),

(2003, 'Global Components Ltd', 'sales@globalcomponents.example.com',
 'Canada', '2024-02-01', 'ACTIVE'),

(2004, 'European Industrial Supply', 'contact@eis.example.com',
 'Germany', '2024-02-15', 'ACTIVE'),

(2005, 'Pacific Manufacturing', 'sales@pacificmfg.example.com',
 'USA', '2024-03-01', 'ACTIVE');
GO

INSERT INTO Products
(
    product_id,
    supplier_id,
    product_name,
    category,
    unit_price,
    created_at,
    status
)
VALUES
(3001, 2001, 'Wireless Keyboard', 'Electronics',
 49.99, '2024-04-01', 'ACTIVE'),

(3002, 2001, 'Wireless Mouse', 'Electronics',
 29.99, '2024-04-01', 'ACTIVE'),

(3003, 2002, 'USB-C Hub', 'Electronics',
 39.99, '2024-04-05', 'ACTIVE'),

(3004, 2002, '27-inch Monitor', 'Electronics',
 249.99, '2024-04-10', 'ACTIVE'),

(3005, 2003, 'Laptop Stand', 'Accessories',
 59.99, '2024-04-15', 'ACTIVE'),

(3006, 2003, 'Webcam', 'Electronics',
 89.99, '2024-05-01', 'ACTIVE'),

(3007, 2004, 'Office Chair', 'Furniture',
 399.99, '2024-05-10', 'ACTIVE'),

(3008, 2004, 'Standing Desk', 'Furniture',
 599.99, '2024-05-15', 'ACTIVE'),

(3009, 2005, 'Desk Lamp', 'Office',
 44.99, '2024-06-01', 'ACTIVE'),

(3010, 2005, 'Power Strip', 'Office',
 24.99, '2024-06-05', 'ACTIVE');
GO

INSERT INTO Inventory
(
    inventory_id,
    product_id,
    warehouse_location,
    quantity_on_hand,
    reorder_level,
    last_updated
)
VALUES
(4001, 3001, 'Charlotte-WH1', 150, 30, '2025-01-15'),
(4002, 3002, 'Charlotte-WH1', 220, 40, '2025-01-15'),
(4003, 3003, 'Charlotte-WH1', 85, 20, '2025-01-16'),
(4004, 3004, 'Charlotte-WH1', 45, 10, '2025-01-16'),
(4005, 3005, 'Charlotte-WH1', 75, 15, '2025-01-17'),

(4006, 3006, 'Charlotte-WH2', 60, 15, '2025-01-18'),
(4007, 3007, 'Charlotte-WH2', 25, 5, '2025-01-18'),
(4008, 3008, 'Charlotte-WH2', 18, 5, '2025-01-19'),
(4009, 3009, 'Charlotte-WH2', 120, 25, '2025-01-20'),
(4010, 3010, 'Charlotte-WH2', 200, 40, '2025-01-20');
GO