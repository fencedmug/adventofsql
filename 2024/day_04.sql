-- https://adventofsql.com/challenges/4
-- example

DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
  toy_id INT,
  toy_name VARCHAR(100),
  previous_tags TEXT[],
  new_tags TEXT[]
);

INSERT INTO toy_production VALUES
(1, 'Robot', ARRAY['fun', 'battery'], ARRAY['smart', 'battery', 'educational', 'scientific']),
(2, 'Doll', ARRAY['cute', 'classic'], ARRAY['cute', 'collectible', 'classic']),
(3, 'Puzzle', ARRAY['brain', 'wood'], ARRAY['educational', 'wood', 'strategy']);

SELECT * FROM toy_production


/*
  added_tags = new_tags - previous_tags
  unchanged_tags = intersect (new_tags, previous_tags)
  removed_tags = previous_tags - new_tags

  find toy with most added_tags
*/

SELECT 
    toy_id, 
    toy_name, 
    -- ARRAY(SELECT unnest(new_tags) EXCEPT SELECT unnest(previous_tags)) AS added_tags,
    -- ARRAY(SELECT unnest(new_tags) INTERSECT SELECT unnest(previous_tags)) AS unchanged_tags,
    -- ARRAY(SELECT unnest(previous_tags) EXCEPT SELECT unnest(new_tags)) AS removed_tags,
    coalesce(array_length(ARRAY(SELECT unnest(new_tags) EXCEPT SELECT unnest(previous_tags)), 1), 0) AS added,
    coalesce(array_length(ARRAY(SELECT unnest(new_tags) INTERSECT SELECT unnest(previous_tags)), 1), 0) AS unchanged,
    coalesce(array_length(ARRAY(SELECT unnest(previous_tags) EXCEPT SELECT unnest(new_tags)), 1), 0) AS removed
FROM toy_production
ORDER BY added DESC
LIMIT 1;

/*
  ARRAY( ... ) => convert results to array; rows to text[]
  
  EXCEPT: 
  - https://www.postgresql.org/docs/current/queries-union.html
  - find difference between two queries
  
  SELECT unnest(array) 
  - unnest
  - https://www.postgresql.org/docs/current/functions-array.html
  - converts array to rows
  
  coalesce
  - https://www.postgresql.org/docs/current/functions-conditional.html#FUNCTIONS-COALESCE-NVL-IFNULL
  - if null, return 2nd parameter
*/
