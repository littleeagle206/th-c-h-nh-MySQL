# Phân Tích Tính Toàn Vẹn: Vai Trò Cột damage_fee - AutoRide

Trong quy trình nghiệp vụ "Thuê và Trả xe", nhánh rẽ kiểm tra phát hiện xe trầy xước/hư hỏng là điểm chạm kinh doanh bắt buộc. Cột `damage_fee` trong bảng `Rentals` đóng vai trò sống còn vì:

1. **Khép kín bài toán tài chính:** Công thức quyết toán tiền cọc `Refund = Security Deposit - Late Fee - Damage Fee` không thể thực thi nếu thiếu `damage_fee`. Sự vắng mặt của cột này khiến hệ thống phải hoàn trả 100% tiền cọc hoặc nhân viên phải ghi chép thủ công ngoài sổ giấy, gây thất thoát trực tiếp cho phòng khám/doanh nghiệp.
2. **Đảm bảo toàn vẹn nghiệp vụ:** Bảng `Inspections` chỉ lưu trữ mô tả định tính (`damage_description`), còn `damage_fee` cung cấp giá trị định lượng tài chính trực tiếp trên hợp đồng để kế toán đối soát doanh thu bồi thường.

Thiếu `damage_fee`, dữ liệu giữa biên bản kiểm tra và luồng tiền hợp đồng bị đứt gãy hoàn toàn.