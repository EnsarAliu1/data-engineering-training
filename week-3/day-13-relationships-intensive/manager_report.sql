-- Which courses have the most enrollments?
SELECT
    courses.course_id,
    courses.course_name,
    COUNT(enrollments.student_id) AS student_count
FROM enrollments
JOIN courses
    ON enrollments.course_id = courses.course_id
GROUP BY 
    courses.course_id,
    courses.course_name
ORDER BY student_count DESC;
/*
Business Action:
Identify top-performing courses. Allocate marketing budget and teaching assistants to these high-demand classes immediately to scale growth.
*/


--Which students are active in more than one course?
SELECT
    students.student_id,
    students.full_name,
    COUNT(enrollments.course_id) AS course_count
FROM students
JOIN enrollments
    ON students.student_id = enrollments.student_id
GROUP BY
    students.student_id,
    students.full_name
HAVING COUNT(enrollments.course_id) > 1;

/*
Business Action:
Identify "power users" taking multiple courses. Target this segment for testimonials and beta-testing. If numbers are low, introduce course bundles to drive cross-selling.
*/


--Which course has the strongest average attendance?
SELECT
	courses.course_id,
    courses.course_name,
	AVG(attendance.minutes_attended) as average_attendacnce
FROM
	attendance
JOIN enrollments
	On attendance.enrollment_id = enrollments.enrollment_id
JOIN courses
	ON enrollments.course_id = courses.course_id
GROUP BY
	courses.course_id;

/*
Business Action:
Track highest attendance to isolate successful teaching methods. Interview top instructors and standardize their engagement tactics across all other courses.
*/



--Which course has the weakest assignment completion?
SELECT
	*
FROM
	assignments
LEFT JOIN submissions
	ON submissions.assignment_id = assignments.assignment_id
ORDER BY submissions.score ASC;

/*
Business Action:
Flag courses with low completion rates. Intervene by offering tutoring or simplifying the curriculum to prevent high dropout rates.
*/


--Which students need attention because of missing/late submissions?
SELECT
	submissions.submission_id,
    students.student_id,
    students.full_name,
    courses.course_name,
    submissions.status
FROM
	submissions
JOIN students
	ON submissions.student_id =  students.student_id
JOIN assignments
	ON submissions.assignment_id = assignments.assignment_id
JOIN courses
	ON assignments.course_id = courses.course_id
WHERE submissions.status IN ('missing' , 'late')
GROUP BY
	students.student_id,
    courses.course_id;

/*
Business Action:
Deploy student success teams to contact these at-risk students within 48 hours. Offer extensions or support to protect overall retention rates.
*/


--Which instructor is responsible for the highest number of active enrollments?
SELECT
    instructors.instructor_id,
    instructors.full_name,
    COUNT(enrollments.student_id) AS student_count
FROM enrollments
JOIN courses
    ON enrollments.course_id = courses.course_id
JOIN instructors
    ON courses.instructor_id = instructors.instructor_id
WHERE enrollments.status = 'active'
GROUP BY 
    instructors.instructor_id,
    instructors.full_name
ORDER BY student_count DESC
LIMIT 1;

/*
Business Action:
Identify highest-impact instructors. Use this data to justify bonuses, performance reviews, and assign them as mentors to underperforming staff.
*/


--Create one final combined report with: student_name, course_name, instructor_name, enrollment_status, total_sessions, attended_sessions, total_minutes, average_score.
SELECT
    students.full_name AS student_name,
    courses.course_name,
    instructors.full_name AS instructor_name,
    enrollments.status AS enrollment_status,
    COUNT(attendance.attendance_id) AS total_sessions,
    SUM(attendance.attended) AS attended_sessions,
    SUM(attendance.minutes_attended) AS total_minutes,
    AVG(submissions.score) AS average_score
FROM enrollments

JOIN students
    ON enrollments.student_id = students.student_id

JOIN courses
    ON enrollments.course_id = courses.course_id

JOIN instructors
    ON courses.instructor_id = instructors.instructor_id

LEFT JOIN attendance
    ON enrollments.enrollment_id = attendance.enrollment_id

LEFT JOIN assignments
    ON courses.course_id = assignments.course_id

LEFT JOIN submissions
    ON assignments.assignment_id = submissions.assignment_id
    AND students.student_id = submissions.student_id

GROUP BY
    students.full_name,
    courses.course_name,
    instructors.full_name,
    enrollments.status;

/*
Business Action:
Review this 360-degree dashboard weekly. Cross-reference attendance with average scores to make data-informed, strategic decisions across the entire Tech Hub.
*/