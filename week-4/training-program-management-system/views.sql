--Create a student program overview view.
CREATE VIEW student_program_overview AS
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    programs.program_id,
    programs.program_name,
    programs.program_type
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id
LEFT JOIN programs
	ON enrollments.program_id = programs.program_id
GROUP BY students.student_id;


--Create a student submission overview view.
CREATE VIEW student_submission_overview AS
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
GROUP BY submissions.submission_id;


--Create a student attendance summary view.
CREATE VIEW student_attendance_summary AS
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    COUNT(attendance.status = 'present') AS present_times,
    COUNT(attendance.status = 'absent') AS absent_times,
    COUNT(attendance.status = 'late') AS late_times,
    COUNT(attendance.status = 'excused') AS excused_times
FROM
	students
LEFT JOIN attendance
	ON attendance.student_id = students.student_id
GROUP BY students.student_id;


--Create a student risk analysis view.
CREATE VIEW student_rsik_analysis AS 
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    COUNT(sub.submission_id) AS total_submissions,
    ROUND(AVG(sub.score), 2) AS average_score,

    CASE
        WHEN COUNT(sub.submission_id) = 0 THEN 'No Data'
        WHEN AVG(sub.score) >= 90 THEN 'No Risk'
        WHEN AVG(sub.score) >= 80 THEN 'Low Risk'
        WHEN AVG(sub.score) >= 70 THEN 'Medium Risk'
        WHEN AVG(sub.score) >= 60 THEN 'High Risk'
        ELSE 'Critical - Repeat Phase'
    END AS risk_level

FROM students s
LEFT JOIN submissions sub
    ON s.student_id = sub.student_id
GROUP BY
    s.student_id,
    s.first_name,
    s.last_name
ORDER BY average_score DESC;


--Create a management dashboard view.
CREATE VIEW managment_dashboard_view AS 
SELECT
    students.student_id,
    students.first_name,
    students.last_name,
    COUNT(submissions.submission_id) AS total_submissions,
    ROUND(AVG(submissions.score), 2) AS average_score,
    enrollments.status AS enrollment_status,
    programs.program_name,
    personnel.personnel_full_name,
    personnel.role AS personnel_role,

    CASE
        WHEN COUNT(submissions.submission_id) = 0 THEN 'No Data'
        WHEN AVG(submissions.score) >= 90 THEN 'No Risk'
        WHEN AVG(submissions.score) >= 80 THEN 'Low Risk'
        WHEN AVG(submissions.score) >= 70 THEN 'Medium Risk'
        WHEN AVG(submissions.score) >= 60 THEN 'High Risk'
        ELSE 'Critical - Repeat Phase'
    END AS risk_level,

    SUM(CASE WHEN attendance.status = 'present' THEN 1 ELSE 0 END) AS present_times,
    SUM(CASE WHEN attendance.status = 'absent' THEN 1 ELSE 0 END) AS absent_times,
    SUM(CASE WHEN attendance.status = 'late' THEN 1 ELSE 0 END) AS late_times,
    SUM(CASE WHEN attendance.status = 'excused' THEN 1 ELSE 0 END) AS excused_times

FROM students

JOIN enrollments
    ON enrollments.student_id = students.student_id

LEFT JOIN programs
    ON enrollments.program_id = programs.program_id

JOIN program_personnel
    ON program_personnel.program_id = programs.program_id

JOIN personnel
    ON program_personnel.personnel_id = personnel.personnel_id

LEFT JOIN attendance
    ON attendance.student_id = students.student_id

LEFT JOIN submissions
    ON submissions.student_id = students.student_id

GROUP BY
    students.student_id

ORDER BY average_score DESC;