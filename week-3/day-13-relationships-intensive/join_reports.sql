--Show all students with their city and email.
SELECT
	students.city,
    students.email
FROM
	students;

--Show all courses with instructor name and specialization.
SELECT
	courses.course_name,
    instructors.full_name,
    instructors.specialization
FROM
	courses
JOIN instructors
	ON courses.instructor_id = instructors.instructor_id;


--Show all assignments with course name and due date.
SELECT
	assignments.assignment_id,
    courses.course_name,
    assignments.due_date
FROM
	assignments
JOIN courses
	ON assignments.course_id = courses.course_id;


-- Show all enrollments with student name, course name, enrollment date, and status.
SELECT
	enrollments.enrollment_id,
    students.full_name,
    courses.course_name,
    enrollments.enrollment_date,
    enrollments.status
FROM
	enrollments
JOIN courses
	ON enrollments.course_id = courses.course_id
JOIN students
	ON enrollments.student_id = students.student_id;


--Show only active enrollments.
SELECT
	enrollments.enrollment_id,
    students.full_name,
    courses.course_name,
    enrollments.enrollment_date,
    enrollments.status
FROM
	enrollments
JOIN courses
	ON enrollments.course_id = courses.course_id
JOIN students
	ON enrollments.student_id = students.student_id
WHERE enrollments.status = 'active';


--Show submissions with student name, assignment title, course name, score, and status.
SELECT
	submissions.submission_id,
    students.full_name,
    assignments.title,
    courses.course_name,
    submissions.score,
    submissions.status
FROM
	submissions
JOIN students
	on submissions.student_id = students.student_id
JOIN assignments
	ON submissions.assignment_id = assignments.assignment_id
JOIN courses
	On assignments.course_id = courses.course_id;


--Count students enrolled in each course.
SELECT
    courses.course_id,
    courses.course_name,
    COUNT(enrollments.student_id) AS student_count
FROM enrollments
JOIN courses
    ON enrollments.course_id = courses.course_id
GROUP BY 
    courses.course_id,
    courses.course_name;


--Show students enrolled in more than one course.
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


--Show average score by course.
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


--Show missing or late submissions with student and course context.
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


--Use LEFT JOIN to show students with no enrollments.
SELECT
	*
FROM
	students
LEFT JOIN enrollments
	on enrollments.student_id = students.student_id
WHERE enrollments.enrollment_id IS NULL

--Use LEFT JOIN to show assignments with no submissions.
SELECT
	*
FROM
	assignments
LEFT JOIN submissions
	ON submissions.assignment_id = assignments.assignment_id
WHERE submissions.submitted_at IS NULL;
