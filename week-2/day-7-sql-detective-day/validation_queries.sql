--V1 Count all orders.
SELECT COUNT(*) as all_orders
FROM orders;

--V2 Count completed orders.
SELECT
	COUNT(*) as all_completed_orders
FROM
	orders
WHERE
	status = 'completed';

-- V3 Count pending orders.
SELECT
	COUNT(*) as all_pending_orders
FROM
	orders
WHERE
	status = 'pending';

-- V3 Count cancelled orders.
SELECT
	COUNT(*) as all_cancelled_orders
FROM
	orders
WHERE
	status = 'cancelled';

-- V5 Count all customers.
SELECT
	COUNT(*) as all_customers
FROM
	customers;

-- V6 Count all products.
SELECT
	COUNT(*) as all_products
FROM
	products;

-- V7 Calculate completed revenue only. Pending and cancelled orders must not be included.
SELECT
	SUM(quantity * price) AS completed_revenue
FROM
	orders
JOIN
	products
ON 
	orders.product_id = products.product_id
WHERE
	status = 'completed';

-- V8 Calculate completed revenue by product_name.
SELECT
	product_name,
	SUM(quantity * price) AS completed_revenue
FROM
	orders
JOIN
	products
ON 
	orders.product_id = products.product_id
WHERE
	status = 'completed'
GROUP BY product_name;

-- V9 Calculate completed revenue by category.
SELECT
	category,
	SUM(quantity * price) AS completed_revenue
FROM
	orders
JOIN
	products
ON 
	orders.product_id = products.product_id
WHERE
	status = 'completed'
GROUP BY category;

-- V10 Count orders by city.
SELECT city, COUNT(*) AS order_count
FROM orders
JOIN customers
	ON orders.customer_id = customers.customer_id
GROUP BY city

-- V11 Find customers with more than one order.
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- V12 Find the top 3 completed orders by total_amount.
SELECT
	*,
    (quantity * price) AS total_amount
FROM
	orders
JOIN products
	ON orders.product_id = products.product_id
WHERE status = 'completed'
ORDER BY total_amount DESC
LIMIT 3

--V13 Find orders that should not count as real revenue.
SELECT
	*,
    (quantity * price) AS not_real_revenue
FROM
	orders
JOIN products
	ON orders.product_id = products.product_id
WHERE status != 'completed'

--V14 Find which category has the highest completed revenue.
SELECT
    category,
    SUM(quantity * price) AS total_amount
FROM orders
JOIN products
    ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY category
ORDER BY total_amount DESC
LIMIT 1;

--V15 Find which city has the highest order activity.
SELECT
    city,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY city
ORDER BY order_count DESC
LIMIT 1;