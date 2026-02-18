
CREATE DATABASE sales_performance;
USE sales_performance;



CREATE TABLE regions (
    region_id   INT PRIMARY KEY AUTO_INCREMENT,
    region_name VARCHAR(50) NOT NULL,
    country     VARCHAR(50) NOT NULL,
    manager     VARCHAR(100)
);

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    region_id     INT,
    signup_date   DATE,
    customer_tier VARCHAR(20),        -- Bronze, Silver, Gold
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE products (
    product_id       INT PRIMARY KEY AUTO_INCREMENT,
    product_name     VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    unit_price       DECIMAL(10,2),
    cost_price       DECIMAL(10,2)
);

CREATE TABLE sales (
    transaction_id   INT PRIMARY KEY AUTO_INCREMENT,
    sale_date        DATE NOT NULL,
    customer_id      INT,
    product_id       INT,
    region_id        INT,
    units_sold       INT NOT NULL,
    unit_price       DECIMAL(10,2),
    discount_pct     DECIMAL(5,2) DEFAULT 0,
    revenue          DECIMAL(10,2),   -- units_sold * unit_price * (1 - discount)
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (region_id)   REFERENCES regions(region_id)
);

-- =============================================
-- SAMPLE DATA — REGIONS
-- =============================================
INSERT INTO regions (region_name, country, manager) VALUES
('North East',  'USA', 'Sarah Johnson'),
('South East',  'USA', 'Michael Brown'),
('Midwest',     'USA', 'Emily Davis'),
('West Coast',  'USA', 'James Wilson'),
('South West',  'USA', 'Linda Martinez'),
('North West',  'USA', 'Robert Taylor'),
('Central',     'USA', 'Patricia Anderson'),
('Mid Atlantic','USA', 'Charles Thomas');

-- =============================================
-- SAMPLE DATA — PRODUCTS
-- =============================================
INSERT INTO products (product_name, product_category, unit_price, cost_price) VALUES
('Laptop Pro 15',       'Electronics',   1299.99,  850.00),
('Wireless Mouse',      'Electronics',     29.99,   10.00),
('USB-C Hub',           'Electronics',     49.99,   18.00),
('Office Chair',        'Furniture',      349.99,  180.00),
('Standing Desk',       'Furniture',      599.99,  310.00),
('Desk Lamp',           'Furniture',       39.99,   12.00),
('Notebook Pack',       'Stationery',       9.99,    3.00),
('Ballpoint Pens',      'Stationery',       4.99,    1.50),
('Whiteboard',          'Stationery',      89.99,   35.00),
('Monitor 27"',         'Electronics',    399.99,  220.00),
('Keyboard Mechanical', 'Electronics',    129.99,   55.00),
('File Cabinet',        'Furniture',      199.99,   95.00),
('Webcam HD',           'Electronics',     79.99,   30.00),
('Headset Pro',         'Electronics',    149.99,   65.00),
('Sticky Notes',        'Stationery',       3.99,    1.00);


-- SAMPLE DATA — CUSTOMERS

INSERT INTO customers (first_name, last_name, email, region_id, signup_date, customer_tier) VALUES
('James',     'Smith',     'james.smith@email.com',     1, '2022-03-15', 'Gold'),
('Mary',      'Johnson',   'mary.johnson@email.com',    2, '2022-06-20', 'Silver'),
('Robert',    'Williams',  'robert.w@email.com',        3, '2022-01-10', 'Gold'),
('Patricia',  'Brown',     'patricia.b@email.com',      4, '2023-02-28', 'Bronze'),
('Michael',   'Jones',     'michael.j@email.com',       5, '2022-11-05', 'Silver'),
('Linda',     'Garcia',    'linda.g@email.com',         6, '2023-05-17', 'Bronze'),
('William',   'Miller',    'william.m@email.com',       7, '2022-08-22', 'Gold'),
('Barbara',   'Davis',     'barbara.d@email.com',       8, '2023-01-30', 'Silver'),
('David',     'Martinez',  'david.m@email.com',         1, '2022-04-12', 'Bronze'),
('Elizabeth', 'Hernandez', 'elizabeth.h@email.com',     2, '2023-07-08', 'Gold'),
('Richard',   'Lopez',     'richard.l@email.com',       3, '2022-09-25', 'Silver'),
('Susan',     'Gonzalez',  'susan.g@email.com',         4, '2023-03-14', 'Bronze'),
('Joseph',    'Wilson',    'joseph.w@email.com',        5, '2022-12-01', 'Gold'),
('Jessica',   'Anderson',  'jessica.a@email.com',       6, '2023-06-19', 'Silver'),
('Thomas',    'Thomas',    'thomas.t@email.com',        7, '2022-07-30', 'Bronze'),
('Sarah',     'Taylor',    'sarah.t@email.com',         8, '2023-04-25', 'Gold'),
('Charles',   'Moore',     'charles.m@email.com',       1, '2022-05-18', 'Silver'),
('Karen',     'Jackson',   'karen.j@email.com',         2, '2023-08-11', 'Bronze'),
('Daniel',    'Martin',    'daniel.m@email.com',        3, '2022-10-07', 'Gold'),
('Nancy',     'Lee',       'nancy.l@email.com',         4, '2023-02-03', 'Silver');


