-- ============================================================
-- Part 10 - Indexes
-- Training Program Management System
-- ============================================================

-- Before we get into the actual indexes, let me explain a couple
-- of things that are important to understand upfront.

-- IMPORTANT NOTE #1 - Indexes do NOT change query results.
-- -----------------------------------------------------------
-- An index has absolutely zero effect on what data comes back.
-- You will get the exact same rows, the exact same values,
-- whether an index exists or not.
-- The only thing an index changes is HOW FAST the database
-- finds that data. Think of it like the index at the back of
-- a textbook. You still read the same chapter, you just
-- find it faster.

-- IMPORTANT NOTE #2 - Indexes help as data grows.
-- -----------------------------------------------------------
-- Right now our database is small, maybe 20-30 rows per table.
-- At this size the database can afford to scan every single row
-- and it barely takes any time. But imagine this system running
-- for 3 years with 5000 students, 100 programs, 20000 attendance
-- records, 15000 submissions. Without indexes, every JOIN and
-- every WHERE clause forces the database to scan tens of thousands
-- of rows just to find the ones it needs. With indexes, it goes
-- directly to the right rows. The bigger the data, the more
-- an index matters.

-- IMPORTANT NOTE #3 - We only create indexes where they make sense.
-- -----------------------------------------------------------
-- Indexes are not free. Every time you INSERT, UPDATE, or DELETE
-- a row, the database also has to update every index on that table.
-- So putting an index on every column is actually harmful.
-- We focus on columns that are frequently used in:
--   JOIN conditions
--   WHERE filters
--   GROUP BY aggregations
--   Reporting queries that run often

-- Primary keys already have indexes created automatically by MySQL.
-- We do not need to re-index student_id, program_id, etc.
-- We focus below on foreign key columns and filter columns
-- that MySQL does not automatically index.

-- ============================================================
-- TABLE: enrollments
-- ============================================================

-- Index on enrollments.student_id
-- --------------------------------
-- Why: This column is a foreign key and it shows up in almost
-- every JOIN we wrote. When we pull a student's enrollment
-- status, find their program, or check if they are active,
-- the database has to match enrollment rows to a student_id.
-- Without an index here it scans the entire enrollments table
-- for every student lookup.
--
-- Queries that benefit:
--   - "Show all students with the programs they are enrolled in" (join_reports.sql)
--   - "Show all active/dropped students" (join_reports.sql)
--   - "Missing submission count by student" (advanced_reports.sql)
--   - "Students who are enrolled but have low activity" (join_reports.sql)
--   - Every view in views.sql that joins students to enrollments

CREATE INDEX idx_enrollments_student_id
    ON enrollments (student_id);


-- Index on enrollments.program_id
-- --------------------------------
-- Why: Same reasoning from the other side of the JOIN.
-- When we query from the programs table and join to enrollments,
-- the database needs to find all enrollment rows for a given
-- program_id. This also supports GROUP BY program_id in
-- aggregation queries.
--
-- Queries that benefit:
--   - "Program performance summary" (advanced_reports.sql)
--   - "Program-level summary with students, attendance, scores" (advanced_reports.sql)
--   - "Missing submission count by student" (advanced_reports.sql)
--   - All subqueries in the program-level summary that filter by en.program_id

CREATE INDEX idx_enrollments_program_id
    ON enrollments (program_id);


-- Index on enrollments.status
-- --------------------------------
-- Why: Almost every "active student" query filters on this column.
-- WHERE enrollments.status = 'active' appears in multiple reports.
-- Without an index the database reads every enrollment row and
-- then throws away the ones that do not match. With an index it
-- goes straight to the active rows.
--
-- Queries that benefit:
--   - "Show all active students" (join_reports.sql)
--   - "Show all dropped students" (join_reports.sql)
--   - "Students who are enrolled but have low activity" (join_reports.sql)
--   - "Missing submission count by student" (advanced_reports.sql)

CREATE INDEX idx_enrollments_status
    ON enrollments (status);


-- TABLE: attendance

-- Index on attendance.student_id
-- --------------------------------
-- Why: Attendance is one of the most queried tables in this
-- system. Every time we want to know how many times a student
-- showed up, was absent, or was late, we JOIN attendance to
-- students on this column. Without an index, the database
-- scans every attendance record looking for a specific student.
--
-- Queries that benefit:
--   - "Attendance summary by student" (advanced_reports.sql)
--   - "Students with 2 or more absences" (advanced_reports.sql)
--   - "Active students with no recent activity" (missing_data_reports.sql)
--   - "Students who have attendance but no submission history" (missing_data_reports.sql)
--   - student_attendance_summary view (views.sql)
--   - managment_dashboard_view (views.sql)

CREATE INDEX idx_attendance_student_id
    ON attendance (student_id);


