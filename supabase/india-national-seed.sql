-- Explore India national starter dataset
-- Run in Supabase Dashboard -> SQL Editor.

create table if not exists public.explore_states (
  id bigserial primary key,
  name text not null unique,
  code text unique,
  is_union_territory boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.explore_categories (
  id bigserial primary key,
  name text not null unique,
  slug text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.explore_districts (
  id bigserial primary key,
  state_id bigint not null references public.explore_states(id) on delete cascade,
  name text not null,
  is_active boolean not null default true,
  unique(state_id,name)
);

create table if not exists public.explore_places (
  id bigserial primary key,
  name text not null,
  slug text not null unique,
  category_id bigint references public.explore_categories(id),
  state_id bigint references public.explore_states(id),
  district_id bigint references public.explore_districts(id),
  short_description text,
  full_description text,
  latitude numeric(10,7),
  longitude numeric(10,7),
  best_season text,
  average_rating numeric(2,1) default 4.5,
  entry_fee numeric(12,2) default 0,
  visit_hours numeric(5,2) default 4,
  status text not null default 'published',
  is_featured boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.explore_place_images (
  id bigserial primary key,
  place_id bigint not null references public.explore_places(id) on delete cascade,
  image_url text not null,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.explore_states enable row level security;
alter table public.explore_categories enable row level security;
alter table public.explore_districts enable row level security;
alter table public.explore_places enable row level security;
alter table public.explore_place_images enable row level security;

drop policy if exists "Public read states" on public.explore_states;
create policy "Public read states" on public.explore_states for select using (is_active = true);
drop policy if exists "Public read categories" on public.explore_categories;
create policy "Public read categories" on public.explore_categories for select using (is_active = true);
drop policy if exists "Public read districts" on public.explore_districts;
create policy "Public read districts" on public.explore_districts for select using (is_active = true);
drop policy if exists "Public read published places" on public.explore_places;
create policy "Public read published places" on public.explore_places for select using (status = 'published');
drop policy if exists "Public read place images" on public.explore_place_images;
create policy "Public read place images" on public.explore_place_images for select using (true);

insert into public.explore_states(name,code,is_union_territory) values
('Andhra Pradesh','AP',false),
('Arunachal Pradesh','AR',false),
('Assam','AS',false),
('Bihar','BR',false),
('Chhattisgarh','CG',false),
('Goa','GA',false),
('Gujarat','GJ',false),
('Haryana','HR',false),
('Himachal Pradesh','HP',false),
('Jharkhand','JH',false),
('Karnataka','KA',false),
('Kerala','KL',false),
('Madhya Pradesh','MP',false),
('Maharashtra','MH',false),
('Manipur','MN',false),
('Meghalaya','ML',false),
('Mizoram','MZ',false),
('Nagaland','NL',false),
('Odisha','OD',false),
('Punjab','PB',false),
('Rajasthan','RJ',false),
('Sikkim','SK',false),
('Tamil Nadu','TN',false),
('Telangana','TS',false),
('Tripura','TR',false),
('Uttar Pradesh','UP',false),
('Uttarakhand','UK',false),
('West Bengal','WB',false),
('Andaman and Nicobar Islands','AN',true),
('Chandigarh','CH',true),
('Dadra and Nagar Haveli and Daman and Diu','DN',true),
('Delhi','DL',true),
('Jammu and Kashmir','JK',true),
('Ladakh','LA',true),
('Lakshadweep','LD',true),
('Puducherry','PY',true)
on conflict (name) do update set code=excluded.code,is_union_territory=excluded.is_union_territory,is_active=true;

insert into public.explore_categories(name,slug) values
('Backwater','backwater'),
('Beach','beach'),
('Cave','cave'),
('Culture','culture'),
('Desert','desert'),
('Fort','fort'),
('Garden','garden'),
('Heritage','heritage'),
('Hill Station','hill-station'),
('Island','island'),
('Lake','lake'),
('Landmark','landmark'),
('Monastery','monastery'),
('Museum','museum'),
('National Park','national-park'),
('Nature','nature'),
('Palace','palace'),
('Pilgrimage','pilgrimage'),
('River','river'),
('Spiritual','spiritual'),
('Temple','temple'),
('Valley','valley'),
('Waterfall','waterfall')
on conflict (name) do update set is_active=true;

insert into public.explore_districts(state_id,name)
select id,'South Andaman' from public.explore_states where name='Andaman and Nicobar Islands'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Tirupati' from public.explore_states where name='Andhra Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Visakhapatnam' from public.explore_states where name='Andhra Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Lower Subansiri' from public.explore_states where name='Arunachal Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Tawang' from public.explore_states where name='Arunachal Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Golaghat' from public.explore_states where name='Assam'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Majuli' from public.explore_states where name='Assam'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Gaya' from public.explore_states where name='Bihar'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Nalanda' from public.explore_states where name='Bihar'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Chandigarh' from public.explore_states where name='Chandigarh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Bastar' from public.explore_states where name='Chhattisgarh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Daman' from public.explore_states where name='Dadra and Nagar Haveli and Daman and Diu'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Diu' from public.explore_states where name='Dadra and Nagar Haveli and Daman and Diu'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Central Delhi' from public.explore_states where name='Delhi'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'New Delhi' from public.explore_states where name='Delhi'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'North Goa' from public.explore_states where name='Goa'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Kutch' from public.explore_states where name='Gujarat'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Narmada' from public.explore_states where name='Gujarat'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Gurugram' from public.explore_states where name='Haryana'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Kurukshetra' from public.explore_states where name='Haryana'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Kullu' from public.explore_states where name='Himachal Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Shimla' from public.explore_states where name='Himachal Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Baramulla' from public.explore_states where name='Jammu and Kashmir'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Srinagar' from public.explore_states where name='Jammu and Kashmir'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Latehar' from public.explore_states where name='Jharkhand'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Ranchi' from public.explore_states where name='Jharkhand'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Mysuru' from public.explore_states where name='Karnataka'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Vijayanagara' from public.explore_states where name='Karnataka'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Alappuzha' from public.explore_states where name='Kerala'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Idukki' from public.explore_states where name='Kerala'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Leh' from public.explore_states where name='Ladakh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Lakshadweep' from public.explore_states where name='Lakshadweep'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Chhatarpur' from public.explore_states where name='Madhya Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Mandla' from public.explore_states where name='Madhya Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Chhatrapati Sambhajinagar' from public.explore_states where name='Maharashtra'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Mumbai' from public.explore_states where name='Maharashtra'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Bishnupur' from public.explore_states where name='Manipur'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Imphal West' from public.explore_states where name='Manipur'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'East Khasi Hills' from public.explore_states where name='Meghalaya'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'West Jaintia Hills' from public.explore_states where name='Meghalaya'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Mamit' from public.explore_states where name='Mizoram'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Serchhip' from public.explore_states where name='Mizoram'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Kohima' from public.explore_states where name='Nagaland'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Puri' from public.explore_states where name='Odisha'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Puducherry' from public.explore_states where name='Puducherry'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Amritsar' from public.explore_states where name='Punjab'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Jaipur' from public.explore_states where name='Rajasthan'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Jaisalmer' from public.explore_states where name='Rajasthan'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Gangtok' from public.explore_states where name='Sikkim'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Chengalpattu' from public.explore_states where name='Tamil Nadu'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Madurai' from public.explore_states where name='Tamil Nadu'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Hyderabad' from public.explore_states where name='Telangana'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Mulugu' from public.explore_states where name='Telangana'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Sepahijala' from public.explore_states where name='Tripura'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'West Tripura' from public.explore_states where name='Tripura'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Agra' from public.explore_states where name='Uttar Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Varanasi' from public.explore_states where name='Uttar Pradesh'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Chamoli' from public.explore_states where name='Uttarakhand'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Rudraprayag' from public.explore_states where name='Uttarakhand'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'Kolkata' from public.explore_states where name='West Bengal'
on conflict (state_id,name) do update set is_active=true;
insert into public.explore_districts(state_id,name)
select id,'South 24 Parganas' from public.explore_states where name='West Bengal'
on conflict (state_id,name) do update set is_active=true;

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Visakhapatnam Beach','visakhapatnam-beach',c.id,s.id,d.id,'Coastal city known for beaches, hills and museums.','Coastal city known for beaches, hills and museums.',17.6868,83.2185,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Beach'
left join public.explore_districts d on d.state_id=s.id and d.name='Visakhapatnam'
where s.name='Andhra Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='visakhapatnam-beach' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Tirupati Balaji Temple','tirupati-balaji-temple',c.id,s.id,d.id,'Major Hindu pilgrimage destination in the Tirumala hills.','Major Hindu pilgrimage destination in the Tirumala hills.',13.6833,79.347,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Tirupati'
where s.name='Andhra Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='tirupati-balaji-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Tawang Monastery','tawang-monastery',c.id,s.id,d.id,'One of India''s largest Buddhist monasteries.','One of India''s largest Buddhist monasteries.',27.5861,91.8594,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Monastery'
left join public.explore_districts d on d.state_id=s.id and d.name='Tawang'
where s.name='Arunachal Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='tawang-monastery' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Ziro Valley','ziro-valley',c.id,s.id,d.id,'Scenic valley known for rice fields and tribal culture.','Scenic valley known for rice fields and tribal culture.',27.594,93.828,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Lower Subansiri'
where s.name='Arunachal Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='ziro-valley' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kaziranga National Park','kaziranga-national-park',c.id,s.id,d.id,'UNESCO-listed park famous for one-horned rhinoceroses.','UNESCO-listed park famous for one-horned rhinoceroses.',26.5775,93.1711,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Golaghat'
where s.name='Assam'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kaziranga-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Majuli Island','majuli-island',c.id,s.id,d.id,'River island known for Assamese monasteries and culture.','River island known for Assamese monasteries and culture.',27.0016,94.2243,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Culture'
left join public.explore_districts d on d.state_id=s.id and d.name='Majuli'
where s.name='Assam'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='majuli-island' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Mahabodhi Temple','mahabodhi-temple',c.id,s.id,d.id,'UNESCO World Heritage Buddhist pilgrimage site.','UNESCO World Heritage Buddhist pilgrimage site.',24.6959,84.991,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Gaya'
where s.name='Bihar'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='mahabodhi-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Nalanda Ruins','nalanda-ruins',c.id,s.id,d.id,'Ancient centre of learning and archaeological site.','Ancient centre of learning and archaeological site.',25.1367,85.4437,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='Nalanda'
where s.name='Bihar'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='nalanda-ruins' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Chitrakote Falls','chitrakote-falls',c.id,s.id,d.id,'Wide horseshoe-shaped waterfall on the Indravati River.','Wide horseshoe-shaped waterfall on the Indravati River.',19.207,81.7,'Monsoon',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Waterfall'
left join public.explore_districts d on d.state_id=s.id and d.name='Bastar'
where s.name='Chhattisgarh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='chitrakote-falls' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kanger Valley National Park','kanger-valley-national-park',c.id,s.id,d.id,'Forest reserve known for caves and biodiversity.','Forest reserve known for caves and biodiversity.',18.7785,81.93,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Bastar'
where s.name='Chhattisgarh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kanger-valley-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Baga Beach','baga-beach',c.id,s.id,d.id,'Popular beach with water sports and nearby resorts.','Popular beach with water sports and nearby resorts.',15.5553,73.7517,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Beach'
left join public.explore_districts d on d.state_id=s.id and d.name='North Goa'
where s.name='Goa'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='baga-beach' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Basilica of Bom Jesus','basilica-of-bom-jesus',c.id,s.id,d.id,'UNESCO-listed church in Old Goa.','UNESCO-listed church in Old Goa.',15.5009,73.9116,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='North Goa'
where s.name='Goa'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='basilica-of-bom-jesus' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Statue of Unity','statue-of-unity',c.id,s.id,d.id,'Famous monument overlooking the Narmada River.','Famous monument overlooking the Narmada River.',21.838,73.7191,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Landmark'
left join public.explore_districts d on d.state_id=s.id and d.name='Narmada'
where s.name='Gujarat'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='statue-of-unity' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Rann of Kutch','rann-of-kutch',c.id,s.id,d.id,'Salt desert known for the Rann Utsav.','Salt desert known for the Rann Utsav.',23.7337,69.8597,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Desert'
left join public.explore_districts d on d.state_id=s.id and d.name='Kutch'
where s.name='Gujarat'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='rann-of-kutch' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Sultanpur National Park','sultanpur-national-park',c.id,s.id,d.id,'Bird sanctuary and wetland near Delhi NCR.','Bird sanctuary and wetland near Delhi NCR.',28.4595,76.8908,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Gurugram'
where s.name='Haryana'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='sultanpur-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kurukshetra','kurukshetra',c.id,s.id,d.id,'Historic religious destination associated with the Mahabharata.','Historic religious destination associated with the Mahabharata.',29.9695,76.8783,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Pilgrimage'
left join public.explore_districts d on d.state_id=s.id and d.name='Kurukshetra'
where s.name='Haryana'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kurukshetra' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Manali','manali',c.id,s.id,d.id,'Mountain destination for snow and adventure.','Mountain destination for snow and adventure.',32.2396,77.1887,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Kullu'
where s.name='Himachal Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='manali' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Shimla','shimla',c.id,s.id,d.id,'Popular Himalayan hill city.','Popular Himalayan hill city.',31.1048,77.1734,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Shimla'
where s.name='Himachal Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='shimla' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Dassam Falls','dassam-falls',c.id,s.id,d.id,'Scenic waterfall near Ranchi.','Scenic waterfall near Ranchi.',23.1443,85.4679,'Monsoon',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Waterfall'
left join public.explore_districts d on d.state_id=s.id and d.name='Ranchi'
where s.name='Jharkhand'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='dassam-falls' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Betla National Park','betla-national-park',c.id,s.id,d.id,'Forest reserve in the Chotanagpur plateau.','Forest reserve in the Chotanagpur plateau.',23.8876,84.1904,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Latehar'
where s.name='Jharkhand'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='betla-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Hampi','hampi',c.id,s.id,d.id,'UNESCO-listed ruins of the Vijayanagara Empire.','UNESCO-listed ruins of the Vijayanagara Empire.',15.335,76.46,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='Vijayanagara'
where s.name='Karnataka'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='hampi' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Mysore Palace','mysore-palace',c.id,s.id,d.id,'Grand royal palace famous for illuminated evenings.','Grand royal palace famous for illuminated evenings.',12.3052,76.6552,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Palace'
left join public.explore_districts d on d.state_id=s.id and d.name='Mysuru'
where s.name='Karnataka'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='mysore-palace' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Munnar','munnar',c.id,s.id,d.id,'Tea gardens, misty hills and wildlife.','Tea gardens, misty hills and wildlife.',10.0889,77.0595,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Idukki'
where s.name='Kerala'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='munnar' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Alappuzha Backwaters','alappuzha-backwaters',c.id,s.id,d.id,'Houseboat destination through Kerala''s backwaters.','Houseboat destination through Kerala''s backwaters.',9.4981,76.3388,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Backwater'
left join public.explore_districts d on d.state_id=s.id and d.name='Alappuzha'
where s.name='Kerala'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='alappuzha-backwaters' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Khajuraho Temples','khajuraho-temples',c.id,s.id,d.id,'UNESCO-listed temple complex.','UNESCO-listed temple complex.',24.8318,79.9199,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Chhatarpur'
where s.name='Madhya Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='khajuraho-temples' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kanha National Park','kanha-national-park',c.id,s.id,d.id,'Tiger reserve with sal forests and grasslands.','Tiger reserve with sal forests and grasslands.',22.3345,80.6115,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Mandla'
where s.name='Madhya Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kanha-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Gateway of India','gateway-of-india',c.id,s.id,d.id,'Historic waterfront monument in South Mumbai.','Historic waterfront monument in South Mumbai.',18.922,72.8347,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Landmark'
left join public.explore_districts d on d.state_id=s.id and d.name='Mumbai'
where s.name='Maharashtra'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='gateway-of-india' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Ajanta Caves','ajanta-caves',c.id,s.id,d.id,'UNESCO-listed Buddhist rock-cut caves.','UNESCO-listed Buddhist rock-cut caves.',20.5519,75.7033,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Cave'
left join public.explore_districts d on d.state_id=s.id and d.name='Chhatrapati Sambhajinagar'
where s.name='Maharashtra'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='ajanta-caves' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Loktak Lake','loktak-lake',c.id,s.id,d.id,'Freshwater lake known for floating phumdis.','Freshwater lake known for floating phumdis.',24.559,93.777,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Lake'
left join public.explore_districts d on d.state_id=s.id and d.name='Bishnupur'
where s.name='Manipur'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='loktak-lake' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kangla Fort','kangla-fort',c.id,s.id,d.id,'Historic royal fort complex in Imphal.','Historic royal fort complex in Imphal.',24.8074,93.9384,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Fort'
left join public.explore_districts d on d.state_id=s.id and d.name='Imphal West'
where s.name='Manipur'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kangla-fort' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Living Root Bridges','living-root-bridges',c.id,s.id,d.id,'Unique bridges grown from living tree roots.','Unique bridges grown from living tree roots.',25.184,91.702,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Nature'
left join public.explore_districts d on d.state_id=s.id and d.name='East Khasi Hills'
where s.name='Meghalaya'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='living-root-bridges' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Dawki River','dawki-river',c.id,s.id,d.id,'Clear-water river and border tourism destination.','Clear-water river and border tourism destination.',25.1842,92.0248,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='River'
left join public.explore_districts d on d.state_id=s.id and d.name='West Jaintia Hills'
where s.name='Meghalaya'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='dawki-river' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Vantawng Falls','vantawng-falls',c.id,s.id,d.id,'Tall waterfall surrounded by bamboo forest.','Tall waterfall surrounded by bamboo forest.',23.539,92.65,'Monsoon',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Waterfall'
left join public.explore_districts d on d.state_id=s.id and d.name='Serchhip'
where s.name='Mizoram'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='vantawng-falls' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Reiek','reiek',c.id,s.id,d.id,'Hill destination with panoramic views.','Hill destination with panoramic views.',23.683,92.614,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Mamit'
where s.name='Mizoram'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='reiek' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Dzukou Valley','dzukou-valley',c.id,s.id,d.id,'High-altitude valley famous for trekking.','High-altitude valley famous for trekking.',25.558,94.05,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Valley'
left join public.explore_districts d on d.state_id=s.id and d.name='Kohima'
where s.name='Nagaland'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='dzukou-valley' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kisama Heritage Village','kisama-heritage-village',c.id,s.id,d.id,'Venue of the Hornbill Festival.','Venue of the Hornbill Festival.',25.594,94.114,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Culture'
left join public.explore_districts d on d.state_id=s.id and d.name='Kohima'
where s.name='Nagaland'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kisama-heritage-village' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Jagannath Temple','jagannath-temple',c.id,s.id,d.id,'Major pilgrimage temple in Puri.','Major pilgrimage temple in Puri.',19.8049,85.8172,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Puri'
where s.name='Odisha'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='jagannath-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Konark Sun Temple','konark-sun-temple',c.id,s.id,d.id,'UNESCO-listed temple shaped like a stone chariot.','UNESCO-listed temple shaped like a stone chariot.',19.8876,86.0945,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Puri'
where s.name='Odisha'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='konark-sun-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Golden Temple','golden-temple',c.id,s.id,d.id,'Sacred Sikh shrine with a community kitchen.','Sacred Sikh shrine with a community kitchen.',31.62,74.8765,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Amritsar'
where s.name='Punjab'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='golden-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Jallianwala Bagh','jallianwala-bagh',c.id,s.id,d.id,'National memorial associated with India''s freedom struggle.','National memorial associated with India''s freedom struggle.',31.6206,74.88,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='Amritsar'
where s.name='Punjab'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='jallianwala-bagh' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Amber Fort','amber-fort',c.id,s.id,d.id,'Hilltop fort known for Rajput architecture.','Hilltop fort known for Rajput architecture.',26.9855,75.8513,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Fort'
left join public.explore_districts d on d.state_id=s.id and d.name='Jaipur'
where s.name='Rajasthan'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='amber-fort' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Jaisalmer Fort','jaisalmer-fort',c.id,s.id,d.id,'Living desert fort made from golden sandstone.','Living desert fort made from golden sandstone.',26.9124,70.9126,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Fort'
left join public.explore_districts d on d.state_id=s.id and d.name='Jaisalmer'
where s.name='Rajasthan'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='jaisalmer-fort' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Tsomgo Lake','tsomgo-lake',c.id,s.id,d.id,'Glacial lake on the route toward Nathula Pass.','Glacial lake on the route toward Nathula Pass.',27.3742,88.7617,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Lake'
left join public.explore_districts d on d.state_id=s.id and d.name='Gangtok'
where s.name='Sikkim'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='tsomgo-lake' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Rumtek Monastery','rumtek-monastery',c.id,s.id,d.id,'Important Tibetan Buddhist monastery.','Important Tibetan Buddhist monastery.',27.289,88.561,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Monastery'
left join public.explore_districts d on d.state_id=s.id and d.name='Gangtok'
where s.name='Sikkim'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='rumtek-monastery' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Meenakshi Amman Temple','meenakshi-amman-temple',c.id,s.id,d.id,'Historic temple complex famous for colourful gopurams.','Historic temple complex famous for colourful gopurams.',9.9195,78.1193,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Madurai'
where s.name='Tamil Nadu'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='meenakshi-amman-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Mahabalipuram','mahabalipuram',c.id,s.id,d.id,'UNESCO-listed shore temples and monuments.','UNESCO-listed shore temples and monuments.',12.6269,80.1927,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='Chengalpattu'
where s.name='Tamil Nadu'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='mahabalipuram' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Charminar','charminar',c.id,s.id,d.id,'Iconic four-minaret monument in Hyderabad.','Iconic four-minaret monument in Hyderabad.',17.3616,78.4747,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Landmark'
left join public.explore_districts d on d.state_id=s.id and d.name='Hyderabad'
where s.name='Telangana'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='charminar' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Ramappa Temple','ramappa-temple',c.id,s.id,d.id,'UNESCO-listed Kakatiya-era temple.','UNESCO-listed Kakatiya-era temple.',18.2593,79.9436,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Mulugu'
where s.name='Telangana'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='ramappa-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Ujjayanta Palace','ujjayanta-palace',c.id,s.id,d.id,'Former royal palace and state museum.','Former royal palace and state museum.',23.8315,91.282,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Palace'
left join public.explore_districts d on d.state_id=s.id and d.name='West Tripura'
where s.name='Tripura'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='ujjayanta-palace' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Neermahal','neermahal',c.id,s.id,d.id,'Lake palace in Rudrasagar Lake.','Lake palace in Rudrasagar Lake.',23.4968,91.3304,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Palace'
left join public.explore_districts d on d.state_id=s.id and d.name='Sepahijala'
where s.name='Tripura'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='neermahal' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Taj Mahal','taj-mahal',c.id,s.id,d.id,'UNESCO-listed Mughal mausoleum and global landmark.','UNESCO-listed Mughal mausoleum and global landmark.',27.1751,78.0421,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='Agra'
where s.name='Uttar Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='taj-mahal' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Varanasi Ghats','varanasi-ghats',c.id,s.id,d.id,'Ancient spiritual riverfront famous for Ganga Aarti.','Ancient spiritual riverfront famous for Ganga Aarti.',25.3176,82.9739,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Pilgrimage'
left join public.explore_districts d on d.state_id=s.id and d.name='Varanasi'
where s.name='Uttar Pradesh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='varanasi-ghats' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Valley of Flowers','valley-of-flowers',c.id,s.id,d.id,'UNESCO-listed Himalayan national park.','UNESCO-listed Himalayan national park.',30.728,79.6053,'Monsoon',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='Chamoli'
where s.name='Uttarakhand'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='valley-of-flowers' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Kedarnath Temple','kedarnath-temple',c.id,s.id,d.id,'High-altitude Shiva temple and pilgrimage.','High-altitude Shiva temple and pilgrimage.',30.7352,79.0669,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Temple'
left join public.explore_districts d on d.state_id=s.id and d.name='Rudraprayag'
where s.name='Uttarakhand'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='kedarnath-temple' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Victoria Memorial','victoria-memorial',c.id,s.id,d.id,'Marble monument and museum in Kolkata.','Marble monument and museum in Kolkata.',22.5448,88.3426,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Museum'
left join public.explore_districts d on d.state_id=s.id and d.name='Kolkata'
where s.name='West Bengal'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='victoria-memorial' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Sundarbans National Park','sundarbans-national-park',c.id,s.id,d.id,'Mangrove tiger reserve and World Heritage Site.','Mangrove tiger reserve and World Heritage Site.',21.9497,88.8926,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='National Park'
left join public.explore_districts d on d.state_id=s.id and d.name='South 24 Parganas'
where s.name='West Bengal'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='sundarbans-national-park' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Radhanagar Beach','radhanagar-beach',c.id,s.id,d.id,'White-sand beach on Havelock Island.','White-sand beach on Havelock Island.',11.9845,92.9508,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Beach'
left join public.explore_districts d on d.state_id=s.id and d.name='South Andaman'
where s.name='Andaman and Nicobar Islands'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='radhanagar-beach' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Cellular Jail','cellular-jail',c.id,s.id,d.id,'National memorial linked to India''s freedom struggle.','National memorial linked to India''s freedom struggle.',11.6743,92.7477,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Heritage'
left join public.explore_districts d on d.state_id=s.id and d.name='South Andaman'
where s.name='Andaman and Nicobar Islands'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='cellular-jail' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Rock Garden','rock-garden',c.id,s.id,d.id,'Sculpture garden created from recycled materials.','Sculpture garden created from recycled materials.',30.7525,76.807,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Garden'
left join public.explore_districts d on d.state_id=s.id and d.name='Chandigarh'
where s.name='Chandigarh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='rock-garden' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Sukhna Lake','sukhna-lake',c.id,s.id,d.id,'Popular urban lake for walking and boating.','Popular urban lake for walking and boating.',30.7421,76.8188,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Lake'
left join public.explore_districts d on d.state_id=s.id and d.name='Chandigarh'
where s.name='Chandigarh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='sukhna-lake' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Diu Fort','diu-fort',c.id,s.id,d.id,'Portuguese-era coastal fort.','Portuguese-era coastal fort.',20.7144,70.9874,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Fort'
left join public.explore_districts d on d.state_id=s.id and d.name='Diu'
where s.name='Dadra and Nagar Haveli and Daman and Diu'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='diu-fort' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Devka Beach','devka-beach',c.id,s.id,d.id,'Popular coastal promenade and beach.','Popular coastal promenade and beach.',20.4326,72.8354,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Beach'
left join public.explore_districts d on d.state_id=s.id and d.name='Daman'
where s.name='Dadra and Nagar Haveli and Daman and Diu'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='devka-beach' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'India Gate','india-gate',c.id,s.id,d.id,'National war memorial and ceremonial landmark.','National war memorial and ceremonial landmark.',28.6129,77.2295,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Landmark'
left join public.explore_districts d on d.state_id=s.id and d.name='New Delhi'
where s.name='Delhi'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='india-gate' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Red Fort','red-fort',c.id,s.id,d.id,'UNESCO-listed Mughal fort complex.','UNESCO-listed Mughal fort complex.',28.6562,77.241,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Fort'
left join public.explore_districts d on d.state_id=s.id and d.name='Central Delhi'
where s.name='Delhi'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='red-fort' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Dal Lake','dal-lake',c.id,s.id,d.id,'Scenic lake known for shikaras and houseboats.','Scenic lake known for shikaras and houseboats.',34.1106,74.8683,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Lake'
left join public.explore_districts d on d.state_id=s.id and d.name='Srinagar'
where s.name='Jammu and Kashmir'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='dal-lake' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Gulmarg','gulmarg',c.id,s.id,d.id,'Mountain destination for snow sports.','Mountain destination for snow sports.',34.0484,74.3805,'All year',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Hill Station'
left join public.explore_districts d on d.state_id=s.id and d.name='Baramulla'
where s.name='Jammu and Kashmir'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='gulmarg' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Pangong Lake','pangong-lake',c.id,s.id,d.id,'High-altitude lake known for changing blue shades.','High-altitude lake known for changing blue shades.',33.7595,78.6674,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Lake'
left join public.explore_districts d on d.state_id=s.id and d.name='Leh'
where s.name='Ladakh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='pangong-lake' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Nubra Valley','nubra-valley',c.id,s.id,d.id,'Cold desert valley with dunes and monasteries.','Cold desert valley with dunes and monasteries.',34.6863,77.5673,'Summer',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Valley'
left join public.explore_districts d on d.state_id=s.id and d.name='Leh'
where s.name='Ladakh'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='nubra-valley' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Agatti Island','agatti-island',c.id,s.id,d.id,'Coral island known for lagoons and water activities.','Coral island known for lagoons and water activities.',10.858,72.193,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Island'
left join public.explore_districts d on d.state_id=s.id and d.name='Lakshadweep'
where s.name='Lakshadweep'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='agatti-island' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Bangaram Island','bangaram-island',c.id,s.id,d.id,'Remote tropical island with clear lagoons.','Remote tropical island with clear lagoons.',10.94,72.287,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Island'
left join public.explore_districts d on d.state_id=s.id and d.name='Lakshadweep'
where s.name='Lakshadweep'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='bangaram-island' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Promenade Beach','promenade-beach',c.id,s.id,d.id,'Seafront promenade beside the French Quarter.','Seafront promenade beside the French Quarter.',11.934,79.8354,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Beach'
left join public.explore_districts d on d.state_id=s.id and d.name='Puducherry'
where s.name='Puducherry'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='promenade-beach' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

insert into public.explore_places(name,slug,category_id,state_id,district_id,short_description,full_description,latitude,longitude,best_season,average_rating,entry_fee,visit_hours,status,is_featured)
select 'Auroville','auroville',c.id,s.id,d.id,'International township centred on community and sustainability.','International township centred on community and sustainability.',12.007,79.8106,'Winter',4.6,0,4,'published',true
from public.explore_states s
join public.explore_categories c on c.name='Spiritual'
left join public.explore_districts d on d.state_id=s.id and d.name='Puducherry'
where s.name='Puducherry'
on conflict (slug) do update set
category_id=excluded.category_id,state_id=excluded.state_id,district_id=excluded.district_id,
short_description=excluded.short_description,full_description=excluded.full_description,
latitude=excluded.latitude,longitude=excluded.longitude,best_season=excluded.best_season,status='published';

insert into public.explore_place_images(place_id,image_url,is_primary)
select p.id,'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',true from public.explore_places p
where p.slug='auroville' and not exists(
select 1 from public.explore_place_images i where i.place_id=p.id and i.is_primary=true
);

create index if not exists idx_explore_districts_state on public.explore_districts(state_id);
create index if not exists idx_explore_places_state on public.explore_places(state_id);
create index if not exists idx_explore_places_category on public.explore_places(category_id);
create index if not exists idx_explore_places_status on public.explore_places(status);

select
  (select count(*) from public.explore_states) as states_and_uts,
  (select count(*) from public.explore_districts) as starter_districts,
  (select count(*) from public.explore_places where status='published') as published_places;
