-- ====================================================
-- Advanced Customer Analysis
-- ==================================================== 

-- Customer Purchase Frequency (how frequently customers place orders)
SELECT purchase_freq, COUNT(*) AS customer_count
FROM(
    SELECT a.customer_unique_id, COUNT(DISTINCT b.order_id) AS purchase_freq
    FROM customers AS a JOIN orders AS b
    ON a.customer_id = b.customer_id
    GROUP BY a.customer_unique_id)
GROUP BY purchase_freq
ORDER BY purchase_freq DESC;

-- High-Value Customers (customers who spends more than the average customer)
/* S1: Avg value spent by all customers */
SELECT ROUND(AVG(total_spending), 2) AS avg_spending
FROM(
    SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
    FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
        JOIN order_items AS b  ON c.order_id = b.order_id
    GROUP BY a.customer_unique_id) AS t;

/* S2: customers spending > avg value */
SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
    JOIN order_items AS b  ON c.order_id = b.order_id
GROUP BY a.customer_unique_id
HAVING ROUND(SUM(b.price + b.freight_value), 2) > (SELECT ROUND(AVG(total_spending), 2) AS avg_spending
FROM(
    SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
    FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
        JOIN order_items AS b  ON c.order_id = b.order_id
    GROUP BY a.customer_unique_id) AS t)
ORDER BY total_spending DESC;

-- Customer Revenue Ranking (Ranking customers based on their total spending)
SELECT *, RANK() OVER(ORDER BY total_spending DESC) AS spending_rank
FROM(SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
    JOIN order_items AS b  ON c.order_id = b.order_id
GROUP BY a.customer_unique_id);


-- Customer Segmentation (Classifying customers based on their total spending)
/* total_spending >= 1000 -> 'High Value'; total_spending < 500 -> 'Low Value'; else -> 'Mid Value' */
SELECT *, (CASE WHEN total_spending >= 1000 THEN 'High Value' WHEN total_spending < 500 THEN 'Low Value' ELSE 'Mid Value' END) AS customer_segment
FROM(SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
    FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
        JOIN order_items AS b  ON c.order_id = b.order_id
    GROUP BY a.customer_unique_id) AS t;

-- Revenue Contribution by Customer Segment (which customer segment contributes the most revenue)
SELECT (CASE WHEN total_spending >= 1000 THEN 'High Value' WHEN total_spending < 500 THEN 'Low Value' ELSE 'Mid Value' END) AS customer_segment,
    COUNT(customer_unique_id) AS customer_count, ROUND(SUM(total_spending), 2) AS revenue
FROM(SELECT a.customer_unique_id, ROUND(SUM(b.price + b.freight_value), 2) AS total_spending
    FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
        JOIN order_items AS b  ON c.order_id = b.order_id
    GROUP BY a.customer_unique_id) AS t 
GROUP BY customer_segment
ORDER BY revenue DESC;

-- Monthly Customer Growth (how the number of new customers changes over time)
SELECT acquisition_month, COUNT(*) AS new_customers
FROM(SELECT a.customer_unique_id, DATE_TRUNC('month', MIN(b.order_purchase_timestamp)) AS acquisition_month
    FROM customers AS a JOIN orders AS b
    ON a.customer_id = b.customer_id
    GROUP BY a.customer_unique_id)
GROUP BY acquisition_month
ORDER BY acquisition_month;
/* DATE_TRUNC('month', ...) = truncates date to 1st of ever month i.e. we'll only get year & month */
