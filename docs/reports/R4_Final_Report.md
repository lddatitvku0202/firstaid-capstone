# [REPORT 4] FINAL CAPSTONE REPORT & DEFENSE DOSSIER
**Capstone Project:** Cross-Platform Mobile App Development  
**Official Project Title:** FirstAid  
**Student Team:** [CHƯA CÓ BẰNG CHỨNG: tên nhóm] • **Deadline:** Week 13

---

## 📑 TABLE OF CONTENTS (25–40 PAGES)
* CHAPTER 1: INTRODUCTION & PROBLEM SPACE — [CHƯA CÓ BẰNG CHỨNG: chưa viết]
* CHAPTER 2: REQUIREMENTS ANALYSIS & MOBILE UI/UX DESIGN — [CHƯA CÓ BẰNG CHỨNG: chưa viết]
* CHAPTER 3: SYSTEM DESIGN & CLEAN ARCHITECTURE — [CHƯA CÓ BẰNG CHỨNG: chưa viết]
* CHAPTER 4: ADVANCED CAPABILITIES & ARTIFICIAL INTELLIGENCE — bản nháp bên dưới (đang cập nhật; số đo LLM mới có 2 lượt trên mẫu nhỏ, bị rate limit)
* CHAPTER 5: TESTING, PERFORMANCE PROFILING & EVALUATION — [CHƯA CÓ BẰNG CHỨNG: chưa viết]
* CHAPTER 6: CONCLUSION, LESSONS LEARNED & FUTURE WORK — [CHƯA CÓ BẰNG CHỨNG: chưa viết]

---

## 📦 FINAL DEFENSE DELIVERABLES CHECKLIST
1. Comprehensive Final Technical Report (PDF) — [CHƯA CÓ BẰNG CHỨNG]
2. Oral Defense Slide Deck (10–12 slides) — [CHƯA CÓ BẰNG CHỨNG]
3. Production-Signed Release Binary (APK/AAB/IPA) — [CHƯA CÓ BẰNG CHỨNG]
4. Clean GitHub Code Repository (main branch) — [CHƯA CÓ BẰNG CHỨNG]
5. High-Definition Demo Video (3–5 minutes) on a physical device — [CHƯA CÓ BẰNG CHỨNG]

---

## CHAPTER 4 (bản nháp): ADVANCED CAPABILITIES & ARTIFICIAL INTELLIGENCE
**Thiết kế.** Tính năng AI là một dịch vụ FastAPI định tuyến mô tả tình huống tới mã phác đồ có sẵn. Dịch vụ không tạo nội dung sơ cứu: LLM (Gemini) chỉ chọn một mã trong danh sách ứng viên do truy xuất BM25 trên các phác đồ `verified`, hoặc trả `null` khi mơ hồ/ngoài phạm vi. Kết quả luôn là JSON cố định 5 trường, được validate (schema, allowlist, ứng viên, chủ đề, nguồn) trước khi dùng; sai thì trả mã lỗi để app quay về sàng lọc cục bộ.

**Vì sao RAG-lite (BM25) mà không dùng embedding.** Chỉ 6 phác đồ, chạy thuần Python, không cần mô hình/hạ tầng thêm, kết quả giải thích được và kiểm thử xác định. Đổi lại truy xuất chỉ dựa từ khóa và nhạy cách diễn đạt (đo được top-1 9/14 trên bộ ca tự gán nhãn).

**Vì sao AI chỉ trả mã.** Nội dung sơ cứu phải có trích dẫn nguồn và không được sinh từ kiến thức của model (CLAUDE.md §6). Chọn mã thu hẹp bề mặt rủi ro: sai mã vẫn dẫn tới phác đồ có nguồn, và người dùng luôn thấy cảnh báo chưa thẩm định cùng nút Gọi 115.

**An toàn.** Quy tắc xác định (không qua LLM) kích hoạt "gọi 115" cho dấu hiệu nguy cấp (không thở/không phản ứng, hóc không ho/nói được, chảy máu phun/không cầm được). Quy tắc không đoán tuổi. Mô tả nội dung người dùng không bị ghi log.

**Streaming.** SSE gồm `status`, `delta` (mảnh tạm chưa validate, chỉ hiển thị tiến trình) và `result` đã validate. Chưa đo time-to-first-token.

