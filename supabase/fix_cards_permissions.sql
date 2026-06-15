-- Run this once in Supabase Dashboard -> SQL Editor.
-- It gives signed-in users access to the cards table.
-- Existing RLS policies still ensure they can access only their own cards.

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.cards to authenticated;

alter table public.cards enable row level security;

drop policy if exists "Users can read own cards" on public.cards;
create policy "Users can read own cards"
on public.cards for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Users can create own cards" on public.cards;
create policy "Users can create own cards"
on public.cards for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update own cards" on public.cards;
create policy "Users can update own cards"
on public.cards for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete own cards" on public.cards;
create policy "Users can delete own cards"
on public.cards for delete
to authenticated
using (auth.uid() = user_id);
