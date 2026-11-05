# CLAUDE.md — Quy tắc dự án FirstAid Capstone

Đồ án Capstone FirstAid (VKU, học phần Phát triển ứng dụng di động đa nền tảng). Trả lời bằng tiếng Việt, giữ thuật ngữ kỹ thuật tiếng Anh. Môi trường Windows, dùng PowerShell.

## 1. Năm tiêu chuẩn bắt buộc (nguồn: docs/source/5_tieu_chuan_bat_buoc.png)
1. Clean Architecture 3 lớp nghiêm ngặt (Domain, Data, Presentation); Domain không import UI/framework.
2. Ít nhất 1 tính năng AI thực sự (Streaming LLM API).
3. Offline-First: CSDL cục bộ (Drift/SQLite) + Cloud BaaS (Supabase).
4. Material 3, hỗ trợ Dark Mode, 60fps.
5. Tự động ký số release APK/AAB qua Fastlane CI/CD.

## 2. Stack
Flutter + Dart 3 + Riverpod 2; Drift; Supabase; FastAPI (Python); Gemini API + RAG-lite; flutter_tts; geolocator.

## 3. Môi trường (đã xác minh bằng flutter doctor, do người dùng cung cấp)
Flutter 3.47.6, Dart 3.13.5, JDK 21.0.13 (`C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot`), Android SDK `D:\Android\SDK` (API 37), Python 3.10.11, Node 22, Git. CHƯA có pandoc. Chưa có điện thoại Android cắm vào (sẽ có sau).
Đường dẫn dự án có dấu cách (`D:\Start Github\firstaid-capstone`): luôn đặt đường dẫn trong dấu nháy khi chạy lệnh.

## 4. Figma
Figma chỉ là TÀI LIỆU THAM CHIẾU LUỒNG MÀN HÌNH (link: docs/source/figma/figma_link.md). Được cải thiện giao diện khi code, nhưng giữ 8 luồng chính và quy tắc an toàn: nút SOS lớn, không chỉ dựa vào màu (có chữ + icon), Dark Mode đúng.

## 5. Quy tắc trung thực
Không bịa số liệu, test, latency, accuracy, FPS, coverage, link, ảnh, release, thành viên, % đóng góp. Số trong template (85ms, 94.2%, +45MB, >=80%) chỉ là mẫu. Chỉ ghi số lấy từ lệnh đã chạy thật, kèm đường dẫn log. Không tuyên bố test/build thành công nếu chưa chạy và chưa xem kết quả. Không back-date.

## 6. Quy tắc y tế
- Nội dung sơ cứu chỉ lấy từ tài liệu trong docs/source/medical/ và có citation. Không tự viết phác đồ từ kiến thức của model. Thiếu nguồn: dùng nhãn `UNVERIFIED_PLACEHOLDER` và báo người dùng.
- AI chỉ định tuyến tới mã phác đồ có sẵn; không chẩn đoán, không kê thuốc. Không dùng cụm "zero hallucination".
- Luồng sơ cứu cốt lõi phải chạy khi mất mạng; không mô tả LLM cloud là hoạt động offline.
- Enum trạng thái nguồn (thống nhất toàn dự án):
  - `source_verification` = `verified` | `unverified`
  - `clinical_review` = `reviewed` | `not_clinically_reviewed`
  - `reuse_permission` = `permitted` | `permission_pending` | `unknown`
- App luôn hiện cảnh báo khi `clinical_review` chưa là `reviewed`.

## 7. Bản quyền
Repo GitHub đang PUBLIC. Không commit PDF/tài liệu y khoa có bản quyền chưa rõ quyền phân phối (.gitignore đã chặn). Chỉ lưu metadata, URL, checksum.

## 8. Bảo mật
Không hardcode secret; không commit `.env`, keystore, `key.properties`.

## 9. Quy trình mỗi task
- Inspect trước, thay đổi tối thiểu, chạy lệnh kiểm tra, báo kết quả thật.
- Không xóa/reset/force-push khi chưa hỏi. KHÔNG tự commit; đề xuất commit message.
- Sau mỗi task cập nhật `docs/evidence-ledger.md` và phần liên quan trong `docs/reports/`.
- Dùng Plan mode: trình bày kế hoạch trước khi sửa file.
