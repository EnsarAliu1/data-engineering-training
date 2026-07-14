--Fixed Query 1
SELECT city, COUNT(*) AS order_count
FROM orders
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY city
-- Explain: This query was missing JOIN ON and because of that was throwing error because column city isnt part of orders table
-- Bussines meaning: this query shows each city with their order count


--Fixed Query 2
SELECT product_name, SUM(quantity * price) AS revenue
FROM orders
JOIN products ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY product_name;
-- Explain: This query was missing a comma after the product_name column, causing a syntax error.
-- Bussines meaning: This query shows the earned revenue of each product , without cancelled or pending orders.


--Fixed Query 3
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;
-- Explain: This query had a semicolon before ORDER BY, causing a syntax error
-- Business meaning: This query shows each status of orders and their count.


--Fixed Query 4
SELECT order_id, quantity, price, quantity * price AS total_amount
FROM orders
JOIN products
	ON orders.product_id = products.product_id
-- Explain: This query was missing JOIN ON porducts, causing error because price doesn't exists in orders as column
-- Business meaning: This query shows orders by id their quantity(times they ve been purcheased ) their price and total amount.


--Fixed Query 5
SELECT category, SUM(quantity) AS total_quantity
FROM orders
JOIN products
	ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY category;
-- Explain: This query was missing JOIN ON porducts, causing error because category doesn't exists in orders as column
-- Bussines meaning: This query shows every category and their total quantity of completed orders.


--Fixed Query 6
SELECT SUM(quantity * price) AS total_revenue
FROM orders
JOIN products ON orders.product_id = products.product_id;
-- Explain: This query was OK.
-- Business meaning: This query shows total revenue of orders


--Fixed Query 7
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- Explain: In this query HAVING COUNT was written before GROUP BY, causing a syntax error.
--Business meaning: this query shows customers id that have more than one order

--Fixed Query 8
SELECT orders.order_id, customers.customer_name
FROM orders
JOIN customers
	ON orders.customer_id = customers.customer_id;
-- Explain: THis query was missing the ON orders.customer_id = customers.customer_id part of JOIN, causing to duplicate the result.
--Business meaning: this query shows the order id and their customer name.


--Fixed Query 9
SELECT orders.customer_id, orders.product_id, products.price
FROM orders
JOIN products ON orders.product_id = products.product_id;
-- Exoplain: Thiq query was missing order. and prodcuts. parts, causing a ambiguous column name error.
-- Business meaning: this query shows customers id with product id they ve ordered and its price too.


--Fixed Query 10
SELECT *
FROM orders
WHERE status != 'completed';
-- Explain: Thiq query was missing the exclamation point, and was showing completed orders instead non-completed orders.
--Business meaning: this query shows orders that are not completed.
