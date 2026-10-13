-- ===============================================================
-- DỰ ÁN: AUTORIDE - TÁI CẤU TRÚC VÀ TỐI ƯU CƠ SỞ DỮ LIỆU
-- ===============================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- 1. TẠO CÁC BẢNG THEO THIẾT KẾ CŨ ĐỂ ÁP DỤNG ALTER TABLE
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status VARCHAR(50) DEFAULT 'BOOKED',
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- ===============================================================
-- 2. DDL: NÂNG CẤP BẢNG RENTALS BẰNG LỆNH ALTER TABLE
-- ===============================================================

-- Chuẩn hóa cột status sang ENUM và thêm các cột tài chính (DECIMAL)
ALTER TABLE Rentals 
    MODIFY COLUMN status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    ADD COLUMN security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00 AFTER return_date,
    ADD COLUMN late_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00 AFTER security_deposit,
    ADD COLUMN damage_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00 AFTER late_fee;

-- ===============================================================
-- 3. DDL: TẠO MỚI BẢNG INSPECTIONS (BIÊN BẢN KIỂM TRA XE)
-- ===============================================================

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_inspections_rentals 
        FOREIGN KEY (rental_id) 
        REFERENCES Rentals(rental_id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- ===============================================================
-- 4. DML: KỊCH BẢN DỮ LIỆU MÔ PHỎNG THỰC TẾ
-- ===============================================================

-- Thêm xe mẫu
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Camry 2.5Q', '30F-123.45');

-- Kịch bản: Khách hàng "Nguyen Van A" thuê xe, đóng cọc 10.000.000 VNĐ, trạng thái ACTIVE
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit) 
VALUES (1, 'Nguyen Van A', '2026-10-10 08:00:00', 'ACTIVE', 10000000.00);

-- Khi khách trả xe: Nhân viên kiểm tra phát hiện vỡ đèn pha -> Tạo biên bản Inspection
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name) 
VALUES (1, '2026-10-12 17:00:00', 'Vo den pha trai, can thay moi', 'Tran Van Kiem');

-- Cập nhật hợp đồng: Hoàn tất (COMPLETED), phạt hư hỏng 2.000.000 VNĐ, phạt trễ 0 VNĐ
UPDATE Rentals 
SET status = 'COMPLETED',
    return_date = '2026-10-12 17:00:00',
    late_fee = 0.00,
    damage_fee = 2000000.00 
WHERE rental_id = 1;

-- ===============================================================
-- 5. TRUY VẤN: TÍNH TIỀN HOÀN LẠI THỰC TẾ CHO KHÁCH HÀNG
-- ===============================================================

SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.status,
    i.damage_description,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;