# Nhật Ký Tương Tác AI (AI Prompt Log) - Dự Án HealthSync

### Phiên 1: Xử lý trạng thái vòng đời thực thể
* **Prompt gửi AI:** "Trong thiết kế cơ sở dữ liệu quan hệ MySQL, tại sao việc dùng một cột `is_active` (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng/Lịch hẹn lại là một Anti-pattern? Tôi nên thay thế bằng cấu trúc nào?"
* **AI phản hồi:** Giải thích rằng Boolean chỉ nhận 2 trạng thái bật/tắt, không thể mô tả quy trình nhiều bước; khuyến nghị dùng `ENUM` hoặc tạo bảng trạng thái riêng liên kết bằng Khóa ngoại.
* **Quyết định kỹ thuật áp dụng:** Sử dụng `ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED')` cho cột `status` trong bảng `Appointments`.

---

### Phiên 2: Lựa chọn kiểu dữ liệu tài chính
* **Prompt gửi AI:** "Khi thiết kế cột deposit_amount và penalty_fee trong MySQL phục vụ tính toán tài chính, tôi nên dùng kiểu FLOAT, DOUBLE hay DECIMAL? Tại sao?"
* **AI phản hồi:** Chỉ ra rủi ro làm tròn số của số thực dấu chấm động (floating-point precision error) trên `FLOAT`/`DOUBLE`. Khuyến nghị dùng `DECIMAL(M, D)` (fixed-point) để đảm bảo độ chính xác tuyệt đối từng xu.
* **Quyết định kỹ thuật áp dụng:** Khai báo `DECIMAL(10, 2)` cho cả `deposit_amount` và `penalty_fee`.

---

### Phiên 3: Ràng buộc toàn vẹn khóa ngoại
* **Prompt gửi AI:** "Mối quan hệ giữa Appointments và Prescriptions nên dùng ON DELETE CASCADE hay ON DELETE RESTRICT trong bệnh viện?"
* **AI phản hồi:** Trong y tế, dữ liệu bệnh án và đơn thuốc cần lưu trữ vĩnh viễn vì tính pháp lý. Dùng `RESTRICT` ngăn việc vô tình xóa lịch hẹn làm mất đơn thuốc.
* **Quyết định kỹ thuật áp dụng:** Thiết lập ràng buộc `FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE RESTRICT`.