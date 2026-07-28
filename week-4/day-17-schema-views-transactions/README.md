# Day 17: Schema Evolution, Views, Transactions & Indexing

## Project Goal
In production data engineering, relational database schemas are never static. As business requirements change, underlying data models must adapt without causing downtime or breaking downstream data pipelines. **Schema Evolution** is the process of modifying database structures (adding columns, updating types, applying constraints) to accommodate new data needs while preserving historical records and referential integrity.

The primary goal of today's work was to practice schema evolution using `ALTER TABLE`, encapsulate complex analytical queries into reusable SQL **Views**, enforce ACID transactional safety using `BEGIN TRANSACTION`, `COMMIT`, and `ROLLBACK`, and optimize query performance using B-Tree **Indexes**.

---

## Setup & Schema Architecture
To simulate an evolving academy data system, I initialized a relational database in SQLite consisting of seven connected tables:

* **`students`**: Contains core student profile records (student ID, first name, last name, email, city, registration date).
* **`programs`**: Details available training courses, program difficulty levels, start/end dates, and status.
* **`enrollments`**: Bridge table connecting students to programs with enrollment status (`active`, `paused`, `dropped`, `cancelled`).
* **`sessions`**: Logs individual class meetings and session topics for each program.
* **`attendance`**: Tracks student attendance statuses (`present`, `absent`, `late`, `excused`) and instructor notes per session.
* **`assignments`**: Defines homework tasks, day numbers, due dates, and max score points per program.
* **`submissions`**: Stores student homework turn-ins, GitHub repository links, submission dates, scores, and instructor feedback.

All tables enforce primary keys, foreign key constraints, `NOT NULL` rules, `CHECK` constraints, and `UNIQUE` constraints to safeguard referential integrity.

---

## ALTER TABLE: Schema Evolution Operations
As operational requirements expanded, I evolved the table schemas using `ALTER TABLE` commands without destroying existing rows:

1. **`ALTER TABLE students ADD COLUMN phone_number TEXT;`**
   * *Purpose:* Required for direct student outreach, SMS notifications, and emergency contact tracking. Populated with unique phone numbers and indexed.
2. **`ALTER TABLE submissions ADD COLUMN github_username TEXT;`**
   * *Purpose:* Needed for tracking student GitHub accounts directly alongside homework submissions for code audit workflows.
3. **`ALTER TABLE submissions ADD COLUMN review_status TEXT;`**
   * *Purpose:* Tracks grading progress (`not reviewed`, `reviewed`, `needs revision`) to streamline instructor review workflows.
4. **`ALTER TABLE submissions ADD COLUMN reviewed_at DATE;`**
   * *Purpose:* Records the exact date grading took place, enabling turnaround time tracking for instructor feedback.
5. **`ALTER TABLE attendance ADD COLUMN corrected_at DATE;`**
   * *Purpose:* Audit tracking column to mark when attendance records were updated retroactively.
6. **`ALTER TABLE assignments ADD COLUMN task_type TEXT;`**
   * *Purpose:* Categorizes assignments by tech stack (e.g., `SQL pipeline`, `Python pipeline`, `NodeJS pipeline`).

---

## Views: Virtual Data Abstractions
SQL Views allow encapsulating multi-table joins, conditional statements, and filtering rules into stored virtual tables. They save storage space (storing only query metadata) while simplifying query execution for analytics and dashboards.

I created six specific business views in `views.sql`:

1. **`student_profile_view`**
   * *Business Question:* "What is the complete contact profile and active status for each student?"
   * *Logic:* Joins `students`, `enrollments`, and `submissions` to display student name, city, email, phone number, GitHub username, and enrollment status.
2. **`student_submission_view`**
   * *Business Question:* "How are students scoring on assignments and what feedback did they receive?"
   * *Logic:* Joins `students`, `assignments`, and `submissions` to show assignment titles, scores, feedback, and review statuses.
3. **`attendance_summary_view`**
   * *Business Question:* "What is the attendance record across all class sessions?"
   * *Logic:* Joins `students`, `sessions`, and `attendance` to report session numbers, topics, attendance status, and notes.
4. **`missing_feedback_view`**
   * *Business Question:* "Which student submissions still require instructor review and grading?"
   * *Logic:* Filters `submissions` where `feedback IS NULL` OR `review_status = 'not reviewed'`.
5. **`student_performance_view`**
   * *Business Question:* "How do we segment students into academic performance tiers based on submission scores?"
   * *Logic:* Uses `CASE WHEN` logic (`> 90`: 'Excellent', `>= 75`: 'Good', `>= 60`: 'Needs Improvement', `ELSE`: 'At Risk').
