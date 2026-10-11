# Báo Cáo Phân Tích Độ Lệch (Consistency Report) - HealthSync

Bản thiết kế cơ sở dữ liệu cũ (Legacy Schema) bộc lộ 3 điểm "vênh" nghiêm trọng so với UML Activity Diagram của bộ phận Nghiệp vụ:

1. **Đứt gãy vòng đời trạng thái (Lifecycle Gap):** CSDL cũ sử dụng cột `is_active BOOLEAN`, chỉ biểu diễn được 2 giá trị nhị phân, trong khi quy trình thực tế gồm 5 trạng thái chuyển dịch liên tục (`PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`). Việc thiếu `ENUM` khiến hệ thống mất kiểm soát tiến trình khám bệnh.
2. **Lỗ hổng quản lý dòng tiền (Financial Gap):** Hoàn toàn vắng bóng các trường lưu trữ tiền cọc (`deposit_amount`), phí phạt vi phạm hủy lịch (`penalty_fee`) và nguyên nhân hủy (`cancel_reason`). Điều này khiến bộ phận Kế toán không thể đối soát tiền cọc bị trừ hay tính toán doanh thu thực tế phát sinh từ phí phạt.
3. **Mất liên kết thực thể cốt lõi (Missing Entity Gap):** Thiếu hoàn toàn bảng `Prescriptions` để lưu đơn thuốc sau khi buổi khám hoàn tất (`COMPLETED`). Hậu quả là Bác sĩ không thể nhập thông tin thuốc và lịch sử điều trị của bệnh nhân bị phân mảnh.

Việc chuẩn hóa lại cấu trúc bảng đã đồng bộ hóa hoàn toàn luồng dữ liệu giữa Dev và BA, bảo đảm tính toàn vẹn hệ thống.