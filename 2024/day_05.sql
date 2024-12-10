DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
    production_date DATE PRIMARY KEY,
    toys_produced INTEGER
);

INSERT INTO toy_production (production_date, toys_produced) VALUES
('2024-12-18', 500),
('2024-12-19', 550),
('2024-12-20', 525),
('2024-12-21', 600),
('2024-12-22', 580),
('2024-12-23', 620),
('2024-12-24', 610);


-- cte is not needed, just for shorthand "previous" purpose
with cte as (
    select 
        *
        ,lag(toys_produced) over (order by production_date) as previous
    from toy_production
)
select
    *
    , toys_produced - previous as change
    , round((toys_produced - previous)::numeric / previous * 100, 2) as percent
from cte
order by percent desc nulls last

/*
    window function
    - lag(..)
    - https://www.postgresql.org/docs/current/functions-window.html
    - https://www.postgresql.org/docs/current/tutorial-window.html

    show nulls at btm of table
    - order by ...desc nulls last

    round(...)
    - only takes numeric
    - need to cast to numeric before use
*/