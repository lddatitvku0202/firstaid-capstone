# firstaid-capstone
FirstAid - Offline-First Emergency First Aid Assistant &amp; Community Support App

[![ci](https://github.com/lddatitvku0202/firstaid-capstone/actions/workflows/ci.yml/badge.svg)](https://github.com/lddatitvku0202/firstaid-capstone/actions/workflows/ci.yml)

> Nội dung sơ cứu trong app **chưa được chuyên gia lâm sàng thẩm định**. Trường hợp nguy hiểm: gọi 115.

## Cấu trúc
- `app/`: ứng dụng Flutter (Clean Architecture: domain / data / presentation; Drift offline; Riverpod).
- `backend/`: dịch vụ FastAPI định tuyến tình huống (RAG-lite + Gemini).
- `docs/`: báo cáo, bằng chứng (`docs/evidence/`), traceability.
- `.github/workflows/`: `ci.yml` (kiểm tra mọi push/PR), `release.yml` (build và ký release khi có tag `v*`).

## Yêu cầu (máy phát triển đã dùng)
Flutter 3.47.6 (Dart 3.13.5), JDK 21 (Temurin), Android SDK, Python 3.10. Đường dẫn có dấu cách: luôn đặt trong dấu nháy.

## Chạy và kiểm tra app (PowerShell)
```powershell
cd "D:\Start Github\firstaid-capstone\app"
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter run                                    # thêm --dart-define-from-file=.env nếu dùng AI/Supabase
```

## Backend
```powershell
cd "D:\Start Github\firstaid-capstone\backend"
python -m pip install -r requirements-dev.txt
python -m pytest -q
```
Chi tiết chạy server: [backend/README.md](backend/README.md).

## Build APK/AAB
- **Debug:** `flutter build apk --debug` (trong `app/`).
- **Release trên máy:** `flutter build apk --release` / `flutter build appbundle --release`.
  - Bản release được ký bằng khóa trong `app/android/key.properties`. File này gitignore, **không commit**.
  - Thiếu file thì bản release ký bằng khóa **debug** (chỉ để thử).
- **Release đã ký qua CI (Fastlane):**
  - Push tag `vX.Y.Z`; workflow `release.yml` giải mã keystore từ GitHub Secrets, chạy `fastlane android release`, xác minh chữ ký, rồi upload artifact.
  - Hướng dẫn tạo keystore, thêm Secrets và xác minh chữ ký: [docs/evidence/ci/release-signing-guide.md](docs/evidence/ci/release-signing-guide.md).
  - Kết quả các lần chạy: [docs/evidence/ci/ci-runs.md](docs/evidence/ci/ci-runs.md).

Không commit `.env`, keystore (`*.jks`), `key.properties` hay bất kỳ mật khẩu/khóa nào. Repo đang public.
