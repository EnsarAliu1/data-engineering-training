--Part 6 - Aggregation Reports
--Count students by city.
SELECT
	COUNT(*) AS city_count,
    students.student_city
FROM
	students
GROUP BY students.student_city;

--Count enrollments by status.
SELECT
	COUNT(*) AS enrollment_status_count,
    enrollments.status
FROM
	enrollments
GROUP BY enrollments.status;

--Count enrollments by program.
SELECT
	COUNT(*) AS enrollment_count,
    programs.program_name
FROM
	enrollments
JOIN programs
	ON enrollments.program_id = programs.program_id
GROUP BY programs.program_name;


--Count active enrollments by program.
SELECT
	COUNT(*) AS active_enrollment_count,
    programs.program_name
FROM
	enrollments
JOIN programs
	ON enrollments.program_id = programs.program_id
WHERE enrollments.status = 'active'
GROUP BY programs.program_name;


--Calculate total paid amount by program.
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
GROUP BY programs.program_name;

--Calculate unpaid or partial amount by program.
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
GROUP BY programs.program_name;


--Calculate collected revenue by city.
SELECT
    students.student_city,
    SUM(programs.price) AS total_paid_amount
FROM
	enrollments
JOIN programs
	ON enrollments.program_id = programs.program_id
JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
JOIN students
	ON enrollments.student_id = students.student_id
WHERE payments.status = 'Paid'
GROUP BY students.student_city;


--Calculate average attendance rate by student.
SELECT
    students.student_id,
    students.student_fullName,
    AVG(attendance.minutes_attended) AS avg_minutes_attended
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
GROUP BY students.student_id, students.student_fullName;


--Calculate average attendance rate by program.
SELECT
	programs.program_name,
    AVG(attendance.minutes_attended) AS avg_minutes_attended
FROM
	programs
JOIN enrollments
	on enrollments.program_id = programs.program_id
JOIN attendance
	On attendance.enrollment_id = enrollments.enrollment_id
GROUP BY programs.program_name;

--Show top 5 students by attendance rate.
SELECT
    students.student_id,
    students.student_fullName,
    SUM(attendance.minutes_attended) AS total_minutes_attended
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
GROUP BY students.student_id, students.student_fullName
ORDER BY total_minutes_attended DESC
LIMIT 5;

--Show top 5 programs by collected revenue.
SELECT
	programs.program_name,
    SUM(programs.price) AS total_collected_revenue
FROM
	programs
JOIN enrollments
	oN enrollments.program_id = programs.program_id
JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
WHERE payments.status = 'Paid'
GROUP BY programs.program_name
ORDER BY total_collected_revenue DESC
LIMIT 5;


--Show instructors ranked by number of active students.
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
ORDER BY active_students DESC;