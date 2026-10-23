-- Consolidate the duplicate aviation catalogs into public.aircraft.
-- The current aviation.html reads public.aircraft first and gracefully skips
-- public.aviation_aircraft if that fallback table is missing.
-- Existing aircraft rows in public.aircraft are retained; missing names are copied.

begin;

insert into public.aircraft (name, nation, category, description)
select
  source.name,
  source.nation,
  source.category,
  source.description
from public.aviation_aircraft as source
where not exists (
  select 1
  from public.aircraft as canonical
  where lower(trim(canonical.name)) = lower(trim(source.name))
);

-- Deliberately omit CASCADE: if another database object depends on this table,
-- PostgreSQL stops here and rolls back the copy instead of removing dependencies.
drop table public.aviation_aircraft;

notify pgrst, 'reload schema';

commit;
