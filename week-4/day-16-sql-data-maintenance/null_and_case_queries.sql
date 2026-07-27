SELECT *
FROM submissions
WHERE feedback IS NULL;


SELECT *
FROM submissions
WHERE feedback IS NOT NULL;


SELECT *
FROM attendance
WHERE notes IS NULL;


SELECT *
FROM attendance
WHERE notes IS NOT NULL;


SELECT
    student_id,
    assignment_id,
    score,
    COALESCE(feedback, 'No feedback yet') AS feedback_status
FROM submissions;


SELECT
    attendance_id,
    session_id,
    student_id,
    status,
    COALESCE(notes, 'No notes') AS notes_status
FROM attendance;


SELECT
    submission_id,
    student_id,
    assignment_id,
    score,
    COALESCE(feedback, 'No feedback yet') AS feedback_status
FROM submissions
ORDER BY student_id;


SELECT
    attendance_id,
    student_id,
    session_id,
    status,
    COALESCE(notes, 'No notes') AS notes_status
FROM attendance
ORDER BY session_id, student_id;


SELECT
    student_id,
    assignment_id,
    score,
    CASE
        WHEN score >= 90 THEN 'Excellent'
        WHEN score >= 75 THEN 'Good'
        WHEN score >= 60 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS performance_level
FROM submissions;


SELECT
    attendance_id,
    student_id,
    session_id,
    status,
    CASE
        WHEN status = 'present' THEN 'Attended'
        WHEN status = 'late' THEN 'Late Arrival'
        WHEN status = 'excused' THEN 'Excused Absence'
        WHEN status = 'absent' THEN 'Absent'
    END AS attendance_category
FROM attendance;


SELECT
    enrollment_id,
    student_id,
    program_id,
    status,
    CASE
        WHEN status = 'active' THEN 'Low Risk'
        WHEN status = 'paused' THEN 'Medium Risk'
        WHEN status = 'cancelled' THEN 'High Risk'
    END AS enrollment_risk
FROM enrollments;


SELECT
    student_id,
    assignment_id,
    score,
    CASE
        WHEN score >= 90 THEN 'Excellent'
        WHEN score >= 75 THEN 'Good'
        WHEN score >= 60 THEN 'Needs Improvement'
        ELSE 'At Risk'
    END AS performance_level,
    COALESCE(feedback, 'No feedback yet') AS feedback_status
FROM submissions
ORDER BY student_id, assignment_id;