# PROMPT 05 — Supabase tối thiểu + RLS + sync queue

Đọc CLAUDE.md. Dùng Plan mode.

Nếu chưa có Supabase project: hướng dẫn người dùng tạo và hỏi URL/anon key. KHÔNG hardcode; dùng --dart-define hoặc file .env (đã gitignore) kèm .env.example.

## Việc cần làm
1. supabase/migrations/*.sql: bảng protocols_remote (version, nội dung, source/citation, các trường trạng thái theo enum), sos_logs (chỉ lưu khi người dùng đồng ý; device_id ẩn danh; không lưu dữ liệu nhạy cảm nếu không cần), sync_events (id idempotent). Bật RLS mọi bảng.
2. RLS: protocols_remote ai cũng đọc, không ghi từ client; sos_logs chỉ insert theo chủ sở hữu, đọc chỉ của chính mình. Auth tùy chọn, không chặn SOS.
3. Kiểm tra RLS với tối thiểu 2 vai trò (anon, authenticated người A, người B); lưu kết quả thật vào docs/evidence/rls/. Chưa chạy được thì ghi rõ chưa có bằng chứng.
4. Flutter: supabase_flutter (flutter pub add), Supabase datasource ở lớp data; SyncQueue lưu bằng Drift, retry giới hạn + backoff, ID idempotent; chính sách xung đột: phác đồ = server version thắng, chỉ nhận bản đã review; log SOS = append-only. Domain chỉ biết interface.
5. Đồng bộ version phác đồ: có mạng và version mới thì cập nhật Drift; sync lỗi giữ bản local ổn định; mất mạng vẫn dùng bản local. Bản chưa review không được ghi đè bản ổn định trên máy.
6. Test: unit test SyncQueue (retry, idempotency, offline->online) bằng fake remote. Lưu log.
7. Cập nhật R2 (ERD Mermaid thật từ migration, bảng RLS policy), R3 (offline sync + conflict policy), decision-log, evidence-ledger. Ghi rõ phần đã kiểm chứng và chưa.

## Điều kiện dừng
Không tự chạy migration lên Supabase thật khi chưa hỏi. Không tự commit. Commit đề xuất: "feat: supabase schema, rls and offline sync queue".
