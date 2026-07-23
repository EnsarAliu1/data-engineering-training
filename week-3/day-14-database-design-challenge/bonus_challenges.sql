--Create a SQL VIEW for active student enrollments.
CREATE VIEW
	view_active_enrollments AS
SELECT
    students.student_id,
    students.student_fullName,
    students.student_email,
    students.student_city,
    programs.program_id,
    programs.program_name,
    programs.level,
    programs.price,
    instructors.instructor_fullName,
    enrollments.enrollment_id,
    enrollments.enrollment_date
FROM
	enrollments
JOIN students
	ON students.student_id      = enrollments.student_id
JOIN programs
	ON programs.program_id      = enrollments.program_id
JOIN instructors
	ON instructors.instructor_id = programs.instructor_id
WHERE enrollments.status = 'active';


--Create a SQL VIEW for program revenue.
CREATE VIEW
	view_program_revenue AS
SELECT
    programs.program_id,
    programs.program_name,
    programs.level,
    programs.price,
    instructors.instructor_fullName,
    COUNT(enrollments.enrollment_id) AS total_enrollments,
    SUM(programs.price) AS total_revenue
FROM
	programs
JOIN instructors
	ON instructors.instructor_id  = programs.instructor_id
LEFT JOIN enrollments
	ON enrollments.program_id = programs.program_id
LEFT JOIN payments
	ON payments.enrollment_id  = enrollments.enrollment_id
WHERE payments.status = 'Paid'
GROUP BY
    programs.program_id,
    programs.program_name,
    programs.level,
    programs.price,
    instructors.instructor_fullName;

--Create a SQL VIEW for student risk summary.
CREATE VIEW view_student_risk AS
SELECT
    students.student_id,
    students.student_fullName,
    students.student_city,
    programs.program_name,
    enrollments.status AS enrollment_status,
    payments.status  AS payment_status,
    COUNT(attendance.attended) AS total_sessions,
    SUM(attendance.attended) AS sessions_attended,
    ROUND(SUM(attendance.attended) * 100.0 / COUNT(attendance.attended), 2) AS attendance_rate
FROM
	students
JOIN enrollments
	ON enrollments.student_id    = students.student_id
JOIN programs
	ON programs.program_id        = enrollments.program_id
LEFT JOIN payments
	ON payments.enrollment_id  = enrollments.enrollment_id
LEFT JOIN attendance
	ON attendance.enrollment_id = enrollments.enrollment_id
GROUP BY
    students.student_id,
    students.student_fullName,
    students.student_city,
    programs.program_name,
    enrollments.status,
    payments.status;