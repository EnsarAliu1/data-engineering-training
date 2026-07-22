PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS students;


CREATE TABLE students(
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    city TEXT NOT NULL
);


CREATE TABLE instructors(
    instructor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    specialization TEXT NOT NULL
);


CREATE TABLE courses(
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_name TEXT NOT NULL,
    instructor_id INTEGER NOT NULL,
    level TEXT NOT NULL CHECK(level IN ('Beginner','Intermediate','Advanced')),
    UNIQUE(course_name, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);


CREATE TABLE enrollments(
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE,
    status TEXT NOT NULL CHECK(status IN ('active','completed','dropped')),
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


CREATE TABLE attendance(
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    session_date DATE NOT NULL,
    attended INT NOT NULL CHECK(attended IN (0,1)),
    minutes_attended INT CHECK(minutes_attended >= 0),
    UNIQUE(enrollment_id, session_date),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);


CREATE TABLE assignments(
    assignment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    max_score INTEGER NOT NULL CHECK(max_score = 100),
    due_date DATE,
    UNIQUE(course_id, title),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);


CREATE TABLE submissions(
    submission_id INTEGER PRIMARY KEY AUTOINCREMENT,
    assignment_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    submitted_at DATE,
    score INTEGER NOT NULL CHECK(score BETWEEN 0 AND 100),
    status TEXT NOT NULL CHECK(status IN ('submitted','missing','late')),
    UNIQUE(assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
