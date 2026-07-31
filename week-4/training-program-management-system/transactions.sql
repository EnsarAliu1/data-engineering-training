--Part 9 - Transactions

--One transaction that updates data and uses ROLLBACK.
START TRANSACTION;

UPDATE personnel
SET personnel.role = 'instructor'
WHERE personnel.personnel_id = 12;

SELECT * FROM personnel WHERE personnel.personnel_id = 12;

ROLLBACK;

SELECT * FROM personnel WHERE personnel.personnel_id = 12;


--One transaction that updates data and uses COMMIT.
START TRANSACTION;

UPDATE attendance
SET attendance.notes = 'Late bus'
WHERE attendance.session_id = 4 AND attendance.student_id = 5;

COMMIT;

SELECT * FROM attendance WHERE attendance.session_id = 4 AND attendance.student_id = 5;


--One transaction that tests a risky delete and uses ROLLBACK.
START TRANSACTION;

-- Risky delete: remove all students with no enrollments
DELETE FROM students
WHERE student_id NOT IN (
    SELECT student_id
    FROM enrollments
);

-- Check the result before committing
SELECT * FROM students;

-- Undo the delete
ROLLBACK;

-- Verify that the deleted rows have been restored
SELECT * FROM students;


--COMMIT saves all changes made during a transaction permanently. Once committed, the changes become part of the database and cannot be undone with `ROLLBACK`.

--ROLLBACK cancels all changes made during a transaction. It is used when a mistake or error occurs, restoring the database to its previous state.
