What is the table name?
The table name is whatever appears after the FROM clause or in the CREATE TABLE statement (for example, orders).

What does one row represent?
One row represents one record (for example, one order, one customer, or one product, depending on the table).

Which columns are text?
Text columns are typically those with data types such as VARCHAR, CHAR, or TEXT, for example:
-customer_name
-product_name
-order_status

Which columns are numbers?
Number columns usually have data types like INT, DECIMAL, FLOAT, or NUMERIC, for example:
-quantity
-price
-order_id

Which column shows the order status?
The column named => status.

Which column can be used to calculate order value?
The quantity and price columns are used together.

What does quantity \* price mean in this table?
It calculates the total value of an order (or line item).

AFTER A MISTAKE ON PART 1 NAMING customer_name with cOstumer_name , I saw it and renamed correctly with the query sent on screenshots/part3

# Day 3 SQL Foundations Practice

This folder contains my SQL practice work from the Unity Tech Hub x Agilyti Data Engineering / Databricks training.

## Files:

- `setup.sql` - Creates the database table and inserts sample data.
- `sql_practice.sql` - Contains SQL queries for practice tasks.
- `custom_business_table.sql` - Includes a custom business table with SQL analysis queries.
- `pipeline_thinking.md` - Explains the data pipeline flow for my chosen business.
- `daily_report.txt` - Contains my short end-of-day learning report.

## Tools Used:

- SQLiteOnline.com

## What I Practiced:

- Creating tables with `CREATE TABLE`
- Adding data with `INSERT INTO`
- Selecting data with `SELECT`
- Filtering data using `WHERE`
- Combining conditions with `AND` and `OR`
- Sorting data with `ORDER BY`
- Limiting results with `LIMIT`
- Creating calculated columns using SQL expressions

## Project Summary:

In this practice, I worked with restaurant order data and learned how SQL can be used to organize, filter, calculate, and analyze business information.
