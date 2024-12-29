-- https://adventofsql.com/challenges/14
-- example

-- CREATE TABLE SantaRecords (
--     record_id INT PRIMARY KEY,
--     record_date DATE,
--     cleaning_receipts JSONB
-- );

-- INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES 
-- (1, '2024-11-25', '[
--     {
--         "receipt_id": "R120",
--         "garment": "hat",
--         "color": "red",
--         "cost": 15.99,
--         "drop_off": "2024-11-25",
--         "pickup": "2024-11-27"
--     },
--     {
--         "receipt_id": "R121",
--         "garment": "mittens",
--         "color": "white",
--         "cost": 12.99,
--         "drop_off": "2024-11-25",
--         "pickup": "2024-11-27"
--     }
-- ]');

-- INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES 
-- (2, '2024-12-01', '[
--     {
--         "receipt_id": "R122",
--         "garment": "suit",
--         "color": "red",
--         "cost": 25.99,
--         "drop_off": "2024-12-01",
--         "pickup": "2024-12-03"
--     },
--     {
--         "receipt_id": "R123",
--         "garment": "boots",
--         "color": "black",
--         "cost": 18.99,
--         "drop_off": "2024-12-01",
--         "pickup": "2024-12-03"
--     }
-- ]');

-- -- Here's the record with the green suit
-- INSERT INTO SantaRecords (record_id, record_date, cleaning_receipts) VALUES 
-- (3, '2024-12-10', '[
--     {
--         "receipt_id": "R124",
--         "garment": "suit",
--         "color": "green",
--         "cost": 29.99,
--         "drop_off": "2024-12-10",
--         "pickup": "2024-12-12"
--     },
--     {
--         "receipt_id": "R125",
--         "garment": "scarf",
--         "color": "green",
--         "cost": 10.99,
--         "drop_off": "2024-12-10",
--         "pickup": "2024-12-12"
--     }
-- ]');


-- convert json array to each element using jsonb_array_elements(..)
-- lateral join main table with json array elements
-- 

select
    record_date,
    value as receipt
from
    SantaRecords,
    jsonb_array_elements(cleaning_receipts)
where
    value->>'color' = 'green' and value->>'garment' = 'suit'
order by 
    record_date desc;



-- alternate solution
select
    *
from
    SantaRecords
where
    exists (
        select *
        from jsonb_array_elements(cleaning_receipts) as jdoc
        where jdoc->>'color' = 'green' and jdoc->>'garment' = 'suit'
    )
order by 
    record_date desc;
