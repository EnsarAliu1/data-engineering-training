-- 1. Duplicate customers
SELECT 
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- 2. Duplicate emails
SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


-- 3. Customers with missing important fields
SELECT *
FROM customers
WHERE customer_id IS NULL
   OR full_name IS NULL
   OR email IS NULL;


-- 4. Orders without existing customer
SELECT
    o.order_id,
    o.customer_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- 5. Order items without existing product
SELECT
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 6. Negative prices or quantities
SELECT *
FROM products
WHERE price < 0;


SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price < 0;


-- 7. Invalid product statuses
SELECT *
FROM products
WHERE status NOT IN ('active','invalid');


-- 8. Invalid customer statuses
SELECT *
FROM customers
WHERE status NOT IN ('active','blocked','unknown');


-- 9. Orders with future dates
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE;


-- 10. Orders with no items
SELECT
    o.order_id
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- 11. Payments higher than expected order amount
SELECT
    p.order_id,
    SUM(p.amount) AS paid_amount,
    SUM(oi.quantity * oi.unit_price) AS expected_amount
FROM payments p
JOIN order_items oi
    ON p.order_id = oi.order_id
GROUP BY p.order_id
HAVING SUM(p.amount) > SUM(oi.quantity * oi.unit_price);


-- 12. Products never sold
SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;