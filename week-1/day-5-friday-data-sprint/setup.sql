-- Create the table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_name TEXT,
    city TEXT,
    product TEXT,
    category TEXT,
    quantity INTEGER,
    price REAL,
    status TEXT,
    order_date DATE
);

-- Insert data
INSERT INTO orders (
    order_id, customer_name, city, product, category,
    quantity, price, status, order_date
) VALUES
(1, 'Arta', 'Vushtrri', 'Laptop', 'Electronics', 1, 700, 'completed', '2026-07-01'),
(2, 'Blerim', 'Prishtina', 'Smartphone', 'Electronics', 2, 450, 'completed', '2026-07-02'),
(3, 'Donika', 'Peja', 'Headphones', 'Accessories', 3, 60, 'pending', '2026-07-02'),
(4, 'Luan', 'Gjakova', 'Office Chair', 'Office', 1, 180, 'completed', '2026-07-03'),
(5, 'Albulena', 'Ferizaj', 'Desk', 'Office', 1, 250, 'processing', '2026-07-03'),
(6, 'Erion', 'Mitrovica', 'Monitor', 'Electronics', 2, 220, 'completed', '2026-07-04'),
(7, 'Valbona', 'Gjilan', 'Keyboard', 'Accessories', 4, 35, 'completed', '2026-07-04'),
(8, 'Driton', 'Prizren', 'Mouse', 'Accessories', 5, 25, 'cancelled', '2026-07-05'),
(9, 'Flutura', 'Vushtrri', 'Printer', 'Office', 1, 150, 'pending', '2026-07-05'),
(10, 'Besnik', 'Prishtina', 'Tablet', 'Electronics', 2, 320, 'completed', '2026-07-06'),
(11, 'Merita', 'Peja', 'Filing Cabinet', 'Office', 1, 140, 'pending', '2026-07-06'),
(12, 'Arben', 'Ferizaj', 'Webcam', 'Accessories', 3, 80, 'completed', '2026-07-07'),
(13, 'Shpresa', 'Mitrovica', 'Gaming Console', 'Electronics', 1, 500, 'completed', '2026-07-08'),
(14, 'Gent', 'Gjilan', 'External SSD', 'Accessories', 2, 120, 'cancelled', '2026-07-08'),
(15, 'Elira', 'Prizren', 'Office Desk', 'Office', 1, 210, 'completed', '2026-07-09');