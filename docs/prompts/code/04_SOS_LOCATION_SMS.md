# PROMPT 04 — SOS: gọi 115, vị trí, SMS có xác nhận

Đọc CLAUDE.md. Dùng Plan mode.

## Việc cần làm
1. Domain: use case PrepareSosMessage tạo nội dung SMS từ tọa độ + ghi chú + thời gian. KHÔNG tự động gửi.
2. Data/Presentation: flutter pub add geolocator url_launcher. Xin quyền vị trí theo ngữ cảnh (giải thích lý do), xử lý từ chối/GPS tắt/timeout. Mở tel:115 và sms: với nội dung soạn sẵn để người dùng xem trước và tự bấm gửi. Không gửi ngầm. Không bắt đăng nhập.
3. Màn xem trước vị trí + nội dung tin nhắn, nút xác nhận.
4. AndroidManifest: chỉ quyền tối thiểu cần thiết; giải thích trong decision-log.
5. Test: unit test PrepareSosMessage (có/không tọa độ, ghi chú dài), widget test luồng xác nhận. Mock geolocator và url_launcher qua interface ở Domain/Data.
6. Lưu log analyze/test vào docs/evidence/tests/. Cập nhật R1/R2, traceability.
7. Ghi "[CHỜ NGƯỜI DÙNG QUAY MÀN HÌNH]" cho video SOS trên máy thật.
8. Nêu giới hạn trong tài liệu: tọa độ GPS dùng được khi không có Internet; tile bản đồ/địa chỉ chữ thì không; gọi/SMS cần sóng di động, không đồng nhất "mất Internet" với "mất sóng".

## Điều kiện dừng
Không tự commit. Commit đề xuất: "feat: sos call, location and confirmed sms draft".
