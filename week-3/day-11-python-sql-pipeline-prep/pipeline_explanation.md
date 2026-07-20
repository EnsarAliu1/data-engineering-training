# Pipeline Explanation — Day 11, Week 3
# Part 1: Data Understanding

Before we touch any code, we need to actually look at the data we are working with.
This is something every data engineer does before building anything. If you skip this
step, you end up writing code that breaks because you did not know what was hiding
in the raw files.


---


## How many raw orders exist?

We opened orders_raw.csv and counted every row below the header.
There are 24 raw orders in total. That is 24 transactions that got recorded
into the system, but as we will see, not all of them are clean enough to use.


---


## Which columns are used to join orders with customers and products?

The orders file does not contain the customer name or the product name directly.
Instead it uses ID codes to reference them.

To connect orders to customers, we use the customer_id column.
Both orders_raw.csv and customers_raw.csv share that column,
so we match rows where the customer_id is the same in both files.

To connect orders to products, we use the product_id column.
Both orders_raw.csv and products_raw.csv share that column,
so we match rows where the product_id is the same in both files.

Think of it this way. The order is like a receipt that only has codes on it.
The customer file and the product file are the code books that tell you
what those codes actually mean.


---


## Which values look inconsistent?

Quite a few things jumped out when we read through the data carefully.

In the status column, the same thing is written in different ways.
Some orders say "completed" in lowercase, others say "Completed" with a capital C,
and two orders say "done" which means the same thing but uses a completely different word.
On top of that, some orders say "cancelled" with two L's and others say "canceled" with one L.
These all need to be standardised before we can trust any counts or filters on that column.

In the channel column, we have "online" and "Online" being treated as if they are different,
and the same issue with "store" and "Store". We also spotted two strange values: "web" and "bank".
Those do not match what we expect and are likely entry mistakes. One order also has
no channel recorded at all.

In the quantity column, things get worse. One order has no quantity at all, it is just blank.
One order has a quantity of -1 which makes zero sense because you cannot sell a negative number of items.
One order has the value "abc" typed in where a number should be.
And one order has a quantity of 0, meaning nothing was actually sold.

In the customers file, the city names are written in inconsistent capitalisation.
Prishtina appears as "prishtina" in lowercase for one customer, Vushtrri appears as
"VUSHTRRI" in full uppercase for another, and Ferizaj appears as "ferizaj" in lowercase.
This would cause problems in any city-level report because the system would treat them
as completely different cities.


---


## Which records should not be trusted for revenue?

Revenue is calculated by multiplying quantity by price. If either of those values
is missing, broken, or nonsensical, the row cannot be used.

Order 3 has no quantity so there is nothing to multiply.
Order 6 has a quantity of -1 which is not a real sale.
Order 7 has "abc" as the quantity which is not a number at all.
Order 9 has no order date so we cannot place it in time.
Order 17 references a product called P999 which does not exist anywhere in our
products file. The highest product ID we have is P010, so P999 is a ghost reference
and we cannot look up a price for it.
Order 22 has a quantity of 0 meaning nothing changed hands.

Beyond those technically broken records, we also need to be careful with orders
that have a status of cancelled, canceled, or returned. These are orders 4, 13, and 14.
The money from those either never arrived or was sent back, so they should not count
toward completed revenue.

In total that is nine orders we need to either discard or set aside.


---


## Which file is Bronze, which output should be Silver, and which output should be Gold?

In data engineering there is a well known approach called the Medallion Architecture.
It organises your data into three layers based on how clean and processed it is.

Bronze is your raw layer. It is the data exactly as it arrived, before anyone touched it.
In our project, the Bronze files are orders_raw.csv, customers_raw.csv, and products_raw.csv
sitting inside the data/bronze/ folder. We never modify these files. They are our backup
and our starting point. If something goes wrong, we come back here.

Silver is your cleaned layer. It is what you get after applying your quality rules
and fixing the problems we found above. In our project, the Silver output should be
orders_clean.csv for the rows that passed our checks, and invalid_orders.csv for the
rows that failed. These go into the data/silver/ folder. This is also where we enrich
the orders by joining them with customer and product information.

Gold is your business layer. It is the final, polished output that someone like a
manager or an analyst would actually open and read. In our project the Gold outputs are
revenue_by_category.csv, revenue_by_city.csv, top_customers.csv, and executive_summary.txt.
These live in data/gold/ and they contain aggregated numbers, no raw IDs, no messy values,
just clean summaries that answer real business questions.


---


Written as part of Week 3, Day 11 — Python and SQL Pipeline Prep.
Next step is building pipeline.py to automate everything we just described above.
