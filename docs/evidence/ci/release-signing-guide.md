# Hướng dẫn ký release: keystore → GitHub Secrets → chạy workflow → xác minh chữ ký (PowerShell)

Trạng thái: **đã làm và chạy thật** (cập nhật 2026-11-12): keystore đã tạo, Secrets đã thêm, ci #1 và release #1 (tag v0.1.0) chạy thành công trên GitHub, đã xác minh chữ ký. Kết quả và bằng chứng: [ci-runs.md](ci-runs.md) (E-037, E-038). Tài liệu này giữ lại làm hướng dẫn lặp lại (ví dụ phát hành v0.2.0). Nội dung các bước bên dưới được viết trước khi chạy; các lệnh chưa được chạy lại trong lần cập nhật này.

Repo đang **PUBLIC**:
- Keystore (`*.jks`), mật khẩu, chuỗi base64 và `key.properties` **không bao giờ** được nằm trong repo.
- `.gitignore` đã chặn `*.jks`, `*.keystore`, `key.properties`, nhưng vẫn phải giữ keystore **ngoài** thư mục dự án.

Workflow liên quan:
- `.github/workflows/ci.yml`: chạy với mọi push/PR.
- `.github/workflows/release.yml`: chạy khi push tag `v*`, gọi Fastlane lane `release` trong `app/android/fastlane/Fastfile`.

---

## Bước 1. Tạo keystore (một lần duy nhất)

```powershell
$KeyDir = "$env:USERPROFILE\firstaid-keys"     # NGOÀI repo
New-Item -ItemType Directory -Force -Path $KeyDir | Out-Null
& "C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot\bin\keytool.exe" -genkeypair -v `
  -keystore "$KeyDir\firstaid-release.jks" -storetype PKCS12 `
  -keyalg RSA -keysize 2048 -validity 10000 -alias firstaid
```

- keytool sẽ **hỏi mật khẩu** và thông tin chủ sở hữu (họ tên, đơn vị VKU, mã quốc gia VN). Gõ trực tiếp; không đưa mật khẩu vào dòng lệnh để nó không nằm trong lịch sử PowerShell.
- Mật khẩu: tối thiểu 12 ký tự, **chỉ dùng chữ và số**. Không dùng `\`, không có khoảng trắng ở đầu hoặc cuối, vì `key.properties` là file Java properties và `\` sẽ bị hiểu là ký tự thoát.
- Keystore PKCS12 (mặc định của JDK 21) dùng **một mật khẩu chung** cho store và key. Vì vậy ở Bước 4, `KEY_PASSWORD` = `KEYSTORE_PASSWORD`.
- Kiểm tra keystore và ghi lại vân tay SHA-256. Vân tay là thông tin công khai, dùng để đối chiếu ở Bước 6:

```powershell
& "C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot\bin\keytool.exe" -list -v `
  -keystore "$KeyDir\firstaid-release.jks" -alias firstaid | Select-String "SHA256:"
```

## Bước 2. Sao lưu keystore NGOÀI repo (bắt buộc)

- Chép `firstaid-release.jks` sang ít nhất **hai** nơi: USB hoặc ổ ngoài, và trình quản lý mật khẩu hoặc kho lưu trữ riêng tư của nhóm. Lưu mật khẩu và alias trong trình quản lý mật khẩu.
- Mất keystore thì không thể phát hành bản cập nhật cùng chữ ký. Người dùng sẽ phải gỡ app cũ; nếu lên Play Store thì phải làm thủ tục reset upload key.
- Không gửi keystore hay mật khẩu qua chat nhóm hay email không mã hóa.

```powershell
Copy-Item "$KeyDir\firstaid-release.jks" "E:\backup\firstaid-release.jks"   # E: = ổ USB, sửa cho đúng
```

## Bước 3. Mã hóa base64 (chỉ trong bộ nhớ, không ghi ra file)

```powershell
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$KeyDir\firstaid-release.jks"))
$b64.Length          # chỉ để chắc là không rỗng; KHÔNG in $b64 ra màn hình
Set-Clipboard -Value $b64
```

Dùng `[Convert]::ToBase64String`. **Không** dùng `certutil -encode`: lệnh này thêm dòng `-----BEGIN CERTIFICATE-----`, làm workflow giải mã sai.

## Bước 4. Thêm 4 GitHub Secrets (giao diện web)

Mở repo trên GitHub, vào **Settings → Secrets and variables → Actions → New repository secret**. Cần quyền admin repo; nếu không có thì nhờ chủ repo làm.

| Tên secret | Giá trị |
|---|---|
| `KEYSTORE_BASE64` | Dán từ clipboard (Bước 3) |
| `KEYSTORE_PASSWORD` | Mật khẩu keystore |
| `KEY_ALIAS` | `firstaid` (alias đã dùng ở Bước 1) |
| `KEY_PASSWORD` | Giống `KEYSTORE_PASSWORD` (PKCS12) |

Sau khi thêm xong, xóa clipboard và biến:

```powershell
Set-Clipboard -Value " "
Remove-Variable b64
```

Lưu ý:
- Đặt ở mục **Repository secrets**, không đặt ở Variables vì Variables hiển thị công khai.
- Workflow chạy từ PR của fork **không** đọc được secrets (mặc định của GitHub). `release.yml` chỉ chạy khi có tag hoặc chạy tay.

## Bước 5. Chạy workflow

1. Commit và push các file CI (người dùng tự commit). Commit đề xuất: `ci: github actions and fastlane signed release`.

```powershell
cd "D:\Start Github\firstaid-capstone"
git push origin main
```

