# Kết quả chạy GitHub Actions (CI và release đã ký)

Trạng thái tổng: workflow **ci** đã chạy thành công 1 lần trên GitHub (run #1, theo ảnh người dùng cung cấp). Workflow **release** đã chạy thành công 1 lần với tag v0.1.0 (run #1, 2026-11-12): Fastfile chạy thật trên GitHub lần đầu, APK/AAB được ký bằng keystore thật của nhóm. Đây là bản **offline-only** (R-33): không có AI/Supabase vì workflow không truyền `--dart-define`.
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

## Thay đổi cấu hình release (2026-11-12, chưa chạy)
- `release.yml` đọc GitHub **Variable** `AI_BASE_URL` (Settings → Secrets and variables → Actions → Variables), không phải Secret. Bước "Kiểm tra cấu hình AI" chạy ngay sau bước xác định phiên bản: thiếu hoặc không phải `https://` thì dừng; không in giá trị; `::add-mask::` rồi ghi `AI_BASE_URL` và `AI_TIMEOUT_SECONDS=45` vào `$GITHUB_ENV`.
- Fastfile kiểm tra lại hai biến, ghi file JSON tạm và gọi `flutter build appbundle/apk --release --dart-define-from-file=<file tạm>`, xóa file sau khi build. Dòng lệnh fastlane in ra chỉ có đường dẫn file, không có URL.
- Không có `GEMINI_API_KEY` trong app hay workflow (chỉ ở backend). Không truyền `AI_API_KEY`, Supabase (bỏ lần này).
- Kiểm tra cục bộ: cú pháp YAML hợp lệ (`docs/evidence/ci/release-ai-config-yaml-check-20261112-113024.log`). Fastfile chưa chạy được trên máy (không có Ruby).
- Trạng thái: **CHƯA CHẠY** trên GitHub. Release #1 (v0.1.0) bên dưới vẫn là bản offline-only. Cần thêm Variable `AI_BASE_URL` trước khi push tag mới (ví dụ `v0.2.0`), nếu thiếu workflow sẽ dừng ở bước kiểm tra.

## Backend AI đã deploy (Render, 2026-11-12)
- URL: https://firstaid-capstone.onrender.com (giá trị dự kiến cho GitHub Variable `AI_BASE_URL`; chưa có run release nào dùng nó).
- Theo người dùng: Docker, gói Free, vùng Singapore; `GEMINI_API_KEY` chỉ đặt trong biến môi trường của Render; endpoint không bật xác thực.
- Bằng chứng: `docs/evidence/ai/render-deploy-check-20261112-111702.txt` (healthz ok; một lần gọi route trả `burns_thermal_chemical`) và `docs/evidence/ai/render-service-live-20261112.png` (log Render: service live, `GET /healthz` 200). Một lần gọi thủ công, không phải số đo. E-042.
- Lưu ý cho release: gói Free ngủ khi không dùng nên lần gọi đầu từ app có thể chậm hơn deadline `AI_TIMEOUT_SECONDS=45` (chưa đo); khi đó app fallback sang sàng lọc offline.

## Lần chạy
| Workflow | Run ID / link | Ngày | Commit / tag | Kết quả | Log |
|---|---|---|---|---|---|
| ci | #1, run 43039650591: https://github.com/lddatitvku0202/firstaid-capstone/actions/runs/43039650591 | 2026-11-11 | commit 40f917a (push lên main) | Success, tổng 2m 14s; job Flutter (format, analyze, test) 2m 10s, job Backend (pytest) 26s; 2 cảnh báo "Node.js 20 is deprecated" (actions/checkout@v4, actions/setup-python@v5 bị chạy trên Node.js 24) và 2 thông báo ubuntu-latest sẽ chuyển sang Ubuntu 26 (theo ảnh người dùng cung cấp) | Ảnh: docs/evidence/ci/ci-run-1-success-20261111.png; link: docs/evidence/ci/ci-run-1-link.txt; log từng bước: chưa tải về (không xác nhận được số test hay phiên bản Flutter/JDK trên runner từ ảnh) |
| release | #1, run 43144492260: https://github.com/lddatitvku0202/firstaid-capstone/actions/runs/43144492260 | 2026-11-12 (ảnh ghi "triggered via push 9 minutes ago"; giờ chính xác không có trong ảnh) | tag v0.1.0, commit c0fcdec | Success, tổng 7m 55s; 1 job "Android signed release (Fastlane)" 7m 53s; 1 artifact; ảnh ghi "2 warnings and 1 notice" nhưng nội dung các cảnh báo không hiện trong ảnh | Ảnh: docs/evidence/ci/release-run-1-success-20261111.png (tên file ghi ngày 20261111, nội dung ảnh không có ngày); link: docs/evidence/ci/release-run-1-success-link.txt; file kết quả: docs/evidence/ci/release-run-v0.1.0-20261112/; log từng bước của workflow: chưa tải về |

Ghi chú tên file: `release-run-1-success-20261111.png` chứa ảnh của release run #1 chạy ngày **2026-11-12**; phần "20261111" trong tên file là ngày đặt tên, không phải ngày chạy (mtime file 2026-11-12 10:16). Không đổi tên để các tham chiếu trong ledger/báo cáo không bị gãy. Tương tự `ci-run-1-success-20261111.png` là của workflow ci (ngày 2026-11-11, khớp).

## Xác minh chữ ký artifact release
| File | apksigner / jarsigner | DN chứng chỉ | SHA-256 chứng chỉ khớp keystore? | Log |
|---|---|---|---|---|
| APK | apksigner (`docs/evidence/ci/release-run-v0.1.0-20261112/apksigner-verify.txt` từ artifact, `apksigner-verify-local.txt` chạy lại trên máy): "Verifies"; v2 scheme: **true**; v1/v3/v3.1/v3.2/v4: false; 1 signer | CN=FirstAid Team, OU=Khoa Khoa hoc May tinh, O=VKU, L=Da Nang, ST=Da Nang, C=VN; RSA 2048 | SHA-256 chứng chỉ (apksigner): `958b380653a70f42c50609ae1a844a6551096ec170b654bc1ff66f0d9869b3a8`. Khớp với vân tay SHA256 của AAB trong `aab-certs.txt` và `aab-printcert-local.txt` (cùng giá trị, khác cách viết hoa/dấu `:`). Đối chiếu với keystore gốc trên máy tác giả: chưa có file nào ghi lại | `docs/evidence/ci/release-run-v0.1.0-20261112/apksigner-verify.txt`, `docs/evidence/ci/release-run-v0.1.0-20261112/apksigner-verify-local.txt` |
| AAB | jarsigner (`docs/evidence/ci/release-run-v0.1.0-20261112/jarsigner-verify-summary.txt`, bản rút gọn): "jar verified." kèm cảnh báo (xem ghi chú); keytool `-printcert -jarfile` (`aab-certs.txt` từ artifact, `aab-printcert-local.txt` chạy lại trên máy): 1 signer | Cùng DN với APK; serial 4b717c7baac2ac0a; SHA384withRSA, RSA 2048 | SHA-256 chứng chỉ: `95:8B:38:06:53:A7:0F:42:C5:06:09:AE:1A:84:4A:65:51:09:6E:C1:70:B6:54:BC:1F:F6:6F:0D:98:69:B3:A8` (= giá trị của APK). Hiệu lực từ 2026-11-12 02:36:03 UTC đến 2054-03-30 | `docs/evidence/ci/release-run-v0.1.0-20261112/jarsigner-verify-summary.txt`, `docs/evidence/ci/release-run-v0.1.0-20261112/aab-certs.txt`, `docs/evidence/ci/release-run-v0.1.0-20261112/aab-printcert-local.txt` |

**Checksum artifact** (`docs/evidence/ci/release-run-v0.1.0-20261112/SHA256SUMS.txt`, do Fastlane lane `release` ghi trong artifact):
| File | SHA-256 |
|---|---|
| firstaid-0.1.0+1.apk | `83eed80bb05584a79203eb5c608c943c2170fe5e5ad5719d3d7165b6741c0081` |
| firstaid-0.1.0+1.aab | `fbf54243fe84d4cc9bb4b8354fd0e57898ebce259a3b1338bceb93c71fb6c220` |

Hai giá trị trên khớp với giá trị người dùng cung cấp. Repo không chứa file APK/AAB và không có log tính lại SHA-256 trên bản tải về, nên việc "file trên máy khớp SHA256SUMS.txt" là theo lời người dùng, không kiểm lại được từ repo.

**Ghi chú về chứng chỉ và cảnh báo jarsigner**
- Chứng chỉ **tự ký** (Owner = Issuer = CN=FirstAid Team...). jarsigner cảnh báo chuỗi chứng chỉ không hợp lệ (PKIX path building failed) vì không có CA tin cậy; việc này đúng với chứng chỉ tự ký và không ảnh hưởng việc cài APK ngoài Play Store.
- Chữ ký **không có timestamp** (jarsigner nêu chứng chỉ hết hạn từ 2054-03-30).
- `jarsigner-verify-summary.txt` là bản **đã rút gọn**: giữ dòng "jar verified.", các cảnh báo và hai ví dụ trong mục "internal inconsistencies" (Manifest không đọc được qua JarInputStream; một entry `BUNDLE-METADATA/.../libapp.so.sym` được ký trong JarFile nhưng không trong JarInputStream). Đầu ra đầy đủ không được lưu.
- Cảnh báo POSIX permission/symlink trong jar được ghi trong file và bị bỏ qua khi ký.

## Cài APK ký từ workflow lên emulator
Theo `docs/evidence/ci/release-run-v0.1.0-20261112/installed-package-info.txt` (mtime 2026-11-12 10:32) và lời người dùng:
| Mục | Giá trị |
|---|---|
| Thiết bị | emulator `vku_test_api33` (không phải điện thoại thật) |
| Ngày | 2026-11-12 |
| APK | artifact của release run #1 (tag v0.1.0) |
| `adb install` | báo "Success" (theo người dùng; không có file log lưu lệnh này) |
| `dumpsys package` (file `installed-package-info.txt`) | versionName=0.1.0, versionCode=1, minSdk=24, targetSdk=36 (file không ghi tên package) |

Ba ảnh chụp trên emulator (`docs/evidence/screenshots/`; chỉ ghi những gì thấy):
| Ảnh | Nội dung thấy được |
|---|---|
| `release-v0.1.0-home-emulator.png` | Màn Home giao diện Sáng, đồng hồ 10:30, không có băng "DEBUG": chip "Có kết nối mạng", thẻ "Cẩm nang sơ cứu", "Hồi sinh tim phổi (CPR)", "Mô tả tình huống" (phụ đề "Cần mạng; AI chỉ gợi ý phác đồ có sẵn..."), dòng "Nội dung sơ cứu chưa được chuyên gia lâm sàng thẩm định.", nút "KHẨN CẤP" |
| `release-v0.1.0-handbook-emulator.png` | Màn "Cẩm nang sơ cứu": ô tìm kiếm, banner cảnh báo chưa thẩm định lâm sàng, danh sách phác đồ (Chảy máu nặng bên ngoài, Bỏng nhiệt và bỏng hóa chất, Hóc dị vật đường thở người lớn và trẻ em, Hóc dị vật đường thở em bé dưới 1 tuổi), mỗi mục "Phiên bản 1.0.0" |
| `release-v0.1.0-ai-not-configured-emulator.png` | Màn "Mô tả tình huống": thẻ "Ứng dụng chưa được cấu hình máy chủ AI." kèm dòng "Chuyển sang sàng lọc bằng câu hỏi Có/Không (chạy không cần mạng)..." (phần dưới thẻ, gồm nút sàng lọc offline nếu có, bị thanh dưới che nên KHÔNG thấy nút trong ảnh), nút "Bỏ qua AI, sàng lọc ngay" và "Gọi 115 ngay". Không thấy hộp thoại đồng ý và không thấy dòng thông báo quyền riêng tư |

Các ảnh không chứng minh bản cài là bản của workflow (không có thông tin chữ ký/phiên bản trong ảnh); điều đó dựa vào `installed-package-info.txt` và lời người dùng. Không có ảnh nào chạy luồng AI hay Supabase (bản này không có cấu hình, R-33).
