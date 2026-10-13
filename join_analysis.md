# Giải Trình Kỹ Thuật: COUNT(o.order_id) vs COUNT(*) Khi Dùng LEFT JOIN

Trong truy vấn `LEFT JOIN`, khi một khách hàng chưa từng mua hàng (như Charlie), hệ thống vẫn giữ lại dòng của khách hàng đó và ghép nối với một dòng dữ liệu giả chứa toàn bộ giá trị `NULL` cho các cột của bảng `Orders`.

Hàm `COUNT(*)` đếm tổng số dòng vật lý được sinh ra, do đó nó sẽ tính cả dòng chứa giá trị `NULL` của Charlie và cho ra kết quả sai lệch là **1 đơn hàng**. 

Ngược lại, hàm `COUNT(o.order_id)` chỉ đếm các giá trị khác `NULL` trên cột `order_id`. Khi gặp dòng của Charlie (`o.order_id` là `NULL`), hàm sẽ bỏ qua và trả về chính xác **0 đơn hàng**, phản ánh đúng thực tế nghiệp vụ.