-- SAMPLE DATA — SALES (2023 & 2024)

INSERT INTO sales (sale_date, customer_id, product_id, region_id, units_sold, unit_price, discount_pct, revenue) VALUES
-- 2023 Q1
('2023-01-05',  1,  1, 1, 2, 1299.99, 0.05, 2469.98),
('2023-01-12',  2,  4, 2, 3,  349.99, 0.00, 1049.97),
('2023-01-20',  3, 10, 3, 1,  399.99, 0.10,  719.98),
('2023-02-03',  4,  2, 4, 5,   29.99, 0.00,  149.95),
('2023-02-14',  5,  5, 5, 1,  599.99, 0.15,  509.99),
('2023-02-22',  6,  7, 6, 4,   9.99,  0.00,   39.96),
('2023-03-01',  7, 11, 7, 2,  129.99, 0.05,  246.98),
('2023-03-15',  8, 14, 8, 3,  149.99, 0.00,  449.97),
('2023-03-28',  9,  3, 1, 6,   49.99, 0.10,  269.95),
('2023-03-30', 10,  6, 2, 2,   39.99, 0.00,   79.98),

-- 2023 Q2
('2023-04-05', 11,  1, 3, 1, 1299.99, 0.00, 1299.99),
('2023-04-18', 12,  8, 4, 8,    4.99, 0.00,   39.92),
('2023-04-25', 13,  9, 5, 3,   89.99, 0.05,  256.47),
('2023-05-02', 14, 12, 6, 2,  199.99, 0.10,  539.97),
('2023-05-17', 15, 13, 7, 4,   79.99, 0.00,  319.96),
('2023-05-29', 16,  2, 8, 1,   29.99, 0.00,  149.95),
('2023-06-03', 17,  4, 1, 3,  349.99, 0.05,  997.47),
('2023-06-14', 18,  5, 2, 1,  599.99, 0.00,  599.99),
('2023-06-22', 19, 10, 3, 2,  399.99, 0.10,  719.98),
('2023-06-30', 20, 15, 4, 4,    3.99, 0.00,   19.95),

-- 2023 Q3
('2023-07-08',  1, 11, 1, 3,  129.99, 0.00,  389.97),
('2023-07-19',  2, 14, 2, 2,  149.99, 0.05,  427.47),
('2023-07-27',  3,  6, 3, 1,   39.99, 0.00,  199.95),
('2023-08-04',  4,  1, 4, 2, 1299.99, 0.10, 2339.98),
('2023-08-15',  5,  3, 5, 4,   49.99, 0.00,  249.95),
('2023-08-23',  6,  9, 6, 3,   89.99, 0.05,  256.47),
('2023-09-01',  7,  2, 7, 1,   29.99, 0.00,  149.95),
('2023-09-12', 8,  13, 8, 2,   79.99, 0.10,  431.95),
('2023-09-20',  9,  5, 1, 3,  599.99, 0.00, 1199.98),
('2023-09-29', 10,  7, 2, 4,    9.99, 0.00,   49.95),

-- 2023 Q4
('2023-10-06', 11, 10, 3, 2,  399.99, 0.05,  759.98),
('2023-10-17', 12,  4, 4, 1,  349.99, 0.00,  699.98),
('2023-10-25', 13, 12, 5, 3,  199.99, 0.10,  539.97),
('2023-11-03', 14,  1, 6, 2, 1299.99, 0.15, 2209.98),
('2023-11-11', 15, 14, 7, 4,  149.99, 0.00,  599.96),
('2023-11-24', 16,  8, 8, 1,    4.99, 0.00,   24.95),
('2023-12-02', 17,  5, 1, 3,  599.99, 0.10, 1079.98),
('2023-12-13', 18, 11, 2, 2,  129.99, 0.05,  493.96),
('2023-12-21', 19,  2, 3, 4,   29.99, 0.00,  149.95),
('2023-12-30', 20,  6, 4, 1,   39.99, 0.00,  119.97),

