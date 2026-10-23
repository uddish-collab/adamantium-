-- Consolidated page access policies. Uses the table and policy names from the supplied audit.
BEGIN;
-- Policies are permissive by default, so obsolete overlapping rules are dropped first.
grant usage on schema public to anon, authenticated;
-- Remove every old policy from the website-managed tables. Supabase combines
-- permissive policies with OR, so leaving one stale policy can bypass the
-- intended rule. The table definitions and data are not touched here.
do $$
declare p record;
begin
  for p in
    select schemaname, tablename, policyname
    from pg_policies
    where schemaname = 'public'
      and tablename = any (array[
        'vehicles','guides','aircraft','aviation_aircraft','naval_vessels',
        'tank_rooms','tank_room_requests','tank_room_scores',
        'aviation_rooms','aviation_room_requests','aviation_room_scores',
        'naval_rooms','naval_room_requests','naval_room_scores'
      ])
  loop
    execute format('drop policy %I on %I.%I', p.policyname, p.schemaname, p.tablename);
  end loop;
end $$;

-- The named drops below document the previous policy names and are harmless
-- after the cleanup above; they also keep the script readable as a migration.
drop policy if exists vehicles_public_read on public.vehicles;
drop policy if exists aircraft_public_read on public.aircraft;
drop policy if exists aviation_aircraft_public_read on public.aviation_aircraft;
drop policy if exists naval_vessels_public_read on public.naval_vessels;
drop policy if exists guides_public_read on public.guides;
drop policy if exists tank_rooms_read_signed_in on public.tank_rooms;
drop policy if exists tank_rooms_read_public_active on public.tank_rooms;
drop policy if exists tank_rooms_create_own on public.tank_rooms;
drop policy if exists tank_rooms_update_own on public.tank_rooms;
drop policy if exists tank_rooms_delete_own on public.tank_rooms;
drop policy if exists tank_requests_read_involved on public.tank_room_requests;
drop policy if exists tank_requests_create_valid on public.tank_room_requests;
drop policy if exists tank_requests_owner_respond on public.tank_room_requests;
drop policy if exists tank_scores_public_read on public.tank_room_scores;
drop policy if exists tank_scores_insert_own on public.tank_room_scores;
drop policy if exists tank_scores_update_own on public.tank_room_scores;
drop policy if exists aviation_rooms_public_read on public.aviation_rooms;
drop policy if exists aviation_rooms_create_own on public.aviation_rooms;
drop policy if exists aviation_rooms_update_own on public.aviation_rooms;
drop policy if exists aviation_rooms_delete_own on public.aviation_rooms;
drop policy if exists aviation_requests_read_involved on public.aviation_room_requests;
drop policy if exists aviation_requests_create_valid on public.aviation_room_requests;
drop policy if exists aviation_requests_owner_respond on public.aviation_room_requests;
drop policy if exists aviation_scores_public_read on public.aviation_room_scores;
drop policy if exists aviation_scores_insert_own on public.aviation_room_scores;
drop policy if exists aviation_scores_update_own on public.aviation_room_scores;
drop policy if exists naval_rooms_public_read on public.naval_rooms;
drop policy if exists naval_rooms_create_own on public.naval_rooms;
drop policy if exists naval_rooms_delete_own on public.naval_rooms;
drop policy if exists naval_requests_read_involved on public.naval_room_requests;
drop policy if exists naval_requests_create_valid on public.naval_room_requests;
drop policy if exists naval_requests_owner_respond on public.naval_room_requests;
drop policy if exists naval_scores_public_read on public.naval_room_scores;

-- Public catalog and guide reads.
 grant select on public.vehicles, public.guides, public.aircraft, public.aviation_aircraft, public.naval_vessels to anon, authenticated;
alter table public.vehicles enable row level security;
alter table public.guides enable row level security;
alter table public.aircraft enable row level security;
alter table public.aviation_aircraft enable row level security;
alter table public.naval_vessels enable row level security;
drop policy if exists "Anyone can view vehicles" on public.vehicles;
drop policy if exists "Aircraft are publicly readable" on public.aircraft;
drop policy if exists adamantium_aircraft_read on public.aircraft;
drop policy if exists aviation_aircraft_read on public.aviation_aircraft;
drop policy if exists naval_vessels_read on public.naval_vessels;
drop policy if exists "Anyone can view guides" on public.guides;
drop policy if exists adamantium_guides_public_read on public.guides;
drop policy if exists guides_read_for_pages on public.guides;
create policy vehicles_public_read on public.vehicles for select to anon, authenticated using (true);
create policy aircraft_public_read on public.aircraft for select to anon, authenticated using (true);
create policy aviation_aircraft_public_read on public.aviation_aircraft for select to anon, authenticated using (true);
create policy naval_vessels_public_read on public.naval_vessels for select to anon, authenticated using (true);
create policy guides_public_read on public.guides for select to anon, authenticated using (true);

