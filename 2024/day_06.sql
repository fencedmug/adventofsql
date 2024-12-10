-- https://adventofsql.com/challenges/6
-- example
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS gifts CASCADE;
CREATE TABLE children (
    child_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    city VARCHAR(100)
);
CREATE TABLE gifts (
    gift_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    child_id INTEGER REFERENCES children(child_id)
);

INSERT INTO children (name, age, city) VALUES
    ('Tommy', 8, 'London'),
    ('Sarah', 7, 'London'),
    ('James', 9, 'Paris'),
    ('Maria', 6, 'Madrid'),
    ('Lucas', 10, 'Berlin');

INSERT INTO gifts (name, price, child_id) VALUES
    ('Robot Dog', 45.99, 1),
    ('Paint Set', 15.50, 2),
    ('Gaming Console', 299.99, 3),
    ('Book Collection', 25.99, 4),
    ('Chemistry Set', 109.99, 5);

/*
    get average price
    return rows that are above average price
    sort by ascending
*/

select 
    c.name as child_name
    ,g.name as gift_name
    ,g.price as gift_price
from children c
left join gifts g
on c.child_id = g.child_id
where g.price > (
    select 
        avg(price)
    from (
        select 
            g.price
        from children c
        left join gifts g using(child_id)
    )
)
order by g.price asc

/*
    left join gifts g using(child_id)
    - instead of c.child_id = g.child_id
*/
