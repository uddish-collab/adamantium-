-- The website reads all mode guides from public.guides. The separate
-- public.aviation_guides table is unused by the current pages.
-- No CASCADE is used: if another database object depends on it, this fails safely.

begin;

drop table public.aviation_guides;

notify pgrst, 'reload schema';

commit;
