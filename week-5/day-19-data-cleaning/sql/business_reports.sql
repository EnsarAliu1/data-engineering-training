--Revenue by customer
SELECT
    customers.customer_id,
    customers.full_name,
    customers.city,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM customers
JOIN orders
    ON orders.customer_id = customers.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
GROUP BY 
    customers.customer_id,
    customers.full_name,
    customers.city
ORDER BY total_revenue DESC
LIMIT 10;


--Revenue by city
SELECT
    customers.city,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM customers
JOIN orders
    ON orders.customer_id = customers.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
GROUP BY 
    customers.city
ORDER BY total_revenue DESC
LIMIT 10;


--Revenue by category
SELECT
    products.category AS product_category,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM products
JOIN order_items
    ON order_items.product_id = products.product_id
GROUP BY 
    product_category
ORDER BY total_revenue DESC;


--Top products
SELECT
	products.product_id,
    products.product_name,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM products
JOIN order_items
    ON order_items.product_id = products.product_id
GROUP BY 
	products.product_id,
    products.product_name
ORDER BY total_revenue DESC
LIMIT 10;


--Top customers
SELECT
    customers.customer_id,
    customers.full_name,
    customers.city,
    ROUND(SUM(order_items.quantity * order_items.unit_price), 2) AS total_revenue
FROM customers
JOIN orders
    ON orders.customer_id = customers.customer_id
JOIN order_items
    ON order_items.order_id = orders.order_id
GROUP BY 
    customers.customer_id,
    customers.full_name,
    customers.city
ORDER BY total_revenue DESC
LIMIT 5;


--Products never sold
SELECT
    products.product_id,
    products.product_name,
    products.category
FROM products
LEFT JOIN order_items
    ON order_items.product_id = products.product_id
WHERE order_items.product_id IS NULL;


--Customers without orders
SELECT
	customers.customer_id,
    customers.full_name,
    customers.email
FROM
	customers
LEFT JOIN orders
	ON orders.customer_id = customers.customer_id
WHERE orders.customer_id IS NULL;


--Orders without payments
SELECT
	orders.*,
    payments.payment_id,
    payments.amount,
    payments.status
FROM
	orders
LEFT JOIN payments
	ON payments.order_id = orders.order_id
WHERE payments.status != 'Paid';


--Payment reconciliation
SELECT
    o.order_id,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS expected_total,
    ROUND(COALESCE(SUM(p.amount), 0), 2) AS paid_total,

    CASE
        WHEN COALESCE(SUM(p.amount), 0) = 0 THEN 'missing payment'
        WHEN SUM(p.amount) < 0 THEN 'refunded'
        WHEN SUM(p.amount) = SUM(oi.quantity * oi.unit_price) THEN 'matched'
        WHEN SUM(p.amount) < SUM(oi.quantity * oi.unit_price) THEN 'underpaid'
        WHEN SUM(p.amount) > SUM(oi.quantity * oi.unit_price) THEN 'overpaid'
    END AS payment_status

FROM orders o

JOIN order_items oi
    ON oi.order_id = o.order_id

LEFT JOIN payments p
    ON p.order_id = o.order_id

GROUP BY o.order_id
ORDER BY o.order_id;