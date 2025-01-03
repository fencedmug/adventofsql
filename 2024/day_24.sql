-- https://adventofsql.com/challenges/24
-- example

-- CREATE TABLE users (
--     user_id INT PRIMARY KEY,
--     username VARCHAR(255) NOT NULL
-- );
-- CREATE TABLE songs (
--     song_id INT PRIMARY KEY,
--     song_title VARCHAR(255) NOT NULL,
--     song_duration INT  -- Duration in seconds, can be NULL if unknown
-- );
-- CREATE TABLE user_plays (
--     play_id INT PRIMARY KEY,
--     user_id INT,
--     song_id INT,
--     play_time DATE,
--     duration INT,  -- Duration in seconds, can be NULL
--     FOREIGN KEY (user_id) REFERENCES users(user_id),
--     FOREIGN KEY (song_id) REFERENCES songs(song_id)
-- );

-- -- Inserting data into users table
-- INSERT INTO users (user_id, username) VALUES (1, 'alice');
-- INSERT INTO users (user_id, username) VALUES (2, 'bob');
-- INSERT INTO users (user_id, username) VALUES (3, 'carol');

-- -- Inserting data into songs table, including a song with a NULL duration
-- INSERT INTO songs (song_id, song_title, song_duration) VALUES (1, 'Jingle Bells', 180);
-- INSERT INTO songs (song_id, song_title, song_duration) VALUES (2, 'Silent Night', NULL); -- NULL duration
-- INSERT INTO songs (song_id, song_title, song_duration) VALUES (3, 'Deck the Halls', 150);

-- -- Inserting example play records into user_plays table, including NULL durations
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (1, 1, 1, '2024-12-22', 180);  -- Full play
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (2, 2, 1, '2024-12-22', 100);  -- Skipped
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (3, 3, 2, '2024-12-22', NULL); -- NULL duration (unknown play)
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (4, 1, 2, '2024-12-23', 180);  -- Valid duration, but song duration unknown
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (5, 2, 2, '2024-12-23', NULL); -- NULL duration
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (6, 3, 3, '2024-12-23', 150);  -- Full play

-- -- Additional plays with NULLs and shorter durations
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (7, 1, 3, '2024-12-23', 150);  -- Full play
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (8, 2, 3, '2024-12-22', 140);  -- Skipped
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (9, 3, 1, '2024-12-23', NULL); -- NULL duration
-- INSERT INTO user_plays (play_id, user_id, song_id, play_time, duration) VALUES (10, 1, 3, '2024-12-22', NULL); -- NULL duration

-- select * from users;
-- select * from songs;
-- select * from user_plays;

/*
    user_plays
    - duration < song duration --> skipped
    - assume duration is null as skipped

    order by most plays, least skips
*/

with cte as (
    select
        *,
        (
            case
                when duration < song_duration then 1
                when duration is null then 1
                else 0
            end
        ) as skipped
    from user_plays
    left join songs using(song_id)
)
select
    song_title,
    count(*) as played,
    sum(skipped) as skipped
from cte
group by song_title
order by played desc, skipped desc;


-- alternative
select
    song_title,
    count(*) as plays,
    count(*) filter (
        where user_plays.duration is null 
        or user_plays.duration < songs.song_duration) as skips
from user_plays
left join songs using(song_id)
group by song_title
order by plays desc, skips desc;

-- aggregate filters
-- https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-AGGREGATES
