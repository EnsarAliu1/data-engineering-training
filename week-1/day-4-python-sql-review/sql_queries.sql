--Part 2 - SQL setup and basic queries

--Task 1

--Show all orders.
SELECT
    *
FROM
    orders;

--Show only customer_name and product.
SELECT
    customer_name,
    product
FROM
    orders;

--Show order_id, customer_name, city, and status.
SELECT
    order_id,
    customer_name,
    city,
    status
FROM
    orders;

--Show product, category, quantity, and price.
SELECT
    product,
    category,
    quantity,
    price
FROM
    orders;

--End of Task 1

--Task 2

--Show only completed orders.
SELECT
    *
FROM
    orders
WHERE
    status = 'completed';

--Show only pending orders.
SELECT
    *
FROM
    orders
WHERE
    status = 'pending';

--Show only cancelled orders.
SELECT
    *
FROM
    orders
WHERE
    status = 'cancelled';

--Show orders where price is greater than 100.
SELECT
    *
FROM
    orders
WHERE
    price > 100;

--Show orders from Vushtrri.
SELECT
    *
FROM
    orders
WHERE
    city = 'Vushtrri';

--Show orders where category is Accessories.
SELECT
    *
FROM
    orders
WHERE
    category = 'Accessories';

--End of Task 2 

--Task 3

--Show completed orders where price is greater than 100.
SELECT
    *
FROM
    orders
WHERE
    price > 100
    AND status = 'completed';

--Show completed orders from Prishtina.
SELECT
    *
FROM
    orders
WHERE
    city = 'Prishtina'
    AND status = 'completed';

--Show orders where status is pending OR cancelled.
SELECT
    *
FROM
    orders
WHERE
    status = 'pending'
    OR status = 'cancelled';

--Show Accessories orders where price is less than 50.
SELECT
    *
FROM
    orders
WHERE
    category = 'Accessories'
    AND price < 50;

--End of Task 3

--Task 4

--Show orders from cheapest to most expensive.
SELECT
    *
FROM
    orders
ORDER BY
    price ASC;

--Show orders from most expensive to cheapest.
SELECT
    *
FROM
    orders
ORDER BY
    price DESC;

--Show top 3 most expensive orders by price.
SELECT
    *
FROM
    orders
ORDER BY
    price DESC
LIMIT
    3;

--Show top 3 orders by total_amount.
SELECT
    order_id,
    customer_name,
    product,
    quantity,
    price,
    quantity * price AS total_amount
FROM
    orders
ORDER BY
    total_amount DESC
LIMIT
    3;

--End of Task 4

--Task 5 

--Show customer_name, product, quantity, price, and total_amount.
SELECT
    customer_name,
    product,
    quantity,
    price,
    quantity * price AS total_amount
FROM orders

--Show only completed orders with total_amount.
SELECT
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
    quantity * price AS total_amount
FROM
	orders
WHERE 
	status = 'completed'

--Show completed orders with total_amount sorted from highest to lowest.
SELECT
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
    quantity * price AS total_amount
FROM
	orders
WHERE 
	status = 'completed'
ORDER BY 
	price DESC


--Part 4 Mini business challenge
--Find the customer with the most expensive single order.
SELECT
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
FROM
	orders
ORDER BY 
	price DESC
LIMIT 1

--Find the highest total_amount order.
SELECT
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
    quantity * price AS total_amount
FROM
	orders
ORDER BY 
	price DESC
LIMIT 1

--Find all orders that should NOT be counted as real revenue because they are pending or cancelled.
SELECT
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status
FROM
	orders
WHERE status IS NOT 'completed'
ORDER BY 
	price DESC

--Calculate completed revenue only. Cancelled and pending orders should not be included.
SELECT
    SUM(quantity * price) AS completed_revenue
FROM
    orders
WHERE
    status = 'completed';

--Create a short business answer: Which order looks most valuable and why?
--The most valuable order is Arta's laptop order because it has the highest total amount of €700. It generates the most revenue from a single purchase.

--Create a short business answer: Why should cancelled orders not be counted as revenue?
--Cancelled orders should not be counted as revenue because the sale was never completed and no payment was successfully received. Including them would make the revenue report inaccurate.


--Bonus Tasks

INSERT INTO orders (
    order_id,
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
    order_date
) VALUES
(1, 'Ensar', 'Skenderaj', 'Laptop', 'Electronics', 1, 700, 'completed', '2026-07-01'),
(2, 'Urim', 'Vushtrri', 'Mouse', 'Accessories', 2, 15, 'completed', '2026-07-01'),


--In SQL, try COUNT(*) to count all orders.
SELECT COUNT(*) AS total_orders
FROM orders;    


--In SQL, try SUM(quantity * price) for completed orders only.
SELECT
    SUM(quantity * price) AS completed_revenue
FROM orders
WHERE status = 'completed';