from order_data import orders


def normalize_status(status):
    """Normalize status values so complete and Completed become completed."""
    if status in ["Completed", "complete", "completed"]:
        return "completed"
    return status


def normalize_city(city):
    """Normalize city values so Prishtine becomes Prishtina."""
    if city == "Prishtine":
        return "Prishtina"
    return city


def normalize_category(category):
    """Normalize category values so accessories becomes Accessories."""
    if category == "accessories":
        return "Accessories"
    return category


def normalize_channel(channel):
    """Normalize channel values so Online becomes online."""
    if channel == "Online":
        return "online"
    return channel


def calculate_total_amount(order):
    """Calculate total amount of an order. Returns None if quantity or price is missing."""
    qty = order.get("quantity")
    prc = order.get("price")
    if qty is None or prc is None:
        return None
    return qty * prc


def validate_order(order):
    """Check order validity. Returns a list of error reasons (empty list means valid)."""
    reasons = []
    if len(order.get("customer_name", "")) == 0:
        reasons.append("Empty customer name")
    if order.get("quantity", 0) <= 0:
        reasons.append("Quantity is 0 or less")
    if order.get("price", 0) <= 0:
        reasons.append("Price is 0 or less")
    return reasons


def clean_order(order):
    """Create a cleaned copy of an order."""
    cleaned = order.copy()
    cleaned["status"] = normalize_status(cleaned["status"])
    cleaned["city"] = normalize_city(cleaned["city"])
    cleaned["category"] = normalize_category(cleaned["category"])
    cleaned["channel"] = normalize_channel(cleaned["channel"])

    if len(cleaned["customer_name"]) == 0:
        cleaned["customer_name"] = "unknown"

    if cleaned["quantity"] <= 0:
        cleaned["quantity"] = None

    if cleaned["price"] <= 0:
        cleaned["price"] = None

    cleaned["total_amount"] = calculate_total_amount(cleaned)
    return cleaned


def split_valid_and_invalid_orders(orders_list):
    """Separate orders list into valid and invalid lists."""
    valid_orders = []
    invalid_orders = []
    for order in orders_list:
        if len(validate_order(order)) > 0:
            invalid_orders.append(order)
        else:
            valid_orders.append(order)
    return valid_orders, invalid_orders


def get_completed_orders(clean_orders):
    """Return only completed orders from a list of clean orders."""
    completed = []
    for order in clean_orders:
        if order["status"] == "completed":
            completed.append(order)
    return completed


def calculate_completed_revenue(clean_orders):
    """Sum total_amount only for completed orders."""
    completed = get_completed_orders(clean_orders)
    revenue = 0
    for order in completed:
        val = order.get("total_amount")
        if val is not None:
            revenue += val
    return revenue


def count_by_field(records, field_name):
    """Count occurrences of each unique value in a specific field."""
    counts = {}
    for order in records:
        value = order.get(field_name)
        if value not in counts:
            counts[value] = 0
        counts[value] += 1
    return counts


def sum_revenue_by_field(records, field_name):
    """Sum completed revenue grouped by a specific field."""
    revenues = {}
    for order in records:
        if order.get("status") == "completed":
            value = order.get(field_name)
            revenue = order.get("total_amount")
            if revenue is None:
                continue
            if value not in revenues:
                revenues[value] = 0
            revenues[value] += revenue
    return revenues


def get_top_orders_by_total_amount(records, limit):
    """Get the top completed orders sorted by total_amount."""
    completed = []
    for order in records:
        if order.get("status") == "completed" and order.get("total_amount") is not None:
            completed.append(order)
    completed.sort(key=lambda x: x["total_amount"], reverse=True)
    return completed[:limit]


def get_customers_with_multiple_orders(records):
    """Get customers who have more than one valid order."""
    customer_counts = {}
    for order in records:
        customer = order.get("customer_name")
        if customer:
            if customer not in customer_counts:
                customer_counts[customer] = 0
            customer_counts[customer] += 1

    multiple = []
    for customer, count in customer_counts.items():
        if count > 1:
            multiple.append(customer)
    return multiple


