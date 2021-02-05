CREATE TABLE usa_place_population (
  id SERIAL,
  sumlev integer,
  state integer,
  county integer,
  place integer,
  cousub integer,
  concit integer,
  primgeo_flag integer,
  funcstat VARCHAR(255),
  name VARCHAR(255),
  stname VARCHAR(255),
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

COPY usa_place_population(sumlev,state,county,place,cousub,concit,primgeo_flag,funcstat,name,stname,estimatesbase2010,popestimate2010,popestimate2011,popestimate2012,popestimate2013,popestimate2014,popestimate2015,popestimate2016,popestimate2017,popestimate2018,popestimate2019)
FROM '/tmp/sub-est2019_all.csv'
DELIMITER ','
CSV HEADER;

select distinct 
	placefp, 
	geom,
	REPLACE(REPLACE(REPLACE(namelsad, ' city', '' ), ' town', ''), ' (balance)', '') as name,
	ROUND(ALAND * 0.00000038610, 2) as area_sq_miles,
	popestimate2019 as pop2019,
	ROUND(popestimate2019 / (ALAND * 0.00000038610), 2) as pop2019density
from geo_places_indiana indiana
left join usa_place_population place on place.name = indiana.namelsad
where place.stname = 'Indiana'
order by placefp;


CREATE TABLE usa_place_population (
  id SERIAL,
  sumlev integer,
  state integer,
  county integer,
  place integer,
  cousub integer,
  concit integer,
  primgeo_flag integer,
  funcstat VARCHAR(255),
  name VARCHAR(255),
  stname VARCHAR(255),
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

COPY usa_place_population(sumlev,state,county,place,cousub,concit,primgeo_flag,funcstat,name,stname,estimatesbase2010,popestimate2010,popestimate2011,popestimate2012,popestimate2013,popestimate2014,popestimate2015,popestimate2016,popestimate2017,popestimate2018,popestimate2019)
FROM '/tmp/sub-est2019_all.csv'
DELIMITER ','
CSV HEADER;

select distinct 
	placefp, 
	geom,
	REPLACE(REPLACE(REPLACE(namelsad, ' city', '' ), ' town', ''), ' (balance)', '') as name,
	ROUND(ALAND * 0.00000038610, 2) as area_sq_miles,
	popestimate2019 as pop2019,
	ROUND(popestimate2019 / (ALAND * 0.00000038610), 2) as pop2019density
from geo_places_indiana indiana
left join usa_place_population place on place.name = indiana.namelsad
where place.stname = 'Indiana'
order by placefp;

select * from 
	(
	  select distinct placefp, geom, REPLACE(REPLACE(REPLACE(namelsad, ' city', '' ), ' town', ''), ' (balance)', '') as name, ROUND(ALAND * 0.00000038610, 2) as area_sq_miles
	  from geo_places_indiana indiana
	  left join usa_place_population place on place.place = cast(indiana.placefp as int8)
	  WHERE namelsad NOT LIKE '%CDP'
	  order by placefp
	) n
left join 
	(
	  select place, max(popestimate2019) as pop2019
	  from usa_place_population
	  where stname = 'Indiana'
	  group by place
	) pop 
	on pop.place = cast(n.placefp as int8);

select place, max(popestimate2019) as pop2019
from usa_place_population
where stname = 'Indiana'
group by place;


select placefp, geom, REPLACE(REPLACE(REPLACE(namelsad, ' city', '' ), ' town', ''), ' (balance)', '') as name, ROUND(ALAND * 0.00000038610, 2) as area_sq_miles
from geo_places_indiana indiana
left join usa_place_population place on place.place = cast(indiana.placefp as int8)
WHERE namelsad NOT LIKE '%CDP'
order by placefp;


select * from usa_place_population;