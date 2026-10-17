-- ===============================================================
-- DỰ ÁN: QUICKFEED - TỐI ƯU HÓA HIỆU NĂNG VÀ DUNG LƯỢNG LƯU TRỮ
-- File: quickfeed_index_optimization.sql
-- Vai trò: Database Administrator (DBA)
-- ===============================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. TẠO CẤU TRÚC BẢNG VÀ ÁP ĐẶT OVER-INDEXING (HIỆN TRẠNG CŨ)
DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),
    is_visible BOOLEAN DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255)); 
CREATE INDEX idx_post_type ON Posts(post_type); 
CREATE INDEX idx_is_visible ON Posts(is_visible); 
CREATE INDEX idx_created_at ON Posts(created_at);

-- ===============================================================
-- 2. ĐO LƯỜNG DUNG LƯỢNG DATA VÀ INDEX TRƯỚC KHI TỐI ƯU (TRƯỚC DROP)
-- ===============================================================

-- Cách 1: Dùng SHOW TABLE STATUS
SHOW TABLE STATUS LIKE 'Posts';

-- Cách 2: Truy vấn chi tiết theo đơn vị Megabytes (MB) qua information_schema
SELECT 
    table_name AS `Table`,
    ROUND((data_length / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND((index_length / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- ===============================================================
-- 3. TIẾN HÀNH "PHẪU THUẬT": DROP 3 INDEX GÂY NGHẼN VÀ VÔ DỤNG
-- ===============================================================

-- Xóa index cột TEXT gây phình to dung lượng
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa index cột có Cardinality thấp (chỉ có 3 giá trị)
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa index cột Boolean (chỉ có 2 giá trị 0 và 1)
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- ===============================================================
-- 4. ĐO LƯỜNG VÀ ĐỐI CHIẾU DUNG LƯỢNG SAU KHI TỐI ƯU (SAU DROP)
-- ===============================================================

-- Kiểm tra lại danh sách index còn lại (Chỉ còn PRIMARY, idx_user_id, idx_created_at)
SHOW INDEX FROM Posts;

-- Đối chiếu lại dung lượng qua information_schema (Index_Size_MB giảm mạnh)
SELECT 
    table_name AS `Table`,
    ROUND((data_length / 1024 / 1024), 2) AS `Data_Size_MB`,
    ROUND((index_length / 1024 / 1024), 2) AS `Index_Size_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_Size_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';