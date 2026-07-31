--Part 4 - Basic Reports

--Show all students with the programs they are enrolled in.
SELECT
	students.*,
    programs.program_name,
    programs.program_type,
    enrollments.status AS enrollment_status
FROM
	students
JOIN enrollments 
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id
WHERE enrollments.status = 'active';
        

--Show all programs with their instructors or mentors.
SELECT
	programs.*,
    personnel.*
FROM
	programs
JOIN program_personnel
	ON program_personnel.program_id = programs.program_id
JOIN personnel
	ON program_personnel.personnel_id = personnel.personnel_id;


--Show all sessions with program information.
SELECT
	sessions.*,
    programs.*
FROM
	sessions
JOIN programs
	ON sessions.program_id = programs.program_id;


--Show attendance with student name and session information.
SELECT
	attendance.*,
    students.first_name,
    sessions.*
FROM 
	attendance
JOIN students
	ON attendance.student_id = students.student_id
JOIN sessions
	ON attendance.session_id = sessions.session_id;


--Show submissions with student name and assignment information.
SELECT
	submissions.*,
    students.first_name,
    sessions.*
FROM
	submissions
JOIN students
	ON submissions.student_id = students.student_id
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN programs
	ON enrollments.program_id = programs.program_id
JOIN sessions
	ON sessions.program_id = programs.program_id;


--Show all active students.
SELECT
	students.*,
    enrollments.status AS enrollment_status
FROM 
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
WHERE enrollments.status = 'active';


--Show all dropped students.
SELECT
	students.*,
    enrollments.status AS enrollment_status
FROM 
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
WHERE enrollments.status = 'dropped';


--Show all reviewed submissions.
SELECT
	*
FROM
	submissions
WHERE
	submissions.feedback IS NOT NULL;


--Show students who are enrolled but do not have much activity yet.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    programs.program_name,
    COUNT(DISTINCT attendance.attendance_id) AS attendance_count,
    COUNT(DISTINCT submissions.submission_id) AS submission_count
FROM
    students
JOIN enrollments
    ON students.student_id = enrollments.student_id
JOIN programs
    ON enrollments.program_id = programs.program_id
LEFT JOIN attendance
    ON students.student_id = attendance.student_id
LEFT JOIN submissions
    ON students.student_id = submissions.student_id
WHERE
    enrollments.status = 'active'
GROUP BY
    students.student_id,
    students.first_name,
    students.last_name,
    programs.program_name
HAVING
    COUNT(DISTINCT attendance.attendance_id) <= 2
    AND COUNT(DISTINCT submissions.submission_id) <= 2;



--Show a clean list that management could read without IDs only.
SELECT
    students.first_name,
    students.last_name,
    students.email,
    programs.program_name,
    programs.program_type,
    programs.status AS program_status,
    personnel.personnel_full_name,
    personnel.role,
    enrollments.status AS enrollment_status,
    COUNT(DISTINCT sessions.session_id) AS session_counts,
    COUNT(DISTINCT attendance.attendance_id) AS attendance_counts,
    COUNT(DISTINCT assignments.assignment_id) AS assignments_count,
    SUM(DISTINCT submissions.score) AS submissions_score
FROM
    students
JOIN enrollments
    ON enrollments.student_id = students.student_id
JOIN programs
    ON enrollments.program_id = programs.program_id
JOIN program_personnel
    ON program_personnel.program_id = programs.program_id
JOIN personnel
    ON program_personnel.personnel_id = personnel.personnel_id
LEFT JOIN sessions
    ON sessions.program_id = programs.program_id
LEFT JOIN attendance
    ON attendance.session_id = sessions.session_id
LEFT JOIN assignments
    ON assignments.program_id = programs.program_id
LEFT JOIN submissions
    ON submissions.assignment_id = assignments.assignment_id
GROUP BY
    students.student_id,
    students.first_name,
    students.last_name,
    students.email,
    programs.program_name,
    programs.program_type,
    programs.status,
    personnel.personnel_full_name,
    personnel.role,
    enrollments.status
ORDER BY submissions_score DESC;