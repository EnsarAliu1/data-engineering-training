PRAGMA foreign_keys = ON;

-- Companies
INSERT INTO companies (company_name, city, industry) VALUES
('TechNova','Prishtina','Software'),
('CloudSys','Prizren','Cloud Services'),
('DataWorks','Peja','Data Analytics'),
('CyberNet','Gjilan','Cyber Security'),
('SmartSolutions','Ferizaj','IT Consulting');

-- Plans
INSERT INTO plans (plan_name, monthly_price, max_users) VALUES
('Basic',49,10),
('Professional',99,30),
('Enterprise',199,100);

-- Users
INSERT INTO users (company_id, full_name, email, role, is_active) VALUES
(1,'Arben Krasniqi','arben@technova.com','Admin',1),
(1,'Sara Berisha','sara@technova.com','Developer',1),

(2,'Luan Gashi','luan@cloudsys.com','Admin',1),
(2,'Elira Hoxha','elira@cloudsys.com','Support',1),
(2,'Dren Kelmendi','dren@cloudsys.com','Developer',1),

(3,'Besa Shala','besa@dataworks.com','Manager',1),
(3,'Alban Rexha','alban@dataworks.com','Developer',0),

(4,'Fitim Morina','fitim@cybernet.com','Admin',1),
(4,'Mira Peci','mira@cybernet.com','Support',1),

(5,'Ariana Mustafa','ariana@smartsolutions.com','Manager',1),
(5,'Valon Hoti','valon@smartsolutions.com','Developer',1),
(5,'Edona Gashi','edona@smartsolutions.com','Support',1);

-- Subscriptions
INSERT INTO subscriptions (company_id, plan_id, start_date, status) VALUES
(1,2,'2026-01-10','active'),
(2,3,'2026-02-15','active'),
(3,1,'2026-03-01','paused'),
(4,2,'2026-01-20','cancelled'),
(5,3,'2026-04-05','active'),
(2,1,'2026-05-01','paused');

-- Payments
INSERT INTO payments (subscription_id, payment_date, amount, payment_status) VALUES
(1,'2026-02-10',99,'paid'),
(1,'2026-03-10',99,'pending'),

(2,'2026-03-15',199,'paid'),
(2,'2026-04-15',199,'paid'),
(2,'2026-05-15',199,'failed'),

(3,'2026-04-01',49,'paid'),
(3,'2026-05-01',49,'pending'),

(4,'2026-02-20',99,'failed'),

(5,'2026-05-05',199,'paid'),
(5,'2026-06-05',199,'paid'),

(6,'2026-06-01',49,'pending'),
(6,'2026-07-01',49,'paid');

-- Support Tickets
INSERT INTO support_tickets
(user_id, issue_type, priority, status, created_date)
VALUES
(3,'Login issue','high','open','2026-06-01'),
(3,'Password reset','medium','closed','2026-06-05'),

(4,'Billing question','low','closed','2026-06-10'),

(5,'API error','high','in_progress','2026-06-12'),
(5,'Database timeout','high','open','2026-06-20'),

(6,'Dashboard bug','medium','closed','2026-06-25'),

(7,'Report export failed','medium','open','2026-07-01'),

(8,'Email notification issue','low','closed','2026-07-02'),

(9,'Security alert','high','in_progress','2026-07-05'),

(10,'Subscription change','medium','open','2026-07-07'),

(11,'Performance issue','high','closed','2026-07-08'),

(12,'User access request','low','open','2026-07-10');


INSERT INTO companies (company_name, city, industry)
VALUES ('FutureSoft', 'Mitrovica', 'Software');

INSERT INTO subscriptions (company_id, plan_id, start_date, status)
VALUES
(1, 1, '2026-07-15', 'active'),
(4, 3, '2026-07-20', 'paused');


INSERT INTO features (feature_name) VALUES
('Cloud Storage'),
('Priority Support'),
('Analytics Dashboard'),
('API Access'),
('Custom Reports');


INSERT INTO subscription_features (subscription_id, feature_id) VALUES
(1,1),
(1,2),
(1,3),

(2,1),
(2,2),
(2,3),
(2,4),
(2,5),

(3,1),

(4,2),
(4,3),

(5,1),
(5,4),
(5,5),

(6,1),
(6,2);



