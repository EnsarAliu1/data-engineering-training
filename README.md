# 🚀 Data Engineering Training Repository

Welcome to the **Data Engineering Training** repository! This project documents a comprehensive, multi-week hands-on journey through fundamental to advanced data engineering concepts, including Python, SQL, data pipeline architecture, and enterprise database design.

---

## 📚 Table of Contents

- [Overview](#-overview)
- [Curriculum Roadmap](#-curriculum-roadmap)
  - [Week 1: Python & SQL Foundations](#week-1-python--sql-foundations)
  - [Week 2: Data Pipelines & Medallion Architecture](#week-2-data-pipelines--medallion-architecture)
  - [Week 3: Relational Database Design & Advanced Modeling](#week-3-relational-database-design--advanced-modeling)
  - [Week 4: Operations, Maintenance & Capstone System](#week-4-operations-maintenance--capstone-system)
  - [Week 5: Advanced Data Engineering & Specialization](#week-5-advanced-data-engineering--specialization)
- [Key Projects & Highlights](#-key-projects--highlights)
- [Tech Stack & Key Concepts](#-tech-stack--key-concepts)
- [Getting Started](#-getting-started)
- [Repository Structure](#-repository-structure)

---

## 💡 Overview

This repository contains practical projects, SQL queries, data processing scripts, and architectural patterns built during intensive data engineering training modules. 

The goal of this curriculum is to build production-grade habits around:
1. **Raw Data Ingestion & Cleansing**: Processing unstructured and semi-structured CSV datasets with validation and error handling.
2. **Medallion Data Architecture**: Building Bronze (Raw), Silver (Cleaned), and Gold (Aggregated/Business) data pipelines.
3. **Relational Database Design**: Modeling entities, foreign keys, cardinality, constraints, and views with ACID compliance.
4. **Data Operations & Maintenance**: Soft/hard deletes, NULL handling (`COALESCE`), transactions (`BEGIN/COMMIT/ROLLBACK`), and B-tree indexing.
5. **Full System Integration**: Designing capstone management databases with transactional safety and reporting views.
6. **Advanced Specialization**: Deep-dive topics including data quality, performance tuning, and specialized data engineering patterns.

---

## 🗺️ Curriculum Roadmap

### Week 1: Python & SQL Foundations
Mastering essential Python data structures, file I/O, error checking, and foundational SQL syntax.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [monday-practice](./week-1/monday-practice) | Introduction to workspace setup, basic scripts, and Python data handling. | Scripting basics |
| 📁 [day-2-practice](./week-1/day-2-practice) | CSV Mini Data Pipeline — validating, cleaning, and generating data quality reports. | Data pipeline scripts |
| 📁 [day-3-sql-foundations](./week-1/day-3-sql-foundations) | Core SQL syntax: `SELECT`, `WHERE`, `GROUP BY`, `HAVING`, aggregations, and filtering. | SQL query scripts |
| 📁 [day-4-python-sql-review](./week-1/day-4-python-sql-review) | Combining Python logic with SQL databases for structured data persistence. | Integration scripts |
| 📁 [day-5-friday-data-sprint](./week-1/day-5-friday-data-sprint) | End-of-week consolidation sprint applying Python + SQL data workflows. | Sprint project |

---

### Week 2: Data Pipelines & Medallion Architecture
Scaling data transformation pipelines, building multi-stage data architectures, and advanced data manipulation.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-6-sql-business-reporting](./week-2/day-6-sql-business-reporting) | Business reporting queries with multi-table joins, subqueries, and metric aggregations. | Reporting SQL scripts |
| 📁 [day-7-sql-detective-day](./week-2/day-7-sql-detective-day) | Data quality debugging, investigative querying, and resolving dataset anomalies. | Detective queries |
| 📁 [day-8-python-data-logic-sprint-heavy](./week-2/day-8-python-data-logic-sprint-heavy) | Heavy Python data transformations, complex dictionary & list manipulation. | Advanced Python scripts |
| 📁 [day-9-csv-data-pipeline](./week-2/day-9-csv-data-pipeline) | Automated multi-file CSV extraction, data quality reporting, and validated output generation. | Production pipeline |
| 📁 [day-10-bronze-silver-gold-pipeline](./week-2/day-10-bronze-silver-gold-pipeline) | Implementation of **Medallion Architecture** (Bronze raw ingestion, Silver sanitization, Gold analytics). | Medallion pipeline |

---

### Week 3: Relational Database Design & Advanced Modeling
Designing scalable database schemas, defining constraints, enforcing referential integrity, and building enterprise models.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-11-python-sql-pipeline-prep](./week-3/day-11-python-sql-pipeline-prep) | Python-to-SQL pipeline preparation, parameterization, and connection handling. | Pipeline prep scripts |
| 📁 [day-12-relationships-foreign-keys](./week-3/day-12-relationships-foreign-keys) | Modeling `1:1` and `1:N` table relationships, `FOREIGN KEY` constraints, and cascades. | Schema design scripts |
| 📁 [day-13-relationships-intensive](./week-3/day-13-relationships-intensive) | Junction tables, `M:N` (many-to-many) relationship implementations, and complex `JOIN`s. | Advanced schema scripts |
| 📁 [day-14-database-design-challenge](./week-3/day-14-database-design-challenge) | Real-world schema design challenges, entity normalization, and constraint strategy. | Design challenges |
| 📁 [day-15-advanced-relationships](./week-3/day-15-advanced-relationships) | SaaS Platform Database Project — multi-tenant schema with strict constraints and business reports. | SaaS database project |

---

### Week 4: Operations, Maintenance & Capstone System
Database maintenance operations, transactions, schema evolution, views, performance indexing, and the end-to-end management capstone.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-16-sql-data-maintenance](./week-4/day-16-sql-data-maintenance) | Data maintenance: Safe `UPDATE`s, Soft vs. Hard Deletes (`is_active`), `COALESCE` for `NULL` handling, `CASE WHEN` logic. | Maintenance SQL |
| 📁 [day-17-schema-views-transactions](./week-4/day-17-schema-views-transactions) | `ALTER TABLE` schema evolution, virtual database `VIEW`s, ACID transactions (`BEGIN`/`COMMIT`), and B-tree indexing. | Views & Transactions |
| 🏆 [training-program-management-system](./week-4/training-program-management-system) | **Capstone Project**: Full-featured Training Program Management System with database creation, views, indexing, and comprehensive SQL operations. | Capstone system |

---

### Week 5: Advanced Data Engineering & Specialization
Deep-dive into specialized data engineering topics, advanced data cleaning techniques, and emerging patterns.

| Module | Description | Core Artifacts |
| :--- | :--- | :--- |
| 📁 [day-19-data-cleaning](./week-5/day-19-data-cleaning) | Advanced data cleaning strategies, handling edge cases, data validation frameworks, and quality assurance patterns. | Data cleaning suite |

---

## 🌟 Key Projects & Highlights

### 1. 🥇 Medallion Architecture Data Pipeline ([Week 2 / Day 10](./week-2/day-10-bronze-silver-gold-pipeline))
- **Bronze Layer**: Raw CSV ingestion preserving raw state and tracking original input format.
- **Silver Layer**: Data cleansing, type coercion, null value resolution, and standardization.
- **Gold Layer**: Business aggregation layer preparing analytical metrics and executive dashboards.
- **Production-Ready**: Includes error handling, data quality reports, and transformative logging.

### 2. 🏛️ SaaS Platform Database Project ([Week 3 / Day 15](./week-3/day-15-advanced-relationships))
- Normalized database schema protecting data integrity with `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, and `CHECK` constraints.
- Multi-tenant support with proper isolation and security considerations.
- Optimized join performance and comprehensive analytical reports.

### 3. 🎓 Training Program Management System Capstone ([Week 4 Capstone](./week-4/training-program-management-system))
- Complete enterprise database solution for managing programs, courses, instructors, students, and enrollments.
- Includes automated setup scripts, seed data generation, comprehensive views, and performance indexing.
- Demonstrates real-world database administration and operational concerns.

### 4. 🧹 Advanced Data Cleaning Suite ([Week 5 / Day 19](./week-5/day-19-data-cleaning))
- Specialized data cleaning and validation frameworks for handling complex datasets.
- Edge case handling and quality assurance patterns for production environments.

---

## 🛠️ Tech Stack & Key Concepts

### Languages & Tools
- **Programming**: Python 3.x (File handling, CSV parsing, data structures, data validation, error handling)
- **Relational Databases**: SQL (PostgreSQL, SQLite)
- **Database Tools**: DDL (Data Definition Language), DML (Data Manipulation Language), Query Optimization

### Data Engineering Concepts
- **Architecture Patterns**:
  - Medallion Architecture (Bronze / Silver / Gold layers)
  - Multi-tenant SaaS database design
  - ACID compliance and transaction management
  
- **Data Quality & Validation**:
  - Data cleansing & standardization
  - Quality reporting and anomaly detection
  - Constraint enforcement and referential integrity
  
- **Database Design**:
  - Schema normalization (1NF, 2NF, 3NF, BCNF)
  - Constraint enforcement (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `UNIQUE`)
  - Entity-relationship modeling and cardinality
  
- **Performance & Optimization**:
  - B-tree indexing strategies
  - Query optimization and execution plans
  - View materialization and reporting
  
- **Operations & Maintenance**:
  - Hard and soft delete strategies
  - NULL handling with `COALESCE` and `CASE WHEN`
  - Schema evolution and `ALTER TABLE` operations
  - Transaction management (`BEGIN`, `COMMIT`, `ROLLBACK`)

---

## 🚀 Getting Started

### Prerequisites
- **Python**: Version 3.8 or higher installed
- **Database**: SQLite3 (built-in with Python) or PostgreSQL
- **Git**: For cloning the repository

### Running Python Data Pipelines
Navigate to any pipeline directory and run the main entry point:

```bash
# Example: Running the Week 1 CSV Cleaning Pipeline
cd week-1/day-2-practice
python csv_pipeline.py

# Example: Running the Week 2 Medallion Pipeline
cd week-2/day-10-bronze-silver-gold-pipeline
python pipeline.py

# Example: Running Week 5 Data Cleaning Utilities
cd week-5/day-19-data-cleaning
python data_cleaning.py
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

# Example: Running SaaS Database Project
cd week-3/day-15-advanced-relationships
sqlite3 saas_db.sqlite < schema.sql
sqlite3 saas_db.sqlite < seed_data.sql
```

### Project-Specific Instructions
Refer to individual `README.md` files within each module directory for detailed setup, dependencies, and execution instructions.

---

## 📁 Repository Structure

```text
data-engineering-training/
├── README.md                                  # Root Documentation & Navigation
├── .gitignore                                 # Git ignore rules
│
├── week-1/                                    # Python & SQL Foundations
│   ├── monday-practice/                       # Python Environment & Basics
│   ├── day-2-practice/                        # CSV Cleaning Pipeline & Reports
│   ├── day-3-sql-foundations/                 # Basic SQL Syntax & Aggregations
│   ├── day-4-python-sql-review/               # Python + SQL Database Basics
│   └── day-5-friday-data-sprint/              # Week 1 Sprint Project
│
├── week-2/                                    # Pipelines & Medallion Architecture
│   ├── day-6-sql-business-reporting/          # Business Reporting Queries
│   ├── day-7-sql-detective-day/               # Data Quality Debugging
│   ├── day-8-python-data-logic-sprint-heavy/  # Advanced Data Transformations
│   ├── day-9-csv-data-pipeline/               # Production CSV Pipeline
│   └── day-10-bronze-silver-gold-pipeline/    # Medallion Architecture Pipeline
│
├── week-3/                                    # Relational Database Modeling
│   ├── day-11-python-sql-pipeline-prep/       # Python-SQL Bridge
│   ├── day-12-relationships-foreign-keys/     # 1:1 and 1:N Schema Design
│   ├── day-13-relationships-intensive/        # Junction Tables & M:N Modeling
│   ├── day-14-database-design-challenge/      # Real-World ERD Exercises
│   └── day-15-advanced-relationships/         # SaaS Platform Database System
│
├── week-4/                                    # Maintenance, Views & Capstone
│   ├── day-16-sql-data-maintenance/           # Soft Deletes, COALESCE & CASE WHEN
│   ├── day-17-schema-views-transactions/      # Schema Evolution, Views, Indexing
│   └── training-program-management-system/    # Capstone Database Management System
│
└── week-5/                                    # Advanced Data Engineering
    └── day-19-data-cleaning/                  # Advanced Data Cleaning & QA
```

---

## 📖 Learning Path & Progression

1. **Foundation (Week 1)**: Build core Python and SQL competencies
2. **Pipeline Architecture (Week 2)**: Master medallion architecture and data transformation
3. **Database Design (Week 3)**: Learn enterprise-grade schema design and normalization
4. **Operations & Capstone (Week 4)**: Execute comprehensive database administration
5. **Specialization (Week 5)**: Deep-dive into advanced data engineering patterns

Each week builds upon previous concepts, progressing from simple scripts to production-grade systems.

---

## 🎯 Learning Outcomes

Upon completing this training program, you will be able to:

- ✅ Write efficient Python scripts for data processing and pipeline automation
- ✅ Design and execute complex SQL queries for analytics and reporting
- ✅ Architect multi-layer data pipelines using medallion patterns
- ✅ Model relational databases with proper normalization and constraints
- ✅ Implement ACID-compliant transactions and maintain data integrity
- ✅ Optimize database performance with indexing and query tuning
- ✅ Manage enterprise database systems with automated operations
- ✅ Apply advanced data cleaning and quality assurance techniques

---

## 👨‍💻 Author & Acknowledgments

- **Repository Owner**: Ensar Aliu
- **Program**: Comprehensive Data Engineering Training Course
- **Created**: July 2026
- Developed with best practices for scalable data pipelines, enterprise database engineering, and production-grade data systems.

---

## 📞 Support & Questions

For issues, questions, or feedback about the training materials:
1. Check the `README.md` file in the specific week/module directory
2. Review inline comments in code files for implementation details
3. Open a GitHub issue for bug reports or suggestions

---

**Happy Learning! 🚀 Let's build some amazing data engineering solutions together!**
