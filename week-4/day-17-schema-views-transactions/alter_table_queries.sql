--Alter 1
--Students now need phone numbers.
--Add phone_number to students and fill it for at least 4 students.
ALTER TABLE students
ADD COLUMN phone_number TEXT;

UPDATE students
SET phone_number = '049123456'
WHERE student_id = 1;

UPDATE students
SET phone_number = '049234567'
WHERE student_id = 2;

UPDATE students
SET phone_number = '049345678'
WHERE student_id = 3;

UPDATE students
SET phone_number = '049456789'
WHERE student_id = 4;

UPDATE students
SET phone_number = '049567890'
WHERE student_id = 5;

UPDATE students
SET phone_number = '049678901'
WHERE student_id = 6;

CREATE UNIQUE INDEX students_phone_number_unique
ON students(phone_number);

SELECT * FROM students;


--Alter 2
--Students now need GitHub usernames.
--Add github_username to students and fill it for at least 4 students.

ALTER TABLE submissions
ADD COLUMN github_username TEXT;

UPDATE submissions
SET github_username = 'ardit'
WHERE student_id = 1;

UPDATE submissions
SET github_username = 'elira'
WHERE student_id = 2;

UPDATE submissions
SET github_username = 'blerim'
WHERE student_id = 3;

UPDATE submissions
SET github_username = 'sara'
WHERE student_id = 4;

UPDATE submissions
SET github_username = 'dren'
WHERE student_id = 5;

UPDATE submissions
SET github_username = 'ariana'
WHERE student_id = 6;



SELECT * FROM submissions;

--Alter 3
--Submissions need review status.
--Add review_status to submissions. Use values like 'not reviewed', 'reviewed', 'needs revision'.

ALTER TABLE submissions
ADD COLUMN review_status TEXT;

UPDATE submissions
SET review_status = 'not reviewed'
WHERE submission_id = 1;

UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 2;

UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 3;

UPDATE submissions
SET review_status = 'not reviewed'
WHERE submission_id = 4;

UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 5;

UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 6;

UPDATE submissions
SET review_status = 'not reviewed'
WHERE submission_id = 7;


UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 8;


UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 9; 

UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 10; 
 
UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 11;

UPDATE submissions
SET review_status = 'not reviewed'
WHERE submission_id = 12;

UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 13;

UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 14;

UPDATE submissions
SET review_status = 'not reviewed'
WHERE submission_id = 15;

UPDATE submissions
SET review_status = 'reviewed'
WHERE submission_id = 16;

UPDATE submissions
SET review_status = 'needs revision'
WHERE submission_id = 17;


SELECT * FROM submissions;

--Alter 4
--Submissions need review date.
--Add reviewed_at to submissions and update at least 3 rows.

ALTER TABLE submissions
ADD COLUMN reviewed_at DATE;

UPDATE submissions
SET reviewed_at = NULL
WHERE submission_id = 1;

UPDATE submissions
SET reviewed_at = '2026-07-10'
WHERE submission_id = 2;

UPDATE submissions
SET reviewed_at = '2026-07-11'
WHERE submission_id = 3;

UPDATE submissions
SET reviewed_at = NULL
WHERE submission_id = 4;

UPDATE submissions
SET reviewed_at = '2026-07-12'
WHERE submission_id = 5;

UPDATE submissions
SET reviewed_at = '2026-07-13'
WHERE submission_id = 6;

UPDATE submissions
SET reviewed_at = NULL
WHERE submission_id = 7;

UPDATE submissions
SET reviewed_at = '2026-07-14'
WHERE submission_id = 8;

UPDATE submissions
SET reviewed_at = '2026-07-15'
WHERE submission_id = 9;

UPDATE submissions
SET reviewed_at = '2026-07-16'
WHERE submission_id = 10;

UPDATE submissions
SET reviewed_at = '2026-07-17'
WHERE submission_id = 11;

UPDATE submissions
SET reviewed_at = NULL
WHERE submission_id = 12;

UPDATE submissions
SET reviewed_at = '2026-07-18'
WHERE submission_id = 13;

UPDATE submissions
SET reviewed_at = '2026-07-19'
WHERE submission_id = 14;

UPDATE submissions
SET reviewed_at = NULL
WHERE submission_id = 15;

UPDATE submissions
SET reviewed_at = '2026-07-20'
WHERE submission_id = 16;

UPDATE submissions
SET reviewed_at = '2026-07-21'
WHERE submission_id = 17;


SELECT * FROM submissions;

--Alter 5
---Attendance needs correction tracking.
--Add corrected_at to attendance and update rows that were corrected.

ALTER TABLE attendance
ADD COLUMN corrected_at DATE;

UPDATE attendance
SET corrected_at = '2026-07-08'
WHERE session_id = 1 AND student_id = 3;

UPDATE attendance
SET corrected_at = '2026-07-08'
WHERE session_id = 1 AND student_id = 4;

UPDATE attendance
SET corrected_at = '2026-07-09'
WHERE session_id = 2 AND student_id = 4;

UPDATE attendance
SET corrected_at = '2026-07-09'
WHERE session_id = 2 AND student_id = 5;

UPDATE attendance
SET corrected_at = '2026-07-10'
WHERE session_id = 3 AND student_id = 6;

SELECT * FROM attendance;

--Alter 6
--Programs need a difficulty level.
--Add difficulty_level to programs. Example values: beginner, intermediate,advanced.

UPDATE programs
SET program_type = 'intermediate'
WHERE program_id = 2;

UPDATE programs
SET program_type = 'advanced'
WHERE program_id = 3;

SELECT * FROM programs;


--Alter 7
--Assignments need task type.
--Add task_type to assignments. Example values: SQL, Python, Pipeline, Databricks Prep.

ALTER TABLE assignments
ADD COLUMN task_type TEXT;

UPDATE assignments
SET task_type = 'sql pipline'
WHERE assignment_id = 1;

UPDATE assignments
SET task_type = 'python pipline'
WHERE assignment_id = 2;

UPDATE assignments
SET task_type = 'NodeJS pipline'
WHERE assignment_id = 3;


SELECT * FROM assignments;