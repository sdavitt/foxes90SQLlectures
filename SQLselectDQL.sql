-- Two dashes is a single line comment
-- Hello SQL World!

-- Today we will be discussing DQL - data query language
-- specifically, simple select statements

-- The "hello, world" program of SQL: select all rows and all columns from a table
select *
from actor;

-- A select statement needs at minimum two clauses:
-- a select clause to specify which columns are being selected
-- and a from clause to specify which table we are selecting from

-- select * from <table>; commonly used as an exploratory query
-- to show you (the developer) what information exists within a table
select * from customer;


-- what if I didnt want every column in a table
-- just specify the columns you'd like to query/select in the select clause
select first_name, last_name
from actor;

-- WHERE clause
-- filter our results by a condition- this will alter the rows that get returned
select first_name, last_name
from actor
where first_name = 'Nick';

-- The order of clauses in a statement matters
-- As we discuss more clauses I'll lay out the specific order but it generally follows the rule
-- Column selection -> Table selection -> Modifiers -> Grouping -> Ordering

-- when writing a where clause with a string - you can use the LIKE operator
-- this enables the use of wildcards aka regex-like patterns
select first_name, last_name
from actor
where last_name like 'Wahlberg';

-- wildcards:
-- % and _
-- % represents any number of characters (could be 0, could be 15000000129301)
-- _ represents a single instance of a character
select first_name, last_name
from actor
where last_name like 'W%';

select first_name, last_name
from actor
where first_name like 'A___';

select first_name, last_name
from actor
where first_name like '%nn%';

-- We've seen a where clause with strings (aka varchars)
-- how do where clauses work for numerical data?
-- Comparison operators:
-- Greater than >
-- Less than <
-- = like shown above
-- Greater or equal >=
-- Less or equal <=
-- Not equal <>

-- explore my data with a SELECT ALL query
select * from payment;

-- query for all payments greater than $10
select customer_id, amount
from payment
where amount > 10;

-- combining operators in our where clause
-- just like python we can combine multiple conditionals with and/or 
select customer_id, amount
from payment
where amount < 0.5 or amount > 300;

-- an alternative to values falling within a range:
-- between operator
-- optional not to flip the behaviour
select customer_id, amount
from payment
where amount not between 10 and 20;


-- can combine conditionals in different columns into one where clause
-- don't need to select a column in order to use that column in the where clause
select first_name, last_name
from actor
where first_name like 'K%' and actor_id > 100;

-- ORDER BY clause
-- let's us sort our results
-- default is ascending order
-- can specify descending with DESC
select customer_id, amount
from payment
where amount > 0
order by amount DESC;

-- Order of the clauses we've discussed so far:
-- select <columns>
-- from <table>
-- where <conditional>
-- order by <column>;
