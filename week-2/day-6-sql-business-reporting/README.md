# Day 6 - SQL Business Reporting Sprint

## Goal

The goal of this practice was to learn how to use SQL not just to pull data, but to answer real business questions. Instead of writing random queries, every query in this sprint was written to solve a specific problem — like finding out which city brought in the most revenue, which product was cancelled the most, or which customers came back to order again.

By the end of this sprint, the data was turned into a full business report with real numbers, real insights, and real recommendations — exactly what a data analyst or data engineer would deliver at work.

---

## Files in This Folder

| File | What it contains |
|------|-----------------|
| setup.sql | Creates the three tables (customers, products, orders) and loads all sample data. Always run this first. |
| asic_aggregations.sql | Simple COUNT, SUM, AVG, MIN, MAX queries. Used to get totals across the whole dataset. |
| group_by_reports.sql | Queries that group results by status, customer, product, and date. Also includes HAVING filters. |
| join_reports.sql | Queries that connect two or three tables together to get full business reports by city, customer, and category. |
| usiness_report.md | The written business report. Turns all SQL results into plain business language with insights and recommendations. |
| query_explanations.md | Explains 8 key queries in detail — what tables were used, why each clause was needed, and what the result means. |
| README.md | This file. Explains the whole sprint, how to run the files, and the key concepts used. |

---

## How to Run the SQL Files

This project was run entirely on **SQLiteOnline.com** — a free, browser-based SQL tool that requires no installation.

Run the files in this exact order:

1. **setup.sql** — Run this first. It drops any old tables, creates fresh ones, and loads all the customer, product, and order data. If you skip this step, nothing else will work.
2. **asic_aggregations.sql** — Run this second. These are standalone SELECT queries. You can run them one at a time or all together.
3. **group_by_reports.sql** — Run this third. These queries use GROUP BY and HAVING to break results into groups.
4. **join_reports.sql** — Run this last. These queries connect multiple tables and build the full business reports.

> To run on SQLiteOnline.com: go to https://sqliteonline.com, paste the contents of each file into the editor, and click Run. No account needed.

---

## Key SQL Concepts Used — In Plain Words

### Basic Aggregation
Basic aggregation means taking a column full of numbers and collapsing it into one answer. Functions like COUNT, SUM, AVG, MIN, and MAX do this. For example, instead of seeing all 14 order rows, you ask SQL to count them and get back the number 14. It is the simplest way to turn a table of data into a single meaningful number.

### GROUP BY
GROUP BY takes that same idea and applies it to groups instead of the whole table. Instead of asking "how many total orders are there?", you ask "how many orders does each city have?" GROUP BY splits the rows into buckets — one per city, one per category, one per customer — and then runs the aggregation inside each bucket separately. Without GROUP BY, every comparison report would be impossible.

### HAVING
HAVING works like a filter, but it runs after the grouping is already done. WHERE filters individual rows before they are grouped. HAVING filters the groups after they are formed. For example, if you want to see only customers who placed more than one order, you cannot use WHERE because at that point SQL has not counted the orders yet. HAVING lets you say "only show me groups where the count is greater than 1." It is the tool that makes conditional grouping possible.

### JOIN
JOIN connects two or more tables by matching a shared column between them. In this project, the orders table does not contain product names or customer cities — those live in separate tables. A JOIN bridges the gap. When we write ON orders.product_id = products.product_id, we are telling SQL to find the matching row in products for each order row and combine them into one result. Without JOIN, it would be impossible to answer any question that involves data spread across multiple tables — which is almost every real business question.

---

## Most Important Business Insight

**The Laptop is the business's biggest strength and biggest risk at the same time.**

The Laptop is the highest-priced product at  and it generated more completed revenue than any other product this week. One single Laptop sale from Arta made Vushtrri the top revenue city — ahead of Prishtina which had more orders.

But the Laptop also appeared in both cancellations this week. Orders 3 and 11 were both Laptop purchases that were cancelled, representing ,400 in lost revenue. The total non-completed value across all cancelled and pending orders was ,660 — almost exactly as much as the ,639 that was actually earned.

This tells the business one clear thing: fix the Laptop cancellation problem. Every recovered Laptop sale adds  directly to the bottom line. That single improvement would have a bigger financial impact than improving any other area of the business right now.

---

*Sprint completed: July 13, 2026 — Week 2, Day 6 of the Data Engineering Training program.*
