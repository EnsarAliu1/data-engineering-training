# Part 1 - Database Design Plan

# What problem your database is solving.

Our database solves the problem of organizing, storing, and managing data efficiently, making it easy to retrieve accurate information, reduce redundancy, and support better decision-making. This makes it easy to get reports analyse them and excecute descisions.

# List every table you decided to create and why it exists.

- **students** Tracks students identity, contact data, city etc.
- **Programs** Tracks training programs(courses).
- **Instructors** Tracks teaching or mentoring responsibilites for each program and student.
- **Enrollments** This is the key table it tracks students, their courses and instructors of those courses.
- **Attendance** Tracks the attendance of students in each program.
- **Payments** Tracks the income of entire training center by each program.
- **Risk** Tracks the risks of studnents who need academic or financial attention.

## Primary Keys

Every table needs a unique identifier for its records—its Primary Key.

- **students:** `student_id`
- **instructors:** `instructor_id`
- **programs:** `program_id`
- **enrollments:** `enrollment_id`
- **attendance:** `attendance_id`
- **payments:** `payment_id`

## Foreign Keys & Their Parents

Foreign keys are how we link a record in one table back to its parent table.

- **programs:** `instructor_id` (references `instructors`)
- **enrollments:** `student_id` (references `students`) and `program_id` (references `programs`)
- **attendance:** `enrollment_id` (references `enrollments`)
- **payment:** `course_id` (references `courses`) `student_id` (references `students`)

## One-to-Many Relationships

Here are three examples of a "one-to-many" relationship in our system:

1. **Instructors to Programs:** One instructor can teach many different programs.
2. **Programs to Assignments:** One course can have many assignments attached to it.
3. **Enrollments to Attendance:** One specific student's enrollment can have many attendance records (e.g., one for each day of class).

## Many-to-Many Relationships & The Bridge Table

We have a classic many-to-many relationship between **students** and **programs**. A single student can take many courses, and a single course is taken by many students.

Relational databases can't handle many-to-many relationships directly without creating a massive mess of duplicate data. To solve this, we use a **bridge table**—in this case, the `enrollments` table. The bridge table sits in the middle and connects the two. Each row in the `enrollments` table simply says "This specific student (via `student_id`) is taking this specific program (via `program_id`)."

# Explain NOT NULL, UNIQUE, CHECK, and why they protect the data.

**NOT NULL:** Ensures that a field cannot be left empty. For example, a student's name or `student_id` must always have a value.

**UNIQUE:** Ensures that no two records have the same value in a specific column. For example, each student's email should be unique.

**CHECK:** Ensures that only valid values are entered based on a condition. For example, a payment amount must be greater than 0, or attendance status must be either "Present" or "Absent".

**Why they protect the data:** These constraints improve data integrity by preventing missing, duplicate, or invalid data from being stored in the database, ensuring the information remains accurate and reliable.

# Explain why your design can answer the required business questions.

Our database design can answer the required business questions because it stores all important information in related tables. By linking students, programs, instructors, enrollments, attendance, payments, and risks through primary and foreign keys, we can easily generate reports such as student enrollment, attendance rates, instructor assignments, program performance, payment history, and students who require academic or financial support. This helps the training center make informed decisions based on accurate and organized data.

**Things might change slightly during the development process as new requirements or improvements are identified. The database design is flexible enough to allow modifications while maintaining data integrity and supporting the business need**
