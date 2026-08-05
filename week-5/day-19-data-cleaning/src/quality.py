def generate_customer_lifetime_value(customers, orders, order_items):
    # 1. Calculates revenue by every order
    order_totals = {}
    for item in order_items:
        order_id = item.get("order_id")
        quantity = int(item.get("quantity", 0) or 0)
        unit_price = float(item.get("unit_price", 0.0) or 0.0)
        item_total = quantity * unit_price

        order_totals[order_id] = order_totals.get(order_id, 0.0) + item_total

    # 2. Groups them by customer_id
    customer_stats = {}
    for order in orders:
        cust_id = order.get("customer_id")
        ord_id = order.get("order_id")

        if cust_id not in customer_stats:
            customer_stats[cust_id] = {"total_orders": 0, "total_spent": 0.0}

        customer_stats[cust_id]["total_orders"] += 1
        customer_stats[cust_id]["total_spent"] += order_totals.get(ord_id, 0.0)

    # 3. Data analytics for every client
    gold_records = []
    for cust in customers:
        cust_id = cust.get("customer_id")
        stats = customer_stats.get(
            cust_id, {"total_orders": 0, "total_spent": 0.0})

        total_orders = stats["total_orders"]
        total_spent = round(stats["total_spent"], 2)
        avg_order_val = round(total_spent / total_orders,
                              2) if total_orders > 0 else 0.0

        gold_records.append({
            "customer_id": cust_id,
            "full_name": cust.get("full_name"),
            "city": cust.get("city"),
            "country": cust.get("country"),
            "total_orders": total_orders,
            "total_spent": total_spent,
            "average_order_value": avg_order_val
        })

    # Sorts clients(customers) by most revenue made by orders
    gold_records.sort(key=lambda x: x["total_spent"], reverse=True)
    return gold_records


def generate_category_sales_performance(products, order_items):
    """
    Krijon raportin Gold 'category_sales_performance' duke kombinuar
    të dhënat e pastra të Products dhe Order Items.
    """
    # 1. Map produktet me kategoritë e tyre (product_id -> category)
    product_categories = {}
    for product in products:
        p_id = product.get("product_id")
        cat = product.get("category", "Unknown")
        product_categories[p_id] = cat

    # 2. Grupo sasinë e shitur dhe të ardhurat totale sipas kategorisë përmes order_items
    category_stats = {}
    for item in order_items:
        p_id = item.get("product_id")
        category = product_categories.get(p_id, "Unknown")

        quantity = int(item.get("quantity", 0) or 0)
        unit_price = float(item.get("unit_price", 0.0) or 0.0)
        item_total = quantity * unit_price

        if category not in category_stats:
            category_stats[category] = {
                "total_items_sold": 0,
                "total_revenue": 0.0
            }

        category_stats[category]["total_items_sold"] += quantity
        category_stats[category]["total_revenue"] += item_total

    # 3. Krijon rekordet përfundimtare për secilën kategori
    gold_records = []
    for category, stats in category_stats.items():
        gold_records.append({
            "category": category,
            "total_items_sold": stats["total_items_sold"],
            "total_revenue": round(stats["total_revenue"], 2)
        })

    # Sorton kategoritë sipas të ardhurave më të mëdha
    gold_records.sort(key=lambda x: x["total_revenue"], reverse=True)

    return gold_records


def generate_city_sales_performance(orders, order_items):
    # Calculate total revenue for each order
    order_totals = {}
    for item in order_items:
        order_id = item.get("order_id")
        quantity = int(item.get("quantity", 0) or 0)
        unit_price = float(item.get("unit_price", 0.0) or 0.0)
        item_total = quantity * unit_price

        order_totals[order_id] = order_totals.get(order_id, 0.0) + item_total

    # Group revenue and orders by shipping city
    city_stats = {}
    for order in orders:
        city = order.get("shipping_city", "Unknown")
        order_id = order.get("order_id")

        if city not in city_stats:
            city_stats[city] = {
                "total_orders": 0,
                "total_revenue": 0.0
            }

        city_stats[city]["total_orders"] += 1
        city_stats[city]["total_revenue"] += order_totals.get(order_id, 0.0)

    # Create final records
    gold_records = []
    for city, stats in city_stats.items():
        gold_records.append({
            "shipping_city": city,
            "total_orders": stats["total_orders"],
            "total_revenue": round(stats["total_revenue"], 2)
        })

    # Sort by total revenue (highest first)
    gold_records.sort(key=lambda x: x["total_revenue"], reverse=True)

    return gold_records
