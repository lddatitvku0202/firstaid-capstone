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

## Nối app với AI + fallback (Prompt 07)
Chưa chạy. Video: [CHỜ NGƯỜI DÙNG QUAY VIDEO] (lưu ngoài repo hoặc docs/evidence/ nếu nhỏ). Ghi kết quả thật vào docs/evidence-ledger.md (E-025).
1. Chạy backend trên máy dev (xem backend/README.md) và kiểm tra `http://localhost:8000/healthz`. Điện thoại thật cần cùng mạng Wi-Fi và dùng IP LAN của máy dev (uvicorn phải chạy với `--host 0.0.0.0`); emulator dùng `http://10.0.2.2:8000`. Có thể phải mở cổng 8000 trong Windows Firewall.
2. Trong `app/.env` (đã gitignore) đặt `AI_BASE_URL=http://<IP_MAY_DEV>:8000` (và `AI_API_KEY` nếu backend đặt `API_AUTH_TOKEN`), rồi:

```powershell
cd "D:\Start Github\firstaid-capstone\app"
flutter run -d <ID_THIET_BI> --dart-define-from-file=.env
```

   HTTP không mã hóa chỉ được phép ở bản debug.
3. Kịch bản quay video: Home → "Mô tả tình huống" → nhập ví dụ "tay bị bỏng do nước sôi" → hộp thoại đồng ý (lần đầu) → thấy tiến trình → thẻ "KẾT QUẢ THAM KHẢO" → "Mở hướng dẫn từng bước". Quay lại, bật chế độ máy bay (chip mạng đổi sang "Không có mạng") → gửi lại → thẻ fallback "Không có mạng..." → "Bắt đầu sàng lọc offline" → sàng lọc Có/Không chạy được.
4. Thử thêm (ghi lại kết quả thật): bấm "Bỏ qua AI, sàng lọc ngay" khi đang chờ; nhập "người lớn bất tỉnh, không thở" khi tắt mạng (phải ra "GỌI 115 NGAY", không cần mạng); tắt backend khi vẫn có Wi-Fi (phải fallback); nếu Gemini trả 429 thì app phải fallback.
