# firstaid-capstone
FirstAid - Offline-First Emergency First Aid Assistant &amp; Community Support App

[![ci](https://github.com/lddatitvku0202/firstaid-capstone/actions/workflows/ci.yml/badge.svg)](https://github.com/lddatitvku0202/firstaid-capstone/actions/workflows/ci.yml)

> Nội dung sơ cứu trong app **chưa được chuyên gia lâm sàng thẩm định**. Trường hợp nguy hiểm: gọi 115.

## Kiến trúc
Clean Architecture 3 lớp (`app/lib/`): **domain** (Dart thuần, không import Flutter/Drift/Supabase), **data** (Drift/SQLite, Supabase, HTTP, service nền tảng), **presentation** (Riverpod, go_router, Material 3 Sáng/Tối). Luồng sơ cứu cốt lõi chạy offline từ SQLite; Supabase và backend AI (FastAPI + Gemini) là lớp tùy chọn, lỗi hoặc không có mạng thì app dùng sàng lọc cục bộ. Chi tiết: [R2](docs/reports/R2_Architecture.md), [R4 chương 3](docs/reports/R4_Final_Report.md).

## Trạng thái (2026-11-12)
- Đã chạy trên **emulator** Android 13; **chưa** chạy trên điện thoại thật (chưa có video demo, chưa có số FPS).
- Release `v0.1.0` (ký bằng keystore của nhóm qua GitHub Actions) là bản **offline-only**: chưa có AI/Supabase vì chưa truyền cấu hình lúc build (R-33). Backend AI chưa deploy.
- Nội dung sơ cứu chưa được chuyên gia lâm sàng thẩm định.
- Bằng chứng: [docs/evidence-ledger.md](docs/evidence-ledger.md); danh sách việc còn thiếu trước khi nộp: [docs/submission-checklist.md](docs/submission-checklist.md).

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
