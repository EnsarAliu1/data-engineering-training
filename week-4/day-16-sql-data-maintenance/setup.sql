PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    city TEXT NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE programs (
    program_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    program_name TEXT NOT NULL,
    program_type TEXT NOT NULL
        CHECK (program_type IN ('beginner', 'intermediate', 'advanced')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
        CHECK (end_date > start_date),
    status TEXT NOT NULL
        CHECK (status IN ('active', 'planned'))
);

CREATE TABLE enrollments (
    enrollment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    enrollment_date DATE NOT NULL,
    status TEXT NOT NULL
        CHECK (status IN ('active', 'paused', 'cancelled')),
    UNIQUE (student_id, program_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

CREATE TABLE sessions (
    session_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    program_id INTEGER NOT NULL,
    session_title TEXT NOT NULL,
    session_date DATE NOT NULL,
    session_number INTEGER NOT NULL
        CHECK (session_number > 0),
    topic TEXT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    status TEXT NOT NULL
        CHECK (status IN ('present', 'absent', 'late', 'excused')),
    notes TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE assignments (
    assignment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    program_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    day_number INTEGER NOT NULL
        CHECK (day_number > 0),
    due_date DATE NOT NULL,
    max_points INTEGER NOT NULL
        CHECK (max_points > 0),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);

CREATE TABLE submissions (
    submission_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    assignment_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    github_link TEXT,
    submitted_at DATE NOT NULL,
    score INTEGER NOT NULL
        CHECK (score >= 0),
    feedback TEXT,
    UNIQUE (assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (first_name, last_name, email, city, created_at)
VALUES
('Ardit', 'Berisha', 'ardit@gmail.com', 'Pristina', '2026-07-01'),
('Elira', 'Gashi', 'elira@gmail.com', 'Prizren', '2026-07-02'),
('Blerim', 'Krasniqi', 'blerim@gmail.com', 'Peja', '2026-07-03'),
('Sara', 'Mustafa', 'sara@gmail.com', 'Gjilan', '2026-07-04'),
('Dren', 'Shala', 'dren@gmail.com', 'Ferizaj', '2026-07-05'),
('Ariana', 'Hoxha', 'ariana@gmail.com', 'Mitrovica', '2026-07-06');

INSERT INTO programs
(program_name, program_type, start_date, end_date, status)
VALUES
('Basic Programming', 'beginner', '2026-08-01', '2026-09-30', 'active');

INSERT INTO sessions
(program_id, session_title, session_date, session_number, topic)
VALUES
(1, 'Session 1', '2026-08-01', 1, 'Introduction to SQL'),
(1, 'Session 2', '2026-08-03', 2, 'CREATE TABLE'),
(1, 'Session 3', '2026-08-05', 3, 'INSERT INTO');

INSERT INTO assignments
(program_id, title, day_number, due_date, max_points)
VALUES
(1, 'Assignment 1', 1, '2026-08-07', 100),
(1, 'Assignment 2', 3, '2026-08-10', 100),
(1, 'Assignment 3', 5, '2026-08-15', 100);

INSERT INTO enrollments
(student_id, program_id, enrollment_date, status)
VALUES
(1,1,'2026-07-25','cancelled'),
(2,1,'2026-07-25','active'),
(3,1,'2026-07-25','active'),
(4,1,'2026-07-25','active'),
(5,1,'2026-07-25','paused'),
(6,1,'2026-07-25','active');

INSERT INTO attendance
(session_id, student_id, status, notes)
VALUES
(1,1,'present',NULL),
(1,2,'present','On time'),
(1,3,'late','Arrived 10 minutes late'),
(1,4,'absent','Sick'),
(1,5,'present',NULL),
(1,6,'excused','Approved leave'),

(2,1,'present',NULL),
(2,2,'present',NULL),
(2,3,'present',NULL),
(2,4,'late','Late arrival'),
(2,5,'absent','Did not attend'),
(2,6,'present',NULL),

(3,1,'present',NULL),
(3,2,'present',NULL),
(3,3,'present',NULL),
(3,4,'present',NULL),
(3,5,'present',NULL),
(3,6,'absent','Did not participate');

INSERT INTO submissions
(assignment_id, student_id, github_link, submitted_at, score, feedback)
VALUES
(1,1,'https://github.com/ardit/d1','2026-08-06',95,'Excellent work'),
(1,2,'https://github.com/elira/d1','2026-08-06',88,NULL),
(1,3,'https://github.com/blerim/d1','2026-08-06',91,'Keep it up'),
(1,4,'https://github.com/sara/d1','2026-08-06',84,NULL),
(1,5,'https://github.com/dren/d1','2026-08-06',76,'Can be improved'),
(1,6,'https://github.com/ariana/d1','2026-08-06',98,'Excellent'),

(2,1,'https://github.com/ardit/d2','2026-08-09',94,NULL),
(2,2,'https://github.com/elira/d2','2026-08-09',86,'Good work'),
(2,3,'https://github.com/blerim/d2','2026-08-09',90,NULL),
(2,5,'https://github.com/dren/d2','2026-08-09',81,'Good'),
(2,6,'https://github.com/ariana/d2','2026-08-09',97,'Outstanding'),

(3,1,'https://github.com/ardit/d3','2026-08-14',100,'Perfect'),
(3,2,'https://github.com/elira/d3','2026-08-14',89,NULL),
(3,3,'https://github.com/blerim/d3','2026-08-14',93,'Very good'),
(3,4,'https://github.com/sara/d3','2026-08-14',85,NULL),
(3,5,'https://github.com/dren/d3','2026-08-14',78,'Satisfactory'),
(3,6,'https://github.com/ariana/d3','2026-08-14',99,'Excellent work');