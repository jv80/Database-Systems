/*
Course: COMP1630 Relational Database & SQL 
Project 2
Author: JV
ID    : Axxxxxxxx
*/

USE master
GO
if exists (select * from sysdatabases where name='Cus_Orders')
begin
  raiserror('Dropping existing Cus_Orders ....',0,1)
  DROP database Cus_Orders
end
GO
/* 1.- Create a database called Cus_Orders.*/

/* CREATE CUS_ORDERS DATABASE*/

PRINT '********************************';
PRINT 'A1-Creating a Cus_Orders database';
CREATE DATABASE Cus_Orders
GO
USE Cus_orders
GO
/* 2.-Create a user defined data types for all similar Primary Key 
attribute columns (e.g. order_id, product_id, title_id), to 
ensure the same data type, length and null ability. See pages 12/13 for specifications.*/

/*Create user type cfid */

PRINT '********************************';
PRINT 'A2a-Creating a user type cfid (char five id)';
CREATE TYPE cfid FROM char(5) NOT NULL;
GO
/*Create user type ctid */
PRINT '********************************';
PRINT 'A2b-Creating a user type ctid (char Three id)';
CREATE TYPE ctid FROM char(3) NOT NULL;
GO
/*Create user type intid */
PRINT '********************************';
PRINT 'A2c-Creating a user type intid (integer id)';
CREATE TYPE intid FROM int NOT NULL;
GO
/*Create user type idenit */
PRINT '********************************';
PRINT 'A2d-Creating a user type idenid (IDENTITY id)';
CREATE TYPE idenid FROM int NOT NULL;
GO
/*3.-Create the following tables (see column information on pages 12 and 13 ):*/
/* Create customers table */
PRINT '********************************';
PRINT 'A3a-Creating customers table';
CREATE TABLE customers
(
customer_id cfid,
name varchar(50) NOT NULL,
contact_name varchar(30),
title_id ctid,
address varchar(50),
city varchar(20),
region varchar(15),
country_code varchar(10),
country varchar(15),
phone varchar(20),
fax varchar(20)
)
GO
/* Create orders table */
PRINT '********************************';
PRINT 'A3b-Creating orders table';
CREATE TABLE orders
(
order_id intid,
customer_id cfid,
employee_id int NOT NULL,
shipping_name varchar(50),
shipping_address varchar(50),
shipping_city varchar(20),
shipping_region varchar(15),
shipping_country_code varchar(10),
shipping_country varchar(15),
shipper_id idenid,
order_date datetime,
required_date datetime,
shipped_date datetime,
freight_charge money
)
GO
/* Create order_details table */
PRINT '********************************';
PRINT 'A3c-Creating order_details table';
CREATE TABLE order_details
(
order_id intid,
product_id intid,
quantity int NOT NULL,
discount float NOT NULL
)
GO
/* Create products table */
PRINT '********************************';
PRINT 'A3d-Creating products table';
CREATE TABLE products
(
product_id intid,
supplier_id intid,
name varchar(40) NOT NULL,
alternate_name varchar(40),
quantity_per_unit varchar(25),
unit_price money,
quantity_in_stock int,
units_on_order int,
reorder_level int
)
 GO
 /* Create shippers table */
PRINT '********************************';
PRINT 'A3e-Creating shippers table';
CREATE TABLE shippers
(
shipper_id idenid,
name varchar(20) NOT NULL
)
GO
/* Create suppliers table */
PRINT '********************************';
PRINT 'A3f-Creating suppliers table';
CREATE TABLE suppliers
(
supplier_id intid,
name varchar(40) NOT NULL,
address varchar(30),
city varchar(20),
province char(2)
)
GO
PRINT '********************************';
PRINT 'A3g-Creating titles table';
CREATE TABLE titles
(
title_id ctid,
description varchar(35) NOT NULL
)
GO
/*4.-Set the primary keys and foreign keys for the tables.*/
/* create your Pks, FKs and other constraints using ALTER here  GO after each statement */

