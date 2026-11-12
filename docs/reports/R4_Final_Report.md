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
* CHAPTER 5: TESTING, PERFORMANCE PROFILING & EVALUATION — bản nháp bên dưới (FPS: [CHỜ SỐ ĐO THẬT])
* CI/CD & KÝ SỐ RELEASE (tiêu chuẩn 5): bản nháp bên dưới (ci và release workflow đã chạy thành công trên GitHub; bản release là offline-only)
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

**Hạn chế.** Phủ 4 chủ đề; chưa deploy; app đã tích hợp và chạy thủ công vài lần trên emulator với backend local thật (E-031), nhưng chưa chạy trên điện thoại thật và chưa với backend đã deploy; danh sách từ khóa 115 tồn tại ở hai nơi (Dart và Python) nên phải sửa đồng thời; kiểm thử với Gemini thật mới ở mẫu nhỏ và bị rate limit (40% ca không có kết quả LLM); chưa thử retry/backoff dài; chưa đo SSE với Gemini thật; từ khóa quy tắc chưa rà soát lâm sàng; nội dung tình huống gửi tới bên thứ ba khi dùng đường LLM.

---

## CHAPTER 5 (bản nháp): TESTING, PERFORMANCE PROFILING & EVALUATION
**Chiến lược kiểm thử.** Nhờ Clean Architecture, mọi phụ thuộc nền tảng (mạng, TTS, trình quay số, vị trí, SMS, AI) đi qua interface ở Domain, nên use case và màn hình được kiểm thử với fake. Có bốn tầng: unit test Domain; test Data trên SQLite in-memory và HTTP giả lập (`MockClient`); widget test từng màn và từng trạng thái (gồm mọi nhánh fallback của AI); integration test chạy trên thiết bị.

**Kết quả.** 155 test tự động pass, `flutter analyze` không có vấn đề (`docs/evidence/tests/quality-checks-20261110-013916.log`). Coverage dòng thật từ lcov: 1495/1716 (87.12%) nếu không tính file sinh tự động, 2010/3429 (58.62%) nếu tính cả `app_database.g.dart`. Lớp domain 272/280, presentation 685/708. Phần phủ thấp chủ yếu là wrapper nền tảng chỉ chạy được trên thiết bị và nguồn Supabase (chi tiết R3 mục 3.2). Integration test luồng khẩn cấp ở chế độ máy bay pass trên emulator Android 13 (`docs/evidence/tests/integration-emergency-offline-20261110-012638.log`); chưa chạy trên điện thoại thật.

**Accessibility và Dark Mode.** Bảy màn chính được kiểm tự động ở cả giao diện Sáng và Tối với ba guideline của Flutter (vùng chạm ≥ 48 dp, nút có nhãn, tương phản chữ) và ở cỡ chữ 200%. Có test đối chứng để chứng minh các kiểm tra không "rỗng". Quá trình này tìm ra ba lỗi thật và đã sửa: chữ bị cắt trong nút cao cố định khi phóng to chữ, app bỏ qua cỡ chữ hệ thống, và thẻ kết quả AI nằm ngoài vùng nhìn thấy trên màn nhỏ (R3 mục 3.4). Dark Mode chưa được xem trên máy thật.

**Hiệu năng.** Đã sửa các điểm nghi ngờ gây jank: dựng lại theme mỗi lần build, ghi đĩa mỗi frame khi kéo thanh cỡ chữ, danh sách nháy khi tìm kiếm (R3 mục 3.5). Chưa có số đo trước/sau. **FPS và frame time: [CHỜ SỐ ĐO THẬT]**. Quy trình đo profile mode trên máy thật và perf test lặp lại được đã chuẩn bị (`docs/evidence/fps/README.md`, `docs/evidence/fps/fps-measurements.md`).

**Đánh giá AI.** Xem Chapter 4 và R3 mục 1.

**Hạn chế.** Chưa đo FPS; chưa chạy trên điện thoại thật; coverage là coverage dòng (không phải nhánh) và không gồm integration test; test widget dùng font Ahem nên kiểm tra cỡ chữ mang tính bảo thủ; tương phản mới đo trong môi trường test.

---

## CI/CD & KÝ SỐ RELEASE (bản nháp, tiêu chuẩn 5)
**Thiết kế.** Có hai workflow GitHub Actions, đều chạy trên `ubuntu-latest`:
- `.github/workflows/ci.yml` chạy với mọi push và PR, gồm hai job:
  - Flutter: `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`.
  - Backend: `pytest` với Python 3.10.
  - Workflow này không dùng secret.
- `.github/workflows/release.yml` chạy khi push tag `vX.Y.Z` hoặc chạy tay:
  1. Chạy lại analyze và test.
  2. Giải mã keystore từ secret `KEYSTORE_BASE64` vào thư mục tạm của runner và tạo `app/android/key.properties` từ `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`.
  3. Gọi Fastlane lane `android release` (`app/android/fastlane/Fastfile`), lane này:
     - Build AAB và APK release. Tên phiên bản lấy từ tag; versionCode là số lần chạy workflow.
     - Xác minh chữ ký: apksigner cho APK, jarsigner/keytool cho AAB.
     - Từ chối nếu thiếu `key.properties` hoặc nếu chứng chỉ là `CN=Android Debug`.
     - Ghi SHA-256 của từng file.
  4. Xóa keystore ở bước `if: always()`, rồi upload artifact.
