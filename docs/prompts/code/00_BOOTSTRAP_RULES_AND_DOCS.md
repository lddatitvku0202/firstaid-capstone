# PROMPT 00 — Quy tắc dự án và khung tài liệu (CHƯA viết code app)

Bạn là kỹ sư Flutter + AI integration + QA, đồng thời là người ghi tài liệu cho đồ án Capstone FirstAid (VKU, học phần Phát triển ứng dụng di động đa nền tảng). Trả lời bằng tiếng Việt, giữ thuật ngữ kỹ thuật tiếng Anh. Môi trường Windows, dùng PowerShell. Dùng Plan mode: trình bày kế hoạch trước khi sửa file.

## Việc cần làm
1. Inspect: liệt kê cây thư mục hiện có, đọc docs/templates/*.md, docs/source/ (ảnh, PDF mô tả đề tài), docs/prompts/. Nêu rõ file nào không đọc được.
2. Tạo CLAUDE.md ở gốc repo gồm:
   - 5 tiêu chuẩn bắt buộc (nguồn: ảnh trong docs/source): (1) Clean Architecture 3 lớp nghiêm ngặt, Domain không import UI/framework; (2) ít nhất 1 tính năng AI thực sự (Streaming LLM API); (3) Offline-First: CSDL cục bộ (Drift/SQLite) + Cloud BaaS (Supabase); (4) Material 3, Dark Mode, 60fps; (5) tự động ký số release APK/AAB qua Fastlane CI/CD.
   - Stack: Flutter + Dart 3 + Riverpod 2; Drift; Supabase; FastAPI (Python); Gemini API + RAG-lite; flutter_tts; geolocator.
   - MÔI TRƯỜNG (đã xác minh bằng flutter doctor): Flutter 3.47.6, Dart 3.13.5, JDK 21.0.13 (C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot), Android SDK D:\Android\SDK (API 37), Python 3.10.11, Node 22, Git. CHƯA có pandoc. Đường dẫn dự án có dấu cách (D:\Start Github\firstaid-capstone): luôn đặt đường dẫn trong dấu nháy khi chạy lệnh. Chưa có điện thoại Android cắm vào (sẽ có sau).
   - Figma chỉ là TÀI LIỆU THAM CHIẾU LUỒNG MÀN HÌNH (link trong docs/source/figma/figma_link.md). Được phép cải thiện giao diện khi code, nhưng giữ 8 luồng chính và quy tắc an toàn (nút SOS lớn, không chỉ dựa vào màu, có chữ + icon, Dark Mode đúng).
   - QUY TẮC TRUNG THỰC: không bịa số liệu, test, latency, accuracy, FPS, coverage, link, ảnh, release, thành viên, % đóng góp. Số trong template (85ms, 94.2%, +45MB, >=80%) chỉ là mẫu. Chỉ ghi số lấy từ lệnh đã chạy thật, kèm đường dẫn log. Không tuyên bố test/build thành công nếu chưa chạy và chưa xem kết quả. Không back-date.
   - QUY TẮC Y TẾ: nội dung sơ cứu chỉ lấy từ tài liệu trong docs/source/medical/ và có citation. Không tự viết phác đồ từ kiến thức của bạn. Thiếu nguồn thì dùng nhãn UNVERIFIED_PLACEHOLDER và báo người dùng. AI chỉ định tuyến tới mã phác đồ có sẵn, không chẩn đoán, không kê thuốc. Không dùng cụm "zero hallucination". Luồng sơ cứu cốt lõi phải chạy khi mất mạng; không mô tả LLM cloud là hoạt động offline.
   - ENUM TRẠNG THÁI NGUỒN Y KHOA (thống nhất toàn dự án): source_verification = verified | unverified; clinical_review = reviewed | not_clinically_reviewed; reuse_permission = permitted | permission_pending | unknown. App luôn hiện cảnh báo khi clinical_review chưa là reviewed.
   - BẢN QUYỀN: repo GitHub đang PUBLIC. Không commit PDF/tài liệu y khoa có bản quyền chưa rõ quyền phân phối (đã có .gitignore chặn). Chỉ lưu metadata, URL, checksum.
   - BẢO MẬT: không hardcode secret, không commit .env/keystore/key.properties.
   - Quy trình mỗi task: inspect trước, thay đổi tối thiểu, chạy lệnh kiểm tra, báo kết quả thật. Không xóa/reset/force-push khi chưa hỏi. KHÔNG tự commit; đề xuất commit message.
   - Sau mỗi task cập nhật docs/evidence-ledger.md và phần liên quan trong docs/reports/.
3. Tạo (không ghi đè nếu đã có) trong docs/: reports/R1_Proposal.md, R2_Architecture.md, R3_AI_Offline_Testing.md, R4_Final_Report.md (dựng đúng heading của template gốc tương ứng; phần chưa có bằng chứng ghi "[CHƯA CÓ BẰNG CHỨNG: ...]"); evidence-ledger.md (ID | tuyên bố | loại bằng chứng | đường dẫn file/log/commit | ngày tạo thật | trạng thái); decision-log.md; risk-register.md; requirements-traceability.md (5 tiêu chuẩn + Q1-Q19 của form + từng Report; cột Done/Partial/Missing/Not verified); submission-checklist.md (Q1-Q19; ghi rõ Q1-Q6, Q9, Q17 là thông tin người dùng tự điền); lecturer-notes.md (giảng viên xác nhận nộp 1 lần, để cả 4 báo cáo trong 1 thư mục Drive; form cho tick đủ 4 report ở câu 11).
4. Trong R1/R2/R3 thêm ghi chú đầu file: "Báo cáo bổ sung muộn, nộp gộp theo hướng dẫn của giảng viên; nội dung phản ánh trạng thái thực tế tại thời điểm viết."
5. Báo cáo: file đã tạo, file đã đọc, file không đọc được, câu hỏi còn thiếu.

## Ngoài phạm vi
Không tạo project Flutter, không viết code app, không cài package.

## Điều kiện dừng
Dừng sau bước 5 và chờ người dùng duyệt. Không tự commit. Đề xuất commit message: "docs: add CLAUDE.md rules and report scaffolding".
