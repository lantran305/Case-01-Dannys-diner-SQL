-- 1. Tổng số tiền mỗi khách hàng đã chi.
SELECT
    s.customer_id,
    SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2. Mỗi khách hàng đã ghé nhà hàng bao nhiêu ngày khác nhau?
SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;

-- 3. Món đầu tiên mỗi khách hàng mua.
WITH ranked_sales AS (
    SELECT
        s.customer_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date, s.sale_id
        ) AS purchase_rank
    FROM sales s
    JOIN menu m ON m.product_id = s.product_id
)
SELECT customer_id, product_name AS first_item
FROM ranked_sales
WHERE purchase_rank = 1
ORDER BY customer_id;

-- 4. Món được mua nhiều nhất và tổng số lần mua.
WITH item_counts AS (
    SELECT
        m.product_name,
        COUNT(*) AS purchase_count
    FROM sales s
    JOIN menu m ON m.product_id = s.product_id
    GROUP BY m.product_name
),
ranked_items AS (
    SELECT
        product_name,
        purchase_count,
        RANK() OVER (ORDER BY purchase_count DESC) AS item_rank
    FROM item_counts
)
SELECT product_name, purchase_count
FROM ranked_items
WHERE item_rank = 1;

-- 5. Món được mua nhiều nhất của từng khách hàng (giữ lại mọi trường hợp đồng hạng).
WITH customer_item_counts AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(*) AS purchase_count
    FROM sales s
    JOIN menu m ON m.product_id = s.product_id
    GROUP BY s.customer_id, m.product_name
),
ranked_customer_items AS (
    SELECT
        customer_id,
        product_name,
        purchase_count,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY purchase_count DESC
        ) AS item_rank
    FROM customer_item_counts
)
SELECT customer_id, product_name, purchase_count
FROM ranked_customer_items
WHERE item_rank = 1
ORDER BY customer_id, product_name;

-- 6. Món đầu tiên khách hàng mua sau khi trở thành thành viên.
WITH ranked_member_sales AS (
    SELECT
        s.customer_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date, s.sale_id
        ) AS purchase_rank
    FROM sales s
    JOIN members mb
        ON mb.customer_id = s.customer_id
       AND s.order_date >= mb.join_date
    JOIN menu m ON m.product_id = s.product_id
)
SELECT customer_id, product_name AS first_item_after_join
FROM ranked_member_sales
WHERE purchase_rank = 1
ORDER BY customer_id;

-- 7. Món được mua ngay trước khi khách hàng trở thành thành viên.
WITH ranked_pre_member_sales AS (
    SELECT
        s.customer_id,
        m.product_name,
        s.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY s.customer_id
            ORDER BY s.order_date DESC, s.sale_id
        ) AS purchase_rank
    FROM sales s
    JOIN members mb
        ON mb.customer_id = s.customer_id
       AND s.order_date < mb.join_date
    JOIN menu m ON m.product_id = s.product_id
)
SELECT customer_id, product_name AS last_item_before_join
FROM ranked_pre_member_sales
WHERE purchase_rank = 1
ORDER BY customer_id;

-- 8. Trước khi trở thành thành viên, mỗi khách hàng đã mua bao nhiêu món
--    và chi tổng cộng bao nhiêu?
SELECT
    s.customer_id,
    COUNT(*) AS items_purchased,
    SUM(m.price) AS total_spent
FROM sales s
JOIN members mb
    ON mb.customer_id = s.customer_id
   AND s.order_date < mb.join_date
JOIN menu m ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9. Điểm thưởng đến hết tháng 1/2021: sushi được 2x điểm,
--    mọi món khác được 10 điểm cho mỗi đô la.
SELECT
    s.customer_id,
    SUM(
        m.price * CASE
            WHEN m.product_name = 'sushi' THEN 20
            ELSE 10
        END
    ) AS points
FROM sales s
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < DATE '2021-02-01'
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 10. Tổng điểm đến hết tháng 1/2021, cộng điểm 2x cho mọi món trong
--     tuần đầu tiên sau khi gia nhập (tính cả ngày gia nhập).
SELECT
    mb.customer_id,
    SUM(
        m.price * CASE
            WHEN m.product_name = 'sushi'
              OR (
                  s.order_date >= mb.join_date
                  AND s.order_date < mb.join_date + 7
              )
            THEN 20
            ELSE 10
        END
    ) AS total_points
FROM members mb
JOIN sales s
    ON s.customer_id = mb.customer_id
   AND s.order_date < DATE '2021-02-01'
JOIN menu m ON m.product_id = s.product_id
GROUP BY mb.customer_id
ORDER BY mb.customer_id;
