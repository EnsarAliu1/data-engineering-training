# Training Program Management System

## What is the goal of this project?

The goal of this project was to design and build a relational database from scratch that can manage a real training program. That means tracking students, programs, instructors, sessions, attendance, assignments, and submissions — all in one place, and all connected properly so the data actually makes sense together.

This is not just a school exercise. The idea behind it was to build something that a real training company could actually use. Every table, every constraint, every report was written with that in mind.

---

## What problem did the client have?

The client runs a training program with multiple cohorts, instructors, and students. Before this system, everything was probably tracked in spreadsheets or notes — which works fine when you have 10 students, but completely falls apart when you scale.

The specific problems they were facing:

- No single place to see which students are enrolled in which program
- No easy way to track attendance across multiple sessions
- No structured way to know who submitted assignments and who didn't
- No reporting — you had to manually look through data to find patterns
- No data integrity — someone could enter wrong values, duplicate records, or link things that don't exist

The database we built solves all of these. It enforces data quality at the database level, connects all the pieces together, and makes reporting possible with simple SQL queries.

---

## How did you design the database?

I started by thinking about the real world before writing any SQL. The question I asked was: *what are the actual things that exist in a training program?*

The answer was:
- Students attend programs
- Programs are run by personnel (instructors, mentors, support staff)
- Programs have sessions
- Students attend sessions
- Programs have assignments
- Students submit assignments

From that thinking I drew out the relationships between these entities, figured out which ones needed junction tables, and then built the schema step by step. The design follows standard normalization principles — no repeated data, no columns that belong in a different table, every relationship expressed through foreign keys.

---

## Why did you create the tables you created?

The `students` table is the core entity. Every student has a profile with a name, email, city, and join date. The `programs` table describes the training programs available — their type, start and end dates, and whether they are active or planned.

The `personnel` table holds instructors, mentors, and support staff. They are kept separate from students because they serve a completely different role in the system. The `program_personnel` table is a junction table that connects programs to personnel — one program can have multiple people attached, and one person can work on multiple programs.

The `enrollments` table is what ties students to programs. It also tracks whether a student is currently active, paused, or dropped. The `sessions` table represents individual class sessions within a program — each session has a title, a topic, a date, and a session number.

The `attendance` table records whether a student was present, absent, late, or excused for a specific session. The `assignments` table holds tasks that belong to a program, and the `submissions` table records a student's response to each assignment — including a GitHub link, a score, and any feedback left by the instructor.

Every table has a clear purpose. There is no overlap and no redundancy.

---

## What are the most important relationships?

The backbone of this database is the connection between students and programs through the `enrollments` table. That single relationship controls who belongs where.

From there, the other key relationships are:

- **Programs → Sessions**: A program is made up of sessions. You cannot have a session without a program.
- **Sessions → Attendance**: Attendance only makes sense in the context of a session. Each record ties a student to a specific session.
- **Programs → Assignments**: Assignments belong to programs. If you know a student's program, you know which assignments they are responsible for.
- **Assignments → Submissions**: A submission is always a response to a specific assignment by a specific student.
- **Programs → Personnel (through program_personnel)**: This many-to-many relationship links instructors and mentors to their programs.

---

## Where did you use primary keys?

Every single table has a primary key. They are all defined as `INT NOT NULL AUTO_INCREMENT PRIMARY KEY`, which means MySQL generates them automatically and they are always unique.

- `students.student_id`
- `programs.program_id`
- `personnel.personnel_id`
- `program_personnel.program_personnel_id`
- `enrollments.enrollment_id`
- `sessions.session_id`
- `attendance.attendance_id`
- `assignments.assignment_id`
- `submissions.submission_id`

Primary keys also get an index created automatically by MySQL. We never need to manually index them.

---

## Where did you use foreign keys?

Foreign keys are what make this a relational database instead of just a pile of tables. They enforce that you cannot link to something that does not exist.

In `program_personnel`, both `program_id` and `personnel_id` are foreign keys pointing back to `programs` and `personnel` respectively. In `enrollments`, `student_id` references `students` and `program_id` references `programs`. The `sessions` table has a `program_id` foreign key pointing to `programs`. The `attendance` table has two — `session_id` references `sessions` and `student_id` references `students`. The `assignments` table has a `program_id` foreign key pointing to `programs`. And `submissions` has two as well — `assignment_id` references `assignments` and `student_id` references `students`.

If you try to insert a submission for a student that does not exist, the database will reject it. We tested this — the error message was `a foreign key constraint fails`. That is the database protecting itself.

