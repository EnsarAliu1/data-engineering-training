--Part 8 - Data Quality Checks
--Find students with no enrollments.
SELECT
    students.student_id,
    students.student_fullName,
    students.student_email,
    students.student_city,
    enrollments.enrollment_id
FROM
	students
LEFT JOIN enrollments
	ON enrollments.student_id = students.student_id
WHERE
	enrollments.enrollment_id IS NULL;


--Find programs with no enrollments.
SELECT
	programs.program_id,
    programs.program_name,
    enrollments.enrollment_id
FROM
	programs
LEFT JOIN enrollments
	ON enrollments.program_id = programs.program_id
WHERE
	enrollments.enrollment_id IS NULL;

--Find enrollments with no payment record.
SELECT
	enrollments.enrollment_id,
    enrollments.student_id,
    enrollments.program_id,
    payments.payment_id
FROM
	enrollments
LEFT JOIN payments
	On payments.enrollment_id = enrollments.enrollment_id
WHERE payments.payment_id IS NULL;

--Find enrollments with no attendance records.
SELECT
	enrollments.enrollment_id,
    enrollments.student_id,
    enrollments.program_id,
    attendance.attendance_id,
    attendance.minutes_attended
FROM
	enrollments
LEFT JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
WHERE attendance.attendance_id IS NULL;

--Find active students with unpaid or partial payments.
SELECT
	enrollments.enrollment_id,
    enrollments.student_id,
    enrollments.program_id,
    attendance.attendance_id,
    attendance.minutes_attended
FROM
	enrollments
LEFT JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
WHERE attendance.attendance_id IS NULL;


SELECT 
	students.student_id,
    students.student_fullName,
    students.student_email,
    payments.payment_id,
    payments.status,
    enrollments.status
FROM
	students
LEFT JOIN enrollments
	on enrollments.student_id = students.student_id
LEFT JOIN payments
	oN payments.enrollment_id = enrollments.enrollment_id
WHERE payments.status in ('Pending' , 'Refunded') AND enrollments.status = 'active';

--32. Find students with low attendance but paid payment.
SELECT 
	students.student_id,
    students.student_fullName,
    students.student_email,
    payments.payment_id,
    payments.status,
    attendance.minutes_attended
FROM
	students
LEFT JOIN enrollments
	on enrollments.student_id = students.student_id
LEFT JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
LEFT JOIN attendance
	on attendance.enrollment_id = enrollments.enrollment_id
WHERE payments.status = 'Paid'
ORDER BY attendance.minutes_attended ASC
LIMIT 3;


--Find students with high attendance but unpaid or partial payment.
SELECT 
	students.student_id,
    students.student_fullName,
    students.student_email,
    payments.payment_id,
    payments.status,
    attendance.minutes_attended
FROM
	students
LEFT JOIN enrollments
	on enrollments.student_id = students.student_id
LEFT JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
LEFT JOIN attendance
	on attendance.enrollment_id = enrollments.enrollment_id
WHERE payments.status In ('Pending' , 'Refunded')
ORDER BY attendance.minutes_attended DESC
LIMIT 3;

--Find dropped students who still have paid or partial payment records.
SELECT 
	students.student_id,
    students.student_fullName,
    students.student_email,
    payments.payment_id,
    payments.status,
    enrollments.status
FROM
	students
LEFT JOIN enrollments
	on enrollments.student_id = students.student_id
LEFT JOIN payments
	ON payments.enrollment_id = enrollments.enrollment_id
WHERE payments.status In ('Refunded' , 'Paid') AND enrollments.status IN ('dropped')

--Find instructors with no active students.
SELECT
	instructors.instructor_id,
    instructors.instructor_fullName,
    students.student_id,
    students.student_fullName
FROM
	instructors
LEFT JOIN programs
	ON programs.instructor_id = instructors.instructor_id
 LEFT JOIN enrollments
 	ON enrollments.program_id = programs.program_id
LEFT JOIN students
	ON enrollments.student_id = students.student_id
WHERE students.student_id IS NULL


--Find any records that look risky, inconsistent, or incomplete based on your own design.
--Enrollments without any paying record
SELECT
    students.student_fullName,
    programs.program_name,
    enrollments.enrollment_id,
    enrollments.status,
    payments.status
FROM enrollments
JOIN students ON students.student_id = enrollments.student_id
JOIN programs ON programs.program_id = enrollments.program_id
LEFT JOIN payments ON payments.enrollment_id = enrollments.enrollment_id
WHERE payments.payment_id IS NULL;

--Students withou any attendance record
SELECT
    students.student_fullName,
    programs.program_name,
    enrollments.status AS enrollment_status
FROM enrollments
JOIN students ON students.student_id = enrollments.student_id
JOIN programs ON programs.program_id = enrollments.program_id
LEFT JOIN attendance ON attendance.enrollment_id = enrollments.enrollment_id
WHERE enrollments.status = 'active'
  AND attendance.attendance_id IS NULL;

    