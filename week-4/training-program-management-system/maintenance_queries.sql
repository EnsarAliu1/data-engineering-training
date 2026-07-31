--Part 7 - Data Maintenance

--Correct a student city.
SELECT
	*
FROM
	students
WHERE
	students.student_id = 1;
    
UPDATE students
SET students.city = 'Skenderaj'
WHERE students.student_id = 1;


SELECT
	*
FROM
	students
WHERE
	students.student_id = 1;


--Update a wrong email.
SELECT
	*
FROM
	students
WHERE
	students.student_id = 1;
    
UPDATE students
SET students.email = 'ardit.berisha1@gmail.com'
WHERE students.student_id = 1;


SELECT
	*
FROM
	students
WHERE
	students.student_id = 1;


--Change a program status.
SELECT
	*
FROM
	programs
WHERE
	programs.program_id = 2;


UPDATE programs
SET programs.status = 'planned'
WHERE programs.program_id = 2;


SELECT
	*
FROM
	programs
WHERE
	programs.program_id = 2;


--Mark a student as dropped without deleting the student.
SELECT
	* 
FROM
	enrollments 
WHERE
	enrollments.enrollment_id = 2;

UPDATE enrollments
SET enrollments.status = 'dropped'
WHERE enrollments.student_id = 2 AND enrollments.enrollment_id = 2;

SELECT
	* 
FROM
	enrollments 
WHERE
	enrollments.enrollment_id = 2;


--Correct attendance from absent to present.
SELECT * FROM attendance 
WHERE attendance.session_id = 1 AND attendance.student_id = 5;

UPDATE attendance
SET attendance.status = 'present'
WHERE attendance.session_id = 1 AND attendance.student_id = 5;

SELECT * FROM attendance 
WHERE attendance.session_id = 1 AND attendance.student_id = 5;


--Add feedback to a submission where feedback is missing.
SELECT * FROM submissions
WHERE submissions.assignment_id = 1 AND submissions.student_id = 3;

UPDATE submissions
SET submissions.feedback = 'Improve your work'
WHERE submissions.assignment_id = 1 AND submissions.student_id = 3;

SELECT * FROM submissions
WHERE submissions.assignment_id = 1 AND submissions.student_id = 3;


--Update a score after review.
SELECT * FROM submissions
WHERE submissions.assignment_id  =2 AND submissions.student_id = 1;

UPDATE submissions
SET submissions.score = 95
WHERE submissions.assignment_id  =2 AND submissions.student_id = 1;

SELECT * FROM submissions
WHERE submissions.assignment_id  =2 AND submissions.student_id = 1;


--Normalize inconsistent city names.
/* Normalize inconsistent city names */

UPDATE students
SET city = 'Prishtina'
WHERE city IN ('Prishtinë', 'prishtina', 'PRISHTINA');

UPDATE students
SET city = 'Prizren'
WHERE city IN ('prizren', 'PRIZREN');

UPDATE students
SET city = 'Peja'
WHERE city IN ('Pejë', 'peja', 'PEJA');

UPDATE students
SET city = 'Gjilan'
WHERE city IN ('gjilani', 'gjilan', 'GJILAN');

UPDATE students
SET city = 'Mitrovica'
WHERE city IN ('mitrovica', 'MITROVICA');

UPDATE students
SET city = 'Ferizaj'
WHERE city IN ('ferizaji', 'ferizaj', 'FERIZAJ');

UPDATE students
SET city = 'Gjakova'
WHERE city IN ('gjakovë', 'gjakova', 'GJAKOVA');

UPDATE students
SET city = 'Vushtrri'
WHERE city IN ('vushtri', 'VUSHTRRI');

UPDATE students
SET city = 'Podujeva'
WHERE city IN ('podujevë', 'podujeva', 'PODUJEVA');

UPDATE students
SET city = 'Lipjan'
WHERE city IN ('lipjani', 'lipjan', 'LIPJAN');



--Test a dangerous delete and explain why it should not be done.
--**Dangerous Delete Test**

```sql
/* Extremely dangerous DELETE - DO NOT EXECUTE */

DELETE students,
       enrollments,
       attendance,
       submissions
FROM students
LEFT JOIN enrollments
    ON students.student_id = enrollments.student_id
LEFT JOIN attendance
    ON students.student_id = attendance.student_id
LEFT JOIN submissions
    ON students.student_id = submissions.student_id;
```

--**Explanation:**

--This is an extremely dangerous SQL statement because it deletes all students and their related enrollment, attendance, and submission records at once. Executing this query would result in major data loss and could make the database unusable. If no backup exists, the deleted data may be impossible to recover. For this reason, `DELETE` statements should always include a `WHERE` clause and should be tested carefully before being executed on a production database.
