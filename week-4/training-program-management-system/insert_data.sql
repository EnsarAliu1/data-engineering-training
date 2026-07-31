--Part 2 - Insert Realistic Data

--STUDENTS (30)

INSERT INTO students (first_name, last_name, email, city, created_at) VALUES
('Ardit','Berisha','ardit.berisha@gmail.com','Prishtina','2025-01-05'),
('Sara','Krasniqi','sara.krasniqi@gmail.com','Prizren','2025-01-06'),
('Albin','Gashi','albin.gashi@gmail.com','Peja','2025-01-07'),
('Diona','Hoxha','diona.hoxha@gmail.com','Gjilan','2025-01-08'),
('Leon','Mustafa','leon.mustafa@gmail.com','Ferizaj','2025-01-09'),
('Era','Shala','era.shala@gmail.com','Mitrovica','2025-01-10'),
('Blend','Rexhepi','blend.rexhepi@gmail.com','Vushtrri','2025-01-11'),
('Anisa','Hasani','anisa.hasani@gmail.com','Gjakova','2025-01-12'),
('Valon','Bytyqi','valon.bytyqi@gmail.com','Podujeva','2025-01-13'),
('Ariana','Morina','ariana.morina@gmail.com','Lipjan','2025-01-14'),
('Erion','Tahiri','erion.tahiri@gmail.com','Prishtina','2025-01-15'),
('Besa','Kelmendi','besa.kelmendi@gmail.com','Peja','2025-01-16'),
('Fisnik','Mehmeti','fisnik.mehmeti@gmail.com','Prizren','2025-01-17'),
('Linda','Ramadani','linda.ramadani@gmail.com','Ferizaj','2025-01-18'),
('Kushtrim','Zeqiri','kushtrim.zeqiri@gmail.com','Gjilan','2025-01-19'),
('Albina','Osmani','albina.osmani@gmail.com','Mitrovica','2025-01-20'),
('Granit','Dervishi','granit.dervishi@gmail.com','Vushtrri','2025-01-21'),
('Elira','Pllana','elira.pllana@gmail.com','Prishtina','2025-01-22'),
('Jeton','Sadiku','jeton.sadiku@gmail.com','Peja','2025-01-23'),
('Megi','Kryeziu','megi.kryeziu@gmail.com','Prizren','2025-01-24'),
('Arbnor','Syla','arbnor.syla@gmail.com','Gjilan','2025-01-25'),
('Rina','Qerimi','rina.qerimi@gmail.com','Lipjan','2025-01-26'),
('Liridon','Beqiri','liridon.beqiri@gmail.com','Podujeva','2025-01-27'),
('Donika','Halimi','donika.halimi@gmail.com','Gjakova','2025-01-28'),
('Besnik','Ibrahimi','besnik.ibrahimi@gmail.com','Ferizaj','2025-01-29'),
('Yllka','Ajdini','yllka.ajdini@gmail.com','Prishtina','2025-01-30'),
('Korab','Miftari','korab.miftari@gmail.com','Mitrovica','2025-01-31'),
('Arta','Veliu','arta.veliu@gmail.com','Peja','2025-02-01'),
('Gent','Haziri','gent.haziri@gmail.com','Gjilan','2025-02-02'),
('Diellza','Bunjaku','diellza.bunjaku@gmail.com','Prizren','2025-02-03');


--PROGRAMS(5)

INSERT INTO programs (program_name, program_type, start_date, end_date, status) VALUES
('Full Stack Web Development','beginner','2025-02-10','2025-05-30','active'),
('Backend Development with Java','intermediate','2025-03-01','2025-06-30','active'),
('Data Analytics with Python','advanced','2025-04-01','2025-07-31','planned'),
('Frontend React Bootcamp','intermediate','2025-05-05','2025-08-20','active'),
('Database Administration','advanced','2025-06-01','2025-09-15','planned');

--PERSONEL(12)

INSERT INTO personnel (personnel_full_name, role) VALUES
('Arian Kelmendi','instructor'),
('Besarta Gashi','instructor'),
('Valmir Berisha','instructor'),
('Albulena Shala','mentor'),
('Dren Hoxha','mentor'),
('Erza Mustafa','mentor'),
('Fisnik Kryeziu','support'),
('Linda Gashi','support'),
('Arbër Rexhepi','support'),
('Gentiana Berisha','mentor'),
('Korab Zeqiri','instructor'),
('Mirlinda Osmani','support');


--PROGRAM PERSONEL (20)
INSERT INTO program_personnel (program_id, personnel_id) VALUES
(1,1),
(1,4),
(1,7),
(1,10),

