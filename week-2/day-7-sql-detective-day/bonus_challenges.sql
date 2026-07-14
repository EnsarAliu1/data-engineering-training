--Create a query that shows completed revenue by city using orders + customers + products.
SELECT
    city,
    SUM(quantity * price) AS total_revenue
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY city
ORDER BY total_revenue DESC;

-- Create a query that shows average completed order value by category.
SELECT
    category,
    AVG(quantity * price) AS avg_order_value
FROM orders
JOIN products
    ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY category
ORDER BY avg_order_value DESC;

-- Create a query that shows only products with completed revenue greater than 100.
SELECT
    city,
    SUM(quantity * price) AS total_revenue
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE (status = 'completed') and (price > 100)
GROUP BY city
ORDER BY total_revenue DESC;

--Create a query that compares completed, pending, and cancelled order counts by city.
SELECT
    city,
    status,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY city, status
ORDER BY city, status;

--Create one intentional broken query yourself, explain the mistake, and then fix it.
-- Broken Query
SELECT
    category,
    SUM(quantity * price) AS total_revenue
FROM orders
JOIN products
    ON orders.product_id = products.product_id
WHERE status = 'completed';
--Mistake: The query uses the SUM() aggregate function together with category, but it is missing a GROUP BY category clause. This will cause an error because category is neither aggregated nor grouped
-- Fixed Query
SELECT
    category,
    SUM(quantity * price) AS total_revenue
FROM orders
JOIN products
    ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY category;
--Business meaning: This query calculates the total revenue from completed orders for each product category, helping identify which categories generate the most sales.