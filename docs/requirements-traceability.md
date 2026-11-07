# Requirements Traceability

Trạng thái: Done / Partial / Missing / Not verified. Ngày cập nhật: 2026-11-05.

## 5 tiêu chuẩn bắt buộc
| # | Tiêu chuẩn | Trạng thái | Bằng chứng |
|---|---|---|---|
| 1 | Clean Architecture 3 lớp | Partial | Skeleton + domain isolation test pass (E-004, E-005); chưa có Data thật |
| 2 | Tính năng AI thực sự (Streaming LLM) | Partial | Backend FastAPI + Gemini client + SSE + validation, 60 test mock (E-017); eval offline (E-018, E-019); eval Gemini thật 2 lượt, lần 2: nguồn hợp lệ 5/5, đúng mã 18/20, p50 2698 ms nhưng 14/35 (40%) lỗi hạ tầng HTTP 429 nên mẫu rất nhỏ (E-020); chưa thử retry/backoff dài; chưa đo SSE với Gemini thật; chưa deploy (E-021), chưa tích hợp app |
| 3 | Offline-First (Drift + Supabase) | Partial | Drift + seed (E-006); schema/RLS + sync queue + test fake remote (E-014); RLS đã chạy trên Supabase: 13/13 PASS, ghi nhận 2026-11-08 (E-015, `docs/evidence/rls/rls-test-20261107-001222.csv`; chưa có ảnh SQL Editor, chưa có ca `sync_events`); app Flutter chưa thử với Supabase thật; chưa thử trên máy |
| 4 | Material 3, Dark Mode, 60fps | Partial | Theme M3 sáng/tối + màn UI khẩn cấp + cài đặt đã code và có test widget (E-009); Dark Mode chưa xem trên máy; FPS chưa đo |
| 5 | Ký số release tự động qua Fastlane | Missing | — |

## Báo cáo
| Report | Trạng thái | Ghi chú |
|---|---|---|
| R1 | Partial | Khung + mô tả đề tài + luồng/màn hình đã triển khai; thiếu persona, tên nhóm, ảnh máy thật |
| R2 | Partial | Clean Architecture + Drift + SOS + ERD + bảng RLS đã ghi; RLS 13/13 PASS (E-015, ghi nhận 2026-11-08; giới hạn xem docs/evidence/rls/README.md); thiếu video, tag M2 |
| R3 | Partial | Bảng offline/online + xung đột + pipeline AI + số đo offline; thiếu số đo LLM thật, FPS, APK |
| R4 | Partial | Chapter 4 bản nháp (AI); các chương khác chưa viết |

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
| AI định tuyến tình huống (backend) | Partial | E-017..E-021. Eval LLM thật lần 2: nguồn 5/5 (100%), đúng mã 18/20 (90%), p50 2698 ms, lỗi hạ tầng 14/35 (40%, HTTP 429); mẫu nhỏ, chưa chạy với retry đủ dài; chưa deploy, chưa tích hợp app |
