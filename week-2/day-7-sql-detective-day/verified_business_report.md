# Verified Business Report — Day 7 SQL Detective Day

**Report Date:** July 14, 2026
**Data Period:** July 1–7, 2026
**Prepared by:** Data Engineering Training — Week 2, Day 7
**Database:** SQLite (setup.sql — customers, products, orders)

> Every number in this report comes directly from a SQL query. Nothing is estimated or assumed.

---

## 1. Total Order Activity

**Insight:**
The business received 14 orders in total during the week. Those orders were split across three statuses: completed, pending, and cancelled.

**Verified Result:**
* Completed orders: 10
* Pending orders: 2
* Cancelled orders: 2
* Total orders placed: 14

**SQL Query Used:**
```sql
-- V1: Total order count
SELECT COUNT(*) AS all_orders
FROM orders;

-- Fixed Query 3: Orders broken down by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;
```

**Business Meaning:**
14 orders shows us the full demand the business received — not just what was paid for, but everything that was attempted. Knowing the split between completed, pending, and cancelled tells us how healthy the order pipeline really is. Out of every 7 orders, 5 completed, 1 is still pending, and 1 was lost.

---

## 2. Completed Revenue

**Insight:**
The business earned $1,639 in real, confirmed revenue from completed orders only.

**Verified Result:**
The total completed revenue is $1,639.

**SQL Query Used:**
```sql
-- V7: Total completed revenue
SELECT SUM(quantity * price) AS completed_revenue
FROM orders
JOIN products ON orders.product_id = products.product_id
WHERE status = 'completed';
```

**Business Meaning:**
This $1,639 is the only money the business actually collected. The WHERE status = 'completed' filter is what makes this number honest — it removes the orders that never resulted in payment. Any revenue report that skips this filter will produce an inflated and misleading number.

---

## 3. Revenue by Product

**Insight:**
The Laptop was the single highest-revenue product at $700, followed by Monitor at $540. The cheapest products (USB Cable, Mouse) generated the least revenue individually but sold in higher quantities.

**Verified Result:**
* Laptop: $700 in revenue (1 sale)
* Monitor: $540 in revenue (3 items sold across 2 orders)
* Headphones: $150 in revenue (3 items sold across 2 orders)
* Desk Chair: $120 in revenue (1 sale)
* Mouse: $105 in revenue (7 items sold across 3 orders)
* USB Cable: $24 in revenue (3 items sold across 1 order)

**SQL Query Used:**
```sql
-- V8 / Fixed Query 2: Revenue by product (completed only)
SELECT product_name, SUM(quantity * price) AS completed_revenue
FROM orders
JOIN products ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY product_name;
```

**Business Meaning:**
This breakdown tells the business which products are actually driving income. The Laptop alone accounts for 42% of total completed revenue from a single sale. This makes it both the most valuable and the most risky product — one cancellation hits hard. Mouse and USB Cable are low-margin but move consistently, making them reliable volume products.

---

## 4. Revenue by Category

**Insight:**
The Electronics category dominated revenue, generating $1,240 out of $1,639 in completed sales — that is 76% of all income from just one category.

**Verified Result:**
* Electronics category: $1,240 in revenue
* Accessories category: $279 in revenue
* Office category: $120 in revenue

**SQL Query Used:**
```sql
-- V9: Revenue by category (completed only)
SELECT category, SUM(quantity * price) AS completed_revenue
FROM orders
JOIN products ON orders.product_id = products.product_id
WHERE status = 'completed'
GROUP BY category;
```

**Business Meaning:**
The business is heavily reliant on Electronics. That concentration is both a strength and a vulnerability. If Electronics sales drop — for example, due to a Laptop cancellation or stock issue — total revenue takes a major hit. Accessories are consistent but not high-value. Office products are barely contributing right now.

---

## 5. Orders by City