/* Add PK to customers table */
PRINT '********************************';
PRINT 'A4a-Creating PK to customers table';
ALTER TABLE customers
ADD PRIMARY KEY ( customer_id );
GO
/* Add PK to orders table */
PRINT '********************************';
PRINT 'A4b-Creating PK to orders table';
ALTER TABLE orders
ADD PRIMARY KEY ( order_id );
GO
/* Add PK to order_details table */
PRINT '********************************';
PRINT 'A4c-Creating PK to order_details table';
ALTER TABLE order_details
ADD PRIMARY KEY ( order_id, product_id );
GO
/* Add PK to products table */
PRINT '********************************';
PRINT 'A4d-Creating PK to products table';
ALTER TABLE products
ADD PRIMARY KEY ( product_id );
GO
/* Add PK to shippers table */
PRINT '********************************';
PRINT 'A4e-Creating PK to shippers table';
ALTER TABLE shippers
ADD PRIMARY KEY ( shipper_id );
GO
/* Add PK to suppliers table */
PRINT '********************************';
PRINT 'A4f-Creating PK to suppliers table';
ALTER TABLE suppliers
ADD PRIMARY KEY ( supplier_id );
GO
/* Add PK to titles table */
PRINT '********************************';
PRINT 'A4g-Creating PK to titles table';
ALTER TABLE titles
ADD PRIMARY KEY ( title_id );
GO
/* Set up PK – FK link titles to customers */
PRINT '********************************';
PRINT 'A4h-FK_titles_customers';
ALTER TABLE customers
ADD CONSTRAINT FK_titles_customers FOREIGN KEY (title_id)
REFERENCES titles
(title_id);
GO
/* Set up PK – FK link customers to orders */
PRINT '********************************';
PRINT 'A4i-FK_customers_orders';
ALTER TABLE orders
ADD CONSTRAINT FK_customers_orders FOREIGN KEY (customer_id)
REFERENCES customers
(customer_id);
GO
/* Set up PK – FK link shippers to orders */
PRINT '********************************';
PRINT 'A4j-FK_shippers_orders';
ALTER TABLE orders
ADD CONSTRAINT FK_shippers_orders FOREIGN KEY (shipper_id)
REFERENCES shippers
(shipper_id);
GO
/* Set up PK – FK link orders to order_details */
PRINT '********************************';
PRINT 'A4k-FK_orders_order_details';
ALTER TABLE order_details
ADD CONSTRAINT FK_orders_order_details FOREIGN KEY (order_id)
REFERENCES orders
(order_id);
GO
/* Set up PK – FK link suppliers to products */
PRINT '********************************';
PRINT 'A4l-FK_suppliers_products';
ALTER TABLE products
ADD CONSTRAINT FK_suppliers_products FOREIGN KEY (supplier_id)
REFERENCES suppliers
(supplier_id);
GO
/* Set up PK – FK link products to order_details */
PRINT '********************************';
PRINT 'A4m-FK_products_order_details';
ALTER TABLE order_details
ADD CONSTRAINT FK_products_order_details FOREIGN KEY (product_id)
REFERENCES products
(product_id);
GO
/*5.	Set the constraints as follows:*/

