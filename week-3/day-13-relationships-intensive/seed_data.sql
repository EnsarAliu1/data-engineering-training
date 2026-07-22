
-- STUDENTS

INSERT INTO students (full_name, email, city) VALUES
('Ardit Krasniqi','ardit@gmail.com','Prishtine'),
('Besa Hoxha','besa@gmail.com','Prizren'),
('Dren Gashi','dren@gmail.com','Peje'),
('Elira Berisha','elira@gmail.com','Gjilan'),
('Fisnik Shala','fisnik@gmail.com','Mitrovice'),
('Gentiana Kelmendi','gentiana@gmail.com','Ferizaj'),
('Ilir Rexha','ilir@gmail.com','Gjakove'),
('Leart Morina','leart@gmail.com','Podujeve');   -- No enrollment



-- INSTRUCTORS

INSERT INTO instructors (full_name,specialization) VALUES
('Arben Berisha','SQL'),
('Mimoza Gashi','Python'),
('Valon Krasniqi','Data Engineering');



-- COURSES

INSERT INTO courses (course_name,instructor_id,level) VALUES
('SQL Fundamentals',1,'Beginner'),
('Python Programming',2,'Beginner'),
('Databricks Essentials',3,'Intermediate'),
('PySpark for Data Engineering',3,'Advanced'),
('Data Modeling',1,'Intermediate');



-- ENROLLMENTS

INSERT INTO enrollments(student_id,course_id,enrollment_date,status) VALUES
(1,1,'2026-01-10','active'),
(1,2,'2026-01-10','completed'),
(2,1,'2026-01-11','active'),
(2,5,'2026-01-11','active'),
(3,2,'2026-01-12','completed'),
(3,3,'2026-01-12','active'),
(4,4,'2026-01-13','active'),
(4,5,'2026-01-13','completed'),
(5,3,'2026-01-14','active'),
(6,1,'2026-01-15','dropped'),
(6,2,'2026-01-15','active'),
(7,4,'2026-01-16','active');



-- ATTENDANCE

INSERT INTO attendance(enrollment_id,session_date,attended,minutes_attended) VALUES
(1,'2026-02-01',1,90),
(1,'2026-02-08',1,85),

(2,'2026-02-02',1,95),
(2,'2026-02-09',0,0),

(3,'2026-02-03',1,80),
(3,'2026-02-10',1,90),

(4,'2026-02-04',0,0),
(4,'2026-02-11',1,88),

(5,'2026-02-05',1,92),
(5,'2026-02-12',1,90),

(6,'2026-02-06',1,75),
(6,'2026-02-13',0,0),

(7,'2026-02-07',1,110),
(8,'2026-02-14',1,100),

(9,'2026-02-15',1,87),
(10,'2026-02-16',0,0),

(11,'2026-02-17',1,89),
(12,'2026-02-18',1,91);



-- ASSIGNMENTS

INSERT INTO assignments(course_id,title,max_score,due_date) VALUES
(1,'SQL Queries',100,'2026-03-01'),
(1,'SQL Joins',100,'2026-03-10'),
(2,'Python Basics',100,'2026-03-05'),
(3,'Databricks Notebook',100,'2026-03-15'),
(4,'PySpark ETL',100,'2026-03-20'),
(5,'ER Diagram',100,'2026-03-25');



-- SUBMISSIONS

INSERT INTO submissions(assignment_id,student_id,submitted_at,score,status) VALUES
(1,1,'2026-02-28',95,'submitted'),
(2,1,'2026-03-11',85,'late'),

(1,2,NULL,0,'missing'),
(6,2,'2026-03-24',91,'submitted'),

(3,3,'2026-03-04',97,'submitted'),
(4,3,'2026-03-16',80,'late'),

(5,4,'2026-03-19',89,'submitted'),
(6,4,NULL,0,'missing'),

(4,5,'2026-03-14',94,'submitted'),

(1,6,'2026-03-01',78,'submitted'),
(3,6,NULL,0,'missing'),

(5,7,'2026-03-21',88,'late');


--After every insert group, run SELECT * to verify the rows.
SELECT * FROM students;
SELECT * FROM instructors;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM attendance;
SELECT * FROM assignments;
SELECT * FROM submissions;