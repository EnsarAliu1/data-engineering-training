import csv
import os
from datetime import datetime

# =============================================================================
# PART 2 — Full Python Pipeline
# Bronze --> Silver --> Gold
# =============================================================================


# -------------------------
# Section 1: Loading Data
# -------------------------
# These functions read the raw CSV files from the Bronze folder.
# load_csv is the generic one. The three below it are just shortcuts
# so the rest of the code stays readable.

def load_csv(file_path):
    with open(file_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        return list(reader)


def load_orders():
    return load_csv("week-3/day-11-python-sql-pipeline-prep/data/bronze/orders_raw.csv")


def load_customers():
    return load_csv("week-3/day-11-python-sql-pipeline-prep/data/bronze/customers_raw.csv")


def load_products():
    return load_csv("week-3/day-11-python-sql-pipeline-prep/data/bronze/products_raw.csv")


# -------------------------
# Section 2: Normalization
# -------------------------
# These functions take a messy value and return a clean, consistent version.
# For example "Completed", "done", and "completed" all become "completed".

def normalize_status(status):
    # We lower-case first so the comparison is always fair
    cleaned = status.strip().lower() if status else ""

    status_map = {
        "completed": "completed",
        "done":      "completed",   # "done" means the same thing
        "cancelled": "cancelled",
        "canceled":  "cancelled",   # US spelling with one L
        "pending":   "pending",
        "returned":  "returned",
    }

    return status_map.get(cleaned, "unknown")


def normalize_city(city):
    # .title() turns "prishtina" into "Prishtina" and "VUSHTRRI" into "Vushtrri"
    cleaned = city.strip().title() if city else ""
    return cleaned if cleaned else "Unknown"


def normalize_channel(channel):
    # Per the spec: online, store, web, and bank are all kept as valid values.
    # Anything else (including blank) becomes "unknown".
    cleaned = channel.strip().lower() if channel else ""

    valid_channels = {"online", "store", "web", "bank"}

    if cleaned in valid_channels:
        return cleaned
    return "unknown"


def normalize_quantity(quantity):
    # Must be a whole number and must be greater than zero.
    try:
        qty = int(quantity)
        return qty if qty > 0 else None
    except (ValueError, TypeError):
        return None


def normalize_price(price):
    # Price must be a positive number. We keep it as a float for accuracy.
    try:
        p = float(price)
        return p if p > 0 else None
    except (ValueError, TypeError):
        return None


def normalize_category(category):
    cleaned = category.strip() if category else ""
    return cleaned if cleaned else "Unknown"


# -------------------------
# Section 3: Lookup Tables
# -------------------------
# Instead of looping through the customers or products list every time,
# we build a dictionary (a lookup table) so we can find a row instantly
# just by its ID. Much faster and much cleaner.

def build_lookup_table(rows, key_field):
    lookup = {}
    for row in rows:
        key = row.get(key_field, "").strip()
        if key:
            lookup[key] = row
    return lookup


# -------------------------
# Section 4: Validation
# -------------------------
# This function finds any order_id that appears more than once.
# Duplicate orders are a sign something went wrong (e.g. double submission).

def get_duplicate_order_ids(orders):
    seen = set()
    duplicates = set()
    for order in orders:
        order_id = order.get("order_id", "").strip()
        if order_id:
            if order_id in seen:
                duplicates.add(order_id)
            else:
                seen.add(order_id)
    return duplicates


# -------------------------
# Section 5: Silver Layer
# -------------------------
# This is where the real work happens. We go through every raw order,
# check it against all our rules, and sort it into either "clean" or "invalid".
# Clean orders also get enriched with customer and product information.

def create_silver_orders(orders, customers, products):
    customers_lookup = build_lookup_table(customers, "customer_id")
    products_lookup = build_lookup_table(products,  "product_id")
    duplicate_ids = get_duplicate_order_ids(orders)

    clean_orders = []
    invalid_orders = []

    for order in orders:
        order_id = order.get("order_id",    "").strip()
        customer_id = order.get("customer_id", "").strip()
        product_id = order.get("product_id",  "").strip()

        # --- Rule: order_id must exist ---
        if not order_id:
            order["invalid_reason"] = "missing_order_id"
            invalid_orders.append(order)
            continue

        # --- Rule: no duplicate order_ids ---
        if order_id in duplicate_ids:
            order["invalid_reason"] = "duplicate_order_id"
            invalid_orders.append(order)
            continue

        # --- Rule: customer_id must exist in the customers file ---
        if not customer_id or customer_id not in customers_lookup:
            order["invalid_reason"] = "invalid_customer_id"
            invalid_orders.append(order)
            continue

        # --- Rule: product_id must exist in the products file ---
        if not product_id or product_id not in products_lookup:
            order["invalid_reason"] = "invalid_product_id"
            invalid_orders.append(order)
            continue

        # --- Rule: quantity must exist, be numeric, and be greater than 0 ---
        qty = normalize_quantity(order.get("quantity"))
        if qty is None:
            order["invalid_reason"] = "invalid_quantity"
            invalid_orders.append(order)
            continue

        # --- Rule: order_date must not be missing ---
        order_date = order.get("order_date", "").strip()
        if not order_date:
            order["invalid_reason"] = "missing_order_date"
            invalid_orders.append(order)
            continue

        # --- Rule: status must normalize to a known value ---
        status = normalize_status(order.get("status", ""))
        if status == "unknown":
            order["invalid_reason"] = "invalid_status"
            invalid_orders.append(order)
            continue

        # All checks passed — enrich the order with customer and product data
        customer = customers_lookup[customer_id]
        product = products_lookup[product_id]

        price = normalize_price(product.get("price"))
        category = normalize_category(product.get("category"))
        city = normalize_city(customer.get("city"))

        enriched = {
            "order_id":      order_id,
            "customer_id":   customer_id,
            "customer_name": customer.get("customer_name", ""),
            "city":          city,
            "segment":       customer.get("segment", ""),
            "product_id":    product_id,
            "product_name":  product.get("product_name", ""),
            "category":      category,
            "quantity":      qty,
            "price":         price,
            "status":        status,
            "order_date":    order_date,
            "channel":       normalize_channel(order.get("channel", "")),
            "total_amount":  round(qty * price, 2),
        }
        clean_orders.append(enriched)

    return clean_orders, invalid_orders


# -------------------------
# Section 6: Gold Layer
# -------------------------
# These functions summarise the clean orders into business-ready reports.
# Only completed orders count toward revenue — pending and cancelled do not.

def get_revenue_by_city(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            city = order["city"]
            amount = float(order["total_amount"])
            if city not in data:
                data[city] = {"completed_revenue": 0,
                              "total_completed_orders": 0}
            data[city]["completed_revenue"] += amount
            data[city]["total_completed_orders"] += 1

    result = []
    for city, metrics in data.items():
        result.append({
            "city":                    city,
            "completed_revenue":       round(metrics["completed_revenue"], 2),
            "total_completed_orders":  metrics["total_completed_orders"],
        })
    # Sort by revenue, highest first
    return sorted(result, key=lambda x: x["completed_revenue"], reverse=True)


def get_revenue_by_category(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            cat = order["category"]
            amount = float(order["total_amount"])
            if cat not in data:
                data[cat] = {"completed_revenue": 0,
                             "total_completed_orders": 0}
            data[cat]["completed_revenue"] += amount
            data[cat]["total_completed_orders"] += 1

    result = []
    for cat, metrics in data.items():
        result.append({
            "category":                cat,
            "completed_revenue":       round(metrics["completed_revenue"], 2),
            "total_completed_orders":  metrics["total_completed_orders"],
        })
    return sorted(result, key=lambda x: x["completed_revenue"], reverse=True)


def get_top_customers(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            cid = order["customer_id"]
            name = order["customer_name"]
            amt = float(order["total_amount"])
            if cid not in data:
                data[cid] = {"customer_name": name,
                             "completed_orders": 0, "total_spent": 0}
            data[cid]["completed_orders"] += 1
            data[cid]["total_spent"] += amt

    result = []
    for cid, metrics in data.items():
        result.append({
            "customer_id":       cid,
            "customer_name":     metrics["customer_name"],
            "completed_orders":  metrics["completed_orders"],
            "total_spent":       round(metrics["total_spent"], 2),
        })
    return sorted(result, key=lambda x: x["total_spent"], reverse=True)


# -------------------------
# Section 7: Writing Files
# -------------------------
# These functions take our data and save it to the right output folder.
# write_csv is the generic helper. The rest call it with the right path and columns.

def write_csv(file_path, rows, fieldnames):
    # Make sure the folder exists before trying to write into it
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            # Only write the columns we asked for, ignore any extras
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def write_silver_orders(clean_orders):
    path = "week-3/day-11-python-sql-pipeline-prep/data/silver/orders_clean.csv"
    columns = [
        "order_id", "customer_id", "customer_name", "city", "segment",
        "product_id", "product_name", "category", "quantity", "price",
        "status", "order_date", "channel", "total_amount",
    ]
    write_csv(path, clean_orders, columns)
    print(f"  Saved {len(clean_orders)} clean orders  -->  {path}")


def write_invalid_orders(invalid_orders):
    path = "week-3/day-11-python-sql-pipeline-prep/data/silver/invalid_orders.csv"
    # The raw order columns plus our reason column at the end
    columns = [
        "order_id", "customer_id", "product_id", "quantity",
        "status", "order_date", "channel", "invalid_reason",
    ]
    write_csv(path, invalid_orders, columns)
    print(f"  Saved {len(invalid_orders)} invalid orders  -->  {path}")


def write_revenue_by_city(revenue_by_city):
    path = "week-3/day-11-python-sql-pipeline-prep/data/gold/revenue_by_city.csv"
    columns = ["city", "completed_revenue", "total_completed_orders"]
    write_csv(path, revenue_by_city, columns)
    print(f"  Saved revenue_by_city  -->  {path}")


def write_revenue_by_category(revenue_by_category):
    path = "week-3/day-11-python-sql-pipeline-prep/data/gold/revenue_by_category.csv"
    columns = ["category", "completed_revenue", "total_completed_orders"]
    write_csv(path, revenue_by_category, columns)
    print(f"  Saved revenue_by_category  -->  {path}")


def write_top_customers(top_customers):
    path = "week-3/day-11-python-sql-pipeline-prep/data/gold/top_customers.csv"
    columns = ["customer_id", "customer_name",
               "completed_orders", "total_spent"]
    write_csv(path, top_customers, columns)
    print(f"  Saved top_customers  -->  {path}")


def write_executive_summary(clean_orders, invalid_orders, revenue_by_city,
                            revenue_by_category, top_customers):
    path = "week-3/day-11-python-sql-pipeline-prep/data/gold/executive_summary.txt"
    os.makedirs(os.path.dirname(path), exist_ok=True)

    # Calculate the headline numbers
    total_raw = len(clean_orders) + len(invalid_orders)
    total_valid = len(clean_orders)
    total_invalid = len(invalid_orders)
    completed_orders = [o for o in clean_orders if o["status"] == "completed"]
    total_revenue = sum(float(o["total_amount"]) for o in completed_orders)
    top_city = revenue_by_city[0] if revenue_by_city else None
    top_cat = revenue_by_category[0] if revenue_by_category else None
    top_customer = top_customers[0] if top_customers else None

    lines = []
    lines.append("=" * 60)
    lines.append("  EXECUTIVE SUMMARY")
    lines.append("=" * 60)
    lines.append("")
    lines.append("PIPELINE RUN OVERVIEW")
    lines.append("-" * 40)
    lines.append(f"  Total raw orders received:   {total_raw}")
    lines.append(f"  Orders that passed checks:   {total_valid}")
    lines.append(f"  Orders that failed checks:   {total_invalid}")
    lines.append(f"  Completed orders:            {len(completed_orders)}")
    lines.append("")
    lines.append("REVENUE SUMMARY")
    lines.append("-" * 40)
    lines.append(f"  Total completed revenue:     ${total_revenue:,.2f}")
    lines.append("")

    if top_city:
        lines.append("TOP PERFORMING CITY")
        lines.append("-" * 40)
        lines.append(f"  City:             {top_city['city']}")
        lines.append(
            f"  Revenue:          ${float(top_city['completed_revenue']):,.2f}")
        lines.append(
            f"  Completed orders: {top_city['total_completed_orders']}")
        lines.append("")

    if top_cat:
        lines.append("TOP PERFORMING CATEGORY")
        lines.append("-" * 40)
        lines.append(f"  Category:         {top_cat['category']}")
        lines.append(
            f"  Revenue:          ${float(top_cat['completed_revenue']):,.2f}")
        lines.append(
            f"  Completed orders: {top_cat['total_completed_orders']}")
        lines.append("")

    if top_customer:
        lines.append("TOP CUSTOMER")
        lines.append("-" * 40)
        lines.append(f"  Name:             {top_customer['customer_name']}")
        lines.append(
            f"  Total spent:      ${float(top_customer['total_spent']):,.2f}")
        lines.append(f"  Completed orders: {top_customer['completed_orders']}")
        lines.append("")

    lines.append("INVALID ORDER BREAKDOWN")
    lines.append("-" * 40)
    reason_counts = {}
    for order in invalid_orders:
        reason = order.get("invalid_reason", "unknown")
        reason_counts[reason] = reason_counts.get(reason, 0) + 1
    for reason, count in sorted(reason_counts.items()):
        lines.append(f"  {reason:<30} {count} order(s)")
    lines.append("")
    lines.append("=" * 60)
    lines.append("  End of report")
    lines.append("=" * 60)

    with open(path, mode="w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    print(f"  Saved executive_summary  -->  {path}")


# -------------------------
# Section 8: Main
# -------------------------
# This is the entry point. When you run "python pipeline.py" from the terminal,
# Python starts here. It calls every function in the right order so the full
# pipeline runs from Bronze all the way to Gold in one go.

def main():
    print()
    print("=" * 60)
    print("  PIPELINE START")
    print("=" * 60)

    # Step 1 — Load the raw Bronze files
    print()
    print("Step 1: Loading Bronze data...")
    orders = load_orders()
    customers = load_customers()
    products = load_products()
    print(
        f"  Loaded {len(orders)} orders, {len(customers)} customers, {len(products)} products")

    # Step 2 — Clean and validate, then write Silver outputs
    print()
    print("Step 2: Creating Silver layer...")
    clean_orders, invalid_orders = create_silver_orders(
        orders, customers, products)
    write_silver_orders(clean_orders)
    write_invalid_orders(invalid_orders)

    # Step 3 — Aggregate and write Gold outputs
    print()
    print("Step 3: Creating Gold layer...")
    revenue_by_city = get_revenue_by_city(clean_orders)
    revenue_by_category = get_revenue_by_category(clean_orders)
    top_customers = get_top_customers(clean_orders)

    write_revenue_by_city(revenue_by_city)
    write_revenue_by_category(revenue_by_category)
    write_top_customers(top_customers)
    write_executive_summary(
        clean_orders, invalid_orders,
        revenue_by_city, revenue_by_category, top_customers
    )

    # Done!
    print()
    print("=" * 60)
    print("  PIPELINE COMPLETE — all Silver and Gold files written.")
    print("=" * 60)
    print()


if __name__ == "__main__":
    main()
