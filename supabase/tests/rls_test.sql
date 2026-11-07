-- Kiểm tra RLS cho 3 vai trò: anon, người A, người B.
-- CHẠY TRÊN PROJECT THỬ (không phải dữ liệu thật) trong SQL Editor, sau khi áp 0001_init.sql.
--
-- Kết quả là MỘT bảng (test_name, result, detail), result = PASS | FAIL, hiển thị được
-- trong SQL Editor của Supabase (SQL Editor chỉ hiện kết quả câu lệnh cuối).
--
-- Về ROLLBACK: mọi thay đổi (user giả, dữ liệu mẫu, log thử) nằm trong một khối con
-- (subtransaction) của hàm và bị ROLLBACK ở cuối bằng cách ném lỗi có chủ đích
-- (SQLSTATE P0001, '__rls_rollback__'), nên không để lại dữ liệu. Làm vậy thay cho
-- BEGIN ... ROLLBACK ở cấp script, vì ROLLBACK là câu lệnh cuối sẽ không trả bảng nào.
-- Kết quả được giữ trong biến cục bộ của hàm (biến plpgsql không bị rollback).
--
-- Giả định: SQL Editor chạy bằng role postgres (được phép SET ROLE).
-- CHƯA chạy trên Supabase thật; xem docs/evidence/rls/README.md.

create or replace function pg_temp.rls_run()
returns table (test_name text, result text, detail text)
language plpgsql
as $fn$
declare
  res jsonb := '[]'::jsonb;
  n   int;
