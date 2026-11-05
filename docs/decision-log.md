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
| D-008 | 2026-11-06 | IFRC-2025 là nguồn nội dung chính cho cả 4 chủ đề MVP; nguồn VN chưa dùng | PDF VN không trích được text (lỗi font), máy thiếu pdftoppm; người dùng chọn phương án này | docs/source/medical/SOURCE_MAP.md |
| D-009 | 2026-11-06 | Tách hóc dị vật theo age_group (adult_child / infant); ghi điểm có thể khác BV Nhi TW 2022 vào notes | Yêu cầu của người dùng; không tự chọn thay | protocols_v1.json |
| D-010 | 2026-11-06 | Nội dung bước bằng tiếng Việt (dịch tóm lược của nhóm) | Phù hợp người dùng VN; vẫn hiện cảnh báo chưa thẩm định | CLAUDE.md §6 |
| D-011 | 2026-11-06 | Phiên bản gói (pubspec.lock): drift 2.35.3, drift_dev 2.35.2, build_runner 2.17.1, path_provider 2.1.6, sqlite3 3.5.2, sqlite3_flutter_libs 0.6.0+eol | `sqlite3_flutter_libs` đã đánh dấu EOL; build Android chưa kiểm chứng, có thể cần đổi cách đóng gói native SQLite | app/pubspec.lock |
| D-012 | 2026-11-06 | Lớp dòng Drift đặt tên `*Row` (ProtocolRow...); các list (do_not, citations) lưu dạng JSON text | Tránh trùng tên entity domain (lỗi ambiguous_import lúc đầu); schema đơn giản | app_database.dart |
| D-013 | 2026-11-06 | `app_database.g.dart` do build_runner sinh đang nằm trong working tree; chưa quyết định commit hay ignore | Cần người dùng chốt | app/lib/data/datasources/local/ |
