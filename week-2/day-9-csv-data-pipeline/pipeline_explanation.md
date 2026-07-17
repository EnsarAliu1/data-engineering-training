Source Data:
Three raw CSV files in the `data/` folder: `customers_raw.csv` (customer profiles), `products_raw.csv` (product catalog), and `orders_raw.csv` (messy transactional records with missing values, inconsistent formatting, invalid quantities, and referential integrity violations).

Ingestion:
Read the raw files into Python using the built-in `csv` module, parsing row values into dictionary records.

Bronze layer:
Direct landing area representing raw, unprocessed data stored in-memory or logged as is, retaining all errors, blanks, and invalid schemas to maintain a historical audit trail.

Cleaning rules:
1. Capitalization: Standardize city names to Title Case (e.g., `prishtina` -> `Prishtina`, `VUSHTRRI` -> `Vushtrri`), and channels (`store`, `online`) and statuses (`completed`, `pending`, `cancelled`) to lowercase.
2. Value normalization: Map synonym status values like `complete` or `done` to `completed`.
3. Date parsing: Parse and convert all date variations (e.g., `2026/07/02` and `07-05-2026`) into a uniform `YYYY-MM-DD` format.

Validation rules:
1. Completeness: Ensure mandatory fields (`order_id`, `customer_id`, `product_id`, `order_date`, `quantity`, `status`, `channel`) are not empty.
2. Numeric sanity: Quantity must be a positive integer (> 0). Reject non-numeric values (e.g., `abc`) and negative values.
3. Allowed values: Channel must be one of `online` or `store`.
4. Referential integrity: Customer ID and Product ID must exist in their respective raw catalogs.

Silver layer:
Contains cleaned and validated data. Records that pass validation are written to `output/orders_clean.csv`. Rejected records are written to `output/invalid_orders.csv` along with their validation error reasons.

Transformation rules:
1. Enrichment: Join valid orders with customers (to retrieve `customer_name` and `city`) and products (to retrieve `product_name`, `category`, and `price`).
2. Calculated columns: Add `revenue` calculated as `quantity * price`.
3. Aggregations: Summarize total revenue and total orders grouped by customer, city, product category, and sales channel.

Gold layer:
Final reporting layer containing conformed aggregations ready for business analytics.

Business Output:
1. `output/business_summary.txt`: Summarizes key metrics (total revenue, order counts) and ranks performance by city, product category, channel, and top customer.
2. `output/data_quality_report.txt`: Audits pipeline processing with totals for raw, valid, and rejected records, including reasons for validation failures.

What makes this data trusted:
1. Strict domain constraint validation ensures math operations (revenue calculations) are accurate by excluding non-positive or non-numeric quantities.
2. Referential integrity enforcement prevents orphan records.
3. String normalization prevents group-by fragmentation during aggregations (e.g., merging "prishtina" and "Prishtina").
4. Complete auditability of pipeline actions using the error logs.
