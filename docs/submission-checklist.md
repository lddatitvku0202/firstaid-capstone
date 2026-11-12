# Submission Checklist (Q1-Q19)

Nguồn: docs/templates/bieu_mau_bao_cao_capstone_vku.md. Cập nhật 2026-11-12. **Q1-Q6, Q9, Q17 là thông tin người dùng tự điền.** Báo cáo không chứa thông tin cá nhân và không có link giả.

Bộ file nộp (đã xuất, thư mục `dist/FirstAid_Capstone_Submission/`, không nằm trong git vì `dist/` bị `.gitignore`):
| File | Số trang (đo từ PDF xuất ra) |
|---|---|
| FirstAid_R1_Proposal.pdf | 5 |
| FirstAid_R2_Architecture.pdf | 6 |
| FirstAid_R3_AI_Offline_Testing.pdf | 12 |
| FirstAid_R4_Final_Report.pdf | **16** (template yêu cầu 25–40 trang, xem "Danh sách còn thiếu") |
| FirstAid_Defense_Slides.pdf / .md | 11 trang (Markdown, không phải .pptx) |
| Evidence/ | bản sao `docs/evidence/` (log, ảnh, JSON, CSV; không có PDF y khoa, keystore hay .env) |

## Đối chiếu Q1-Q19
- [ ] Q1 Lớp học phần — *người dùng tự điền*
- [ ] Q2 Họ tên người nộp — *người dùng tự điền*
- [ ] Q3 MSSV — *người dùng tự điền*
- [ ] Q4 Email sinh viên VKU — *người dùng tự điền*
- [ ] Q5 SĐT/Zalo — *người dùng tự điền*
- [ ] Q6 Tên nhóm/mã nhóm — *người dùng tự điền* (cũng điền vào R1–R4, hiện ghi `[CHƯA CÓ BẰNG CHỨNG: tên nhóm]`)
- [x] Q7 Tên đề tài (VI): "FirstAid – Ứng dụng trợ lý sơ cứu khẩn cấp ngoại tuyến và kết nối hỗ trợ cộng đồng" (từ R1; đối chiếu lại với mô tả đề tài khi điền)
- [x] Q8 Tên đề tài (EN): "Offline-First Emergency First Aid Assistant & Community Support App" (từ R1)
- [ ] Q9 Danh sách thành viên, vai trò, % đóng góp — *người dùng tự điền*
- [x] Q10 Tech stack: Flutter (Dart)
- [ ] Q11 Tick đủ 4 report (xem docs/lecturer-notes.md) — người dùng tick khi điền form
- [ ] Q12 Link thư mục Drive PDF công khai — **chưa có**: tải 4 PDF R1–R4 (và slide) lên Drive, đặt "Anyone with the link can view"
- [~] Q13 Link GitHub: https://github.com/lddatitvku0202/firstaid-capstone (có README, lịch sử commit, tag `v0.1.0`; kiểm tra bằng cửa sổ ẩn danh rằng repo public và các thay đổi mới nhất đã được push)
- [~] Q14 Link Figma: có trong `docs/source/figma/figma_link.md`; người dùng báo đã đặt công khai, **chưa kiểm chứng** (mở bằng cửa sổ ẩn danh); đối chiếu số luồng (5–8) trong file Figma
- [ ] Q15 Video demo 2–5 phút — **chưa có** (cần quay trên điện thoại thật theo `docs/evidence/android-device-run.md`)
- [~] Q16 Link APK/AAB release — APK/AAB v0.1.0 là artifact của release run #1 (E-038); **chưa có link tải công khai ổn định** (artifact giữ 30 ngày, cần đăng nhập GitHub để tải)
- [ ] Q17 Tự đánh giá tiến độ 1-5 — *người dùng tự điền*
- [~] Q18 Tóm tắt kết quả/khó khăn — **bản nháp để nhóm sửa** (chỉ gồm sự kiện có bằng chứng):
  > Nhóm đã xây dựng ứng dụng Flutter FirstAid theo Clean Architecture, chạy offline từ SQLite (Drift): sàng lọc khẩn cấp, cẩm nang 6 phác đồ (IFRC-2025), hướng dẫn từng bước có đọc to, SOS (gọi 115, tọa độ, SMS soạn sẵn), cùng backend FastAPI + Gemini chỉ định tuyến tới mã phác đồ và fallback an toàn khi mất mạng/lỗi. Có 159 test tự động pass, CI GitHub Actions xanh, và release v0.1.0 được ký tự động qua Fastlane (APK/AAB), cài thử trên emulator. Khó khăn: Gemini bị giới hạn tốc độ (HTTP 429) nên 14/35 ca eval không có kết quả LLM; chưa có điện thoại thật nên chưa có video demo và số FPS; bản release hiện offline-only (chưa cấu hình AI/Supabase); nội dung y khoa chưa được chuyên gia thẩm định; chưa làm bộ đếm nhịp CPR và bản đồ/cộng đồng.
