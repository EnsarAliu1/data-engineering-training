--Payment reconciliation
SELECT
    o.order_id,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS expected_total,
    ROUND(COALESCE(SUM(p.amount), 0), 2) AS paid_total,

    CASE
        WHEN COALESCE(SUM(p.amount), 0) = 0 THEN 'missing payment'
        WHEN SUM(p.amount) < 0 THEN 'refunded'
        WHEN SUM(p.amount) = SUM(oi.quantity * oi.unit_price) THEN 'matched'
        WHEN SUM(p.amount) < SUM(oi.quantity * oi.unit_price) THEN 'underpaid'
        WHEN SUM(p.amount) > SUM(oi.quantity * oi.unit_price) THEN 'overpaid'
    END AS payment_status

FROM orders o

JOIN order_items oi
    ON oi.order_id = o.order_id

LEFT JOIN payments p
    ON p.order_id = o.order_id

GROUP BY o.order_id
ORDER BY o.order_id;