-- Altering data in your database
	-- Commands from both the DDL and DML families
		-- DDL - Data Definition language
			-- the creation or modification of TABLEs (entire entities within the database, larger database structure)
		-- DML - Data Manipulation language
			-- the creation or modification of data within a table
				-- inserting values into a table
				-- modifying those values within the table

-- ALTER, UPDATE+SET, DELETE+WHERE, ADD, DROP

select * from customer;

-- currently in the customer table, we cannot have a null value in the last name column
-- However, what if we have a customer who has a mononym (like Cher, Bono, Rodri, Kaka)
-- we can change the constraints on an existing column
-- using ALTER
-- ALTER TABLE <table>
-- ALTER COLUMN <column>
-- DROP <constraint> or SET <constraint>

alter table customer
alter column last_name
drop not null;

-- adding the not null constraint
alter table customer
alter column last_name
set not null;

-- testing the constraint
insert into customer (first_name, last_name, address)
values ('Erling', 'Haaland', 'Manchester City FC');

select * from customer;

-- more table modification - setting a default on a column
alter table customer
alter column billing_info
set default 'not provided';

-- add an entirely new column to a table
-- alter table <table>
-- add <column> <datatype>
alter table customer
add ispoor bool;

-- What if I want to change the datatype of a column that already exists
-- If data already exists in the column, depending on the change in datatype, we may need to provide a method of transformation for the existing data
	-- an optional USING clause to provide typecasting for the transformation (https://www.postgresql.org/docs/current/typeconv.html)
alter table customer
alter column ispoor
type varchar(10);

-- bad practice of changing values in a column: UPDATE+SET with no WHERE clause
update customer
set ispoor = 'poor';

-- better practice: use a where clause
update customer
set ispoor = 'not poor'
where address = 'Manchester City FC';

-- ok, our column currently contains null values, how can we change that null value such that we can set the not null constraint
-- UPDATE <table>
-- SET <column> = <value>
-- WHERE <condition>;
update customer
set last_name = 'Hernandez'
where customer_id = 5;

-- removing values from my database using DELETE
-- delete from <table>
-- where <condition>;

-- the where clause is important because without it you will delete all information from the table
delete from customer
where first_name = 'Rodri' and last_name is null;

select * from customer;

-- two *dangerous* alter commands - these will delete data permanently*

-- Delete a column:
-- alter table <table>
-- drop <column>
alter table customer
drop ispoor;

-- deleting a whole table
-- drop table <table_name>
-- a drop table won't run if there are other tables referencing that table
	-- aka if a table has a column which is a foreign key in other tables
	-- we cannot directly drop that table without telling SQL what to do with the references
drop table cart;

-- if you want to drop a table and delete all references to it, you can do so using
-- DROP TABLE <table_name> CASCADE
drop table inventory CASCADE;

select * from order_;
