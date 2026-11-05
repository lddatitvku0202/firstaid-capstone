# PROMPT 01 — Skeleton Flutter + Clean Architecture + theme sáng/tối

Đọc CLAUDE.md, docs/requirements-traceability.md. Dùng Plan mode.

## Việc cần làm
1. Chạy flutter --version. Tạo project trong thư mục app/ (nếu chưa có): flutter create --org vn.vku.firstaid --platforms android app (đặt đường dẫn trong dấu nháy). Không đụng docs/.
2. Cấu trúc app/lib theo Clean Architecture:
   domain/{entities,repositories,usecases}; data/{datasources/{local,remote},models,repositories}; presentation/{screens,widgets,providers,theme,router}; core/{di,utils}.
   - Domain là Dart thuần: KHÔNG import package:flutter, drift, supabase, http, flutter_riverpod.
   - Entity: FirstAidProtocol, ProtocolStep, TriageNode, EmergencyCase, SosMessage.
   - Repository interface + use case khởi đầu: GetOfflineProtocols, GetProtocolByCode, StartEmergencyFlow, PrepareSosMessage (signature + hiện thực tối thiểu).
3. Thêm package bằng flutter pub add (để lấy phiên bản tương thích với Flutter 3.47.6; không ghi phiên bản từ trí nhớ): flutter_riverpod, go_router. Ghi phiên bản thật vào decision-log.
4. Material 3 + theme sáng/tối (ColorScheme.fromSeed), theo hệ thống mặc định. Nút SOS tương phản cao, không chỉ dựa vào màu đỏ/vàng (thêm icon + chữ). Tham chiếu Figma để dựng màn Home rỗng.
5. Test kiểm tra kiến trúc: app/test/architecture/domain_isolation_test.dart quét mọi file trong lib/domain và FAIL nếu có import từ presentation, data, flutter, drift, supabase, http, riverpod.
6. Bật flutter_lints chặt. Chạy trong app/: flutter pub get; dart format --set-exit-if-changed .; flutter analyze; flutter test. Lưu output vào docs/evidence/tests/ (tên file có timestamp).
7. Ghi tài liệu: R2 mục Clean Architecture (sơ đồ phụ thuộc Mermaid, cây thư mục lấy từ lệnh thật); decision-log (vì sao Riverpod, go_router); evidence-ledger. Chỉ ghi kết quả đã chạy thật.

## Điều kiện dừng
Báo lệnh đã chạy + kết quả thật; nếu lệnh fail nói rõ. Không tự commit. Commit đề xuất: "feat: flutter skeleton with clean architecture and domain isolation test".
