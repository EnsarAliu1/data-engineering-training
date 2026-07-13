--Join orders with customers and show order_id, customer_name, city, order_date, and status.
SELECT 
    order_id,
    customer_name,
    city,
    order_date,
    status
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id;

--Join orders with products and show order_id, product_name, category, quantity, price, total_amount, and status.
SELECT 
    order_id,
    product_name,
    category,
    quantity,
    price,
    quantity * price AS total_amount,
    status
FROM orders
JOIN products
    ON orders.product_id = products.product_id;

--Join all three tables and create a complete order report with customer_name, city, product_name, category, quantity, price, total_amount, status, and order_date.
SELECT 
    customer_name,
    city,
    product_name,
    category,
    quantity,
    price,
    quantity * price AS total_amount,
    status,
    order_date
FROM orders
JOIN products
    ON orders.product_id = products.product_id
JOIN customers
    ON orders.customer_id = customers.customer_id;

-- Create completed revenue by product_name
SELECT
    product_name,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM products
JOIN orders
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY product_name;

-- Create completed revenue by category
SELECT
    category,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM products
JOIN orders
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY category;

---- Create order count by city
SELECT
    city,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY city
ORDER BY order_count DESC;

-- Create completed revenue by city
SELECT
    city,
    SUM(orders.quantity * products.price) AS total_revenue,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY city
ORDER BY total_revenue DESC;

-- Create completed revenue by customer_name.
SELECT
    customer_name,
    SUM(orders.quantity * products.price) AS total_revenue,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY customer_name
ORDER BY total_revenue DESC;

-- Show customers with more than one order using GROUP BY and HAVING.
SELECT
    customer_name,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
GROUP BY customer_name 
HAVING order_count > 1

-- Show top 3 customers by completed revenue
SELECT
    customer_name,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY customer_name
ORDER BY completed_revenue DESC
LIMIT 3;

-- Show top 3 products by completed revenue.
SELECT
    product_name,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY product_name
ORDER BY completed_revenue DESC
LIMIT 3;

-- Show all pending or cancelled orders with customer_name, city, product_name, and potential_amount.
SELECT
    customer_name,
    city,
    product_name,
    SUM(orders.quantity * products.price) AS potential_amount
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY product_name
ORDER BY potential_amount;