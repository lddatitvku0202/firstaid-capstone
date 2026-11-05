# Risk Register

| ID | Rủi ro | Mức | Giảm thiểu | Trạng thái |
|---|---|---|---|---|
| R-01 | Chưa có tài liệu y khoa trong docs/source/medical/ → nội dung sơ cứu chỉ là UNVERIFIED_PLACEHOLDER | Cao | Người dùng thu thập tài liệu từ nguồn chính thức | Mở |
| R-02 | Bản quyền tài liệu y khoa; repo public | Cao | .gitignore chặn PDF; chỉ lưu metadata/URL/checksum | Mở |
| R-03 | Nội dung chưa được rà soát chuyên môn (clinical_review) | Cao | App luôn hiện cảnh báo | Mở |
| R-04 | Chưa có điện thoại Android thật (video demo, FPS) | Trung bình | Dùng emulator tạm; đo thật khi có máy | Mở |
| R-05 | Thiếu pandoc / poppler (không đọc PDF, không convert báo cáo) | Thấp | Cài khi cần | Mở |
| R-06 | Chưa có Supabase project, Gemini key, hosting FastAPI, keystore | Trung bình | Người dùng tạo; không commit secret | Mở |
| R-07 | Nộp muộn R1-R3 | Trung bình | Nộp gộp theo giảng viên | Mở |
