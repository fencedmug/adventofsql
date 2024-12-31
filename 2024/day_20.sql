-- https://adventofsql.com/challenges/20
-- example

-- CREATE TABLE web_requests (
--     request_id SERIAL PRIMARY KEY,
--   url TEXT NOT NULL
-- );

-- INSERT INTO web_requests (url) VALUES
-- ('http://example.com/page?param1=value1¶m2=value2'),
-- ('https://shop.example.com/items?item=toy&color=red&size=small&ref=google&utm_source=advent-of-sql'),
-- ('http://news.example.org/article?id=123&source=rss&author=jdoe&utm_source=advent-of-sql'),
-- ('https://travel.example.net/booking?dest=paris&date=2024-12-19&class=business'),
-- ('http://music.example.com/playlist?genre=pop&duration=long&listener=guest&utm_source=advent-of-sql');

/*
    split string by '?'
    split query params
    combine array into jsonb object

    conditions
    - to contain utm_source=advent-of-sql
    - query params are correct (even number, i.e. recognise every key + value)
*/

with cte as (
    select 
        *, 
        -- split_part(url, '?', 2) as split,
        string_to_array(replace(split_part(url, '?', 2), '=', '&'), '&') as parts
    from web_requests
    where split_part(url, '?', 2) like '%utm_source=advent-of-sql%'
)
select
    *,
    jsonb_object(parts),
    (select count(1) from jsonb_object_keys(jsonb_object(parts))) as keys
from cte
where mod(array_length(parts, 1), 2) = 0
order by keys desc, url asc

-- https://www.postgresql.org/docs/current/functions-string.html
-- split_part
-- string_to_array

-- https://www.postgresql.org/docs/17/functions-json.html
-- jsonb_object