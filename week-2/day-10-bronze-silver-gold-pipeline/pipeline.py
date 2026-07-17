import csv

# PART 1

# Read orders_raw.csv, customers_raw.csv, and products_raw.csv from data/bronze/.


def load_csv(file_path):
    with open(file_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        return list(reader)


def load_orders():
    return load_csv("week-2/day-10-bronze-silver-gold-pipeline/data/bronze/orders_raw.csv")


def load_customers():
    return load_csv("week-2/day-10-bronze-silver-gold-pipeline/data/bronze/customers_raw.csv")


def load_products():
    return load_csv("week-2/day-10-bronze-silver-gold-pipeline/data/bronze/products_raw.csv")


# PART 2
# Normalize status: completed, Completed, complete, done -> completed; cancelled, canceled -> cancelled; pending -> pending.

def normalize_status(status):
    status = status.strip().lower()

    status_map = {
        "completed": "completed",
        "complete": "completed",
        "done": "completed",
        "cancelled": "cancelled",
        "canceled": "cancelled",
        "pending": "pending"
    }

    return status_map.get(status, "Unknown")


# Normalize channel: online, Online, web, mobile -> online; store, Store -> store; missing channel -> unknown.

def normalize_channel(channel):
    channel_cleaned = channel.strip().lower()

    channel_map = {
        "online": "online",
        "web": "online",
        "mobile": "online",
        "store": "store",
        "": "unknown"
    }

    return channel_map.get(channel_cleaned, "unknown")

# Normalize city names: prishtina -> Prishtina, VUSHTRRI -> Vushtrri, missing city -> Unknown.


def normalize_city(city):
    city_cleaned = city.strip().title()
    if city_cleaned == "":
        return "Unknown"

    city_map = {
        "Prishtina": "Prishtina",
        "Vushtrri": "Vushtrri"
    }

    return city_map.get(city_cleaned, city_cleaned)


# Order quantity must be a positive integer.


def normalize_quantity(quantity):
    try:
        quantity = int(quantity)

        if quantity > 0:
            return quantity
        else:
            return None
    except (ValueError, TypeError):
        return None


# Order date must exist. You do not need to fully standardize every date format today, but missing dates are invalid.

def normalize_date(order_date):
    if order_date.strip() == "":
        return "unknown"
    return order_date


# customer_id must exist in clean customers.


def normalize_customer_id(customer_id):
    if customer_id.strip() == "":
        return "unknown"
    return customer_id


# product_id must exist in clean products.
def normalize_product_id(product_id):
    if product_id.strip() == "":
        return "unknown"
    return product_id

# Duplicate order_id should be invalid.


def get_duplicate_order_ids(orders):
    seen = set()
    duplicates = set()
    for order in orders:
        order_id = order.get("order_id")
        if order_id:
            if order_id in seen:
                duplicates.add(order_id)
            else:
                seen.add(order_id)
    return duplicates


# Product price must be a positive number.


def normalize_price(price):
    try:
        price = int(price)

        if price > 0:
            return price
        else:
            return None
    except (ValueError, TypeError):
        return None

# Missing product category should become Unknown.


def normalize_category(category):
    if category.strip() == "":
        return "Unknown"
    else:
        return category


# Silver enrichment

def build_lookup_table(rows, key_field):
    lookup = {}

    for row in rows:
        lookup[row[key_field]] = row

    return lookup


def clean_customers(customers):
    seen = set()
    clean = []
    missing_cities_count = 0
    for c in customers:
        cust_id = c.get("customer_id", "").strip()
        if not cust_id:
            continue
        if cust_id in seen:
            continue
        seen.add(cust_id)

        city = c.get("city", "").strip()
        if not city:
            missing_cities_count += 1

        clean.append({
            "customer_id": cust_id,
            "customer_name": c.get("customer_name", "").strip(),
            "city": normalize_city(city)
        })
    return clean, missing_cities_count


def clean_products(products):
    seen = set()
    clean = []
    invalid_prices_count = 0
    for p in products:
        prod_id = p.get("product_id", "").strip()
        if not prod_id:
            continue
        if prod_id in seen:
            continue
        
        price = normalize_price(p.get("price", ""))
        if price is None:
            invalid_prices_count += 1
            continue
            
        seen.add(prod_id)
        clean.append({
            "product_id": prod_id,
            "product_name": p.get("product_name", "").strip(),
            "category": normalize_category(p.get("category", "")),
            "price": price
        })
    return clean, invalid_prices_count


def silver_enrichment(orders, customers, products):
    customers_lookup = build_lookup_table(customers, "customer_id")
    products_lookup = build_lookup_table(products, "product_id")

    duplicate_ids = get_duplicate_order_ids(orders)

    clean_orders = []
    invalid_orders = []

    for order in orders:
        order_id = order.get("order_id", "").strip()
        customer_id = order.get("customer_id", "").strip()
        product_id = order.get("product_id", "").strip()

        if not order_id:
            order["reason"] = "missing_order_id"
            invalid_orders.append(order)
            continue
        if order_id in duplicate_ids:
            order["reason"] = "duplicate_order_id"
            invalid_orders.append(order)
            continue

        if not customer_id or customer_id not in customers_lookup:
            order["reason"] = "invalid_customer_id"
            invalid_orders.append(order)
            continue

        if not product_id or product_id not in products_lookup:
            order["reason"] = "invalid_product_id"
            invalid_orders.append(order)
            continue

        qty = normalize_quantity(order.get("quantity"))
        if qty is None:
            order["reason"] = "invalid_quantity"
            invalid_orders.append(order)
            continue

        order_date = order.get("order_date", "").strip()
        if not order_date:
            order["reason"] = "missing_order_date"
            invalid_orders.append(order)
            continue

        status = normalize_status(order.get("status"))
        if status == "Unknown":
            order["reason"] = "invalid_status"
            invalid_orders.append(order)
            continue

        customer = customers_lookup[customer_id]
        product = products_lookup[product_id]

        price = normalize_price(product.get("price"))
        category = normalize_category(product.get("category"))
        city = normalize_city(customer.get("city"))

        enriched = {
            "order_id": order_id,
            "customer_id": customer_id,
            "customer_name": customer.get("customer_name"),
            "city": city,
            "product_id": product_id,
            "product_name": product.get("product_name"),
            "category": category,
            "quantity": qty,
            "price": price,
            "total_amount": qty * price,  # Calculate total amount
            "status": status,
            "channel": normalize_channel(order.get("channel")),
            "order_date": order_date
        }
        clean_orders.append(enriched)

    return clean_orders, invalid_orders
# Part 3 - Gold layer: business-ready reports


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
            "category": cat,
            "completed_revenue": round(metrics["completed_revenue"], 2),
            "total_completed_orders": metrics["total_completed_orders"]
        })
    return result


