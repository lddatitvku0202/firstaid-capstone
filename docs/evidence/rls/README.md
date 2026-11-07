# Bằng chứng RLS

Trạng thái: **13/13 PASS** trên Supabase (E-015). Người dùng chạy `supabase/tests/rls_test.sql` và xuất kết quả; tôi chỉ ghi nhận file CSV, không tự chạy trên Supabase.

- File kết quả: `rls-test-20261107-001222.csv` (cột `test_name, result, detail`; 13 dòng, tất cả `PASS`).
- Lưu ý ngày: tên file ghi 20261107 nhưng thời điểm sửa file trên máy là 2026-11-08 00:12 (+07). Sổ bằng chứng ghi ngày theo thời điểm file thật.

## Các ca đã PASS
| Vai trò | Ca |
|---|---|
| anon | đọc `protocols_remote` thấy dữ liệu; không ghi `protocols_remote`; không đọc và không insert `sos_logs` (đều `permission denied`) |
| người A | insert `sos_logs` của mình; không insert thay B và không insert khi `consent = false` (RLS từ chối); đọc được log của mình; không update, không xóa `sos_logs`; không sửa `protocols_remote` (`permission denied`) |
| người B | không thấy log của A (0 dòng); đọc được `protocols_remote` |

## Giới hạn của bằng chứng
- Chỉ phủ 13 ca trong script. Chưa có ca cho `sync_events`.
- Chưa có ảnh chụp màn hình hay log phiên SQL Editor kèm theo; chỉ có file CSV.
- Đây là kiểm tra chính sách trên database, chưa phải kiểm tra từ app Flutter với Supabase thật (`SupabaseRemoteSyncSource` chưa chạy với server).
- Script chạy trong khối con bị rollback (không để lại dữ liệu), xem đầu `supabase/tests/rls_test.sql`.