- [ ] Q19 Cam kết liêm chính (100% thành viên đồng thuận) — người dùng xác nhận

Ghi chú: `[x]` = có nội dung từ repo; `[~]` = một phần; `[ ]` = cần người dùng làm.

## Danh sách còn thiếu trước khi nộp

### Ưu tiên 1: bắt buộc để nộp form
1. Điền Q1–Q6, Q9, Q17 và xác nhận Q19 (thông tin cá nhân, nhóm, % đóng góp).
2. Điền tên nhóm, thành viên, MSSV vào R1–R4 và slide (hiện để trống), rồi xuất lại PDF.
3. **Q12:** tải 4 PDF (và slide) lên Google Drive, đặt chia sẻ công khai, dán link.
4. **Q15:** quay video demo 2–5 phút trên điện thoại Android thật (luồng khẩn cấp, chế độ máy bay, SOS, và nếu có thể AI online → tắt mạng → fallback).
5. **Q16:** đưa APK/AAB v0.1.0 lên GitHub Release hoặc Drive để có link ổn định. Artifact Actions hết hạn sau 30 ngày (khoảng 2026-12-12; ngày chính xác xem trên GitHub).
6. **Q14:** mở link Figma bằng cửa sổ ẩn danh để chắc là công khai.
7. **Q13:** kiểm tra repo public và đã push commit mới nhất (tài liệu và slide hiện chỉ nằm trên máy nếu chưa commit/push).

### Ưu tiên 2: chất lượng và độ đầy đủ của báo cáo
8. **R4 chỉ 16 trang PDF** (template: 25–40 trang). Chưa độn nội dung. Nếu giảng viên yêu cầu đủ số trang, cần viết thêm nội dung thật (ví dụ: persona và khảo sát người dùng, phân tích yêu cầu chi tiết, mô tả từng màn, kết quả đo FPS, ảnh máy thật).
9. **FPS / frame time: [CHỜ SỐ ĐO THẬT]** (tiêu chuẩn 4): chạy theo `docs/evidence/fps/README.md` trên điện thoại thật ở profile mode; điền `docs/evidence/fps/fps-measurements.md`, ledger E-030, R3 mục 3.6, R4 mục 5.2.
10. Chạy app trên điện thoại thật và chụp ảnh Sáng/Tối từng màn (`docs/evidence/screenshots/emergency_ui.md`), ảnh chế độ máy bay (`offline_airplane_mode.md`). Hiện chỉ có ảnh emulator.
11. Nhờ người có chuyên môn y tế rà soát phác đồ và cây sàng lọc; đối chiếu nguồn Việt Nam (R-03, R-08, R-10, R-13).
12. Viết persona người dùng cho R1 (hiện `[CHƯA CÓ BẰNG CHỨNG]`).
13. Slide hiện là Markdown + PDF 11 trang. Nếu cần .pptx, chuyển thủ công (máy chưa có công cụ tạo .pptx từ nội dung này).

### Ưu tiên 3: kỹ thuật, có thể làm sau
14. Deploy backend (https, rate limit), rồi build lại release có `--dart-define` cho `AI_BASE_URL`/Supabase (R-33); hiện bản v0.1.0 offline-only.
15. Thử app với Supabase thật (RLS mới chỉ test bằng script, E-015); thêm ca `sync_events`; làm UI đăng nhập/đồng ý cho log SOS (R-19).
16. Tải log từng bước của ci #1 và release #1 về `docs/evidence/ci/`; commit `Gemfile.lock`; xử lý cảnh báo Node.js 20 deprecated của các action (R-32).
17. Đo lại coverage cho bộ 159 test (số 87,12% / 58,62% là của bản 155 test).
18. Đổi lại hoặc ghi chú tên bằng chứng không khớp nội dung: `triage-01-consciousness-dark.png` (ảnh Sáng), `release-run-1-success-20261111.png` (run ngày 2026-11-12). Hiện chỉ có ghi chú, chưa đổi tên.
19. Bộ đếm nhịp CPR (Should-Have) và các mục P2 chỉ ở Future Work.
20. Cột "Trạng thái" của nhiều dòng sổ bằng chứng cũ còn ghi "Done (chưa commit)": đó là trạng thái lúc tạo dòng, nay các thay đổi đã được commit; chưa cập nhật hàng loạt.