---

## Where did you use unique constraints?

Unique constraints prevent duplicate combinations that do not make logical sense.

On the `students` table we have `uq_student_email` on the `email` column — two students simply cannot share the same email address. On `enrollments` we have `uq_student_program` across `student_id` and `program_id` together — a student can only be enrolled in the same program once. On `program_personnel` we have `uq_program_personnel` across `program_id` and `personnel_id` — you cannot assign the same person to the same program twice. On `sessions` we have `uq_program_session_number` across `program_id` and `session_number` — session numbers have to be unique within a program. On `attendance` we have `uq_session_student_attendance` across `session_id` and `student_id` — a student can only have one attendance record per session. And on `submissions` we have `uq_assignment_student_submission` across `assignment_id` and `student_id` — a student can only submit once per assignment.

These constraints save a lot of headaches. Without them, the database would let you insert duplicate rows silently and you would only find out later when your reports show wrong numbers.

---

## Where did you use CHECK constraints?

CHECK constraints go one step further — they validate the actual value of a column, not just whether it is unique.

On `programs`, the `program_type` column only accepts `'beginner'`, `'intermediate'`, or `'advanced'`. The `status` column only accepts `'active'` or `'planned'`. And `end_date` must always be after `start_date` — a program that ends before it starts makes no sense. On `personnel`, the `role` column is locked to `'instructor'`, `'mentor'`, or `'support'`. On `enrollments`, the `status` column only accepts `'active'`, `'paused'`, or `'dropped'`. On `sessions`, `session_number` must be greater than 0. On `attendance`, `status` only accepts `'present'`, `'absent'`, `'late'`, or `'excused'`. On `assignments`, `day_number` must be greater than 0 and `max_points` must be between 1 and 100. And on `submissions`, `score` must be between 0 and 100.

We tested these by trying to insert invalid data. The database rejected a score of 110, rejected a negative score, rejected an attendance status of `'here'`, and they all failed exactly as expected.

---

## What reports did you create?

**Basic join reports** (`join_reports.sql`):
- All students with their enrolled programs
- All programs with their instructors and mentors
- All sessions with program information
- Attendance with student names and session details
- Submissions linked back to students and programs
- All active students and all dropped students
- Reviewed submissions (those with feedback)
- Students who are enrolled but have low activity

**Advanced reports** (`advanced_reports.sql`):
- Average score per student
- Average score per assignment
- Full attendance summary per student (present, absent, late, excused)
- Submission count per student
- Missing submissions per student per program
- Submissions without feedback
- Program performance summary (enrollment count and attendance rate)
- Students with average score below 70
- Students with 2 or more absences
- Performance classification (Excellent / Good / Needs Improvement)
- Phase readiness (Next Phase / Test Before / Repeat)
- Full program-level summary with attendance, scores, and missing work using subqueries

---

## How did you find missing data?

Missing data is one of the most useful things to report on in a training system. It tells you where problems are before they get worse (`missing_data_reports.sql`).

The main tool was `LEFT JOIN` combined with `WHERE ... IS NULL`. The logic is:

> *Include everything from the left table, and if there is no match on the right side, the right side columns will be NULL. Filter for NULL to find the gaps.*

Reports created this way:
- Students who did not submit a specific assignment
- Students who have no submissions at all
- Submissions that have no feedback yet
- Students without attendance for a specific session
- Programs without enough sessions
- Assignments with zero submissions

This approach does not change the result — it is purely a filtering technique to surface what is missing.

---

## What views did you create?

Views are saved SELECT statements that work like virtual tables. Once a view exists you can query it like a table without rewriting the JOIN logic every time (`views.sql`).

The `student_program_overview` shows each student alongside their program name and type. The `student_submission_overview` shows each student with their full submission history — dates, scores, and any feedback that was left. The `student_attendance_summary` breaks down each student's attendance into counts of how many times they were present, absent, late, or excused. The `student_rsik_analysis` calculates each student's total submissions and average score and then assigns a risk level — No Risk, Low Risk, Medium Risk, High Risk, or Critical. And the `managment_dashboard_view` is the big one — it pulls everything together into a single view that shows enrollment status, program name, instructor, score, risk level, and the full attendance breakdown all in one place.

The management dashboard view in particular is something a team lead or program manager could open and immediately understand the state of every student.

---

## What transactions did you test?

Transactions let you wrap one or more SQL statements into a single unit. Either everything succeeds, or nothing does. We tested three scenarios (`transactions.sql`).

