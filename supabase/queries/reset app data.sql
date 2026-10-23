-- Fresh application-data reset for the existing Adamantium schema.
-- This removes room/score/request rows, catalogs, guides, and vehicle favorites.
-- It keeps Auth users, profiles, posts, comments, and all table definitions.
-- Run only when you intend to clear the listed application data.

begin;

truncate table
  public.tank_room_scores,
  public.tank_room_requests,
  public.tank_rooms,
  public.aviation_room_scores,
  public.aviation_room_requests,
  public.aviation_rooms,
  public.naval_room_scores,
  public.naval_room_requests,
  public.naval_rooms,
  public.aviation_guides,
  public.guides,
  public.aircraft,
  public.aviation_aircraft,
  public.naval_vessels,
  public.favourites,
  public.vehicles
restart identity;

commit;

notify pgrst, 'reload schema';
