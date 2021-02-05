SELECT id, geom, statefp, placefp, geoid, name, aland
FROM public.geo_places_indiana;

drop table usa_place_population;

CREATE TABLE usa_place_population (
  id SERIAL,
  sumlev integer,
  state integer,
  county integer,
  place VARCHAR(255),
  cousub integer,
  concit integer,
  primgeo_flag integer,
  funcstat VARCHAR(255),
  name VARCHAR(255),
  stname VARCHAR(255),
  census2010pop VARCHAR(255),
  estimatesbase2010 integer,
  popestimate2010 integer,
  popestimate2011 integer,
  popestimate2012 integer,
  popestimate2013 integer,
  popestimate2014 integer,
  popestimate2015 integer,
  popestimate2016 integer,
  popestimate2017 integer,
  popestimate2018 integer,
  popestimate2019 integer,
  PRIMARY KEY (id)
);

COPY usa_place_population(sumlev,state,county,place,cousub,concit,primgeo_flag,funcstat,name,stname,census2010pop,estimatesbase2010,popestimate2010,popestimate2011,popestimate2012,popestimate2013,popestimate2014,popestimate2015,popestimate2016,popestimate2017,popestimate2018,popestimate2019)
FROM '/tmp/sub-est2019_all.csv'
DELIMITER ','
CSV HEADER;

select place, max(name), max(stname) as stname, max(popestimate2019) as pop2019
from usa_place_population
where stname = 'Indiana'
group by place;

select place, max(stname) as stname, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(max(name), ' city', '' ), ' town', ''), ' (balance)', ''), ' (pt.)', ''), ' village', '')  as name, max(popestimate2019) as pop2019
from usa_place_population
where stname = 'Indiana'
group by place;

select place, max(stname) as stname, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(max(name), ' city', '' ), ' town', ''), ' (balance)', ''), ' (pt.)', ''), ' village', '')  as name, max(popestimate2019) as pop2019
INTO indiana_place_population 
FROM usa_place_population 
where stname = 'Indiana'
group by place;

select * from indiana_place_population;

select 
  geom, 
  placefp, 
  REPLACE(REPLACE(REPLACE(REPLACE(namelsad, ' city', '' ), ' town', ''), ' (balance)', ''),' CDP', '') as name,
  ROUND(ALAND * 0.00000038610, 2) as area_sq_miles,
  CASE WHEN pop2019 is NULL THEN 0 ELSE pop2019 END AS pop_2019,
  CASE WHEN pop2019 is NULL THEN 0 ELSE ROUND(pop2019 / (ALAND * 0.00000038610), 2) END AS pop_density_2019  
from geo_places_indiana indiana
left join indiana_place_population place on place.place = indiana.placefp
order by pop_density_2019 desc;
