--Count all orders.
SELECT COUNT(*) AS
	total_orders
FROM
	orders;

--Count only completed orders.
SELECT COUNT(*) AS
	total_orders
FROM
	orders
WHERE status = 'completed';

--Count only pending orders.
SELECT COUNT(*) AS
	total_orders
FROM
	orders
WHERE status = 'pending';

--Count only cancelled orders.
SELECT COUNT(*) AS
	total_orders
FROM
	orders
WHERE status = 'cancelled';

--Calculate total quantity ordered across all statuses.
SELECT SUM(quantity) AS
	total_quantity
FROM
	orders;

--Calculate total quantity ordered only from completed orders.
SELECT SUM(quantity) AS
	total_quantity
FROM
	orders
WHERE
	status = 'completed';

--Find the average product price.
SELECT
    AVG(price) AS average_price
FROM 
	products;

--Find the cheapest product price.
SELECT
    MIN(price) AS cheapest_product_price
FROM 
	products;

--Find the most expensive product price.
SELECT
    MAX(price) AS cheapest_product_price
FROM 
	products;

-- Calculate total revenue from completed orders
SELECT
    SUM(o.quantity * p.price) AS total_completed_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.status = 'completed';

--Calculate non-completed potential value from pending and cancelled orders. Explain why this should not be counted as real revenue.
SELECT
    SUM(o.quantity * p.price) AS total_non_completed_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.status = 'pending' OR status = 'cancelled';

--Pending orders have not been finalized and may still be cancelled or fail.
--Cancelled orders were never completed, so no revenue was earned.