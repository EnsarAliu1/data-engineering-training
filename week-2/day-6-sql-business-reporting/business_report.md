# Business Report — Day 6 SQL Business Reporting Sprint

**Report Date:** July 13, 2026
**Data Period:** July 1–7, 2026
**Prepared by:** Data Engineering Training — Week 2, Day 6

---

## 1. Total Orders
**14 orders** were placed during the reporting week.

This is the full picture of all customer activity — every order regardless of whether it was completed, still waiting, or cancelled. It tells us how much demand the business received in total.

---

## 2. Completed Orders
**10 out of 14 orders** were completed.

That means 71% of all orders actually went through successfully. This is a healthy completion rate and shows that most customers who placed an order followed through to the end.

---

## 3. Pending Orders
**2 orders** are still pending.

These orders have been placed but not yet finalized. They could still go either way — completed or cancelled. The business should follow up on these to avoid losing that potential revenue.

---

## 4. Cancelled Orders
**2 orders** were cancelled.

Both cancellations involved a Laptop (order 3 and order 11), which is the highest-priced product in the catalog. This is worth paying attention to — high-value items may be getting abandoned more often.

---

## 5. Completed Revenue
**Total completed revenue: $1,639**

This is the only money the business actually earned. It comes from the 10 completed orders only. Pending and cancelled orders are not included here because no payment was collected for them.

---

## 6. Product with Highest Completed Revenue
**Laptop — $700**

Just one completed Laptop sale generated more revenue than any other product. This makes the Laptop the single most valuable product in the business right now. Losing even one Laptop sale (as seen in the cancellations) has a big financial impact.

---

## 7. Category with Highest Completed Revenue
**Electronics — $1,240**

The Electronics category (Laptops and Monitors) brought in $1,240 out of the total $1,639 in completed revenue. That is 76% of all revenue from just one category. The business is heavily dependent on Electronics performing well.

---

## 8. City with Most Orders
**Prishtina — 5 orders**

Prishtina had more orders than any other city, with 5 total across customers Blend, Elira, and Gresa. This makes Prishtina the most active market and a strong focus point for sales and marketing efforts.

---

## 9. City with Highest Completed Revenue
**Vushtrri — $750**

Even though Prishtina had more orders, Vushtrri generated the most completed revenue at $750. This is mainly driven by Arta's Laptop purchase ($700). This shows that order count alone does not tell the full story — order value matters just as much.

---

## 10. Customer with Highest Completed Revenue
**Arta — $700**

Arta placed just one completed order, but it was for a Laptop, making her the top revenue-generating customer this week. She is a high-value customer and worth prioritizing for retention and loyalty efforts.

---

## 11. Customers with More Than One Order
**4 customers placed more than one order:** Arta, Blend, Dren, and Elira.

These are the most engaged customers. They came back and ordered again within the same week. Repeat buyers are extremely valuable to a business because they cost less to retain than acquiring new customers.

---

## 12. Orders That Should Not Count as Real Revenue
**4 orders totaling $1,660 in potential value** should NOT be counted as real revenue.

- 2 cancelled orders: Keyboard ($40) + Laptop ($700) = $740
- 2 pending orders: Laptop ($700) + Desk ($220) = $920

**Total non-countable: $1,660**

These orders never generated actual income. Pending orders are still uncertain, and cancelled orders mean no money changed hands. Including them in revenue figures would make the business look better than it actually is — that is a misleading and dangerous reporting habit.

---

## 13. One Business Recommendation
**Focus on reducing Laptop cancellations.**

The Laptop is the highest-revenue product, but it also appeared in both cancellations this week. At $700 each, every cancelled Laptop order is a significant loss. The business should look into why customers are cancelling — is the price too high, is stock running out, or is there a delivery issue? Even recovering one of those cancellations per week adds $700 directly to the bottom line.

---

## 14. One Data Quality or Reporting Risk
**Reporting total orders as revenue is a serious risk.**

If someone pulls the total quantity or order count without filtering by status, the numbers will be inflated. For example, including pending and cancelled orders makes it look like the business earned $3,299 when the real completed revenue is only $1,639 — nearly double the actual number. Every revenue report must always filter by status = 'completed' to be accurate and trustworthy.

---

## 15. What This Report Would Help a Manager Decide

This report gives a manager a clear, honest summary of one week of business. With it, they can decide:

- **Where to invest marketing budget** — Prishtina has the most customers, so promotions there would reach the most people.
- **Which products to prioritize** — Electronics, especially the Laptop, drives the most revenue, so keeping stock available is critical.
- **Which customers to reward** — Repeat buyers like Arta, Blend, Dren, and Elira are ideal candidates for a loyalty program.
- **What to investigate** — Two Laptop cancellations in one week is a red flag that needs a follow-up before it becomes a pattern.
- **Whether the business is healthy** — A 71% completion rate and $1,639 in one week is a good starting point, but there is $1,660 in lost potential that the team should work to recover.

---

*This report was built entirely from SQL queries written against a structured orders database. All figures are based on real data rows — no estimates or assumptions were made.*
