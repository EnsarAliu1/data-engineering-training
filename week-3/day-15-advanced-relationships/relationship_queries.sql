-- Part 5 - Create relationship_queries.sql

-- Show users together with their company name.
SELECT
    users.*,
    companies.company_name
FROM
    users
JOIN companies
    ON users.company_id = companies.company_id;


-- Show subscriptions together with company name and plan name.
SELECT
    subscriptions.*,
    companies.company_name,
    plans.plan_name
FROM
    subscriptions
JOIN companies
    ON subscriptions.company_id = companies.company_id
JOIN plans
    ON subscriptions.plan_id = plans.plan_id;


-- Show payments together with company name, plan name and subscription status.
SELECT
    payments.*,
    companies.company_name,
    plans.plan_name,
    subscriptions.status
FROM
    payments
JOIN subscriptions
    ON payments.subscription_id = subscriptions.subscription_id
JOIN companies
    ON subscriptions.company_id = companies.company_id
JOIN plans
    ON subscriptions.plan_id = plans.plan_id;


-- Show support tickets together with user name, user email and company name.
SELECT
    support_tickets.*,
    users.full_name,
    users.email,
    companies.company_name
FROM
    support_tickets
JOIN users
    ON support_tickets.user_id = users.user_id
JOIN companies
    ON users.company_id = companies.company_id;


-- Show all companies and their users using LEFT JOIN.
SELECT
    companies.*,
    users.*
FROM
    companies
LEFT JOIN users
    ON companies.company_id = users.company_id;


-- Show companies that currently have no users.
SELECT
    companies.*,
    users.*
FROM
    companies
LEFT JOIN users
    ON companies.company_id = users.company_id
WHERE
    users.user_id IS NULL;


-- Show users that have not opened any support tickets.
SELECT
    users.*,
    support_tickets.ticket_id
FROM
    users
LEFT JOIN support_tickets
    ON users.user_id = support_tickets.user_id
WHERE
    support_tickets.ticket_id IS NULL;


-- Show subscriptions that have no payments yet.
SELECT
    subscriptions.*,
    payments.payment_id
FROM
    subscriptions
LEFT JOIN payments
    ON subscriptions.subscription_id = payments.subscription_id
WHERE
    payments.payment_id IS NULL;


-- Show active subscriptions with pending or failed payments.
SELECT
    subscriptions.*,
    payments.payment_id,
    payments.payment_status
FROM
    subscriptions
JOIN payments
    ON subscriptions.subscription_id = payments.subscription_id
WHERE
    subscriptions.status = 'active'
    AND payments.payment_status IN ('pending', 'failed');