-- 2024 Q1
('2024-01-07',  1,  1, 1, 3, 1299.99, 0.05, 3704.97),
('2024-01-15',  2, 10, 2, 2,  399.99, 0.00,  799.98),
('2024-01-23',  3,  4, 3, 1,  349.99, 0.10,  944.97),
('2024-02-05',  4, 14, 4, 3,  149.99, 0.00,  599.96),
('2024-02-16',  5,  5, 5, 2,  599.99, 0.05, 1139.98),
('2024-02-25',  6, 11, 6, 4,  129.99, 0.00,  519.96),
('2024-03-04',  7,  2, 7, 1,   29.99, 0.00,  209.93),
('2024-03-13',  8,  9, 8, 2,   89.99, 0.10,  485.95),
('2024-03-22',  9, 13, 1, 3,   79.99, 0.05,  303.96),
('2024-03-31', 10,  3, 2, 4,   49.99, 0.00,  249.95),

-- 2024 Q2
('2024-04-08', 11,  1, 3, 2, 1299.99, 0.00, 2599.98),
('2024-04-19', 12,  6, 4, 1,   39.99, 0.00,  159.96),
('2024-04-27', 13, 12, 5, 3,  199.99, 0.05, 1139.94),
('2024-05-06', 14,  7, 6, 2,    9.99, 0.00,   49.95),
('2024-05-14', 15,  4, 7, 4,  349.99, 0.10,  944.97),
('2024-05-23', 16, 10, 8, 1,  399.99, 0.00,  799.98),
('2024-06-01', 17, 14, 1, 3,  149.99, 0.05,  569.96),
('2024-06-12', 18,  5, 2, 2,  599.99, 0.00, 1199.98),
('2024-06-20', 19, 11, 3, 4,  129.99, 0.10,  701.95),
('2024-06-28', 20,  2, 4, 1,   29.99, 0.00,  149.95),

-- 2024 Q3
('2024-07-05',  1, 15, 1, 4,    3.99, 0.00,   15.96),
('2024-07-16',  2,  1, 2, 2, 1299.99, 0.10, 2339.98),
('2024-07-24',  3,  8, 3, 1,    4.99, 0.00,   24.95),
('2024-08-02',  4,  5, 4, 3,  599.99, 0.05, 1139.98),
('2024-08-13',  5, 13, 5, 2,   79.99, 0.00,  399.95),
('2024-08-21',  6,  4, 6, 4,  349.99, 0.10,  944.97),
('2024-09-03',  7, 10, 7, 1,  399.99, 0.05,  759.98),
('2024-09-14',  8, 14, 8, 2,  149.99, 0.00,  749.95),
('2024-09-22',  9,  6, 1, 3,   39.99, 0.00,  199.95),
('2024-09-30', 10, 11, 2, 4,  129.99, 0.05,  493.96),

-- 2024 Q4
('2024-10-07', 11,  1, 3, 3, 1299.99, 0.00, 3899.97),
('2024-10-18', 12,  9, 4, 1,   89.99, 0.05,  256.47),
('2024-10-26', 13,  5, 5, 2,  599.99, 0.10, 1079.98),
('2024-11-04', 14, 12, 6, 4,  199.99, 0.00,  799.96),
('2024-11-12', 15,  2, 7, 1,   29.99, 0.00,  149.95),
('2024-11-25', 16,  4, 8, 3,  349.99, 0.15,  892.47),
('2024-12-03', 17, 10, 1, 2,  399.99, 0.05,  759.98),
('2024-12-14', 18, 14, 2, 4,  149.99, 0.00,  599.96),
('2024-12-22', 19,  1, 3, 1, 1299.99, 0.10, 2339.98),
('2024-12-31', 20,  7, 4, 3,    9.99, 0.00,   49.95);


-- VERIFY DATA

SELECT COUNT(*)  AS total_transactions FROM sales;
SELECT SUM(revenue) AS total_revenue   FROM sales;
SELECT DISTINCT YEAR(sale_date)        FROM sales ORDER BY 1;
