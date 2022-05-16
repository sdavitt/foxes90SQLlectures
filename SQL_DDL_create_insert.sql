-- Database Creation using Mock Amazon ERD and DDL

-- Data Definition Language encompasses commands that create or modify database structure (aka create, change, or remove entire tables)

-- CREATE TABLE <name_table>(
	-- <column name> <datatype> <constraints>,
-- )

-- create table command for each entity
create table customer(
	customer_id serial primary key,
	first_name varchar(20), -- varchar(20) is a string of length 0 to 20
	last_name varchar(50) not null, -- by default any column can contain a nothing/none value which is called null in sql
	-- not null constraint dictates that that column cannot have any null values
	address varchar(150),
	billing_info varchar(150)
);

select * from customer;

create table brand(
	seller_id serial primary key,
	brand_name varchar(150) not null,
	contact_number varchar(15),
	address varchar(150)
);

create table inventory(
	upc serial primary key,
	product_amount integer
);

-- at this point we've created all three of our tables that don't reference/rely on/have a foreign key to any other table
-- so, now I can start making my tables that have foreign key constraints
create table product(
	item_id serial primary key,
	-- numeric needs a total number of digits and a number of digits after the decimal place
	amount numeric(5,2), -- a price between -999.99 and 999.99 (five total digits, two after the decimal place)
	prod_name varchar(100),
	upc integer,
	-- adding a foreign key constraint
	-- foreign key(<this table's column>) references <other_table>(<other table's column>)
	foreign key(upc) references inventory(upc),
	seller_id integer,
	foreign key(seller_id) references brand(seller_id)
);

create table order_(
	order_id serial primary key,
	order_date date default current_date, -- default constraint lets us specify a default value - in this case the system's current date variable
	sub_total numeric(8,2), -- 999,999.99 max
	total_cost numeric(9,2), -- 9,999,999.99 max
	upc integer,
	foreign key(upc) references inventory(upc)
);

create table cart(
	cart_id serial primary key,
	customer_id integer,
	foreign key(customer_id) references customer(customer_id),
	order_id integer,
	foreign key(order_id) references order_(order_id)
);


-- deleting a table: DROP TABLE <tablename>;
drop table cart;
select * from cart;

-- now that all of my tables are created, I can insert some data into them 
-- INSERT command allows us to insert data into a table

-- insert into <table_name>(<column_A>, <column_B>, <column_C>)
-- values(<value_for_column_A>, <value_for_column_B>, <value_for_column_C>)
insert into customer(first_name, last_name, address, billing_info)
values('Dinesh', 'Chugtai', '5230 Newell Road, Palo Alto, CA', 'poor');

select * from customer;

-- syntax for inserting multiple values of the same structure at the same time
insert into customer(first_name, last_name, address, billing_info)
values ('Hummingbird', 'Saltalamacchia', 'Santa Barbara', 'Psych Office'),
('Bertram', 'Gilfoyle', '5230 Newell Road, Palo Alto, CA', 'also poor');

-- inserts where foreign keys are concerned
-- if a value for a foreign key column is provided (i.e. a customer_id value for the cart table)
-- the primary key it refences (aka the customer table customer_id) must exist
insert into cart(customer_id)
values(1);

select * from cart;

-- helping with ambiguous column names: table.column
select customer.first_name, customer.last_name, customer.billing_info
from customer;
