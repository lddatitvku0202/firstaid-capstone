# Requirements Traceability

Trạng thái: Done / Partial / Missing / Not verified. Ngày cập nhật: 2026-11-11.

## 5 tiêu chuẩn bắt buộc
| # | Tiêu chuẩn | Trạng thái | Bằng chứng |
|---|---|---|---|
| 1 | Clean Architecture 3 lớp | Partial | Skeleton + domain isolation test pass (E-004, E-005); chưa có Data thật |
| 2 | Tính năng AI thực sự (Streaming LLM) | Partial | Backend FastAPI + Gemini client + SSE + validation, 60 test mock (E-017); eval offline (E-018, E-019); eval Gemini thật 2 lượt, lần 2: nguồn hợp lệ 5/5, đúng mã 18/20, p50 2698 ms nhưng 14/35 (40%) lỗi hạ tầng HTTP 429 nên mẫu rất nhỏ (E-020); chưa thử retry/backoff dài; chưa đo SSE với Gemini thật; chưa deploy (E-021). App đã tích hợp màn "Mô tả tình huống" (SSE, fallback, đồng ý quyền riêng tư), 119 test pass (E-022), build APK debug (E-023); chưa chạy app với backend thật; video fallback [CHỜ NGƯỜI DÙNG QUAY VIDEO] (E-025) |
| 3 | Offline-First (Drift + Supabase) | Partial | Drift + seed (E-006); schema/RLS + sync queue + test fake remote (E-014); RLS đã chạy trên Supabase: 13/13 PASS, ghi nhận 2026-11-08 (E-015, `docs/evidence/rls/rls-test-20261107-001222.csv`; chưa có ảnh SQL Editor, chưa có ca `sync_events`); app Flutter chưa thử với Supabase thật; chưa thử trên máy |
| 4 | Material 3, Dark Mode, 60fps | Partial | M3 sáng/tối; 7 màn × 2 theme đạt guideline tap target/nhãn/tương phản, cỡ chữ 200% không tràn/cắt chữ (E-027); 3 lỗi accessibility đã sửa; tối ưu jank (R3 3.5); integration test offline pass trên emulator (E-028). Dark Mode chưa xem trên máy thật; **FPS: [CHỜ SỐ ĐO THẬT]** (hướng dẫn + perf test sẵn, E-029) |
| 5 | Ký số release tự động qua Fastlane | Partial | ci.yml + release.yml + Fastfile + Gradle đọc key.properties (E-032); ký thử cục bộ bằng keystore thử (E-033); lệnh CI chạy cục bộ (E-034); ci #1 xanh trên GitHub (E-037); **release workflow chạy thành công trên GitHub** (tag v0.1.0, commit c0fcdec, Fastfile chạy thật lần đầu): APK v2 verified, AAB jar verified, ký bằng keystore thật của nhóm (CN=FirstAid Team, tự ký, không timestamp), SHA-256 APK/AAB/chứng chỉ ghi ở E-038; cài thử lên emulator (E-039). Là bản offline-only (R-33: không AI/Supabase). Còn thiếu: log từng bước của workflow, kiểm tra trên điện thoại thật, Play Store/upload key |

## Báo cáo
| Report | Trạng thái | Ghi chú |
|---|---|---|
| R1 | Partial | Khung + mô tả đề tài + luồng/màn hình đã triển khai; thiếu persona, tên nhóm, ảnh máy thật |
| R2 | Partial | Clean Architecture + Drift + SOS + ERD + bảng RLS đã ghi; RLS 13/13 PASS (E-015, ghi nhận 2026-11-08; giới hạn xem docs/evidence/rls/README.md); thiếu video, tag M2 |
| R3 | Partial | Bảng offline/online + xung đột + pipeline AI + số đo offline + số đo LLM thật (mẫu nhỏ) + mục 1b tích hợp app/fallback + mục 3 test/coverage/accessibility/tối ưu (Prompt 08); thiếu video fallback, chạy app với backend thật trên điện thoại/backend đã deploy (mới có emulator + backend local, E-031), FPS [CHỜ SỐ ĐO THẬT], APK release |
| R4 | Partial | Chapter 4 (AI), Chapter 5 (test, hiệu năng) và mục CI/CD & ký số release bản nháp (release workflow đã chạy thành công với tag v0.1.0, E-038; bản offline-only); FPS [CHỜ SỐ ĐO THẬT]; các chương khác chưa viết |

## Form Q1-Q19
| Q | Nội dung | Trạng thái |
|---|---|---|
| Q1-Q6 | Lớp, người nộp, MSSV, email, SĐT, tên nhóm | Người dùng tự điền — Not verified |
| Q7-Q8 | Tên đề tài VI/EN | Partial (có tên trong tài liệu) |
| Q9 | Danh sách thành viên + % đóng góp | Người dùng tự điền — Not verified |
| Q10 | Tech stack (Flutter) | Done (dự kiến) |
| Q11 | Tick đủ 4 report | Not verified |
| Q12 | Link thư mục Drive PDF | Missing |
| Q13 | Link GitHub | Not verified |
| Q14 | Link Figma | Partial (chưa kiểm tra quyền chia sẻ) |
| Q15 | Video demo | Missing |
| Q16 | Link APK/AAB | Missing |
| Q17 | Tự đánh giá tiến độ 1-5 | Người dùng tự điền — Not verified |
| Q18 | Tóm tắt kết quả/khó khăn | Missing |
| Q19 | Cam kết liêm chính | Người dùng xác nhận — Not verified |

## Chức năng MVP theo mô tả đề tài (cập nhật 2026-11-07)
| Chức năng | Trạng thái | Bằng chứng |
|---|---|---|
| SOS và vị trí (gọi 115, tọa độ, SMS soạn sẵn có xác nhận) | Partial | Code + 45 test (E-011); chưa chạy trên máy thật; video [CHỜ NGƯỜI DÙNG QUAY MÀN HÌNH] |
| Đồng bộ Supabase (phác đồ + hàng đợi log SOS) | Partial | Code + 63 test (E-014); RLS 13/13 PASS trên Supabase, ghi nhận 2026-11-08 (E-015); app Flutter chưa thử với Supabase thật; UI consent/đăng nhập chưa có |
| AI định tuyến tình huống (backend) | Partial | E-017..E-021. Eval LLM thật lần 2: nguồn 5/5 (100%), đúng mã 18/20 (90%), p50 2698 ms, lỗi hạ tầng 14/35 (40%, HTTP 429); mẫu nhỏ, chưa chạy với retry đủ dài; chưa deploy |
| AI trong app: Mô tả tình huống + fallback an toàn (Prompt 07) | Partial | Code + 119 test pass (E-022), build APK debug (E-023), quy tắc 115 Dart khớp backend 35/35 ca (E-024); đã chạy thủ công trên emulator với backend local thật, vài lần thử, có log + 3 ảnh (E-031), chưa chạy trên điện thoại thật/backend deploy; video online → AI → tắt mạng → fallback [CHỜ NGƯỜI DÙNG QUAY VIDEO] (E-025) |
