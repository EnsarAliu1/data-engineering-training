-- Invalid course instructor
INSERT INTO courses (course_name,instructor_id,level) VALUES
('test',999,'Beginner');
-- Rejected because the instructor does not exist.
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Invalid enrollment student
INSERT INTO enrollments(student_id,course_id,enrollment_date,status) VALUES
(999,1,'2026-01-10','active');
--Rejected because the student does not exist.
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Invalid enrollment course
INSERT INTO enrollments(student_id,course_id,enrollment_date,status) VALUES
(1,999,'2026-01-10','active');
--Rejected because the course does not exist.
-- SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Duplicate enrollment
INSERT INTO enrollments(student_id,course_id,enrollment_date,status) VALUES
(1,1,'2026-01-10','active');
--Rejected by UNIQUE(student_id, course_id).
--SQLITE_CONSTRAINT_UNIQUE: sqlite3 result code 2067: UNIQUE constraint failed: enrollments.student_id, enrollments.course_id


--Invalid attendance enrollment
INSERT INTO attendance(enrollment_id,session_date,attended,minutes_attended) VALUES
(999,'2026-02-01',1,90);
--Rejected because the enrollment does not exist.
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Invalid attendance minutes
INSERT INTO attendance(enrollment_id,session_date,attended,minutes_attended) VALUES
(999,'2026-02-01',1,-10);
--Rejected by CHECK constraint.
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: minutes_attended >= 0


--Invalid course level
INSERT INTO courses (course_name,instructor_id,level) VALUES
('SQL Fundamentals',1,'Expert');
--Rejected if CHECK allows only Beginner/Intermediate/Advanced.
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: level IN ('Beginner','Intermediate','Advanced')


--Invalid submission assignment
INSERT INTO submissions(assignment_id,student_id,submitted_at,score,status) VALUES
(999,1,'2026-02-28',95,'submitted');
--Rejected because assignment does not exist.
--SQLITE_CONSTRAINT_FOREIGNKEY: sqlite3 result code 787: FOREIGN KEY constraint failed


--Invalid submission score
INSERT INTO submissions(assignment_id,student_id,submitted_at,score,status) VALUES
(1,1,'2026-02-28',120,'submitted');
--Should be handled or explained. If not enforceable with basic CHECK, explain limitation.
--SQLITE_CONSTRAINT_CHECK: sqlite3 result code 275: CHECK constraint failed: score BETWEEN 0 AND 100


--Duplicate email
INSERT INTO students (full_name, email, city) VALUES
('Ardit Krasniqi','ardit@gmail.com','Prishtine');
--Rejected by UNIQUE email.
--SQLITE_CONSTRAINT_UNIQUE: sqlite3 result code 2067: UNIQUE constraint failed: students.email