def get_revenue_by_city(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            city = order["city"]
            amount = int(order["total_amount"])
            if city not in data:
                data[city] = {"completed_revenue": 0,
                              "total_completed_orders": 0}
            data[city]["completed_revenue"] += amount
            data[city]["total_completed_orders"] += 1

    result = []
    for city, metrics in data.items():
        result.append({
            "city": city,
            "completed_revenue": round(metrics["completed_revenue"], 2),
            "total_completed_orders": metrics["total_completed_orders"]
        })
    return result


def get_revenue_by_customer(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            name = order["customer_name"]
            city = order["city"]
            amount = int(order["total_amount"])
            if name not in data:
                data[name] = {"city": city, "completed_revenue": 0,
                              "total_completed_orders": 0}
            data[name]["completed_revenue"] += amount
            data[name]["total_completed_orders"] += 1

    result = []
    for name, metrics in data.items():
        result.append({
            "customer_name": name,
            "city": metrics["city"],
            "completed_revenue": round(metrics["completed_revenue"], 2),
            "total_completed_orders": metrics["total_completed_orders"]
        })
    return result


def get_top_products(clean_orders):
    data = {}
    for order in clean_orders:
        if order["status"] == "completed":
            prod_name = order["product_name"]
            cat = order["category"]
            qty = int(order["quantity"])
            amount = int(order["total_amount"])
            if prod_name not in data:
                data[prod_name] = {
                    "category": cat, "total_quantity_sold": 0, "completed_revenue": 0}
            data[prod_name]["total_quantity_sold"] += qty
            data[prod_name]["completed_revenue"] += amount

    result = []
    for prod_name, metrics in data.items():
        result.append({
            "product_name": prod_name,
            "category": metrics["category"],
            "total_quantity_sold": metrics["total_quantity_sold"],
            "completed_revenue": round(metrics["completed_revenue"], 2)
        })

    result = sorted(result, key=lambda x: x["completed_revenue"], reverse=True)
    return result


def write_executive_summary(clean_orders, invalid_orders):
    valid_silver = len(clean_orders)
    total_invalid = len(invalid_orders)
    total_raw = valid_silver + total_invalid

    completed_orders = 0
    pending_orders = 0
    cancelled_orders = 0
    completed_revenue = 0

    for o in clean_orders:
        status = o["status"]
        if status == "completed":
            completed_orders += 1
            completed_revenue += float(o["total_amount"])
        elif status == "pending":
            pending_orders += 1
        elif status == "cancelled":
            cancelled_orders += 1

    cat_data = get_revenue_by_category(clean_orders)
    city_data = get_revenue_by_city(clean_orders)
    cust_data = get_revenue_by_customer(clean_orders)
    prod_data = get_top_products(clean_orders)

    top_cat = "None"
    if cat_data:
        top_cat = sorted(cat_data, key=lambda x: x["completed_revenue"], reverse=True)[
            0]["category"]

    top_city = "None"
    if city_data:
        top_city = sorted(
            city_data, key=lambda x: x["completed_revenue"], reverse=True)[0]["city"]

    top_cust = "None"
    if cust_data:
        top_cust = sorted(cust_data, key=lambda x: x["completed_revenue"], reverse=True)[
            0]["customer_name"]

    top_prod = "None"
    if prod_data:
        top_prod = prod_data[0]["product_name"]

    reason_counts = {}
    for o in invalid_orders:
        reason = o.get("reason", "unknown")
        reason_counts[reason] = reason_counts.get(reason, 0) + 1

    most_common_reason = "None"
    if reason_counts:
        most_common_reason = sorted(
            reason_counts.items(), key=lambda x: x[1], reverse=True)[0][0]

    recommendations = (
        f"1. Focus marketing on the top category '{top_cat}' which drives the highest revenue.\n"
        f"2. Investigate the quality issue '{most_common_reason}' to improve bronze-silver pipeline health."
    )

    summary_path = "week-2/day-10-bronze-silver-gold-pipeline/data/gold/executive_summary.txt"
    with open(summary_path, "w", encoding="utf-8") as f:
        f.write("Executive Summary - Day 10 Pipeline\n")
        f.write("====================================\n")
        f.write(f"Total raw orders: {total_raw}\n")
        f.write(f"Valid silver orders: {valid_silver}\n")
        f.write(f"Invalid orders: {total_invalid}\n")
        f.write(f"Completed orders: {completed_orders}\n")
        f.write(f"Pending orders: {pending_orders}\n")
        f.write(f"Cancelled orders: {cancelled_orders}\n")
        f.write(f"Completed revenue: {completed_revenue:.2f}\n")
        f.write(f"Top category: {top_cat}\n")
        f.write(f"Top city: {top_city}\n")
        f.write(f"Top customer: {top_cust}\n")
        f.write(f"Top product: {top_prod}\n")
        f.write(f"Most common invalid reason: {most_common_reason}\n\n")
        f.write("Business recommendation:\n")
        f.write(recommendations)


def create_data_quality_report(raw_orders, clean_orders, invalid_orders, raw_customers, raw_products, invalid_prices, missing_cities):
    raw_count = len(raw_orders)
    clean_count = len(clean_orders)
    invalid_count = len(invalid_orders)

    is_equal = "YES" if (raw_count == clean_count + invalid_count) else "NO"

    reasons = {
        "duplicate_order_id": 0,
        "missing_order_date": 0,
        "invalid_quantity": 0,
        "invalid_status": 0,
        "invalid_product_id": 0,
        "invalid_customer_id": 0,
        "missing_order_id": 0
    }

    for o in invalid_orders:
        reason = o.get("reason", "")
        if reason in reasons:
            reasons[reason] += 1
        else:
            reasons[reason] = reasons.get(reason, 0) + 1

    report_path = "week-2/day-10-bronze-silver-gold-pipeline/data_quality_report.txt"
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("Validation Checks\n")
        f.write(f"Raw orders count: {raw_count}\n")
        f.write(f"Silver clean orders count: {clean_count}\n")
        f.write(f"Invalid orders count: {invalid_count}\n")
        f.write(f"Raw = Silver + Invalid: {is_equal}\n")
        f.write(f"Customer IDs checked: {len(raw_customers)}\n")
        f.write(f"Product IDs checked: {len(raw_products)}\n")
        f.write(f"Duplicate order IDs found: {reasons.get('duplicate_order_id', 0)}\n")
        f.write(f"Missing dates found: {reasons.get('missing_order_date', 0)}\n")
        f.write(f"Invalid quantities found: {reasons.get('invalid_quantity', 0)}\n")
        f.write(f"Invalid statuses found: {reasons.get('invalid_status', 0)}\n")
        f.write(f"Invalid products found: {reasons.get('invalid_product_id', 0)}\n")
        f.write(f"Invalid customers found: {reasons.get('invalid_customer_id', 0)}\n")
        f.write(f"Invalid product prices found: {invalid_prices}\n")
        f.write(f"Missing customer cities found: {missing_cities}\n")
        f.write("Invalid records by reason:\n")
        for reason, count in sorted(reasons.items()):
            f.write(f"  - {reason}: {count}\n")


def write_csv(file_path, rows, fieldnames):
    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            # This ensures only the requested columns are written
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def load_clean_orders():
    return load_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/orders_clean.csv")


def load_invalid_orders():
    return load_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/invalid_orders.csv")


def main():
    # Print how many raw records exist in each file.
    orders = load_orders()
    customers = load_customers()
    products = load_products()

    orders_count = len(orders)
    customers_count = len(customers)
    products_count = len(products)

    print(f"Order records: {orders_count}")
    print(f"Customers records: {customers_count}")
    print(f"Products records: {products_count}")

    # Check and print duplicate order IDs
    duplicates = get_duplicate_order_ids(orders)
    print(f"Duplicate order IDs: {duplicates}")

    # Clean customers and products
    clean_cust, missing_cities = clean_customers(customers)
    clean_prod, invalid_prices = clean_products(products)

    # Silver Enrichment
    clean_ord, invalid_ord = silver_enrichment(orders, clean_cust, clean_prod)

    # Write Silver layer outputs
    customers_fields = ["customer_id", "customer_name", "city"]
    products_fields = ["product_id", "product_name", "category", "price"]
    clean_orders_fields = [
        "order_id", "customer_id", "customer_name", "city",
        "product_id", "product_name", "category", "quantity",
        "price", "total_amount", "status", "channel", "order_date"
    ]
    invalid_orders_fields = [
        "order_id", "customer_id", "product_id",
        "order_date", "quantity", "status", "channel", "reason"
    ]

    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/customers_clean.csv",
              clean_cust, customers_fields)
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/products_clean.csv",
              clean_prod, products_fields)
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/orders_clean.csv",
              clean_ord, clean_orders_fields)
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/silver/invalid_orders.csv",
              invalid_ord, invalid_orders_fields)

    print("Silver tables written successfully.")

    # Load clean and invalid orders from the silver layer files
    clean_orders_loaded = load_clean_orders()
    invalid_orders_loaded = load_invalid_orders()

    # Write Gold layer outputs using the loaded silver clean orders
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/gold/revenue_by_category.csv",
              get_revenue_by_category(clean_orders_loaded), ["category", "completed_revenue", "total_completed_orders"])
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/gold/revenue_by_city.csv",
              get_revenue_by_city(clean_orders_loaded), ["city", "completed_revenue", "total_completed_orders"])
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/gold/revenue_by_customer.csv",
              get_revenue_by_customer(clean_orders_loaded), ["customer_name", "city", "completed_revenue", "total_completed_orders"])
    write_csv("week-2/day-10-bronze-silver-gold-pipeline/data/gold/top_products.csv",
              get_top_products(clean_orders_loaded), ["product_name", "category", "total_quantity_sold", "completed_revenue"])

    # Write Data Quality Report
    create_data_quality_report(orders, clean_ord, invalid_ord, customers, products, invalid_prices, missing_cities)

    # Write Executive Summary
    write_executive_summary(clean_orders_loaded, invalid_orders_loaded)
    print("Gold business reports written successfully.")


if __name__ == "__main__":
    main()