- Gradle (`app/android/app/build.gradle.kts`) đọc khóa ký từ `key.properties`. File này gitignore. Thiếu file thì bản release ký bằng khóa debug, chỉ để chạy thử trên máy. Đã kiểm tra: apksigner báo `CN=Android Debug`, đúng chuỗi mà Fastlane lane dùng để từ chối.

**Bảo mật (repo public).**
- Keystore, mật khẩu và `key.properties` không nằm trong repo; `.gitignore` chặn `*.jks`, `*.keystore`, `key.properties`.
- Secret chỉ đi qua biến môi trường của một bước. Workflow không echo secret, và GitHub che giá trị secret trong log.
- PR từ fork không đọc được secret.
- Hướng dẫn tạo và sao lưu keystore, thêm Secrets: `docs/evidence/ci/release-signing-guide.md`.

**Phiên bản công cụ.** CI cấu hình Flutter 3.47.6 stable và JDK Temurin 21, khớp máy phát triển; Python 3.10. Bản vá JDK, Python và build-tools trên runner có thể khác máy dev; bảng so sánh ở `docs/evidence/ci/ci-runs.md`. Fastlane `~> 2.225` chạy trên Ruby 3.3; chưa có Gemfile.lock.

**Kết quả chạy thật trên GitHub (2026-11-12).**
- **ci #1** (commit 40f917a): Success, 2m 14s (theo ảnh; ledger E-037).
- **release #1** (tag v0.1.0, commit c0fcdec): Success, 7m 55s, 1 artifact (ảnh + link run; ledger E-038). Đây là lần đầu **Fastfile chạy thật** (trước đó chưa chạy được vì máy dev không có Ruby). Các giá trị dưới đây lấy từ `docs/evidence/ci/release-run-v0.1.0-20261112/`:
  - APK: `apksigner` báo v2 scheme verified; AAB: `jarsigner` báo "jar verified.".
  - Chủ sở hữu chứng chỉ: CN=FirstAid Team, OU=Khoa Khoa hoc May tinh, O=VKU, Da Nang, VN. Chứng chỉ tự ký, hiệu lực đến 2054-03-30; chữ ký không có timestamp; jarsigner cảnh báo chuỗi chứng chỉ không xác minh được qua CA (đúng với chứng chỉ tự ký). File `jarsigner-verify-summary.txt` là bản rút gọn của đầu ra jarsigner.
  - SHA-256 chứng chỉ: `958b380653a70f42c50609ae1a844a6551096ec170b654bc1ff66f0d9869b3a8` (apksigner và keytool của AAB cho cùng giá trị).
  - SHA-256 APK `83eed80bb05584a79203eb5c608c943c2170fe5e5ad5719d3d7165b6741c0081`, AAB `fbf54243fe84d4cc9bb4b8354fd0e57898ebce259a3b1338bceb93c71fb6c220`, khớp `SHA256SUMS.txt`.
- **Cài thử:** APK từ workflow cài lên emulator `vku_test_api33` ngày 2026-11-12 (`adb install` báo Success theo người dùng; `dumpsys`: versionName 0.1.0, versionCode 1, minSdk 24, targetSdk 36) và chạy được Home, Cẩm nang, Mô tả tình huống (ảnh trong `docs/evidence/screenshots/release-v0.1.0-*.png`; E-039).
- **Bản này là offline-only (R-33):** release.yml không truyền `--dart-define`, nên bản build không có AI và không có Supabase. Màn "Mô tả tình huống" hiện thẻ "Ứng dụng chưa được cấu hình máy chủ AI.", không hỏi đồng ý gửi dữ liệu.

**Kiểm chứng trước đó (cục bộ, Windows).**
- Đã build AAB và APK release bằng một keystore **thử dùng một lần**, không phải keystore thật (`docs/evidence/ci/local-signing-check-20261111-194317.log`):
  - APK: `apksigner verify` báo "Verified using v2 scheme: true", chứng chỉ `CN=FirstAid Throwaway Test, O=VKU, C=VN`.
  - AAB: `jarsigner -verify` báo "jar verified.", kèm cảnh báo bình thường cho chứng chỉ tự ký và không có timestamp.
- Điều này cho thấy cấu hình ký trong Gradle hoạt động.
- Lệnh của job Flutter trong CI chạy cục bộ (`docs/evidence/ci/local-ci-flutter-20261111-195857.log`): format 0 changed (93 file), analyze "No issues found!", 155 test pass.
- Backend pytest cục bộ: 60 passed (`docs/evidence/ci/local-ci-backend-20261111-194606.log`).
- Hai file workflow parse YAML hợp lệ.

**Chưa kiểm chứng / còn thiếu.**
- Log từng bước của release workflow chưa tải về (chỉ có ảnh tổng quan, link run và các file kết quả); `jarsigner` chỉ lưu bản rút gọn.
- Chưa cài và chạy trên điện thoại thật (mới có emulator); chưa đo FPS.
- Bản release chưa có cấu hình AI/Supabase (R-33); chưa kiểm tra luồng AI hay đồng bộ trong bản release.
- Chứng chỉ tự ký, chưa có kênh phân phối như Play Store (upload key/App Signing chưa làm).
- Chi tiết các lần chạy: `docs/evidence/ci/ci-runs.md`.
