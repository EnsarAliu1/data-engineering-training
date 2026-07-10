import csv

CSV = r"c:\Users\Admin\OneDrive\Desktop\data-engineering-training\week-1\day-5-friday-data-sprint\data\orders.csv"


def load_orders():
    orders = []

    with open(CSV, "r") as file:
        reader = csv.DictReader(file)

        for row in reader:
            orders.append(row)

    return orders


def total_orders(orders):
    print(f"Total orders: {len(orders)}")


def get_completed_orders(orders):
    print("Completed orders:")

    for order in orders:
        if order["status"] == "completed":
            print(f"{order['customer_name']} - {order['status']}")


def pending_cancelled_orders(orders):
    print("Pending and Cancelled orders:")

    for order in orders:
        if order["status"] in ["pending", "cancelled"]:
            print(f"{order['customer_name']} - {order['status']}")


def calculate_total_amount(orders):
    print("Total amount per order:")

    for order in orders:
        quantity = int(order["quantity"])
        price = int(order["price"])

        total_amount = quantity * price

        print(f"{order['customer_name']}: {total_amount}")


def calculate_completed_revenue(orders):
    total_revenue = 0

    for order in orders:
        if order["status"] == "completed":
            total_amount = int(order["quantity"]) * int(order["price"])
            total_revenue += total_amount

    print(f"Completed revenue: {total_revenue}")


def most_expensive_order(orders):
    expensive_order = orders[0]

    for order in orders:
        if int(order["price"]) > int(expensive_order["price"]):
            expensive_order = order

    print("Most expensive order:")
    print(
        f"{expensive_order['product']} - "
        f"{expensive_order['price']} EUR "
        f"({expensive_order['customer_name']})"
    )


def highest_total_amount_order(orders):
    highest_order = orders[0]

    for order in orders:
        total_amount = int(order["quantity"]) * int(order["price"])
        highest_total = (
            int(highest_order["quantity"]) *
            int(highest_order["price"])
        )

        if total_amount > highest_total:
            highest_order = order

    total = (
        int(highest_order["quantity"]) *
        int(highest_order["price"])
    )

    print("Highest total amount order:")
    print(
        f"{highest_order['product']} - "
        f"{total} EUR "
        f"({highest_order['customer_name']})"
    )


def count_orders_by(orders, field):
    counts = {}

    for order in orders:
        value = order[field]

        if value in counts:
            counts[value] += 1
        else:
            counts[value] = 1

    print(f"Orders by {field}:")

    for value, count in counts.items():
        print(f"{value}: {count}")


def count_by_status(orders):
    count_orders_by(orders, "status")


def count_by_city(orders):
    count_orders_by(orders, "city")


def count_by_category(orders):
    count_orders_by(orders, "category")


def print_business_report(orders):
    print("Buisness report")

    total_orders(orders)

    print()
    calculate_completed_revenue(orders)

    print()
    most_expensive_order(orders)

    print()
    highest_total_amount_order(orders)

    print()
    count_by_status(orders)

    print()
    count_by_city(orders)

    print()
    count_by_category(orders)


def main():
    orders = load_orders()

    print_business_report(orders)


if __name__ == "__main__":
    main()
