-- ===============================================================
-- DỰ ÁN: HEALTHSYNC - TÁI CẤU TRÚC CƠ SỞ DỮ LIỆU
-- ===============================================================

CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 1. TẠO CÁC BẢNG NỀN TẢNG (DANH MỤC)
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 2. TÁI CẤU TRÚC BẢNG APPOINTMENTS KHỚP ACTIVITY DIAGRAM
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    deposit_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 3. BỔ SUNG BẢNG PRESCRIPTIONS (ĐƠN THUỐC)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    medication_details TEXT NOT NULL,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE RESTRICT
);

-- ===============================================================
-- MÔ PHỎNG DỮ LIỆU THỰC TẾ (DML TEST SCENARIOS)
-- ===============================================================

-- Thêm dữ liệu mẫu ban đầu
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van An', '0912345678'),
('Tran Thi Binh', '0987654321');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Hoang Minh', 'Noi tong quat'),
('BS. Pham Ngoc Lan', 'Nhi khoa');

-- KỊCH BẢN 1: QUY TRÌNH KHÁM BỆNH THÀNH CÔNG HOÀN TẤT
-- Bước 1.1: Đặt lịch PENDING với tiền cọc 500.000đ
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount) 
VALUES (1, 1, '2026-10-15 09:00:00', 'PENDING', 500000.00);

-- Bước 1.2: Bệnh nhân đến phòng khám (CHECKED_IN)
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = 1;

-- Bước 1.3: Bác sĩ khám xong (COMPLETED)
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = 1;

-- Bước 1.4: Kê đơn thuốc cho lịch hẹn 1
INSERT INTO Prescriptions (appointment_id, medication_details) 
VALUES (1, 'Paracetamol 500mg (20 vien, ngay uong 2 vien sau an), Vitamin C 500mg (10 vien)');

-- KỊCH BẢN 2: BỆNH NHÂN HỦY LỊCH VÀ PHẠT TIỀN CỌC
-- Bước 2.1: Đặt lịch và đã duyệt cọc 300.000đ (CONFIRMED)
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount) 
VALUES (2, 2, '2026-10-16 14:30:00', 'CONFIRMED', 300000.00);

-- Bước 2.2: Hủy lịch sau khi CONFIRMED -> Phạt 150.000đ và ghi lý do
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00 
WHERE appointment_id = 2;

-- ===============================================================
-- TRUY VẤN KIỂM CHỨNG TOÀN VẸN
-- ===============================================================
-- 1. Xem toàn bộ lịch hẹn và trạng thái tài chính
SELECT * FROM Appointments;

-- 2. Truy vấn danh sách lịch hẹn COMPLETED kèm đơn thuốc
SELECT 
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date,
    a.status,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';