-- Part 4 - Relationship and Constraint Tests


-- Insert enrollment with student ID that does not exist
-- Should fail because of foreign key protection.
INSERT INTO enrollments (student_id, program_id, enrollment_date, status) VALUES
    (999,  1, '2025-01-10', 'completed');
-- SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Insert enrollment with program ID that does not exist
--Should fail because the program does not exist.
INSERT INTO enrollments (student_id, program_id, enrollment_date, status) VALUES
    (1,  999, '2025-01-10', 'completed')
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Insert attendance for enrollment ID that does not exist
--Should fail because attendance must belong to a real enrollment.
INSERT INTO attendance (enrollment_id, session_date, attended, minutes_attended) VALUES
    (999, '2025-01-15', 1, 90)
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed

--Insert payment for enrollment ID that does not exist
--Should fail because payment must belong to a real enrollment.
INSERT INTO payments (enrollment_id, payment_date, payment_method, status) VALUES
    (999,  '2025-01-10', 'Card',          'Paid')
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Insert student with duplicate email
--Should fail if email is UNIQUE.
INSERT INTO students (student_fullName, student_email, student_city) VALUES
    ('test',       'aldi.mehmeti@email.com',       'Prishtine')
--SQLITE_CONSTRAINT_UNIQUE: sqlite3 result code 2067: UNIQUE constraint failed: students.student_email


--Insert payment with negative amount
--Should fail if amount has a CHECK constraint. 
-- Its more logical to have prices of course in courses table so i added them on.
INSERT INTO programs (program_name, instructor_id, level, price) VALUES
    ('HTML & CSS Fundamentals',   1, 'Beginner',    -30)
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: price > 0

--Insert invalid enrollment status
--Should fail if status has a CHECK constraint.
INSERT INTO enrollments (student_id, program_id, enrollment_date, status) VALUES
    (1,  1, '2025-01-10', 'finished')
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: status IN ('active','completed','dropped')