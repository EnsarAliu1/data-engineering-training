# Part 1 - Database Design Before SQL

## Making Sense of the Data Model
When building a system for the Unity Tech Hub, the easiest mistake to make is throwing all our data into one giant spreadsheet. While that might seem simple at first, it quickly turns into a nightmare of duplicated information and inconsistent records. 

Instead, a professional relational database design breaks everything down into focused, logical pieces. Each table represents a single entity (like a student or a course). We then connect these tables using specific links called relationships. This way, we store a piece of information exactly once. If an instructor changes their name, we update it in one place, and the rest of the system automatically reflects that change. It keeps our data clean, reliable, and perfectly organized so managers can easily pull the combined reports they need without sifting through messy duplicates.

## Primary Keys
Every table needs a unique identifier for its records—its Primary Key.
* **students:** `student_id`
* **instructors:** `instructor_id`
* **courses:** `course_id`
* **enrollments:** `enrollment_id`
* **attendance:** `attendance_id`
* **assignments:** `assignment_id`
* **submissions:** `submission_id`

## Foreign Keys & Their Parents
Foreign keys are how we link a record in one table back to its parent table.
* **courses:** `instructor_id` (references `instructors`)
* **enrollments:** `student_id` (references `students`) and `course_id` (references `courses`)
* **attendance:** `enrollment_id` (references `enrollments`)
* **assignments:** `course_id` (references `courses`)
* **submissions:** `student_id` (references `students`) and `assignment_id` (references `assignments`)

## One-to-Many Relationships
Here are three examples of a "one-to-many" relationship in our system:
1. **Instructors to Courses:** One instructor can teach many different courses.
2. **Courses to Assignments:** One course can have many assignments attached to it.
3. **Enrollments to Attendance:** One specific student's enrollment can have many attendance records (e.g., one for each day of class).

## Many-to-Many Relationships & The Bridge Table
We have a classic many-to-many relationship between **students** and **courses**. A single student can take many courses, and a single course is taken by many students.

Relational databases can't handle many-to-many relationships directly without creating a massive mess of duplicate data. To solve this, we use a **bridge table**—in this case, the `enrollments` table. The bridge table sits in the middle and connects the two. Each row in the `enrollments` table simply says "This specific student (via `student_id`) is taking this specific course (via `course_id`)." 

## Why Not Store `course_name` in the Students Table?
If we stored `course_name` directly next to the student's name, we'd have to type out "Data Engineering 101" hundreds of times for every student in that class. 
If the course name ever changes, we'd have to track down every single student's record and update it manually. If we miss even one, our data becomes inconsistent. By storing the `course_name` only in the `courses` table and linking to it with a `course_id`, we save storage space and ensure that any updates only need to happen in one single place.

## Simple Database Flow Diagram
```text
instructors ---> courses ---> assignments ---> submissions
                   |                               ^
                   v                               |
              enrollments <-------------------- students
                   |
                   v
               attendance
```
