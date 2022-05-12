-- SQL Day 1 Homework
-- DQL practice

-- 1. How many actors are there with the last name ‘Wahlberg’?
select *
from actor
where last_name = 'Wahlberg';
-- There are two actors with the last name Wahlberg.
select count(last_name)
from actor
where last_name = 'Wahlberg';
-- aggregate count agrees - 2 Wahlbergs
select last_name, count(last_name)
from actor
where last_name = 'Wahlberg'
group by last_name;
-- more complete query showing both the last_name in question and its count

-- 2. How many payments were made between $3.99 and $5.99?
select count(payment_id) 
from payment
where amount between 3.99 and 5.99;
-- 5,561 payments between 3.99 and 5.99 inclusive (if using BETWEEN or >= and <=)
-- 3,412 payments between 3.99 and 5.99 exclusive (using > and <)

select * from inventory;
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

-- 4. How many customers have the last name ‘William’?
select count(last_name)
from customer
where last_name like 'William';
-- Zero. But there is one customer with the last name 'Williams'.

select * from customer;
-- 5. What store employee (get the id) sold the most rentals?
-- we have two options for answering this question
	-- count of staff_ids within the payment table
	-- or count of staff_ids within the rental table
-- rental table
select staff_id, count(staff_id)
from rental
group by staff_id
order by count(staff_id) desc;
-- according to the rental table, staff_id 1 has the most rentals with 8,040
select staff_id, count(staff_id)
from payment
group by staff_id
order by count(staff_id) desc;
-- according to the payment table, staff_id 2 has the most rentals with 7,304

-- 6. How many different district names are there?
select district, count(district)
from address
group by district;
-- The number of different district names is the number of rows returned by the above query: 378 different district names
-- Alternatively, using the DISTINCT operator we can retrieve only unique values
select count(distinct district)
from address;
-- 378

-- 7. What film has the most actors in it? (use film_actor table and get film_id)
-- aka what film_id has the highest count in film_actor
select film_id, count(film_id)
from film_actor
group by film_id
order by count(film_id) desc
limit 1;
-- film_id 508 has the most actors with 16
-- while we had just mentioned attempting to get a direct answer to your question as the result of a query
	-- that could be achieved in this scenario and others with the LIMIT clause
	-- the limit clause chops off your returned/fetched values after the limit is reached
	-- the limit clause always appears at the end of a query

-- What about the flip side? Which actor has appeared in the most films?
select actor_id, count(*)
from film_actor
group by actor_id
order by count(*) desc
limit 1;
-- Actor id#107 has appeared in 42 films.

-- 8. From store_id 1, how many customers have a last name ending with ‘es’? (use customer table)
select count(*)
from customer
where store_id = 1 and last_name like '%es';
-- 13 customers with a last_name ending in 'es' shop at store_id#1

-- 9. How many payment amounts (4.99, 5.99, etc.) had a number of rentals above 250 for customers  with ids between 380 and 430?
-- part 1: count of payment amounts where the count is above 250
	-- conditional/filter on an aggregate -> HAVING clause
-- part 2:
	-- filter that based on customer_ids
select amount, count(amount)
from payment
where customer_id between 380 and 430
group by amount
having count(amount) > 250;
-- 3 amounts with more than 250 transactions made by customers with ids between 380 and 430

-- 10. Within the film table, how many rating categories are there? And what rating has the most movies total?
select count(distinct rating) 
from film;
-- 5 different rating categories
select rating, count(film_id)
from film
group by rating
order by count(film_id) desc;
-- PG-13 has the most movies total at 223

-- <column> must appear in a GROUP BY error? You are probably selecting a column you don't need to be selecting!
	-- If you are selecting an aggregate such as COUNT() or SUM(), SQL is attempting to smash together a bunch of rows into fewer rows
	-- If you select a regular column alongside an aggregate, SQL doesn't know what to do with those values as it is smashing rows together
		-- SQL tables must have the same number of rows in every column
	-- If you include a regular column in both the select and the groupby clauses, you won't get an error
		-- because the group by is telling SQL how to smash together the rows in that column