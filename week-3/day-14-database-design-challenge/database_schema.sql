--Part 2 - Build the Database Schema

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS students;


CREATE TABLE students(
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_fullName TEXT NOT NULL,
    student_email TEXT UNIQUE NOT NULL,
    student_city TEXT NOT NULL
);


CREATE TABLE instructors(
    instructor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    instructor_fullName TEXT NOT NULL,
    specialization TEXT NOT NULL
);


CREATE TABLE programs(
    program_id INTEGER PRIMARY KEY AUTOINCREMENT,
    program_name TEXT NOT NULL,
    instructor_id INTEGER NOT NULL,
    level TEXT NOT NULL CHECK(level IN ('Beginner','Intermediate','Advanced')),
    price DECIMAL(10,2) NOT NULL CHECK(price > 0),
    UNIQUE(program_name, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);


CREATE TABLE enrollments(
    enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    program_id INTEGER NOT NULL,
    enrollment_date DATE,
    status TEXT NOT NULL CHECK(status IN ('active','completed','dropped')),
    UNIQUE(student_id, program_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
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


CREATE TABLE payments(
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    enrollment_id INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    payment_method TEXT NOT NULL CHECK(payment_method IN ('Cash','Bank Transfer','Card')),
    status TEXT NOT NULL CHECK(status IN ('Pending','Paid','Refunded')),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);