from src.config import (
    SILVER_CUSTOMERS_FILE,
    SILVER_ORDER_ITEMS_FILE,
    SILVER_ORDERS_FILE,
    SILVER_PAYMENTS_FILE,
    SILVER_PRODUCTS_FILE,
    INVALID_CUSTOMERS_FILE,
    INVALID_ORDER_ITEMS_FILE,
    INVALID_ORDERS_FILE,
    INVALID_PAYMENTS_FILE,
    INVALID_PRODUCTS_FILE,
    GOLD_CUSTOMER_LIFETIME_VALUE_FILE,
    GOLD_CATEGORY_SALES_PERFORMANCE_FILE,
    GOLD_SHIPPING_CITY_SALES_SUMMARY_FILE
)
from src.io_utils import (
    load_customers,
    load_order_items,
    load_orders,
    load_payments,
    load_products,
    save_csv,
)
from src.normalizers import (
    normalize_customers,
    normalize_order_items,
    normalize_orders,
    normalize_payments,
    normalize_products,
)
from src.validators import (
    validate_customers,
    validate_order_items,
    validate_orders,
    validate_payments,
    validate_products,
)
from src.quality import generate_customer_lifetime_value, generate_category_sales_performance, generate_city_sales_performance


def run_pipeline():
    print("[ETL] Starting Medallion ETL Pipeline (Bronze -> Silver -> Gold)...")

    # 1. Load raw data from Bronze
    raw_customers = load_customers()
    raw_order_items = load_order_items()
    raw_orders = load_orders()
    raw_payments = load_payments()
    raw_products = load_products()

    # 2. Normalize
    norm_customers = normalize_customers(raw_customers)
    norm_order_items = normalize_order_items(raw_order_items)
    norm_orders = normalize_orders(raw_orders)
    norm_payments = normalize_payments(raw_payments)
    norm_products = normalize_products(raw_products)

    # 3. Validate and split (Valid / Invalid)
    valid_cust, invalid_cust = validate_customers(norm_customers)
    valid_items, invalid_items = validate_order_items(norm_order_items)
    valid_orders, invalid_orders = validate_orders(norm_orders)
    valid_pay, invalid_pay = validate_payments(norm_payments)
    valid_prod, invalid_prod = validate_products(norm_products)

    # 4. Save Clean data to Silver
    save_csv(valid_cust, SILVER_CUSTOMERS_FILE)
    save_csv(valid_items, SILVER_ORDER_ITEMS_FILE)
    save_csv(valid_orders, SILVER_ORDERS_FILE)
    save_csv(valid_pay, SILVER_PAYMENTS_FILE)
    save_csv(valid_prod, SILVER_PRODUCTS_FILE)

    # 5. Save Bad data to Invalid (Quarantine)
    save_csv(invalid_cust, INVALID_CUSTOMERS_FILE)
    save_csv(invalid_items, INVALID_ORDER_ITEMS_FILE)
    save_csv(invalid_orders, INVALID_ORDERS_FILE)
    save_csv(invalid_pay, INVALID_PAYMENTS_FILE)
    save_csv(invalid_prod, INVALID_PRODUCTS_FILE)

    # 6. Generate Gold Layer Analytics (Task 1)
    gold_clv = generate_customer_lifetime_value(
        valid_cust, valid_orders, valid_items)
    save_csv(gold_clv, GOLD_CUSTOMER_LIFETIME_VALUE_FILE)

    # TASK 2: Category Sales Performance
    gold_cat = generate_category_sales_performance(valid_prod, valid_items)
    save_csv(gold_cat, GOLD_CATEGORY_SALES_PERFORMANCE_FILE)

    # TASK 3
    gold_clv = generate_city_sales_performance(valid_orders, valid_items)
    save_csv(gold_clv, GOLD_SHIPPING_CITY_SALES_SUMMARY_FILE)

    print("[SUCCESS] PIPELINE COMPLETE:")
    print(
        f"   Customers   -> Valid: {len(valid_cust)} | Invalid: {len(invalid_cust)}")
    print(
        f"   Order Items -> Valid: {len(valid_items)} | Invalid: {len(invalid_items)}")
    print(
        f"   Orders      -> Valid: {len(valid_orders)} | Invalid: {len(invalid_orders)}")
    print(
        f"   Payments    -> Valid: {len(valid_pay)} | Invalid: {len(invalid_pay)}")
    print(
        f"   Products    -> Valid: {len(valid_prod)} | Invalid: {len(invalid_prod)}")
    print(f"[GOLD] Report Created: {GOLD_CUSTOMER_LIFETIME_VALUE_FILE}")
    print(f"[GOLD] Report Created: {GOLD_CATEGORY_SALES_PERFORMANCE_FILE}")
    print(f"[GOLD] Report Created: {GOLD_SHIPPING_CITY_SALES_SUMMARY_FILE}")


if __name__ == "__main__":
    run_pipeline()
