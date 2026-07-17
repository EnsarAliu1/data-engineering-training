# Day 10 - Bronze / Silver / Gold Pipeline with Python

## Project goal
The goal of this project is to build a structured, 3-tier data pipeline (Medallion Architecture) in Python using raw transaction data. The pipeline loads raw data (Bronze), cleans and validates it to ensure integrity and consistency (Silver), and generates aggregated business reports and insights (Gold).

## Bronze layer
Stores the raw data as received from source systems without modification. This includes:
- `orders_raw.csv`: Unfiltered sales transactions with errors like duplicate order IDs, negative quantities, missing dates, and spelling variations.
- `customers_raw.csv`: Raw customer profile details with missing cities and unstandardized text.
- `products_raw.csv`: Raw product lists with invalid prices and categories.

Keeping these files untouched ensures we can always trace back to original source files and re-run the pipeline from scratch if our business logic changes.

## Silver layer
Applies data cleaning, type casting, validation, and enrichment:
- **Cleaning:** Standardizes city names (Title Case) and order statuses (e.g. mapping `done` or `complete` to `completed`) and removes duplicates.
- **Validation:** Filters out transactions with invalid quantities, missing dates, duplicate IDs, or missing references.
- **Enrichment:** Appends customer details, product categories, and calculates the `total_amount` (`quantity * price`).

Good records go to `orders_clean.csv`, while failed records are isolated into `invalid_orders.csv`.

## Gold layer
Houses the business-level aggregates and high-level summaries ready for dashboards and business intelligence:
- **Aggregated reports:** Grouped revenue tables by category, city, and customer, alongside top-performing products.
- **Executive Summary:** A final text report detailing total revenue, top products/cities, and data quality insights.

## How to run the pipeline
To run the full pipeline, navigate to this day's directory in your terminal and execute the Python script:
```bash
python pipeline.py
```

## Files generated
During pipeline execution, the following files are produced:
- **Silver:** `data/silver/customers_clean.csv`, `products_clean.csv`, `orders_clean.csv`, and `invalid_orders.csv`.
- **Gold:** `data/gold/revenue_by_category.csv`, `revenue_by_city.csv`, `revenue_by_customer.csv`, `top_products.csv`, and `executive_summary.txt`.
- **Quality Check:** `data_quality_report.txt` in the root folder.

## Data quality checks
The pipeline automatically runs audits after processing to verify data integrity:
- **Reconciliation Check:** Confirms that `Raw Orders (31)` = `Clean Orders (21)` + `Invalid Orders (10)`.
- **Reason Breakdown:** Tracks and counts exact failure reasons, with `invalid_quantity` identified as the most common issue.

## Business insights
Based on the Gold layer reports:
- **Top Product & Category:** Laptops are the best-performing product, making `Electronics` the highest revenue-generating category.
- **Top Location:** `Vushtrri` is our most profitable city.
- **Most Valuable Customer:** `Arta` generated the highest completed sales volume.

## What I can explain and defend
- **Medallion Architecture:** The logical separation of data processing concerns into Bronze (raw), Silver (cleaned/enriched), and Gold (aggregated business-level).
- **Referential Integrity:** Ensuring that order rows are invalid if their `customer_id` or `product_id` does not exist in the clean catalog tables.
- **Idempotency:** The pipeline can be rerun safely multiple times without creating duplicate records or appending redundant logs.

## What was difficult
- Handling mixed data types (such as prices written as text strings) and building a resilient conversion check to filter invalid prices without crashing the python runtime.
- Creating clean lookups for customer and product mapping in plain Python without using external libraries like Pandas.

## What I would improve next
- Integrate automated validation using library-based schema checks (like Pydantic) to simplify validation logic.
- Schedule the pipeline using orchestrators (e.g., cron or Airflow) for daily batch processing.
- Add detailed execution timestamps to the pipeline logs to monitor performance.
