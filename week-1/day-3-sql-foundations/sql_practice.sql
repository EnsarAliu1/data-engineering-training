-- PART 3

-- Level 1
-- 1. Show all columns and all rows from orders.
SELECT * FROM orders;

--2. Show only customer_name and product.
SELECT customer_name, product FROM orders

--3.Show only order_id, product, and status.
SELECT order_id, product, status FROM orders

--4. Show customer_name as customer and product as item using aliases.
SELECT customer_name as customer,
product AS item 
FROM orders;

--5. Show product, quantity, and price only.
SELECT product, quantity, price FROM orders

--6. Show order_id and customer_name only.
SELECT order_id, custumer_name FROM orders

--Level 2
--7. Show only completed orders.
SELECT * FROM orders WHERE status = 'completed'

--8. Show only pending orders.
SELECT * FROM orders WHERE status = 'pendings'

--9. Show only cancelled orders.
SELECT * FROM orders WHERE status = 'cacelled'

--10. Show orders where price is greater than 100.
SELECT * FROM orders WHERE price > 100

--11. Show orders where price is greater than 100.
SELECT * FROM orders WHERE price < 100

--12. Show orders where price is greater than or equal to 180.
SELECT * FROM orders WHERE price >= 180

--13. Show orders where status is not cancelled.
SELECT * FROM orders WHERE status != 'cancelled'

--14. Show orders where customer_name is Arta.
SELECT * FROM orders WHERE customer_name = 'Arta'

--15. Show orders where product is Mouse.
SELECT * FROM orders where product = 'Mouse'


--Level 3
--16. Show completed orders where price is greater than 50.
SELECT * FROM orders where status = 'completed' AND price > 50

--17. Show completed orders where product is Mouse.
SELECT * FROM orders where status = 'completed' AND product = 'Mouse'

--18. Show orders where status is pending OR status is cancelled.
SELECT * FROM orders where status = 'pending' OR status = 'cancelled'

--19. Show orders where customer_name is Dren AND status is completed.
SELECT * FROM orders where customer_name = 'Dren' AND status = 'completed'

--20. Show orders where product is Laptop AND price is 700.
SELECT * FROM orders where product = 'Laptop' AND price = 700

--21. Show orders where status is completed OR price is greater than 500.
SELECT * FROM orders where status = 'completed' OR price > 500

--22. Show orders where status is not cancelled AND price is greater than 100.
SELECT * FROM orders where status != 'cancelled' AND price > 100

--Level 4
--23. Show all orders from cheapest to most expensive.
SELECT * FROM orders order BY price ASC

--24. Show all orders from most expensive to cheapest.
SELECT * FROM orders order BY price DESC

--26. Show the cheapest 2 orders.
SELECT * FROM orders order BY price ASC LIMIT 2

--27. Show completed orders from highest price to lowest price.
SELECT * FROM orders WHERE status = 'completed' order BY price DESC 

--28. Show products sorted alphabetically by product name.
SELECT * FROM orders order BY product ASC 

--29. Show customers sorted alphabetically by customer_name.
SELECT * FROM orders order BY customer_name ASC 


--Level 5
--30. Show customer_name, product, quantity, price, and total_amount.
SELECT customer_name, product, quantity, price, quantity * price AS total_amount FROM orders

--31. Show only completed orders with total_amount.
SELECT quantity * price as total_amount, status FROM orders WHERE status = 'completed'

--32. Show completed orders with total_amount sorted from highest to lowest.
SELECT *,quantity * price AS total_amount FROM orders WHERE status = 'completed' ORDER BY quantity * price DESC;

--33. Show cancelled or pending orders with total_amount.
SELECT *,quantity * price AS total_amount FROM orders WHERE status = 'cancelled' OR status = 'pending' ORDER BY quantity * price DESC;

--34. Show customer_name as customer, product as item, and quantity * price as total_amount.
SELECT customer_name as customer , product AS item , quantity * price AS total_amount from orders

--35. Show the top 3 orders by total_amount.
SELECT quantity * price AS total_amount from orders ORDER BY total_amount DESC LIMIT 3

--36. Show only orders where total_amount is greater than 100. Hint: repeat the calculation in WHERE or filter byprice/quantity if needed.
SELECT quantity * price AS total_amount from orders WHERE total_amount > 100


--Part 4
SELECT *,quantity * price AS total_amount FROM orders WHERE status = 'cancelled' OR status = 'pending' ORDER BY quantity * price DESC;
--Explanation:
--this query selects all orders wheren the order is cancelled or in penging status and show total amount of order my multiplying quantity and price


SELECT customer_name as customer , product AS item , quantity * price AS total_amount from orders
--Expanation:
--this query shows name of customers as customer , products as items and shows total amount by multiplying price and quantity


SELECT * FROM orders WHERE status = 'completed' order BY price DESC 
--Explanation:
--this query shows completed orders from highest price to lowest


SELECT * FROM orders where status != 'cancelled' AND price > 100
--Explanation:
-- this query returns ordes that are not cancelled and price is higher than 100


SELECT * FROM orders where customer_name = 'Dren' AND status = 'completed'
--Explanation:
--this query returns orders from customer Dren and status of orders are completed