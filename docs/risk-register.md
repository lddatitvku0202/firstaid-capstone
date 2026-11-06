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
| R-09 | `sqlite3_flutter_libs` EOL; build Android với Drift chưa kiểm chứng | Trung bình | Chạy `flutter build apk --debug` hoặc chạy trên máy thật; đổi cấu hình nếu lỗi | Mở |
| R-10 | PDF nguồn VN không trích được text (lỗi font), thiếu poppler | Trung bình | Cài poppler hoặc cung cấp ảnh trang | Mở |
| R-11 | Máy không có giọng vi-VN hoặc TTS chỉ chạy khi có mạng (chưa kiểm chứng) | Trung bình | App báo rõ, vẫn hiện chữ; thử trên máy thật ở chế độ máy bay | Mở |
| R-12 | `connectivity_plus` chỉ báo có kết nối, không đảm bảo có Internet; có thể gây hiểu lầm | Thấp | Nhãn chip nêu rõ "kết nối mạng"; AI cần xử lý lỗi/timeout riêng ở prompt sau | Mở |
| R-13 | Câu hỏi sàng lọc và thứ tự ưu tiên do nhóm soạn, chưa thẩm định lâm sàng | Cao | Giữ cảnh báo; luôn có nút Gọi 115; nhờ người có chuyên môn rà | Mở |