(2,2),
(2,5),
(2,8),
(2,11),

(3,3),
(3,6),
(3,9),
(3,10),

(4,2),
(4,4),
(4,12),
(4,11),

(5,1),
(5,5),
(5,8),
(5,9);


--ENROLLMENTS (40)

INSERT INTO enrollments (student_id, program_id, enrollment_date, status) VALUES

-- Full Stack Web Development
(1,1,'2025-02-05','active'),
(2,1,'2025-02-05','active'),
(3,1,'2025-02-06','active'),
(4,1,'2025-02-06','paused'),
(5,1,'2025-02-07','active'),
(6,1,'2025-02-07','dropped'),
(7,1,'2025-02-08','active'),
(8,1,'2025-02-08','active'),
(9,1,'2025-02-09','active'),
(10,1,'2025-02-09','paused'),

-- Backend Development
(11,2,'2025-02-25','active'),
(12,2,'2025-02-25','active'),
(13,2,'2025-02-26','active'),
(14,2,'2025-02-26','active'),
(15,2,'2025-02-27','dropped'),
(16,2,'2025-02-27','active'),
(17,2,'2025-02-28','paused'),
(18,2,'2025-02-28','active'),

-- Data Analytics
(19,3,'2025-03-20','active'),
(20,3,'2025-03-20','active'),
(21,3,'2025-03-21','active'),
(22,3,'2025-03-21','paused'),
(23,3,'2025-03-22','active'),
(24,3,'2025-03-22','active'),

-- Frontend React
(25,4,'2025-04-25','active'),
(26,4,'2025-04-25','active'),
(27,4,'2025-04-26','active'),
(28,4,'2025-04-26','active'),
(29,4,'2025-04-27','paused'),
(30,4,'2025-04-27','active'),

-- Students enrolled in multiple programs
(3,2,'2025-02-28','active'),
(5,2,'2025-03-01','active'),
(8,4,'2025-04-28','active'),
(11,5,'2025-05-25','active'),
(18,5,'2025-05-25','active'),
(22,5,'2025-05-26','paused'),
(27,5,'2025-05-27','active'),
(1,4,'2025-04-29','active'),
(9,2,'2025-03-01','active'),
(14,5,'2025-05-28','active');

--SESSIONS(25)

INSERT INTO sessions (program_id, session_title, session_date, session_number, topic) VALUES

-- Program 1: Full Stack Web Development
(1,'Introduction to Web Development','2025-02-10',1,'HTML Basics'),
(1,'Working with CSS','2025-02-12',2,'CSS Fundamentals'),
(1,'Responsive Design','2025-02-14',3,'Flexbox & Grid'),
(1,'JavaScript Basics','2025-02-17',4,'Variables and Functions'),
(1,'DOM Manipulation','2025-02-19',5,'DOM Events'),

-- Program 2: Backend Development with Java
(2,'Java Introduction','2025-03-01',1,'Java Syntax'),
(2,'Object Oriented Programming','2025-03-03',2,'Classes and Objects'),
(2,'Collections Framework','2025-03-05',3,'Lists and Maps'),
(2,'Exception Handling','2025-03-07',4,'Try Catch'),
(2,'JDBC Basics','2025-03-10',5,'Database Connectivity'),

-- Program 3: Data Analytics with Python
(3,'Python Refresher','2025-04-01',1,'Python Basics'),
(3,'NumPy','2025-04-03',2,'Arrays'),
(3,'Pandas','2025-04-05',3,'DataFrames'),
(3,'Visualization','2025-04-08',4,'Matplotlib'),
(3,'Data Cleaning','2025-04-10',5,'Missing Values'),

-- Program 4: Frontend React
(4,'React Introduction','2025-05-05',1,'React Basics'),
(4,'Components','2025-05-07',2,'Functional Components'),
(4,'Props and State','2025-05-09',3,'State Management'),
(4,'React Hooks','2025-05-12',4,'useState & useEffect'),
(4,'Routing','2025-05-14',5,'React Router'),

-- Program 5: Database Administration
(5,'Database Fundamentals','2025-06-01',1,'Relational Databases'),
(5,'SQL Basics','2025-06-03',2,'SELECT Queries'),
(5,'JOIN Operations','2025-06-05',3,'INNER and LEFT JOIN'),
(5,'Indexes','2025-06-08',4,'Performance'),
(5,'Stored Procedures','2025-06-10',5,'Procedures');


--ASSIGNMENTS(20)

INSERT INTO assignments (program_id, title, day_number, due_date, max_points) VALUES

