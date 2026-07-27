SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    sub.submission_id,
    sub.assignment_id,
    sub.score
FROM students s
LEFT JOIN submissions sub
    ON s.student_id = sub.student_id;



SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    a.title AS assignment_title
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN assignments a
    ON e.program_id = a.program_id
LEFT JOIN submissions sub
    ON s.student_id = sub.student_id
    AND a.assignment_id = sub.assignment_id
WHERE a.assignment_id = 1
  AND sub.submission_id IS NULL;



SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    sub.assignment_id,
    sub.score,
    sub.feedback
FROM students s
JOIN submissions sub
    ON s.student_id = sub.student_id
WHERE sub.feedback IS NULL;



SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    e.program_id,
    att.session_id,
    att.status
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
LEFT JOIN attendance att
    ON s.student_id = att.student_id
    AND att.session_id = 3
WHERE e.status = 'active'
  AND att.attendance_id IS NULL;



SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    ses.session_id,
    ses.session_title
FROM students s
CROSS JOIN sessions ses
LEFT JOIN attendance att
    ON s.student_id = att.student_id
    AND ses.session_id = att.session_id
WHERE att.attendance_id IS NULL;


