-- Naval catalog. Existing vessels with these names are preserved unchanged.
insert into public.naval_vessels(name,nation,category,description) values
('USS Iowa','United States','Battleship','Lead ship of the Iowa class, built for speed and heavy-gun fleet operations.'),
('HMS Warspite','United Kingdom','Battleship','Queen Elizabeth class battleship with a long record of service.'),
('IJN Yamato','Japan','Battleship','Imperial Japanese Navy battleship and one of the largest ever built.'),
('Bismarck','Germany','Battleship','Bismarck class battleship and the lead ship of its class.'),
('USS Enterprise','United States','Aircraft Carrier','Yorktown class aircraft carrier that served throughout the Pacific War.'),
('HMS Belfast','United Kingdom','Cruiser','Town class light cruiser built for fleet service.'),
('USS Fletcher','United States','Destroyer','Fletcher class destroyer used for escort and surface combat.'),
('USS Missouri','United States','Battleship','Iowa class battleship that hosted the 1945 surrender ceremony.'),
('Akagi','Japan','Aircraft Carrier','Imperial Japanese Navy aircraft carrier used in the Pacific.'),
('Type VII U-Boat','Germany','Submarine','German submarine class widely used in Atlantic operations.')
on conflict(name) do nothing;
