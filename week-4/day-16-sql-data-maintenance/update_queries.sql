--Update 1
UPDATE
	students
SET
	city = 'Skenderaj'
WHERE student_id = 1;

SELECT * FROM students WHERE student_id = 1;

--Update 2
UPDATE
	students
SET
	email = 'elira1@gmail.com'
WHERE student_id = 2;

SELECT * FROM students WHERE student_id = 2;

-- Update 3
UPDATE
	programs
SET
	status = 'planned'
WHERE program_id = 1;

SELECT * FROM programs WHERE program_id = 1;

-- Update 4
UPDATE enrollments
SET status = 'cancelled'
WHERE enrollment_id = 1
  AND student_id = 1;
  
  SELECT *
FROM enrollments
WHERE enrollment_id = 1;


--Update 5
UPDATE attendance
SET
    status = 'present',
    notes = 'On time'
WHERE session_id = 3
  AND student_id = 1;


--Update 6
UPDATE submissions
SET score = 90
WHERE submission_id = 1
  AND student_id = 1;
  
  SELECT *
FROM submissions
WHERE submission_id = 1;

--Update 7
UPDATE students
SET city = 'Pristina'
WHERE city = 'Prishtinë';

UPDATE students
SET city = 'Peja'
WHERE city = 'Pejë';

UPDATE students
SET city = 'Mitrovica'
WHERE city = 'Mitrovicë';

SELECT student_id, first_name, last_name, city
FROM students;