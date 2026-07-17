import csv

# PART 2


def load_csv(file_path):
    with open(file_path, mode="r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        return list(reader)


def load_orders():
    return load_csv("week-2/day-9-csv-data-pipeline/data/orders_raw.csv")


def load_customers():
    return load_csv("week-2/day-9-csv-data-pipeline/data/customers_raw.csv")


def load_products():
    return load_csv("week-2/day-9-csv-data-pipeline/data/products_raw.csv")


# PART 3
def build_lookup_table(rows, key_field):
    lookup = {}

    for row in rows:
        lookup[row[key_field]] = row

    return lookup


# PART 4
def normalize_status(status):
    status = status.strip().lower()

    status_map = {
        "completed": "completed",
        "complete": "completed",
        "done": "completed",
        "pending": "pending",
        "cancelled": "cancelled",
        "canceled": "cancelled",
    }

    return status_map.get(status, "Unknown")


def normalize_city(city):
    city_cleaned = city.strip().title()

    city_map = {
        "Prishtina": "Prishtina",
        "Vushtrri": "Vushtrri"
    }

    return city_map.get(city_cleaned, city_cleaned)


def normalize_channel(channel):
    channel_cleaned = channel.strip().lower()

    channel_map = {
        "online": "online",
        "web": "online",
        "store": "store",
        "": "unknown"
    }

    return channel_map.get(channel_cleaned, "unknown")


# PART 5
def is_positive_integer(value):
    try:
        val_int = int(str(value).strip())
        return val_int > 0
    except (ValueError, TypeError):
        return False


def validate_order(order, customers_lookup, products_lookup):
    if not order.get("order_id", "").strip():
        return False, "missing_order_id"

    cust_id = order.get("customer_id", "").strip()
    if not cust_id:
        return False, "missing_customer_id"
    if cust_id not in customers_lookup:
        return False, "invalid_customer_id"

    prod_id = order.get("product_id", "").strip()
    if not prod_id:
        return False, "missing_product_id"
    if prod_id not in products_lookup:
        return False, "invalid_product_id"

    if not order.get("order_date", "").strip():
        return False, "missing_order_date"

    qty = order.get("quantity", "").strip()
    if not qty:
        return False, "missing_quantity"
    try:
        qty_val = int(qty)
        if qty_val <= 0:
            return False, "negative_quantity"
    except ValueError:
        return False, "invalid_quantity"

    status = order.get("status", "").strip()
    if not status:
        return False, "missing_status"

    normalized_st = normalize_status(status)
    if normalized_st not in ["completed", "pending", "cancelled"]:
        return False, "invalid_status"

    channel = order.get("channel", "").strip()
    normalized_ch = normalize_channel(channel)
    if normalized_ch not in ["online", "store", "unknown"]:
        return False, "invalid_channel"

    return True, None


def validate_orders(orders, customers_lookup, products_lookup):
    valid = []
    invalid = []

    for order in orders:
        is_valid, reason = validate_order(
            order, customers_lookup, products_lookup)
        print(
            f"Order {order.get('order_id')}: valid={is_valid}, reason={reason}")
        if is_valid:
            valid.append(order)
        else:
            invalid_row = dict(order)
            invalid_row["reason"] = reason
            invalid.append(invalid_row)

    return valid, invalid


# PART 6
def calculate_total_amount(order):
    quantity = int(order["quantity"])
    price = int(order["price"])
    return quantity * price


def enrich_order(order, customers_lookup, products_lookup):
    customer = customers_lookup[order["customer_id"]]
    product = products_lookup[order["product_id"]]

    return {
        "order_id": order["order_id"],
        "customer_id": order["customer_id"],
        "customer_name": customer["customer_name"],
        "city": normalize_city(customer["city"]),
        "product_id": order["product_id"],
        "product_name": product["product_name"],
        "category": product["category"],
        "quantity": int(order["quantity"]),
        "price": int(product["price"]),
        "total_amount": calculate_total_amount({
            "quantity": order["quantity"],
            "price": product["price"]
        }),
        "status": normalize_status(order["status"]),
        "channel": normalize_channel(order["channel"]),
        "order_date": order["order_date"]
    }


def enrich_orders(valid_orders, customers_lookup, products_lookup):
    clean = []

    for order in valid_orders:
        enriched = enrich_order(order, customers_lookup, products_lookup)
        clean.append(enriched)
        print(
            f"Order {enriched['order_id']}: {enriched['customer_name']} | "
            f"{enriched['product_name']} | qty={enriched['quantity']} | "
            f"total={enriched['total_amount']}"
        )

    return clean


# PART 7
def write_csv(file_path, rows, fieldnames):
    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({k: row.get(k, "") for k in fieldnames})


def write_output_files(clean_orders, invalid_orders):
    clean_path = "week-2/day-9-csv-data-pipeline/output/orders_clean.csv"
    clean_fields = [
        "order_id", "customer_id", "customer_name", "city", "product_id",
        "product_name", "category", "quantity", "price", "total_amount",
        "status", "channel", "order_date"
    ]
    write_csv(clean_path, clean_orders, clean_fields)
    print(
        f"Written {len(clean_orders)} clean orders to output/orders_clean.csv.")

    invalid_path = "week-2/day-9-csv-data-pipeline/output/invalid_orders.csv"
    invalid_fields = [
        "order_id", "customer_id", "product_id",
        "order_date", "quantity", "status", "channel", "reason"
    ]
    write_csv(invalid_path, invalid_orders, invalid_fields)
    print(
        f"Written {len(invalid_orders)} invalid orders to output/invalid_orders.csv.")


# PART 8
def create_data_quality_report(raw_orders, clean_orders, invalid_orders):
    total_raw = len(raw_orders)
    total_valid = len(clean_orders)
    total_invalid = len(invalid_orders)

    # Count reasons
    reason_counts = {}
    for order in invalid_orders:
        reason = order.get("reason", "unknown")
        reason_counts[reason] = reason_counts.get(reason, 0) + 1

    # Count normalized status values from clean orders
    status_counts = {}
    for order in clean_orders:
        s = order.get("status", "unknown")
        status_counts[s] = status_counts.get(s, 0) + 1

    # Count normalized channel values from clean orders
    channel_counts = {}
    for order in clean_orders:
        c = order.get("channel", "unknown")
        channel_counts[c] = channel_counts.get(c, 0) + 1

    # Count normalized city values from clean orders
    city_counts = {}
    for order in clean_orders:
        city = order.get("city", "unknown")
        city_counts[city] = city_counts.get(city, 0) + 1

    report_path = "week-2/day-9-csv-data-pipeline/output/data_quality_report.txt"
    with open(report_path, mode="w", encoding="utf-8") as f:
        f.write("Data Quality Report - Day 9\n")
        f.write("=" * 40 + "\n\n")

        f.write(f"Total raw orders: {total_raw}\n")
        f.write(f"Valid orders: {total_valid}\n")
        f.write(f"Invalid orders: {total_invalid}\n\n")

        f.write("Invalid records by reason:\n")
        for reason, count in reason_counts.items():
            f.write(f"  - {reason}: {count}\n")
        f.write("\n")

        f.write("Status values after cleaning:\n")
        for status, count in status_counts.items():
            f.write(f"  - {status}: {count}\n")
        f.write("\n")

        f.write("Channel values after cleaning:\n")
        for channel, count in channel_counts.items():
            f.write(f"  - {channel}: {count}\n")
        f.write("\n")

        f.write("City values after cleaning:\n")
        for city, count in city_counts.items():
            f.write(f"  - {city}: {count}\n")
        f.write("\n")

        f.write("Bronze input files checked:\n")
        f.write("  - data/orders_raw.csv\n")
        f.write("  - data/customers_raw.csv\n")
        f.write("  - data/products_raw.csv\n\n")

        f.write("Silver output files created:\n")
        f.write("  - output/orders_clean.csv\n")
        f.write("  - output/invalid_orders.csv\n\n")

        f.write("Main data quality problems found:\n")
        for reason, count in reason_counts.items():
            f.write(f"  - {reason}: {count} order(s) affected\n")

    print("Written data quality report to output/data_quality_report.txt.")


# PART 9
def count_by_field(rows, field_name):
    counts = {}
    for row in rows:
        val = row[field_name]
        if val not in counts:
            counts[val] = 1
        else:
            counts[val] = counts[val] + 1
    return counts


def sum_by_field(rows, group_field, amount_field):
    sums = {}
    for row in rows:
        g_val = row[group_field]
        a_val = float(row[amount_field])
        if g_val not in sums:
            sums[g_val] = a_val
        else:
            sums[g_val] = sums[g_val] + a_val
    return sums


def get_completed_orders(rows):
    completed = []
    for row in rows:
        if row["status"] == "completed":
            completed.append(row)
    return completed


def get_top_n_by_field(rows, field_name, n):
    def get_value(row):
        return float(row[field_name])

    sorted_rows = sorted(rows, key=get_value, reverse=True)
    return sorted_rows[:n]


def create_business_summary(clean_orders):
    completed_orders = get_completed_orders(clean_orders)

    # 1. Completed revenue
    completed_revenue = 0.0
    for o in completed_orders:
        completed_revenue = completed_revenue + float(o["total_amount"])

    # 2. Orders by status
    status_counts = count_by_field(clean_orders, "status")

    # 3. Orders by city
    city_counts = count_by_field(clean_orders, "city")

    # 4. Revenue by category
    category_revenue = sum_by_field(
        completed_orders, "category", "total_amount")

    # 5. Revenue by channel
    channel_revenue = sum_by_field(completed_orders, "channel", "total_amount")

    # 6. Top 3 customers by completed revenue
    cust_revenue_dict = sum_by_field(
        completed_orders, "customer_name", "total_amount")
    cust_revenue_list = []
    for name in cust_revenue_dict:
        revenue = cust_revenue_dict[name]
        cust_revenue_list.append({
            "customer_name": name,
            "revenue": revenue
        })
    top_customers = get_top_n_by_field(cust_revenue_list, "revenue", 3)

    # 7. Top 3 products by completed revenue
    prod_revenue_dict = sum_by_field(
        completed_orders, "product_name", "total_amount")
    prod_revenue_list = []
    for name in prod_revenue_dict:
        revenue = prod_revenue_dict[name]
        prod_revenue_list.append({
            "product_name": name,
            "revenue": revenue
        })
    top_products = get_top_n_by_field(prod_revenue_list, "revenue", 3)

    # 8. Most valuable completed order
    most_valuable = get_top_n_by_field(completed_orders, "total_amount", 1)
    most_valuable_order = None
    if len(most_valuable) > 0:
        most_valuable_order = most_valuable[0]

    # 9. Orders that should not count as revenue
    non_revenue_orders = []
    for o in clean_orders:
        if o["status"] == "pending" or o["status"] == "cancelled":
            non_revenue_orders.append(o)

    summary_path = "week-2/day-9-csv-data-pipeline/output/business_summary.txt"
    with open(summary_path, mode="w", encoding="utf-8") as f:
        f.write("Business Summary - Day 9\n")
        f.write("========================================\n\n")

        f.write(f"Completed revenue: {completed_revenue:.2f}\n\n")

        f.write("Orders by status:\n")
        for status in status_counts:
            count = status_counts[status]
            f.write(f"  - {status}: {count}\n")
        f.write("\n")

        f.write("Orders by city:\n")
        city_list = []
        for city in city_counts:
            city_list.append({
                "city": city,
                "count": city_counts[city]
            })
        sorted_cities = get_top_n_by_field(city_list, "count", len(city_list))
        for c in sorted_cities:
            f.write(f"  - {c['city']}: {c['count']}\n")
        f.write("\n")

        f.write("Revenue by category:\n")
        category_list = []
        for cat in category_revenue:
            category_list.append({
                "category": cat,
                "revenue": category_revenue[cat]
            })
        sorted_categories = get_top_n_by_field(
            category_list, "revenue", len(category_list))
        for cat_item in sorted_categories:
            f.write(f"  - {cat_item['category']}: {cat_item['revenue']:.2f}\n")
        f.write("\n")

        f.write("Revenue by channel:\n")
        channel_list = []
        for chan in channel_revenue:
            channel_list.append({
                "channel": chan,
                "revenue": channel_revenue[chan]
            })
        sorted_channels = get_top_n_by_field(
            channel_list, "revenue", len(channel_list))
        for chan_item in sorted_channels:
            f.write(
                f"  - {chan_item['channel']}: {chan_item['revenue']:.2f}\n")
        f.write("\n")

        f.write("Top 3 customers by completed revenue:\n")
        for c in top_customers:
            f.write(f"  - {c['customer_name']}: {c['revenue']:.2f}\n")
        f.write("\n")

        f.write("Top 3 products by completed revenue:\n")
        for p in top_products:
            f.write(f"  - {p['product_name']}: {p['revenue']:.2f}\n")
        f.write("\n")

        if most_valuable_order:
            f.write(f"Most valuable completed order:\n")
            f.write(f"  - Order ID: {most_valuable_order['order_id']} | "
                    f"Customer: {most_valuable_order['customer_name']} | "
                    f"Product: {most_valuable_order['product_name']} | "
                    f"Total: {float(most_valuable_order['total_amount']):.2f}\n\n")
        else:
            f.write("Most valuable completed order: None\n\n")

        f.write("Orders that should not count as revenue:\n")
        for o in non_revenue_orders:
            f.write(
                f"  - Order ID: {o['order_id']} | Status: {o['status']} | Amount: {float(o['total_amount']):.2f}\n")
        f.write("\n")

        f.write("Business recommendation:\n")
        f.write("  1. Focus marketing on the 'Electronics' category which drives the highest completed revenue (1240.00).\n")
        f.write("  2. Standardize sales channels; investigate the 'unknown' channel orders (like order 10) to prevent data loss.\n")
        f.write(
            "  3. Target high-value clients like Arta (700.00) and Leart (360.00) with loyalty programs.\n\n")

        f.write("Why this Gold output can be trusted:\n")
        f.write("  - Only completed orders should count as real revenue.\n")
        f.write("  - Pending and cancelled orders should appear in status reporting, but not in completed revenue.\n")
        f.write(
            "  - Business numbers must be calculated from clean data, not guessed manually.\n")
        f.write(
            "  - String standardizations prevent split-grouping errors for cities and statuses.\n")

    print("Written business summary to output/business_summary.txt.")


def main():
    # 1. load raw CSV files
    orders = load_orders()
    customers = load_customers()
    products = load_products()
    print()
    # 2. build lookup tables
    customers_lookup = build_lookup_table(customers, "customer_id")
    products_lookup = build_lookup_table(products, "product_id")
    print()
    # 3. validate and clean orders
    valid_orders, invalid_orders = validate_orders(
        orders, customers_lookup, products_lookup)
    print()
    # 4. enrich valid orders
    clean_orders = enrich_orders(
        valid_orders, customers_lookup, products_lookup)
    print()
    # 5. write clean and invalid CSV files
    write_output_files(clean_orders, invalid_orders)
    print()
    # 6. create data quality report
    create_data_quality_report(orders, clean_orders, invalid_orders)
    print()
    # 7. create business summary report
    create_business_summary(clean_orders)


if __name__ == "__main__":
    main()
