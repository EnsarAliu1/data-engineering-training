--Part 5 - Advanced Reports
--Average score by student.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    AVG(submissions.score) AS average_student_score
FROM
	students
JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY students.student_id;


--Average score by assignment.
SELECT
	assignments.assignment_id,
    assignments.program_id,
    assignments.title,
    AVG(submissions.score) AS average_student_score
FROM
	assignments
JOIN submissions
	ON submissions.assignment_id = assignments.assignment_id
GROUP BY assignments.assignment_id;


--Attendance summary by student.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    COUNT(attendance.attendance_id) AS total_attendance,
    SUM(attendance.status = 'present') AS presesnt_attendance,
    SUM(attendance.status = 'absent') AS absent_attendance,
    SUM(attendance.status = 'late' ) AS late_attendance,
    SUM(attendance.status = 'excused') AS excused_attendance
FROM
	students
LEFT JOIN attendance
	ON attendance.student_id = students.student_id
GROUP BY students.student_id;


--Submission count by student.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    COUNT(submissions.submission_id) AS submissions_count
FROM
	students
LEFT JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY students.student_id;


--Missing submission count by student.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    programs.program_name,
    COUNT(assignments.assignment_id) - COUNT(submissions.submission_id) AS missing_submissions
FROM
    students
JOIN enrollments
    ON students.student_id = enrollments.student_id
JOIN programs
    ON enrollments.program_id = programs.program_id
JOIN assignments
    ON assignments.program_id = programs.program_id
LEFT JOIN submissions
    ON submissions.assignment_id = assignments.assignment_id
    AND submissions.student_id = students.student_id
GROUP BY
    students.student_id,
    students.first_name,
    students.last_name,
    programs.program_name
HAVING
    missing_submissions > 0
ORDER BY
    missing_submissions DESC;



--Feedback missing count.
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    COUNT(submissions.submission_id) AS feedback_missing_count
FROM
    students
JOIN submissions
    ON submissions.student_id = students.student_id
WHERE
    submissions.feedback IS NULL
GROUP BY
    students.student_id,
    students.first_name,
    students.last_name
ORDER BY
    feedback_missing_count DESC;


--Program performance summary.
SELECT
	programs.program_id,
    programs.program_name,
    COUNT(enrollments.program_id) AS enrollments_by_program,
    ROUND(
        SUM(attendance.status = 'present') /
        COUNT(attendance.attendance_id) * 100,
        2
    ) AS attendance_rate
FROM
	programs
JOIN enrollments
	ON enrollments.program_id = programs.program_id
JOIN students
	ON enrollments.student_id = students.student_id
JOIN attendance
	ON attendance.student_id = students.student_id
GROUP BY programs.program_name;


--Students with average score below 70.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    AVG(submissions.score) AS average_student_score
FROM
	students
JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY
	students.student_id
HAVING
	average_student_score < 70;


--Students with 2 or more absences.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    COUNT(attendance.status = 'absent') AS count_of_absences
FROM
	students
JOIN attendance
	ON attendance.student_id = students.student_id
GROUP BY
	students.student_id
HAVING count_of_absences >= 2;


--Students who need support.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    AVG(submissions.score) AS average_student_score,
    CASE
    	WHEN AVG(submissions.score) >= 90 THEN "Excellent"
    	WHEN AVG(submissions.score) >= 75 THEN "Good"
        ELSE 'Needs Improvement'
    END AS performance_level
FROM
	students
LEFT JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY students.student_id;


--Students who look ready for the next phase.
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    AVG(submissions.score) AS average_student_score,
    CASE
    	WHEN AVG(submissions.score) >= 90 THEN "Next Phase"
    	WHEN AVG(submissions.score) >= 75 THEN "Test before next phase"
        ELSE 'Repeat this phase'
    END AS performance_level
FROM
	students
LEFT JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY students.student_id;


--Program-level summary that includes students, attendance, scores, and missing work.
SELECT
    p.program_name,
    p.program_type,
    p.status,

    COUNT(DISTINCT e.student_id) AS total_students,

    (
        SELECT COUNT(*)
        FROM attendance a
        JOIN sessions s
            ON a.session_id = s.session_id
        WHERE s.program_id = p.program_id
    ) AS total_attendance,

    (
        SELECT ROUND(AVG(sub.score), 2)
        FROM submissions sub
        JOIN assignments ass
            ON sub.assignment_id = ass.assignment_id
        WHERE ass.program_id = p.program_id
    ) AS average_score,

    (
        SELECT
            COUNT(*) - COUNT(sub.submission_id)
        FROM enrollments en
        JOIN assignments ass
            ON ass.program_id = en.program_id
        LEFT JOIN submissions sub
            ON sub.assignment_id = ass.assignment_id
            AND sub.student_id = en.student_id
        WHERE en.program_id = p.program_id
    ) AS missing_work

FROM programs p
LEFT JOIN enrollments e
    ON e.program_id = p.program_id

GROUP BY
    p.program_id,
    p.program_name,
    p.program_type,
    p.status

ORDER BY
    average_score DESC;