# Day 11 - Python + SQL Pipeline Preparation


## Project Goal

The goal of this project is to build a real data pipeline from scratch using Python and SQL.
We start with raw, messy CSV files and end up with clean, trusted data that a business can
actually use to make decisions. Along the way we catch bad records, fix inconsistent values,
join data from multiple sources, and produce reports that answer real business questions.

This project follows the Medallion Architecture, which is a standard way data engineers
organise data in three stages. Bronze is raw, Silver is clean, and Gold is business-ready.
Everything here is built to be moved into a Databricks notebook later, so the logic is
kept modular and each function does exactly one job.


---


## Bronze Data


### What raw files did you receive?

We received three CSV files in the data/bronze/ folder. These are the original files
exactly as they arrived. We never touch them. If something breaks downstream, these
are our starting point again.

orders_raw.csv is the main file. It contains 24 order records with columns for the
order ID, customer ID, product ID, quantity, status, order date, and channel.

customers_raw.csv contains 12 customer records. Each row has a customer ID,
customer name, city, and segment (Individual or Business).

products_raw.csv contains 10 product records. Each row has a product ID, product name,
category, and price.


### What problems did you notice?

The data was not clean at all, which is completely normal in real projects. Here is
what we found when we inspected it manually before writing any code.

The status column had the same value written in multiple different ways. Some orders
said "completed" in lowercase, others said "Completed" with a capital letter, and two
said "done" which means the same thing but uses a different word entirely. On top of
that, "cancelled" appeared with two L's in some rows and one L in others.

The channel column had the same capitalisation problem. "online" and "Online" were
both present, and so were "store" and "Store". There were also two unexpected values
called "web" and "bank" that do not match standard channels. One order had no channel
at all.

The quantity column had four broken entries. One row had no quantity, one had -1 which
is physically impossible, one had the word "abc" instead of a number, and one had 0
which means nothing was sold.

Order number 9 had no order date, making it impossible to place on a timeline.
Order number 8 had no status at all.
Order number 17 referenced a product ID called P999 which does not exist anywhere
in the products file. The highest product we have is P010.

The customers file also had inconsistent city names. Prishtina was written as
"prishtina" in lowercase for one customer, Vushtrri was written as "VUSHTRRI" in
full uppercase for another, and Ferizaj was written as "ferizaj" in lowercase.


---


## Silver Data


### What validation rules did you apply?

Every order went through a series of checks before being allowed into the clean output.
If an order failed any single check, it was moved to the invalid file with a reason attached.

The order ID must exist and must not appear more than once. Duplicates are a sign
of a system error and cannot be trusted.

The customer ID must exist and must match a record in the customers file.
If we cannot find the customer, we cannot enrich the order with their details.

The product ID must exist and must match a record in the products file.
If we cannot find the product, we have no price and cannot calculate revenue.

The quantity must be present, must be a real number, and must be greater than zero.
Blank, text, negative, and zero quantities all fail this check.

The order date must be present. Without a date we cannot do any time-based analysis.

The status must normalize to one of our known values. If after normalization the status
is still unknown, the order is invalid.


### Which records became invalid and why?

Eight orders failed the checks and were moved to invalid_orders.csv.

Order 3 failed because its quantity was blank.
Order 6 failed because its quantity was -1.
Order 7 failed because its quantity was "abc", which is text, not a number.
Order 8 failed because it had no status at all.
Order 9 failed because it had no order date.
Order 16 failed because its customer ID, C013, does not exist in the customers file.
Order 17 failed because its product ID, P999, does not exist in the products file.
Order 22 failed because its quantity was 0.


### What did you normalize?

Status values were normalized to one of four consistent options: completed, pending,
cancelled, or returned. The word "done" was mapped to "completed". Both "cancelled" and
"canceled" were mapped to "cancelled". Casing differences were handled by lowercasing
everything before comparing.

City names were normalized using Python's built-in .title() method, which capitalises
the first letter of each word. This turned "prishtina" into "Prishtina" and "VUSHTRRI"
into "Vushtrri" automatically.

Channel values were normalized to lowercase. Any value that matched online, store, web,
or bank was kept as-is. Anything blank or unrecognised was set to "unknown".


---


## Gold Reports


### What business reports did you create?

We created four Gold output files in the data/gold/ folder.

revenue_by_city.csv shows the total completed revenue and the number of completed
orders broken down by city. The rows are sorted from highest revenue to lowest.

