-- SQL Joins/Subqueries Homework


-- 1. List all customers who live in Texas (use JOINs)
select customer_id, first_name, last_name, address, district
from customer
join address
on customer.address_id = address.address_id
where district = 'Texas';
-- 5 customers from Texas

-- 2. Get all payments above $6.99 with the Customer's Full Name
select payment_id, amount, payment_date, payment.customer_id, first_name || ' ' || last_name as full_name
from payment
join customer
on payment.customer_id = customer.customer_id 
where amount > 6.99;
-- 1498 payments above 6.99

-- 3. Show all customers names who have made payments over $175(use subqueries)
	-- Interpretation 1: sum(payments) > 175
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	group by customer_id
	having sum(amount) > 175
);
	-- Interpretation 2: any inidividual payment > 175
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	where amount > 175
);

-- 4. List all customers that live in Nepal (use the city table)
	-- The same as the multijoin we did in class (except we're looking for customers in Nepal instead of Angola)
select customer.customer_id, customer.first_name, customer.last_name, address, city, country
from customer
join address
on customer.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where country = 'Nepal';
-- Kevin Schuler is the only customer from Nepal

-- 5. Which staff member had the most transactions?
	-- transactions could be payments
	-- subquery in the payment table
select * 
from staff
where staff_id in (
	select staff_id
	from payment
	group by staff_id
	order by count(staff_id) desc
	limit 1
);
	-- according to the payment table, staff_id 2 has made more transactions

	-- transactions could be rentals
	-- join between the staff table and the rental table
select staff.staff_id, first_name, last_name, count(rental_id)
from rental
join staff
on rental.staff_id = staff.staff_id
group by staff.staff_id, first_name, last_name
order by count(rental_id) desc
limit 1;
	-- according to the rental table, staff_id 1 has made more transactions

-- 6. How many movies of each rating are there?
select rating, count(title) 
from film
group by rating;

-- question 6 part 2 - how many movies of each category are there?
select category.category_id, category.name, count(film_category.film_id)
from category
join film_category
on category.category_id = film_category.category_id
join film
on film.film_id = film_category.film_id
group by category.category_id, category.name
order by count(film_category.film_id) desc;

-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
select first_name, last_name
from customer
where customer_id in (
	select customer_id
	from payment
	where amount > 6.99
);

-- 8. How many free rentals did our stores give away?
select count(*) from payment where amount = 0;
-- 23 free rentals

-- In class exercise: Which staff member has given away more free rentals and where is the location of the store where that staff member works
-- Answer: 1 row: <staff_id> <name> <store_id> <country of store>
-- Multijoin and maybe a subquery
select staff.staff_id, first_name, last_name, staff.store_id, country
from staff
join store
on staff.store_id = store.store_id
join address
on store.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id
where staff_id in (
	select staff_id
	from payment
	where amount = 0
	group by staff_id
	order by count(rental_id) desc
	limit 1
);

