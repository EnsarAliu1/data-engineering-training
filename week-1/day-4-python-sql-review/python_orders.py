orders = [
    {
        "order_id": 1,
        "customer_name": "Arta",
        "city": "Vushtrri",
        "product": "Laptop",
        "category": "Electronics",
        "quantity": 1,
        "price": 700,
        "status": "completed",
        "order_date": "2026-07-01",
    },
    {
        "order_id": 2,
        "customer_name": "Blend",
        "city": "Prishtina",
        "product": "Mouse",
        "category": "Accessories",
        "quantity": 2,
        "price": 15,
        "status": "completed",
        "order_date": "2026-07-01",
    },
    {
        "order_id": 3,
        "customer_name": "Arta",
        "city": "Vushtrri",
        "product": "Keyboard",
        "category": "Accessories",
        "quantity": 1,
        "price": 40,
        "status": "cancelled",
        "order_date": "2026-07-02",
    },
    {
        "order_id": 4,
        "customer_name": "Dren",
        "city": "Mitrovica",
        "product": "Monitor",
        "category": "Electronics",
        "quantity": 1,
        "price": 180,
        "status": "completed",
        "order_date": "2026-07-02",
    },
    {
        "order_id": 5,
        "customer_name": "Elira",
        "city": "Prishtina",
        "product": "Mouse",
        "category": "Accessories",
        "quantity": 1,
        "price": 15,
        "status": "completed",
        "order_date": "2026-07-03",
    },
    {
        "order_id": 6,
        "customer_name": "Dren",
        "city": "Mitrovica",
        "product": "Laptop",
        "category": "Electronics",
        "quantity": 1,
        "price": 700,
        "status": "pending",
        "order_date": "2026-07-03",
    },
    {
        "order_id": 7,
        "customer_name": "Nora",
        "city": "Vushtrri",
        "product": "Headphone",
        "category": "Accessories",
        "quantity": 1,
        "price": 50,
        "status": "completed",
        "order_date": "2026-07-04",
    },
    {
        "order_id": 8,
        "customer_name": "Leart",
        "city": "Peja",
        "product": "Monitor",
        "category": "Electronics",
        "quantity": 2,
        "price": 180,
        "status": "completed",
        "order_date": "2026-07-04",
    },
    {
        "order_id": 9,
        "customer_name": "Faton",
        "city": "Prizren",
        "product": "Desk Chair",
        "category": "Office",
        "quantity": 1,
        "price": 120,
        "status": "completed",
        "order_date": "2026-07-05",
    },
    {
        "order_id": 10,
        "customer_name": "Gresa",
        "city": "Prishtina",
        "product": "USB Cable",
        "category": "Accessories",
        "quantity": 3,
        "price": 8,
        "status": "completed",
        "order_date": "2026-07-05",
    },
    {
        "order_id": 11,
        "customer_name": "Rina",
        "city": "Vushtrri",
        "product": "Laptop",
        "category": "Electronics",
        "quantity": 1,
        "price": 650,
        "status": "cancelled",
        "order_date": "2026-07-06",
    },
    {
        "order_id": 12,
        "customer_name": "Arben",
        "city": "Ferizaj",
        "product": "Desk",
        "category": "Office",
        "quantity": 1,
        "price": 220,
        "status": "pending",
        "order_date": "2026-07-06",
    },
]

# Part 1


# Task 1
def total_orders():
    number_of_orders = len(orders)
    return number_of_orders


print(f"Total orders: {total_orders()}")


print()


print("Custumer names:")


def customer_names():
    for customer in orders:
        print(customer["customer_name"])


customer_names()


print()


print("Order details:")


def order_details():
    for order in orders:
        print(
            f"{order["customer_name"]} ordered {order["product"]} from {order["city"]} and the status is {order["status"]}")


order_details()


print()
# End of Task 1


# Task 2


def orders_by_status(status):
    for order in orders:
        if order["status"] == status:
            print(f"{order['customer_name']} - {order['product']}")


print("Completed orders:")
orders_by_status("completed")

print()

print("Pending orders:")
orders_by_status("pending")

print()

print("Cancelled orders:")
orders_by_status("cancelled")


print()


def high_price_orders():
    for order in orders:
        if order["price"] > 100:
            print(
                f"{order['customer_name']} - {order['product']} - {order['price']}")


print("Orders with price higher than 100:")
high_price_orders()


print()


def high_price_orders():
    for order in orders:
        if order["category"] == "Accessories":
            print(
                f"{order['customer_name']} - {order['product']} - {order['price']}")


print("Orders of Accessories category")
high_price_orders()