-- Tank rooms, join requests, and scoreboards.
alter table public.tank_rooms enable row level security;
alter table public.tank_room_requests enable row level security;
alter table public.tank_room_scores enable row level security;
grant select on public.tank_rooms, public.tank_room_scores to anon, authenticated;
grant insert, update, delete on public.tank_rooms to authenticated;
grant select, insert on public.tank_room_requests to authenticated;
grant update (status) on public.tank_room_requests to authenticated;
grant insert, update on public.tank_room_scores to authenticated;
drop policy if exists "Authenticated users can view tank rooms" on public.tank_rooms;
drop policy if exists "Visitors can view active tank rooms" on public.tank_rooms;
drop policy if exists "Users can create their own tank rooms" on public.tank_rooms;
drop policy if exists "Room owners can update their rooms" on public.tank_rooms;
drop policy if exists "Room owners can delete their rooms" on public.tank_rooms;
drop policy if exists "Room owners and requesters can view requests" on public.tank_room_requests;
drop policy if exists "Users can request to join rooms" on public.tank_room_requests;
drop policy if exists "Room owners can respond to requests" on public.tank_room_requests;
drop policy if exists "Room owners and requesters can view scores" on public.tank_room_scores;
drop policy if exists "Room owners and accepted requesters can view scores" on public.tank_room_scores;
drop policy if exists "Players can create their own scores" on public.tank_room_scores;
drop policy if exists "Players can update their own scores" on public.tank_room_scores;
drop policy if exists tanks_public_scoreboard_read on public.tank_room_scores;
create policy tank_rooms_read_signed_in on public.tank_rooms for select to authenticated using (true);
create policy tank_rooms_read_public_active on public.tank_rooms for select to anon using (status in ('open','in_progress'));
create policy tank_rooms_create_own on public.tank_rooms for insert to authenticated with check (owner_id = (select auth.uid()));
create policy tank_rooms_update_own on public.tank_rooms for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy tank_rooms_delete_own on public.tank_rooms for delete to authenticated using (owner_id = (select auth.uid()));
create policy tank_requests_read_involved on public.tank_room_requests for select to authenticated using (
  requester_id = (select auth.uid()) or exists(select 1 from public.tank_rooms r where r.id = tank_room_requests.room_id and r.owner_id = (select auth.uid()))
);
create policy tank_requests_create_valid on public.tank_room_requests for insert to authenticated with check (
  requester_id = (select auth.uid()) and status = 'pending' and exists(
    select 1 from public.tank_rooms r where r.id = tank_room_requests.room_id and r.status = 'open'
      and r.owner_id <> (select auth.uid()) and r.name not ilike 'DEMO%'
  )
);
create policy tank_requests_owner_respond on public.tank_room_requests for update to authenticated
using (status = 'pending' and exists(select 1 from public.tank_rooms r where r.id = tank_room_requests.room_id and r.owner_id = (select auth.uid())))
with check (status in ('accepted','declined') and exists(select 1 from public.tank_rooms r where r.id = tank_room_requests.room_id and r.owner_id = (select auth.uid())));
create policy tank_scores_public_read on public.tank_room_scores for select to anon, authenticated using (true);
create policy tank_scores_insert_own on public.tank_room_scores for insert to authenticated with check (player_id = (select auth.uid()));
create policy tank_scores_update_own on public.tank_room_scores for update to authenticated using (player_id = (select auth.uid())) with check (player_id = (select auth.uid()));

