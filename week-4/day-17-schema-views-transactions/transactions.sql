--Start a transaction, update one score, verify it changed, then ROLLBACK. Prove the old value returned.
BEGIN TRANSACTION;

UPDATE submissions
set score = 100;

SELECT * FROM submissions WHERE submissions.submission_id = 1;

ROLLBACK;

SELECT * FROM submissions WHERE submissions.submission_id = 1;

--Start a transaction, update one review_status, then COMMIT. Prove the change stayed.
SELECT * FROM submissions;

BEGIN TRANSACTION;

UPDATE submissions
SET review_status = 'reviewed' , reviewed_at = '2026-08-07'
WHERE submission_id = 1;

COMMIT;

SELECT * FROM submissions WHERE submission_id = 1;


--Start a transaction, try to delete a student who has submissions or attendance. Explain what happens.
SELECT * from students;

BEGIN TRANSACTION;

DELETE FROM students
WHERE student_id = 1;
--The delete operation fails because the student record is referenced by foreign keys in the submissions and attendance tables. SQLite prevents deleting a parent row while child records still exist, in order to maintain referential integrity. The related records must be deleted first or the foreign keys must use ON DELETE CASCADE.


--Start a transaction, soft-delete one enrollment by changing status to dropped, then COMMIT.
BEGIN TRANSACTION;

UPDATE enrollments
set status = 'dropped'
WHERE enrollment_id = 2;

COMMIT;

--Start a transaction, make two updates together: update score and feedback for the same submission. COMMIT only if both are correct.


BEGIN TRANSACTION;

UPDATE submissions
set score = 100 
WHERE submission_id = 1 and student_id = 6;

UPDATE submissions
set feedback = 'Outstanding'
WHERE submission_id = 1 and student_id = 6;

COMMIT;


-- COMMIT is used when all changes in a transaction are correct
-- and we want to permanently save them to the database.
-- Example: after successfully updating an enrollment status,
-- we use COMMIT to confirm and save the change.


-- ROLLBACK is used when something goes wrong during a transaction
-- and we want to undo all changes made since the transaction started.
-- Example: if we update the wrong student or an error occurs,
-- ROLLBACK restores the database to its previous state.