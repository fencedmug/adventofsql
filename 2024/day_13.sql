-- https://adventofsql.com/challenges/13
-- example

-- CREATE TABLE contact_list (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     email_addresses TEXT[] NOT NULL
-- );

-- INSERT INTO contact_list (name, email_addresses) VALUES
-- ('Santa Claus', 
--  ARRAY['santa@northpole.com', 'kringle@workshop.net', 'claus@giftsrus.com']),
-- ('Head Elf', 
--  ARRAY['supervisor@workshop.net', 'elf1@northpole.com', 'toys@workshop.net']),
-- ('Grinch', 
--  ARRAY['grinch@mountcrumpit.com', 'meanie@whoville.org']),
-- ('Rudolph', 
--  ARRAY['red.nose@sleigh.com', 'rudolph@northpole.com', 'flying@reindeer.net']);

-- select * from contact_list;
with cte as (
    select 
        *,
        split_part(email, '@', 2) as domain 
    from 
        contact_list, 
        unnest(email_addresses) as email
        -- implicit lateral join here
)
select 
    domain,
    count(*),
    array_agg(distinct email)
from cte
group by domain
order by count(*) desc

-- lateral joins
-- https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-LATERAL