-- Aviation rooms: remove the duplicate older request rules that bypassed the newer restrictions.
alter table public.aviation_rooms enable row level security;
alter table public.aviation_room_requests enable row level security;
alter table public.aviation_room_scores enable row level security;
grant select on public.aviation_rooms, public.aviation_room_scores to anon, authenticated;
grant insert, update, delete on public.aviation_rooms to authenticated;
grant select, insert on public.aviation_room_requests to authenticated;
grant update (status) on public.aviation_room_requests to authenticated;
grant insert, update on public.aviation_room_scores to authenticated;
drop policy if exists "Aviation rooms are readable" on public.aviation_rooms;
drop policy if exists aviation_rooms_read on public.aviation_rooms;
drop policy if exists "Users create own aviation rooms" on public.aviation_rooms;
drop policy if exists aviation_rooms_create_own on public.aviation_rooms;
drop policy if exists "Owners update aviation rooms" on public.aviation_rooms;
drop policy if exists "Owners delete aviation rooms" on public.aviation_rooms;
drop policy if exists aviation_rooms_delete_own on public.aviation_rooms;
drop policy if exists "Requesters and room owners read aviation requests" on public.aviation_room_requests;
drop policy if exists "Users create own aviation requests" on public.aviation_room_requests;
drop policy if exists "Room owners decide aviation requests" on public.aviation_room_requests;
drop policy if exists aviation_room_requests_read_involved on public.aviation_room_requests;
drop policy if exists aviation_room_requests_create_self on public.aviation_room_requests;
drop policy if exists aviation_room_requests_owner_respond on public.aviation_room_requests;
drop policy if exists "Aviation scores are readable" on public.aviation_room_scores;
drop policy if exists aviation_room_scores_read on public.aviation_room_scores;
drop policy if exists "Players insert own aviation scores" on public.aviation_room_scores;
drop policy if exists "Players update own aviation scores" on public.aviation_room_scores;
create policy aviation_rooms_public_read on public.aviation_rooms for select to anon, authenticated using (true);
create policy aviation_rooms_create_own on public.aviation_rooms for insert to authenticated with check (owner_id = (select auth.uid()));
create policy aviation_rooms_update_own on public.aviation_rooms for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy aviation_rooms_delete_own on public.aviation_rooms for delete to authenticated using (owner_id = (select auth.uid()));
create policy aviation_requests_read_involved on public.aviation_room_requests for select to authenticated using (
  requester_id = (select auth.uid()) or exists(select 1 from public.aviation_rooms r where r.id = aviation_room_requests.room_id and r.owner_id = (select auth.uid()))
);
create policy aviation_requests_create_valid on public.aviation_room_requests for insert to authenticated with check (
  requester_id = (select auth.uid()) and status = 'pending' and exists(
    select 1 from public.aviation_rooms r where r.id = aviation_room_requests.room_id and r.status = 'open'
      and r.owner_id <> (select auth.uid()) and r.name not ilike 'DEMO%'
  )
);
create policy aviation_requests_owner_respond on public.aviation_room_requests for update to authenticated
using (status = 'pending' and exists(select 1 from public.aviation_rooms r where r.id = aviation_room_requests.room_id and r.owner_id = (select auth.uid())))
with check (status in ('accepted','declined') and exists(select 1 from public.aviation_rooms r where r.id = aviation_room_requests.room_id and r.owner_id = (select auth.uid())));
create policy aviation_scores_public_read on public.aviation_room_scores for select to anon, authenticated using (true);
create policy aviation_scores_insert_own on public.aviation_room_scores for insert to authenticated with check (player_id = (select auth.uid()));
create policy aviation_scores_update_own on public.aviation_room_scores for update to authenticated using (player_id = (select auth.uid())) with check (player_id = (select auth.uid()));

-- Naval room access. Existing policies are already singular; these replace them with the same owner/requester rules.
alter table public.naval_rooms enable row level security;
alter table public.naval_room_requests enable row level security;
alter table public.naval_room_scores enable row level security;
grant select on public.naval_rooms, public.naval_room_scores to anon, authenticated;
grant insert, update, delete on public.naval_rooms to authenticated;
grant select, insert on public.naval_room_requests to authenticated;
grant update (status) on public.naval_room_requests to authenticated;
drop policy if exists naval_vessels_read on public.naval_vessels;
drop policy if exists naval_rooms_read on public.naval_rooms;
drop policy if exists naval_rooms_create_own on public.naval_rooms;
drop policy if exists naval_rooms_delete_own on public.naval_rooms;
drop policy if exists naval_room_requests_read_involved on public.naval_room_requests;
drop policy if exists naval_room_requests_create_self on public.naval_room_requests;
drop policy if exists naval_room_requests_owner_respond on public.naval_room_requests;
drop policy if exists naval_room_scores_read on public.naval_room_scores;
create policy naval_rooms_public_read on public.naval_rooms for select to anon, authenticated using (true);
create policy naval_rooms_create_own on public.naval_rooms for insert to authenticated with check (owner_id = (select auth.uid()));
create policy naval_rooms_delete_own on public.naval_rooms for delete to authenticated using (owner_id = (select auth.uid()));
create policy naval_requests_read_involved on public.naval_room_requests for select to authenticated using (
 requester_id = (select auth.uid()) or exists(select 1 from public.naval_rooms r where r.id = naval_room_requests.room_id and r.owner_id = (select auth.uid()))
);
create policy naval_requests_create_valid on public.naval_room_requests for insert to authenticated with check (
 requester_id = (select auth.uid()) and status='pending' and exists(
  select 1 from public.naval_rooms r where r.id=naval_room_requests.room_id and r.status='open'
   and r.owner_id <> (select auth.uid()) and r.name not ilike 'DEMO%'
 )
);
create policy naval_requests_owner_respond on public.naval_room_requests for update to authenticated
using(status='pending' and exists(select 1 from public.naval_rooms r where r.id=naval_room_requests.room_id and r.owner_id=(select auth.uid())))
with check(status in ('accepted','declined') and exists(select 1 from public.naval_rooms r where r.id=naval_room_requests.room_id and r.owner_id=(select auth.uid())));
create policy naval_scores_public_read on public.naval_room_scores for select to anon, authenticated using (true);

COMMIT;


