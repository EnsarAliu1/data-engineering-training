--Create a report for completed revenue by order_date.
SELECT
    order_date,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM products
JOIN orders
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY order_date;

-- Create a report for average completed order value by category
SELECT
    category,
    AVG(order_value) AS average_completed_order_value
FROM (
    SELECT
        products.category,
        orders.order_id,
        SUM(orders.quantity * products.price) AS order_value
    FROM products
    JOIN orders
        ON orders.product_id = products.product_id
    WHERE orders.status = 'completed'
    GROUP BY
        products.category,
        orders.order_id
) AS completed_orders
GROUP BY category;


-- Create a report that shows each product with completed_orders, completed_quantity, and completed_revenue
SELECT
    products.product_id,
    COUNT(orders.order_id) AS completed_orders,
    SUM(orders.quantity) AS completed_quantity,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM orders
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY products.product_id;


-- Create a report that shows each city with total_orders, completed_orders, pending_or_cancelled_orders, and completed_revenue.
SELECT
    customers.city,
    total_orders.total_orders,
    completed_orders.completed_orders,
    pending_cancelled_orders.pending_or_cancelled_orders,
    completed_revenue.completed_revenue
FROM customers

JOIN
(
    SELECT
        customers.city,
        COUNT(*) AS total_orders
    FROM orders
    JOIN customers
        ON orders.customer_id = customers.customer_id
    GROUP BY customers.city
) AS total_orders
    ON customers.city = total_orders.city

JOIN
(
    SELECT
        customers.city,
        COUNT(*) AS completed_orders
    FROM orders
    JOIN customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.status = 'completed'
    GROUP BY customers.city
) AS completed_orders
    ON customers.city = completed_orders.city

JOIN
(
    SELECT
        customers.city,
        COUNT(*) AS pending_or_cancelled_orders
    FROM orders
    JOIN customers
        ON orders.customer_id = customers.customer_id
    WHERE orders.status = 'pending'
       OR orders.status = 'cancelled'
    GROUP BY customers.city
) AS pending_cancelled_orders
    ON customers.city = pending_cancelled_orders.city

JOIN
(
    SELECT
        customers.city,
        SUM(orders.quantity * products.price) AS completed_revenue
    FROM orders
    JOIN customers
        ON orders.customer_id = customers.customer_id
    JOIN products
        ON orders.product_id = products.product_id
    WHERE orders.status = 'completed'
    GROUP BY customers.city
) AS completed_revenue
    ON customers.city = completed_revenue.city;


--Add two new orders and check whether your reports update correctly.
-- Add two new orders
INSERT INTO orders (order_id, customer_id, product_id, order_date, quantity, status)
VALUES
(15, 1, 104, '2026-07-08', 1, 'completed'),
(16, 5, 102, '2026-07-08', 2, 'pending');

SELECT
    city,
    COUNT(*) AS total_orders
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY city;

--Create a short Bronze/Silver/Gold explanation: raw tables, cleaned tables, and Gold reporting outputs.
-- Bronze Layer:
-- Raw data tables as they arrive from source systems.
-- Example: orders, customers, and products tables before cleaning.
-- Data may contain missing values, duplicates, or formatting issues.


-- Silver Layer:
-- Cleaned and transformed tables.
-- Data is validated, duplicates are removed, data types are corrected,
-- and relationships between tables are prepared for analysis.


-- Gold Layer:
-- Business-ready reporting tables.
-- Contains aggregated metrics and reports used by analysts and dashboards.
-- Examples: completed revenue by product, sales by city, and customer reports.