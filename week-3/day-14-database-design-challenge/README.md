# Day 14 - Database Design Challenge

## Project Goal
The goal of this project is to design, implement, and query a fully normalized relational database in SQLite for a technology training academy. The database tracks students, instructors, courses, enrollments, attendance, and payments, while providing structured SQL reports and data quality audits to inform business management.

## Business Requirements
The academy manages multiple training programs across different skill levels (Beginner, Intermediate, Advanced) taught by specialized instructors. Students register from various cities and enroll in one or more courses. Management requires visibility into:
- Program popularity and active enrollment volume.
- Collected revenue versus uncollected outstanding fees.
- Student geographical distribution.
- Financial risks (active students with pending/missing payments).
- Academic risks (students with low or zero attendance).
- Program attendance performance and instructor workload concentration.

## Database Design
The database consists of 6 normalized tables designed to eliminate data redundancy and preserve integrity:

- **students**: Stores student profile data (id, full name, email, city). Primary Key: `student_id`.
- **instructors**: Stores instructor details and technical specializations. Primary Key: `instructor_id`.
- **programs**: Stores course details, assigned instructor, level, and price. Primary Key: `program_id`. Foreign Key: `instructor_id` referencing `instructors`.
- **enrollments**: Serves as the central bridge table connecting students to programs, tracking enrollment date and course status (`active`, `completed`, `dropped`). Primary Key: `enrollment_id`. Foreign Keys: `student_id` referencing `students`, `program_id` referencing `programs`.
- **attendance**: Logs session-level attendance, binary attendance flag (0 or 1), and minutes attended. Primary Key: `attendance_id`. Foreign Key: `enrollment_id` referencing `enrollments`.
- **payments**: Tracks payment transactions, payment methods, transaction dates, and status (`Pending`, `Paid`, `Refunded`). Primary Key: `payment_id`. Foreign Key: `enrollment_id` referencing `enrollments`.

## Relationships
- **One-to-Many (Instructors to Programs)**: One instructor can teach multiple programs, but each program has one designated primary instructor.
- **Many-to-Many (Students to Programs)**: A student can take multiple courses, and a course contains multiple students. This is implemented via the `enrollments` bridge table.
- **One-to-Many (Enrollments to Attendance)**: A single student enrollment yields multiple attendance records across scheduled class sessions.
- **One-to-Many (Enrollments to Payments)**: One enrollment can have multiple associated payment records (e.g., initial attempt, pending, cleared, or refunded).

## Constraints
- **PRIMARY KEY**: Guarantees unique identification for every record across all tables.
- **FOREIGN KEY (PRAGMA foreign_keys = ON)**: Maintains referential integrity and prevents orphan records in child tables.
- **NOT NULL**: Ensures mandatory attributes (such as names, dates, prices, and statuses) cannot be left empty.
- **UNIQUE**: Prevents duplicate records, such as duplicate student emails, duplicate `(student_id, program_id)` enrollments, and duplicate `(enrollment_id, session_date)` attendance logs.
- **CHECK**: Restricts column inputs to valid business logic boundaries (e.g., `price > 0`, `minutes_attended >= 0`, level IN (`Beginner`, `Intermediate`, `Advanced`), status IN (`active`, `completed`, `dropped`), and payment status IN (`Pending`, `Paid`, `Refunded`)).

## How to Run
Run the SQL scripts in the following exact sequence using SQLite CLI, DBeaver, or VS Code SQLite extension:

1. **database_schema.sql**: Drops existing tables and creates all 6 schema tables with primary keys, foreign keys, and constraints.
2. **insert_data.sql**: Seeds the database with realistic test data across all tables.
3. **relationship_tests.sql**: Executes queries to verify foreign key relationships and bridge table connections.
4. **join_reports.sql**: Runs multi-table INNER and LEFT JOIN queries to combine student, program, instructor, attendance, and payment data.
5. **aggregation_reports.sql**: Runs summary reports using COUNT, SUM, AVG, and GROUP BY.
6. **having_reports.sql**: Filters aggregated groupings using HAVING clauses (e.g., programs with revenue > 300, students with attendance < 70%).
7. **data_quality_checks.sql**: Audits the system for missing payments, orphan records, zero-attendance active students, and financial risk profiles.

## Business Insights & Data Quality Discoveries
- **Revenue vs Volume**: HTML & CSS Fundamentals and Network Security Basics have the most active students (3 each), but JavaScript Advanced (€299.98) and Python for Data Science (€299.97) generate double the collected revenue due to higher course pricing.
- **Geographic Focus**: Prishtinë represents our largest student concentration (25%), while regional cities (Prizren, Pejë, Gjakovë) represent 50% combined.
- **Financial Risk**: 4 active students have pending or missing payment records totaling €279.96 in uncollected fees.
- **Academic Risk**: 5 active students have zero logged session attendance, and Drin Osmani has attendance below 70% across two courses.
- **Weakest Attendance**: Network Security Basics has the lowest average attendance rate at 66.67% (55 mins/session).
- **Data Quality Anomaly**: Enrollment ID 6 (Hana Morina) was created without any entry in the `payments` table, uncovering an onboarding process gap where active enrollments can bypass payment creation.

## What I Can Explain Live
- **Schema & Normalization**: How 3NF design prevents data duplication and protects database integrity.
- **Bridge Table Mechanics**: Why `enrollments` is necessary to resolve the many-to-many relationship between students and courses.
- **Constraint Defense**: How `CHECK`, `UNIQUE`, and `FOREIGN KEY` rules catch invalid inputs before they enter the system.
- **Complex Query Construction**: How to write multi-table `JOIN`s, aggregation queries using `GROUP BY`, and conditional filtering with `HAVING`.
- **Auditing with LEFT JOINs**: How to use `LEFT JOIN ... WHERE key IS NULL` to spot missing payments and process gaps.
- **Translating Data to Business Value**: How to present technical database query outputs as actionable management recommendations for revenue collection, student retention, and instructor workload balance.
