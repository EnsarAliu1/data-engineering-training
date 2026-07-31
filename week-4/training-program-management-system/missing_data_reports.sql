--Part 6 - Missing Data Analysis

--Students who did not submit a specific assignment.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    assignments.assignment_id,
    assignments.title AS assignment_title
FROM
	students
JOIN enrollments
    ON enrollments.student_id = students.student_id
JOIN assignments
    ON assignments.program_id = enrollments.program_id
LEFT JOIN submissions
    ON submissions.assignment_id = assignments.assignment_id
    AND submissions.student_id = students.student_id
WHERE
    assignments.assignment_id = 1
    AND submissions.submission_id IS NULL;


--Students who have no submissions at all.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    submissions.submission_id,
    submissions.submitted_at,
    submissions.score
FROM
	students
LEFT JOIN submissions
	ON submissions.student_id = students.student_id
WHERE submissions.submission_id IS NULL;


--Submissions without feedback.
/*Students who have no submissions at all.*/
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    submissions.submission_id,
    submissions.submitted_at,
    submissions.score,
    submissions.feedback
FROM
	students
LEFT JOIN submissions
	ON submissions.student_id = students.student_id
WHERE submissions.feedback IS NULL;


--Students without attendance for a specific session.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    sessions.session_id,
    sessions.session_title
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN sessions
	ON sessions.program_id = enrollments.program_id
LEFT JOIN attendance
	ON attendance.session_id = sessions.session_id
    AND attendance.student_id = students.student_id
WHERE
	sessions.session_id = 1
    AND attendance.attendance_id IS NULL;


--Students without review or evaluation.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    assignments.title AS assignment_title,
    submissions.submitted_at,
    submissions.feedback
FROM
    students
JOIN submissions
    ON submissions.student_id = students.student_id
JOIN assignments
    ON assignments.assignment_id = submissions.assignment_id
WHERE
    submissions.feedback IS NULL;


--Programs without enough sessions.
SELECT
	programs.program_id,
    programs.program_name,
    programs.program_type,
    COUNT(sessions.session_id) AS count_session
FROM
	programs
LEFT JOIN sessions
	ON sessions.program_id = programs.program_id
GROUP BY
	programs.program_id  
ORDER BY `count_session` ASC


--Assignments without submissions.
SELECT
	assignments.assignment_id,
    assignments.title AS assignment_title,
    submissions.submission_id
FROM
	assignments
LEFT JOIN submissions
	ON submissions.assignment_id = assignments.assignment_id
WHERE
	submissions.submission_id IS NULL;


--Active students with no recent activity.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    enrollments.status AS enrollment_status,
    COUNT(attendance.status IN( 'absent','excused')) AS late_or_absent_recent_activity
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
JOIN attendance
	ON attendance.student_id = students.student_id
GROUP BY students.student_id;


--Students who have attendance but no submission history.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    COUNT(DISTINCT attendance.attendance_id) AS attendance_count
FROM
    students
JOIN attendance
    ON attendance.student_id = students.student_id
LEFT JOIN submissions
    ON submissions.student_id = students.student_id
WHERE
    submissions.submission_id IS NULL
GROUP BY
    students.student_id,
    students.first_name,
    students.last_name;


--Students who have submissions but no feedback yet.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    assignments.title AS assignment_title,
    submissions.submitted_at,
    submissions.feedback
FROM
    students
JOIN submissions
    ON submissions.student_id = students.student_id
JOIN assignments
    ON assignments.assignment_id = submissions.assignment_id
WHERE
    submissions.feedback IS NULL;