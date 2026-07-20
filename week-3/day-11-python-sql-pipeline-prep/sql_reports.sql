-- Show all clean orders.
SELECT *
FROM clean_orders;


-- Calculate completed revenue.
SELECT
    SUM(total_amount) AS completed_revenue
FROM clean_orders
WHERE status = 'completed';


-- Count orders by status.
SELECT
    status,
    COUNT(*) AS total_orders
FROM clean_orders
GROUP BY status
ORDER BY total_orders DESC;


-- Count orders by city.
SELECT
    city,
    COUNT(*) AS total_orders
FROM clean_orders
GROUP BY city
ORDER BY total_orders DESC;


-- Calculate completed revenue by city.
SELECT
    city,
    SUM(total_amount) AS completed_revenue,
    COUNT(*) AS total_orders
FROM clean_orders
WHERE status = 'completed'
GROUP BY city
ORDER BY completed_revenue DESC;


-- Calculate completed revenue by category.
SELECT
    category,
    SUM(total_amount) AS completed_revenue,
    COUNT(*) AS total_orders
FROM clean_orders
WHERE status = 'completed'
GROUP BY category
ORDER BY completed_revenue DESC;


-- Show top 5 orders by total_amount.
SELECT *
FROM clean_orders
ORDER BY total_amount DESC
LIMIT 5;


-- Show top customers by completed revenue.
SELECT
    customer_name,
    SUM(total_amount) AS completed_revenue
FROM clean_orders
WHERE status = 'completed'
GROUP BY customer_name
ORDER BY completed_revenue DESC;


-- Count orders by channel.
SELECT
    channel,
    COUNT(*) AS total_orders
FROM clean_orders
GROUP BY channel
ORDER BY total_orders DESC;


-- Find city with highest completed revenue.
SELECT
    city,
    SUM(total_amount) AS completed_revenue
FROM clean_orders
WHERE status = 'completed'
GROUP BY city
ORDER BY completed_revenue DESC
LIMIT 1;