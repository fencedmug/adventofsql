-- https://adventofsql.com/challenges/7
-- example
DROP TABLE workshop_elves CASCADE;
CREATE TABLE workshop_elves (
    elf_id SERIAL PRIMARY KEY,
    elf_name VARCHAR(100) NOT NULL,
    primary_skill VARCHAR(50) NOT NULL,
    years_experience INTEGER NOT NULL
);

INSERT INTO workshop_elves (elf_name, primary_skill, years_experience) VALUES
    ('Tinker', 'Toy Making', 150),
    ('Sparkle', 'Gift Wrapping', 75),
    ('Twinkle', 'Toy Making', 90),
    ('Holly', 'Cookie Baking', 200),
    ('Jolly', 'Gift Wrapping', 85),
    ('Berry', 'Cookie Baking', 120),
    ('Star', 'Toy Making', 95);

