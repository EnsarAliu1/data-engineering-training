# Data Pipeline Thinking - Day 3

## Chosen business:

Restaurant Ordering System

## Source Data:

The source data comes from customer orders, online orders, payment records, menu information, and customer details. The data includes customer names, products ordered, quantities, prices, categories, and order statuses.

## Ingestion:

The data is collected from the restaurant's ordering system and entered into a database. New orders, payments, and customer information are continuously added to the system.

## Storage:

The data is stored in database tables such as restaurant_orders, customers, and payments. Each table keeps organized information that can be used for analysis.

## Cleaning:

Cleaning means fixing problems in the data, such as:

- Correcting spelling mistakes in customer names or product names.
- Removing duplicate orders.
- Filling missing values.
- Making sure order statuses have consistent names like Completed, Pending, and Cancelled.

## Transformation:

The data can be transformed by creating useful calculations, such as:

- Calculating total order value using quantity × price.
- Finding the most popular products.
- Calculating daily or monthly revenue.
- Counting completed and cancelled orders.

## Business Output:

The final output can be a restaurant dashboard or report showing:

- Total sales revenue.
- Best-selling products.
- Number of completed orders.
- Customer order trends.

## Business questions we can answer:

1. Which products generate the most revenue?
2. How many orders are completed, pending, or cancelled?
3. Which customers place the most orders?

## Possible data problems:

1. Missing or incorrect customer information.
2. Duplicate orders in the database.
3. Incorrect prices or quantities causing wrong revenue calculations.