def write_validation_report(valid_orders, invalid_orders):
    """Write output/validation_report.txt and output/invalid_records.txt."""
    # Write invalid records file first
    invalid_file = open(
        "week-2/day-8-python-data-logic-sprint-heavy/output/invalid_records.txt",
        "w"
    )
    for order in invalid_orders:
        customer = order["customer_name"]
        if len(customer) == 0:
            customer = "(no name)"
        reasons = validate_order(order)
        reason_text = ", ".join(reasons)
        invalid_file.write(
            f"Order ID {order['order_id']} | Customer: {customer} | Reason: {reason_text}\n")
    invalid_file.close()

    # Collect unique raw values before cleaning
    raw_statuses = []
    raw_cities = []
    raw_categories = []
    raw_channels = []
    for order in orders:
        if order["status"] not in raw_statuses:
            raw_statuses.append(order["status"])
        if order["city"] not in raw_cities:
            raw_cities.append(order["city"])
        if order["category"] not in raw_categories:
            raw_categories.append(order["category"])
        if order["channel"] not in raw_channels:
            raw_channels.append(order["channel"])

    # Write summary validation report
    report_file = open(
        "week-2/day-8-python-data-logic-sprint-heavy/output/validation_report.txt",
        "w"
    )
    report_file.write("Validation Summary Report\n")
    report_file.write("=========================\n")
    report_file.write(f"Total Records Processed: {len(orders)}\n")
    report_file.write(f"Total Valid Records: {len(valid_orders)}\n")
    report_file.write(f"Total Invalid Records: {len(invalid_orders)}\n")
    report_file.write("\nInvalid Record Reasons:\n")

    for order in invalid_orders:
        customer = order["customer_name"]
        if len(customer) == 0:
            customer = "(no name)"
        reasons = validate_order(order)
        reason_text = ", ".join(reasons)
        report_file.write(
            f"  Order ID {order['order_id']} | Customer: {customer} | {reason_text}\n")

    report_file.write("\nUnique Raw Values (before cleaning):\n")
    report_file.write(f"  Statuses:   {raw_statuses}\n")
    report_file.write(f"  Cities:     {raw_cities}\n")
    report_file.write(f"  Categories: {raw_categories}\n")
    report_file.write(f"  Channels:   {raw_channels}\n")
    report_file.close()


def write_business_report(valid_orders):
    """Write output/business_report.txt using cleaned valid records."""
    clean_orders = [clean_order(o) for o in valid_orders]

    business_file = open(
        "week-2/day-8-python-data-logic-sprint-heavy/output/business_report.txt",
        "w"
    )
    business_file.write("Business Report\n")
    business_file.write("===============\n\n")

    completed_rev = calculate_completed_revenue(clean_orders)
    business_file.write(f"Total Completed Revenue: {completed_rev} \n\n")

    # Revenue by city
    business_file.write("Revenue by City:\n")
    for item in sorting_by_filed_name(clean_orders, "city"):
        business_file.write(f"  {item['name']}: {item['revenue']} \n")

    # Revenue by category
    business_file.write("\nRevenue by Category:\n")
    for item in sorting_by_filed_name(clean_orders, "category"):
        business_file.write(f"  {item['name']}: {item['revenue']} \n")

    # Revenue by channel
    business_file.write("\nRevenue by Channel:\n")
    for item in sorting_by_filed_name(clean_orders, "channel"):
        business_file.write(f"  {item['name']}: {item['revenue']} \n")

    # Top 5 orders
    business_file.write("\nTop 5 Completed Orders by Total Amount:\n")
    for order in get_top_orders_by_total_amount(clean_orders, 5):
        business_file.write(
            f"  Order ID {order['order_id']} | {order['customer_name']} | "
            f"{order['product']} | {order['total_amount']} \n"
        )

    # Repeat customers
    business_file.write("\nRepeat Customers (more than 1 order):\n")
    for customer in get_customers_with_multiple_orders(valid_orders):
        business_file.write(f"  {customer}\n")

    # Final recommendation
    business_file.write("\nFinal Recommendation:\n")
    business_file.write(
        "Revenue numbers are based only on valid completed orders.\n"
        "4 records were removed before reporting due to missing or invalid data.\n"
        "Pending, cancelled, and returned orders were excluded from all revenue totals.\n"
    )
    business_file.close()


