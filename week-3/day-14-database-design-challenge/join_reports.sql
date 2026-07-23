--Part 5 - JOIN Reports
--Show all students with their programs and instructors.
SELECT
	students.student_id,
    students.student_fullName,
    students.student_email,
    students.student_city,
    programs.program_name,
    instructors.instructor_fullName
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id
JOIN instructors
	ON programs.instructor_id = instructors.instructor_id;


--Show active enrollments only, including student name, program name, instructor name, and status.
SELECT
	students.student_fullName,
    programs.program_name,
    instructors.instructor_fullName,
    enrollments.status
FROM 
	enrollments
JOIN students
	ON enrollments.student_id = students.student_id
JOIN programs
	On enrollments.program_id = programs.program_id
JOIN instructors
	ON programs.instructor_id = instructors.instructor_id
WHERE enrollments.status = 'completed';


--Show completed enrollments with student and program information.
SELECT
	students.*,
    programs.*,
    enrollments.status
FROM 
	enrollments
JOIN students
	ON enrollments.student_id = students.student_id
JOIN programs
	On enrollments.program_id = programs.program_id
WHERE enrollments.status = 'completed';

--Show dropped students and the program they dropped from.
SELECT
	students.*,
    programs.*,
    enrollments.status
FROM 
	enrollments
JOIN students
	ON enrollments.student_id = students.student_id
JOIN programs
	On enrollments.program_id = programs.program_id
WHERE enrollments.status = 'dropped';


--Show attendance records with student name, program name, date, and attended value.
SELECT
	students.student_fullName,
    programs.program_name,
    attendance.session_date,
    attendance.minutes_attended
FROM
	attendance
JOIN enrollments
	ON attendance.enrollment_id = enrollments.enrollment_id
JOIN students
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id;
    

--Show payment records with student name, program name, payment month, status, and amount.
SELECT
    students.student_fullName,
    programs.program_name,
    payments.payment_date,
    payments.payment_method,
    payments.status,
    programs.price
FROM
	payments
JOIN enrollments
	ON payments.enrollment_id = enrollments.enrollment_id
JOIN students	
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id;


--Show each student with city and all programs they are enrolled in.
SELECT
	students.*,
    programs.program_name
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id;


--Show instructors and the students/programs they are responsible for.
SELECT
	instructors.*,
    students.student_id,
    students.student_fullName,
    programs.program_name
FROM
	instructors
JOIN programs
	ON programs.instructor_id = instructors.instructor_id
JOIN enrollments
	ON enrollments.program_id = programs.program_id
JOIN students
	ON enrollments.student_id = students.student_id;