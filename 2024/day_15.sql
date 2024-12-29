-- https://adventofsql.com/challenges/15
-- example

-- CREATE EXTENSION postgis;

-- CREATE TABLE sleigh_locations (
--     id SERIAL PRIMARY KEY,
--     timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
--     coordinate GEOGRAPHY(POINT) NOT NULL
-- );

-- CREATE TABLE areas (
--     id SERIAL PRIMARY KEY,
--     place_name VARCHAR(255) NOT NULL,
--     polygon GEOGRAPHY(POLYGON) NOT NULL
-- );

-- INSERT INTO sleigh_locations (timestamp, coordinate) VALUES
--     ('2024-12-24 22:00:00+00', ST_SetSRID(ST_Point(-73.985130, 40.758896), 4326)), -- Times Square, New York
--     ('2024-12-24 23:00:00+00', ST_SetSRID(ST_Point(-118.243683, 34.052235), 4326)), -- Downtown Los Angeles
--     ('2024-12-25 00:00:00+00', ST_SetSRID(ST_Point(139.691706, 35.689487), 4326)); -- Tokyo

-- INSERT INTO areas (place_name, polygon) VALUES
--     ('New_York', ST_SetSRID(ST_GeomFromText('POLYGON((-74.25909 40.477399, -73.700272 40.477399, -73.700272 40.917577, -74.25909 40.917577, -74.25909 40.477399))'), 4326)),
--     ('Los_Angeles', ST_SetSRID(ST_GeomFromText('POLYGON((-118.668176 33.703652, -118.155289 33.703652, -118.155289 34.337306, -118.668176 34.337306, -118.668176 33.703652))'), 4326)),
--     ('Tokyo', ST_SetSRID(ST_GeomFromText('POLYGON((138.941375 35.523222, 140.68074 35.523222, 140.68074 35.898782, 138.941375 35.898782, 138.941375 35.523222))'), 4326));


-- using postgis image for this exercise

select * from sleigh_locations;
select * from areas;

select 
    timestamp,
    place_name
from 
    sleigh_locations loc, 
    areas
where 
    st_intersects(loc.coordinate, areas.polygon)
