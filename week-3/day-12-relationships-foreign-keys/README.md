# PART 5

Explain the difference between INNER JOIN and LEFT JOIN in README.md.

## INNER JOIN vs LEFT JOIN

**INNER JOIN** returns only records that have a match in both tables.

**LEFT JOIN** returns all records from the left table and matching records from the right table. If there is no match, it shows NULL values.

Example:

- INNER JOIN customers + orders → only customers with orders.
- LEFT JOIN customers + orders → all customers, including those without orders.

---

# Part 7 - Day 12 Full Documentation

# Day 12 - Relationships, Foreign Keys, and JOINs

---

## Project Goal

The goal of Day 12 was to move past writing basic queries and actually understand
how a relational database is supposed to be structured. Up until now I was working
with flat tables. Today I built a proper multi-table system where tables talk to
each other through keys and rules.

By the end of the day I could create tables with foreign keys, write JOIN queries
that pull data from multiple tables at once, and prove that my constraints actually
work by intentionally trying to break them.

---

## Database Tables

I built four tables that together represent a small order management system.

**customers** - stores the people who place orders. Each customer has an ID,
a name, a city, and a segment (Individual or Business).

**products** - stores the items that can be sold. Each product has an ID, a name,
a category, and a price.

**orders** - stores each transaction. An order belongs to one customer and records
the date, the status, and the channel it came through.

**order_items** - stores the individual lines inside each order. Each row links
one order to one product and records how many units were purchased. This table
is the bridge between orders and products.

---

## Primary Keys

Every table has a primary key. A primary key is a column that uniquely identifies
each row. No two rows in the same table can have the same primary key value, and
it can never be NULL.

In this project every primary key is an integer. For example:

- customer_id is the primary key of the customers table
- product_id is the primary key of the products table
- order_id is the primary key of the orders table
- order_item_id is the primary key of the order_items table

The database uses these IDs to connect tables to each other. When orders wants
to say which customer placed it, it stores that customer's primary key value
in its own column. That value is called a foreign key.

---

## Foreign Keys

A foreign key is a column in one table that points to the primary key of another
table. It creates a link between two tables and enforces that the link is real.

In this project:

- orders.customer_id references customers.customer_id
- order_items.order_id references orders.order_id
- order_items.product_id references products.product_id

This means you cannot insert an order for a customer that does not exist. You
cannot insert an order_item for an order that does not exist. The database checks
the reference first and if it finds nothing, it rejects the insert.

One important thing I learned: SQLite does not enforce foreign keys by default.
You have to run this at the start of every session:

`sql
PRAGMA foreign_keys = ON;
`

Without that line, SQLite accepts any value in a foreign key column even if it
points to nothing. That was a real surprise.

---

## Auto Increment

AUTOINCREMENT means the database assigns the ID value automatically every time
you insert a new row. You do not have to think about what number to use next.

So if I insert three customers, they automatically get customer_id values of
1, 2, and 3. If I delete customer 3 and insert a new one, AUTOINCREMENT in
SQLite guarantees the new one gets a value higher than any previously used ID.
It will never reuse an old number.

This matters because primary keys should never change or be reused. If an ID
gets recycled, it could accidentally point to the wrong record.

---

## Relationships

There are two types of relationships in this project.

**One-to-Many**
One customer can have many orders. But each order belongs to exactly one customer.
This is a one-to-many relationship. The many side (orders) holds the foreign key.

Same pattern: one order can have many order_items, but each order_item belongs
to exactly one order.

**Many-to-Many**
One order can contain many products, and one product can appear in many different
orders. This is many-to-many. You cannot represent this directly with just two
tables. You need a third table in the middle to break it apart.

That is exactly what order_items does. It turns the many-to-many between orders
and products into two separate one-to-many relationships.

`customers --> orders --> order_items --> products`

---

## Valid and Invalid Insert Tests

I wrote tests in relationship_tests.sql to prove the constraints work. Every
test below was designed to fail on purpose.

A valid insert has to follow all three rules at the same time:

1. Every foreign key must point to a row that actually exists
2. Every CHECK constraint must evaluate to true
3. No NOT NULL column can be skipped

---

## INNER JOIN vs LEFT JOIN

This was already covered in Part 5 but it is worth putting in full context here.

**INNER JOIN** only returns rows where there is a match in both tables. If a
customer has no orders, they do not show up at all.

**LEFT JOIN** returns every row from the left table no matter what. If a customer
has no orders, they still appear in the result but with NULL in the order columns.

When to use which:

- Use INNER JOIN when you only care about records that have a complete link.
  For example, show me all orders with customer details.

- Use LEFT JOIN when you need to find records that have no match. For example,
  show me all customers even if they have never placed an order. Those are
  the ones you might want to follow up with.

`sql
-- INNER JOIN example
SELECT customers.customer_name, orders.order_id
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id;

-- LEFT JOIN example
SELECT customers.customer_name, orders.order_id
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;
`

---

## Business Reports

Using JOINs I was able to write queries that answer real business questions.
These are the kinds of things a data analyst or data engineer would actually
be asked to produce.

**Total revenue per customer**
Join orders and order_items and products together, then group by customer
to get a sum of quantity multiplied by price for each person.

**Orders per channel**
Count how many orders came through Online vs Store. This tells the business
which sales channel is more active.

**Most ordered products**
Join order_items to products and count how many times each product appears
across all orders. Sort descending to find the top sellers.

**Customers with no orders**
Use a LEFT JOIN from customers to orders and filter WHERE orders.order_id IS NULL.
These are customers who signed up but never bought anything.

The power of the multi-table design is that you can answer all of these questions
with SELECT queries. You do not need to store pre-calculated totals anywhere
because the relationships let you compute them on demand.

---

## What I Can Explain Live

- What a primary key is and why every table needs one
- What a foreign key is and how it links two tables
- The difference between one-to-many and many-to-many relationships
- Why order_items exists and what problem it solves
- What PRAGMA foreign_keys = ON does and why SQLite needs it
- The difference between INNER JOIN and LEFT JOIN with a real example
- What CHECK constraints do and how to test that they work
- Why normalization matters and what goes wrong without it

---

## What I Would Improve Next

**Add timestamps.** Right now orders only store a date. Adding created_at and
updated_at columns would make it possible to track exactly when things changed.

**Add a unit_price column to order_items.** Currently to calculate revenue you
have to join all the way to the products table to get the price. But what if
the price changes tomorrow? The historical order would then show the wrong
revenue. Storing the price at the time of purchase in order_items would fix this.

**Add indexes.** On a bigger dataset, joining on customer_id or order_id without
an index would get slow. Adding indexes on foreign key columns is a standard
performance improvement.

**More realistic data.** The test data I inserted is clean and simple. Real data
has gaps, nulls in unexpected places, and values that do not match what the
schema expects. Testing against messier data would expose more edge cases.

**Views for reports.** Instead of rewriting the same JOIN query every time,
I could create a SQL view that wraps the query and lets me query it like a table.
