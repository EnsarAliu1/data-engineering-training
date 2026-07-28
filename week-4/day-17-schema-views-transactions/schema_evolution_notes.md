# Part 7: Schema Evolution, Views, Transactions & Indexing Notes

---

### 15. What is the difference between changing data and changing schema?

* **Changing Data (DML - Data Manipulation Language):** Refers to modifying the actual records stored inside table rows (e.g., `INSERT`, `UPDATE`, `DELETE`). The container structure stays untouched, but the content inside changes.
* **Changing Schema (DDL - Data Definition Language):** Refers to altering the structural definition or metadata of the database objects (e.g., `ALTER TABLE ADD COLUMN`, `DROP COLUMN`, `MODIFY COLUMN`). It redefines how data is stored, what data types are permitted, constraints, or table layouts.

*Analogy:* Changing data is like adding, editing, or deleting pages inside a notebook. Changing schema is like adding a new column to a table layout template printed on every page.

---

### 16. Why do real databases need `ALTER TABLE`?

In real-world data engineering and application development, requirements change continuously:
* **Business Evolution:** New feature requirements demand storing additional attributes (e.g., adding `phone_number TEXT`, `github_username TEXT`, or `review_status TEXT` to our tables).
* **Data Quality & Refactoring:** Modifying column definitions (e.g., adding new `TEXT` columns, adjusting default values, or adding uniqueness constraints).
* **Avoiding Downtime & Data Loss:** In production databases with millions of records, dropping and recreating a table to change its structure is unacceptable—it causes data loss and pipeline downtime. `ALTER TABLE` allows in-place schema changes without destroying existing data.

---

### 17. What is a view and why is it useful?

A **View** is a virtual table defined by a stored SQL `SELECT` query. It does not physically store data on disk (unless materialized); instead, it dynamically executes its underlying query every time it is queried.

**Why views are useful:**
1. **Query Simplification:** Wraps complex multi-table `JOIN`s, `CASE` statements, or aggregation logic into a clean single reference (e.g., `SELECT * FROM student_profile_view`).
2. **Security & Abstraction:** Restricts user access to specific sensitive columns (like hiding password hashes or SSNs) or specific rows without granting access to base tables.
3. **Data Interface Stability:** If underlying base tables are renamed or refactored, the view definition can be updated so downstream dashboards and pipelines don't break.

---

### 18. What is the difference between a table and a view?

* **Storage:** A table stores actual data physically on disk. A view is virtual and stores only the SQL query definition in database metadata.
* **Performance:** Tables offer direct row access via disk pages and indexes. Views execute their underlying SQL query on demand whenever queried.
* **Data Persistence:** Tables maintain their own stored records independently. Views dynamically display live data pulled from their underlying base tables.
* **Data Modifications (Writes):** Tables fully support direct `INSERT`, `UPDATE`, and `DELETE` operations. Views are primarily designed for reading and have strict limitations or are read-only when involving complex joins or aggregations.

---

### 19. What does `ROLLBACK` do?

`ROLLBACK` reverts all uncommitted data modifications made during the active transaction session. It restores the database back to the state it was in before `BEGIN TRANSACTION` (or to a specific `SAVEPOINT`). 

If an error occurs midway through a pipeline execution or a batch update, `ROLLBACK` guarantees that no partial or corrupted data remains in the database.

---

### 20. What does `COMMIT` do?

`COMMIT` saves all data modifications executed within the current transaction permanently to disk. Once committed, the changes become permanent, ACID-compliant, and visible to all other concurrent database sessions and connections. You cannot `ROLLBACK` changes once a `COMMIT` has executed.

---

### 21. Why are transactions useful before dangerous updates/deletes?

In relational databases, executing an `UPDATE` or `DELETE` without a proper `WHERE` clause (or with flawed filter logic) can accidentally overwrite or wipe an entire table in seconds.

By wrapping dangerous operations inside an explicit transaction block (`BEGIN TRANSACTION`), you can:
1. Run the `UPDATE` or `DELETE` command.
2. Check `ROW_COUNT()` or run a quick `SELECT` query in the same session to inspect affected records.
3. If everything looks accurate, issue `COMMIT`.
4. If something looks wrong (e.g., 50,000 rows affected instead of 5), issue `ROLLBACK` to immediately restore the data to its original state without any risk.

---

### 22. What is an index in simple words?

An **index** is a specialized lookup data structure (typically a B-Tree) created on one or more table columns. 

*Analogous to an index at the back of a book:* Instead of reading every page sequentially (Full Table Scan) to find a keyword, the database consults the index to instantly jump to the exact disk location of the target rows, drastically reducing read times.

---

### 23. Which columns did you index and why?

Based on our `indexes.sql` script for Day 17, the following columns were indexed:

1. **`submissions(student_id)` & `submissions(assignment_id)`**
   * *Why:* `student_id` and `assignment_id` are primary foreign keys in `submissions`. They are frequently joined against `students` and `assignments` tables and used in filtering (`WHERE student_id = X`).
2. **`attendance(session_id)` & `attendance(student_id)`**
   * *Why:* Used heavily in `JOIN` conditions when computing attendance rates per student or per session (`attendance_summary_view`).
3. **`enrollments(program_id)`**
   * *Why:* Accelerates program-level lookups and filtering across student enrollments.

*Key Takeaway:* We index foreign key columns and frequently queried `WHERE` / `JOIN` columns to optimize join execution plans and prevent full table scans as datasets grow.

---

### 24. How does this prepare you for Databricks tables and views?

Understanding standard SQL schema evolution, views, transactions, and indexing builds the exact foundation needed for working with Lakehouse architectures like Databricks & Delta Lake:

* **Schema Evolution in Delta Lake:** In Databricks, Delta Lake extends standard relational schema management with automatic schema enforcement and controlled schema evolution (e.g., `option("mergeSchema", "true")` in PySpark or `ALTER TABLE` in Spark SQL).
* **Views & Medallion Architecture:** Views in Databricks (Standard Views, Temporary Views, and Materialized Views / Streaming Tables) form the backbone of the Medallion Architecture (Bronze $\rightarrow$ Silver $\rightarrow$ Gold layers) to abstract raw data into clean, business-ready data assets.
* **ACID Transactions & Time Travel:** Traditional RDBMS `ROLLBACK`/`COMMIT` concepts translate directly to Delta Lake's ACID transaction log (`_delta_log`). Delta Lake logs all commits, giving you time travel (`VERSION AS OF` / `TIMESTAMP AS OF`) and snapshot isolation.
* **Indexing vs. Data Skipping / Z-Ordering:** While traditional databases use B-Tree indexes, Lakehouses format data as Parquet files. Databricks optimizes queries using metadata data skipping, **Z-Ordering** (`OPTIMIZE ... ZORDER BY`), and **Liquid Clustering** to co-locate related data—achieving the same goal as traditional indexing for massive data scale.
