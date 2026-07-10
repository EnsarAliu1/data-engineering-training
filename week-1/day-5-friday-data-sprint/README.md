# Day 5 - Friday Data Sprint

Unity Tech Hub x Agilyti - Data Engineering / Databricks Training

Day 5 Friday Data Sprint - Group Challenge

---

## Business Scenario

We were given the role of data analysts for a small online shop that sells electronics, accessories, and office products to customers across different cities in Kosovo. The shop had 15 orders and needed answers to basic business questions: how much money was made, which products and cities were performing well, and which orders should not count as real revenue. We used Python and SQL to analyze the data and then presented our findings as if we were reporting to a real business owner.

---

## Group Members

- Urim Avdiu
- Ensar Aliu

---

## Files in This Folder

- data/orders.csv — the dataset we created with 15 customer orders
- setup.sql — creates the orders table in the database and inserts all the data
- sql_analysis.sql — all the SQL queries we wrote to answer the business questions
- python_analysis.py — the Python script that reads the CSV file and answers the same business questions using code
- business_insights.md — our answers to the 10 business questions, written for a business owner
- presatation_notes.md — our notes for the 3 to 5 minute group presentation
- individual_reflections/Urim_Avdiu.txt — Urim's personal reflection on the sprint
- individual_reflections/Ensar_Aliu.txt — Ensar's personal reflection on the sprint

---

## How to Run the Python Script

Make sure you have Python installed on your computer. Then open a terminal, go to the folder where python_analysis.py is saved, and run this command:

python python_analysis.py

The script will print the business report directly in the terminal, including total orders, completed revenue, most valuable order, and order counts by city and category.

---

## How to Run the SQL Files

We practiced SQL using the online tool at SQLiteOnline.com. You do not need to install anything. Just go to that website and follow these two steps:

Step 1 — Open setup.sql and run it first. This creates the orders table and fills it with all 15 orders.

Step 2 — Open sql_analysis.sql and run the queries one at a time. Each query has a comment above it explaining what it does.

Always run setup.sql before sql_analysis.sql, otherwise the table will not exist and the queries will not work.

---

## Most Important Insight

Out of a possible 5,235 EUR in total orders, only 3,950 EUR was confirmed revenue. That means 1,285 EUR was either lost or still uncertain because of cancelled, pending, and processing orders. The biggest opportunity for this business is to reduce cancellations and follow up on pending orders before they are lost.

---

## Tools Used

- Python for reading the CSV file and analyzing data with code
- SQL practiced on SQLiteOnline.com for querying and summarising the data
- CSV file created manually by both students together

---

*Prepared by Urim Avdiu and Ensar Aliu — Week 1, Day 5*
