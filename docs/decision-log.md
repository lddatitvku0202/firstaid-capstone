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
| D-014 | 2026-11-06 | Thêm flutter_tts 4.2.5, url_launcher 6.3.3, connectivity_plus 7.3.2, shared_preferences 2.5.6 (từ pub add) | Đọc to vi-VN, mở trình quay số 115, chip mạng, lưu cài đặt; người dùng đã đồng ý | app/pubspec.lock |
| D-015 | 2026-11-06 | "Gọi 115 ngay" chỉ mở trình quay số (tel:115), người dùng tự bấm gọi; luôn hiển thị ở mọi bước sàng lọc | Không tự gọi/gửi âm thầm theo mô tả đề tài | call_115_button.dart |
| D-016 | 2026-11-06 | Chip mạng chỉ phản ánh có kết nối, không đảm bảo có Internet; nút Đọc to bị tắt khi không có giọng vi-VN và có thông báo | Không khẳng định TTS offline khi chưa kiểm tra trên thiết bị | network_chip.dart, protocol_detail_screen.dart |
| D-017 | 2026-11-06 | Màn sàng lọc và hướng dẫn dùng NoTransitionPage; nút Đọc to/Trước/Tiếp đặt ở thanh cố định phía dưới | Hạn chế animation ở màn khẩn cấp; thao tác một tay | app_router.dart |
| D-018 | 2026-11-06 | Thêm `<queries>` cho tel và TTS_SERVICE vào AndroidManifest | Android 11+ package visibility; chưa kiểm chứng trên máy | android/app/src/main/AndroidManifest.xml |
| D-019 | 2026-11-07 | Thêm geolocator 14.0.1 (từ pub add) | Lấy tọa độ GPS cho SOS | app/pubspec.lock |
| D-020 | 2026-11-07 | Manifest chỉ khai báo ACCESS_FINE_LOCATION và ACCESS_COARSE_LOCATION; không background location, không SEND_SMS | Vị trí chỉ khi bấm trong lúc dùng app; SMS chỉ mở bản nháp để người dùng tự gửi nên không cần SEND_SMS. Merged manifest còn có ACCESS_NETWORK_STATE (connectivity_plus) và INTERNET ở bản debug; release cần khai INTERNET khi làm AI (prompt 07) | AndroidManifest.xml, E-012 |
| D-021 | 2026-11-07 | SMS để trống người nhận, người dùng tự chọn; không lưu số liên hệ | Chưa có nguồn xác nhận 115 nhận SMS; tránh lưu dữ liệu cá nhân | sos_screen.dart |
| D-022 | 2026-11-07 | Nội dung SMS kèm tọa độ số và liên kết maps.google.com | Tọa độ đọc được khi không có Internet; liên kết chỉ tiện khi người nhận có Internet | prepare_sos_message.dart |
| D-023 | 2026-11-07 | Thêm supabase_flutter 2.18.3 (từ pub add); khởi tạo bằng `publishableKey` (anonKey bị đánh dấu deprecated) | Supabase BaaS cho tiêu chuẩn Offline-First | app/pubspec.lock |
| D-024 | 2026-11-07 | Cấu hình Supabase qua `--dart-define-from-file=.env`; thiếu cấu hình thì sync tắt | Không hardcode secret; app vẫn chạy offline | app_config.dart, supabase/README.md |
| D-025 | 2026-11-07 | Phác đồ: server thắng nhưng chỉ nhận bản reviewed + verified và version mới hơn; ghi trong một transaction | Bản chưa review không được ghi đè bản ổn định (CLAUDE.md §6) | sync_protocols.dart |
| D-026 | 2026-11-07 | SeedLoader không ghi đè phác đồ nhận từ server có version >= asset (Meta `remote_version:<code>`) | Nếu không, đổi version asset sẽ xóa bản đồng bộ | seed_loader.dart |
| D-027 | 2026-11-07 | sos_logs append-only, consent=true bắt buộc, owner_id = auth.uid(); không lưu ghi chú/số liên hệ; vị trí làm tròn 3 chữ số | Tối thiểu dữ liệu nhạy cảm | 0001_init.sql, enqueue_sos_log.dart |
| D-028 | 2026-11-07 | Retry tối đa 5 lần, backoff mũ 30 s đến 1 giờ; lỗi vĩnh viễn không retry | Giới hạn theo yêu cầu prompt 05; giá trị do nhóm chọn, chưa tinh chỉnh bằng đo đạc | process_sync_queue.dart |
| D-029 | 2026-11-07 | Drift schemaVersion 1 -> 2 (thêm `sync_jobs`) với `onUpgrade` | Giữ dữ liệu máy đã cài bản cũ | app_database.dart |
| D-030 | 2026-11-07 | Thêm INTERNET vào manifest chính | Cần cho Supabase (và AI prompt 07); xử lý mục D-020 | AndroidManifest.xml, E-016 |
| D-031 | 2026-11-07 | `EnqueueSosLog` chưa nối UI; chưa có màn đăng nhập/consent | Prompt 05 yêu cầu tầng sync + schema; UI consent cần thiết kế riêng | R2 |
