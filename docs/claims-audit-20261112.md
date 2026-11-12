# Rà soát tuyên bố trong R1–R4 so với bằng chứng (Prompt 10, 2026-11-12)

Phương pháp: đối chiếu từng báo cáo trong `docs/reports/` với `docs/evidence-ledger.md`, `docs/requirements-traceability.md`, `docs/risk-register.md`, `git log` và các file trong `docs/evidence/`. Chỉ liệt kê những gì phát hiện được qua đọc; chưa chạy lại các lệnh kiểm thử trong lần rà soát này (trừ việc xuất PDF).

## A. Tuyên bố lỗi thời hoặc không còn đúng (đã sửa)
| Vị trí | Tuyên bố cũ | Bằng chứng hiện có | Xử lý |
|---|---|---|---|
| R1 bảng màn hình | "Mô tả tình huống bị tắt vì AI chưa triển khai" | Màn đã triển khai (E-022, E-031) | Sửa; thêm hàng "Mô tả tình huống" và "SOS" |
| R1 cuối mục 2 | "Nhóm chưa triển khai ... AI mô tả tình huống" | Đã triển khai | Thay bằng bảng trạng thái 6 tính năng (bộ đếm CPR, bản đồ/cộng đồng ghi "chưa triển khai") |
| R1 | "UI, chưa chạy trên máy thật" | Đã chạy trên emulator (ảnh 2026-11-06/07, E-028, E-039) | Ghi "đã chạy trên emulator; chưa chạy trên điện thoại thật" |
| R2 mục 1 | "Supabase datasource chưa triển khai" | `SupabaseRemoteSyncSource` có code + test fake (E-014) | Sửa; ghi rõ chưa thử với Supabase thật |
| R2 mục 1 | Cây thư mục skeleton (2026-11-05), "màn Home rỗng" | `find app/lib` ngày 2026-11-12 | Thay cây và mô tả |
| R2 Prompt 07 | "bản release chưa build/kiểm tra" | Release v0.1.0 (E-038) | Sửa |
| R2 Prompt 04/05 | "(chưa chạy trên máy)" | App đã chạy trên emulator | Ghi chú "lúc đó chưa chạy; sau đó đã chạy trên emulator" |
| R2 mục 3 | Tag M2 "chưa có tag/branch" | Chỉ có tag `v0.1.0` (không phải M2) | Ghi rõ không có tag M2 |
| R3 mục 1b | "màn luôn hiện thông báo gửi dữ liệu", hỏi đồng ý khi AI chưa cấu hình | D-061, E-036 | Sửa mô tả và sơ đồ |
| R3 mục 2 | "chưa chạy ở chế độ máy bay" | Integration test chế độ máy bay trên emulator (E-028) | Sửa |
| R3 mục 3.6 | "Internal Testing APK Link: chưa có bản build" | Release v0.1.0 (E-038) | Sửa; ghi chưa có link ổn định |
| R4 | Chương 1, 2, 3, 6 "chưa viết"; mục 3 checklist "CHƯA CÓ BẰNG CHỨNG" | — | Đã viết; cập nhật checklist |
| traceability | Tiêu chuẩn 1 "chưa có Data thật"; R1–R4; Q7/8/13/14/16 | Xem file | Cập nhật |
| evidence-ledger E-035, risk-register R-32, release-signing-guide | "CHƯA CHẠY" | ci #1, release #1 (E-037, E-038) | Cập nhật theo yêu cầu |

## B. Tuyên bố giữ lại nhưng bằng chứng yếu (đã ghi giới hạn trong báo cáo)
| Tuyên bố | Giới hạn |
|---|---|
| ci #1 xanh, 2m 14s; release #1 xanh, 7m 55s | Từ ảnh chụp và link do người dùng cung cấp; log từng bước chưa tải về |
| `adb install` báo Success; dumpsys versionName 0.1.0 | "Success" chỉ theo lời người dùng; file dumpsys không ghi tên package; ảnh không chứng minh APK từ workflow |
| SHA-256 APK/AAB "khớp SHA256SUMS.txt" | Repo không có APK/AAB, không có log băm lại; chỉ xác nhận giá trị trong file khớp giá trị người dùng đưa |
| Fastfile "chạy thật" | Suy ra từ việc release workflow xanh và có file apksigner/aab-certs do Fastfile ghi; chưa có log bước |
| RLS 13/13 PASS | CSV do người dùng chạy; không có ảnh/log phiên; chưa phủ `sync_events` |
| Figma công khai | Người dùng báo; chưa kiểm chứng |
| Eval LLM thật (nguồn hợp lệ 5/5, đúng mã 18/20) | Mẫu 6–7 ca/lượt do 40% HTTP 429; nhãn tự gán |
| App → backend thật | 1 dòng log + 3 ảnh trên emulator; log không chứng minh khớp từng ảnh (R3 mục 1b) |
| E-001 môi trường (Flutter 3.47.6...) | Có `docs/evidence/ci/flutter-doctor-initial.txt` (ghi 2026-11-05) dù dòng ledger còn ghi "chưa lưu log" |

## C. Bằng chứng có tên không khớp nội dung
- `docs/evidence/screenshots/triage-01-consciousness-dark.png`: tên có "dark" nhưng ảnh là giao diện **Sáng**. Dark Mode thật chỉ thấy ở `home-dark-emulator-20261106.png`.
- `docs/evidence/ci/release-run-1-success-20261111.png`: run chạy ngày 2026-11-12.
- Các file `*-20261107-001222.csv` (RLS): tên ghi 2026-11-07, mtime 2026-11-08 (đã ghi ở docs/evidence/rls/README.md).

## D. Không có bằng chứng, để trống hoặc ghi "chưa có" (không tự bịa)
- Tên nhóm, thành viên, MSSV, % đóng góp; persona; link Drive; video demo; số FPS; ảnh/video trên điện thoại thật; deploy backend; thẩm định lâm sàng; tag/branch M2; file .pptx.
- Các số mẫu trong template (85 ms, 94,2%, +45 MB, ≥ 80%, 58–60 FPS): không dùng.

## E. Chưa xử lý
- Cột trạng thái "Done (chưa commit)" ở nhiều dòng ledger cũ (E-003..E-036): trạng thái lúc tạo, nay đã commit.
- R4 xuất ra 16 trang PDF, dưới mức 25–40 trang của template (không độn nội dung).
- Coverage đo ở bản 155 test; chưa đo lại cho 159 test.
