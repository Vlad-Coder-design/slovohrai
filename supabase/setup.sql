-- Запустіть увесь цей файл у Supabase Dashboard -> SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  ukrainian text not null,
  english text not null,
  english_pronunciation text not null,
  spanish text not null,
  spanish_pronunciation text not null,
  category text not null default 'Інше',
  image_url text,
  image_path text,
  color text not null default '#f1dfc4',
  is_favorite boolean not null default false,
  is_learned boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.cards enable row level security;

-- Data API privileges are required when "Automatically expose new tables"
-- was disabled during project creation. RLS still limits every user to own rows.
grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.cards to authenticated;

drop policy if exists "Users can read own cards" on public.cards;
create policy "Users can read own cards"
on public.cards for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can create own cards" on public.cards;
create policy "Users can create own cards"
on public.cards for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own cards" on public.cards;
create policy "Users can update own cards"
on public.cards for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete own cards" on public.cards;
create policy "Users can delete own cards"
on public.cards for delete
to authenticated
using ((select auth.uid()) = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'card-images',
  'card-images',
  true,
  5242880,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Users can upload own card images" on storage.objects;
create policy "Users can upload own card images"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'card-images'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

drop policy if exists "Users can update own card images" on storage.objects;
create policy "Users can update own card images"
on storage.objects for update
to authenticated
using (
  bucket_id = 'card-images'
  and owner_id = (select auth.uid())::text
);

drop policy if exists "Users can delete own card images" on storage.objects;
create policy "Users can delete own card images"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'card-images'
  and owner_id = (select auth.uid())::text
);
