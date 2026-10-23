-- Tank catalog records. Existing rows with these IDs are preserved unchanged.
-- Display-only demo pilots do not correspond to Auth accounts.
alter table public.tank_room_scores
  add column if not exists player_name text;
alter table public.tank_room_scores
  alter column player_id drop not null;

insert into public.vehicles (id,name,nation) values
(1001,'M1 Abrams','USA'),(1002,'M4 Sherman','USA'),(1003,'M18 Hellcat','USA'),(1004,'M60 Patton','USA'),
(1005,'Leopard 2','Germany'),(1006,'Tiger II','Germany'),(1007,'Panther','Germany'),(1008,'T-34-85','USSR'),
(1009,'KV-1','USSR'),(1010,'IS-2','USSR'),(1011,'T-72','USSR'),(1012,'T-80','USSR'),(1013,'T-90','USSR'),
(1014,'Challenger 2','Great Britain'),(1015,'Centurion','Great Britain'),(1016,'Type 96','China'),(1017,'Type 99','China'),
(1018,'Leclerc','France'),(1019,'Ariete','Italy'),(1020,'Strv 122','Sweden')
on conflict (id) do nothing;
