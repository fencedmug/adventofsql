-- https://adventofsql.com/challenges/3
-- example
DROP TABLE IF EXISTS christmas_menus CASCADE;

CREATE TABLE christmas_menus (
  id SERIAL PRIMARY KEY,
  menu_data XML
);

INSERT INTO christmas_menus (id, menu_data) VALUES
(1, '<menu version="1.0">
    <dishes>
        <dish>
            <food_item_id>99</food_item_id>
        </dish>
        <dish>
            <food_item_id>102</food_item_id>
        </dish>
    </dishes>
    <total_count>80</total_count>
</menu>');

INSERT INTO christmas_menus (id, menu_data) VALUES
(2, '<menu version="2.0">
    <total_guests>85</total_guests>
    <dishes>
        <dish_entry>
            <food_item_id>101</food_item_id>
        </dish_entry>
        <dish_entry>
            <food_item_id>102</food_item_id>
        </dish_entry>
    </dishes>
</menu>');

INSERT INTO christmas_menus (id, menu_data) VALUES
(3, '<menu version="beta">
  <guestCount>15</guestCount>
  <foodList>
      <foodEntry>
          <food_item_id>102</food_item_id>
      </foodEntry>
  </foodList>
</menu>');

/*
  - more than 78 guests
  - xml schema not consistent
*/

with cte as (
    select 
        unnest(xpath('//food_item_id/text()', menu_data)::text[]) as food_item_id
        ,xpath('//*[contains(local-name(), "total")]', menu_data)
    from christmas_menus
    where 
        xpath_exists('//*[contains(local-name(), "total")]', menu_data)
        and (xpath('//*[contains(local-name(), "total")]/text()', menu_data))[1]::text::int > 78
)
select food_item_id, count(*) from cte
group by food_item_id
order by count(*) desc

/*
  xpath
  - //food_item_id/text() -> get all food_item_id elements
  - //*[contains(local-name(), "total")] -> get all elements where name contains "total"
  - xpath returns xml[]

  xpath(...)::text[] -> cast to text[]
  unnest(...) unroll array to rows of results

*/