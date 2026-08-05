from datetime import datetime
import re

EMAIL_REGEX = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
CUSTOMER_ALLOWED_STATUSES = {"active", "blocked", "unknown"}
ORDER_ALLOWED_STATUSES = {"new", "completed",
                          "pending", "cancelled", "processing", "unknown"}
PAYMENT_ALLOWED_STATUSES = {"Paid", "Refunded", "Failed", "Pending", "Unknown"}
PRODUCT_ALLOWED_STATUSES = {
    "active", "discontinued", "out_of_stock", "invalid", "unknown"}
ALLOWED_CURRENCIES = {"EUR", "USD"}


def is_valid_email(email):
    if not email or not isinstance(email, str):
        return False
    return bool(EMAIL_REGEX.match(email.strip()))


def is_valid_date(date_str):
    if not date_str or not isinstance(date_str, str):
        return False
    try:
        datetime.strptime(date_str.strip(), "%Y-%m-%d")
        return True
    except ValueError:
        return False


# Validating customer **************************************************************************


def validate_customer(customer):
    customer_id = customer.get("customer_id")
    full_name = customer.get("full_name")
    email = customer.get("email")
    created_at = customer.get("created_at")
    status = customer.get("status")

    if customer_id is None or not isinstance(customer_id, int) or customer_id <= 0:
        return False, "Invalid or missing customer_id"

    if not full_name or full_name == "Unknown":
        return False, "Missing full_name"

    if not is_valid_email(email):
        return False, f"Invalid email format: '{email}'"

    if not is_valid_date(created_at):
        return False, f"Invalid created_at date format: '{created_at}'"

    if status not in CUSTOMER_ALLOWED_STATUSES:
        return False, f"Invalid status: '{status}'"

    return True, "Valid"


def validate_customers(customers):
    valid_customers = []
    invalid_customers = []
    seen_ids = set()

    for customer in customers:
        is_valid, reason = validate_customer(customer)

        if not is_valid:
            invalid_record = customer.copy()
            invalid_record["rejection_reason"] = reason
            invalid_customers.append(invalid_record)
            continue

        customer_id = customer["customer_id"]
        if customer_id in seen_ids:
            invalid_record = customer.copy()
            invalid_record["rejection_reason"] = f"Duplicate customer_id: {customer_id}"
            invalid_customers.append(invalid_record)
        else:
            seen_ids.add(customer_id)
            valid_customers.append(customer)

    return valid_customers, invalid_customers

# End of validating customer **********************************************************************


# Validating order_items *******************************************************************************


def validate_order_item(order_item):
    order_item_id = order_item.get("order_item_id")
    order_id = order_item.get("order_id")
    product_id = order_item.get("product_id")
    quantity = order_item.get("quantity")
    unit_price = order_item.get("unit_price")

    if order_item_id is None or not isinstance(order_item_id, int) or order_item_id <= 0:
        return False, "Invalid or missing order_item_id"

    if order_id is None or not isinstance(order_id, int) or order_id <= 0:
        return False, "Invalid or missing order_id"

    if product_id is None or not isinstance(product_id, int) or product_id <= 0:
        return False, "Invalid or missing product_id"

    if quantity is None or not isinstance(quantity, int) or quantity <= 0:
        return False, "Invalid or missing quantity"

    if unit_price is None or not isinstance(unit_price, float) or unit_price <= 0:
        return False, "Invalid or missing unit price"

    return True, "Valid"


def validate_order_items(order_items):
    valid_order_items = []
    invalid_order_items = []
    seen_ids = set()

    for order_item in order_items:
        is_valid, reason = validate_order_item(order_item)

        if not is_valid:
            invalid_record = order_item.copy()
            invalid_record["rejection_reason"] = reason
            invalid_order_items.append(invalid_record)
            continue

        order_item_id = order_item["order_item_id"]
        if order_item_id in seen_ids:
            invalid_record = order_item.copy()
            invalid_record["rejection_reason"] = f"Duplicate order_item_id: {order_item_id}"
            invalid_order_items.append(invalid_record)
        else:
            seen_ids.add(order_item_id)
            valid_order_items.append(order_item)

    return valid_order_items, invalid_order_items

# End of validating order_items *******************************************************************


# Validating orders ********************************************************************************

def validate_order(order):
    order_id = order.get("order_id")
    customer_id = order.get("customer_id")
    order_date = order.get("order_date")
    status = order.get("status")
    shipping_city = order.get("shipping_city")
    payment_method = order.get("payment_method")

    if order_id is None or not isinstance(order_id, int) or order_id <= 0:
        return False, "Invalid or missing order_id"

    if customer_id is None or not isinstance(customer_id, int) or customer_id <= 0:
        return False, "Invalid or missing customer_id"

    if not is_valid_date(order_date):
        return False, f"Invalid order_date format: '{order_date}'"

    if status not in ORDER_ALLOWED_STATUSES:
        return False, f"Invalid status: '{status}'"

    if not shipping_city or shipping_city == "Unknown":
        return False, "Missing or Unknown shipping city"

    if not payment_method or payment_method == "Unknown":
        return False, "Missing or unknown payment method"

    return True, "Valid"


