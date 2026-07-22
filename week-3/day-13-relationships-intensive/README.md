# Day 13 - Intensive Relationships and Foreign Keys

## Project Goal
The goal of this project was to design, build, and test a multi-table database for Unity Tech Hub using SQLite. Instead of keeping all data in one big spreadsheet, we split it up into logical tables to track students, instructors, courses, enrollments, daily attendance, assignments, and homework submissions.

We set up primary keys, foreign keys, unique constraints, and check rules to make sure invalid data gets rejected. We also wrote multi-table JOIN reports and a manager SQL script to answer real business questions about student performance, class attendance, and instructor workloads.

## Database Design
Before writing any SQL script, we planned out a normalized database structure to avoid repeating data and keep everything clean. 

Instead of typing out instructor names or course names over and over in every table, each real-world concept gets its own table. We then connected these tables using primary key to foreign key links.

For example, `instructors` links to `courses`, `courses` links to `assignments`, and `assignments` links to `submissions`. The `enrollments` table sits between `students` and `courses` to handle student registrations, and `attendance` connects directly to each enrollment.

## Tables and Relationships
Our database includes 7 normalized tables:

1. **students**: Holds student profile info like full name, email, and city.
2. **instructors**: Holds instructor details and their area of specialization.
3. **courses**: Connects each course to its assigned instructor (One-to-Many relationship).
4. **enrollments**: A bridge table that connects students to courses (Many-to-Many relationship) while storing enrollment date and status.
5. **attendance**: Tracks daily attendance per enrollment (One-to-Many relationship) with session date, attendance flag, and minutes attended.
6. **assignments**: Stores assignments for each course (One-to-Many relationship) with assignment title, max score, and due date.
7. **submissions**: A relationship table linking students to assignments (Many-to-Many relationship) to record submitted date, score, and status.

## Primary Keys, Foreign Keys, and Constraints
To protect the database from bad data, we added the following rules in our schema:

* Enabled foreign keys using `PRAGMA foreign_keys = ON;`
* Used `INTEGER PRIMARY KEY AUTOINCREMENT` on every table so each row has a unique identifier.
* Linked foreign keys across tables:
  * `courses.instructor_id` references `instructors.instructor_id`
  * `enrollments.student_id` references `students.student_id`
  * `enrollments.course_id` references `courses.course_id`
  * `attendance.enrollment_id` references `enrollments.enrollment_id`
  * `assignments.course_id` references `courses.course_id`
  * `submissions.assignment_id` references `assignments.assignment_id`
  * `submissions.student_id` references `students.student_id`
* Added UNIQUE constraints to prevent duplicate entries (like unique student emails, unique student-course enrollments, and unique student-assignment submissions).
* Added CHECK constraints to ensure valid values for course levels (Beginner, Intermediate, Advanced), positive attendance minutes, valid scores (0 to 100), and valid submission statuses.

## Seed Data
We inserted realistic sample data across all 7 tables to simulate real platform activity. This included multiple students from different cities, instructors, courses, active and completed enrollments, daily attendance logs, assignments, and student submission scores.

## Constraint Tests
We intentionally ran bad SQL insert queries to verify that our constraints actually catch errors and protect the database:

1. **Invalid Instructor FK**: Tried adding a course with a non-existent instructor ID. SQLite rejected it with a foreign key constraint error.
2. **Invalid Student or Course FK**: Tried enrolling a non-existent student or course ID. SQLite rejected it with a foreign key constraint error.
3. **Duplicate Enrollment**: Tried enrolling the same student into the exact same course twice. SQLite blocked it with a unique constraint error.
4. **Negative Minutes**: Tried adding negative attendance minutes. SQLite blocked it with a check constraint error.
5. **Invalid Course Level**: Tried setting a course level to Expert. SQLite rejected it because it was not in the allowed list.
6. **Invalid Score**: Tried entering an assignment score above 100. SQLite rejected it with a check constraint error.
7. **Duplicate Email**: Tried adding a student with an email that was already registered. SQLite blocked it with a unique constraint error.

## JOIN Reports
In our join queries script, we wrote multi-table SELECT statements using INNER JOIN and LEFT JOIN to pull together reports:

* Showed course details alongside instructor names and specializations.
* Combined enrollments, students, and courses to view active student workloads.
* Calculated class attendance averages across courses.
* Used LEFT JOIN to spot edge cases, like students who are registered but not enrolled in any courses, and assignments that have zero submissions.

## Manager Report
In our manager report script, we wrote targeted business queries paired with concrete decision notes for leadership:

1. **Course Enrollment Numbers**: Ranked courses by student enrollment counts to help allocate marketing budgets and assistant teachers.
2. **Multi-Course Students**: Identified active power users taking multiple classes to target for testimonials and course bundles.
3. **Attendance Leaders**: Found courses with the highest attendance averages so instructors can share their teaching methods across the team.
4. **At-Risk Students**: Filtered missing or late submissions so student support can reach out early.
5. **Top Instructor Workload**: Located instructors managing the most active enrollments to evaluate workload and performance.
6. **360 Degree Student Overview**: Built one final combined report joining student details, course names, instructor names, enrollment status, attendance sessions, total minutes, and average assignment scores.

## Screenshots
Query outputs and database verification were saved and organized in the screenshots directory:
* Table creation and schema setup running cleanly in SQLite.
* Constraint rejection error outputs verifying that bad inserts were caught.
* Final execution output of the manager report.

## What I Can Explain Live
* Why normalizing data into separate tables prevents duplicate entries and keeps reports accurate.
* How bridge tables like enrollments and submissions connect many-to-many relationships while holding key details like grades and attendance.
* The practical difference between INNER JOIN (only matching rows) and LEFT JOIN (keeping all left-side rows to find missing records).
* Why testing constraint failures is essential before using a database in a real data pipeline.

## What I Would Improve Next
* Add database indexes on frequently joined columns (like student_id and course_id) to speed up queries as data grows.
* Add timestamp columns like created_at and updated_at to track when records change.
* Recreate this schema in Databricks using Delta Lake tables and set up data validation rules using Spark SQL.
