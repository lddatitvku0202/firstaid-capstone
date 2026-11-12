# FirstAid — Slide bảo vệ (11 trang)

Nguồn: R4 (`docs/reports/R4_Final_Report.md`) và sổ bằng chứng (`docs/evidence-ledger.md`). Mọi số liệu lấy từ file/log đã có trong repo. Chỗ chưa có dữ liệu ghi `[CHỜ ...]` hoặc `[CHƯA CÓ]`. Tên nhóm, thành viên, MSSV, % đóng góp: nhóm tự điền.

## Slide 1: FirstAid — Trợ lý sơ cứu khẩn cấp offline-first

- Học phần: Phát triển ứng dụng di động đa nền tảng (VKU)
- Nhóm: [NHÓM TỰ ĐIỀN: tên nhóm, thành viên, MSSV]
- Stack: Flutter + Dart 3, Riverpod, Drift (SQLite), Supabase, FastAPI, Gemini + RAG-lite
- Repo: https://github.com/lddatitvku0202/firstaid-capstone (tag `v0.1.0`)
- Lưu ý: nội dung sơ cứu **chưa được chuyên gia lâm sàng thẩm định**; trường hợp nguy hiểm gọi 115

---

## Slide 2: Vấn đề và mục tiêu

- Khi sơ cứu: hoảng loạn, quên trình tự, mẹo truyền miệng nguy hiểm, không có mạng ổn định
- Mục tiêu: luồng sơ cứu có kiểm soát, **chạy khi mất mạng**, nội dung có trích dẫn nguồn
- Năm tiêu chuẩn bắt buộc: Clean Architecture • AI thực sự (streaming LLM) • Offline-First (Drift + Supabase) • Material 3 + Dark Mode + 60fps • Ký số release tự động qua Fastlane
- Quy tắc an toàn của nhóm: AI chỉ định tuyến tới mã phác đồ có sẵn; không chẩn đoán, không kê thuốc

---

## Slide 3: Giải pháp và phạm vi

- Đã làm: sàng lọc khẩn cấp Có/Không • cẩm nang 6 phác đồ (CPR, hóc dị vật, chảy máu, bỏng) • hướng dẫn từng bước + đọc to • SOS (gọi 115, tọa độ, SMS soạn sẵn) • Mô tả tình huống (AI + fallback) • Cài đặt Sáng/Tối/cỡ chữ
- Chưa làm (Future Work): bộ đếm nhịp CPR, bản đồ/cộng đồng, vision triage, cảm biến CPR
- Nguồn nội dung: IFRC-2025, bản tóm lược của nhóm, `clinical_review = not_clinically_reviewed`, luôn hiện cảnh báo
- Figma: prototype định hướng luồng; giao diện cuối là app đã chạy

---

## Slide 4: Kiến trúc Clean Architecture

- 3 lớp: **Domain** (Dart thuần) ← **Data** (Drift, Supabase, http, service) • **Presentation** (Riverpod, go_router)
- Domain không import Flutter/Drift/Supabase: có test cô lập (`domain_isolation_test`, E-005)
- Mọi phụ thuộc nền tảng qua interface → test bằng fake
- Quy mô: 4629 dòng Dart (không tính `*.g.dart`); 7 màn; 13 use case
- Luồng cốt lõi chỉ dùng SQLite; Supabase và FastAPI/Gemini là lớp tùy chọn

---

## Slide 5: Offline-First và Supabase

- Drift schema v2: `protocols`, `protocol_steps`, `triage_nodes`, `meta`, `sync_jobs`; seed từ asset JSON
- Supabase: 3 bảng, RLS bật cả 3; kịch bản RLS **13/13 PASS** (do nhóm chạy, E-015)
- Đồng bộ: server thắng nhưng chỉ nhận bản `reviewed` + `verified`; ghi trong 1 transaction; hàng đợi retry tối đa 5 lần, log SOS idempotent
- Kiểm chứng: 63 test với fake remote (tại thời điểm đó, E-014)
- Chưa làm: thử app với Supabase thật, UI đăng nhập/đồng ý cho log SOS

---

## Slide 6: AI: định tuyến, không sinh nội dung

