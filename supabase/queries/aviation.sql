-- Keep both existing aircraft catalogs so either frontend fallback continues to work.
do $$ begin
  if to_regclass('public.aircraft') is not null then
    insert into public.aircraft(name,nation,category,description,rank)
    select v.name,v.nation,v.category,v.description,v.rank from (values
      ('P-51 Mustang','United States','Fighter','Long-range fighter known for speed, range, and escort missions.','III–IV'),
      ('Supermarine Spitfire','United Kingdom','Fighter','Highly manoeuvrable fighter associated with the Battle of Britain.','II–IV'),
      ('Mitsubishi A6M Zero','Japan','Naval Fighter','Carrier-based fighter designed for long range and agility.','II–III'),
      ('B-17 Flying Fortress','United States','Bomber','Strategic bomber designed for high-altitude, long-range missions.','III–IV'),
      ('F-16 Fighting Falcon','United States','Multirole Fighter','Multirole fighter for air-to-air and air-to-ground missions.','VII–VIII'),
      ('F4U-4 Corsair','United States','Carrier Fighter','Carrier-capable fighter known for its inverted gull wings.','IV'),
      ('Hawker Tempest Mk V','United Kingdom','Fighter','Fast late-war fighter designed to intercept high-speed threats.','IV'),
      ('Yakovlev Yak-3','Soviet Union','Fighter','Lightweight fighter known for agility at low and medium altitude.','III'),
      ('Messerschmitt Bf 109 G-6','Germany','Fighter','Widely used fighter with flexible armament options.','IV'),
      ('A-26B Invader','United States','Attack Aircraft','Twin-engine attack aircraft built for ground-attack missions.','III–IV')
    ) v(name,nation,category,description,rank)
    where not exists(select 1 from public.aircraft a where a.name=v.name);
  end if;
  if to_regclass('public.aviation_aircraft') is not null then
    insert into public.aviation_aircraft(name,nation,category,description)
    select v.name,v.nation,v.category,v.description from (values
      ('P-51 Mustang','United States','Fighter','Long-range fighter known for speed, range, and escort missions.'),
      ('Supermarine Spitfire','United Kingdom','Fighter','Highly manoeuvrable fighter associated with the Battle of Britain.'),
      ('Mitsubishi A6M Zero','Japan','Naval Fighter','Carrier-based fighter designed for long range and agility.'),
      ('B-17 Flying Fortress','United States','Bomber','Strategic bomber designed for high-altitude, long-range missions.'),
      ('F-16 Fighting Falcon','United States','Multirole Fighter','Multirole fighter for air-to-air and air-to-ground missions.'),
      ('F4U-4 Corsair','United States','Carrier Fighter','Carrier-capable fighter known for its inverted gull wings.'),
      ('Hawker Tempest Mk V','United Kingdom','Fighter','Fast late-war fighter designed to intercept high-speed threats.'),
      ('Yakovlev Yak-3','Soviet Union','Fighter','Lightweight fighter known for agility at low and medium altitude.'),
      ('Messerschmitt Bf 109 G-6','Germany','Fighter','Widely used fighter with flexible armament options.'),
      ('A-26B Invader','United States','Attack Aircraft','Twin-engine attack aircraft built for ground-attack missions.')
    ) v(name,nation,category,description)
    where not exists(select 1 from public.aviation_aircraft a where a.name=v.name);
  end if;
end $$;
