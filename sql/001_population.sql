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


-- indiana state
SELECT 
  geom,
  statefp,
  geoid,
  stusps,
  name,
  aland,
  awater
FROM public.geo_state_raw
where statefp = '18';

-- indiana counties
SELECT
  geom, 
  statefp,
  countyfp,
  geoid,
  name,
  aland,
  awater
 FROM public.geo_county_raw
 where statefp = '18';

--indiana county persons per hospital
select 
  county.geom,
  county.name, 
  max(pop.pop_2019) as pop_2019,
  count(hospitals.geom) as animal_hospital_count,
  CASE 
    WHEN count(hospitals.geom) = 0 
    THEN max(pop.pop_2019) 
    ELSE max(pop.pop_2019) / count(hospitals.geom) 
  END
  AS persons_per_hospital
from geo_county_raw county
left join population_county pop on pop.name = CONCAT(county.name, ' County')
left join geo_animal_hospitals_usa as hospitals 
  on ST_WITHIN(ST_Transform(hospitals.geom, 4326), ST_Transform(county.geom, 4326))
where pop.state_name = 'Indiana'
and county.statefp = '18'
group by county.geom, county.name
order by persons_per_hospital desc;


CREATE TABLE population_county (
  id SERIAL,
  statefp VARCHAR(2),
  state_name VARCHAR(255),
  name VARCHAR(255),
  type VARCHAR(100),
  pop_2019 integer,
  PRIMARY KEY (id)
);