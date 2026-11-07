> Báo cáo bổ sung muộn, nộp gộp theo hướng dẫn của giảng viên; nội dung phản ánh trạng thái thực tế tại thời điểm viết.

# [REPORT 3] AI INTEGRATION, OFFLINE SYNC & TEST REPORT
**Course:** Cross-Platform Mobile App Development  
**Project Title:** FirstAid  
**Team Name:** [CHƯA CÓ BẰNG CHỨNG: tên nhóm] • **Academic Term:** Semester 1 (2026 - 2027) • **Deadline:** Week 11

---

## 1. ARTIFICIAL INTELLIGENCE CAPABILITIES & BENCHMARKS
* **Model Backbone:** Streaming LLM API (dự kiến Gemini) + RAG-lite qua FastAPI. [CHƯA CÓ BẰNG CHỨNG: chưa triển khai.]
* **Performance Benchmarks:** [CHƯA CÓ BẰNG CHỨNG: latency / tỷ lệ chọn đúng phác đồ / tỷ lệ đúng schema chưa được đo.]

---

## 2. OFFLINE-FIRST SYNCHRONIZATION ENGINE
* Local persistence Drift/SQLite đã triển khai, có test tự động trên SQLite in-memory (log `docs/evidence/tests/drift-seed-checks-20261106-010345.log`). [CHƯA CÓ BẰNG CHỨNG: chưa chạy trên thiết bị thật/chế độ máy bay; xem docs/evidence/offline-manual-test.md.]

| Chức năng | Offline? | Ghi chú |
|---|---|---|
| Cẩm nang 6 phác đồ (bước, không nên làm, khi nào gọi 115, nguồn, phiên bản) | Thiết kế: có (đọc từ SQLite) | Chưa kiểm chứng trên máy thật |
| Cây quyết định triage tĩnh (dữ liệu có trong DB, chưa có màn UI) | Thiết kế: có | Luật xác định, không phải AI |
| Cảnh báo chưa thẩm định lâm sàng | Có | Hiển thị ở danh sách và chi tiết |
| AI Streaming LLM / RAG | Không | Cần mạng; chưa triển khai |
| SOS: gọi 115, vị trí, SMS | Chưa triển khai | Prompt 04 |
| Đồng bộ phác đồ từ Supabase | Cần mạng để cập nhật; đọc phác đồ vẫn offline | Code + test bằng fake remote; chưa thử với Supabase thật |
### Chính sách xung đột và đồng bộ (Prompt 05)
* **Phác đồ:** server version thắng, nhưng CHỈ nhận bản `clinical_review = reviewed` và `source_verification = verified`, và chỉ khi version mới hơn bản trên máy (so sánh số). Bản chưa review không bao giờ ghi đè bản ổn định.
* **Ghi local:** toàn bộ phác đồ nhận về ghi trong một transaction; lỗi giữa chừng thì rollback, giữ bản cũ. Mất mạng hoặc sync lỗi: giữ bản local, UI không đổi.
* **Seed asset:** khi asset đổi version, seed không ghi đè phác đồ đã nhận từ server có version >= asset; asset mới hơn thì asset thắng.
* **Log SOS:** append-only, chỉ gửi khi người dùng đồng ý; ID UUID do client sinh nên gửi lại không nhân đôi (trùng khóa chính coi là đã gửi).
* **Hàng đợi:** lưu bằng Drift (`sync_jobs`), retry tối đa 5 lần, backoff mũ 30 s x 2^(n-1) tối đa 1 giờ; lỗi vĩnh viễn (RLS từ chối, dữ liệu sai) chuyển `failed` ngay. Đồng bộ chạy khi khởi động nếu có kết nối và mỗi khi kết nối quay lại.
* **Đã kiểm chứng (test tự động, fake remote, SQLite in-memory):** retry/backoff, hết lần retry, lỗi vĩnh viễn, idempotency, offline -> online, lọc bản chưa review, rollback, seed không ghi đè, migration v1 -> v2 (kiểm tra thu gọn trên bảng `meta`). Log: `docs/evidence/tests/sync-checks-20261107-234308.log`.
* **CHƯA kiểm chứng:** chạy với Supabase thật, RLS thật, mạng thật trên điện thoại, kết nối "có sóng nhưng không có Internet" (connectivity chỉ cho biết có kết nối).

---

## 3. AUTOMATED TEST SUITE & PERFORMANCE PROFILING
* **Unit Test Coverage:** [CHƯA CÓ BẰNG CHỨNG: chưa chạy test] • **Frame Rate:** [CHƯA CÓ BẰNG CHỨNG: chưa đo FPS]
* **🔗 Internal Testing APK Link:** [CHƯA CÓ BẰNG CHỨNG: chưa có bản build]
