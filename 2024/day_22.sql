-- https://adventofsql.com/challenges/22
-- example

-- DROP TABLE IF EXISTS elves CASCADE;
-- CREATE TABLE elves (
--     id SERIAL PRIMARY KEY,
--     elf_name VARCHAR(255) NOT NULL,
--     skills TEXT NOT NULL
-- );

-- INSERT INTO elves (elf_name, skills)
-- VALUES 
--     ('Eldrin', 'Elixir,Python,C#,JavaScript,MySQL'),    -- 4 programming skills
--     ('Faenor', 'C++,Ruby,Kotlin,Swift,Perl'),           -- 5 programming skills
--     ('Luthien', 'PHP,TypeScript,Go,SQL');               -- 4 programming skills


-- find elves with skill 'SQL'
select
    elf_name,
    string_to_array(skills, ',') as skills_array,
    count(*) over ()
from elves
where 'SQL' = any(string_to_array(skills, ','))

-- any function
-- https://www.postgresql.org/docs/current/functions-comparisons.html#FUNCTIONS-COMPARISONS-ANY-SOME

-- string_to_array function
-- https://www.postgresql.org/docs/current/functions-string.html#FUNCTION-STRING-TO-ARRAY
