# Query Explanations — Day 6 SQL Business Reporting Sprint

**File:** query_explanations.md
**Date:** July 13, 2026
**Sprint:** Week 2, Day 6 — SQL Business Reporting

These are real explanations of actual queries written during this sprint. Each one answers a specific business question using data from the orders, customers, and products tables.

---

## Query 1: Total Completed Revenue

**File:** basic_aggregations.sql

**Business question:** How much money did the business actually earn this week?

**The query:**
`sql
SELECT
    SUM(o.quantity * p.price) AS total_completed_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.status = 'completed';
`

**Tables used:** orders and products

**Why JOIN is needed:** The orders table only stores quantity and product_id. The actual price of each product lives in the products table. Without joining the two tables, we have no way to calculate how much money each order was worth.

**Why WHERE is needed:** We only want orders with status = 'completed'. Pending and cancelled orders did not generate any real income. If we skip this filter, we would be reporting money the business never received.

**Why SUM is needed:** Each completed order generates a different amount. SUM adds all of them together into one total number.

**What I understood:** Revenue is not just about how many orders exist — it is about multiplying the right quantity by the right price and only counting the orders that actually finished. This query proves that the business earned ,639 this week.

---

## Query 2: Completed Revenue by Product Name

**File:** join_reports.sql

**Business question:** Which individual product generated the most completed revenue?

**The query:**
`sql
SELECT
    product_name,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM products
JOIN orders
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY product_name;
`

**Tables used:** orders and products

**Why JOIN is needed:** The orders table knows which product_id was ordered, but the product_name and price are only in the products table. We need both pieces to show a readable name and calculate the value.

**Why WHERE is needed:** Only completed orders count as real revenue. Including cancelled or pending orders would show misleading numbers for each product.

**Why GROUP BY is needed:** Without GROUP BY, SQL cannot separate results by product. It would try to give us one single row. GROUP BY tells SQL to give us one row per product_name so we can compare them.

**What I understood:** The Laptop generated  in completed revenue — the highest of any product. This one product alone accounts for 43% of the total weekly revenue, which shows how important it is to keep it in stock and avoid cancellations.

---

## Query 3: Completed Revenue by Category

**File:** join_reports.sql

**Business question:** Which product category generated the most completed revenue?

**The query:**
`sql
SELECT
    category,
    SUM(orders.quantity * products.price) AS completed_revenue
FROM products
JOIN orders
    ON orders.product_id = products.product_id
WHERE orders.status = 'completed'
GROUP BY category;
`

**Tables used:** orders and products

**Why JOIN is needed:** The orders table has product_id, but the category and price are stored in the products table. We must join them to connect what was ordered with what category it belongs to.

**Why WHERE is needed:** Only completed orders should count as real revenue. A pending or cancelled order in the Electronics category has not actually made the business any money yet.

**Why GROUP BY is needed:** We need one result row per category, not one row per order. GROUP BY category tells SQL to combine all orders for Electronics together, all for Accessories together, and so on.

**What I understood:** Electronics generated ,240 in completed revenue — that is 76% of all weekly earnings. Accessories came in second and Office was last. This tells the business that Electronics is the engine of its income and should receive the most attention in terms of inventory and sales focus.

---

## Query 4: Order Count by City

**File:** join_reports.sql

**Business question:** Which city is placing the most orders?

**The query:**
`sql
SELECT
    city,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
GROUP BY city
ORDER BY order_count DESC;
`

**Tables used:** orders and customers

**Why JOIN is needed:** The orders table only stores customer_id, not the city name. The city is stored in the customers table. We join them so we can group orders by city instead of just by ID.

**Why GROUP BY is needed:** We want to see one row per city showing how many orders each city made. Without GROUP BY, SQL cannot separate the data by city.

**Why ORDER BY is needed:** Sorting by order_count DESC puts the most active city at the top, making it immediately easy to spot the leader.

**What I understood:** Prishtina leads with 5 total orders. Vushtrri comes second with 4. This shows where the customer base is most active and where a marketing campaign would reach the most buyers right away.

---

## Query 5: Completed Revenue by City

**File:** join_reports.sql

**Business question:** Which city brought in the most real revenue, not just the most orders?

