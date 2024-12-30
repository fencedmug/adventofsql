-- https://adventofsql.com/challenges/19
-- example

-- CREATE TABLE employees (
--     employee_id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     salary DECIMAL(10, 2) NOT NULL,
--     year_end_performance_scores INTEGER[] NOT NULL
-- );

-- INSERT INTO employees (name, salary, year_end_performance_scores) VALUES
-- ('Alice Johnson', 75000.00, ARRAY[85, 90, 88, 92]),
-- ('Bob Smith', 68000.00, ARRAY[78, 82, 80, 81]),
-- ('Charlie Brown', 72000.00, ARRAY[91, 89, 94, 96]),
-- ('Dana White', 64000.00, ARRAY[70, 75, 73, 72]),
-- ('Eliot Green', 70000.00, ARRAY[88, 85, 90, 87]);

/*
    bonus = 15% of salary
    last performance score must be above average
*/

with cte as (
    select 
        *,
        year_end_performance_scores[array_length(year_end_performance_scores, 1)] as last,
        avg(year_end_performance_scores[array_length(year_end_performance_scores, 1)]) over (),
        (
            case
                when year_end_performance_scores[array_length(year_end_performance_scores, 1)] > (avg(year_end_performance_scores[array_length(year_end_performance_scores, 1)]) over ()) then salary * 1.15
                else salary
            end
        ) as total_salary
    from employees
)
select round(sum(total_salary), 2)
from cte
