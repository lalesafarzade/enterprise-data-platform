USE [ecommerce_db];
GO

-- Orders
INSERT INTO Orders
(
    order_id,
    customer_id,
    order_date,
    order_status,
    total_amount,
    shipping_city,
    shipping_state,
    created_at
)
VALUES
(5001, 1001, '2025-03-01 10:15:00', 'COMPLETED',
 129.97, 'Charlotte', 'NC', '2025-03-01 10:15:00'),

(5002, 1002, '2025-03-03 14:20:00', 'COMPLETED',
 249.99, 'Fort Mill', 'SC', '2025-03-03 14:20:00'),

(5003, 1003, '2025-03-05 09:30:00', 'SHIPPED',
 89.99, 'Charlotte', 'NC', '2025-03-05 09:30:00'),

(5004, 1004, '2025-03-07 16:45:00', 'CANCELLED',
 399.99, 'Rock Hill', 'SC', '2025-03-07 16:45:00'),

(5005, 1005, '2025-03-10 11:10:00', 'COMPLETED',
 659.98, 'Charlotte', 'NC', '2025-03-10 11:10:00');
GO


-- Order Items
INSERT INTO OrderItems
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    line_amount
)
VALUES
(6001, 5001, 3001, 2, 49.99, 99.98),
(6002, 5001, 3002, 1, 29.99, 29.99),

(6003, 5002, 3004, 1, 249.99, 249.99),

(6004, 5003, 3006, 1, 89.99, 89.99),

(6005, 5004, 3007, 1, 399.99, 399.99),

(6006, 5005, 3008, 1, 599.99, 599.99),
(6007, 5005, 3009, 1, 44.99, 44.99),
(6008, 5005, 3010, 1, 24.99, 24.99);
GO


-- Payments
INSERT INTO Payments
(
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_status,
    amount
)
VALUES
(7001, 5001, '2025-03-01 10:16:00',
 'CREDIT_CARD', 'CAPTURED', 129.97),

(7002, 5002, '2025-03-03 14:21:00',
 'PAYPAL', 'CAPTURED', 249.99),

(7003, 5003, '2025-03-05 09:31:00',
 'CREDIT_CARD', 'CAPTURED', 89.99),

(7004, 5004, '2025-03-07 16:46:00',
 'CREDIT_CARD', 'REFUNDED', 399.99),

(7005, 5005, '2025-03-10 11:11:00',
 'CREDIT_CARD', 'CAPTURED', 659.98);
GO