- Pipeline: quy tắc 115 xác định → truy xuất BM25 → Gemini chọn **mã** → validate (schema, allowlist, nguồn)
- SSE: `status`, `delta` (chỉ báo tiến trình), `result` (đã validate)
- App: mở phác đồ từ Drift theo mã; không hiển thị văn bản do LLM sinh; mọi lỗi → sàng lọc offline + Gọi 115
- Từ khóa nguy cấp kiểm tra **trên máy** trước khi gửi gì lên mạng
- Hiện tại: backend chạy local, **chưa deploy**; bản release **không có AI** (R-33)

---

## Slide 7: Chỉ số AI (số thật, mẫu nhỏ)

- Backend: 60 test pass (mock LLM) — E-017
- Offline (35 ca nhãn tự gán): quy tắc 115 recall 9/12, kích hoạt nhầm 0/23; truy xuất top-3 12/14, top-1 9/14 — E-018
- Gemini thật (gemini-2.5-flash), lần 2: nguồn hợp lệ 5/5, đúng mã 18/20 trên ca có trả lời; p50 2698 ms, p95 3244 ms (n=6) — E-020
- **14/35 ca (40%) bị HTTP 429**: mẫu LLM chỉ 6 ca/lượt, tỷ lệ không ổn định
- Chưa đo: time to first token; retry/backoff dài; điện thoại thật

---

## Slide 8: Chất lượng: test, Dark Mode, accessibility

- 159 test pass, `flutter analyze` sạch, `dart format` 0 thay đổi (E-036)
- Coverage dòng (bản 155 test, E-027): 87,12% không tính file sinh tự động; 58,62% tính cả `app_database.g.dart`
- 7 màn × Sáng/Tối đạt 3 guideline (tap target, nhãn, tương phản); cỡ chữ 200% không cắt chữ
- Test đối chứng chứng minh kiểm tra không "rỗng"; tìm ra và sửa 3 lỗi thật
- Integration test chế độ máy bay: pass trên emulator Android 13 (E-028)
- Dark Mode mới có ảnh trên emulator; chưa xem trên máy thật

---

## Slide 9: Hiệu năng (FPS)

- Đã tối ưu: cache theme, không ghi đĩa mỗi frame khi kéo thanh cỡ chữ, giữ danh sách khi tìm kiếm, bật lint `const`
- Công cụ đo sẵn: `flutter drive --profile --no-dds` + `watchPerformance`; hướng dẫn `docs/evidence/fps/README.md`
- **FPS / frame time: [CHỜ SỐ ĐO THẬT]**: cần điện thoại Android thật, chế độ profile
- Không dùng số từ emulator hay debug làm số FPS

---

## Slide 10: CI/CD và ký số release

- `ci.yml`: format, analyze, test, pytest — run #1 xanh, 2m 14s (E-037)
- `release.yml`: tag `v0.1.0` → Fastlane build + ký + xác minh — run #1 xanh, 7m 55s, 1 artifact (E-038)
- APK: apksigner v2 verified; AAB: jarsigner "jar verified."; chứng chỉ tự ký CN=FirstAid Team, không timestamp
- SHA-256 chứng chỉ `958b3806…b3a8`; cài thử APK lên emulator, versionName 0.1.0 (E-039)
- Giới hạn: bản offline-only; chưa thử trên máy thật; artifact hết hạn sau 30 ngày; chưa có link tải ổn định

---

## Slide 11: Kết luận, bài học, hướng phát triển

- Kết quả: 5 tiêu chuẩn đều có triển khai và bằng chứng, **chưa tiêu chuẩn nào được kiểm chứng trên điện thoại thật**; FPS chờ số đo
- Bài học: lỗi UI "im lặng" cần test chủ động • chạy trên thiết bị lộ lỗi mà widget test bỏ sót • LLM có thể không khả dụng (429) nên fallback là đường chính • quyết định cấu hình build sớm (R-33)
- Future Work: deploy backend, release có cấu hình AI/Supabase, thẩm định lâm sàng, đo FPS và quay video trên máy thật, bộ đếm nhịp CPR, bản đồ/cộng đồng, vision triage, cảm biến CPR
- Cảm ơn thầy cô và hội đồng
