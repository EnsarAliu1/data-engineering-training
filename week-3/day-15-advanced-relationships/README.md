# SaaS Platform Database Project

## Project Goal

The goal of this project was to design and build a normalized relational database that represents how a SaaS platform manages users, subscriptions, payments, and support activity. Beyond just setting up tables, the main focus was enforcing data integrity directly inside SQLite using primary keys, foreign keys, and check constraints so bad data gets blocked before reaching downstream reporting scripts.

## Business Scenario

The database models a SaaS company providing software services to corporate client accounts. Clients choose subscription tiers like Basic, Professional, or Enterprise. Each company has multiple employee users using the platform, and payments are billed against active subscriptions. Users can open support tickets when issues arise. Five Kosovo-based companies (TechNova, CloudSys, DataWorks, CyberNet, and SmartSolutions) were seeded as real-world examples to test billing and support operations.

## Tables Created

The companies table serves as the root account entity storing company names, locations, and industries.

The users table holds employee account records linked to a company, capturing full names, unique emails, access roles, and active status.

The plans table defines the subscription packages, storing monthly pricing and user limits for Basic, Professional, and Enterprise tiers.

The subscriptions table connects companies to plans, recording the start date and whether the subscription is active, paused, or cancelled.

The payments table tracks billing transactions tied to subscriptions, logging amounts, payment dates, and statuses like paid, pending, or failed.

The support tickets table stores customer support issues submitted by individual users, including priority levels and resolution states.

The features table lists platform tools available across plans, such as Cloud Storage or API Access.

The subscription features table acts as a bridge junction table to handle the many-to-many relationship between active subscriptions and assigned features.

## Primary Keys and Why They Were Selected

Every primary entity uses an auto-incrementing integer surrogate key, such as company_id, user_id, plan_id, subscription_id, payment_id, ticket_id, and feature_id. Surrogate keys were chosen over natural keys like email or company name because business attributes change over time, whereas numeric IDs remain stable and lightweight for index lookups. 

The subscription features table uses a composite primary key formed by combining subscription_id and feature_id. This ensures a specific feature cannot be assigned to the same subscription more than once.

## Foreign Keys and What Relationships They Protect

Foreign keys preserve referential integrity across the system. 

users.company_id references companies.company_id so users cannot exist without a valid company account.

subscriptions.company_id and subscriptions.plan_id ensure subscriptions are only created for real companies and valid pricing plans.

payments.subscription_id links every payment transaction back to a legitimate subscription contract.

support_tickets.user_id ensures support requests map back to existing user accounts.

subscription_features links subscription_id and feature_id back to their parent tables, preventing non-existent feature assignments.

## Constraints Used and Why They Matter

NOT NULL constraints guarantee mandatory fields like names, emails, start dates, and amounts are never left blank during record creation.

UNIQUE constraints on user email addresses and company names prevent duplicate registrations and identity collisions.

CHECK constraints restrict text columns to allowed business values, such as active, paused, or cancelled for subscriptions, and low, medium, or high for ticket priority. CHECK constraints also enforce positive numbers on monthly_price and payment amount to prevent billing errors like negative pricing.

## Examples of Invalid Data Rejected by the Database

Attempting to insert a user assigned to company_id 999 is blocked by a foreign key constraint because company 999 does not exist.

Attempting to insert a duplicate email address fails due to the UNIQUE constraint on users.email.

Attempting to set a plan monthly_price to -49 triggers a CHECK constraint failure because prices must be strictly greater than zero.

Inserting a support ticket with a priority of 'very high' gets rejected because the CHECK constraint only allows 'low', 'medium', or 'high'.

Inserting a payment status of 'delayed' is rejected because only 'paid', 'pending', or 'failed' are permitted.

## Most Important JOIN Queries

Joining users to companies matches individual account holders to their employer organization.

Joining payments through subscriptions to companies and plans links financial transactions directly to customer accounts and their plan tiers.

Joining support tickets to users and companies connects incoming issues back to the affected enterprise client.

Using a LEFT JOIN from companies to users highlights companies that currently have zero registered user accounts.

Filtering a JOIN between subscriptions and payments for active subscriptions with pending or failed payments pinpoints accounts at risk of service interruption.

## Business Insights from Reports

CloudSys generated the highest paid revenue on the Enterprise plan, followed closely by SmartSolutions.

CyberNet had a cancelled subscription along with a failed payment, highlighting an account that churned.

Support ticket reports revealed open high-priority tickets, indicating specific accounts that need immediate customer success attention.

Combining revenue totals with ticket counts per company showed which high-revenue clients are generating the highest support workload.

## What I Can Explain Live

I can walk through the DDL schema line by line, explaining why specific constraints were picked for each column. I can demonstrate how foreign key checks block invalid inserts in SQLite and explain the practical difference between INNER and LEFT JOINs when querying relational data. I can also explain how to model many-to-many relationships with junction tables and how constraint enforcement at the database level keeps downstream data pipelines clean.
