--Run the final view and take a screenshot.

create VIEW final_student_progress_view as 
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    students.city,
    students.phone_number,
    submissions.github_username,
    enrollments.status AS enrollment_status,
    assignments.title AS assignment_title,
    submissions.score AS submissions_score,
    CASE
        WHEN submissions.score >= 90 THEN 'Excellent'
        WHEN submissions.score >= 75 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance_level,
    COALESCE(submissions.feedback, 'No feedback yet') AS feedback_status,
    submissions.review_status,
    attendance.status AS attendance_status
FROM
	students
JOIN enrollments
	ON enrollments.student_id = students.student_id

LEFT JOIN submissions
	ON submissions.student_id = students.student_id

LEFT JOIN assignments
	ON assignments.assignment_id = submissions.assignment_id

LEFT JOIN attendance
	ON attendance.student_id = students.student_id;
    
SELECT * FROM final_student_progress_view;
    
    
    
    
    