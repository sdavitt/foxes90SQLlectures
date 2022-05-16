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

-- film_actor table, actor table, and film table are all related
	-- actors and films have a many-to-many relationship which is maintained by the existence of the film_actor table
	-- if an actor is in a specific film, their actor_id appears alongside a film_id in the film_actor table
	-- that way aside from IDs, there is no duplicate data for films or actors
-- How do we join these three tables?
	-- actor has actor_id
	-- film_actor has actor_id
	-- therefore we can join them together creating a table with actor information and film_ids from film_actor
	-- film has film_ids...
	-- therefore we can join film onto the joined result of actor and film_actor

-- before we do the multijoin, lets look at the two joins separately
select actor.first_name, actor.last_name, actor.actor_id, film_actor.film_id
from actor
full join film_actor
on actor.actor_id = film_actor.actor_id;

select film_actor.actor_id, film_actor.film_id, film.title, film.description
from film_actor
full join film
on film.film_id = film_actor.film_id;

-- All there is to a multijoin is the addition of another join + on clause as long as that join + on clause makes sense
	-- given the result of the preceding join
select actor.first_name, actor.last_name, actor.actor_id, film_actor.film_id, film.title, film.description
from actor
full join film_actor
on actor.actor_id = film_actor.actor_id
full join film
on film.film_id = film_actor.film_id;

-- Sometimes the information we want is spread across many tables to avoid copies of data (aka the database is normalized)

-- Produce a query showing the first name, last name, and email of all customers living in Angola
-- first figure out where this information is held
select * from customer; -- first_name, last_name, email
select * from country; -- country names
select * from city;
-- customer table has FK to address table
-- address table has FK to city table
-- city table has FK to country table

-- if we want to query our customers by the country they live in, we must join the address table onto the customer table
-- then the city table onto the address table
-- then the country table onto the city table
select customer.first_name, customer.last_name, address.address, city.city, country.country
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where country.country = 'Angola';

-- An alternative approach to a query in multiple tables and a useful approach for certain more complex queries
-- SubQueries!
-- We can turn an entire separate query into the condition of a where clause of another query
-- Essentially, we can filter the results of a select statement by the results of another select statement
-- We can filter a table by another table's contents, we can filter a table by the result of an aggregate without selecting that aggregate or using a groupby

-- I want to write a query providing me with customer information (first_name, last_name, etc.)
-- for every customer who has spent more than $175

-- we're asking for data from the customer table
-- but only if it meets criteria from the payment table
-- we could do this with a join
-- it could be done with two separate queries
-- or we could do it with a subquery

-- separate queries example:
select * from customer;

select customer_id, sum(amount)
from payment
group by customer_id
having sum(amount) > 175;

-- join version:
select customer.customer_id, customer.first_name, customer.last_name
from customer
join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id, customer.first_name, customer.last_name
having sum(payment.amount) > 175
order by customer.customer_id;

-- subquery version
select customer_id, first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
)
order by customer.customer_id;

-- key difference between a join and a subquery:
	-- the join's result will/can have data from both tables
	-- the subquery's result will only have data from the outer query's table
-- A subquery can only select a single column- this must be the column specified right before the subquery (or the equivalent)
	-- usually, this would be the column used in the ON clause of a join (aka a foreign key)

select * from film;

select * from language;

-- I could use a subquery to filter my film table by the films having a language of English
	-- this subquery is rather pointless-> i could just say where language_id = 1
select *
from film
where language_id in (
	select language_id
	from language
	where name = 'English'
);

-- Another subquery example:
-- Actor data for an actor who appeared in at least 30 films
select actor_id, first_name, last_name
from actor
where actor_id in (
	select actor_id
	from film_actor
	group by actor_id
	having count(film_id) >= 30
);

-- In class exercise #2:
-- I want to know the name, address, city, and country of any customer who spent more than $175
-- multijoin and a subquery
-- hint: combine the previous multijoin and subquery examples :)
select customer.first_name, customer.last_name, address.address, city.city, country.country
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
);

-- Altering data: DML
-- What if I have a value in my database that is not what I intended
select * from actor where last_name = 'Dith';

-- update command
-- can be used to update all rows in a column or only specific rows from a column
-- I want to change first_name, last_name of Smylan Dith
-- to Dylan Smith
update actor
set first_name = 'Dylan'
where first_name = 'Smylan';

update actor
set last_name = 'Smith'
where last_name = 'Dith';

select * from actor where first_name = 'Dylan';

-- UPDATE <table>
-- SET <column> = <new_value>
-- WHERE <condition>;