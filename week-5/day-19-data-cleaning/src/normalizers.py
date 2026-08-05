from datetime import datetime

# Normalizing Customers *********************************************************************


def normalize_customer(customer):

    try:
        customer_id = int(str(customer.get("customer_id", "")).strip())
    except (ValueError, TypeError):
        customer_id = None

    full_name = str(customer.get("full_name", "")).strip().title()
    email = str(customer.get("email", "")).strip().lower()

    city = str(customer.get("city", "")).strip().title()
    if not city:
        city = "Unknown"

    country = str(customer.get("country", "")).strip().title()
    if not country:
        country = "Unknown"

    status = str(customer.get("status", "")).strip().lower()

    raw_date = str(customer.get("created_at", "")).strip()
    try:
        parsed_date = datetime.strptime(raw_date, "%Y-%m-%d").date()
        created_at = parsed_date.strftime(
            "%Y-%m-%d")
    except (ValueError, TypeError):
        created_at = raw_date

    return {
        "customer_id": customer_id,
        "full_name": full_name,
        "email": email,
        "city": city,
        "country": country,
        "created_at": created_at,
        "status": status,
    }


def normalize_customers(customers):
    return [normalize_customer(c) for c in customers]
# End of normalizing customers ********************************************************


# Normalizing order items ******************************************************************
def normalize_order_item(order_item):

    try:
        order_item_id = int(str(order_item.get("order_item_id", "")).strip())
    except (ValueError, TypeError):
        order_item_id = None

    try:
        order_id = int(str(order_item.get("order_id", "")).strip())
    except (ValueError, TypeError):
        order_id = None

    try:
        product_id = int(str(order_item.get("product_id", "")).strip())
    except (ValueError, TypeError):
        product_id = None

    try:
        quantity = int(str(order_item.get("quantity", "")).strip())
        if not quantity:
            quantity = None
    except (ValueError, TypeError):
        quantity = None

    try:
        unit_price = float(str(order_item.get("unit_price", "")).strip())
        if not unit_price:
            unit_price = None
    except (ValueError, TypeError):
        unit_price = None

    return {
        "order_item_id": order_item_id,
        "order_id": order_id,
        "product_id": product_id,
        "quantity": quantity,
        "unit_price": unit_price
    }


def normalize_order_items(order_items):
    return [normalize_order_item(oi) for oi in order_items]

# End of normalizing order_items ***************************************************


# Normalizing orders *****************************************************************

def normalize_order(order):

    try:
        order_id = int(str(order.get("order_id", "")).strip())
    except (ValueError, TypeError):
        order_id = None

    try:
        customer_id = int(str(order.get("customer_id", "")).strip())
    except (ValueError, TypeError):
        customer_id = None

    raw_date = str(order.get("order_date", "")).strip()
    try:
        parsed_date = datetime.strptime(raw_date, "%Y-%m-%d").date()
        order_date = parsed_date.strftime(
            "%Y-%m-%d")
    except (ValueError, TypeError):
        order_date = raw_date

    status = str(order.get("status", "")).strip().lower()
    if not status:
        status = "unknown"

    shipping_city = str(order.get("shipping_city", "")).strip().title()
    if not shipping_city:
        shipping_city = "Unknown"

    payment_method = str(order.get("payment_method", "")).strip().title()
    if not payment_method:
        payment_method = "Unknown"

    return {
        "order_id": order_id,
        "customer_id": customer_id,
        "order_date": order_date,
        "status": status,
        "shipping_city": shipping_city,
        "payment_method": payment_method
    }


def normalize_orders(orders):
    return [normalize_order(o) for o in orders]

# End of normalizing orders *********************************************************


# Normalizing payments ******************************************************************

def normalize_payment(payment):
    try:
        payment_id = int(str(payment.get("payment_id", "")). strip())
    except (ValueError, TypeError):
        payment_id = None

    try:
        order_id = int(str(payment.get("order_id", "")).strip())
    except:
        order_id = None

    raw_date = str(payment.get("payment_date", "")).strip()
    try:
        parsed_date = datetime.strptime(raw_date, "%Y-%m-%d").date()
        payment_date = parsed_date.strftime(
            "%Y-%m-%d")
    except (ValueError, TypeError):
        payment_date = raw_date

    try:
        amount = float(str(payment.get("amount", "")).strip())
        if not amount:
            amount = None
    except (ValueError, TypeError):
        amount = None

    currency = str(payment.get("currency", "")).strip().upper()
    # Standardize currency aliases to ISO codes
    CURRENCY_ALIASES = {
        "EURO": "EUR",
        "EUROS": "EUR",
        "DOLLAR": "USD",
        "DOLLARS": "USD",
        "US": "USD",
    }
    currency = CURRENCY_ALIASES.get(currency, currency)
    if not currency:
        currency = "UNKNOWN"

    status = str(payment.get("status", "")).strip().title()
    if not status:
        status = "Unknown"

    payment_method = str(payment.get("payment_method", "")).strip().title()
    if not payment_method:
        payment_method = "Unknown"

    return {
        "payment_id": payment_id,
        "order_id": order_id,
        "payment_date": payment_date,
        "amount": amount,
        "currency": currency,
        "status": status,
        "payment_method": payment_method
    }


def normalize_payments(payments):
    return [normalize_payment(p) for p in payments]

# End of normalizing payments ****************************************************************

# Normalizing products *******************************************************************


def normalize_product(product):
    try:
        product_id = int(str(product.get("product_id")).strip())
    except (ValueError, TypeError):
        product_id = None

    product_name = str(product.get("product_name", "")).strip().title()
    if not product_name:
        product_name = "Unknown"

    category = str(product.get("category", "")).strip().title()
    if not category:
        category = "Unknown"

    try:
        price = float(str(product.get("price", "")).strip())
        if not price:
            price = None
    except (ValueError, TypeError):
        price = None

    try:
        stock_quantity = int(str(product.get("stock_quantity", "")).strip())
        if not stock_quantity:
            stock_quantity = None
    except (ValueError, TypeError):
        stock_quantity = None

    try:
        supplier_id = int(str(product.get("supplier_id", "")).strip())
    except (ValueError, TypeError):
        supplier_id = None

    status = str(product.get("status", "")).strip().lower()
    if not status:
        status = "unknown"

    return {
        "product_id": product_id,
        "product_name": product_name,
        "category": category,
        "price": price,
        "stock_quantity": stock_quantity,
        "supplier_id": supplier_id,
        "status": status
    }


def normalize_products(products):
    return [normalize_product(p) for p in products]

# End of normalizing products ******************************************************************
