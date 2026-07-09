# Part 3

--Show completed orders task
--Python Logic
Loop through orders and keep records where status is completed.

> def orders_by_status(status):
> for order in orders:
> if order["status"] == status:
> print(f"{order['customer_name']} - {order['product']}")
>
> print("Completed orders:")
> orders_by_status("completed")

--SQL LOGIC
Use WHERE status = 'completed';.

> SELECT
>
> - FROM
>   orders
>   WHERE
>   status = 'completed';

What I understood:
Both approaches filter rows. Python uses a loop and if statement. SQL filters directly from the table using WHERE.

--Show orders with price > 100 task
--Python Logic
Use an if statement checking price > 100.

> def high_price_orders():
> for order in orders:
> if order["price"] > 100:
> print(
> f"{order['customer_name']} - {order['product']} - {order['price']}")
>
> print("Orders with price higher than 100:")
> high_price_orders()

--SQL Logic
Use WHERE price > 100.

> SELECT
>
> - FROM
>   orders
>   WHERE
>   price > 100;

What I understood:
Both approaches filter rows. Python uses a loop and if statement to check the price above 100. SQL filters directly from the table using WHERE the price is above 100.

Calculate total_amount task
--Python Logic
Multiply quantity \* price inside a loop.

> def total_amount():
> for order in orders:
> total_amount = order['quantity'] \* order['price']
> print(
> f"{order['customer_name']} - {order['product']} - {order['quantity']} - {order['price']} - {total_amount}")
>
> print("Order totals:")
> total_amount()

--SQL Logic
Use quantity \* price AS total_amount.

> SELECT
> customer_name,
> product,
> quantity,
> price,
> quantity \* price AS total_amount
> FROM orders

What I understood
Both calculate a new value called total_amount by multiplying quantity and price. In Python, this is done inside a for loop for each order. In SQL, the calculation is performed directly in the SELECT statement using quantity \* price AS total_amount, which creates a calculated column in the query result (it does not add a new column to the table).

Sort by price descending task
--Python Logic
Use sorted() with price as the key.

> def sorting_orders_by_price(reverse=False):
> sorted_orders = sorted(orders, key=get_price, reverse=reverse)
>
> for order in sorted_orders:
> print(
> f"{order['customer_name']} - {order['product']} - ${order['price']}")
>
> print("Highest to Lowest by proice:")
> sorting_orders_by_price(True)

--SQL Logic
Use ORDER BY price DESC.

> SELECT
>
> - FROM
>   orders
>   ORDER BY
>   price DESC;

What I understood:
Both sort the orders by price in descending order. In Python, sorted() is used with price as the sorting key and reverse=True to sort from highest to lowest. In SQL, ORDER BY price DESC sorts the query results in descending order based on the price column.

Show top 3 orders task
--Python Logic
Sort first, then use [:3].

> def sorting_orders_by_total_amount(reverse=False):
> sorted_orders = sorted(orders, key=get_total_amount, reverse=reverse)
>
> print("Highest to Lowest by total amount:")
> for order in sorted_orders:
> print(
> f"{order['customer_name']} - {order['product']} - {get_total_amount(order)}")
>
> print()
>
> ---
>
> print("Top 3 orders by total amount:") |
> for order in sorted_orders[:3]: |
> print( |
> f"{order['customer_name']} - {order['product']} - {get_total_amount(order)}") |
> |
>
> ---

--SQL Logic
Use ORDER BY ... LIMIT 3.

> SELECT
> order_id,
> customer_name,
> product,
> quantity,
> price,
> quantity \* price AS total_amount
> FROM
> orders
> ORDER BY
> total_amount DESC
> LIMIT
> 3;

What I understood:
Both show the top 3 orders with the highest total amount. In Python, the orders are first sorted by total amount, and then the first three orders are selected using [:3]. In SQL, ORDER BY total_amount DESC sorts the results from highest to lowest, and LIMIT 3 returns only the first three rows.
