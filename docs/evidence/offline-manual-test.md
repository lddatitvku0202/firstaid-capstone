# Hướng dẫn kiểm thử thủ công: chế độ máy bay (Prompt 02)

Mục tiêu: xác nhận cẩm nang sơ cứu đọc được từ SQLite (Drift) khi không có mạng. **Chưa chạy: chờ người dùng thực hiện trên máy thật.**

1. Cắm điện thoại Android (bật USB debugging). Kiểm tra: `adb devices`.
2. Chạy bản debug lần đầu khi CÓ mạng (để seed dữ liệu): `cd "D:\Start Github\firstaid-capstone\app"` rồi `flutter run`.
3. Ở màn Home, bấm "Cẩm nang sơ cứu (offline)". Xác nhận danh sách 6 phác đồ và khung cảnh báo "Chưa được chuyên gia lâm sàng thẩm định".
4. Đóng hẳn app (vuốt khỏi danh sách gần đây).
5. Bật Chế độ máy bay; tắt Wi-Fi và dữ liệu di động. Xác nhận biểu tượng máy bay trên thanh trạng thái.
6. Mở lại app từ icon. Bấm "Cẩm nang sơ cứu (offline)" rồi mở từng phác đồ. Xác nhận: các bước, mục "Không nên làm", "Khi nào gọi 115", nguồn (IFRC-2025 + trang), phiên bản và cảnh báo vẫn hiển thị.
7. Chụp ảnh màn hình ở bước 3 và 6 (sáng và tối nếu được), đặt vào `docs/evidence/screenshots/`.
8. Ghi kết quả (đạt/không đạt, model máy, bản Android, ngày) vào `docs/evidence-ledger.md`.

Lưu ý: nếu app crash ở lần mở đầu vì thiếu native SQLite, ghi lại log `flutter run` hoặc `adb logcat` rồi báo lại; build Android chưa được kiểm chứng trong prompt này.