**Đo lường.** Xem R3 mục 1. Đã đo offline quy tắc, truy xuất và mô phỏng lỗi, và đã chạy eval với Gemini thật (gemini-2.5-flash) 2 lượt trên 35 ca. Kết quả lần 2 (sau khi sửa định dạng nguồn trong prompt): nguồn hợp lệ 5/5 (100%), đúng mã 18/20 (90%) trên các ca có trả lời, độ trễ đường LLM p50 2698 ms và p95 3244 ms (n=6), lỗi hạ tầng 14/35 (40%), toàn bộ là HTTP 429 (rate limit; lần 1 là 9/35 = 25,7%, nguồn hợp lệ 0/3).

*Cách đọc các số này.* Đây là mẫu rất nhỏ: do 429, chỉ 6 ca lần 2 đi tới đầu ra LLM, và 14 ca chưa có kết quả LLM. Các tỷ lệ vì vậy không ổn định, hai lượt không so sánh trực tiếp được (tập ca trả lời khác nhau), và 100% nguồn hợp lệ chỉ dựa trên 5 ca. Nhãn do nhóm tự gán, cần rà lại; số đo mô tả hành vi trên tập nhỏ này, không phải độ chính xác tổng quát. Hai lượt eval chạy với cấu hình retry hiện tại (tối đa 2 lần gọi, backoff 0,5 s), chưa chạy với retry/backoff đủ dài để vượt giới hạn tốc độ. Time to first token của SSE chưa đo; eval dùng chế độ không stream. Chi tiết và đường dẫn bằng chứng: R3, evidence-ledger E-020 (`docs/evidence/ai/eval-llm-20261108-020235.json`, `docs/evidence/ai/eval-llm-20261108-021429.json`).

**Tích hợp vào app và fallback (Prompt 07).** Màn "Mô tả tình huống" gửi mô tả tới `/v1/route-situation` qua SSE và chỉ dùng sự kiện `result` đã validate. Kết quả là mở phác đồ từ CSDL cục bộ (Drift) theo `protocol_code`, kèm nguồn, phiên bản, cảnh báo chưa thẩm định và nhãn "KẾT QUẢ THAM KHẢO"; app không hiển thị văn bản do LLM sinh (kể cả `confidence_note`). Mọi đường hỏng đều quay về cây quyết định tĩnh chạy offline: mất mạng, không tới được máy chủ, timeout (deadline tổng 15 s do nhóm chọn, chưa đo trên mạng thật), lỗi máy chủ (gồm 429), sai schema, `uncertain`, mã không có trong Drift hoặc chủ đề không khớp. Từ khóa nguy cấp được kiểm tra ngay trên máy trước khi gửi (bản port 1-1 của quy tắc backend, khớp 35/35 ca eval khi so chéo) và dẫn thẳng tới "Gọi 115". Nút "Bỏ qua AI, sàng lọc ngay" và "Gọi 115" luôn hiện, bấm bỏ qua sẽ hủy yêu cầu HTTP ngay. Trước lần gửi đầu, app thông báo văn bản sẽ được gửi tới máy chủ và Gemini (bên thứ ba) và xin đồng ý; có thể đổi trong Cài đặt.

*Kiểm chứng.* 119 test tự động pass, gồm unit test use case với fake repository (thành công, uncertain, timeout, mã sai, call_115_now, mất mạng, không đồng ý...), test client SSE bằng `MockClient` và widget test từng trạng thái màn hình (`docs/evidence/tests/ai-integration-checks-20261110-002444.log`); build APK debug thành công (`docs/evidence/tests/build-apk-debug-20261110-002726.log`). Chưa chạy app với backend thật; video kịch bản online → AI → tắt mạng → fallback: [CHỜ NGƯỜI DÙNG QUAY VIDEO].

**Hạn chế.** Phủ 4 chủ đề; chưa deploy; app đã tích hợp nhưng chưa chạy với backend thật trên điện thoại; danh sách từ khóa 115 tồn tại ở hai nơi (Dart và Python) nên phải sửa đồng thời; kiểm thử với Gemini thật mới ở mẫu nhỏ và bị rate limit (40% ca không có kết quả LLM); chưa thử retry/backoff dài; chưa đo SSE với Gemini thật; từ khóa quy tắc chưa rà soát lâm sàng; nội dung tình huống gửi tới bên thứ ba khi dùng đường LLM.
