begin;

drop table if exists public.comments;
drop table if exists public.favourites;
drop table if exists public.posts;

notify pgrst, 'reload schema';

commit;