-- Program 1
(1,'Build Personal Portfolio',3,'2025-02-15',100),
(1,'Responsive Landing Page',5,'2025-02-20',100),
(1,'JavaScript Calculator',8,'2025-02-26',100),
(1,'DOM Todo App',10,'2025-03-02',100),

-- Program 2
(2,'Java Console Project',3,'2025-03-06',100),
(2,'OOP Banking System',6,'2025-03-13',100),
(2,'Collections Challenge',8,'2025-03-17',100),
(2,'JDBC CRUD Application',10,'2025-03-22',100),

-- Program 3
(3,'Python Exercises',2,'2025-04-04',100),
(3,'NumPy Practice',4,'2025-04-08',100),
(3,'Pandas Analysis',7,'2025-04-14',100),
(3,'Visualization Dashboard',10,'2025-04-20',100),

-- Program 4
(4,'React Profile App',2,'2025-05-08',100),
(4,'Movie Search App',5,'2025-05-15',100),
(4,'Weather Application',8,'2025-05-22',100),
(4,'React Final Project',12,'2025-05-30',100),

-- Program 5
(5,'SQL SELECT Practice',2,'2025-06-05',100),
(5,'JOIN Exercises',5,'2025-06-12',100),
(5,'Normalization Task',8,'2025-06-18',100),
(5,'Database Final Project',12,'2025-06-28',100);


--ATTENDANCE(60)
INSERT INTO attendance (session_id, student_id, status, notes) VALUES

-- Session 1
(1,1,'present',NULL),
(1,2,'present',NULL),
(1,3,'late','Traffic'),
(1,4,'present',NULL),
(1,5,'absent','Sick'),
(1,7,'present',NULL),

-- Session 2
(2,1,'present',NULL),
(2,2,'late','Late bus'),
(2,3,'present',NULL),
(2,4,'excused','Medical appointment'),
(2,5,'present',NULL),
(2,7,'present',NULL),

-- Session 3
(3,1,'present',NULL),
(3,2,'present',NULL),
(3,3,'present',NULL),
(3,4,'absent',NULL),
(3,5,'present',NULL),
(3,7,'late','Traffic'),

-- Session 4
(4,1,'present',NULL),
(4,2,'present',NULL),
(4,3,'absent','Family reasons'),
(4,4,'present',NULL),
(4,5,'late',NULL),
(4,7,'present',NULL),

-- Session 5
(5,1,'present',NULL),
(5,2,'present',NULL),
(5,3,'present',NULL),
(5,4,'present',NULL),
(5,5,'present',NULL),
(5,7,'excused','Doctor'),

-- Java Program
(6,11,'present',NULL),
(6,12,'late','Traffic'),
(6,13,'present',NULL),
(6,14,'present',NULL),
(6,16,'absent','Sick'),
(6,18,'present',NULL),

(7,11,'present',NULL),
(7,12,'present',NULL),
(7,13,'late',NULL),
(7,14,'present',NULL),
(7,16,'present',NULL),
(7,18,'present',NULL),

(8,11,'present',NULL),
(8,12,'present',NULL),
(8,13,'present',NULL),
(8,14,'absent',NULL),
(8,16,'present',NULL),
(8,18,'late','Late arrival'),

(9,11,'present',NULL),
(9,12,'excused','Personal reason'),
(9,13,'present',NULL),
(9,14,'present',NULL),
(9,16,'present',NULL),
(9,18,'present',NULL),

(10,11,'present',NULL),
(10,12,'present',NULL),
(10,13,'present',NULL),
(10,14,'late',NULL),
(10,16,'present',NULL),
(10,18,'present',NULL);



--SUBMISSIONS(58)

INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES

-- Assignment 1
(1,1,'https://github.com/ardit/portfolio','2025-02-14',95,'Excellent work'),
(1,2,'https://github.com/sara/portfolio','2025-02-15',87,'Good job'),
(1,3,'https://github.com/albin/portfolio','2025-02-15',72,NULL),
(1,4,'https://github.com/diona/portfolio','2025-02-15',64,'Needs improvement'),
(1,7,'https://github.com/blend/portfolio','2025-02-15',98,'Outstanding'),

-- student 5 missing submission
-- student 6 dropped

-- Assignment 2
(2,1,'https://github.com/ardit/landing','2025-02-20',91,'Nice design'),
(2,2,'https://github.com/sara/landing','2025-02-20',78,NULL),
(2,3,'https://github.com/albin/landing','2025-02-20',69,'Improve responsiveness'),
(2,5,'https://github.com/leon/landing','2025-02-20',83,'Good'),
(2,7,'https://github.com/blend/landing','2025-02-19',99,'Excellent'),

