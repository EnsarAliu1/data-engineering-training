-- Part 4 - Create constraint_tests.sql

--Insert a user with a company_id that does not exist.
INSERT INTO users (company_id, full_name, email, role, is_active) VALUES
(999,'Arben Krasniqi','arben@technova.com','Admin',1)
--SQLITE_CONSTRAINT_UNIQUE: sqlite3 result code 2067: UNIQUE constraint failed: users.email

--Insert a subscription with a plan_id that does not exist.
INSERT INTO subscriptions (company_id, plan_id, start_date, status) VALUES
(1,999,'2026-01-10','active')
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed

--Insert a duplicate user email.
INSERT INTO users (company_id, full_name, email, role, is_active) VALUES
(1,'text test','arben@technova.com','Admin',1)
--SQLITE_CONSTRAINT_UNIQUE: sqlite3 result code 2067: UNIQUE constraint failed: users.email

--Insert a plan with a negative monthly_price.
INSERT INTO plans (plan_name, monthly_price, max_users) VALUES
('Basic',-49,10)
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: monthly_price > 0

--Insert a payment with amount = 0 or negative amount.
INSERT INTO payments (subscription_id, payment_date, amount, payment_status) VALUES
(1,'2026-02-10',-99,'paid')
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: amount > 0

--Insert a support ticket with an invalid priority.
INSERT INTO support_tickets
(user_id, issue_type, priority, status, created_date)
VALUES
(3,'Login issue','very high','open','2026-06-01')
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: priority IN ('low','medium','high')

--Insert a subscription with an invalid status.
INSERT INTO subscriptions (company_id, plan_id, start_date, status) VALUES
(1,2,'2026-01-10','delayed')
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: status IN ('active','paused','cancelled')

--Insert a payment with an invalid payment_status.
INSERT INTO payments (subscription_id, payment_date, amount, payment_status) VALUES
(1,'2026-02-10',99,'delayed')
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: payment_status IN ('paid','pending','failed')