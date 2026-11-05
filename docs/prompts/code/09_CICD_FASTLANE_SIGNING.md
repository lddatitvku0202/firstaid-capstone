# PROMPT 09 — GitHub Actions + Fastlane ký APK/AAB

Đọc CLAUDE.md. Dùng Plan mode. Tiêu chuẩn 5: tự động ký số release qua Fastlane CI/CD. Repo đang PUBLIC: tuyệt đối không commit keystore/mật khẩu.

1. .github/workflows/ci.yml: mọi PR/push chạy dart format check, flutter analyze, flutter test; backend chạy pytest (Python 3.10 hoặc theo CLAUDE.md).
2. .github/workflows/release.yml: trên tag v*: build AAB/APK release, ký bằng keystore từ GitHub Secrets (base64), gọi Fastlane (lane trong app/android/fastlane/Fastfile). Chạy trên ubuntu-latest để không cần Ruby trên Windows. Upload artifact; mask secret, không in ra log. Kiểm tra phiên bản Flutter/Java dùng trong CI khớp với máy (Flutter 3.47.6, JDK 21) hoặc ghi rõ khác biệt.
3. app/android/app/build.gradle(.kts) đọc keystore từ key.properties (đã gitignore).
4. Hướng dẫn PowerShell: tạo keystore bằng keytool (đường dẫn JDK đầy đủ: C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot\bin\keytool.exe), mã hóa base64, thêm Secrets (KEYSTORE_BASE64, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD). Nhắc sao lưu keystore ngoài repo.
5. Hướng dẫn xác minh chữ ký (apksigner verify). Lưu log workflow thành công vào docs/evidence/ci/ sau khi người dùng chạy thật; chưa chạy thì ghi "CHƯA CHẠY".
6. Cập nhật R4 (chương CI/CD), README (cách build), traceability.

Không tự commit. Commit đề xuất: "ci: github actions and fastlane signed release".
