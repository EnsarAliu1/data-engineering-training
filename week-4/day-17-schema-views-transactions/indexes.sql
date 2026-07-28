--Create an index on submissions.student_id.
CREATE INDEX idx_submissions_student_id
ON submissions(student_id);

--Create an index on submissions.assignment_id.
CREATE INDEX idx_submissions_assignment_id
ON submissions(assignment_id);

--Create an index on attendance.session_id.
CREATE INDEX idx_attendance_session_id
on attendance(session_id);

--Create an index on attendance.student_id.
CREATE INDEX idx_attendance_student_id
on attendance(student_id);

--Create an index on enrollments.program_id.
CREATE INDEX idx_entrollments_program_id
on enrollments(program_id);