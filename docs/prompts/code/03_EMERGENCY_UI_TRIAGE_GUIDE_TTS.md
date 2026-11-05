# PROMPT 03 — UI khẩn cấp: Home, sàng lọc, hướng dẫn từng bước, TTS

Đọc CLAUDE.md và docs/source/figma/figma_link.md. Dùng Plan mode. Figma chỉ là tham chiếu luồng; được cải thiện bố cục/giao diện.

## Màn hình (Presentation chỉ gọi use case của Domain)
1. Home: nút KHẨN CẤP lớn, không cần đăng nhập, chip trạng thái mạng (icon + chữ), lối vào cẩm nang/CPR/mô tả tình huống.
2. Sàng lọc: hiển thị TriageNode lần lượt; trường hợp nghiêm trọng có nút "Gọi 115 ngay".
3. Hướng dẫn từng bước: một hành động mỗi bước, khối KHÔNG ĐƯỢC LÀM, nút đọc to (flutter_tts, vi-VN), nguồn + version + cảnh báo. Nếu máy không có giọng vi-VN: thông báo rõ, vẫn hiển thị text. Không khẳng định TTS offline nếu chưa kiểm tra trên thiết bị.
4. Cẩm nang: danh sách + tìm kiếm local.
5. Cài đặt: sáng/tối/hệ thống, cỡ chữ.
Ràng buộc: thao tác một tay, tương phản tốt, không dùng màu làm tín hiệu duy nhất, hạn chế animation ở màn khẩn cấp, Dark Mode đúng ở mọi màn. Không màn nào gọi API để mở phác đồ.

## Làm
- flutter pub add flutter_tts. Widget test cho Home, Triage, Step (text hiển thị, nút đọc, đường tới 115).
- flutter analyze, flutter test; lưu log vào docs/evidence/tests/.
- Ảnh sáng/tối trên máy thật: ghi "[CHỜ NGƯỜI DÙNG CHỤP]" trong docs/evidence/screenshots/.
- Cập nhật R1 (user flow, màn hình), R2, evidence-ledger, traceability.
- Hướng dẫn chạy lên máy Android thật bằng PowerShell (adb devices, flutter devices, flutter run) khi người dùng đã cắm điện thoại.

## Điều kiện dừng
Không tự commit. Commit đề xuất: "feat: emergency flow ui with triage, guide steps and tts".
