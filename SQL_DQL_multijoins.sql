-- SQL joins

-- Two tables that share a column (usually a Foreign Key in one)
-- Therefore we can join their info on that shared column
select * from actor;
select * from film_actor;

-- syntax: DQL - two clauses (or more) added to a SELECT query
-- pick a primary table (A) and a secondary table (B)
-- SELECT <columns*>
-- FROM <table A>
-- JOIN <table B>
-- ON <table_A.column> = <table_B.column>;

-- *if a column has the same name in both tables, we must specify which table's column of that name we are selecting
	-- using dot notation <table.column>
select actor.actor_id, film_id, first_name, last_name
from actor
join film_actor
on film_actor.actor_id = actor.actor_id;

-- Let's look back at our Day 1 homework and a few questions that were answered in multiple queries:
-- 3. What film does the store have the most of? (search in inventory)
select film_id, count(film_id)
from inventory
group by film_id
order by count(film_id) desc;
-- The store owns 9 copies of Film ID 200.
-- Which film is that?
select *
from film
where film_id = 200;
-- The film is a boring reflection of a dentist and a mad cow who must chase a secret agent in a shark tank.... what?

-- What film does the store have the most of (including film names)? Use join!
select count(inventory.film_id), inventory.film_id, film.title, film.description
from inventory
join film
on inventory.film_id = film.film_id
group by inventory.film_id, film.title, film.description
order by count(inventory.film_id) desc
limit 1;
-- the join occurs before the aggregate so the column selection in the aggregate actually does not matter!
	-- but we must select one table or the other's column otherwise we get a column is ambiguous error

-- In-class exercise:
-- Are there any actors who appear in zero films? A join between the actor table and the film_actor table
select actor.actor_id, actor.first_name, actor.last_name, film_actor.film_id
from actor
left join film_actor
on actor.actor_id = film_actor.actor_id
where film_actor.film_id is null;

-- Film_Actor table is an intermediary table between the film table and the actor table
-- So, we can actually multijoin the film_actor, actor, and film tables together
-- to get actor information and film information together in the same query

