-- https://adventofsql.com/challenges/21
-- example

-- CREATE TABLE sales (
--     id SERIAL PRIMARY KEY,
--     sale_date DATE NOT NULL,
--     amount DECIMAL(10, 2) NOT NULL
-- );

-- INSERT INTO sales (sale_date, amount) VALUES ('2024-01-10', 3500.25);
-- INSERT INTO sales (sale_date, amount) VALUES ('2023-01-15', 1500.50);
-- INSERT INTO sales (sale_date, amount) VALUES ('2023-04-20', 2000.00);
-- INSERT INTO sales (sale_date, amount) VALUES ('2023-07-12', 2500.75);
-- INSERT INTO sales (sale_date, amount) VALUES ('2023-10-25', 3000.00);

-- find growth percent current over previous quarter
with cte as (
    select
        extract(year from sale_date) as year,
        extract(quarter from sale_date) as quarter,
        sum(amount) as total
    from sales
    group by year, quarter
)
select
    concat(year::text, ',', quarter::text),
    total,
    lag(total) over (order by year, quarter),
    (total - lag(total) over (order by year, quarter)) / (lag(total) over (order by year, quarter)) as growth_rate
from cte
order by growth_rate desc nulls last

-- extract function
-- https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT
