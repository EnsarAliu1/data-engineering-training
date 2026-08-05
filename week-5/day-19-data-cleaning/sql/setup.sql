SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE IF NOT EXISTS customers (
	customer_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL ,
    email VARCHAR(50) NOT NULL UNIQUE,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL ,
    created_at DATE NOT NULL,
    status VARCHAR(50) NOT NULL
    	CHECK (status IN ('active' , 'blocked' , 'unknown'))
);

CREATE TABLE IF NOT EXISTS products (
	product_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50) NOT NULL ,
    category VARCHAR(50) NOT NULL
    	CHECK (category IN ('Accessories' , 'Laptop' , 'Monitor' )),
    price REAL NOT NULL
    	CHECK (price > 0),
    stock_quantity INTEGER NOT NULL 
    	CHECK (stock_quantity >= 0 ),
    status VARCHAR(50) NOT NULL
    	CHECK (status IN ('active' , 'invalid'))
);

CREATE TABLE IF NOT EXISTS orders (
	order_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL
    	CHECK (status IN ('new' , 'completed', 'pending','cancelled','processing','unknown')),
    shipping_city VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
	order_item_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL
    	CHECK (quantity > 0),
    unit_price REAL NOT NULL 
    	CHECK (unit_price > 0)
);

CREATE TABLE IF NOT EXISTS payments (
	payment_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
    order_id INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    amount REAL NOT NULL
    	CHECK (amount > 0),
    currency VARCHAR (5) NOT NULL
    	CHECK (currency In ('EUR' , 'USD' )),
    status VARCHAR(10) NOT NULL 
    	CHECK (status IN ('Paid' , 'Refunded' , 'Failed' , 'Pending' , 'Unknown')),
    payment_method VARCHAR(20) NOT NULL
    	CHECK (payment_method IN ('Cash' , 'Card' , 'Paypal'))
);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE payments
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);


