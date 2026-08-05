import csv
import os
from src.config import (
    CUSTOMERS_FILE,
    ORDER_ITEMS_FILE,
    ORDERS_FILE,
    PAYMENTS_FILE,
    PRODUCTS_FILE,
)


def load_csv(file_path):
    with open(file_path, mode="r", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def load_customers():
    return load_csv(CUSTOMERS_FILE)


def load_order_items():
    return load_csv(ORDER_ITEMS_FILE)


def load_orders():
    return load_csv(ORDERS_FILE)


def load_payments():
    return load_csv(PAYMENTS_FILE)


def load_products():
    return load_csv(PRODUCTS_FILE)


def save_csv(data, file_path):
    """Writes a list of dictionaries to a CSV file (creates directories automatically)."""
    if not data:
        return

    dir_name = os.path.dirname(file_path)
    if dir_name:
        os.makedirs(dir_name, exist_ok=True)

    fieldnames = data[0].keys()
    with open(file_path, mode="w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
