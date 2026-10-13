-- ===============================================================
-- DỰ ÁN: PAYFLOW - TỐI ƯU HÓA HIỆU NĂNG BÁO CÁO TÀI CHÍNH
-- ===============================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. TẠO CẤU TRÚC BẢNG NGUYÊN BẢN
DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ===============================================================
-- 2. TẠO COMPOSITE INDEX PHỤC VỤ TRUY VẤN
-- ===============================================================
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- ===============================================================
-- 3. ĐỐI CHIẾU THỰC THI (EXPLAIN)
-- ===============================================================

-- Kế hoạch 1: Truy vấn cũ của Kế toán (Non-SARGable)
-- Kết quả dự kiến: type = ALL, key = NULL, rows ~ 5,000,000
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;

-- Kế hoạch 2: Truy vấn đã được tối ưu (SARGable + Index)
-- Kết quả dự kiến: type = range (hoặc ref), key = idx_type_date, rows giảm mạnh
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';

-- ===============================================================
-- 4. TRUY VẤN THỰC THI TÍNH TỔNG DÒNG TIỀN NẠP
-- ===============================================================
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';