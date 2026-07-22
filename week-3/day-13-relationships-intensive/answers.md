# Day 13 - Answers & Explanations

## 1. What problem does a primary key solve?
A primary key ensures that every single row in a table is uniquely identifiable. Without it, you can easily end up with duplicate or ambiguous rows—for example, if two students are named "Ardit Krasniqi", you wouldn't be able to target or update one specific student without risking modifying the other.

## 2. What problem does AUTOINCREMENT solve?
AUTOINCREMENT handles the generation of unique, sequential primary keys automatically whenever a new row is added. It eliminates the manual work of querying for the last inserted ID or guessing the next available integer, which prevents ID collisions and race conditions when multiple records are being inserted.

## 3. What problem does a foreign key solve?
A foreign key enforces referential integrity between child and parent tables. It prevents "orphan" records and bad references by guaranteeing that an ID stored in a child table (like `student_id` in `enrollments`) actually exists in the parent table (`students`).

## 4. Why is enrollments a bridge table?
The `students` and `courses` tables have a many-to-many relationship—a student can enroll in multiple courses, and a course contains multiple students. Relational databases can't link two tables directly like that, so `enrollments` sits in the middle as a bridge table (junction table) holding pairs of `(student_id, course_id)` alongside enrollment metadata like `status` and `enrollment_date`.

## 5. Why is submissions also a relationship table?
`submissions` acts as a junction table connecting `students` with `assignments`. A single student can submit work for multiple assignments, and each assignment receives submissions from many students. On top of linking these two entities, `submissions` holds the actual payload of the interaction: `score`, `submitted_at`, and `status`.

## 6. What is one-to-many in your project? Give two examples.
A one-to-many relationship means a single record in Table A can connect to multiple records in Table B, but each record in Table B links back to only one record in Table A.

1. **Instructors to Courses (`instructors` -> `courses`):** One instructor can teach multiple courses, but each course is assigned to one primary instructor (`instructor_id`).
2. **Courses to Assignments (`courses` -> `assignments`):** One course can have multiple assignments, but each assignment belongs to exactly one course (`course_id`).

## 7. What is many-to-many in your project? Give one example.
A many-to-many relationship occurs when multiple records in one table relate to multiple records in another table.

* **Students and Courses (`students` <-> `courses`):** One student can take multiple courses, and one course can be taken by multiple students. This is resolved using the `enrollments` bridge table.

## 8. Why should we not store instructor_name directly inside every course report table?
Storing `instructor_name` directly in reporting or transactional tables causes data redundancy and update anomalies. If an instructor changes their name or updates their details, you would have to update every single row across multiple report tables. Missing even one row leads to corrupted, inconsistent data. Storing only `instructor_id` keeps a single source of truth, allowing us to fetch the updated name via a `JOIN` whenever needed.

## 9. What is the difference between INNER JOIN and LEFT JOIN?
* **INNER JOIN:** Returns only rows where there is a matching key in both tables. Any record in Table A that doesn't have a matching key in Table B is completely dropped from the result set.
* **LEFT JOIN:** Returns all rows from the left table regardless of whether a match exists in the right table. If there is no match in the right table, `NULL` values are populated for those columns.

## 10. Which constraint test was most important and why?
The **Foreign Key constraint test** (such as trying to insert an enrollment with a non-existent `student_id` or `course_id`) was the most critical. 

**Why:** Referential integrity is the foundation of any relational database. If invalid foreign keys sneak into the database, ghost records build up, causing `JOIN` queries to return incorrect counts, broken reports, and bad analytical metrics downstream in data pipelines.

## 11. How does this prepare you for Databricks tables and reporting?
Building and testing relational schemas here builds the foundation for working with **Medallion Architecture (Bronze, Silver, Gold)** in Databricks and Delta Lake:

* **Fact vs. Dimension Modeling:** Understanding primary/foreign keys and junction tables maps directly to building Star Schema / Snowflake dimensional models in Databricks (e.g., `students` as a Dimension, `attendance` or `submissions` as Fact tables).
* **JOIN Efficiency & Data Integrity:** Knowing how `INNER` vs `LEFT` JOINs behave prevents silent data loss or unexpected fan-outs when joining massive Delta tables in PySpark / Spark SQL.
* **Data Quality Constraints:** While Delta Lake supports primary/foreign key declarations (informational or enforced depending on configuration), understanding these constraints allows us to write proper data validation checks (e.g. using Delta Live Tables Expectations or Great Expectations) before pushing clean data into production reporting dashboards.