/* customers table  - country should default to Canada*/
PRINT '********************************';
PRINT 'A5a Adding Canada as a default country';
ALTER TABLE customers
ADD CONSTRAINT default_country
DEFAULT ('Canada') FOR country;
GO
/*orders table -  required_date should default to today’s date plus ten day*/
PRINT '********************************';
PRINT 'A5b Adding required_date should default to today’s date plus ten day';
ALTER TABLE orders
ADD CONSTRAINT required_date_plus_ten
DEFAULT DATEADD(day, 10, GETDATE()) FOR required_date;
GO
/*order_details table  -  quantity must be greater than or equal to 1*/
PRINT '********************************';
PRINT 'A5c Adding quantity must be greater than or equal to 1 in order_details table';
ALTER TABLE order_details
ADD CONSTRAINT ch_min_quantity
CHECK (quantity >= 1);
GO
/*products table  -  reorder_level must be greater than or equal to 1*/
PRINT '********************************';
PRINT 'A5d Adding to reorder_level that must be greater than or equal to 1';
ALTER TABLE products
ADD CONSTRAINT ch_min_reorder_level
CHECK (reorder_level >= 1);
GO
/*products table-quantity_in_stock value must not be greater than 150*/
PRINT '********************************';
PRINT 'A5e Adding to quantity_in_stock value must not be greater than 150';
ALTER TABLE products
ADD CONSTRAINT ch_max_quantity_in_stock
CHECK (quantity_in_stock < 150);
GO
/*suppliers table  -  province should default to BC*/
PRINT '********************************';
PRINT 'A5f Adding BC as a default province';
ALTER TABLE suppliers
ADD CONSTRAINT default_province
DEFAULT ('BC') FOR province;
GO
/* Insert statements from supplied scripts here with GO after each */
BULK INSERT titles 
FROM 'C:\TextFiles\titles.txt' 
WITH (
               CODEPAGE=1252,                  
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )
GO
BULK INSERT suppliers 
FROM 'C:\TextFiles\suppliers.txt' 
WITH (  
               CODEPAGE=1252,               
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
 GO
BULK INSERT shippers 
FROM 'C:\TextFiles\shippers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
GO
BULK INSERT customers 
FROM 'C:\TextFiles\customers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
GO
BULK INSERT products 
FROM 'C:\TextFiles\products.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
GO
BULK INSERT order_details 
FROM 'C:\TextFiles\order_details.txt'  
WITH (
               CODEPAGE=1252,              
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
GO
BULK INSERT orders 
FROM 'C:\TextFiles\orders.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )
GO
/* Do your queries here with GO after each */
/* For example */
/*Part B - SQL Statements*/
/*B 1. List the customer id, name, city, and country from the customer table. 
          Order the result set by the customer id. */
SELECT customer_id, name, city, country
FROM customers
ORDER BY customer_id;
GO
/*2.	Add a new column called active to the customers table using the ALTER statement.  The only valid values are 1 or 0.  The default should be 1.*/

PRINT '********************************';
PRINT 'B2 Adding a new column called active to the customers';
ALTER TABLE customers
ADD active bit NOT NULL
DEFAULT 1
GO
/*
3.	List all the orders where the order date is between January 1 and December 31, 2001.  
Display the order id, order date, and a new shipped date calculated by adding 7 days to 
the shipped date from the orders table, the product name from the product table, the customer
name from the customer table, and the cost of the order.  Format the date order date and the 
shipped date as MON DD YYYY. Use the formula (quantity * unit_price) to calculate the cost of the order. 
*/
SELECT orders.order_id,
       products.name AS 'Product name', 
       customers.name AS 'Customer name',   
'order_date'=CONVERT(CHAR(11),order_date,100), 
'new_shipped_date'=CONVERT(CHAR(11),DATEADD(DAY,7,shipped_date),100),
'order_cost'= order_details.quantity*products.unit_price
FROM orders, customers, products, order_details
WHERE order_date BETWEEN 'Jan 1 2001' AND 'Dec 31 2001' AND
      orders.customer_id=customers.customer_id AND
	  orders.order_id=order_details.order_id AND
	  order_details.product_id=products.product_id
GO
/*
4.	List all the orders that have not been shipped.  Display the customer id, 
name and phone number from the customers table, and the order id and order date from 
the orders table.  Order the result set by the customer name.  The query should produce 
the result set listed below. Your displayed results may look slightly different 
to those shown below but the query should still return 21 rows.
*/      
SELECT customers.customer_id,
       customers.name,
	   customers.phone,
	   orders.order_id,
	   orders.order_date
FROM customers,
     orders
WHERE shipped_date IS NULL AND 
      customers.customer_id= orders.customer_id
	  ORDER BY customers.name
GO
/*
5.	List all the customers where the region is NULL.  
Display the customer id, name, and city from the customers table, 
and the title description from the titles table.   
The query should produce the result set listed below.  
*/
SELECT customers.customer_id,
       customers.name,
	   customers.city,
	   titles.description
FROM customers,
     titles
WHERE customers.region IS NULL AND
      customers.title_id=titles.title_id
GO
/*
6.	List the products where the reorder level is higher than the quantity in stock.  
Display the supplier name from the suppliers table, the product name, reorder level,
and quantity in stock from the products table.  Order the result set by the supplier name.  
The query should produce the result set listed below.  
*/
SELECT supplier_name=suppliers.name,
       products_name=products.name,
       products.reorder_level,
       products.quantity_in_stock
FROM suppliers
INNER JOIN products	ON suppliers.supplier_id=products.supplier_id
WHERE products.reorder_level>products.quantity_in_stock
ORDER BY suppliers.name
/*
7.	Calculate the length in years from January 1, 2008 and when an order was 
shipped where the shipped date is not null.  Display the order id, and the 
shipped date from the orders table, the customer name, and the contact name 
from the customers table, and the length in years for each order.  
Display the shipped date in the format MMM DD YYYY.  
Order the result set by order id and the calculated years. 
 The query should produce the result set listed below. 
*/
SELECT orders.order_id,
	   customers.name,
	   customers.contact_name,
'shipped_date'=	 CONVERT(CHAR(11),shipped_date), 
'elapse'= CONVERT(char(11),DATEDIFF(YEAR, shipped_date,'Jan 1 2008')) 
FROM orders,
     customers
WHERE orders.customer_id=customers.customer_id AND 
      shipped_date IS NOT NULL 
/*
8.	List number of customers with names beginning with each letter of the alphabet.  
Ignore customers whose name begins with the letter S. 
Do not display the letter and count unless at least two customer’s names begin with the letter.
*/
SELECT 'name'=SUBSTRING (name,1,1),
        COUNT(*) AS total
FROM   customers
GROUP BY SUBSTRING (name,1,1)
HAVING COUNT(name) >= 2	AND SUBSTRING(name,1,1) != 'S'
GO
/*
9.	List the order details where the quantity is greater than 100.  
Display the order id and quantity from the order_details table, 
the product id and reorder level from the products table, 
and the supplier id from the suppliers table.  Order the result 
set by the order id.  The query should produce the result set listed below.
*/
SELECT order_details.order_id,
       order_details.quantity,
	   products.product_id,
	   products.reorder_level,
	   suppliers.supplier_id
FROM order_details,
     products,
	 suppliers
WHERE order_details.product_id=products.product_id AND
      products.supplier_id=suppliers.supplier_id AND 
	  order_details.quantity > 100
ORDER BY order_details.order_id
GO
/*
10.	List the products which contain tofu or chef in their name.  
Display the product id, product name, quantity per unit and unit price from the products table.  
Order the result set by product name.  The query should produce the result set listed below.
*/
 SELECT product_id,
        name,
		quantity_per_unit,
		unit_price
 FROM products
 WHERE name LIKE '%tofu%' OR name LIKE '%chef%'
 ORDER BY name     
 GO      
 /*PART C*/
/*
 1.	Create an employee table with the following columns:
 */
PRINT '********************************';
PRINT 'B1-Creating employee table';
CREATE TABLE employee
 (
 employee_id int NOT NULL,
 last_name varchar(30) NOT NULL,
 first_name varchar(15) NOT NULL,
 address varchar(30),
 city varchar(20), 
 province char(2),
 postal_code varchar(7),
 phone varchar(10),
 birth_date datetime NOT NULL
 )
 GO
 /*
 2.	The primary key for the employee table should be the employee id.  
 */
PRINT '********************************';
PRINT 'B2-Creating PK to employee table';
ALTER TABLE employee
ADD PRIMARY KEY ( employee_id);
GO
/*
3.	Load the data into the employee table using the employee.txt file; 9 rows.  
In addition, create the relationship to enforce referential integrity between 
the employee and orders tables.  
*/
BULK INSERT employee 
FROM 'C:\TextFiles\employee.txt' 
WITH (         CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )
	 GO
/*Creating the relationship to enforce referential integrity between 
the employee and orders tables 
*/
PRINT '********************************';
PRINT 'B3-FK_employee_orders';
ALTER TABLE orders
ADD CONSTRAINT fk_employee_orders FOREIGN KEY(employee_id)
REFERENCES employee(employee_id)
GO
/*
4.	Using the INSERT statement, add the shipper Quick Express to the shippers table.
*/
PRINT '********************************';
PRINT 'B4-Insert Quick Express ';
INSERT INTO shippers(shipper_id,name)
VALUES(4,'Quick Express')
GO
/*Checking INSERT*/
SELECT*
FROM shippers
GO
/*
5.	Using the UPDATE statement, increate the unit price in 
the products table of all rows with a current unit price 
between $5.00 and $10.00 by 5%; 12 rows affected.
*/
PRINT '********************************';
PRINT 'B5-increate the unit price in 5% ';
UPDATE products
SET unit_price=unit_price*1.05
WHERE unit_price BETWEEN 5 AND 10
GO
/*
6.	Using the UPDATE statement, change the fax value to Unknown for all 
rows in the customers table where the current fax value is NULL; 22 rows affected.
*/
PRINT '********************************';
PRINT 'B6-change the fax value to Unknown';
UPDATE customers
SET fax='Unknown'
WHERE fax IS NULL
GO
/*
7.	Create a view called vw_order_cost to list the cost of the orders.  
Display the order id and order_date from the orders table, the product id from the products table, 
the customer name from the customers tble, and the order cost.  To calculate the cost of the orders, 
use the formula (order_details.quantity * products.unit_price).  
Run the view for the order ids between 10000 and 10200.  The view should produce the result set listed below.
*/
CREATE VIEW vw_order_cost
AS
SELECT orders.order_id,
       orders.order_date,
	   products.product_id,
	   customers.name,
order_cost=order_details.quantity * products.unit_price	   
FROM orders
INNER JOIN order_details ON order_details.order_id=orders.order_id
INNER JOIN customers ON customers.customer_id=orders.customer_id
INNER JOIN products ON products.product_id=order_details.product_id
GO
SELECT *
FROM vw_order_cost 
WHERE order_id BETWEEN 10000 AND 10200
GO	
/*
8.	Create a view called vw_list_employees to list all 
the employees and all the columns in the employee table. 
Run the view for employee ids 5, 7, and 9.  Display the employee id, 
last name, first name, and birth date.  Format the name as last name 
followed by a comma and a space followed by the first name.  
Format the birth date as YYYY.MM.DD.  
*/	
CREATE VIEW vw_list_employees
AS
SELECT *
FROM employee
GO
SELECT employee_id,
       'name'= last_name+', '+first_name,
	   'birth_date'=CONVERT(char(10),birth_date,102)   
FROM vw_list_employees   
WHERE employee_id=5 OR
      employee_id=7 OR
	  employee_id=9
GO
/*
9.	Create a view called vw_all_orders to list all the orders.  
Display the order id and shipped date from the orders table, and 
the customer id, name, city, and country from the customers table.  
Run the view for orders shipped from January 1, 2002 and December 31, 2002, 
formatting the shipped date as MON DD YYYY.  Order the result 
set by customer name and country.    
*/
CREATE VIEW vw_all_orders
AS
SELECT orders.order_id,
       orders.shipped_date,
	   customers.customer_id,
	   customers.name,
	   customers.city,
	   customers.country
FROM orders
INNER JOIN customers ON orders.customer_id=customers.customer_id
GO
SELECT order_id,
       customer_id,
	   'customer_name'=name,
	   city,
	   country,
	   'shipped_date'=CONVERT(CHAR(11),shipped_date,100)
FROM vw_all_orders
WHERE shipped_date BETWEEN 'Jan 1 2002' AND 'Dec 31 2002'
ORDER BY customer_name,country
GO
/*
10.	Create a view listing the suppliers and the items they have shipped.  
Display the supplier id and name from the suppliers table, and the product 
id and name from the products table.  Run the view.  The view should 
produce the result set listed below, although not necessarily in the same order.
*/
CREATE VIEW vw_supplier_item_shipped
AS
SELECT suppliers.supplier_id,
       supplier_name=suppliers.name,
	   products.product_id,
	   product_name=products.name
FROM suppliers
INNER JOIN products ON products.supplier_id=suppliers.supplier_id
GO
SELECT*
FROM vw_supplier_item_shipped
GO
/*PART D*/
/*
1.	Create a stored procedure called sp_customer_city displaying the customers 
living in a particular city.  The city will be an input parameter for the stored procedure.  
Display the customer id, name, address, city and phone from the customers table.  
Run the stored procedure displaying customers living in London.  
The stored procedure should produce the result set listed below.
*/
CREATE PROCEDURE sp_customer_city
(
	 @pcity varchar(20)='London%'
)
AS
SELECT customer_id,
       name,
	   address,
	   city,
	   phone
FROM customers
WHERE city LIKE @pcity
GO
EXECUTE sp_customer_city
GO
/*
2.	Create a stored procedure called sp_orders_by_dates displaying 
the orders shipped between particular dates.  The start and end date will be input parameters 
for the stored procedure.  Display the order id, customer id, and shipped date from the 
orders table, the customer name from the customer table, and the shipper 
name from the shippers table.  Run the stored procedure displaying orders from January 1, 2003 to June 30, 2003.  
The stored procedure should produce the result set listed below.
*/
CREATE PROCEDURE sp_orders_by_dates
(
	@startDate datetime= 'January 1, 2003',
	@endDate datetime='June 30, 2003'
)
AS
SELECT orders.order_id,
       orders.customer_id,
	   orders.shipped_date,
	   customers.name,
	   shippers.name
FROM orders
INNER JOIN customers ON customers.customer_id=orders.customer_id
INNER JOIN shippers ON shippers.shipper_id=orders.shipper_id
WHERE shipped_date BETWEEN @startDate AND @endDate
GO
EXECUTE sp_orders_by_dates
GO
/*
3.	Create a stored procedure called sp_product_listing listing a 
specified product ordered during a specified month and year.  
The product and the month and year will be input parameters for the stored procedure.  
Display the product name, unit price, and quantity in stock from the products table, 
and the supplier name from the suppliers table.  Run the stored procedure displaying a 
product name containing Jack and the month of the order date is June and the year is 2001.  
The stored procedure should produce the result set listed below. 
*/
CREATE PROCEDURE sp_product_listing
(
	@sproduct varchar(40),
	@smonth varchar(10),
	@syear int
)
AS
SELECT product_name=products.name,
       products.unit_price,
	   products.quantity_in_stock,
	   suppliers.name
FROM products
INNER JOIN suppliers ON suppliers.supplier_id=products.supplier_id 
INNER JOIN order_details ON order_details.product_id=products.product_id
INNER JOIN orders ON order_details.order_id=orders.order_id
WHERE products.name LIKE '%'+@sproduct+'%'AND
DATENAME(Month,orders.order_date)=@smonth AND
DATENAME(YEAR,orders.order_date)=@syear
GO
EXECUTE sp_product_listing 'Jack',June,2001
GO
/*
4.	Create a DELETE trigger called tr_delete_orders 
on the orders table to display an error message if an order 
is deleted that has a value in the order_details table. 
( Since Referential Integrity constraints will normally prevent 
such deletions, this trigger needs to be an Instead of trigger.) 
Run the following query to verify your trigger. 
DELETE orders
WHERE order_id = 10000 
*/
CREATE TRIGGER tr_delete_orders
ON orders
INSTEAD OF DELETE
AS
DECLARE @order_id intid
SELECT @order_id=order_id
FROM DELETED
IF EXISTS
(
	SELECT order_id
	FROM order_details
	WHERE order_id = @order_id
)
BEGIN
raiserror('This order has a value and it can not be deleted of order_details table....',0,1)
ROLLBACK TRANSACTION
END
GO
DELETE orders
WHERE order_id=10000
GO
/*
5.	Create an INSERT and UPDATE trigger called tr_check_qty on the 
order_details table to only allow orders of products that have a quantity 
in stock greater than or equal to the units ordered.  Run the following query 
to verify your trigger.

UPDATE order_details
SET quantity = 30
WHERE order_id = '10044'
     AND product_id = 7
*/
CREATE TRIGGER tr_check_qty
ON order_details
FOR INSERT, UPDATE
AS
DECLARE @product_id cfid
SELECT @product_id=product_id
FROM inserted
IF
(
	SELECT products.quantity_in_stock
	FROM products
	WHERE products.product_id=@product_id)
>=
(
	SELECT products.units_on_order
	FROM products
	WHERE products.product_id=@product_id)
BEGIN
ROLLBACK TRANSACTION
PRINT'Not enough quantity of products'
END
GO
UPDATE order_details
SET quantity=30
WHERE order_id='10044'AND product_id=7
GO
/*
6.	Create a stored procedure called sp_del_inactive_cust 
to delete customers that have no orders.  The stored procedure should delete 1 row.
*/
CREATE PROCEDURE sp_del_inactive_cust
AS
DELETE
FROM customers
WHERE customers.customer_id NOT IN
(
	SELECT orders.customer_id
	FROM orders
)
GO
EXECUTE sp_del_inactive_cust
GO
/*
7.	Create a stored procedure called sp_employee_information to display 
the employee information for a particular employee.  The employee id will 
be an input parameter for the stored procedure.  Run the stored procedure 
displaying information for employee id of 5.  
*/
CREATE PROCEDURE sp_employee_information
(
	@emp_id int
)
AS
SELECT employee_id,
       last_name,
	   first_name,
	   address,
	   city,
	   province,
	   postal_code,
	   phone,birth_date
FROM employee
WHERE employee_id=@emp_id
GO
EXECUTE sp_employee_information 5
GO
/*
8.	Create a stored procedure called sp_reorder_qty to show when 
the reorder level subtracted from the quantity in stock is less than a specified value.  
The unit value will be an input parameter for the stored procedure.  
Display the product id, quantity in stock, and reorder level from the products table, 
and the supplier name, address, city, and province from the suppliers table. 
 Run the stored procedure displaying the information for a value of 5.  
The stored procedure should produce the result set listed below.  
*/
CREATE PROCEDURE sp_reorder_qty
(
	@unit int
)
AS
SELECT products.product_id,
       suppliers.name,
       suppliers.address,
       suppliers.city,
       suppliers.province,
qty=products.quantity_in_stock,
products.reorder_level
FROM products
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE (products.quantity_in_stock-products.reorder_level)<@unit
GO
EXECUTE sp_reorder_qty 5
GO
/*
9.	Create a stored procedure called sp_unit_prices for the product table 
where the unit price is between particular values.  The two unit prices will 
be input parameters for the stored procedure.  Display the product id, product name, 
alternate name, and unit price from the products table.  Run the stored procedure to 
display products where the unit price is between $5.00 and $10.00.     
*/
CREATE PROCEDURE sp_unit_prices
(
	@unitp1 money,
	@unitp2 money
)
AS
SELECT product_id,
       name,
       alternate_name,
       unit_price
FROM products
WHERE unit_price BETWEEN @unitp1 AND @unitp2
GO
EXECUTE sp_unit_prices 5,10

/* DO AS ABOVE FOR ALL THE QUESTIONS */