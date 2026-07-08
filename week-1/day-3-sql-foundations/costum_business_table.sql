--Part 5

CREATE TABLE restaurant_orders (
  order_id INTEGER,
  costumer_name TEXT,
  product TEXT,
  quantity INTEGER,
  price REAL,
  category TEXT,
  status TEXT
);

INSERT INTO restaurant_orders (order_id, costumer_name, product, quantity, price, category, status)
VALUES
(1, 'Ensar', 'Burger', 2, 8.50, 'Fast Food', 'Completed'),
(2, 'Erlis', 'Pizza', 1, 12.00, 'Italian', 'Pending'),
(3, 'Urim', 'Pasta', 3, 10.50, 'Italian', 'Completed'),
(4, 'Amar', 'Caesar Salad', 2, 7.50, 'Salad', 'Cancelled'),
(5, 'Eljesa', 'Chicken Sandwich', 1, 9.00, 'Fast Food', 'Completed'),
(6, 'Yllza', 'Sushi Roll', 4, 14.00, 'Japanese', 'Pending'),
(7, 'Korab', 'Tacos', 3, 6.50, 'Mexican', 'Completed'),
(8, 'Drin', 'Grilled Salmon', 2, 18.00, 'Seafood', 'Completed');


--37. Show all rows from your custom table.
SELECT * FROM restaurant_orders

--38. Show only 2 or 3 selected columns.
SELECT costumer_name, product, price FROM restaurant_orders;

--39. Filter rows by a text/status column.
SELECT * FROM restaurant_orders WHERE status = 'Completed';

--40. Filter rows by a numeric column using > or <.
SELECT * FROM restaurant_orders WHERE price > 10;

--41. Combine two conditions using AND.
SELECT * FROM restaurant_orders WHERE status = 'Completed' AND price > 10;

--42. Combine two conditions using OR.
SELECT * FROM restaurant_orders WHERE status = 'Completed' OR category = 'Italian';

--43. Sort rows from highest to lowest by a numeric column.
SELECT * FROM restaurant_orders ORDER BY price DESC;

--44. Limit the result to the top 3 rows.
SELECT * FROM restaurant_orders LIMIT 3;

--45. Create one calculated column using two existing columns.
SELECT *, quantity * price AS total_amount FROM restaurant_orders;

--46. Create one business-ready query that looks like something a manager would use.

SELECT costumer_name, product, quantity, price, quantity * price AS total_amount
FROM restaurant_orders
WHERE status = 'Completed'
ORDER BY total_amount DESC;