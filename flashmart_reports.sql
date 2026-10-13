-- ===============================================================
-- DỰ ÁN: FLASHMART - TỐI ƯU HÓA BÁO CÁO TRUY VẤN DỮ LIỆU
-- ===============================================================

CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- 1. KHỞI TẠO BẢNG VÀ NẠP DỮ LIỆU MẪU
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY, 
    product_name VARCHAR(50) NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Nạp dữ liệu mẫu
INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie'); -- Charlie chưa mua hàng

INSERT INTO Products VALUES 
(101, 'Laptop'), 
(102, 'Mouse'), 
(103, 'Keyboard'); -- Keyboard chưa được ai mua

INSERT INTO Orders VALUES 
(1001, 1, 101), 
(1002, 1, 102), 
(1003, 2, 101);

-- ===============================================================
-- BÁO CÁO 1: MARKETING (TẤT CẢ KHÁCH HÀNG & SỐ ĐƠN HÀNG)
-- Giải pháp: LEFT JOIN kết hợp COUNT(o.order_id)
-- Kết quả kỳ vọng: Alice: 2, Bob: 1, Charlie: 0
-- ===============================================================
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ===============================================================
-- BÁO CÁO 2: KHO VẬN (SẢN PHẨM TỒN CHƯA TỪNG BÁN RA - ANTI-JOIN)
-- Giải pháp: LEFT JOIN kết hợp WHERE o.order_id IS NULL
-- Kết quả kỳ vọng: product_id: 103, product_name: Keyboard
-- ===============================================================
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;