**The query:**
`sql
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
`

**Tables used:** orders, customers, and products

**Why JOIN is needed:** This query needs three tables. City comes from customers, price comes from products, and everything connects through orders using customer_id and product_id.

**Why WHERE is needed:** We only want completed orders so the revenue numbers are real and accurate.

**Why GROUP BY is needed:** We want one revenue total per city. GROUP BY city merges all completed orders from the same city into a single row.

**What I understood:** Even though Prishtina had the most orders, Vushtrri topped the revenue chart at . This is because Arta from Vushtrri bought a Laptop worth . This is a great example of why order count and revenue are two different metrics — a city can have fewer orders but still generate more money if those orders are for high-value products.

---

## Query 6: Completed Revenue by Customer Name

**File:** join_reports.sql

**Business question:** Which customer spent the most on completed orders?

**The query:**
`sql
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
`

**Tables used:** orders, customers, and products

**Why JOIN is needed:** Customer names are in the customers table. Prices are in the products table. Orders only holds the linking IDs. All three tables are needed to build the full picture per customer.

**Why WHERE is needed:** We only want to count revenue from completed orders. A customer who placed an order that was later cancelled should not be credited with revenue they never actually paid.

**Why GROUP BY is needed:** We need one row per customer showing their total spend. Without GROUP BY, SQL cannot aggregate separately for each person.

**What I understood:** Arta is the top customer at , all from a single Laptop purchase. Leart is second at  from two Monitors. This tells us that our highest-value customers are not necessarily the ones who order most often — they are the ones who buy expensive products.

---

## Query 7: Customers with More Than One Order (HAVING)

**File:** join_reports.sql

**Business question:** Which customers placed more than one order this week?

**The query:**
`sql
SELECT
    customer_name,
    COUNT(*) AS order_count
FROM orders
JOIN customers
    ON orders.customer_id = customers.customer_id
JOIN products
    ON orders.product_id = products.product_id
GROUP BY customer_name
HAVING order_count > 1;
`

**Tables used:** orders, customers, and products

**Why JOIN is needed:** The orders table only has customer_id. We need to join with customers to display the actual customer name in the result.

**Why GROUP BY is needed:** We need to count how many orders each customer made. GROUP BY customer_name groups all their orders together so COUNT can give us the right number per person.

**Why HAVING is needed:** HAVING filters after the grouping is done. We cannot use WHERE here because WHERE filters individual rows before they are grouped, and at that point we do not yet know the order count per customer. HAVING lets us filter groups — in this case, keeping only customers whose order count is greater than 1.

**What I understood:** Arta, Blend, Dren, and Elira each placed more than one order. These four are the most loyal and engaged buyers this week. They are prime candidates for a loyalty reward or repeat-purchase discount since they already showed they come back on their own.

---

## Query 8: Non-Completed Revenue (Orders That Should Not Count)

**File:** basic_aggregations.sql

**Business question:** How much potential revenue was lost or is at risk from cancelled and pending orders?

**The query:**
`sql
SELECT
    SUM(o.quantity * p.price) AS total_non_completed_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.status = 'pending' OR status = 'cancelled';
`

**Tables used:** orders and products

**Why JOIN is needed:** Just like with completed revenue, we need the price from the products table. The orders table only stores quantity and product_id — no price.

**Why WHERE is needed:** This time WHERE is doing the opposite job — instead of keeping only completed orders, it keeps only pending and cancelled ones. This lets us isolate the value of orders that did not turn into real money.

**Why this should NOT be counted as revenue:** Pending orders are still unresolved — the customer has not finished paying and the order might still be cancelled. Cancelled orders are already confirmed losses — no money came in. Counting either of these as revenue would give a false picture of the business's financial health.

**What I understood:** The total non-completed value is ,660 — which is actually more than the real completed revenue of ,639. This means the business nearly left as much money on the table as it collected. The two cancelled Laptop orders alone represent ,400 in lost sales. This is a serious signal that the business needs to investigate why high-value orders are being cancelled.

---

*All queries above were written from scratch during the Day 6 sprint. Explanations are based on the actual data, actual results, and actual business questions answered by each query.*