# End of task 2

print()

# Task 3


def total_amount():
    for order in orders:
        total_amount = order['quantity'] * order['price']
        print(
            f"{order['customer_name']} - {order['product']} - {order['quantity']} - {order['price']} - {total_amount}")


print("Order totals:")
total_amount()

print()

# End of task 3


# Task 4

def get_price(order):
    return order["price"]


def sorting_orders_by_price(reverse=False):
    sorted_orders = sorted(orders, key=get_price, reverse=reverse)

    for order in sorted_orders:
        print(
            f"{order['customer_name']} - {order['product']} - ${order['price']}")


print("Highest to Lowest by proice:")
sorting_orders_by_price(True)

print()


print()


def get_total_amount(order):
    return order["price"] * order["quantity"]


def sorting_orders_by_total_amount(reverse=False):
    sorted_orders = sorted(orders, key=get_total_amount, reverse=reverse)

    print("Highest to Lowest by total amount:")
    for order in sorted_orders:
        print(
            f"{order['customer_name']} - {order['product']} - {get_total_amount(order)}")

    print()

    print("Top 3 orders by total amount:")
    for order in sorted_orders[:3]:
        print(
            f"{order['customer_name']} - {order['product']} - {get_total_amount(order)}")


sorting_orders_by_total_amount(True)


print()


# End of task 4

# Task 5

print("Status counts:")


def order_count_by_status():
    completed = 0
    pending = 0
    cancelled = 0

    for order in orders:
        if order["status"] == "completed":
            completed += 1
        elif order["status"] == "pending":
            pending += 1
        elif order["status"] == "cancelled":
            cancelled += 1

    print(f"Completed: {completed}")
    print(f"Pending: {pending}")
    print(f"Cancelled: {cancelled}")


order_count_by_status()


print()


def completed_revenue():
    total = 0

    for order in orders:
        if order["status"] == "completed":
            total += order["price"] * order["quantity"]

    print(f"Completed Revenue: ${total}")


completed_revenue()

print()

# Part 4 - Mini business challenge


def customer_with_most_expensive_order():
    highest_order = orders[0]

    for order in orders:
        if order["quantity"] * order["price"] > highest_order["quantity"] * highest_order["price"]:
            highest_order = order

    print("Customer with the most expensive single order:")
    print(
        f"{highest_order['customer_name']} - "
        f"{highest_order['product']} - "
        f"{highest_order['quantity'] * highest_order['price']}"
    )


customer_with_most_expensive_order()


print()


def not_in_revenue():
    not_in_revenue_orders = []

    for order in orders:
        if order["status"] != "completed":
            not_in_revenue_orders.append(order)

    print("Orders not counted as revenue:")
    for order in not_in_revenue_orders:
        print(
            f"{order['customer_name']} - "
            f"{order['product']} - "
            f"{order['status']}"
        )


not_in_revenue()


print()


def completed_revenue():
    total_revenue = 0

    for order in orders:
        if order["status"] == "completed":
            total_revenue += order["quantity"] * order["price"]

    print("Completed revenue:")
    print(total_revenue)


completed_revenue()


# --Create a short business answer: Which order looks most valuable and why?
# --The most valuable order is Arta's laptop order because it has the highest total amount of €700. It generates the most revenue #from a single purchase.
#
# --Create a short business answer: Why should cancelled orders not be counted as revenue?
# --Cancelled orders should not be counted as revenue because the sale was never completed and no payment was successfully received. Including them would make the revenue report inaccurate.


# Bonus Tasks

def add_two_orders():
    order1 = {
        "order_id": 13,
        "customer_name": "Ensar",
        "city": "Skenderaj",
        "product": "Laptop",
        "category": "Electronics",
        "quantity": 1,
        "price": 700,
        "status": "completed",
        "order_date": "2026-07-01",
    }

    order2 = {
        "order_id": 24,
        "customer_name": "Urim",
        "city": "Vushtrri",
        "product": "Mouse",
        "category": "Accessories",
        "quantity": 2,
        "price": 15,
        "status": "completed",
        "order_date": "2026-07-01",
    }

    orders.append(order1)
    orders.append(order2)

    print("Two orders added successfully!")

    for order in orders[-2:]:
        print(order)


add_two_orders()


print()


def count_orders_by_city():
    city_counts = {}

    for order in orders:
        city = order["city"]

        if city in city_counts:
            city_counts[city] += 1
        else:
            city_counts[city] = 1

    print("Orders by city:")
    for city, count in city_counts.items():
        print(f"{city}: {count}")


count_orders_by_city()