revenue_by_category.csv shows the same information but grouped by product category
instead of city. This helps identify which types of products are selling the most.

top_customers.csv shows every customer who placed at least one completed order,
ranked by how much money they spent in total. It includes their name, how many
completed orders they placed, and their total spend.

executive_summary.txt is a plain text report that brings all the key numbers together
in one place. It shows how many orders were processed, how many passed or failed,
the total completed revenue, the top city, the top product category, the top customer,
and a breakdown of every reason why orders were rejected.


### Which report is most useful for a manager?

The executive_summary.txt is the most useful for a manager because it does not require
them to open a spreadsheet or know what any column means. They can read it in under a
minute and walk away knowing how much money came in, where it came from, who the best
customer is, and how many orders had problems. That is exactly the kind of summary a
manager wants at the start of their day.


---


## Python vs SQL


### What did Python help you do?

Python handled the messy, logic-heavy parts of the pipeline that are hard to express
in a simple query. It loaded the raw CSV files, applied all the validation rules row
by row, normalized inconsistent values, joined orders with customers and products,
calculated revenue, and wrote every output file. Python was the right tool here because
we needed full control over the logic. We could check multiple conditions at once,
skip bad rows gracefully, and build the output exactly the way we wanted it.


### What did SQL help you do?

SQL made the reporting side much simpler. Once the data was clean and loaded into a
database, writing a query to group revenue by city or find the top customer by spend
is just a few lines. SQL is built for that kind of aggregation and filtering. It is
faster to write and easier to read than the equivalent Python loop. For the Gold layer
queries in particular, SQL expressed the intent clearly and concisely.


---


## Data Quality Notes

Out of 24 raw orders, 16 passed all validation checks and 8 were rejected.

The most common failure reason was invalid quantity, which affected 4 orders.
This suggests the system that generated the data does not enforce a minimum quantity
at the point of entry. That should be fixed at the source.

One order referenced a customer ID that does not exist in the customer file. This
points to a synchronisation issue between the order system and the customer system.

One order referenced a product that does not exist. This is a broken reference and
means either the product was deleted after the order was placed, or the product ID
was typed incorrectly.

The inconsistent city casing in the customer file suggests the data was entered
manually rather than selected from a dropdown. A future improvement would be to
enforce a validated city list at the point of data entry.


---


## Business Insights

The total completed revenue across all valid orders was $2,851.

Vushtrri was the highest revenue city with $1,655 from 5 completed orders.
Electronics was the top performing product category with $2,280 in completed revenue.
The top customer was Noar, who spent $880 across 2 completed orders.

Three orders were cancelled or returned, which means some revenue was lost or refunded.
These are worth monitoring over time to see if returns are increasing in any particular
category or from any particular city.

The pending orders represent potential revenue that has not yet been confirmed. Those
should be followed up on.


---


## What I Can Explain Live

I can walk through every function in pipeline.py and explain what it does and why it
is structured the way it is.

I can explain the difference between Bronze, Silver, and Gold and why we separate them
instead of just cleaning the data in one file.

I can explain what a lookup table is and why we use a dictionary instead of looping
through the customers list every time we process an order.

I can explain every validation rule and give a real example from the data of an order
that failed because of it.

I can explain why only completed orders count toward revenue and what happens to
pending and cancelled orders in the pipeline.

I can run the pipeline live from the terminal and show the output files being generated
in real time.


---


## What I Would Improve Next

The file paths are currently hardcoded as strings inside each function. A cleaner
approach would be to define all paths in one place at the top of the file so they
are easy to change without hunting through the code.

The pipeline currently only supports CSV files. In a real Databricks environment,
the input would come from Delta tables or cloud storage like ADLS. The load and write
functions would need to be updated to support those formats.

The executive summary is a plain text file right now. A future version could generate
a proper PDF or HTML report with charts and formatting that looks professional enough
to send directly to a stakeholder.

There is no logging in the current version. If the pipeline fails halfway through,
we only know from the terminal output. Adding proper logging with timestamps and
error messages would make debugging much easier in production.

The validation rules are embedded inside the create_silver_orders function. A better
design would be to define each rule as its own small function so they can be tested
independently and new rules can be added without changing existing logic.

Finally, none of the functions currently have automated tests. Adding unit tests for
each normalization function and each validation rule would give us confidence that
the pipeline handles edge cases correctly every time it runs.


---

Written as part of Week 3, Day 11 - Python and SQL Pipeline Preparation.
