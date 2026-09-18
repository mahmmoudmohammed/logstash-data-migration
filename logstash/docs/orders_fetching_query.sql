

SELECT

    o.id,
    COALESCE(o.updated_at, o.created_at) AS sync_cursor,

    o.order_number,
    o.status,
    o.payment_status,
    o.currency,

    o.subtotal,
    o.discount,
    o.shipping_cost,
    o.tax,
    o.total,

    o.created_at,
    o.updated_at,


    JSON_OBJECT(
            'id', c.id,
            'name', c.name,
            'email', c.email,
            'mobile', c.mobile
    ) AS customer,

    JSON_OBJECT(
            'id', sa.id,
            'country', sa.country,
            'city', sa.city,
            'address', sa.address,
            'postal_code', sa.postal_code
    ) AS shipping_address,

    COALESCE(
            (
                SELECT JSON_ARRAYAGG(
                               JSON_OBJECT(
                                       'id', oi.id,
                                       'product_id', oi.product_id,
                                       'product_name', oi.product_name,
                                       'quantity', oi.quantity,
                                       'unit_price', oi.unit_price,
                                       'discount', oi.discount,
                                       'total',
                                       (
                                           (oi.quantity * oi.unit_price)
                                               - COALESCE(oi.discount, 0)
                                           )
                               )
                       )
                FROM order_items oi
                WHERE oi.order_id = o.id
            ),
            JSON_ARRAY()
    ) AS items,


    IF(
            o.payment_status = 'paid',
            1,
            0
    ) AS paid,

    IF(
            o.status IN ('completed', 'delivered'),
            1,
            0
    ) AS completed,

    IF(
            o.status IN ('cancelled', 'refunded'),
            1,
            0
    ) AS cancelled
FROM orders o

         LEFT JOIN customers c
                   ON c.id = o.customer_id

         LEFT JOIN shipping_addresses sa
                   ON sa.id = o.shipping_address_id

WHERE COALESCE(o.updated_at, o.created_at) > :sql_last_value
ORDER BY sync_cursor ASC