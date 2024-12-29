-- https://adventofsql.com/challenges/18
-- example 

-- CREATE TABLE staff (
--     staff_id INT PRIMARY KEY,
--     staff_name VARCHAR(100) NOT NULL,
--     manager_id INT,
--     FOREIGN KEY (manager_id) REFERENCES Staff(staff_id)
-- );

-- INSERT INTO staff (staff_id, staff_name, manager_id) VALUES
--     (1, 'Santa Claus', NULL),                -- CEO level
--     (2, 'Head Elf Operations', 1),           -- Department Head
--     (3, 'Head Elf Logistics', 1),            -- Department Head
--     (4, 'Senior Toy Maker', 2),              -- Team Lead
--     (5, 'Senior Gift Wrapper', 2),           -- Team Lead
--     (6, 'Inventory Manager', 3),             -- Team Lead
--     (7, 'Junior Toy Maker', 4),              -- Staff
--     (8, 'Junior Gift Wrapper', 5),           -- Staff
--     (9, 'Inventory Clerk', 6),               -- Staff
--     (10, 'Apprentice Toy Maker', 7);         -- Entry Level

/*
    peers_same_manager
    - number of people with same manager_id

    total_peers_same_level 
    - number of people with same no. of paths to current level

    find
    - most peers
    - lowest level
    - staff_id as
*/

with recursive cte as (
    -- anchor query
    select 
        staff_id,
        staff_name,
        manager_id,
        1 as level,
        array[1] as path
    from staff
    where staff_id = 1

    union all
    -- recursive query
    select 
        staff.staff_id,
        staff.staff_name,
        staff.manager_id,
        array_length(cte.path || array[staff.staff_id], 1) as level,
        cte.path || array[staff.staff_id] as path
    from staff
    inner join cte on staff.manager_id = cte.staff_id
    where staff.staff_id <= (select max(staff_id) from staff)
)
select 
    *,
    -- (select count(1) from staff where staff.manager_id = cte.manager_id) as peers_same_manager,
    count(1) over (partition by manager_id) as peers_same_manager_v2,
    count(1) over (partition by level) as total_peers_same_level
from 
    cte
order by 
    total_peers_same_level desc,
    level asc,
    staff_id asc;

-- todo:
-- look into optimizing performance
