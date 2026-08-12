USE [crm-db];
GO

-- Insert Customers
INSERT INTO Customers
    (customer_id, first_name, last_name, email, phone, created_at, status)
VALUES
    (1001, 'James', 'Carter', 'james.carter@example.com',
     '704-555-0101', '2025-01-15', 'ACTIVE'),

    (1002, 'Emily', 'Johnson', 'emily.johnson@example.com',
     '704-555-0102', '2025-01-20', 'ACTIVE'),

    (1003, 'Michael', 'Brown', 'michael.brown@example.com',
     '980-555-0103', '2025-02-03', 'ACTIVE'),

    (1004, 'Sophia', 'Davis', 'sophia.davis@example.com',
     '803-555-0104', '2025-02-10', 'INACTIVE'),

    (1005, 'Daniel', 'Wilson', 'daniel.wilson@example.com',
     '704-555-0105', '2025-02-18', 'ACTIVE');
GO


-- Insert Addresses
INSERT INTO Addresses
    (address_id, customer_id, street, city, state, zip_code, country)
VALUES
    (1, 1001, '100 Main Street', 'Charlotte', 'NC', '28202', 'USA'),
    (2, 1002, '200 Park Avenue', 'Fort Mill', 'SC', '29715', 'USA'),
    (3, 1003, '300 Oak Street', 'Charlotte', 'NC', '28209', 'USA'),
    (4, 1004, '400 Pine Road', 'Rock Hill', 'SC', '29730', 'USA'),
    (5, 1005, '500 Lake Drive', 'Charlotte', 'NC', '28210', 'USA');
GO