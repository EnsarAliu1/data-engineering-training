-- Part 6 - Create business_reports.sql
--Total paid revenue from payments where payment_status = paid.
SELECT
	SUM(payments.amount) AS paid_revenue
FROM
	payments
WHERE payments.payment_status = 'paid';

--Paid revenue by company.
SELECT
	companies.company_name,
	SUM(payments.amount) AS paid_revenue
FROM
	payments
JOIN subscriptions
	ON payments.subscription_id = subscriptions.subscription_id
JOIN companies
	ON subscriptions.company_id = companies.company_id
WHERE payments.payment_status = 'paid'
GROUP BY companies.company_name;

--Paid revenue by plan.
SELECT
	plans.plan_name,
	SUM(payments.amount) AS paid_revenue
FROM
	payments
JOIN subscriptions
	ON payments.subscription_id = subscriptions.subscription_id
JOIN plans
	ON subscriptions.plan_id= plans.plan_id
WHERE payments.payment_status = 'paid'
GROUP BY plans.plan_id;

--Number of active subscriptions by plan.
SELECT
    plans.plan_name,
    COUNT(subscriptions.subscription_id) AS active_subscription_plan
FROM subscriptions
JOIN plans
    ON subscriptions.plan_id = plans.plan_id
WHERE subscriptions.status = 'active'
GROUP BY plans.plan_name;


--Number of users by company.
SELECT
	COUNT(users.user_id) as number_of_users,
    companies.company_name
FROM
	users
JOIN companies
	ON users.company_id = companies.company_id
GROUP BY
	companies.company_name;


--Support tickets by company.
SELECT
	COUNT(support_tickets.ticket_id) AS number_of_tickets,
    companies.company_name
FROM
	support_tickets
JOIN users
	ON support_tickets.user_id = users.user_id
JOIN companies
	ON users.company_id = companies.company_id
GROUP BY
	companies.company_name;


--Open support tickets by priority.
SELECT
	support_tickets.priority,
    COUNT(support_tickets.status) AS open_support_tickets
FROM
 	support_tickets
WHERE
	support_tickets.status = 'open'
GROUP BY support_tickets.priority;


--Companies with active subscriptions but unpaid/pending payments.
SELECT
	companies.*,
    subscriptions.status AS subscriptions_status,
    payments.payment_status
FROM
	companies
JOIN subscriptions
	ON subscriptions.company_id = companies.company_id
JOIN payments
	on payments.subscription_id = subscriptions.subscription_id
WHERE subscriptions.status = 'active' AND payments.payment_status IN ('pending' , 'failed');


--Top 5 companies by paid revenue.
SELECT
	companies.company_name,
	SUM(payments.amount) AS paid_revenue
FROM
	payments
JOIN subscriptions
	ON payments.subscription_id = subscriptions.subscription_id
JOIN companies
	ON subscriptions.company_id = companies.company_id
WHERE
	payments.payment_status = 'paid'
GROUP BY
	companies.company_name
ORDER BY
	paid_revenue DESC 
LIMIT 5;


--Average payment amount by plan.
SELECT
	plans.plan_name,
	AVG(payments.amount) AS avg_paid_revenue
FROM
	payments
JOIN subscriptions
	ON payments.subscription_id = subscriptions.subscription_id
JOIN plans
	ON subscriptions.plan_id= plans.plan_id
WHERE payments.payment_status = 'paid'
GROUP BY plans.plan_id;

--Companies with the highest number of support tickets.
SELECT
	COUNT(support_tickets.ticket_id) AS number_of_tickets,
    companies.company_name
FROM
	support_tickets
JOIN users
	ON support_tickets.user_id = users.user_id
JOIN companies
	ON users.company_id = companies.company_id
GROUP BY
	companies.company_name
ORDER BY number_of_tickets DESC;;


--A final executive summary query combining company, plan, revenue and ticket count.
SELECT
    companies.company_name,
    plans.plan_name,
    SUM(payments.amount) AS total_revenue,
    COUNT(DISTINCT support_tickets.ticket_id) AS total_tickets
FROM companies
JOIN subscriptions
    ON companies.company_id = subscriptions.company_id
JOIN plans
    ON subscriptions.plan_id = plans.plan_id
JOIN payments
    ON subscriptions.subscription_id = payments.subscription_id
LEFT JOIN users
    ON companies.company_id = users.company_id
LEFT JOIN support_tickets
    ON users.user_id = support_tickets.user_id
WHERE payments.payment_status = 'paid'
GROUP BY
    companies.company_name,
    plans.plan_name
ORDER BY
    total_revenue DESC;


--Part 7 - Advanced Challenge
SELECT
	companies.company_id,
    companies.company_name,
    features.feature_name,
    subscriptions.subscription_id
 FROM
 	companies
JOIN subscriptions
	ON subscriptions.company_id = companies.company_id
JOIN subscription_features
 	ON subscription_features.subscription_id = subscriptions.subscription_id
JOIN features
	ON subscription_features.feature_id = features.feature_id
GROUP by companies.company_name;
    