def validate_orders(orders):
    valid_orders = []
    invalid_orders = []
    seen_ids = set()

    for order in orders:
        is_valid, reason = validate_order(order)

        if not is_valid:
            invalid_record = order.copy()
            invalid_record["rejection_reason"] = reason
            invalid_orders.append(invalid_record)
            continue

        order_id = order["order_id"]
        if order_id in seen_ids:
            invalid_record = order.copy()
            invalid_record["rejection_reason"] = f"Duplicate order_id: {order_id}"
            invalid_orders.append(invalid_record)
        else:
            seen_ids.add(order_id)
            valid_orders.append(order)

    return valid_orders, invalid_orders


# End of validating orders ***************************************************************************


# Validating payments ********************************************************************

def validate_payment(payment):
    payment_id = payment.get("payment_id")
    order_id = payment.get("order_id")
    payment_date = payment.get("payment_date")
    amount = payment.get("amount")
    currency = payment.get("currency")
    status = payment.get("status")
    payment_method = payment.get("payment_method")

    if payment_id is None or not isinstance(payment_id, int) or payment_id <= 0:
        return False, "Invalid or missing payment_id"

    if order_id is None or not isinstance(order_id, int) or order_id <= 0:
        return False, "Invalid or missing order_id"

    if not is_valid_date(payment_date):
        return False, f"Invalid payment_date format: '{payment_date}'"

    if amount is None or not isinstance(amount, float) or amount <= 0:
        return False, "Invalid or missing amount"

    if not currency or currency not in ALLOWED_CURRENCIES:
        return False, f"Invalid or unsupported currency: '{currency}' (allowed: EUR, USD)"

    if not status or status == "Unknown":
        return False, "Invalid or missing status"

    if not payment_method or payment_method == "Unknown":
        return False, "Invalid or missing payment_method"

    return True, "Valid"


def validate_payments(payments):
    valid_payments = []
    invalid_payments = []
    seen_ids = set()

    for payment in payments:
        is_valid, reason = validate_payment(payment)

        if not is_valid:
            invalid_record = payment.copy()
            invalid_record["rejection_reason"] = reason
            invalid_payments.append(invalid_record)
            continue

        payment_id = payment["payment_id"]
        if payment_id in seen_ids:
            invalid_record = payment.copy()
            invalid_record["rejection_reason"] = f"Duplicate payment_id: {payment_id}"
            invalid_payments.append(invalid_record)
        else:
            seen_ids.add(payment_id)
            valid_payments.append(payment)

    return valid_payments, invalid_payments

# End of validating payments *******************************************************************


# Validating products ********************************************************************

def validate_product(product):
    product_id = product.get("product_id")
    product_name = product.get("product_name")
    category = product.get("category")
    price = product.get("price")
    stock_quantity = product.get("stock_quantity")
    supplier_id = product.get("supplier_id")
    status = product.get("status")

    if product_id is None or not isinstance(product_id, int) or product_id <= 0:
        return False, "Invalid or missing product_id"

    if not product_name or product_name == "Unknown":
        return False, "Invalid or missing product_name"

    if not category or category == "Unknown":
        return False, "Invalid or missing category"

    if not price or not isinstance(price, float) or price <= 0:
        return False, "Invalid or missing price"

    if stock_quantity is None or not isinstance(stock_quantity, int) or stock_quantity < 0:
        return False, "Invalid or missing stock_quantity"

    if supplier_id is None or not isinstance(supplier_id, int) or supplier_id <= 0:
        return False, "Invalid or missing supplier_id"

    if status not in PRODUCT_ALLOWED_STATUSES:
        return False, f"Invalid status: '{status}'"

    return True, "Valid"


def validate_products(products):
    valid_products = []
    invalid_products = []
    seen_ids = set()

    for product in products:
        is_valid, reason = validate_product(product)

        if not is_valid:
            invalid_record = product.copy()
            invalid_record["rejection_reason"] = reason
            invalid_products.append(invalid_record)
            continue

        product_id = product["product_id"]
        if product_id in seen_ids:
            invalid_record = product.copy()
            invalid_record["rejection_reason"] = f"Duplicate product_id: {product_id}"
            invalid_products.append(invalid_record)
        else:
            seen_ids.add(product_id)
            valid_products.append(product)

    return valid_products, invalid_products


# End of validating products **********************************************************************