-- Assignment 3
(3,1,'https://github.com/ardit/calculator','2025-02-26',100,'Perfect'),
(3,2,'https://github.com/sara/calculator','2025-02-26',88,'Well done'),
(3,3,'https://github.com/albin/calculator','2025-02-26',55,'Logic errors'),
(3,4,'https://github.com/diona/calculator','2025-02-26',42,'Incomplete'),
(3,7,'https://github.com/blend/calculator','2025-02-26',94,NULL),

-- Assignment 4
(4,1,'https://github.com/ardit/todo','2025-03-02',97,'Great'),
(4,2,'https://github.com/sara/todo','2025-03-02',84,NULL),
(4,5,'https://github.com/leon/todo','2025-03-02',76,'Good'),
(4,7,'https://github.com/blend/todo','2025-03-02',93,'Excellent'),

-- Assignment 5
(5,11,'https://github.com/erion/java1','2025-03-06',92,'Good OOP'),
(5,12,'https://github.com/besa/java1','2025-03-06',74,NULL),
(5,13,'https://github.com/fisnik/java1','2025-03-06',63,'Needs work'),
(5,14,'https://github.com/linda/java1','2025-03-06',87,'Very good'),
(5,16,'https://github.com/albina/java1','2025-03-06',96,'Excellent'),

-- Assignment 6
(6,11,'https://github.com/erion/bank','2025-03-13',95,'Excellent'),
(6,12,'https://github.com/besa/bank','2025-03-13',68,NULL),
(6,13,'https://github.com/fisnik/bank','2025-03-13',49,'Missing features'),
(6,14,'https://github.com/linda/bank','2025-03-13',82,'Good'),
(6,18,'https://github.com/elira/bank','2025-03-13',90,'Nice'),

-- Assignment 7
(7,11,'https://github.com/erion/collections','2025-03-17',88,NULL),
(7,12,'https://github.com/besa/collections','2025-03-17',71,'Good'),
(7,13,'https://github.com/fisnik/collections','2025-03-17',57,NULL),
(7,16,'https://github.com/albina/collections','2025-03-17',98,'Excellent'),

-- Assignment 8
(8,11,'https://github.com/erion/jdbc','2025-03-22',94,'Excellent'),
(8,12,'https://github.com/besa/jdbc','2025-03-22',81,NULL),
(8,13,'https://github.com/fisnik/jdbc','2025-03-22',73,'Good'),
(8,14,'https://github.com/linda/jdbc','2025-03-22',65,'Needs optimization'),

-- Assignment 13
(13,25,'https://github.com/besnik/react1','2025-05-08',91,'Good'),
(13,26,'https://github.com/yllka/react1','2025-05-08',87,NULL),
(13,27,'https://github.com/korab/react1','2025-05-08',75,'Good'),
(13,28,'https://github.com/arta/react1','2025-05-08',59,'Improve components'),
(13,30,'https://github.com/diellza/react1','2025-05-08',97,'Excellent'),

-- Assignment 14
(14,25,'https://github.com/besnik/movie','2025-05-15',90,NULL),
(14,26,'https://github.com/yllka/movie','2025-05-15',83,'Nice'),
(14,27,'https://github.com/korab/movie','2025-05-15',71,NULL),
(14,30,'https://github.com/diellza/movie','2025-05-15',95,'Very good'),

-- Assignment 15
(15,25,'https://github.com/besnik/weather','2025-05-22',94,'Excellent'),
(15,26,'https://github.com/yllka/weather','2025-05-22',88,NULL),
(15,28,'https://github.com/arta/weather','2025-05-22',62,'Needs work'),
(15,30,'https://github.com/diellza/weather','2025-05-22',99,'Outstanding'),

-- Assignment 17
(17,11,'https://github.com/erion/sql','2025-06-05',100,'Perfect'),
(17,18,'https://github.com/elira/sql','2025-06-05',92,'Excellent'),
(17,22,'https://github.com/rina/sql','2025-06-05',81,NULL),
(17,27,'https://github.com/korab/sql','2025-06-05',74,'Good'),
(17,14,'https://github.com/linda/sql','2025-06-05',66,NULL),

-- Assignment 18
(18,11,'https://github.com/erion/join','2025-06-12',95,'Excellent'),
(18,18,'https://github.com/elira/join','2025-06-12',89,NULL),
(18,27,'https://github.com/korab/join','2025-06-12',78,'Good'),
(18,14,'https://github.com/linda/join','2025-06-12',61,'Needs practice');