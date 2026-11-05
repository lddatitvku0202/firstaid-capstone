# PROMPT 02 — Dữ liệu phác đồ có nguồn + Drift (offline)

Đọc CLAUDE.md. Dùng Plan mode.

## Bước 0 (bắt buộc)
Đọc docs/source/medical/ (official/, international/, extracted/, review/) và source_register.csv nếu có. Liệt kê tài liệu nguồn đã đọc. Nếu chưa có source_register: tạo docs/source/medical/source_register.csv với các cột source_id, title, issuing_organization, source_class, document_number, publication_date, version, jurisdiction, target_audience, official_url, accessed_at, source_verification, reuse_permission, relevant_pages_sections, notes (chỉ điền cái có thật; thiếu ghi unknown). KHÔNG tự viết nội dung y khoa. Nếu thiếu nguồn cho một phác đồ: dừng phần đó, dùng nhãn UNVERIFIED_PLACEHOLDER và liệt kê cho người dùng.

## Việc cần làm
1. app/assets/protocols/protocols_v1.json cho 4 chủ đề MVP: bleeding_wounds, burns, choking, cardiac_arrest_cpr. Mỗi phác đồ: code, title, topic_id, severity, target_audience, age_group, steps[] (mỗi bước một hành động ngắn), do_not[], call_115_conditions[], citations[] (source_id + trang/mục), version, updated_at, source_verification, clinical_review, reuse_permission. Chỉ tóm lược từ nguồn trong docs/source/medical/; không chép dài nguyên văn.
2. app/assets/triage/triage_v1.json: cây quyết định tĩnh (câu hỏi ngắn: tỉnh táo, nhịp thở, mức độ chảy máu), nhánh dẫn tới code phác đồ hoặc "Gọi 115 ngay". Đây là luật xác định, không phải AI. Nội dung câu hỏi cũng phải có citation hoặc nhãn UNVERIFIED_PLACEHOLDER.
3. Drift (SQLite): bảng protocols, protocol_steps, triage_nodes, meta (version dữ liệu). Seed từ JSON ở lần chạy đầu. Datasource local + repository implementation ở lớp data. Dùng flutter pub add drift sqlite3_flutter_libs path_provider và dev: drift_dev build_runner; chạy dart run build_runner build.
4. Dữ liệu y tế read-only. Hiển thị nguồn + version + cảnh báo "chưa được chuyên gia lâm sàng thẩm định" khi clinical_review != reviewed.
5. Test: unit test use case + repository (Drift in-memory); test parse seed; test mọi phác đồ có >=1 citation hợp lệ và các trường trạng thái hợp lệ theo enum.
6. flutter analyze, flutter test; lưu log vào docs/evidence/tests/.
7. Hướng dẫn người dùng kiểm thử thủ công ở chế độ máy bay (bước cụ thể). Ảnh chụp để trống: "[CHỜ NGƯỜI DÙNG CHỤP]" trong docs/evidence/screenshots/.
8. Cập nhật R2 (dữ liệu/local), R3 (bảng cái gì dùng được offline/không), traceability, evidence-ledger. Chỉ ghi thực tế.

## Điều kiện dừng
Nếu thiếu nguồn y khoa: dừng và hỏi người dùng thay vì bịa. Không tự commit. Commit đề xuất: "feat: sourced protocol seed data and drift offline store".
