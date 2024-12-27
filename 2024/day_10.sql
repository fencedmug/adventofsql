-- https://adventofsql.com/challenges/10
-- example

-- DROP TABLE IF EXISTS Drinks CASCADE;
-- CREATE TABLE Drinks (
--     drink_id SERIAL PRIMARY KEY,
--     drink_name VARCHAR(50) NOT NULL,
--     date DATE NOT NULL,
--     quantity INTEGER NOT NULL
-- );

-- INSERT INTO Drinks (drink_name, date, quantity) VALUES
--     ('Eggnog', '2024-12-24', 50),
--     ('Eggnog', '2024-12-25', 60),
--     ('Hot Cocoa', '2024-12-24', 75),
--     ('Hot Cocoa', '2024-12-25', 80),
--     ('Peppermint Schnapps', '2024-12-24', 30),
--     ('Peppermint Schnapps', '2024-12-25', 40);


-- solution 1 - using group by + sum filter
with cte as (
    select 
        date,
        sum(quantity) filter (where drink_name = 'Eggnog') as Eggnog,
        sum(quantity) filter (where drink_name = 'Hot Cocoa') as HotCocoa,
        sum(quantity) filter (where drink_name = 'Peppermint Schnapps') as PeppermintSchnapps
    from Drinks
    group by date
    order by date
)
select * from cte
where HotCocoa = 38 and PeppermintSchnapps = 298 and Eggnog = 198;


-- solution 2 - using postgre's crosstab function
-- https://www.postgresql.org/docs/current/tablefunc.html#TABLEFUNC-FUNCTIONS-CROSSTAB-TEXT
-- query must return 1 row_name, 1 category and 1 value

-- to enable extension to us crosstab
-- CREATE EXTENSION tablefunc;

select *
from crosstab(
    'select date, drink_name, sum(quantity) from Drinks 
    group by date, drink_name
    order by date, drink_name'
) as ct(date DATE, "Eggnog" bigint, "Hot Cocoa" bigint, "Peppermint Schnapps" bigint)
where HotCocoa = 38 and PeppermintSchnapps = 298 and Eggnog = 198;
order by date

-- additional notes
--   double quotes "something" => identifiers
--   single quotes 'another' => strings
-- https://www.postgresql.org/docs/current/sql-syntax-lexical.html

-- sum (integer) return bigint
-- had to make this change:
--   ct(date DATE, "Eggnog" int, ...) to ct(date DATE, "Eggnog" bigint, ...)
