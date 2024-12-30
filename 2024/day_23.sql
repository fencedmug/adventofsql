-- https://adventofsql.com/challenges/23
-- example

-- CREATE TABLE sequence_table (
--     id INT PRIMARY KEY
-- );

-- INSERT INTO sequence_table (id) VALUES 
--     (1),
--     (2),
--     (3),
--     (7),
--     (8),
--     (9),
--     (11),
--     (15),
--     (16),
--     (17),
--     (22);

/*
    find gaps between numbers
    count only numbers not listed in ids
*/

with cte as (
    select 
        *,
        lead(id) over (order by id) as next,
        id + 1 as gap_start,
        lead(id) over (order by id) - 1 as gap_end
    from sequence_table
    order by id
)
select 
    *,
    (select array_agg(nums) from generate_series(gap_start, gap_end) as nums)
from cte
where (gap_end - gap_start) >= 0


-- generate_series
-- https://www.postgresql.org/docs/current/functions-srf.html#FUNCTIONS-SRF

-- array_agg
-- https://www.postgresql.org/docs/current/functions-aggregate.html#FUNCTIONS-AGGREGATE
