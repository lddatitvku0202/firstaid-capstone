# PROMPT 08 — Chất lượng: test, Dark Mode, accessibility, FPS

Đọc CLAUDE.md. Dùng Plan mode. Mục tiêu: bằng chứng cho tiêu chuẩn 4 và phần test.

1. Rà toàn app: Material 3, Dark Mode đúng mọi màn, contrast, cỡ chữ lớn (text scale), Semantics/tooltip cho nút chính, không chỉ dựa vào màu.
2. Bổ sung unit/widget test còn thiếu cho use case và màn chính; thêm 1 integration test luồng khẩn cấp offline (nếu chạy được). flutter test --coverage; lưu lcov và tóm tắt coverage THẬT vào docs/evidence/tests/. Không làm tròn hay bịa số.
3. FPS: viết hướng dẫn từng bước chạy profile mode trên máy thật (flutter run --profile, DevTools Performance, ghi frame time và số frame jank) để người dùng tự chạy. Tạo bảng mẫu docs/evidence/fps/fps-measurements.md (thiết bị, màn hình, FPS trung bình, jank) để người dùng điền số thật. Không tự điền số.
4. Tối ưu chỗ nghi ngờ jank (const widget, giảm rebuild) và nêu thay đổi + lý do.
5. Cập nhật R3 (test + FPS), R4 chương 5, traceability. Phần thiếu ghi "[CHỜ SỐ ĐO THẬT]".

Không tự commit. Commit đề xuất: "test: widget/unit coverage, dark mode and accessibility pass".
