# 🚀 Data Engineering Training Repository

Welcome to the **Data Engineering Training** repository! This project documents a comprehensive, multi-week hands-on journey through fundamental to advanced data engineering concepts, including Python scripting, relational database design, data cleaning pipelines, Medallion Architecture, schema evolution, database administration, and capstone system development.

---

## 📚 Table of Contents

- [Overview](#-overview)
- [Curriculum Roadmap](#-curriculum-roadmap)
  - [Week 1: Python & SQL Foundations](#week-1-python--sql-foundations)
  - [Week 2: Data Pipelines & Medallion Architecture](#week-2-data-pipelines--medallion-architecture)
  - [Week 3: Relational Database Design & Advanced Modeling](#week-3-relational-database-design--advanced-modeling)
  - [Week 4: Operations, Maintenance & Capstone System](#week-4-operations-maintenance--capstone-system)
- [Key Projects & Highlights](#-key-projects--highlights)
- [Tech Stack & Key Concepts](#-tech-stack--key-concepts)
- [Getting Started](#-getting-started)
- [Repository Structure](#-repository-structure)

---

## 💡 Overview

This repository contains practical projects, SQL queries, data processing scripts, and architectural patterns built during intensive data engineering training modules. 

The goal of this curriculum is to build production-grade habits around:
1. **Raw Data Ingestion & Cleansing**: Processing unstructured and semi-structured CSV datasets.
2. **Medallion Data Architecture**: Building Bronze (Raw), Silver (Cleaned), and Gold (Aggregated/Business) data pipelines.
3. **Relational Database Design**: Modeling entities, foreign keys, cardinality, constraints, and views.
4. **Data Operations & Maintenance**: Soft/hard deletes, NULL handling (`COALESCE`), transactions (`BEGIN/COMMIT/ROLLBACK`), and B-tree indexing.
5. **Full System Integration**: Designing capstone management databases with transactional safety and reporting views.

---

## 🗺️ Curriculum Roadmap

### Week 1: Python & SQL Foundations
Mastering essential Python data structures, file I/O, error checking, and foundational SQL syntax.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [monday-practice](./week-1/monday-practice) | Introduction to workspace setup, basic scripts, and Python data handling. | Scripting basics |
| 📁 [day-2-practice](./week-1/day-2-practice) | CSV Mini Data Pipeline — validating, cleaning, and generating data quality reports. | [`csv_pipeline.py`](./week-1/day-2-practice/csv_pipeline.py) |
| 📁 [day-3-sql-foundations](./week-1/day-3-sql-foundations) | Core SQL syntax: `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, aggregations, and filtering. | Basic SQL queries |
| 📁 [day-4-python-sql-review](./week-1/day-4-python-sql-review) | Combining Python logic with SQL databases for structured data persistence. | Review scripts |
| 📁 [day-5-friday-data-sprint](./week-1/day-5-friday-data-sprint) | End-of-week consolidation sprint applying Python + SQL data workflows. | Sprint scripts |

---

### Week 2: Data Pipelines & Medallion Architecture
Scaling data transformation pipelines, building multi-stage data architectures, and advanced data manipulation.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-6-sql-business-reporting](./week-2/day-6-sql-business-reporting) | Business reporting queries with multi-table joins, subqueries, and metric aggregations. | Reporting queries |
| 📁 [day-7-sql-detective-day](./week-2/day-7-sql-detective-day) | Data quality debugging, investigative querying, and resolving dataset anomalies. | Detective queries |
| 📁 [day-8-python-data-logic-sprint-heavy](./week-2/day-8-python-data-logic-sprint-heavy) | Heavy Python data transformations, complex dictionary & list manipulation. | Logic sprint code |
| 📁 [day-9-csv-data-pipeline](./week-2/day-9-csv-data-pipeline) | Automated multi-file CSV extraction, data quality reporting, and validated output generation. | Pipeline runner |
| 📁 [day-10-bronze-silver-gold-pipeline](./week-2/day-10-bronze-silver-gold-pipeline) | Implementation of **Medallion Architecture** (Bronze raw ingestion, Silver sanitization, Gold analytics). | [`pipeline.py`](./week-2/day-10-bronze-silver-gold-pipeline/pipeline.py), [`layer_explanation.md`](./week-2/day-10-bronze-silver-gold-pipeline/layer_explanation.md) |

---

### Week 3: Relational Database Design & Advanced Modeling
Designing scalable database schemas, defining constraints, enforcing referential integrity, and building enterprise models.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-11-python-sql-pipeline-prep](./week-3/day-11-python-sql-pipeline-prep) | Python-to-SQL pipeline preparation, parameterization, and connection handling. | Pipeline prep scripts |
| 📁 [day-12-relationships-foreign-keys](./week-3/day-12-relationships-foreign-keys) | Modeling `1:1` and `1:N` table relationships, `FOREIGN KEY` constraints, and cascades. | FK DDL scripts |
| 📁 [day-13-relationships-intensive](./week-3/day-13-relationships-intensive) | Junction tables, `M:N` (many-to-many) relationship implementations, and complex `JOIN`s. | Junction DDL scripts |
| 📁 [day-14-database-design-challenge](./week-3/day-14-database-design-challenge) | Real-world schema design challenges, entity normalization, and constraint strategy. | Design challenges |
| 📁 [day-15-advanced-relationships](./week-3/day-15-advanced-relationships) | SaaS Platform Database Project — multi-tenant schema with strict constraints and business reports. | [`README.md`](./week-3/day-15-advanced-relationships/README.md) |

---

### Week 4: Operations, Maintenance & Capstone System
Database maintenance operations, transactions, schema evolution, views, performance indexing, and the end-to-end management capstone.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-16-sql-data-maintenance](./week-4/day-16-sql-data-maintenance) | Data maintenance: Safe `UPDATE`s, Soft vs. Hard Deletes (`is_active`), `COALESCE` for `NULL` handling, `CASE WHEN` logic. | Maintenance queries |
| 📁 [day-17-schema-views-transactions](./week-4/day-17-schema-views-transactions) | `ALTER TABLE` schema evolution, virtual database `VIEW`s, ACID transactions (`BEGIN`/`COMMIT`), and B-tree indexes. | [`README.md`](./week-4/day-17-schema-views-transactions/README.md) |
| 🏆 [training-program-management-system](./week-4/training-program-management-system) | **Capstone Project**: Full-featured Training Program Management System with database creation, views, indexing, maintenance scripts, and reporting queries. | [`README.md`](./week-4/training-program-management-system/README.md), [`setup.sql`](./week-4/training-program-management-system/setup.sql), [`indexes.sql`](./week-4/training-program-management-system/indexes.sql) |

---

## 🌟 Key Projects & Highlights

### 1. 🥇 Medallion Architecture Data Pipeline ([Week 2 / Day 10](./week-2/day-10-bronze-silver-gold-pipeline))
- **Bronze Layer**: Raw CSV ingestion preserving raw state and tracking original input format.
- **Silver Layer**: Data cleansing, type coercion, null value resolution, and standardization.
- **Gold Layer**: Business aggregation layer preparing analytical metrics and executive dashboards.

### 2. 🏛️ SaaS Platform Database Project ([Week 3 / Day 15](./week-3/day-15-advanced-relationships))
- Normalized database schema protecting data integrity with `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, and `CHECK` constraints.
- Optimized join performance and comprehensive analytical reports.

### 3. 🎓 Training Program Management System Capstone ([Week 4 Capstone](./week-4/training-program-management-system))
- Complete enterprise database solution for managing programs, courses, instructors, students, and enrollments.
- Includes automated setup scripts ([`setup.sql`](./week-4/training-program-management-system/setup.sql)), seed data ([`insert_data.sql`](./week-4/training-program-management-system/insert_data.sql)), abstraction views ([`views.sql`](./week-4/training-program-management-system/views.sql)), indexing strategy ([`indexes.sql`](./week-4/training-program-management-system/indexes.sql)), and data maintenance routines ([`maintenance_queries.sql`](./week-4/training-program-management-system/maintenance_queries.sql)).

---

## 🛠️ Tech Stack & Key Concepts

- **Programming**: Python 3.x (File handling, CSV parsing, data structures, data validation)
- **Relational Databases**: SQL (PostgreSQL, SQLite), Data Definition Language (DDL), Data Manipulation Language (DML)
- **Data Engineering Concepts**:
  - Medallion Architecture (Bronze / Silver / Gold)
  - Data Cleansing & Validation (Data Quality Reports, Exception Handling)
  - Schema Normalization & Constraint Enforcement (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `UNIQUE`)
  - Database Performance Optimization (B-tree Indexes, SQL Views)
  - Data Maintenance (Hard Delete vs. Soft Delete, NULL Handling with `COALESCE`)
  - Transaction Management (ACID Compliance, `BEGIN`, `COMMIT`, `ROLLBACK`)

---

## 🚀 Getting Started

### Prerequisites
- **Python**: Version 3.8 or higher installed.
- **Database**: SQLite3 (built-in with Python) or PostgreSQL.

### Running Python Data Pipelines
Navigate to any pipeline directory and run the main entry point:

```bash
# Example: Running the Week 1 CSV Cleaning Pipeline
cd week-1/day-2-practice
python csv_pipeline.py

# Example: Running the Week 2 Medallion Pipeline
cd week-2/day-10-bronze-silver-gold-pipeline
python pipeline.py
```

### Running SQL Capstone Scripts
Execute the SQL scripts against your database engine (e.g., SQLite CLI or PostgreSQL `psql`):

```bash
# Example: Setting up the Capstone Database System
cd week-4/training-program-management-system
sqlite3 training_db.sqlite < setup.sql
sqlite3 training_db.sqlite < insert_data.sql
sqlite3 training_db.sqlite < views.sql
sqlite3 training_db.sqlite < indexes.sql
```

---

## 📁 Repository Structure

```text
data-engineering-training/
├── README.md                                  # Root Documentation & Navigation
├── week-1/                                    # Python & SQL Foundations
│   ├── monday-practice/                       # Python Environment & Basics
│   ├── day-2-practice/                        # CSV Cleaning Pipeline & Reports
│   ├── day-3-sql-foundations/                 # Basic SQL Syntax & Aggregations
│   ├── day-4-python-sql-review/               # Python + SQL Database Basics
│   └── day-5-friday-data-sprint/              # Week 1 Sprint Project
├── week-2/                                    # Pipelines & Medallion Architecture
│   ├── day-6-sql-business-reporting/          # Business Reporting Queries
│   ├── day-7-sql-detective-day/               # Data Quality Debugging
│   ├── day-8-python-data-logic-sprint-heavy/  # Data Transformations
│   ├── day-9-csv-data-pipeline/               # Production CSV Pipeline
│   └── day-10-bronze-silver-gold-pipeline/    # Medallion Architecture Pipeline
├── week-3/                                    # Relational Database Modeling
│   ├── day-11-python-sql-pipeline-prep/       # Python-SQL Bridge
│   ├── day-12-relationships-foreign-keys/     # 1:1 and 1:N Schema Design
│   ├── day-13-relationships-intensive/        # Junction Tables & M:N Modeling
│   ├── day-14-database-design-challenge/      # Real-World ERD Exercises
│   └── day-15-advanced-relationships/         # SaaS Platform Database System
└── week-4/                                    # Maintenance, Views & Capstone
    ├── day-16-sql-data-maintenance/           # Soft Deletes, COALESCE & CASE WHEN
    ├── day-17-schema-views-transactions/      # Schema Evolution, Views, Indexing
    └── training-program-management-system/    # Capstone Database Management System
```

---

## 👨‍💻 Author & Acknowledgments

- **Repository Owner**: Ensar Aliu
- **Program**: Data Engineering Training Course
- Developed with best practices for scalable data pipelines and robust database engineering.
