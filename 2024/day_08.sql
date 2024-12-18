-- https://adventofsql.com/challenges/8
-- example
-- create table staff (
--     staff_id int primary key,
--     staff_name varchar(100) not null,
--     manager_id int,
--     foreign key (manager_id) references staff(staff_id)
-- );

-- insert into staff (staff_id, staff_name, manager_id) values
--     (1, 'santa claus', null),                -- ceo level
--     (2, 'head elf operations', 1),           -- department head
--     (3, 'head elf logistics', 1),            -- department head
--     (4, 'senior toy maker', 2),              -- team lead
--     (5, 'senior gift wrapper', 2),           -- team lead
--     (6, 'inventory manager', 3),             -- team lead
--     (7, 'junior toy maker', 4),              -- staff
--     (8, 'junior gift wrapper', 5),           -- staff
--     (9, 'inventory clerk', 6),               -- staff
--     (10, 'apprentice toy maker', 7);         -- entry level

/*
    find most over-managed employee (most levels)
    order by number of levels desc
*/


-- select * from staff;

with recursive cte as (
    -- anchor query
    select 
        staff_id,
        staff_name,
        1 as level,
        array[1] as path
    from staff
    where staff_id = 1

    union all
    -- recursive query
    select 
        staff.staff_id,
        staff.staff_name,
        array_length(cte.path || array[staff.staff_id], 1) as level,
        cte.path || array[staff.staff_id] as path
    from staff
    inner join cte on staff.manager_id = cte.staff_id
    where staff.staff_id <= (select max(staff_id) from staff)
)
select * from cte
 order by level desc;

/*
    docs: https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE

    recursive cte
    - anchor query provides the first row
    - recursive query builds row based on previous cte
        - if current cte is staff id = 4, previous cte will contain rows from staff id = 3
        - this hint comes from example results, 10 rows of staff (no staff id was repeated)

    1st round - get staff with manager id = 1
    2nd round - get staff with manager id in cte (which is 1)
    3rd round - get staff with manager id in cte (which is 1 + 2nd round's staff id)
*/