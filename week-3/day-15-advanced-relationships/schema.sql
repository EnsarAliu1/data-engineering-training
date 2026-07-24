--Part 2 - Create schema.sql

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS plans;
DROP TABLE IF EXISTS companies;

CREATE TABLE companies(
    company_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name TEXT UNIQUE NOT NULL,
    city TEXT NOT NULL,
    industry TEXT NOT NULL
);

CREATE TABLE users(
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id INTEGER NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    role TEXT NOT NULL,
    is_active INTEGER CHECK (is_active IN  (0 , 1)),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

CREATE TABLE plans(
    plan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    plan_name TEXT UNIQUE NOT NULL,
    monthly_price INTEGER NOT NULL CHECK (monthly_price > 0),
    max_users INTEGER NOT NULL CHECK (max_users > 0)
);

CREATE TABLE subscriptions(
    subscription_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_id INTEGER,
    plan_id INTEGER,
    start_date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('active','paused','cancelled')),
    FOREIGN KEY (company_id) REFERENCES companies(company_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);


CREATE TABLE payments(
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subscription_id INTEGER,
    payment_date DATE NOT NULL,
    amount REAL NOT NULL CHECK (amount > 0),
    payment_status TEXT NOT NULL CHECK (payment_status IN ('paid','pending','failed')),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);


CREATE TABLE support_tickets(
    ticket_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    issue_type TEXT NOT NULL,
    priority TEXT NOT NULL CHECK (priority IN ('low','medium','high')),
    status TEXT NOT NULL CHECK (status IN ('open','in_progress','closed')),
    created_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


CREATE TABLE features(
    feature_id INTEGER PRIMARY KEY AUTOINCREMENT,
    feature_name TEXT NOT NULL UNIQUE
);

CREATE TABLE subscription_features(
    subscription_id INTEGER NOT NULL,
    feature_id INTEGER NOT NULL,
    PRIMARY KEY (subscription_id, feature_id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);