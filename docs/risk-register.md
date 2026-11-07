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
| R-17 | RLS đã chạy trên Supabase: 13/13 PASS, ghi nhận 2026-11-08 (E-015, `docs/evidence/rls/rls-test-20261107-001222.csv`). Còn rủi ro: chưa có ảnh SQL Editor, chưa có ca `sync_events`, app Flutter chưa thử với Supabase thật | Trung bình | Thêm ca `sync_events` vào rls_test.sql, chụp ảnh SQL Editor, thử `SupabaseRemoteSyncSource` với project thật | Giảm một phần |
| R-18 | Key Supabase bị lộ nếu đặt nhầm vào repo (repo PUBLIC) | Cao | Chỉ dùng anon/publishable key trong app/.env (gitignore); không dùng service_role trong app | Mở |
| R-19 | Log SOS chưa nối UI/consent/đăng nhập: tính năng chưa dùng được end-to-end | Trung bình | Thiết kế UI consent ở bước sau; ghi rõ trong báo cáo | Mở |
| R-20 | Connectivity chỉ báo có kết nối, không phải có Internet: sync có thể lỗi dù "có mạng" | Thấp | Lỗi được bắt và hẹn thử lại; không ảnh hưởng luồng sơ cứu | Chấp nhận |
| R-21 | Endpoint backend công khai có thể bị lạm dụng làm cạn quota Gemini; token trong app không phải bí mật | Trung bình | Cổng truy xuất giảm số lần gọi LLM; token tùy chọn; thêm rate limit khi deploy (chưa làm) | Mở |
| R-22 | Nội dung tình huống (có thể nhạy cảm) gửi tới Gemini (bên thứ ba) | Trung bình | Không log nội dung; thông báo cho người dùng trong app (Prompt 07); không bắt buộc dùng AI, luồng cốt lõi chạy offline | Mở |
| R-23 | Từ khóa quy tắc 115, alias, từ dừng và nhãn eval do nhóm tự viết, chưa rà soát lâm sàng; rule bỏ sót 3/12 ca nguy cấp trong tập thử | Cao | Người dùng/chuyên gia rà lại; app luôn hiện nút Gọi 115; mở rộng từ khóa sau rà soát | Mở |
| R-24 | Cổng truy xuất cho lọt 8/12 ca không nhãn; hiệu quả từ chối của LLM mới đo trên mẫu rất nhỏ (xem E-020; 429 làm mất nhiều ca) | Trung bình | Chạy run_eval --mode llm khi có key; validation chặn mã ngoài ứng viên | Mở |
| R-25 | Tên model Gemini mặc định chưa xác minh; SDK/model có thể đổi | Thấp | list-models khi có key; cấu hình qua biến môi trường | Mở |
| R-26 | Dockerfile chưa build thử, chưa deploy | Trung bình | Chọn nền tảng, build và ghi log | Mở |
| R-27 | Lỗi hạ tầng/fallback khi gọi Gemini tăng từ 9/35 (25.7%) ở eval lần 1 lên 14/35 (40%) ở lần 2; cả 14 ca lần 2 là HTTP 429 (rate limit; người dùng cho biết gói miễn phí, file chỉ ghi 429). Retry hiện tại (2 lần, backoff 0,5 s) không đủ vượt giới hạn tốc độ | Cao | Retry + backoff dài hơn khi deploy, tăng thời gian nghỉ giữa các lời gọi, cân nhắc nâng hạn mức; app luôn có fallback sang sàng lọc cục bộ + nút Gọi 115 (Prompt 07); chưa triển khai các biện pháp giảm thiểu | Mở |
