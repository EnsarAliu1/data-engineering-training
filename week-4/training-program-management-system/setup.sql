--Part 1 - Database Design

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS program_personnel;
DROP TABLE IF EXISTS personnel;
DROP TABLE IF EXISTS programs;
DROP TABLE IF EXISTS students;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE students (
    student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    created_at DATE NOT NULL
);

CREATE TABLE programs (
    program_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    program_type VARCHAR(20) NOT NULL
        CHECK (program_type IN ('beginner','intermediate','advanced')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
        CHECK (end_date > start_date),
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('active','planned'))
);

CREATE TABLE personnel (
    personnel_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    personnel_full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('instructor','mentor','support'))
);

CREATE TABLE program_personnel (
    program_personnel_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    personnel_id INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    program_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('active','paused','dropped'))
);

CREATE TABLE sessions (
    session_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    session_title VARCHAR(100) NOT NULL,
    session_date DATE NOT NULL,
    session_number INT NOT NULL
        CHECK (session_number > 0),
    topic VARCHAR(100) NOT NULL
);

CREATE TABLE attendance (
    attendance_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN ('present','absent','late','excused')),
    notes TEXT
);

CREATE TABLE assignments (
    assignment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    day_number INT NOT NULL
        CHECK (day_number > 0),
    due_date DATE NOT NULL,
    max_points INT NOT NULL
    CHECK (max_points > 0 AND max_points <= 100)
);

CREATE TABLE submissions (
    submission_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    github_link VARCHAR(255) NOT NULL,
    submitted_at DATE NOT NULL,
    score INT NOT NULL
    CHECK (score >= 0 AND score <= 100),
    feedback TEXT
);


ALTER TABLE students
ADD CONSTRAINT uq_student_email UNIQUE (email);

ALTER TABLE enrollments
ADD CONSTRAINT uq_student_program UNIQUE (student_id, program_id);

ALTER TABLE program_personnel
ADD CONSTRAINT uq_program_personnel UNIQUE (program_id, personnel_id);

ALTER TABLE sessions
ADD CONSTRAINT uq_program_session_number UNIQUE (program_id, session_number);

ALTER TABLE attendance
ADD CONSTRAINT uq_session_student_attendance UNIQUE (session_id, student_id);



ALTER TABLE  program_personnel
ADD FOREIGN KEY (program_id)
REFERENCES programs(program_id),

ADD FOREIGN KEY (personnel_id)
REFERENCES personnel(personnel_id);
/*--------------------------------------------------*/
ALTER TABLE enrollments
ADD FOREIGN KEY (student_id)
REFERENCES students(student_id),

ADD FOREIGN KEY (program_id)
REFERENCES programs(program_id);
/*--------------------------------------------------*/
ALTER TABLE sessions
ADD FOREIGN KEY (program_id)
REFERENCES programs(program_id);
/*--------------------------------------------------*/
ALTER TABLE attendance
ADD FOREIGN KEY (session_id)
REFERENCES sessions(session_id),

ADD FOREIGN KEY (student_id)
REFERENCES students(student_id);
/*--------------------------------------------------*/
ALTER TABLE assignments
ADD FOREIGN KEY (program_id)
REFERENCES programs(program_id);
/*--------------------------------------------------*/
ALTER TABLE submissions
ADD FOREIGN KEY (assignment_id)
REFERENCES assignments(assignment_id),

ADD FOREIGN KEY (student_id)
REFERENCES students(student_id);


ALTER TABLE submissions
ADD CONSTRAINT uq_assignment_student_submission
UNIQUE (assignment_id, student_id);