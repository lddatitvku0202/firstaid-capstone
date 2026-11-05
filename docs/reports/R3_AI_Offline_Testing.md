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
| Đồng bộ Supabase | Không | Chưa triển khai |
* [CHƯA CÓ BẰNG CHỨNG: chiến lược xử lý xung đột chưa chốt/triển khai.]

---

## 3. AUTOMATED TEST SUITE & PERFORMANCE PROFILING
* **Unit Test Coverage:** [CHƯA CÓ BẰNG CHỨNG: chưa chạy test] • **Frame Rate:** [CHƯA CÓ BẰNG CHỨNG: chưa đo FPS]
* **🔗 Internal Testing APK Link:** [CHƯA CÓ BẰNG CHỨNG: chưa có bản build]
