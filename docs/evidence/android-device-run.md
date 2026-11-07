# Chạy app lên điện thoại Android thật (PowerShell)

Chưa chạy: chờ người dùng cắm điện thoại. Mọi đường dẫn có dấu cách phải đặt trong dấu nháy.

1. Trên điện thoại: bật Developer options và USB debugging; cắm cáp (chọn File transfer), chấp nhận hộp thoại "Allow USB debugging".
2. Mở PowerShell:

```powershell
adb devices
flutter devices
```

   - `adb devices` phải hiện thiết bị với trạng thái `device`. Nếu là `unauthorized`: rút cáp, bật lại USB debugging, chấp nhận hộp thoại. Nếu trống: thử cáp/cổng khác hoặc cài driver USB của hãng.
   - `flutter devices` ghi ID thiết bị (cột thứ hai).
3. Chạy app:

```powershell
cd "D:\Start Github\firstaid-capstone\app"
flutter pub get
flutter run -d <ID_THIET_BI>
```

4. Kiểm thử thủ công cần làm trên máy (ghi kết quả thật vào docs/evidence-ledger.md):
   - Nút "Gọi 115 ngay" mở trình quay số với số 115 (không tự gọi).
   - "Đọc to": nếu máy không có giọng vi-VN, app báo rõ và vẫn hiện chữ. Cài giọng tiếng Việt trong cài đặt Text-to-speech của Android nếu cần. Việc đọc to có chạy khi tắt mạng hay không CHƯA được kiểm chứng; tự thử ở chế độ máy bay rồi ghi lại.
   - Chip mạng đổi chữ/icon khi bật/tắt Wi-Fi (chỉ phản ánh có kết nối, không đảm bảo có Internet).
   - Cài đặt Sáng/Tối/Hệ thống và cỡ chữ; thoát hẳn app rồi mở lại để xem cài đặt có được nhớ.
   - Chụp ảnh sáng/tối theo docs/evidence/screenshots/emergency_ui.md.
5. Nếu build lỗi, giữ nguyên log (`flutter run -v > "docs\\evidence\\tests\\device-run.log"`) và báo lại.

## Kiểm thử SOS trên máy thật (Prompt 04)
Chưa chạy. Video: [CHỜ NGƯỜI DÙNG QUAY MÀN HÌNH] (lưu ngoài repo hoặc docs/evidence/ nếu nhỏ).
1. Home hoặc Sàng lọc → "SOS: gửi vị trí": xem màn giải thích; bấm "Lấy vị trí của tôi" → hộp thoại quyền vị trí của Android.
2. Thử các trường hợp: Cho phép → màn xem trước có tọa độ và nội dung tin nhắn; Từ chối → thông báo + Thử lại/Bỏ qua; Từ chối và không hỏi lại → "Mở cài đặt ứng dụng"; tắt GPS → "Mở cài đặt vị trí"; ở trong nhà để thử hết thời gian chờ.
3. Xem trước → "Xác nhận và mở tin nhắn": ứng dụng SMS mở với nội dung soạn sẵn, người nhận trống. Xác nhận app KHÔNG tự gửi: chỉ gửi khi bạn bấm Gửi trong ứng dụng SMS.
4. "Gọi 115 ngay" chỉ mở trình quay số (nhớ KHÔNG bấm gọi khi thử).
5. Phân biệt mất Internet và mất sóng: (a) bật chế độ máy bay rồi bật lại GPS (tọa độ vẫn lấy được?; gọi/SMS sẽ không dùng được); (b) tắt dữ liệu di động và Wi-Fi nhưng giữ SIM còn sóng (tọa độ, SMS, trình quay số vẫn dùng được). Ghi lại kết quả thật.