6. **`missing_submission_view`**
   * *Business Question:* "Which active students failed to turn in their assignments?"
   * *Logic:* Performs a `LEFT JOIN` between `students`, `enrollments`, and `submissions`, filtering on `WHERE submissions.submission_id IS NULL`.

---

## Transactions: ACID & Safe Mutation Control
Transactions group multiple SQL operations into a single atomic unit of work. Using `BEGIN TRANSACTION`, `COMMIT`, and `ROLLBACK` guarantees database consistency and provides a safety net against destructive updates.

In `transactions.sql`, I implemented and tested the following scenarios:

* **Testing ROLLBACK:** Executed an unconstrained batch update (`UPDATE submissions SET score = 100;`). Inspected updated rows within the active transaction session, verified the mistake, and executed `ROLLBACK`. Re-queried the table to prove original scores were fully restored.
* **Executing COMMIT:** Updated `review_status = 'reviewed'` and `reviewed_at = '2026-08-07'` for submission ID 1 inside a transaction, then ran `COMMIT` to permanently save the change.
* **Foreign Key Protection:** Attempted to execute `DELETE FROM students WHERE student_id = 1;` inside a transaction. SQLite blocked the delete statement because child records existed in `submissions` and `attendance`, enforcing relational integrity.
* **Controlled Soft Delete:** Wrapped an enrollment status update (`UPDATE enrollments SET status = 'dropped' WHERE enrollment_id = 2;`) inside a transaction and committed it safely.
* **Atomic Multi-Statement Updates:** Executed simultaneous score and feedback updates for submission ID 1 in a single transaction block, committing only after verifying both statements succeeded cleanly.

---

## Indexes: Query Performance Optimization
An **index** is a B-Tree lookup structure that enables the database engine to locate specific rows quickly without scanning every row in a table (Full Table Scan).

In `indexes.sql`, I created indexes on key foreign columns:
* **`submissions(student_id)`** & **`submissions(assignment_id)`**: Speeds up join operations between `submissions`, `students`, and `assignments`.
* **`attendance(session_id)`** & **`attendance(student_id)`**: Optimizes multi-table joins when computing student attendance summaries.
* **`enrollments(program_id)`**: Accelerates filtering and joining across program enrollments.

*Why:* Indexing foreign keys and columns frequently used in `JOIN`, `WHERE`, and `GROUP BY` clauses minimizes disk I/O and speeds up execution plans as datasets scale.

---

## Integration Challenge: `final_student_progress_view`
The capstone task of Day 17 was constructing `final_student_progress_view` in `integration_challenge.sql`. This view provides a master operational dataset by consolidating data across five tables:

```sql
CREATE VIEW final_student_progress_view AS 
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    students.city,
    students.phone_number,
    submissions.github_username,
    enrollments.status AS enrollment_status,
    assignments.title AS assignment_title,
    submissions.score AS submissions_score,
    CASE
        WHEN submissions.score >= 90 THEN 'Excellent'
        WHEN submissions.score >= 75 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_level,
    COALESCE(submissions.feedback, 'No feedback yet') AS feedback_status,
    submissions.review_status,
    attendance.status AS attendance_status
FROM students
JOIN enrollments
    ON enrollments.student_id = students.student_id
LEFT JOIN submissions
    ON submissions.student_id = students.student_id
LEFT JOIN assignments
    ON assignments.assignment_id = submissions.assignment_id
LEFT JOIN attendance
    ON attendance.student_id = students.student_id;
```

### Key Business Insights Delivered:
1. **Comprehensive Student View:** Single source of truth combining contact details, enrollment standing, assignment performance, and attendance records.
2. **Graceful Handling of Missing Data:** Uses `LEFT JOIN` to ensure students without submissions or attendance are not omitted, and applies `COALESCE()` to replace `NULL` feedback with `'No feedback yet'`.
3. **Dynamic Academic Categorization:** Applies conditional `CASE WHEN` rules to automatically classify student scores into performance tiers.

---

## What I Can Explain Live
* **Schema Evolution Concept:** Why production tables must evolve using `ALTER TABLE` rather than being dropped and recreated.
* **View Abstraction & Security:** How views simplify complex SQL joins, mask sensitive columns, and protect downstream BI reports from base table changes.
* **Transaction Control:** How `BEGIN TRANSACTION`, `COMMIT`, and `ROLLBACK` prevent accidental mass updates and maintain ACID atomicity.
* **Index Mechanics:** How B-Tree indexes transform $O(N)$ full table scans into fast $O(\log N)$ lookups on foreign keys and filter columns.
* **Master Progress Reporting:** How `final_student_progress_view` combines inner joins, outer joins, `CASE WHEN` logic, and `COALESCE` for academy-wide reporting.
