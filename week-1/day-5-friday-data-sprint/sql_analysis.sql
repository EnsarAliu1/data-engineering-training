--Show all orders. 
SELECT
    * 
FROM 
    orders

--Show only completed orders.
SELECT 
    *
FROM 
    orders
WHERE 
    status = 'completed'

--Show pending or cancelled orders.
SELECT 
    *
FROM 
    orders
WHERE 
    status = 'cancelled' OR status = 'pending'

--Show total_amount as quantity * price.
SELECT
    *,
    quantity * price AS total_amount
FROM orders;

--Show completed orders with total_amount.
SELECT 
    order_id,
    customer_name,
    city,
    product,
    category,
    quantity,
    price,
    status,
    order_date,
    quantity * price AS total_amount
FROM 
    orders

--Calculate completed revenue using SUM(quantity * price).
SELECT
    SUM(quantity * price) AS completed_revenue
FROM orders
WHERE status = 'completed';

--Count orders by status using COUNT(*) and GROUP BY status.
SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status;

--Count orders by city using COUNT(*) and GROUP BY city.
SELECT
    city,
    COUNT(*) AS total_orders
FROM orders
GROUP BY city;

--Count orders by category using COUNT(*) and GROUP BY category.
SELECT
    category,
    COUNT(*) AS total_orders
FROM orders
GROUP BY category;

--Show top 3 orders by total_amount.
SELECT 
    *,
    quantity * price AS total_amount
FROM 
    orders

--Show top 3 orders by total_amount.
SELECT 
    *,
    quantity * price AS total_amount
FROM 
    orders
ORDER BY total_amount DESC 
LIMIT 3

--Find the most valuable order.
SELECT 
    *
FROM 
    orders
ORDER BY price DESC 
LIMIT 1