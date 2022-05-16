-- JOINS - working in a separate database to better illustrate different join types
create table join_customer(
	customer_id serial primary key,
	first_name varchar(100),
	last_name varchar(100),
	email varchar(200),
	address varchar(150),
	city varchar(150),
	customer_state varchar(100),
	zipcode varchar(10)
);
select * from join_customer;
create table join_order(
	order_id serial primary key,
	order_date date default current_date,
	amount numeric(5,2), -- decimals between -999.99 and 999.99
	customer_id integer,
	foreign key(customer_id) references join_customer(customer_id)
);
select * from join_order;

insert into join_customer(first_name, last_name, email, address, city, customer_state, zipcode)
values('George', 'Washington', 'gwash@usa.gov', '3200 Mt Vernon Hwy', 'Mt Vernon', 'VA', '22121');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('John','Adams','jadams@usa.gov','1200 Hancock', 'Quincy', 'MA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('Thomas','Jefferson', 'tjeff@usa.gov', '931 Thomas Jefferson Pkway', 'Charlottesville','VA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('James','Madison', 'jmad@usa.gov', '11350 Conway','Orange','VA','02169');

INSERT INTO join_customer(first_name,last_name,email,address,city,customer_state,zipcode)
VALUES('James','Monroe','jmonroe@usa.gov','2050 James Monroe Parkway','Charlottesville','VA','02169');

INSERT INTO join_order(amount,customer_id)
VALUES(234.56,1);

INSERT INTO join_order(amount,customer_id)
VALUES(78.50,3);

INSERT INTO join_order(amount,customer_id)
values(124.00,2);

INSERT INTO join_order(amount,customer_id)
VALUES(65.50,3);

INSERT INTO join_order(amount,customer_id)
VALUES(55.50,NULL);

-- Now that we've created two tables - customers and joins - with a zero or one to zero or many relationship
-- Let's look at joins
-- for all examples, CUSTOMER table will be TABLE_A and ORDER table will be TABLE_B

-- Inner join - only returns data where this is non-null matching information in BOTH tables
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
join join_order
on join_customer.customer_id = join_order.customer_id;
-- not all orders have rows in the result
-- not all customers have rows in the result
-- an inner join only shows rows where we have shared data

-- Full join - all data from both tables, regardless if there is shared/matching data in the other table
-- All possible rows
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
full join join_order
on join_customer.customer_id = join_order.customer_id;
-- every possible row including those with null values (no matching data)


-- Full outer join - all data from both tables that does not have corresponding data in the other table
-- same as a full join but including a where clause
-- where <column only in Table_A> is null or <column only in Table_B> is null;
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
full join join_order
on join_customer.customer_id = join_order.customer_id
where order_id is null or first_name is null;

-- Left join - take all possible rows from Table_A and add in the data from Table_B where it exists
-- All matching data plus data from Table_A that has no corresponding data in Table_B
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
left join join_order
on join_customer.customer_id = join_order.customer_id;

-- Left outer join
-- same exact thing as a left join
-- but looking only for data from Table_A with no matching data in Table_B
-- aka the results from a normal left join where there is a null value
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
left join join_order
on join_customer.customer_id = join_order.customer_id
where order_id is null;
-- useful for determining: Do I have any customers who have never made an order?

-- Right join
-- the only difference between a right join and left join is essentially which table is Table A and which is Table B
-- I can get the exact same result as a left join if I do a right join with the table roles flipped
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_order
right join join_customer
on join_customer.customer_id = join_order.customer_id;
-- I switched from a left join to a right join
-- and I switched Table_A from the customer table to the order table
-- same result as before

-- Right join with normal table assignments
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
right join join_order
on join_customer.customer_id = join_order.customer_id;

-- Right outer join
-- same concept as a left outer join, we're just looking for the null values from the other table
select order_id, amount, join_customer.customer_id, first_name, last_name, email
from join_customer
right join join_order
on join_customer.customer_id = join_order.customer_id
where email is null;
-- result is the one order with no corresponding customer data
