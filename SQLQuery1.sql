For the below schema for a clinic management system,
1. Revenue from each sales channel in a given year
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2023
GROUP BY sales_channel
ORDER BY total_revenue DESC;
 2. Top 10 most valuable customers (based on revenue)
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(t.amount) AS total_revenue
FROM transactions t
JOIN customers c 
    ON t.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;
 3. Month-wise revenue, expense, profit, status
SELECT 
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(amount) AS revenue,
    SUM(expense) AS expense,
    SUM(amount) - SUM(expense) AS profit,
    CASE 
        WHEN SUM(amount) - SUM(expense) > 0 THEN 'PROFITABLE'
        ELSE 'NOT-PROFITABLE'
    END AS status
FROM transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2023
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY month;
 4. Most profitable clinic per city (for a given month)
WITH clinic_profit AS (
    SELECT 
        c.city,
        c.clinic_id,
        c.clinic_name,
        SUM(t.amount - t.expense) AS profit
    FROM transactions t
    JOIN clinics c 
        ON t.clinic_id = c.clinic_id
    WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
      AND EXTRACT(MONTH FROM t.transaction_date) = 5
    GROUP BY c.city, c.clinic_id, c.clinic_name
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 1;
 5. Second least profitable clinic per state (for a given month)
WITH clinic_profit AS (
    SELECT 
        c.state,
        c.clinic_id,
        c.clinic_name,
        SUM(t.amount - t.expense) AS profit
    FROM transactions t
    JOIN clinics c 
        ON t.clinic_id = c.clinic_id
    WHERE EXTRACT(YEAR FROM t.transaction_date) = 2023
      AND EXTRACT(MONTH FROM t.transaction_date) = 5
    GROUP BY c.state, c.clinic_id, c.clinic_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 2;