# Day 4 - Python and SQL Logic Review

This is my day 4 practice where I tried to compare Python with SQL. I wanted to see how to do the same things with both of them, like finding something, sorting, or adding numbers.

## Why did I do this?
The idea was to understand the difference between Python and SQL. In Python you have to write a for loop and check with "if" for everything step by step, but in SQL you just tell it "give me this" and the database finds it for you without trying too hard.

## What is inside this folder? (in simple words)
* [python_orders.py] - This is a big Python file where at the beginning there is a long list of orders with names, cities, prices, and products. After the list, there are many functions I wrote to find which orders are completed, which ones are cancelled, to sort them by price from most expensive to cheapest, and to calculate how much money we made from the completed orders. It does all of this using loops.

* [setup.sql] - This is only for creating the table in the database. Inside it has code that creates the table named "orders" and then inserts the same data as the Python file so we have it ready for SQL.

* [sql_queries.sql] - Here I wrote all the SQL queries (questions). It has codes that only pull names, code to find orders that cost more than 100 euros, as well as business codes like how much is the total profit or which is the most expensive order.

* [comparison.md] - Here I compared the codes. For each task I put the Python code on top and the SQL code on bottom so the difference is very easy to see, and I wrote what I understood for each one.

* [daily_report.txt] - An empty file that has nothing inside for now, maybe for other notes later.

* [screenshots/] - This is an empty folder where we can leave photos of the SQL results we got when running the code.

## How to run the Python file?
To start this `python_orders.py`, you need to open the terminal in this folder here and type:
`python python_orders.py`
And all those results of filters, sorting, and calculations that the code does will automatically show up on the screen.

## Where did I try SQL?
Since I didn't want to install a database on my computer, I used a website called [SQLiteOnline.com](https://sqliteonline.com/). You just copy the code from `setup.sql` to create the table there, and then you can try any query from `sql_queries.sql` to see the result directly.

## What did I learn from this comparison?
* In Python you have to write a lot of code with loops to find something, but in SQL you write it short with `WHERE`.
* To add numbers or multiply in Python you have to create variables and add them in a loop, but SQL does it on its own when you tell it `quantity * price AS total_amount`.
* Sorting the top 3 orders in Python requires complicated sorting functions and slicing the list with `[:3]`, but in SQL it is simple with `ORDER BY` and `LIMIT 3`.
* Python is better when you have to do complicated steps one after the other, but SQL is king for pulling data quickly from tables.
