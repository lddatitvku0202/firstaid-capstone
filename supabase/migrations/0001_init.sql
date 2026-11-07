-- FirstAid: schema tối thiểu + RLS (Prompt 05).
-- CHƯA chạy lên Supabase thật. Xem supabase/README.md.
-- Enum trạng thái nguồn thống nhất theo CLAUDE.md §6.

-- ============ protocols_remote ============
create table public.protocols_remote (
  code                 text primary key,
  title                text not null,
  topic_id             text not null,
  severity             text not null,
  target_audience      text not null,
  age_group            text not null,
  version              text not null,
  updated_at           text not null,
  steps                jsonb not null default '[]'::jsonb,   -- [{order,text,citation}]
  do_not               jsonb not null default '[]'::jsonb,   -- [{text,citation}]
  call_115_conditions  jsonb not null default '[]'::jsonb,   -- [{text,citation}]
  citations            jsonb not null default '[]'::jsonb,   -- [{source_id,pages}]
  notes                text,
  source_verification  text not null
    check (source_verification in ('verified', 'unverified')),
  clinical_review      text not null
    check (clinical_review in ('reviewed', 'not_clinically_reviewed')),
  reuse_permission     text not null
    check (reuse_permission in ('permitted', 'permission_pending', 'unknown'))
);

alter table public.protocols_remote enable row level security;

-- Ai cũng đọc được (anon + authenticated). Không có policy ghi: client không ghi được.
-- Ghi dữ liệu chỉ qua dashboard / service_role (bỏ qua RLS).
create policy protocols_remote_read_all
  on public.protocols_remote for select
  to anon, authenticated
  using (true);

-- ============ sos_logs (append-only, chỉ khi người dùng đồng ý) ============
create table public.sos_logs (
  id          uuid primary key,                       -- do client sinh => idempotent
  owner_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  device_id   text not null,                          -- id ẩn danh ngẫu nhiên, không phải IMEI/số điện thoại
  consent     boolean not null check (consent = true),
  lat         double precision,                       -- client làm tròn; có thể null
  lon         double precision,
  created_at  timestamptz not null default now(),
  check (lat is null or lat between -90 and 90),
  check (lon is null or lon between -180 and 180)
);
-- Không lưu ghi chú tự do và không lưu số liên hệ.

alter table public.sos_logs enable row level security;

create policy sos_logs_insert_own
  on public.sos_logs for insert
  to authenticated
  with check (owner_id = auth.uid() and consent = true);

create policy sos_logs_select_own
  on public.sos_logs for select
  to authenticated
  using (owner_id = auth.uid());
-- Không có policy UPDATE/DELETE => append-only với client.

-- ============ sync_events (idempotent, insert-only) ============
create table public.sync_events (
  id          uuid primary key,                       -- client sinh => idempotent
  owner_id    uuid not null default auth.uid() references auth.users (id) on delete cascade,
  device_id   text not null,
  kind        text not null check (kind in ('sos_log')),
  created_at  timestamptz not null default now()
);

alter table public.sync_events enable row level security;

create policy sync_events_insert_own
  on public.sync_events for insert
  to authenticated
  with check (owner_id = auth.uid());

create policy sync_events_select_own
  on public.sync_events for select
  to authenticated
  using (owner_id = auth.uid());

-- Siết quyền bảng mức GRANT (phòng thủ lớp hai).
revoke all on public.protocols_remote, public.sos_logs, public.sync_events from anon, authenticated;
grant select on public.protocols_remote to anon, authenticated;
grant select, insert on public.sos_logs, public.sync_events to authenticated;
