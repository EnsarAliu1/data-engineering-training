-- PART 3

INSERT INTO
	customers(customer_name, city, segment)
VALUES 
	('Arta', 'Vushtrri', 'Individual'),
	('Blend', 'Prishtina', 'Business'),    
	('Dren', 'Mitrovica', 'Individual'),    
	('Elira', 'Peja', 'Business'),    
	('Leart', 'Ferizaj', 'Individual'),    
	('Gresa', 'Gjakova', 'Business');
    
    
INSERT INTO
	products(product_name, category, price)
VALUES 
	('Laptop', 'Electronics', 1200),
	('Monitor', 'Electronics', 300),    
	('Mouse', 'Accessories', 25),    
	('Keyboard', 'Accessories', 50),    
	('Desk', 'Office', 200),    
	('Headphone', 'Accessories', 200);
    
 
INSERT INTO
	orders (customer_id, order_date, status, channel)
VALUES
	(1, '2026-07-01', 'Completed', 'Online'),
	(2, '2026-07-02', 'Pending', 'Store'),
	(3, '2026-07-03', 'Cancelled', 'Online'),
	(4, '2026-07-04', 'Completed', 'Store'),
	(5, '2026-07-05', 'Pending', 'Online'),
	(6, '2026-07-06', 'Completed', 'Online'),
	(2, '2026-07-07', 'Completed', 'Store'),
	(1, '2026-07-08', 'Pending', 'Online');
    
INSERT INTO
	order_items (order_id, product_id, quantity)
VALUES
	(1, 1, 1),
	(1, 3, 2),
	(2, 2, 1),
	(2, 4, 1),
	(3, 6, 1),
	(4, 5, 2),
	(4, 3, 1),
	(5, 1, 1),
	(6, 6, 2),
	(6, 4, 1),
	(7, 2, 1),
	(7, 3, 3),
	(8, 5, 1);