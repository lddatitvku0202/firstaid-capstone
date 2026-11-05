# Evidence Ledger

Chỉ ghi tuyên bố có bằng chứng thật. Ngày = ngày tạo thật, không back-date.

| ID | Tuyên bố | Loại bằng chứng | Đường dẫn file/log/commit | Ngày tạo thật | Trạng thái |
|---|---|---|---|---|---|
| E-001 | Môi trường: Flutter 3.47.6, Dart 3.13.5, JDK 21.0.13, Android SDK API 37, Python 3.10.11, Node 22 | Output flutter doctor do người dùng cung cấp | [CHƯA CÓ log trong repo] | 2026-11-05 | Not verified (chưa lưu log) |
| E-002 | Figma prototype tồn tại | Link | docs/source/figma/figma_link.md | 2026-11-05 | Quyền chia sẻ chưa kiểm tra |
| E-003 | Khung tài liệu CLAUDE.md, reports R1-R4 và các file theo dõi đã được tạo | File trong repo (chưa commit) | CLAUDE.md, docs/ | 2026-11-05 | Done (chưa commit) |
| E-004 | Skeleton Flutter: pub get, dart format --set-exit-if-changed, flutter analyze (No issues found), flutter test (3 test pass) đều exit=0 | Log lệnh thật | docs/evidence/tests/skeleton-checks-20261105-224643.log | 2026-11-05 | Done (chưa commit); chưa chạy trên thiết bị/emulator |
| E-005 | Domain isolation test tồn tại và pass trên lib/domain | Test + log | app/test/architecture/domain_isolation_test.dart; log E-004 | 2026-11-05 | Done (chưa thử vi phạm cố ý để xác nhận test fail) |
