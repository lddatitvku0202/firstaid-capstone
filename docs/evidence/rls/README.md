# Bằng chứng RLS

Trạng thái: **CHƯA có bằng chứng** (script đã viết, chưa chạy trên Supabase).

Cách làm: áp `supabase/migrations/0001_init.sql` lên project thử, rồi chạy `supabase/tests/rls_test.sql` trong SQL Editor (không để lại dữ liệu: khối con bị rollback). Kết quả là một bảng `test_name, result, detail` (PASS/FAIL). Xuất bảng ra CSV hoặc chụp màn hình rồi lưu thành `rls-test-<yyyymmdd-hhmmss>.txt` trong thư mục này. [CHỜ NGƯỜI DÙNG CHẠY]

Script (đã đổi từ RAISE NOTICE sang bảng kết quả, chưa chạy lần nào, chưa kiểm tra cú pháp vì máy không có PostgreSQL) dùng `set local role` + `request.jwt.claims` để mô phỏng anon, người A, người B. Giả định: SQL Editor chạy bằng role `postgres`; việc chèn user giả vào `auth.users` có thể cần chỉnh nếu project thêm cột bắt buộc, nếu lỗi hãy ghi lại nguyên văn lỗi. Chưa chạy nên chưa xác nhận script chạy đúng.
