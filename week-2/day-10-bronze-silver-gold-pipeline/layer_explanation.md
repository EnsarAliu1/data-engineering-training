## Bronze Layer

What files are stored in Bronze?

Bronze stores the raw CSV files for orders, customers, and products.

Why do we keep raw data unchanged?

We keep raw data unchanged because it is the original source of information. This helps us go back later, check what was received, and rebuild the pipeline if needed.

What problems did you notice in the raw data?

I noticed missing values, duplicate records, inconsistent status names, mixed date formats, and invalid values such as negative quantities and prices written as text.

Which data problems could break business reports if they are not cleaned?

These problems could break reports because they can make totals wrong, dates inconsistent, and joins between customers and products unreliable. Missing and invalid values can also cause incorrect revenue and sales analysis.

## Silver Layer

What cleaning rules did you apply?

- Normalized and standardized statuses (e.g. mapping `complete`, `done` to `completed`, and `canceled` to `cancelled`).
- Standardized city names to Title Case (e.g. `Prishtina`, `Vushtrri`).
- Deduplicated customer and product lists to ensure unique IDs.
- Validated values to ensure order quantities and product prices are positive numbers.
- Checked referential integrity to ensure that each order matches a valid customer and product.

Which records became invalid and why?

- Orders with duplicate order IDs, missing order dates, or non-positive quantities.
- Orders with invalid/unknown statuses.
- Orders referencing customer IDs or product IDs that were not found in our cleaned customer or product lookup tables.

What columns were added during enrichment?

- `customer_name` and `city` (retrieved from the clean customer database).
- `product_name` and `category` (retrieved from the clean product catalog).
- `total_amount` (calculated dynamically as `quantity * price` for each order).

Why is Silver safer than Bronze?

Silver is much safer because it guarantees clean, deduplicated, and fully validated data. It prevents calculations from breaking due to missing fields, formatting differences, or orphan references (like an order with a non-existent customer).

## Gold Layer

Which reports did you create?

- `revenue_by_category.csv`: Revenue and order counts grouped by product category.
- `revenue_by_city.csv`: Sales summary by customer city.
- `revenue_by_customer.csv`: Top spending customers and their cities.
- `top_products.csv`: Total quantities sold and revenue by product.

Which business questions do these reports answer?

- Which categories of products are performing best?
- Which locations generate the most revenue?
- Who are our top customers and where do they live?
- Which specific items are our best-sellers?

Why should dashboards use Gold outputs instead of raw Bronze data?

- **Query Speed:** Gold data is already aggregated, so charts load instantly instead of scanning millions of records.
- **Accuracy:** Gold reports only include validated, cleaned transactions, preventing dashboards from showing skewed or incorrect business numbers.
- **Consistency:** All dashboards and business teams query the same source of truth rather than writing custom cleaning filters themselves, which leads to conflicting numbers.
