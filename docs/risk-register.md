# Risk Register

| ID | Rủi ro | Mức | Giảm thiểu | Trạng thái |
|---|---|---|---|---|
| R-01 | Nguồn y khoa: đã có 6 PDF trong docs/source/medical/ nhưng chỉ IFRC-2025 đọc được; nội dung nguồn VN chưa dùng (xem R-10) | Trung bình | Đối chiếu khi đọc được nguồn VN | Giảm một phần |
| R-02 | Bản quyền tài liệu y khoa; repo public | Cao | .gitignore chặn PDF; chỉ lưu metadata/URL/checksum | Mở |
| R-03 | Nội dung chưa được rà soát chuyên môn (clinical_review) | Cao | App luôn hiện cảnh báo | Mở |
| R-04 | Chưa có điện thoại Android thật (video demo, FPS) | Trung bình | Dùng emulator tạm; đo thật khi có máy | Mở |
| R-05 | Thiếu pandoc / poppler (không đọc PDF, không convert báo cáo) | Thấp | Cài khi cần | Mở |
| R-06 | Chưa có Supabase project, Gemini key, hosting FastAPI, keystore | Trung bình | Người dùng tạo; không commit secret | Mở |
| R-07 | Nộp muộn R1-R3 | Trung bình | Nộp gộp theo giảng viên | Mở |
| R-08 | Bản dịch/tóm lược tiếng Việt từ IFRC-2025 có thể sai sót hoặc khác hướng dẫn Việt Nam; chưa ai rà soát lâm sàng | Cao | Giữ cảnh báo; nhờ người có chuyên môn rà; đối chiếu VN-MOH-636/BV Nhi TW khi đọc được | Mở |
| R-09 | `sqlite3_flutter_libs` EOL; build APK debug đã thành công (E-012) nhưng chưa chạy Drift trên máy thật | Trung bình | Chạy trên máy thật; đổi cấu hình nếu lỗi lúc chạy | Giảm một phần |
| R-10 | PDF nguồn VN không trích được text (lỗi font), thiếu poppler | Trung bình | Cài poppler hoặc cung cấp ảnh trang | Mở |
| R-11 | Máy không có giọng vi-VN hoặc TTS chỉ chạy khi có mạng (chưa kiểm chứng) | Trung bình | App báo rõ, vẫn hiện chữ; thử trên máy thật ở chế độ máy bay | Mở |
| R-12 | `connectivity_plus` chỉ báo có kết nối, không đảm bảo có Internet; có thể gây hiểu lầm | Thấp | Nhãn chip nêu rõ "kết nối mạng"; AI cần xử lý lỗi/timeout riêng ở prompt sau | Mở |
| R-13 | Câu hỏi sàng lọc và thứ tự ưu tiên do nhóm soạn, chưa thẩm định lâm sàng | Cao | Giữ cảnh báo; luôn có nút Gọi 115; nhờ người có chuyên môn rà | Mở |
| R-14 | Định vị GPS chậm/timeout trong nhà; người dùng từ chối quyền | Trung bình | Giới hạn 15 giây, thử lại, bỏ qua để soạn tin không vị trí, luôn có Gọi 115 | Mở |
| R-15 | Người dùng hiểu nhầm app tự gửi tin hoặc 115 nhận SMS | Trung bình | Nêu rõ "app không tự gửi"; không mặc định người nhận; nút gọi 115 mở trình quay số | Mở |
| R-16 | Phụ thuộc ứng dụng SMS và sóng di động trên máy thật; chưa kiểm chứng | Trung bình | Kiểm thử thủ công theo docs/evidence/android-device-run.md | Mở |
| R-17 | Migration/RLS chưa chạy trên Supabase thật; script rls_test.sql chưa được thử (có thể cần chỉnh cho auth.users) | Cao | Người dùng chạy trên project thử, lưu output vào docs/evidence/rls/ | Mở |
| R-18 | Key Supabase bị lộ nếu đặt nhầm vào repo (repo PUBLIC) | Cao | Chỉ dùng anon/publishable key trong app/.env (gitignore); không dùng service_role trong app | Mở |
| R-19 | Log SOS chưa nối UI/consent/đăng nhập: tính năng chưa dùng được end-to-end | Trung bình | Thiết kế UI consent ở bước sau; ghi rõ trong báo cáo | Mở |
| R-20 | Connectivity chỉ báo có kết nối, không phải có Internet: sync có thể lỗi dù "có mạng" | Thấp | Lỗi được bắt và hẹn thử lại; không ảnh hưởng luồng sơ cứu | Chấp nhận |