2. Push xong thì workflow **ci** tự chạy. Xem ở tab **Actions** trên GitHub; cả hai job `Flutter` và `Backend` phải có dấu tích xanh.
3. Tạo tag để chạy **release**. Tag phải đúng dạng `vX.Y.Z`:

```powershell
git tag v1.0.0
git push origin v1.0.0
```

   Cũng có thể chạy tay: **Actions → release → Run workflow**, nhập `build_name`.

4. Chờ job `Android signed release (Fastlane)` xong. Ở cuối trang run, phần **Artifacts**, tải `firstaid-android-1.0.0+<N>` về. Bên trong có:
   - file `.aab` và `.apk`
   - `apksigner-verify.txt`, `aab-certs.txt`
   - `SHA256SUMS.txt`
   - Lưu ý: artifact của repo public có thể được người khác tải. Không sao, vì APK không chứa secret.
5. Lưu log làm bằng chứng:
   - Trên trang run, bấm **⚙ → Download log archive**, giải nén.
   - Chép các file `.txt` của job vào `docs\evidence\ci\release-run-<YYYYMMDD>-<run id>\`.
   - Làm tương tự với run `ci`, vào `docs\evidence\ci\ci-run-<YYYYMMDD>-<run id>\`.
   - Trước khi commit log, rà nhanh để chắc chắn không có secret lộ ra (GitHub đã thay secret bằng `***`):

```powershell
Select-String -Path "docs\evidence\ci\release-run-*\*.txt" -Pattern "storePassword|keyPassword|BEGIN" | Select-Object -First 5
```

   Kết quả phải rỗng, hoặc chỉ là dòng `***`.

## Bước 6. Xác minh chữ ký trên máy

```powershell
cd "$env:USERPROFILE\Downloads\firstaid-android-1.0.0+N"     # thư mục đã giải nén artifact
$BT  = "D:\Android\SDK\build-tools\37.0.0"
$JDK = "C:\Program Files\Eclipse Adoptium\jdk-21.0.13.9-hotspot\bin"

# APK: phải có "Verified using v2 scheme (APK Signature Scheme v2): true" và
# "Signer #1 certificate DN" là thông tin ở Bước 1, KHÔNG phải "CN=Android Debug".
& "$BT\apksigner.bat" verify --verbose --print-certs (Get-ChildItem *.apk).FullName

# AAB: phải in "jar verified."
& "$JDK\jarsigner.exe" -verify (Get-ChildItem *.aab).FullName
& "$JDK\keytool.exe" -printcert -jarfile (Get-ChildItem *.aab).FullName | Select-String "Owner|SHA256"

# Checksum khớp SHA256SUMS.txt
Get-FileHash *.apk, *.aab -Algorithm SHA256 | Format-Table Hash, Path
```

- So sánh vân tay:
  - Dòng `Signer #1 certificate SHA-256 digest` của apksigner là hex chữ thường, không có dấu `:`.
  - Vân tay `SHA256:` ở Bước 1 là hex chữ hoa, có dấu `:`.
  - Bỏ dấu `:` và đổi về chữ thường thì hai chuỗi phải giống nhau.
- Lưu output của các lệnh xác minh. PowerShell 5.1 dùng `>` sẽ ghi UTF-16, nên dùng `Out-File -Encoding utf8`:

```powershell
& "$BT\apksigner.bat" verify --verbose --print-certs (Get-ChildItem *.apk).FullName 2>&1 |
  Out-File -Encoding utf8 "D:\Start Github\firstaid-capstone\docs\evidence\ci\apksigner-verify-$(Get-Date -Format yyyyMMdd-HHmmss).log"
```

- Cài thử lên emulator hoặc điện thoại. Nếu máy đang có bản debug, phải gỡ trước vì khác chữ ký:

```powershell
adb uninstall vn.vku.firstaid.app
adb install (Get-ChildItem *.apk).FullName
```

## (Tùy chọn) Build release đã ký ngay trên máy Windows

Tạo file `D:\Start Github\firstaid-capstone\app\android\key.properties` bằng Notepad. File đã được `.gitignore` chặn. Đường dẫn dùng dấu `/`, không dùng `\`:

```
storeFile=C:/Users/<TEN_BAN>/firstaid-keys/firstaid-release.jks
storePassword=<mật khẩu>
keyAlias=firstaid
keyPassword=<mật khẩu>
```

```powershell
cd "D:\Start Github\firstaid-capstone"
git check-ignore -v app/android/key.properties     # phải in ra dòng .gitignore khớp
git status --short                                  # key.properties KHÔNG được xuất hiện
cd app
flutter build apk --release
flutter build appbundle --release
```

- Không có `key.properties` thì `flutter build ... --release` vẫn chạy được nhưng ký bằng **khóa debug**. Gradle có ghi cảnh báo, nhưng output mặc định của `flutter build` không hiện cảnh báo này (đã thử, xem `docs/evidence/ci/local-ci-flutter-20261111-195857.log`). Luôn kiểm tra bằng `apksigner verify --print-certs`: nếu thấy `CN=Android Debug` thì đó là bản ký debug.
- Fastlane lane `release` thì từ chối build khi thiếu `key.properties`, và báo lỗi nếu chứng chỉ ký là `CN=Android Debug`.

## Sau khi chạy thật (đã làm cho v0.1.0; lặp lại cho bản sau)

- Điền [ci-runs.md](ci-runs.md): run id, link run, ngày, kết quả, đường dẫn log.
- Thêm dòng vào `docs/evidence-ledger.md`.
- Trong `docs/requirements-traceability.md` (tiêu chuẩn 5) và R4 (CI/CD), thay "CHƯA CHẠY" bằng kết quả thật kèm đường dẫn.
