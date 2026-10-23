-- Optional demo seeder: creates missing demo rooms and missing display-only scores.
-- It does not delete or overwrite existing score rows. Requires one auth user only if a room must be created.
do $$
declare
  demo_owner uuid;
  tank_a public.tank_rooms.id%type; tank_b public.tank_rooms.id%type;
  air_a public.aviation_rooms.id%type; air_b public.aviation_rooms.id%type;
  sea_a public.naval_rooms.id%type; sea_b public.naval_rooms.id%type;
begin
  select id into demo_owner from auth.users order by last_sign_in_at desc nulls last, created_at desc limit 1;
  if demo_owner is null then raise exception 'Create/sign in to an account before seeding demo rooms.'; end if;

  select id into tank_a from public.tank_rooms where name='DEMO - Steel Division' order by created_at desc limit 1;
  if tank_a is null then insert into public.tank_rooms(name,owner_id,mode,team_size,status) values('DEMO - Steel Division',demo_owner,'Realistic Battles',4,'open') returning id into tank_a; end if;
  select id into tank_b from public.tank_rooms where name='DEMO - Iron Wolves' order by created_at desc limit 1;
  if tank_b is null then insert into public.tank_rooms(name,owner_id,mode,team_size,status) values('DEMO - Iron Wolves',demo_owner,'Squad Training',4,'open') returning id into tank_b; end if;

  select id into air_a from public.aviation_rooms where name='DEMO | Sky Wardens' order by created_at desc limit 1;
  if air_a is null then insert into public.aviation_rooms(name,owner_id,mode,team_size,status) values('DEMO | Sky Wardens',demo_owner,'Realistic Battles',8,'open') returning id into air_a; end if;
  select id into air_b from public.aviation_rooms where name='DEMO | Bomber Escort' order by created_at desc limit 1;
  if air_b is null then insert into public.aviation_rooms(name,owner_id,mode,team_size,status) values('DEMO | Bomber Escort',demo_owner,'Squad Training',8,'open') returning id into air_b; end if;

  select id into sea_a from public.naval_rooms where name='DEMO | Atlantic Fleet' order by created_at desc limit 1;
  if sea_a is null then insert into public.naval_rooms(name,owner_id,mode,team_size,status) values('DEMO | Atlantic Fleet',demo_owner,'Realistic Battles',8,'open') returning id into sea_a; end if;
  select id into sea_b from public.naval_rooms where name='DEMO | Pacific Guardians' order by created_at desc limit 1;
  if sea_b is null then insert into public.naval_rooms(name,owner_id,mode,team_size,status) values('DEMO | Pacific Guardians',demo_owner,'Fleet Training',8,'open') returning id into sea_b; end if;

  insert into public.tank_room_scores(room_id,player_id,player_name,points,kills,deaths)
  select v.room_id,null,v.player_name,v.points,v.kills,v.deaths from (values
    (tank_a,'TigerAce',2450,18,5),(tank_a,'SteelWolf',2210,16,7),(tank_a,'PanzerFox',1980,14,8),(tank_a,'GhostTank',1840,12,6),(tank_a,'IronViper',1690,11,9),(tank_a,'BlitzHawk',1510,10,8),(tank_a,'RedComet',1370,9,10),(tank_a,'FrostByte',1190,7,9),
    (tank_b,'TigerAce',2380,17,5),(tank_b,'SteelWolf',2160,15,7),(tank_b,'PanzerFox',1920,13,8),(tank_b,'GhostTank',1780,12,6),(tank_b,'IronViper',1600,10,9),(tank_b,'BlitzHawk',1480,9,8),(tank_b,'RedComet',1300,8,10),(tank_b,'FrostByte',1120,7,9)
  ) v(room_id,player_name,points,kills,deaths)
  where not exists(select 1 from public.tank_room_scores s where s.room_id=v.room_id and s.player_name=v.player_name);

  insert into public.aviation_room_scores(room_id,player_id,player_name,points,kills,deaths)
  select v.room_id,null,v.player_name,v.points,v.kills,v.deaths from (values
    (air_a,'SkyAce',2840,11,1),(air_a,'CloudReaper',2510,9,2),(air_a,'BlueFalcon',2190,8,3),(air_a,'Valkyrie',1870,7,3),(air_a,'IronWing',1640,6,4),(air_a,'Redline',1420,5,4),(air_a,'NightOwl',1180,4,5),(air_a,'RookieOne',860,3,6),
    (air_b,'Stormchaser',2760,10,1),(air_b,'BomberGuard',2430,9,2),(air_b,'AeroKnight',2110,8,2),(air_b,'SilverLance',1930,7,3),(air_b,'HighAltitude',1690,6,3),(air_b,'Wingman7',1470,5,4),(air_b,'AceRookie',1210,4,5),(air_b,'TrainingPilot',910,3,6)
  ) v(room_id,player_name,points,kills,deaths)
  where not exists(select 1 from public.aviation_room_scores s where s.room_id=v.room_id and s.player_name=v.player_name);

  insert into public.naval_room_scores(room_id,player_id,player_name,points,kills,deaths)
  select v.room_id,null,v.player_name,v.points,v.kills,v.deaths from (values
    (sea_a,'HarborAce',2840,11,1),(sea_a,'Dreadnought',2510,9,2),(sea_a,'BlueWater',2190,8,3),(sea_a,'Ironclad',1870,7,3),(sea_a,'Tidebreaker',1640,6,4),(sea_a,'SeaWolf',1420,5,4),(sea_a,'NorthStar',1180,4,5),(sea_a,'Deckhand',860,3,6),
    (sea_b,'StormFleet',2760,10,1),(sea_b,'WaveRider',2430,9,2),(sea_b,'AegisGuard',2110,8,2),(sea_b,'SilverWake',1930,7,3),(sea_b,'DeepCurrent',1690,6,3),(sea_b,'SeaLance',1470,5,4),(sea_b,'ReefRunner',1210,4,5),(sea_b,'CadetBlue',910,3,6)
  ) v(room_id,player_name,points,kills,deaths)
  where not exists(select 1 from public.naval_room_scores s where s.room_id=v.room_id and s.player_name=v.player_name);
end $$;
