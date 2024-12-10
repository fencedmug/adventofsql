-- https://adventofsql.com/challenges/1
-- example

CREATE TABLE children (
  child_id INT PRIMARY KEY,
  name VARCHAR(100),
  age INT
);
CREATE TABLE wish_lists (
  list_id INT PRIMARY KEY,
  child_id INT,
  wishes JSON,
  submitted_date DATE
);
CREATE TABLE toy_catalogue (
  toy_id INT PRIMARY KEY,
  toy_name VARCHAR(100),
  category VARCHAR(50),
  difficulty_to_make INT
);

INSERT INTO children VALUES
(1, 'Tommy', 8),
(2, 'Sally', 7),
(3, 'Bobby', 9);

INSERT INTO wish_lists VALUES
(1, 1, '{"first_choice": "bike", "second_choice": "blocks", "colors": ["red", "blue"]}', '2024-11-01'),
(2, 2, '{"first_choice": "doll", "second_choice": "books", "colors": ["pink", "purple"]}', '2024-11-02'),
(3, 3, '{"first_choice": "blocks", "second_choice": "bike", "colors": ["green"]}', '2024-11-03');

INSERT INTO toy_catalogue VALUES
(1, 'bike', 'outdoor', 3),
(2, 'blocks', 'educational', 1),
(3, 'doll', 'indoor', 2),
(4, 'books', 'educational', 1);

/*
  difficulty_to_make:
    1 =  Simple Gift
    2 =  Moderate Gift
    3 >= Complex Gift
  
  category:
    outdoor = Outside Workshop
    educational = Learning Workshop
    all other types = General Workshop

  order by child name ascending
    name,primary_wish,backup_wish,favorite_color,color_count,gift_complexity,workshop_assignment
*/


SELECT 
  c.name, 
  w.wishes ->> 'first_choice', 
  w.wishes ->> 'second_choice', 
  w.wishes -> 'colors' ->> 0, 
  (
    SELECT json_array_length(w.wishes -> 'colors')
  ), 
  (
    CASE 
      WHEN t.difficulty_to_make = 1 THEN 'Simple Gift' 
      WHEN t.difficulty_to_make = 2 THEN 'Moderate Gift' 
      ELSE 'Complex Gift' 
    END
  ), 
  (
    CASE 
      WHEN t.category = 'outdoor' THEN 'Outside Workshop' 
      WHEN t.category = 'educational' THEN 'Learning Workshop' 
      ELSE 'General Workshop' 
    END
  ) 
FROM 
  children c 
  LEFT JOIN wish_lists w ON c.child_id = w.child_id 
  LEFT JOIN toy_catalogue t ON w.wishes ->> 'first_choice' = t.toy_name 
ORDER BY 
  c.name ASC 
LIMIT 
  5

/*
  jsonb_path_query
  - https://www.postgresql.org/docs/current/functions-json.html#FUNCTIONS-SQLJSON-PATH
  
  accessing json
  - w.wishes->>'fieldname'
  - -> will show quotes
  - ->> will show string without quotes

  joining with json fields need to convert json to correct data type
  hence ->> in w.wishes->>'first_choice' = t.toy_name
*/