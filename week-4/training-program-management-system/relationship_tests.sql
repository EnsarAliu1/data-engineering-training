--Part 3 - Relationship and Constraint Tests

--Test that the database rejects bad data.
INSERT INTO students
(first_name, last_name, email, city, created_at)
VALUES
(NULL, 'Smith', 'test@email.com', 'Pristina', '2026-07-30');
--MySQL said: Documentation - Column 'first_name' cannot be null


--Try inserting a duplicate student email.
INSERT INTO students (first_name, last_name, email, city, created_at) VALUES
('Ardit','Berisha','ardit.berisha@gmail.com','Prishtina','2025-01-05')
--Duplicate entry 'ardit.berisha@gmail.com' for key 'email'


--Try inserting duplicate attendance for the same student and session.
INSERT INTO attendance (session_id, student_id, status, notes) VALUES
(1,1,'present',NULL)
--Duplicate entry '1-1' for key 'uq_session_student_attendance'


--Try inserting duplicate submission for the same student and assignment.
INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES
(1,1,'https://github.com/ardit/portfolio','2025-02-14',95,'Excellent work')
--Duplicate entry '1-1' for key 'uq_assignment_student_submission'


--Try inserting a score above 100.
INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES
(2,8,'https://github.com/ardit/portfolio','2025-02-14',110,'Excellent work')
--CONSTRAINT `submissions.score` failed for `de_utc_db`.`submissions`


--Try inserting a negative score.
INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES
(2,8,'https://github.com/ardit/portfolio','2025-02-14',-110,'Excellent work')
--CONSTRAINT `submissions.score` failed for `de_utc_db`.`submissions`


--Try inserting an attendance status that is not allowed.
INSERT INTO attendance (session_id, student_id, status, notes) VALUES
(10,10,'here',NULL)
--CONSTRAINT `attendance.status` failed for `de_utc_db`.`attendance`


--Try connecting a submission to a student or assignment that does not exist.
INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES
(998,999,'https://github.com/ardit/portfolio','2025-02-14',95,'Excellent work')
--Cannot add or update a child row: a foreign key constraint fails (`de_utc_db`.`submissions`, CONSTRAINT `submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`))


--Try connecting attendance to a session that does not exist.
INSERT INTO attendance (session_id, student_id, status, notes) VALUES
(999,1,'present',NULL)
--Cannot add or update a child row: a foreign key constraint fails (`de_utc_db`.`attendance`, CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`session_id`))