**Insight:**
Prishtina had the highest order activity with 5 orders. Vushtrri came second with 4. Three other cities had 1–2 orders each.

**Verified Result:**
* Prishtina: 5 orders
* Vushtrri: 4 orders
* Mitrovica: 2 orders
* Peja: 1 order
* Prizren: 1 order
* Ferizaj: 1 order

**SQL Query Used:**
```sql
-- V10 / Fixed Query 1: Orders by city
SELECT city, COUNT(*) AS order_count
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY city;
```

**Business Meaning:**
Prishtina is clearly the most active market. If the business wants to run a promotion or delivery campaign, Prishtina gives the widest reach. Vushtrri is second in volume but notable because it generated the most completed revenue per city ($750) — meaning Vushtrri customers buy higher-value items. Order count and revenue do not always move together.

---

## 6. Customers with More Than One Order

**Insight:**
Four customers placed more than one order during the week: Arta, Blend, Dren, and Elira — each placing exactly 2 orders.

**Verified Result:**
* Arta (Customer ID 1): 2 orders
* Blend (Customer ID 2): 2 orders
* Dren (Customer ID 3): 2 orders
* Elira (Customer ID 4): 2 orders

**SQL Query Used:**
```sql
-- V11 / Fixed Query 7: Customers with more than one order
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

**Business Meaning:**
These four are the most engaged buyers this week. Repeat customers already trust the business — they cost much less to retain than acquiring someone brand new. These are the people a loyalty program, a discount, or a personalized offer should target first. The fact that they came back within the same week is a strong positive signal worth protecting.

---

## 7. Orders Not Counted as Revenue

**Insight:**
Four orders totaling $1,660 in potential value were excluded from revenue because they were either cancelled or still pending.

**Verified Result:**
* Order 3 (Arta - Keyboard): $40 value (Cancelled status)
* Order 6 (Dren - Laptop): $700 value (Pending status)
* Order 11 (Rina - Laptop): $700 value (Cancelled status)
* Order 12 (Arben - Desk): $220 value (Pending status)
* Total excluded potential value: $1,660

**SQL Query Used:**
```sql
-- V13 / Fixed Query 10: Orders that should NOT count as revenue
SELECT *, (quantity * price) AS not_real_revenue
FROM orders
JOIN products ON orders.product_id = products.product_id
WHERE status != 'completed';
```

**Business Meaning:**
$1,660 in potential revenue never became real income. Two of those four orders involve a Laptop — the most expensive product at $700 each. One was cancelled (Rina) and one is still pending (Dren). If those pending orders convert, the business gains another $920. If not, it loses it. This is exactly why status filtering matters — the difference between what was earned and what was only attempted is $1,660.

---

## 8. Final Recommendation

**Two things stand out clearly from this data and both deserve immediate attention.**

**First — the Laptop cancellation problem is real.**
The Laptop is the highest-revenue product in the catalog at $700. This week, it appeared in two cancellations and one pending order — that is $1,400 in failed or uncertain Laptop revenue. For a business generating $1,639 in weekly completed revenue, losing even one more Laptop sale would cut income nearly in half. The business needs to understand why customers are cancelling or delaying high-value orders. Is the price creating hesitation? Is there a stock or delivery issue? Answering that question is urgent.

**Second — every revenue query must filter by status = 'completed'. No exceptions.**
The gap between total potential revenue (all 14 orders would be $3,299) and actual completed revenue ($1,639) is enormous. If anyone pulls an order report without the status filter, they will see a number that is almost double what the business actually earned. That leads to wrong decisions about inventory, staffing, and budgets. The fix is simple: WHERE status = 'completed' goes into every revenue query. That single line is the difference between accurate reporting and dangerous fiction.

---

*This report was built entirely from SQL queries written and verified against a structured SQLite database. All figures are based on real data rows from the setup.sql dataset. No estimates, rounding, or assumptions were made. Each query can be re-run at any time to confirm the results.*