def print_num_of_raw_records():
    raw_records = len(orders)
    print(f"Number of raw records: {raw_records}")


def first_three_readable_format():
    for order in orders[:3]:
        print(
            f"{order['customer_name']} with order id {order['order_id']} "
            f"from {order['city']} ordered {order['quantity']} "
            f"{order['product']} with status of {order['status']} "
            f"ordered in/by {order['channel']} from category "
            f"{order['category']} with price of {order['price']} "
            f"in {order['order_date']}"
        )


def all_unique_raw():
    unique_statuses = []
    unique_cities = []
    unique_categories = []
    unique_channels = []

    for order in orders:
        status = order['status']
        city = order['city']
        category = order['category']
        channel = order['channel']

        if status not in unique_statuses:
            unique_statuses.append(status)
        if city not in unique_cities:
            unique_cities.append(city)
        if category not in unique_categories:
            unique_categories.append(category)
        if channel not in unique_channels:
            unique_channels.append(channel)

    print(f"Unique Raw Statuses: {unique_statuses}")
    print(f"Unique Raw Cities: {unique_cities}")
    print(f"Unique Raw Categories: {unique_categories}")
    print(f"Unique Raw Channels: {unique_channels}")


def empty_customer_name():
    print("Orders with empty customer name:")
    for order in orders:
        if len(order['customer_name']) == 0:
            print(order)


def zero_or_less_quantity_orders():
    print("Orders with zero or less quantity:")
    for order in orders:
        if order['quantity'] <= 0:
            print(order)


def zero_or_less_price_orders():
    print("Orders with zero or less price:")
    for order in orders:
        if order['price'] <= 0:
            print(order)


def create_cleaned_orders():
    cleaned_orders = []
    for order in orders:
        cleaned_orders.append(order.copy())
    return cleaned_orders


def clean_and_normalize_orders(cleaned_orders):
    for order in cleaned_orders:
        order["status"] = normalize_status(order["status"])
        order["city"] = normalize_city(order["city"])
        order["category"] = normalize_category(order["category"])
        order["channel"] = normalize_channel(order["channel"])
        if len(order["customer_name"]) == 0:
            order["customer_name"] = "unknown"
        if order["quantity"] <= 0:
            order["quantity"] = None
        if order["price"] <= 0:
            order["price"] = None
    return cleaned_orders


def add_total_amount(cleaned_orders):
    for order in cleaned_orders:
        order["total_amount"] = calculate_total_amount(order)
    return cleaned_orders


def print_unique_cleaned_values(cleaned_orders):
    unique_statuses = []
    unique_cities = []
    unique_categories = []
    unique_channels = []

    for order in cleaned_orders:
        status = order["status"]
        city = order["city"]
        category = order["category"]
        channel = order["channel"]

        if status not in unique_statuses:
            unique_statuses.append(status)
        if city not in unique_cities:
            unique_cities.append(city)
        if category not in unique_categories:
            unique_categories.append(category)
        if channel not in unique_channels:
            unique_channels.append(channel)

    print(f"Unique Cleaned Statuses: {unique_statuses}")
    print(f"Unique Cleaned Cities: {unique_cities}")
    print(f"Unique Cleaned Categories: {unique_categories}")
    print(f"Unique Cleaned Channels: {unique_channels}")


