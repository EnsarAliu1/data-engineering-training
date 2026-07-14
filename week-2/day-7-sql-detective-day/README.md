# Day 7 - SQL Detective Day

## Goal of the Practice
The goal of this practice is to develop real-world SQL debugging and validation skills. Instead of just writing queries from scratch, the focus is on locating syntax errors, repairing broken JOIN conditions, fixing incorrect filtering logic, and building independent validation queries to prove that the extracted business figures are 100% accurate.

---

## Files Included in This Folder

* **setup.sql**: The initialization database script. It recreates the tables (customers, products, orders) and inserts raw mock data.
* **table_inspection.sql**: A simple script used to query raw tables, understand database relationships, and inspect records.
* **broken_queries.sql**: The original set of 10 queries containing various syntax, join, and logical errors.
* **fixed_queries.sql**: The corrected versions of the 10 queries, complete with brief comments explaining the fixes.
* **validation_queries.sql**: A suite of independent validation queries designed to cross-reference and double-check key metrics.
* **query_explanations.md**: An in-depth analysis of 8 fixed queries and 5 validation queries, explaining what they do, their tables, JOIN needs, and business meanings.
* **verified_business_report.md**: The final, verified executive summary presenting weekly orders, revenue, top categories, active cities, repeat customers, and strategic recommendations.

---

## Recommended Running Order

To run and verify the project files successfully, execute them in this exact order:

1. **setup.sql**: Run this first to build the SQLite tables and insert mock records.
2. **table_inspection.sql**: Execute this to verify that all records loaded cleanly and to understand the database columns.
3. **fixed_queries.sql**: Run this to retrieve the corrected query outputs for customer, product, and city metrics.
4. **validation_queries.sql**: Run these queries to cross-reference the numbers from step 3 and ensure everything balances.
5. **Review verified_business_report.md**: Read the final Markdown document to see the verified facts, figures, and strategic recommendations.

---

## What Was Learned About Debugging SQL

* **Debugging Syntax Errors:** Syntax errors often stem from simple typing slips like missing commas between columns in a SELECT statement, misplacing HAVING clauses before GROUP BY, or writing semicolons in the middle of active statements. SQLite error messages usually point directly to the line causing the problem.
* **Fixing Logic and JOIN Errors:** Omitting JOIN criteria (like ON clauses) creates accidental cross joins, which multiply and duplicate rows. In addition, ambiguous column references occur when two joined tables share the same column name (like customer_id) and we fail to specify which table the query should read from.
* **Filtering Logic is Crucial:** A simple typo in query filters (like using = instead of !=) changes the entire business outcome. In this dataset, filtering for completed orders instead of non-completed orders led to completely reversed outputs.

---

## What Was Learned About Verifying Business Reports

* **The Reality of Potential vs. Real Revenue:** Total order activity is not the same as revenue. Calculating revenue without a WHERE status = 'completed' filter inflates actual earnings by counting pending or cancelled transactions. In this case, reporting total raw transactions would have artificially doubled the company's actual revenue ($3,299 vs. $1,639).
* **Cross-Checking is Essential:** A business report is only as strong as its verification. By running independent validation queries and ensuring the sums of individual products or cities match the total completed revenue, we eliminate math and logical errors.
* **Numbers Must Guide Action:** Data is only useful if it points to a business decision. Verifying that two Laptop sales were cancelled ($1,400) immediately highlights a critical leak in the sales funnel, showing management exactly where they need to intervene.
