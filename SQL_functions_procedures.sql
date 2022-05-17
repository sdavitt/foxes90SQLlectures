-- Stored Functions and Procedures in Postgres
-- the concept of a stored function or procedure in SQL/postgres is the same as the concept of a function in Python
-- we can assign a name to a certain query or process of queries
-- have that name be able to accept input
-- run its processes
-- and potentially return a value (postgres functions do not particularly play well with return values)

-- One thing you will notice about stored functions and procedures is the syntax is rather complicated
-- SQL was first invented in the 1970s (it is an older language)
-- even more so than almost any other syntax within SQL, stored functions and procedure syntax seems archaic
-- outside of database management or SQL engineer roles (where you are working every single day with pure SQL)
	-- stored functions and procedures are not common to use


-- STORED FUNCTIONS VS. STORED PROCEDURES
-- What's the difference?
-- The answer is very little. Before Postgres v11, there was no difference.
-- Only functions existed. A function with no return value was called a procedure, but there was no syntax difference.
-- With the introduction of Postgres v11 (and subsequent versions [current v14]), there is a formal difference.
	-- PROCEDUREs were introduced as a slight simplification of the syntax of functions
		-- in part to formalize the difference in terminology that had been around for a while 
		-- and in part to simplify the process of creating a procedure given the infrequency of creating a function with a return value

-- TL:DR FUNCTION -> FUNCTION WITH A RETURN VALUE
	-- PROCEDURE -> FUNCTION WITH NO RETURN VALUE

-- Let's look at a potential process to assign a late fee to a payment in our movie theatre database
-- This will be using DML (the UPDATE command) to increase the amount for a payment based on rental_id

-- I want to set a procedure that accepts a rental_id and a fee, and increased the payment amount by the fee
select * from payment where rental_id between 14714 and 14715;

-- procedure definition is equivalent to a python function definition:
	-- def funcName(inputA, inputB):
create or replace procedure lateFee(
	rental INTEGER,
	feeAmount DECIMAL
)
language plpgsql
as $$
begin
	-- here is where we actually write the query/process to be run
	update payment
	set amount = amount + feeAmount
	where rental_id = rental;
	
	-- within a procedure, running a query doesn't actually alter the database
	-- we need to tell the database to "save" the results of the queries inside the procedure
	commit;
end;
$$


-- call the procedure with input values to run it
-- equivalent of a function call in python right down to the syntax and terminology
-- call <procedure_name>(<input values>)
call lateFee(14714, 19.99);
call lateFee(14715, 2.99);

-- delete a procedure
drop procedure lateFee;

-- Simple stored function for inserting a new actor into the actor table
select * from actor;

-- syntax for a function is very similar to a procedure
create or replace function addactor_sam(actorid INTEGER, firstname VARCHAR, lastname VARCHAR, lastupdate TIMESTAMP without TIME zone)
returns table(fname VARCHAR, lname VARCHAR)
as $$
begin
	insert into actor(actor_id, first_name, last_name, last_update)
	values (actorid, firstname, lastname, lastupdate);

	-- return query allows us to return the result of a query as our return value
	return query select first_name, last_name from actor where actor_id = actorid;
end;
$$
language plpgsql;

-- let's call our function
-- how not to call a function in postgres:
-- call addactor_sam()
-- it would make a lot of sense... but instead we select functions

select addactor_sam(605, 'Kevin', 'Hart', NOW()::timestamp);
select addactor_sam(606, 'Dylan', 'Smith', NOW()::timestamp);
-- what is happening with NOW()::timestamp?
	-- NOW() lets postgres access our system's clock to get the current time
	-- :: is postgres' typecasting syntax (aka the syntax for taking a piece of data of one type and transforming into another datatype)
	-- so, we're grabbing the systems current time and converting it to a postgres timestamp

-- working with a return value, selecting the function is no different
-- but when we run the select of the function, we will see the return value
-- the return value is not a permanent table in the database, it is just to show the result of the function
select addactor_sam(711, 'Taika', 'Waititi', NOW()::timestamp);


-- delete function by drop function
drop function addactor_sam;
