--student_profile_view - show student name, city, email, phone number, GitHub username, enrollment status.

CREATE VIEW student_profile_view as 
SELECT
	students.first_name,
    students.last_name,
    students.city,
    students.email,
    students.phone_number,
    submissions.github_username,
    enrollments.status
FROM
	students
JOIN enrollments 
	ON enrollments.student_id = students.student_id
JOIN submissions
	ON submissions.student_id = students.student_id
GROUP BY students.email;
    
SELECT * FROM student_profile_view;

--student_submission_report - show student, assignment, score, feedback, review status.
CREATE VIEW student_submission_view as 
SELECT 
	students.student_id,
    students.first_name,
    assignments.assignment_id,
    assignments.program_id,
    assignments.title,
    submissions.score,
    submissions.feedback,
    submissions.review_status
FROM
	students
JOIN submissions
	ON submissions.student_id = students.student_id
JOIN assignments
	ON submissions.assignment_id = assignments.assignment_id;
    
SELECT * FROM student_submission_view;


--attendance_summary_view - show student, session number, topic, attendance status, notes.
CREATE VIEW attendance_summary_view AS 
SELECT
	students.student_id,
    students.first_name,
    sessions.session_number,
    sessions.topic,
    attendance.status,
    attendance.notes
FROM 
	students
JOIN attendance 
	ON attendance.student_id = students.student_id
JOIN sessions
	ON attendance.session_id = sessions.session_id;
    
    
SELECT * FROM attendance_summary_view;

--missing_feedback_view - show submissions where feedback is NULL or review_status is not reviewed.
CREATE VIEW missing_feedback_view as 
SELECT
	submissions.submission_id,
    submissions.feedback,
    submissions.review_status
FROM
	submissions
WHERE submissions.feedback is NULL OR review_status = 'not reviewed';

SELECT * FROM missing_feedback_view;


--student_performance_view - show student, score, and CASE WHEN performance level.
CREATE VIEW student_performance_view as 
SELECT
	students.*,
    submissions.score,
    CASE
    	WHEn submissions.score > 90 THEN 'Excellent'
        WHEN submissions.score >= 75 THEN 'Good'
        WHEn submissions.score >= 60 THEN 'Needs Improvement'
        ELSE 'At Risk'
    End as performance_level
FROM
	students
JOIN submissions
	on submissions.student_id = students.student_id;
    
SELECT * FROM student_performance_view;


--missing_submission_view - show enrolled students who did not submit a specific assignment using LEFT JOIN logic.
create VIEW missing_submission_view as 
SELECT
	students.student_id,
    students.first_name,
    students.last_name,
    enrollments.enrollment_id,
    enrollments.status,
    submissions.assignment_id
FROM
	students
JOIN enrollments
	on enrollments.student_id = students.student_id
left JOIN submissions
	on submissions.student_id = students.student_id
WHERE submissions.submission_id is NULL;


SELECT * FROM missing_submission_view;