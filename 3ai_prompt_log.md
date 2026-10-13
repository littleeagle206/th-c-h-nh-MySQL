# Nhật Ký Tương Tác AI (AI Prompt Log) - Dự Án FlashMart

### Phiên 1: Khác biệt giữa COUNT(*) và COUNT(column) khi LEFT JOIN
* **Prompt gửi AI:** "Khi tôi sử dụng LEFT JOIN và đếm số lượng đơn hàng bằng hàm COUNT, tôi nên dùng COUNT(*) hay COUNT(tên_cột_khóa_chính_bảng_order)? Sự khác biệt khi kết quả trả về NULL là gì?"
* **AI phản hồi:** Giải thích cơ chế `COUNT(*)` đếm mọi hàng vật lý kể cả khi toàn bộ cột bảng phụ là NULL, trong khi `COUNT(column)` tự động bỏ qua NULL.
* **Áp dụng:** Sử dụng `COUNT(o.order_id)` trong câu lệnh báo cáo Marketing để khách hàng chưa mua hàng nhận kết quả bằng 0.

---

### Phiên 2: Phân tích hiệu năng Anti-Join (LEFT JOIN ... IS NULL vs NOT IN)
* **Prompt gửi AI:** "Hãy phân tích hiệu năng (Performance) của việc dùng LEFT JOIN kết hợp IS NULL so với việc dùng subquery NOT IN khi muốn tìm kiếm các bản ghi không tồn tại trong bảng khác."
* **AI phản hồi:** Phân tích rằng `NOT IN` có thể gặp vấn đề hiệu năng nghiêm trọng và trả về kết quả rỗng nếu cột con chứa giá trị `NULL`. Kỹ thuật `LEFT JOIN ... WHERE IS NULL` cho phép MySQL tận dụng index trên khóa chính và tối ưu hóa tốt hơn qua cơ chế kiểm tra sự tồn tại (Anti-join optimization).
* **Áp dụng:** Dùng cấu trúc `LEFT JOIN ... WHERE o.order_id IS NULL` cho báo cáo Kho vận.

---

### Phiên 3: Tối ưu hóa thuật toán JOIN của MySQL
* **Prompt gửi AI:** "Bộ tối ưu hóa truy vấn của MySQL thực thi các câu lệnh JOIN bằng thuật toán gì? Nested-Loop Join hoạt động ra sao?"
* **AI phản hồi:** Giải thích thuật toán Block Nested-Loop (BNL) và Hash Join (từ MySQL 8.0.18 trở đi), nhấn mạnh vai trò của Driving Table và tầm quan trọng của việc đánh chỉ mục (Index) trên khóa ngoại.
* **Áp dụng:** Nắm vững cơ chế chọn Driving Table để bảo vệ trong phần vấn đáp với CDO.