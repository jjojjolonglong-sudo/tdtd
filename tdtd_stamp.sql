-- tdtd: 원고 파일마다 "마지막으로 저장한 판" 기록 (2026-11-20)
-- 원고 내용은 저장하지 않아요. 파일 이름·내용 지문(해시)·저장 시각·기기·글자수만.
-- 다른 기기에서 연 파일이 이 지문과 다르면 '최신본이 아니에요'로 막아요.
create table if not exists public.tdtd_stamp (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  file text not null,                 -- 파일 이름(.md 빼고)
  hash text not null,                 -- 저장한 내용의 SHA-256
  saved_at timestamptz not null default now(),
  device text,                        -- 'PC' / '휴대폰'
  chars int,
  primary key (user_id, file)
);
alter table public.tdtd_stamp enable row level security;
drop policy if exists tdtd_stamp_own on public.tdtd_stamp;
create policy tdtd_stamp_own on public.tdtd_stamp for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
