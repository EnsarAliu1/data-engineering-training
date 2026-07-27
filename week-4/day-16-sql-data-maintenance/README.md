# Day 16: SQL Data Maintenance & Quality Operations

## Project Goal
Data maintenance is the practice of keeping a database accurate, consistent, and reliable over time. In real-world data systems, records are rarely static. Students change email addresses, relocate to different cities, pause or cancel course enrollments, and miss assignment deadlines. 

Data maintenance encompasses safe row updates, controlled deletion strategies, handling missing or null values, and applying conditional business logic to transform raw data into operational insights. The main goal of today's work was to practice executing state changes in SQL safely without corrupting historical records, breaking referential integrity, or causing accidental data loss.

## Setup & Schema Architecture
To simulate a real training academy database, I created seven interconnected tables in SQLite:

- students: Stores student profile information including name, email, city, and creation date.
- programs: Contains training program details, difficulty levels (beginner, intermediate, advanced), program dates, and status.
- enrollments: Serves as a bridge table linking students to programs, enforcing unique student-program pairs and tracking status (active, paused, cancelled).
- sessions: Logs individual class sessions tied to specific training programs.
- attendance: Records student attendance statuses (present, absent, late, excused) per session along with optional instructor notes.
- assignments: Defines homework tasks, due dates, day numbers, and maximum points for each program.
- submissions: Tracks student assignment submissions, GitHub links, turn-in dates, scores, and feedback.

All tables enforce primary keys, foreign keys, non-null requirements, and check constraints to preserve data integrity across updates and deletes.

## Safe Update Practices
Executing an UPDATE query in SQL without a WHERE clause will overwrite the target column for every single row in the table. In a production environment, an unconstrained update can corrupt thousands of records instantly.

To ensure safe updates, I followed these principles:
- Explicit WHERE Clauses: Always target specific records using primary keys or unique identifier conditions (for example, `WHERE student_id = 1`).
- Pre-Execution Verification: Run a SELECT query before executing an UPDATE to inspect the exact rows that will be modified.
- Post-Execution Validation: Re-query the updated records immediately after running the UPDATE statement to confirm the change was applied correctly.
- Bulk Standardization: When updating categorical values across multiple rows—such as standardizing city names (replacing 'Prishtinë' with 'Pristina' or 'Pejë' with 'Peja')—verify that the filter condition strictly targets the intended records without affecting adjacent data.

## Delete Logic: Hard Delete vs. Soft Delete
Managing data removal requires choosing between two main strategies based on system design and audit requirements:

- Hard Delete: Uses the `DELETE FROM` SQL command to permanently erase rows from database storage. Hard deletes present significant risks in production. If child records exist in connected tables, foreign key constraints will block the deletion. If cascade deletes are enabled, removing a row can wipe out associated historical records permanently. During testing, attempting to hard-delete an active student failed due to foreign key protections, whereas deleting an isolated temporary assignment succeeded cleanly.
- Soft Delete: Modifies a status column (such as setting enrollment status to 'cancelled' or student status to 'inactive') instead of physically deleting rows. Soft deletion keeps historical records intact for reporting, compliance, and auditing while filtering inactive records out of active application workflows.

In data engineering pipelines, soft deletes are the standard approach because preserving audit trails and analytical history is far more valuable than saving minimal disk space.

## Handling NULL Values: IS NULL and COALESCE
In SQL, NULL represents missing, unknown, or unrecorded data. Because NULL is not a standard value, standard comparison operators like `= NULL` or `!= NULL` return UNKNOWN rather than true or false.

- Filtering with IS NULL and IS NOT NULL: To query records with missing entries—such as submissions turn-ins without instructor feedback or attendance rows without optional notes—we must explicitly use `WHERE feedback IS NULL` or `WHERE feedback IS NOT NULL`.
- Providing Fallbacks with COALESCE: The `COALESCE()` function accepts multiple arguments and returns the first non-null value. Raw NULL values look unpolished in reports and dashboards. Using `COALESCE(feedback, 'No feedback yet')` or `COALESCE(notes, 'No notes')` ensures user-facing queries output clean, meaningful text instead of blank values.

## Business Classification Rules with CASE WHEN
SQL `CASE WHEN` statements allow us to write conditional logic directly within queries, transforming raw numbers and status codes into structured business metrics.

In today's queries, I implemented three key classification rules:
- Academic Performance Bands: Categorized student assignment scores into performance levels (>= 90: 'Excellent', >= 75: 'Good', >= 60: 'Needs Improvement', < 60: 'At Risk').
- Attendance Status Mapping: Converted raw attendance values into readable operational labels ('Attended', 'Late Arrival', 'Excused Absence', 'Absent').
- Enrollment Risk Modeling: Classified student retention risk based on enrollment status ('active' -> 'Low Risk', 'paused' -> 'Medium Risk', 'cancelled' -> 'High Risk').

Using CASE WHEN enables on-the-fly reporting and categorization without needing to store redundant, derived columns in the primary database tables.

## Finding Missing Submissions with LEFT JOIN
Detecting process bottlenecks or missing data requires using anti-join patterns with `LEFT JOIN`.

Unlike an INNER JOIN which only returns matching rows from both sides, a LEFT JOIN preserves all rows from the left table regardless of whether matching records exist in the right table.

To find students who failed to submit an assignment:
- Start with the complete set of enrolled students and assignments.
- Perform a `LEFT JOIN` to the submissions table on both student_id and assignment_id.
- Filter the results with `WHERE submissions.submission_id IS NULL`.

Because non-matching rows produce NULL values for right-table columns, filtering on `IS NULL` isolates the exact list of active students who have not submitted their work.

## What I Can Explain Live
- How to execute safe SQL updates using targeted WHERE clauses, pre-checks, and post-verification queries.
- The practical tradeoffs between Hard Deletes (permanent removal, risk of broken FKs) and Soft Deletes (flagging status, audit preservation).
- How SQL tri-state logic handles NULL values and why `COALESCE()` is essential for reporting pipelines.
- How to structure multi-branch `CASE WHEN` logic to dynamically segment raw metrics into actionable business categories.
- How to build anti-join queries using `LEFT JOIN` combined with `IS NULL` to locate missing submissions, missing attendance, and data gaps.