-- Index on attendance.session_id
-- --------------------------------
-- Why: When we look at attendance per session, or join attendance
-- to the sessions table, this column gets filtered. It also shows
-- up in the subquery of the program-level summary where we count
-- attendance per program by going through sessions.
--
-- Queries that benefit:
--   - "Show attendance with student name and session information" (join_reports.sql)
--   - "Students without attendance for a specific session" (missing_data_reports.sql)
--   - The subquery in program-level summary that joins attendance to sessions (advanced_reports.sql)

CREATE INDEX idx_attendance_session_id
    ON attendance (session_id);


-- Index on attendance.status
-- --------------------------------
-- Why: Multiple reports filter or aggregate by attendance status.
-- Counting how many times a student was 'present', 'absent',
-- 'late', or 'excused' requires the database to evaluate this
-- column for every single attendance row it reads.
--
-- Queries that benefit:
--   - "Attendance summary by student" (advanced_reports.sql)
--   - "Program performance summary" attendance rate calculation (advanced_reports.sql)
--   - managment_dashboard_view SUM(CASE WHEN status = ...) (views.sql)

CREATE INDEX idx_attendance_status
    ON attendance (status);


-- TABLE: submissions

-- Index on submissions.student_id
-- --------------------------------
-- Why: Submissions are linked to students in basically every
-- reporting query we have. Average score by student, missing
-- submissions, feedback tracking, risk analysis - they all
-- JOIN submissions to students using this column.
--
-- Queries that benefit:
--   - "Average score by student" (advanced_reports.sql)
--   - "Submission count by student" (advanced_reports.sql)
--   - "Students with average score below 70" (advanced_reports.sql)
--   - "Students who need support / ready for next phase" (advanced_reports.sql)
--   - "Students without feedback" (missing_data_reports.sql)
--   - student_submission_overview view (views.sql)
--   - student_rsik_analysis view (views.sql)
--   - managment_dashboard_view (views.sql)

CREATE INDEX idx_submissions_student_id
    ON submissions (student_id);


-- Index on submissions.assignment_id
-- --------------------------------
-- Why: When we join submissions to assignments, or check which
-- assignments have no submissions at all, this column is the
-- bridge. It also appears in subqueries that calculate average
-- scores per program by going through assignments.
--
-- Queries that benefit:
--   - "Average score by assignment" (advanced_reports.sql)
--   - "Missing submission count by student" (advanced_reports.sql)
--   - "Assignments without submissions" (missing_data_reports.sql)
--   - "Students who did not submit a specific assignment" (missing_data_reports.sql)
--   - The subquery in program-level summary for average_score (advanced_reports.sql)

CREATE INDEX idx_submissions_assignment_id
    ON submissions (assignment_id);


-- TABLE: sessions

-- Index on sessions.program_id
-- --------------------------------
-- Why: Sessions belong to programs. Whenever we want to list
-- all sessions for a program, or join sessions to programs,
-- this column drives the JOIN. It also shows up in the subquery
-- that counts total attendance per program by going through
-- sessions.program_id.
--
-- Queries that benefit:
--   - "Show all sessions with program information" (join_reports.sql)
--   - "Programs without enough sessions" (missing_data_reports.sql)
--   - The attendance subquery in program-level summary (advanced_reports.sql)
--   - Any report that filters or groups sessions by program

CREATE INDEX idx_sessions_program_id
    ON sessions (program_id);


-- TABLE: assignments

-- Index on assignments.program_id
-- --------------------------------
-- Why: Assignments belong to programs. When we need to count
-- assignments per program, find which students are missing work,
-- or calculate average scores per program, the database joins
-- assignments to programs using this column. Without an index
-- it has to scan the entire assignments table.
--
-- Queries that benefit:
--   - "Average score by assignment" grouped by program (advanced_reports.sql)
--   - "Missing submission count by student" (advanced_reports.sql)
--   - "Assignments without submissions" (missing_data_reports.sql)
--   - The missing_work subquery in program-level summary (advanced_reports.sql)

CREATE INDEX idx_assignments_program_id
    ON assignments (program_id);


-- TABLE: program_personnel

-- Index on program_personnel.program_id
-- --------------------------------
-- Why: This is a junction table. Every time we want to find
-- the instructors or mentors assigned to a program, the database
-- filters this table by program_id. Without an index it reads
-- every row in the junction table.
--
-- Queries that benefit:
--   - "Show all programs with their instructors or mentors" (join_reports.sql)
--   - "Show a clean list that management could read" (join_reports.sql)
--   - managment_dashboard_view (views.sql)

CREATE INDEX idx_program_personnel_program_id
    ON program_personnel (program_id);


-- Index on program_personnel.personnel_id
-- --------------------------------
-- Why: Same idea from the other side. When we join personnel
-- to their programs we go through this junction table using
-- personnel_id to look up the personnel details.
--
-- Queries that benefit:
--   - "Show all programs with their instructors or mentors" (join_reports.sql)
--   - "Show a clean list that management could read" (join_reports.sql)
--   - managment_dashboard_view (views.sql)

CREATE INDEX idx_program_personnel_personnel_id
    ON program_personnel (personnel_id);

-- This file is written with the help of AI on explanations and index recommendations.