def calculate_business_metrics(cleaned_orders, valid_orders, invalid_orders):
    cleaned_valid_orders = []
    for order in cleaned_orders:
        if order["quantity"] is not None and order["price"] is not None:
            cleaned_valid_orders.append(order)

    # Completed orders
    completed_orders = get_completed_orders(cleaned_valid_orders)

    # Non-revenue orders
    non_revenue_orders = []
    for order in cleaned_valid_orders:
        if order["status"] in ["pending", "cancelled", "returned"]:
            non_revenue_orders.append(order)

    # Completed revenue
    completed_revenue = calculate_completed_revenue(cleaned_valid_orders)

    # Average completed order value
    if len(completed_orders) > 0:
        average_completed_order_value = completed_revenue / \
            len(completed_orders)
    else:
        average_completed_order_value = 0

    # Highest and lowest completed order
    highest_order = None
    lowest_completed_order = None

    if len(completed_orders) > 0:
        highest_order = completed_orders[0]["total_amount"]
        lowest_completed_order = completed_orders[0]["total_amount"]
        for order in completed_orders:
            if order["total_amount"] > highest_order:
                highest_order = order["total_amount"]
            if order["total_amount"] < lowest_completed_order:
                lowest_completed_order = order["total_amount"]

    # Print business metrics
    print("Business Metrics:")
    print()
    print(f"Raw records: {len(orders)}")
    print(f"Valid records: {len(valid_orders)}")
    print(f"Invalid records: {len(invalid_orders)}")
    print(f"Completed orders: {len(completed_orders)}")
    print(f"Non-revenue orders: {len(non_revenue_orders)}")
    print(f"Completed revenue: {completed_revenue}")
    print(f"Average completed order value: {average_completed_order_value}")
    print(f"Highest order: {highest_order}")
    print(f"Lowest completed order: {lowest_completed_order}")


def products_ordered_more_than_once(valid_orders):
    product_counts = {}
    for order in valid_orders:
        product = order["product"]
        if product not in product_counts:
            product_counts[product] = 0
        product_counts[product] += 1

    products = []
    for product in product_counts:
        if product_counts[product] > 1:
            products.append(product)
    return products


def top_5_completed_orders(cleaned_orders):
    return get_top_orders_by_total_amount(cleaned_orders, 5)


def top_3_by_revenue(cleaned_orders, field_name):
    grouped_revenue = sum_revenue_by_field(cleaned_orders, field_name)
    sorted_groups = sorted(
        [{"name": k, "revenue": v} for k, v in grouped_revenue.items()],
        key=lambda item: item["revenue"],
        reverse=True
    )
    return sorted_groups[:3]


def sorting_by_filed_name(cleaned_orders, field_name):
    grouped_revenue = sum_revenue_by_field(cleaned_orders, field_name)
    sorted_groups = sorted(
        [{"name": k, "revenue": v} for k, v in grouped_revenue.items()],
        key=lambda item: item["revenue"],
        reverse=True
    )
    return sorted_groups


# bonus challenges
def add_risk_flag(cleaned_orders):
    for order in cleaned_orders:
        if order["total_amount"] is not None and order["total_amount"] >= 500:
            order["risk_flag"] = "high_value"


