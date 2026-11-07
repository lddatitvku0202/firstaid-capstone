# Supabase cho FirstAid

Trạng thái: test RLS đã chạy trên Supabase, **13/13 PASS** (ghi nhận 2026-11-08, file `docs/evidence/rls/rls-test-20261107-001222.csv`, mã bằng chứng E-015). Giới hạn: chưa có ảnh SQL Editor, chưa có ca `sync_events`, app Flutter chưa thử với Supabase thật. Xem `docs/evidence/rls/README.md`.

## Áp migration (do người dùng tự chạy, nên dùng project thử trước)
1. Supabase Dashboard → SQL Editor → dán `supabase/migrations/0001_init.sql` → Run.
2. Chạy `supabase/tests/rls_test.sql` (không để lại dữ liệu). Kết quả là bảng `test_name, result, detail`; xuất CSV hoặc chụp màn hình, lưu vào `docs/evidence/rls/rls-test-<yyyymmdd-hhmmss>.csv` (hoặc .png).
3. Ghi dữ liệu `protocols_remote` bằng dashboard hoặc service role (client không ghi được). Chỉ đưa lên nội dung đã có nguồn; bản `reviewed` + `verified` mới được app nhận.

## Cấu hình app (không commit key)
Tạo `app/.env` (đã gitignore), mẫu ở `app/.env.example`:
```
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=<anon/publishable key>
```
Chạy: `flutter run --dart-define-from-file=.env` (trong thư mục `app/`, PowerShell, đường dẫn có dấu cách phải để trong nháy). Thiếu key → app tắt đồng bộ và vẫn dùng dữ liệu local.

Chỉ dùng anon/publishable key trong app. KHÔNG đưa service_role key vào app hay repo.

## Đăng nhập
Tùy chọn. App chưa có màn đăng nhập (chưa triển khai); SOS không phụ thuộc đăng nhập. Ghi `sos_logs` cần phiên authenticated + consent.
