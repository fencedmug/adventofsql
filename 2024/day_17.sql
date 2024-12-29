-- https://adventofsql.com/challenges/17
-- example

-- CREATE TABLE Workshops (
--     workshop_id INT PRIMARY KEY,
--     workshop_name VARCHAR(100),
--     timezone VARCHAR(50),
--     business_start_time TIME,
--     business_end_time TIME
-- );

-- INSERT INTO Workshops (workshop_id, workshop_name, timezone, business_start_time, business_end_time) VALUES
-- (1, 'North Pole HQ', 'UTC', '09:00', '17:00'),
-- (2, 'London Workshop', 'Europe/London', '09:00', '17:00'),
-- (3, 'New York Workshop', 'America/New_York', '09:00', '17:00');

select * from pg_timezone_names where name = 'America/New_York';
with cte as (
    select 
        workshop_name,
        timezone,
        utc_offset,
        business_start_time,
        business_end_time,
        business_start_time - utc_offset as utc_start,
        business_end_time - utc_offset as utc_end
    from Workshops
    left join pg_timezone_names zone on Workshops.timezone = zone.name
)
select
    max(utc_start),
    min(utc_end)
from cte

-- obtained correct answer but dataset doesn't make sense