def main():
    # Part 1
    print_num_of_raw_records()
    print()
    first_three_readable_format()
    print()
    all_unique_raw()
    print()

    # Part 2
    empty_customer_name()
    print()
    zero_or_less_quantity_orders()
    print()
    zero_or_less_price_orders()
    print()

    valid_orders, invalid_orders = split_valid_and_invalid_orders(orders)
    write_validation_report(valid_orders, invalid_orders)
    print("Validation results have been written to files inside the output/ folder.")
    print()

    # Part 3
    cleaned_orders = create_cleaned_orders()
    cleaned_orders = clean_and_normalize_orders(cleaned_orders)
    cleaned_orders = add_total_amount(cleaned_orders)
    cleaned_orders = add_risk_flag(cleaned_orders)
    print_unique_cleaned_values(cleaned_orders)
    print(cleaned_orders)

    # Part 4
    calculate_business_metrics(
        cleaned_orders,
        valid_orders,
        invalid_orders
    )
    print()

    # Part 5
    print("Count by field:")
    print(count_by_field(cleaned_orders, "status"))
    print(count_by_field(cleaned_orders, "city"))
    print(count_by_field(cleaned_orders, "category"))
    print(count_by_field(cleaned_orders, "channel"))
    print()

    print("Count by field with completed revenue:")
    print(sum_revenue_by_field(cleaned_orders, "city"))
    print(sum_revenue_by_field(cleaned_orders, "category"))
    print(sum_revenue_by_field(cleaned_orders, "channel"))
    print(sum_revenue_by_field(cleaned_orders, "customer_name"))
    print()

    print("Costumers with more than one valid order")
    print(get_customers_with_multiple_orders(valid_orders))
    print()

    print("Products ordered more than once:")
    print(products_ordered_more_than_once(valid_orders))
    print()

    # Part 6
    print("Top 5 valid completed orders by total amount:")
    top_orders = top_5_completed_orders(cleaned_orders)
    for order in top_orders:
        print(
            f"Order ID: {order['order_id']} | "
            f"Customer: {order['customer_name']} | "
            f"Product: {order['product']} | "
            f"Total Amount: {order['total_amount']}"
        )
    print()

    print("Top 3 by customer revenue:")
    for item in top_3_by_revenue(cleaned_orders, "customer_name"):
        print(f"Customer: {item['name']} | Revenue: {item['revenue']}")
    print()

    print("Top 3 by city revenue:")
    for item in top_3_by_revenue(cleaned_orders, "city"):
        print(f"City: {item['name']} | Revenue: {item['revenue']}")
    print()

    print("Top 3 by product revenue:")
    for item in top_3_by_revenue(cleaned_orders, "product"):
        print(f"Product: {item['name']} | Revenue: {item['revenue']}")
    print()

    print("Highest to lowest completed revenue by category:")
    for item in sorting_by_filed_name(cleaned_orders, "category"):
        print(f"Product: {item['name']} | Revenue: {item['revenue']}")
    print()

    print("Highest to lowest completed revenue by channel:")
    for item in sorting_by_filed_name(cleaned_orders, "channel"):
        print(f"Product: {item['name']} | Revenue: {item['revenue']}")
    print()

    # Part 7 - Data quality investigation
    print("=" * 60)
    print("Part 7 - Data Quality Investigation")
    print("=" * 60)

    print("\nQ1: Which invalid records were removed and why?")
    print("Order ID 15: customer name was empty.\nOrder ID 17: quantity was 0.\nOrder ID 18: quantity was -1 (negative).\nOrder ID 20: price was 0.")

    print("\nQ2: How many valid orders do not count as revenue?")
    print("6 valid orders do not count as revenue (Orders 3, 6, 11, 12, 14, 22).\nThey passed validation but have status cancelled, pending, or returned.")

    print("\nQ3: Which status values existed before normalization?")
    print("Raw statuses: completed, Completed, complete, cancelled, pending, returned.\nCompleted, Completed, and complete all meant the same thing. After normalization, all became: completed.")

    print("\nQ4: Which values changed after normalization?")
    print("Order 16: city Prishtine -> Prishtina\nOrder 5: category accessories -> Accessories, channel Online -> online\nOrders 2, 7, 19: status Completed/complete -> completed")

    print("\nQ5: What would go wrong if revenue was calculated before validation?")
    print("Order 18 has quantity -1 so it would subtract from the total.\nOrder 17 (qty 0) and Order 20 (price 0) add nothing but should not be included.\nThe result would be an incorrect and untrustworthy revenue number.")

    print("\nQ6: What would go wrong if pending, cancelled and returned orders counted as revenue?")
    print("Pending orders may never be paid. Cancelled orders did not complete.\nReturned orders mean the product was sent back by the customer.\nCounting them would inflate revenue and lead to wrong business decisions.")

    print("\n" + "=" * 60)
    print("End of Data Quality Investigation")
    print("=" * 60)

    # Part 8 - Write business report to file
    write_business_report(valid_orders)
    print("Business report has been written to output/business_report.txt")


if __name__ == "__main__":
    main()
