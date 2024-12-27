-- https://adventofsql.com/challenges/11
-- example

-- CREATE TABLE TreeHarvests (
--     field_name VARCHAR(50),
--     harvest_year INT,
--     season VARCHAR(6),
--     trees_harvested INT
-- );

-- INSERT INTO TreeHarvests VALUES
-- ('Rudolph Ridge', 2023, 'Spring', 150),
-- ('Rudolph Ridge', 2023, 'Summer', 180),
-- ('Rudolph Ridge', 2023, 'Fall', 220),
-- ('Rudolph Ridge', 2023, 'Winter', 300),
-- ('Dasher Dell', 2023, 'Spring', 165),
-- ('Dasher Dell', 2023, 'Summer', 195),
-- ('Dasher Dell', 2023, 'Fall', 210),
-- ('Dasher Dell', 2023, 'Winter', 285);

/*
    order by seasons
    - spring, summer, fall, winter

    show 3 season moving average per field per season per year
    
*/

with cte as (
    select
        *,
        (
            case 
                when season = 'Spring' then 1
                when season = 'Summer' then 2
                when season = 'Fall' then 3
                when season = 'Winter' then 4
                else 0
            end
        ) as season_int
    from TreeHarvests
)
select
    *,
    round(
        avg(trees_harvested) 
        over (
            partition by field_name 
            order by field_name, harvest_year, season_int 
            rows between 2 preceding and current row
        )
    , 2) as moving_avg
from cte
order by moving_avg desc
