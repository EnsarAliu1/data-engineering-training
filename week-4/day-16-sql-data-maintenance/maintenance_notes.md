# Data Maintenance Technical Notes - Day 16

## Key Concepts & Best Practices

### 1. Data Maintenance & Operational Safety
- Data maintenance covers the techniques required to update, purge, or flag records as business state changes over time.
- All DML modifications (`UPDATE` and `DELETE`) must be explicitly scoped using `WHERE` clauses matching unique identifier keys.
- Verification pattern: Always run a `SELECT` query prior to running an `UPDATE` or `DELETE` to confirm target row scope.

### 2. Deletion Strategies
- **Hard Deletes (`DELETE FROM`)**: Purges row binary data permanently from database blocks. Fails when referenced by foreign keys. Destroys historical audit trails.
- **Soft Deletes (`UPDATE ... SET status = ...`)**: Flags records as inactive or cancelled. Keeps historical child records (attendance, payment, submissions) intact while filtering records out of active application views.

### 3. NULL Value Mechanics
- SQL uses tri-state logic (`TRUE`, `FALSE`, `UNKNOWN`). Because `NULL` signifies missing data, equality comparisons (`= NULL`) evaluate to `UNKNOWN`.
- Filter using `IS NULL` or `IS NOT NULL`.
- Format reporting outputs using `COALESCE(val, 'Default String')` to replace missing attributes cleanly.

### 4. Anti-Joins & Gap Analysis
- Use `LEFT JOIN` combined with `WHERE right_table.primary_key IS NULL` to identify missing records (such as students with zero submissions or unrecorded session attendance).
- Multi-column join conditions (`ON left.student_id = right.student_id AND left.assignment_id = right.assignment_id`) ensure precision when checking per-task deliverables.
