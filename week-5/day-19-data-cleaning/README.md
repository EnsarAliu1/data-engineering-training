# Day 19: Data Cleaning, Validation & Quality Reporting

## Project Goal
Raw data is rarely ready for reporting as soon as it arrives. CSV files can contain inconsistent text casing, empty fields, duplicate IDs, invalid numeric values, and records that do not match the expected business rules. The goal of this project was to build a small but realistic data-cleaning pipeline that turns raw e-commerce data into trusted analytical datasets.

I used a Medallion-style flow:

```text
Bronze (raw CSV files) -> Silver (normalized and validated data) -> Gold (business-ready analytics)
                              \
                               -> Invalid (quarantined records with rejection reasons)
```

The pipeline keeps invalid records instead of silently dropping them. This makes the cleaning process traceable and gives the source-data owner a clear list of issues to fix.

---

## Source Data
The Bronze layer contains five raw CSV datasets:

* **`customers_raw.csv`** — customer identity, contact, location, registration date, and status.
* **`orders_raw.csv`** — customer orders, dates, order status, shipping city, and payment method.
* **`order_items_raw.csv`** — products, quantities, and unit prices for each order.
* **`payments_raw.csv`** — payment amount, currency, status, and payment method.
* **`products_raw.csv`** — product catalogue, category, price, stock, supplier, and status.

The data deliberately includes quality problems such as missing names, invalid emails, duplicate identifiers, missing payment methods, non-positive quantities, negative prices, invalid stock values, and incomplete supplier information.

---

## Pipeline Design
The entry point is `main.py`, which runs the pipeline in six clear steps:

1. Load the five Bronze CSV files into Python.
2. Normalize each record into a consistent structure.
3. Validate the normalized records and split them into valid and invalid groups.
4. Save valid records in the Silver layer.
5. Save rejected records in the Invalid layer together with a `rejection_reason`.
6. Build Gold-layer analytical reports from the valid data only.

Separating normalization from validation was important. Normalization makes values consistent where it is safe to do so, while validation decides whether a record is reliable enough to be used downstream.

---

## Normalization Rules
The normalizers in `src/normalizers.py` standardize values before validation:

* Text values are trimmed to remove accidental spaces.
* Customer names, cities, countries, product names, and categories are converted to title case.
* Email addresses and status values are converted to lowercase where appropriate.
* Payment currency is converted to uppercase, and common aliases such as `EURO` and `DOLLARS` are mapped to `EUR` and `USD`.
* IDs, quantities, stock values, prices, and payment amounts are converted into numeric types.
* Dates are checked against the expected `YYYY-MM-DD` format.
* Empty descriptive fields are represented as `Unknown` when that is useful for detecting missing information later.

This step reduces superficial differences in the raw data, for example treating ` Prishtina ` and `prishtina` as the same city value, without trying to guess or repair records that are structurally invalid.

---

## Validation and Quarantine
Each dataset has dedicated validation rules in `src/validators.py`. Records that pass are written to `data/silver`; records that fail are written to `data/invalid` with the specific reason for rejection.

Examples of checks implemented:

| Dataset | Main validation checks |
| --- | --- |
| Customers | Required ID and name, valid email format, valid status, and no duplicate customer ID |
| Orders | Required order/customer IDs, valid date and status, known shipping city and payment method, and no duplicate order ID |
| Order items | Required IDs, positive quantity and unit price, and no duplicate item ID |
| Payments | Required payment/order IDs, positive amount, allowed status/method, and no duplicate payment ID |
| Products | Required identifiers and descriptive fields, positive price, non-negative stock, valid supplier ID/status, and no duplicate product ID |

The quarantine output is not an error log only; it is a usable data-quality dataset. A rejected customer, order, payment, or product can be reviewed together with the original values and the reason it was excluded.

---

## Silver Layer
The Silver layer contains cleaned versions of all five source datasets:

* `customers_clean.csv`
* `orders_clean.csv`
* `order_items_clean.csv`
* `payments_clean.csv`
* `products_clean.csv`

Only records that pass the validation rules are written here. This means the Gold reports are built from a stable foundation instead of mixing trusted and untrusted records.

---

## Gold-Layer Analytics
I generated three business-ready CSV reports in `data/gold`:

1. **`customer_lifetime_value.csv`**
   * Combines customers, orders, and order items.
   * Calculates total orders, total spend, and average order value for every customer.
   * Sorts customers by total spend so higher-value customers can be identified quickly.

2. **`category_sales_performance.csv`**
   * Connects products to order items.
   * Aggregates total items sold and total revenue by product category.
   * Helps compare the commercial performance of categories such as laptops, monitors, and accessories.

3. **`shipping_city_sales_summary.csv`**
   * Groups valid orders and order-item revenue by shipping city.
   * Shows total order count and total revenue for each delivery location.

All revenue calculations use `quantity * unit_price`, which keeps the calculation close to the transaction-level data instead of relying on a pre-calculated total from the raw source.

---

## SQL Quality Checks and Business Reports
Alongside the Python pipeline, I prepared SQL scripts for checking and analysing loaded relational data.

### `quality_checks.sql`

This script checks for:

* Duplicate customer IDs and emails.
* Missing required customer fields.
* Orders without a matching customer.
* Order items without a matching product.
* Negative prices, invalid quantities, and unsupported statuses.
* Orders created in the future or without order items.
* Payments above the expected order amount.
* Products that have never been sold.

### `reconciliation_reports.sql`

The payment reconciliation report compares the expected order value with the payment amount and classifies each order as:

* `missing payment`
* `refunded`
* `matched`
* `underpaid`
* `overpaid`

This is a practical quality check because a clean-looking sales report can still be misleading if payments do not reconcile with order items.

### `business_reports.sql`

The business reporting queries provide revenue by customer, city, category, and product, along with lists of customers without orders, products never sold, and orders with payment issues.

---

## What I Can Explain Live

* Why data cleaning should preserve rejected records in a quarantine layer instead of deleting them permanently.
* The difference between normalization (making values consistent) and validation (checking whether values are acceptable).
* How duplicate IDs and referential-integrity checks protect downstream reports from double counting and orphan records.
* How the Bronze, Silver, and Gold layers separate raw ingestion, trusted operational data, and analytical output.
* How `LEFT JOIN`, `COALESCE`, `CASE WHEN`, `GROUP BY`, and aggregate functions support data-quality and reconciliation reports.
* Why revenue should be calculated from valid `quantity * unit_price` records before it is used in customer, category, or city reporting.
