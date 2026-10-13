# Báo Cáo Phân Tích Hiệu Năng Truy Vấn (EXPLAIN Analysis) - PayFlow

Sau khi rà soát bằng lệnh `EXPLAIN`, sự khác biệt về kế hoạch thực thi trước và sau khi tối ưu thể hiện rõ qua các chỉ số:

1. **Trước tối ưu:**
   - **`type: ALL`**: MySQL phải thực hiện quét toàn bộ bảng (Full Table Scan) do biểu thức `YEAR()` và `MONTH()` bọc quanh cột `created_at` làm mất tính SARGable.
   - **`rows`**: Dự kiến quét toàn bộ ~5.000.000 dòng dữ liệu, khiến CPU vọt lên 100% và gây khóa tài nguyên trong 45 giây.

2. **Sau tối ưu:**
   - **`type: range`** (hoặc `ref`): Chuyển thành tìm kiếm phạm vi trên cây B-Tree.
   - **`key: idx_type_date`**: Hệ thống tận dụng thành công chỉ mục kết hợp `(transaction_type, created_at)`.
   - **`rows`**: Lượng dòng cần quét giảm từ hàng triệu xuống chỉ còn vài nghìn dòng thực tế trong tháng 6/2026.

Thời gian truy vấn giảm từ 45 giây xuống dưới 0.1 giây, giải quyết triệt để sự cố nghẽn mạng và timeout hệ thống.