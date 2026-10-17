# Báo Cáo Đánh Giá Hiệu Năng & Tài Nguyên Lưu Trữ - QuickFeed

### 1. Phân tích sự đánh đổi (Trade-off) giữa Read và Write
Index giúp tăng tốc truy vấn đọc (`SELECT`), nhưng việc lạm dụng đánh index trên mọi cột khiến hệ thống phải trả giá đắt ở tốc độ ghi (`INSERT`/`UPDATE`). Khi thêm một bài viết mới, MySQL buộc phải thực hiện 5 lần cập nhật ngầm vào các cây B-Tree phụ. Điều này tiêu tốn I/O đĩa và khóa trang dữ liệu, gây ra hiện tượng nghẽn hàng đợi và lỗi timeout 5-10 giây khi người dùng đăng bài.

### 2. Tối ưu hóa Cardinality và Dung lượng (Storage Overhead)
Qua rà soát, chúng tôi tiến hành cắt bỏ 3 Index không hiệu quả:
* **`idx_content`:** Cột `TEXT` làm phình to `Index_length` gấp đôi dữ liệu thực tế.
* **`idx_post_type` & `idx_is_visible`:** Cột có độ phân giải dữ liệu (Cardinality) cực thấp (2 - 3 giá trị). Bộ tối ưu hóa (Query Optimizer) thường bỏ qua index này để Full Table Scan, khiến chi phí duy trì B-Tree trở nên vô nghĩa.

### 3. Kết quả đối chiếu
Chỉ giữ lại 2 index then chốt (`idx_user_id`, `idx_created_at`):
* Giảm 60% thao tác cập nhật cấu trúc B-Tree khi `INSERT` bài viết mới (từ 5 lần xuống 2 lần).
* Giải phóng ngay lập tức dung lượng `Index_length` trong `information_schema.TABLES`, đưa hệ thống trở lại trạng thái phản hồi tức thì và triệt tiêu nguy cơ tràn đĩa (Disk Full).