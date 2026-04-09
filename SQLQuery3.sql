
Given the below schema for a hotel management system,
For every user, get the user_id and last booked room_no
SELECT user_id, room_no
FROM (
    SELECT 
        b.user_id,
        b.room_no,
        ROW_NUMBER() OVER (PARTITION BY b.user_id ORDER BY b.created_at DESC) AS rn
    FROM bookings b
) t
WHERE rn = 1;

Uses ROW_NUMBER() to get the latest booking per user.

2. Booking_id and total billing amount for bookings in Nov 2021
SELECT 
    b.booking_id,
    SUM(bl.bill_amount) AS total_billing
FROM bookings b
JOIN bills bl 
    ON b.booking_id = bl.booking_id
WHERE b.created_at >= '2021-11-01'
  AND b.created_at < '2021-12-01'
GROUP BY b.booking_id;

 Filters bookings in November and aggregates billing.

3. Bills in October 2021 with amount > 1000
SELECT 
    bill_id,
    bill_amount
FROM bills
WHERE bill_date >= '2021-10-01'
  AND bill_date < '2021-11-01'
  AND bill_amount > 1000;
4. Most ordered and least ordered item of each month in 2021
WITH item_counts AS (
    SELECT 
        EXTRACT(MONTH FROM o.order_date) AS month,
        o.item_id,
        SUM(o.quantity) AS total_qty
    FROM orders o
    WHERE EXTRACT(YEAR FROM o.order_date) = 2021
    GROUP BY month, o.item_id
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS max_rank,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS min_rank
    FROM item_counts
)
SELECT 
    r.month,
    i.item_name,
    r.total_qty,
    CASE 
        WHEN max_rank = 1 THEN 'MOST_ORDERED'
        WHEN min_rank = 1 THEN 'LEAST_ORDERED'
    END AS category
FROM ranked r
JOIN items i 
    ON r.item_id = i.item_id
WHERE max_rank = 1 OR min_rank = 1
ORDER BY month, category;
5. Customers with second highest bill value of each month in 2021
WITH monthly_bills AS (
    SELECT 
        b.user_id,
        EXTRACT(MONTH FROM bl.bill_date) AS month,
        SUM(bl.bill_amount) AS total_bill
    FROM bills bl
    JOIN bookings b 
        ON bl.booking_id = b.booking_id
    WHERE EXTRACT(YEAR FROM bl.bill_date) = 2021
    GROUP BY b.user_id, month
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS rnk
    FROM monthly_bills
)
SELECT 
    user_id,
    month,
    total_bill
FROM ranked
WHERE rnk = 2;

 DENSE_RANK() ensures proper handling of ties.