DROP TABLE IF EXISTS clean_orders;

CREATE TABLE clean_orders (
    order_id INTEGER,
    customer_name TEXT,
    city TEXT,
    segment TEXT,
    product_name TEXT,
    category TEXT,
    quantity INTEGER,
    price REAL,
    status TEXT,
    channel TEXT,
    total_amount REAL
);

INSERT INTO clean_orders (
    order_id,
    customer_name,
    city,
    segment,
    product_name,
    category,
    quantity,
    price,
    status,
    channel,
    total_amount
) VALUES
(1, 'Arta', 'Vushtrri', 'Individual', 'Laptop', 'Electronics', 1, 700.0, 'completed', 'online', 700.0),
(2, 'Blend', 'Prishtina', 'Individual', 'Mouse', 'Accessories', 2, 15.0, 'completed', 'store', 30.0),
(4, 'Elira', 'Vushtrri', 'Individual', 'Keyboard', 'Accessories', 1, 40.0, 'cancelled', 'store', 40.0),
(5, 'Arta', 'Vushtrri', 'Individual', 'Mouse', 'Accessories', 3, 15.0, 'completed', 'online', 45.0),
(10, 'Jon', 'Prishtina', 'Business', 'Headphones', 'Accessories', 4, 50.0, 'pending', 'store', 200.0),
(11, 'Era', 'Vushtrri', 'Individual', 'Laptop', 'Electronics', 1, 700.0, 'completed', 'online', 700.0),
(12, 'Noar', 'Gjilan', 'Individual', 'Webcam', 'Electronics', 2, 90.0, 'completed', 'bank', 180.0),
(13, 'Sara', 'Peja', 'Business', 'Notebook', 'Office', 1, 5.0, 'cancelled', 'online', 5.0),
(14, 'Blend', 'Prishtina', 'Individual', 'Monitor', 'Electronics', 2, 180.0, 'returned', 'online', 360.0),
(15, 'Elira', 'Vushtrri', 'Individual', 'Keyboard', 'Accessories', 5, 40.0, 'completed', 'store', 200.0),
(18, 'Leart', 'Peja', 'Business', 'Desk', 'Office', 1, 220.0, 'completed', 'unknown', 220.0),
(19, 'Faton', 'Prizren', 'Individual', 'Chair', 'Office', 3, 120.0, 'pending', 'web', 360.0),
(20, 'Gresa', 'Prishtina', 'Business', 'USB Cable', 'Accessories', 2, 8.0, 'completed', 'online', 16.0),
(21, 'Nora', 'Ferizaj', 'Individual', 'Headphones', 'Accessories', 1, 50.0, 'completed', 'store', 50.0),
(23, 'Era', 'Vushtrri', 'Individual', 'Notebook', 'Office', 2, 5.0, 'completed', 'online', 10.0),
(24, 'Noar', 'Gjilan', 'Individual', 'Laptop', 'Electronics', 1, 700.0, 'completed', 'store', 700.0);



SELECT * FROM clean_orders;