begin
  begin  -- khối con: sẽ bị rollback hoàn toàn ở cuối

    -- ---------- Chuẩn bị (role postgres) ----------
    insert into auth.users (id, instance_id, aud, role, email)
    values
      ('aaaaaaaa-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls_a@example.test'),
      ('bbbbbbbb-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rls_b@example.test');

    insert into public.protocols_remote
      (code, title, topic_id, severity, target_audience, age_group, version, updated_at,
       source_verification, clinical_review, reuse_permission)
    values
      ('rls_test_proto', 'RLS test', 't', 's', 'a', 'all', '9.9.9', '2026-11-07',
       'unverified', 'not_clinically_reviewed', 'unknown');

    -- ---------- ANON ----------
    set local role anon;
    perform set_config('request.jwt.claims', '{"role":"anon"}', true);

    select count(*) into n from public.protocols_remote where code = 'rls_test_proto';
    res := res || jsonb_build_object('t', 'anon đọc protocols_remote thấy dữ liệu',
      'ok', n = 1, 'd', 'số dòng thấy = ' || n || ' (kỳ vọng 1)');

    begin
      insert into public.protocols_remote
        (code, title, topic_id, severity, target_audience, age_group, version, updated_at,
         source_verification, clinical_review, reuse_permission)
      values ('anon_x', 'x', 't', 's', 'a', 'all', '1', 'd', 'verified', 'reviewed', 'permitted');
      res := res || jsonb_build_object('t', 'anon KHÔNG ghi được protocols_remote',
        'ok', false, 'd', 'insert thành công (kỳ vọng bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'anon KHÔNG ghi được protocols_remote',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      select count(*) into n from public.sos_logs;
      res := res || jsonb_build_object('t', 'anon KHÔNG đọc được sos_logs',
        'ok', false, 'd', 'đọc được, thấy ' || n || ' dòng (kỳ vọng bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'anon KHÔNG đọc được sos_logs',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      insert into public.sos_logs (id, owner_id, device_id, consent)
      values (gen_random_uuid(), 'aaaaaaaa-0000-0000-0000-000000000001', 'dev', true);
      res := res || jsonb_build_object('t', 'anon KHÔNG insert được sos_logs',
        'ok', false, 'd', 'insert thành công (kỳ vọng bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'anon KHÔNG insert được sos_logs',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    reset role;

    -- ---------- NGƯỜI A ----------
    set local role authenticated;
    perform set_config('request.jwt.claims',
      '{"role":"authenticated","sub":"aaaaaaaa-0000-0000-0000-000000000001"}', true);

    begin
      insert into public.sos_logs (id, device_id, consent, lat, lon)
      values ('11111111-1111-1111-1111-111111111111', 'dev-a', true, 16.05, 108.20);
      res := res || jsonb_build_object('t', 'A insert sos_logs của chính mình (owner mặc định = auth.uid())',
        'ok', true, 'd', 'insert thành công');
    exception when others then
      res := res || jsonb_build_object('t', 'A insert sos_logs của chính mình (owner mặc định = auth.uid())',
        'ok', false, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      insert into public.sos_logs (id, owner_id, device_id, consent)
      values (gen_random_uuid(), 'bbbbbbbb-0000-0000-0000-000000000002', 'dev-a', true);
      res := res || jsonb_build_object('t', 'A KHÔNG insert thay B',
        'ok', false, 'd', 'insert thành công (kỳ vọng bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'A KHÔNG insert thay B',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      insert into public.sos_logs (id, device_id, consent)
      values (gen_random_uuid(), 'dev-a', false);
      res := res || jsonb_build_object('t', 'A KHÔNG insert khi consent = false',
        'ok', false, 'd', 'insert thành công (kỳ vọng bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'A KHÔNG insert khi consent = false',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    select count(*) into n from public.sos_logs;
    res := res || jsonb_build_object('t', 'A đọc được log của mình (1 dòng)',
      'ok', n = 1, 'd', 'số dòng thấy = ' || n || ' (kỳ vọng 1)');

    begin
      update public.sos_logs set device_id = 'hack'
        where id = '11111111-1111-1111-1111-111111111111';
      get diagnostics n = row_count;
      res := res || jsonb_build_object('t', 'A KHÔNG update được log',
        'ok', n = 0, 'd', 'số dòng bị sửa = ' || n || ' (kỳ vọng 0 hoặc bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'A KHÔNG update được log',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      delete from public.sos_logs where id = '11111111-1111-1111-1111-111111111111';
      get diagnostics n = row_count;
      res := res || jsonb_build_object('t', 'A KHÔNG xóa được log',
        'ok', n = 0, 'd', 'số dòng bị xóa = ' || n || ' (kỳ vọng 0 hoặc bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'A KHÔNG xóa được log',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    begin
      update public.protocols_remote set title = 'hack' where code = 'rls_test_proto';
      get diagnostics n = row_count;
      res := res || jsonb_build_object('t', 'A KHÔNG sửa được protocols_remote',
        'ok', n = 0, 'd', 'số dòng bị sửa = ' || n || ' (kỳ vọng 0 hoặc bị từ chối)');
    exception when others then
      res := res || jsonb_build_object('t', 'A KHÔNG sửa được protocols_remote',
        'ok', true, 'd', 'bị từ chối: ' || sqlerrm);
    end;

    reset role;

    -- ---------- NGƯỜI B ----------
    set local role authenticated;
    perform set_config('request.jwt.claims',
      '{"role":"authenticated","sub":"bbbbbbbb-0000-0000-0000-000000000002"}', true);

    select count(*) into n from public.sos_logs;
    res := res || jsonb_build_object('t', 'B KHÔNG thấy log của A (0 dòng)',
      'ok', n = 0, 'd', 'số dòng thấy = ' || n || ' (kỳ vọng 0)');

    select count(*) into n from public.protocols_remote where code = 'rls_test_proto';
    res := res || jsonb_build_object('t', 'B đọc được protocols_remote',
      'ok', n = 1, 'd', 'số dòng thấy = ' || n || ' (kỳ vọng 1)');

    reset role;

    -- ---------- ROLLBACK: hủy toàn bộ thay đổi của khối con ----------
    raise exception using errcode = 'P0001', message = '__rls_rollback__';

  exception when sqlstate 'P0001' then
    if sqlerrm <> '__rls_rollback__' then
      -- lỗi P0001 khác (ngoài ý muốn) trong phần chuẩn bị: báo cáo thay vì giấu
      res := res || jsonb_build_object('t', 'LỖI KHI CHẠY SCRIPT',
        'ok', false, 'd', sqlerrm);
    end if;
  when others then
    -- lỗi khác ngoài các test con (vd. chèn auth.users thất bại): báo cáo nguyên văn
    res := res || jsonb_build_object('t', 'LỖI KHI CHẠY SCRIPT',
      'ok', false, 'd', sqlstate || ': ' || sqlerrm);
  end;

  return query
    select e.value ->> 't',
           case when (e.value ->> 'ok')::boolean then 'PASS' else 'FAIL' end,
           e.value ->> 'd'
    from jsonb_array_elements(res) with ordinality as e(value, ord)
    order by e.ord;
end
$fn$;

-- Câu lệnh cuối: trả bảng (test_name, result, detail).
select * from pg_temp.rls_run();
