# Part 1 - Understand the Data Model Before Writing SQL

# Data Quality & Model Notes - Day 15 SaaS Platform Database

## Overview & Business Context

As we prepare to migrate our SaaS training platform logic into Databricks and larger data pipelines, establishing a clean relational data model at the source is critical. A flat structure would create immense redundancy—repeating company names, billing details, and plan specs across every user event or ticket log. By breaking the data down into normalized entities linked by explicit constraints, we enforce data hygiene early in the pipeline and avoid costly cleanup jobs downstream.

Below are my notes analyzing the target relational model before writing the DDL scripts.

---

## 1. What Each Table Represents

- **companies**: Represents customer accounts or corporate clients purchasing platform access for their employees.
- **users**: Represents individual human accounts tied to a specific company who access training content and interact with support.
- **plans**: Represents available SaaS subscription tiers (e.g., Basic, Pro, Enterprise) defining pricing schedules and feature packages.
- **subscriptions**: Represents active or past billing contracts linking a company to a specific plan over a timeframe.
- **payments**: Represents individual financial billing transactions made against an active or recurring subscription.
- **support_tickets**: Represents customer service inquiries or technical support cases submitted by individual users.

---

## 2. Primary Keys

Each table uses a surrogate primary key with an auto-incrementing integer to ensure every record is uniquely identifiable without relying on mutable business attributes.

- **companies**: `company_id`
- **users**: `user_id`
- **plans**: `plan_id`
- **subscriptions**: `subscription_id`
- **payments**: `payment_id`
- **support_tickets**: `ticket_id`

---

## 3. Foreign Keys

Foreign keys establish explicit parent-child relational links across our domain:

- **users.company_id** references `companies.company_id`.
- **subscriptions.company_id** references `companies.company_id`.
- **subscriptions.plan_id** references `plans.plan_id`.
- **payments.subscription_id** references `subscriptions.subscription_id`.
- **support_tickets.user_id** references `users.user_id`.

---

## 4. Mandatory (NOT NULL) Fields

To maintain baseline data integrity and prevent incomplete records from reaching downstream analytics, the following attributes must be defined as NOT NULL:

- **companies**: `company_id`, `company_name`, `created_at`
- **users**: `user_id`, `company_id`, `full_name`, `email`, `created_at`
- **plans**: `plan_id`, `plan_name`, `monthly_price`
- **subscriptions**: `subscription_id`, `company_id`, `plan_id`, `status`, `start_date`
- **payments**: `payment_id`, `subscription_id`, `amount`, `payment_date`, `status`
- **support_tickets**: `ticket_id`, `user_id`, `subject`, `status`, `created_at`

---

## 5. Value Protection with CHECK Constraints

CHECK constraints guard against logic errors and dirty inputs directly at database write time:

- **plans.monthly_price**: Must be non-negative (`monthly_price >= 0`).
- **payments.amount**: Must be strictly positive (`amount > 0`).
- **subscriptions.status**: Must belong to an approved status list, such as ('active', 'cancelled', 'expired', 'pending').
- **payments.status**: Must be restricted to valid billing outcomes, such as ('completed', 'failed', 'pending', 'refunded').
- **support_tickets.status**: Must fit standard workflow states, such as ('open', 'in_progress', 'resolved', 'closed').
- **subscriptions date consistency**: If `end_date` is populated, it must be greater than or equal to `start_date` (`end_date >= start_date`).

---

## 6. One-to-Many Relationships

Our schema includes five primary one-to-many relationships:

1. **Companies to Users**: A single company can onboard many individual users, but each user belongs to exactly one company.
2. **Companies to Subscriptions**: A single company can purchase multiple subscriptions over time (upgrades, renewals, add-ons).
3. **Plans to Subscriptions**: A single pricing plan can be selected across many different company subscriptions.
4. **Subscriptions to Payments**: A single subscription generates multiple billing payments across monthly or annual cycles.
5. **Users to Support Tickets**: A single user can open multiple support tickets over their tenure on the platform.

---

## 7. Bridge Table & Many-to-Many Relationship

The business model features a **Many-to-Many (M:N)** relationship between **Companies** and **Plans**. A company can utilize different plans over time, while a plan is bought by multiple companies.

To model this cleanly in a relational engine, we use **`subscriptions`** as a bridge table (associative entity). It splits the M:N relationship into two 1:N relationships (`companies` -> `subscriptions` and `plans` -> `subscriptions`) while storing rich contract context like start dates, renewal terms, and current status.

---

## 8. Invalid Data the Database Must Reject

By enforcing schema constraints strictly, our relational database must reject:

- **Orphaned child records**: Attempts to create users without a valid company, tickets without a valid user, or payments attached to non-existent subscriptions.
- **Duplicate emails or identifiers**: Multiple user accounts registered under the identical email address (enforced via UNIQUE constraint on `users.email`).
- **Nonsensical monetary values**: Zero or negative payment amounts, or negative plan pricing.
- **Corrupted status values**: Free-form or misspelled status entries outside our defined workflow domain.
- **Incomplete foundational attributes**: Missing company names, blank email fields, or null subscription foreign keys.
- **Temporal anomalies**: Subscription end dates that precede their start dates.
