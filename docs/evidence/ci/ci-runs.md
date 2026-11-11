# Kết quả chạy GitHub Actions (CI và release đã ký)

Trạng thái tổng: workflow **ci** đã chạy thành công 1 lần trên GitHub (run #1, theo ảnh người dùng cung cấp). Workflow **release**: **CHƯA CHẠY** (chưa có GitHub Secrets, chưa có keystore thật).
Người dùng làm theo [release-signing-guide.md](release-signing-guide.md), rồi điền bảng. Không điền khi chưa có run thật.

## Môi trường CI và máy phát triển
| Thành phần | Máy phát triển (Windows) | CI (ubuntu-latest) | Ghi chú |
|---|---|---|---|
| Flutter | 3.47.6 stable (flutter doctor, docs/evidence/ci/flutter-doctor-initial.txt) | 3.47.6 stable (`subosito/flutter-action@v2`, `flutter-version: 3.47.6`) | Khớp theo cấu hình; xác nhận bằng bước "In phiên bản công cụ" trong log run thật |
| Dart | 3.13.5 | Đi kèm Flutter 3.47.6 | |
| JDK | Temurin 21.0.13 | Temurin 21 (`actions/setup-java@v4`), bản vá cụ thể do runner chọn | Có thể khác bản vá (21.0.x); ghi lại từ `java -version` trong log |
| Python (backend) | 3.10.11 | 3.10 (`actions/setup-python@v5`), bản vá do runner chọn | |
| Android SDK build-tools | 37.0.0 (D:\Android\SDK) | Bản cài sẵn trên runner (in ra ở bước "In phiên bản công cụ") | apksigner lấy bản build-tools mới nhất có trên runner |
| Ruby / Fastlane | Không cài (không cần trên Windows) | Ruby 3.3 (`ruby/setup-ruby@v1`), fastlane `~> 2.225` | Chưa có Gemfile.lock; phiên bản fastlane thật in ở bước "Cài Fastlane" |
| Hệ điều hành | Windows 10 | Ubuntu (ubuntu-latest) | Khác OS. Kiểm tra cục bộ chạy trên Windows; kết quả trên Ubuntu (vd `dart format` với file LF) chỉ biết khi có run thật |

## Lần chạy
| Workflow | Run ID / link | Ngày | Commit / tag | Kết quả | Log |
|---|---|---|---|---|---|
| ci | #1, run 43039650591: https://github.com/lddatitvku0202/firstaid-capstone/actions/runs/43039650591 | 2026-11-11 | commit 40f917a (push lên main) | Success, tổng 2m 14s; job Flutter (format, analyze, test) 2m 10s, job Backend (pytest) 26s; 2 cảnh báo "Node.js 20 is deprecated" (actions/checkout@v4, actions/setup-python@v5 bị chạy trên Node.js 24) và 2 thông báo ubuntu-latest sẽ chuyển sang Ubuntu 26 (theo ảnh người dùng cung cấp) | Ảnh: docs/evidence/ci/ci-run-1-success-20261111.png; link: docs/evidence/ci/ci-run-1-link.txt; log từng bước: chưa tải về (không xác nhận được số test hay phiên bản Flutter/JDK trên runner từ ảnh) |
| release | CHƯA CHẠY | | | | |

## Xác minh chữ ký artifact release
| File | apksigner / jarsigner | DN chứng chỉ | SHA-256 chứng chỉ khớp keystore? | Log |
|---|---|---|---|---|
| APK | CHƯA CHẠY | | | |
| AAB | CHƯA CHẠY | | | |
