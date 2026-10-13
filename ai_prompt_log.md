# Nhật Ký Tương Tác AI (AI Prompt Log) - Dự Án AutoRide

### Phiên 1: Lựa chọn kiểu dữ liệu cho tiền cọc và phí phạt
* **Prompt gửi AI:** "Khi thiết kế cột security_deposit, late_fee và damage_fee trong MySQL phục vụ tính toán tài chính và tiền hoàn lại, tại sao nên dùng DECIMAL(12, 2) thay vì FLOAT hay DOUBLE?"
* **AI phản hồi:** Giải thích rằng kiểu `FLOAT`/`DOUBLE` sử dụng chuẩn biểu diễn số thực dấu chấm động nhị phân (IEEE 754), gây ra sai số làm tròn số học khi cộng trừ tiền. Kiểu `DECIMAL` (Fixed-point) lưu trữ chính xác tuyệt đối từng con số sau dấu phẩy.
* **Quyết định kỹ thuật áp dụng:** Khai báo kiểu `DECIMAL(12, 2)` cho toàn bộ các cột tài chính trong bảng `Rentals`.

---

### Phiên 2: Thiết kế quan hệ giữa Rentals và Inspections
* **Prompt gửi AI:** "Biên bản kiểm tra xe Inspections nên liên kết với Rentals theo quan hệ 1-1 hay 1-N? Nếu một hợp đồng kiểm tra xe nhiều lần (lúc nhận xe và lúc trả xe) thì thiết kế thế nào?"
* **AI phản hồi:** Khuyến nghị thiết kế quan hệ 1-N (một lượt thuê có thể có nhiều biên bản kiểm tra: lúc giao xe và lúc nhận xe). Đặt Khóa ngoại `rental_id` ở bảng `Inspections` kèm ràng buộc `ON DELETE RESTRICT` để bảo đảm không bị mất lịch sử kiểm tra nếu hợp đồng chưa xử lý xong.
* **Quyết định kỹ thuật áp dụng:** Tạo bảng `Inspections` có cột `rental_id` làm khóa ngoại trỏ về `Rentals(rental_id)`.

---

### Phiên 3: Xử lý giá trị NULL khi tính toán tiền hoàn lại
* **Prompt gửi AI:** "Trong SQL, nếu late_fee hoặc damage_fee bị NULL thì phép tính `security_deposit - late_fee - damage_fee` sẽ ra NULL. Làm thế nào để khắc phục?"
* **AI phản hồi:** Sử dụng ràng buộc `NOT NULL DEFAULT 0.00` ngay tại định nghĩa bảng hoặc dùng hàm `COALESCE(late_fee, 0)` trong câu truy vấn.
* **Quyết định kỹ thuật áp dụng:** Thiết lập ràng buộc `NOT NULL DEFAULT 0.00` cho cả 3 cột tài chính trong lệnh `ALTER TABLE`.