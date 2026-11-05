# Decision Log

| ID | Ngày | Quyết định | Lý do | Nguồn |
|---|---|---|---|---|
| D-001 | 2026-11-05 | Stack: Flutter + Dart 3 + Riverpod 2, Drift, Supabase, FastAPI, Gemini + RAG-lite | Theo mô tả đề tài hiệu chỉnh | docs/source/description/ |
| D-002 | 2026-11-05 | Figma chỉ là tham chiếu luồng màn hình | Cho phép cải thiện UI khi code | CLAUDE.md §4 |
| D-003 | 2026-11-05 | Không commit tài liệu y khoa có bản quyền chưa rõ | Repo public | .gitignore, CLAUDE.md §7 |
| D-004 | 2026-11-05 | Nộp gộp 4 báo cáo một lần theo hướng dẫn giảng viên | Giảng viên xác nhận | docs/lecturer-notes.md |
| D-005 | 2026-11-05 | Dùng Riverpod (flutter_riverpod 3.4.3) cho DI/state | Theo stack đề tài; compile-safe, test dễ qua ProviderScope override; phiên bản lấy từ `flutter pub add` (app/pubspec.lock) | app/pubspec.lock |
| D-006 | 2026-11-05 | Dùng go_router 18.1.3 cho điều hướng | Khai báo route tập trung, dễ mở rộng 8 luồng; phiên bản từ `flutter pub add` | app/pubspec.lock |
| D-007 | 2026-11-05 | Tên package Dart là `app` (mặc định của flutter create trong thư mục app/) | Giữ mặc định, thay đổi tối thiểu | app/pubspec.yaml |
