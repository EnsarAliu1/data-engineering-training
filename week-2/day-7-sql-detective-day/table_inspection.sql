--Show all rows from orders.
-- checks the existing table of orders
SELECT
    *
FROM
    orders;

--Show all rows from customers.
-- checks the existing table of customers

SELECT
    *
FROM
    customers;

--Show all rows from products.
-- checks the existing table of products

SELECT
    *
FROM
    products;

--Count rows in each table.
--checks how many rows are in the existing tables of : oders, customers and products
SELECT
	COUNT(*) AS order_rows
FROM
	orders;

SELECT
	COUNT(*) AS customers_rows
FROM
	customers;

SELECT
	COUNT(*) AS products_rows
FROM
	products;
