-- PART 4

-- FOREIGN KEY TEST 1
-- Insert an order for a customer_id that does not exist.
-- customer_id 9999 was never inserted into the customers table.
-- Expected error: FOREIGN KEY constraint failed

INSERT INTO orders (customer_id, order_date, status, channel)
VALUES (9999, '2024-01-15', 'Pending', 'Online');

-- Why this matters:
-- Without this protection we would have orders floating in
-- the system with no real owner. Every JOIN back to customers
-- would return NULL or simply break.


-- FOREIGN KEY TEST 2
-- Insert an order_item with an order_id that does not exist.
-- order_id 9999 was never inserted into the orders table.
-- Expected error: FOREIGN KEY constraint failed

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (9999, 1, 2);

-- Why this matters:
-- An order_item that belongs to no real order is an orphan.
-- It would pollute inventory counts and revenue reports.


-- FOREIGN KEY TEST 3
-- Insert an order_item with a product_id that does not exist.
-- product_id 9999 was never inserted into the products table.
-- Expected error: FOREIGN KEY constraint failed

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 9999, 1);

-- Why this matters:
-- Without a real product reference we cannot look up the name
-- or price. We would essentially be selling a ghost product.


-- CHECK TEST 1 - price must be greater than 0
-- The schema has CHECK (price > 0) on the products table.
-- Trying price = 0:
-- Expected error: CHECK constraint failed: products

INSERT INTO products (product_name, category, price)
VALUES ('Broken Item', 'Electronics', 0);

-- Also trying a negative price:
-- Expected error: CHECK constraint failed: products

INSERT INTO products (product_name, category, price)
VALUES ('Negative Price Item', 'Office', -50);

-- Why this matters:
-- A product priced at zero or below would silently destroy
-- any revenue or profit calculation downstream.


-- CHECK TEST 2 - quantity must be greater than 0
-- The schema has CHECK (quantity > 0) on order_items.
-- Expected error: CHECK constraint failed: order_items

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 0);

-- Why this matters:
-- A quantity of zero means nothing was actually ordered.
-- It adds noise to stock tracking and order summaries.


-- STATUS TEST
-- Try inserting an order with status 'done'.
-- The schema only allows: Pending, Cancelled, Completed.
-- Expected error: CHECK constraint failed: orders

INSERT INTO orders (customer_id, order_date, status, channel)
VALUES (1, '2024-01-15', 'done', 'Online');

-- Why this matters:
-- Free-text status means you end up with 'done', 'Done',
-- 'DONE', 'finished' all meaning the same thing. Filtering
-- becomes inconsistent and reports break.


-- CORRECT INSERTS - these should all succeed (for reference)
-- Run schema.sql first to start with a clean database.

-- Step 1: valid customer
INSERT INTO customers (customer_name, city, segment)
VALUES ('Ensar Aliu', 'Skenderaj', 'Business');

-- Step 2: valid product
INSERT INTO products (product_name, category, price)
VALUES ('Wireless Mouse', 'Accessories', 25);

-- Step 3: valid order (customer_id 1 now exists)
INSERT INTO orders (customer_id, order_date, status, channel)
VALUES (1, '2024-01-15', 'Pending', 'Online');

-- Step 4: valid order_item (order_id 1 and product_id 1 now exist)
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 2);
