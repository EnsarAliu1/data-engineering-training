--Part 11 - Final Manager Report
SELECT
    students.student_id,
    students.first_name,
    students.last_name,

    COUNT(DISTINCT submissions.submission_id) AS total_submissions,
    ROUND(AVG(submissions.score), 2) AS average_score,

    enrollments.status AS enrollment_status,
    programs.program_name,
    personnel.personnel_full_name,
    personnel.role AS personnel_role,

    CASE
        WHEN COUNT(DISTINCT submissions.submission_id) = 0 THEN 'Not enough data'
        WHEN AVG(submissions.score) >= 90 THEN 'Invite to next phase'
        WHEN AVG(submissions.score) >= 80 THEN 'No Risk'
        WHEN AVG(submissions.score) >= 70 THEN 'Schedule live coding check'
        WHEN AVG(submissions.score) >= 60 THEN 'Needs extra practice'
        ELSE 'Critical - Repeat Phase'
    END AS recommendation,

    SUM(CASE WHEN submissions.submission_id IS NULL THEN 1 ELSE 0 END) AS missing_submissions,
    SUM(CASE WHEN submissions.feedback IS NULL THEN 1 ELSE 0 END) AS missing_feedbacks,

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