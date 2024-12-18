-- https://adventofsql.com/challenges/7
-- example
-- DROP TABLE workshop_elves CASCADE;
-- CREATE TABLE workshop_elves (
--     elf_id SERIAL PRIMARY KEY,
--     elf_name VARCHAR(100) NOT NULL,
--     primary_skill VARCHAR(50) NOT NULL,
--     years_experience INTEGER NOT NULL
-- );

-- INSERT INTO workshop_elves (elf_name, primary_skill, years_experience) VALUES
--     ('Tinker', 'Toy Making', 150),
--     ('Sparkle', 'Gift Wrapping', 75),
--     ('Twinkle', 'Toy Making', 90),
--     ('Holly', 'Cookie Baking', 200),
--     ('Jolly', 'Gift Wrapping', 85),
--     ('Berry', 'Cookie Baking', 120),
--     ('Star', 'Toy Making', 95);

/*
    each pair only return once
    elves cannot pair with themselves
    order by primary_skill
    for dupes, order first by elf_1_id then elf_2_id
*/

/*
    solution 1
    made mistake of not including elf_id in window function
    >> select first_value(elf_id) over (partition by primary_skill order by years_experience desc)
    wrong result because multiple elves have the same max years of experience
    and we are supposed to select the elf with lowest id
*/
with cte as (
    select distinct primary_skill from workshop_elves
)
select 
    (
        select first_value(elf_id) over (partition by primary_skill order by years_experience desc, elf_id)
        from workshop_elves
        where workshop_elves.primary_skill = cte.primary_skill
        limit 1
    ) as elf_1_id
    , (
        select first_value(elf_id) over (partition by primary_skill order by years_experience asc, elf_id)
        from workshop_elves
        where workshop_elves.primary_skill = cte.primary_skill
        limit 1
    ) as elf_2_id
    ,*
from cte
order by primary_skill;


-- solution 2
with cte as (
    select distinct primary_skill from workshop_elves
)
select
    (select elf_id from workshop_elves 
    where workshop_elves.primary_skill = cte.primary_skill
    order by years_experience desc
    limit 1) as elf_1_id
    ,(select elf_id from workshop_elves 
    where workshop_elves.primary_skill = cte.primary_skill
    order by years_experience asc
    limit 1) as elf_2_id
    ,primary_skill
from cte
order by primary_skill