**Transaction 1 — Update with ROLLBACK:**
Changed a personnel member's role to `'instructor'`, verified the change, then used `ROLLBACK` to undo it. A second SELECT confirmed the value was restored.

**Transaction 2 — Update with COMMIT:**
Added a note to an attendance record for a specific session and student. Used `COMMIT` to save it permanently.

**Transaction 3 — Risky DELETE with ROLLBACK:**
Ran a `DELETE` that would remove all students with no enrollments, checked the result, then used `ROLLBACK` to bring them back. This one was important to test because it showed how dangerous an unguarded DELETE can be — and how a transaction gives you a safety net.

---

## Hard Delete vs Soft Delete

This is something worth understanding because it comes up in every real project.

### Hard Delete

A hard delete is a permanent `DELETE FROM table WHERE ...`. The row is gone. You cannot get it back unless you have a backup. We demonstrated this risk in `maintenance_queries.sql` with a dangerous multi-table DELETE that was intentionally not executed.

**When it makes sense:** Truly temporary data, test records, spam, or data that has no audit value.

**The risk:** If a student completes a program and is then deleted, you lose their entire history — submissions, attendance, scores. That is a problem.

### Soft Delete

A soft delete does not actually remove the row. Instead it updates a status column to indicate the record is inactive. In our database we already use this pattern with `enrollments.status = 'dropped'`. A dropped student still exists in the database. Their data is still there. You can still report on them. You just filter them out of your active student lists.

**Why soft delete is better in most cases:**
- You keep the history
- You can undo it by updating the status back
- Reports that look at past data still work correctly
- You can ask questions like "how many students dropped in the last 3 months"

In a production system, you would typically add a column like `deleted_at TIMESTAMP` or `is_active BOOLEAN` to support full soft delete behavior across all tables.

---

## What indexes did you create and why?

We created 12 indexes in `indexes.sql` — all on foreign key and filter columns that appear regularly in JOINs, WHERE clauses, and GROUP BY aggregations.

On `enrollments` we indexed `student_id` because it shows up in almost every student JOIN, `program_id` because it drives all program-level aggregation queries, and `status` because every active and dropped student filter goes through this column. On `attendance` we indexed `student_id` because attendance is the most queried table in the system and student lookups happen constantly, `session_id` because of the session-level queries and subqueries, and `status` because every present/absent/late count aggregates on it. On `submissions` we indexed `student_id` because every submission report joins on it, and `assignment_id` because it powers missing work detection and the average score subqueries. On `sessions` we indexed `program_id` because sessions are always grouped and filtered by program. On `assignments` we indexed `program_id` for the same reason — assignment counts and missing work queries all filter by program. And on `program_personnel` we indexed both `program_id` and `personnel_id` because it is a junction table that gets hit from both sides.

An index does not change what the query returns. The result is always the same. The only thing an index changes is how fast the database gets there. At 20 rows it barely matters. At 20,000 rows it is the difference between a report that loads in milliseconds and one that times out.

Primary keys and UNIQUE constraints already create indexes automatically — we did not duplicate those.

---

## What was the hardest part?

Honestly, the hardest part was the reporting, specifically the program-level summary in `advanced_reports.sql`. That query uses three separate subqueries inside a single SELECT — one for total attendance, one for average score, and one for missing work — all filtered dynamically by `p.program_id`. Getting those subqueries to reference the outer query correctly, and making sure the counts were accurate without double-counting, took real thought.

The second hardest thing was understanding when to use `LEFT JOIN` vs `JOIN`. At first it felt like they both did the same thing, but the difference is significant — a regular `JOIN` drops any row that does not have a match, while `LEFT JOIN` keeps it and fills the right side with NULL. All the missing data reports depend on this distinction being exactly right.

---

## What can you explain live without reading from notes?

- Why we use primary keys and what AUTO_INCREMENT does
- What a foreign key actually protects you against (and what error you get when it fails)
- The difference between UNIQUE on a single column vs a composite UNIQUE constraint
- What a CHECK constraint does and why it is better than validating in application code
- How LEFT JOIN + IS NULL finds missing data
- What a view is and why you would use one instead of a subquery every time
- The difference between COMMIT and ROLLBACK in a transaction
- Hard delete vs soft delete — what the tradeoffs are and when you would choose each
- What an index does and why it does not change the result of a query
- Why you do not index every column and what the cost of an index is on write operations

---

*This project was completed as part of the Data Engineering Training Program — Week 4, Days 18–20.*
