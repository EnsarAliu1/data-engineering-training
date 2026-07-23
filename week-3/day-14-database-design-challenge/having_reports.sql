--Part 7 - HAVING Reports
--Show programs with more than 3 enrollments.
SELECT
    programs.program_id,
    programs.program_name,
    programs.level,
    programs.price,
    COUNT(enrollments.enrollment_id) AS total_enrollments
FROM programs
JOIN enrollments ON enrollments.program_id = programs.program_id
GROUP BY programs.program_id, programs.program_name, programs.level, programs.price
HAVING COUNT(enrollments.enrollment_id) > 3
ORDER BY total_enrollments DESC;

--Show cities with more than 2 students.
SELECT 
	students.student_city,
    COUNT(students.student_city) AS city_count
FROM students
GROUP BY students.student_city
HAVING city_count > 2
ORDER BY city_count DESC;

--Show students with attendance rate below 70%.
SELECT
    students.student_id,
    students.student_fullName,
    COUNT(attendance.attended) AS total_sessions,
    SUM(attendance.attended) AS sessions_attended,
    ROUND(SUM(attendance.attended) * 100.0 / COUNT(attendance.attended), 2) AS attendance_rate
FROM
	students
JOIN enrollments
	ON enrollments.student_id   = students.student_id
JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
GROUP BY
	students.student_id, students.student_fullName
HAVING
	ROUND(SUM(attendance.attended) * 100.0 / COUNT(attendance.attended), 2) < 70
ORDER BY
	attendance_rate ASC;


--Show programs with collected revenue greater than 300.
SELECT
    programs.program_name,
    SUM(programs.price) AS total_paid_amount
FROM
	enrollments
JOIN programs
	ON enrollments.program_id = programs.program_id
JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
WHERE payments.status = 'Paid'
GROUP BY programs.program_name
HAVING total_paid_amount > 300;

--Show instructors with more than 3 active enrollments.
SELECT
    instructors.instructor_id,
    instructors.instructor_fullName,
    instructors.specialization,
    COUNT(enrollments.enrollment_id) AS active_students
FROM
	instructors
JOIN programs
	ON programs.instructor_id   = instructors.instructor_id
JOIN enrollments
	ON enrollments.program_id   = programs.program_id
WHERE enrollments.status = 'active'
GROUP BY instructors.instructor_id, instructors.instructor_fullName, instructors.specialization
HAVING active_students > 3
ORDER BY active_students DESC;

--Show programs with unpaid or partial payment amount greater than 100.
SELECT
    programs.program_name,
    SUM(programs.price) AS total_unpaid_amount
FROM
	enrollments
JOIN programs
	ON enrollments.program_id = programs.program_id
JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
WHERE payments.status In ('Pending' , 'Refunded')
GROUP BY programs.program_name
HAVING total_unpaid_amount > 100;