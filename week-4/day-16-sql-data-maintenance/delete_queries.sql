
SELECT * FROM assignments
WHERE assignment_id = 99;


DELETE FROM assignments
WHERE assignment_id = 99;


SELECT * FROM assignments
WHERE assignment_id = 99;



DELETE FROM students
WHERE student_id = 1;


SELECT * FROM students
WHERE student_id = 1;



DELETE FROM assignments
WHERE assignment_id = 1;



SELECT * FROM assignments
WHERE assignment_id = 1;



INSERT INTO assignments
(program_id, title, day_number, due_date, max_points)
VALUES
(1, 'Temporary Assignment', 99, '2026-09-01', 100);


SELECT * FROM assignments
WHERE title = 'Temporary Assignment';


DELETE FROM assignments
WHERE title = 'Temporary Assignment';


SELECT * FROM assignments
WHERE title = 'Temporary Assignment';



UPDATE enrollments
SET status = 'cancelled'
WHERE student_id = 4
  AND program_id = 1;


SELECT *
FROM enrollments
WHERE student_id = 4
  AND program_id = 1;