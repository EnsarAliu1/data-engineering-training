# ERD Explanation - Day 12

# PART 1

### 1. What are the main entities in this project?

The main entities are customers, products, orders, and order_items.
Each one of these represents a real-world thing that we need to track.
A customer is a person who buys. A product is what they buy. An order is the
transaction that happened. And order_items is the detail of exactly what was
inside each order.

---

### 2. Which table should store customers?

The customers table. It holds everything about the person placing the order,
their name, what city they are in, and what segment they belong to (like Consumer
or Business). We store this once here instead of repeating it everywhere.

---

### 3. Which table should store products?

The products table. It holds the product name, the category it belongs to,
and the price. We define a product once here and just reference it
by its ID whenever we need it elsewhere.

---

### 4. Which table should store orders?

The orders table. An order represents one transaction. It records when the
order happened, what the status is (like Pending or Completed), and which channel
it came from (like Online or Store). It also links back to the customer who
placed it through a foreign key.

---

### 5. Why should orders not repeat all customer and product details directly?

Because that would create a massive mess. Imagine storing the customer name,
city, and segment inside every single order row. If that customer moves cities,
you would have to update hundreds of rows. Same with products if a price
changes, you would have to hunt through thousands of order rows to fix it.

By keeping customer data in the customers table and product data in the products
table, you only store each piece of information once. Orders just point to the
right customer using a foreign key. This is called normalization and it keeps
our data clean and consistent.

---

### 6. What is the relationship between customers and orders?

It is a one-to-many relationship. One customer can place many orders over
time, but each individual order belongs to exactly one customer. So the orders
table has a customer_id column that points back to the customers table.

Think of it like this: a customer is a person, and they can have a whole history
of purchases. Each purchase (order) knows who made it, but a purchase can only
have one buyer.

---

### 7. What is the relationship between orders and products?

It is a many-to-many relationship. One order can contain multiple products,
and one product can appear across many different orders. For example, a laptop
might show up in hundreds of orders. And a single order might have a laptop,
a mouse, and a keyboard all together.

You cannot express many-to-many directly between two tables, that is exactly
why we need the order_items table in the middle.

---

### 8. Why do we need an order_items table?

Because of that many-to-many relationship between orders and products. The
order_items table sits in between them and acts as a bridge. Each row in
order_items represents one product inside one order, along with the quantity
purchased.

Without this table, there would be no clean way to say Order 5 had 3 products
in it. You would end up duplicating rows or cramming multiple products into one
column, both of which are terrible ideas in a relational database.

So order_items breaks the many-to-many into two clean one-to-many relationships:

- One order -> many order_items
- One product -> many order_items

---

## Visual Overview

\*Notice this visual overview is generated with AI with the help of my explanation.
`customers
    |
    | (one-to-many)
    |
  orders
    |
    | (one-to-many)
    |
order_items -----> products
              (many-to-one)`

- orders.customer_id -> references customers.customer_id
- order_items.order_id -> references orders.order_id
- order_items.product_id -> references products.product_id

---

## Summary Table

\*Notice this visual overview is generated with AI with the help of my explanation.

| Relationship            | Type         | How it works                      |
| ----------------------- | ------------ | --------------------------------- |
| customers -> orders     | One-to-Many  | One customer, many orders         |
| orders -> order_items   | One-to-Many  | One order, many line items        |
| products -> order_items | One-to-Many  | One product appears in many items |
| orders <-> products     | Many-to-Many | Resolved through order_items      |

The whole point of this design is to store data once, reference it by ID,
and never repeat yourself. That is the foundation of a well-structured
relational database.
