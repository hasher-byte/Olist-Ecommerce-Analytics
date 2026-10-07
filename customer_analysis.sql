-- ====================================================
-- Customer Analysis
-- ====================================================

-- Customers by State = SP has highest no. of customers followed by RJ and MG whereas RR has least count
SELECT customer_state AS state, COUNT(DISTINCT customer_unique_id) AS customer_count
FROM customers
GROUP BY state
ORDER BY customer_count DESC;

-- Orders per Customer = Max orders placed by a single customer is 17 followed by 9 and 7
SELECT order_count, COUNT(*) AS customers
FROM(
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
    FROM customers AS a JOIN orders AS b
    ON a.customer_id = b.customer_id
    GROUP BY customer_unique_id) 
GROUP BY order_count
ORDER BY order_count;

-- Top 10 Customers by Spending = 13664.08 is the max spending by customer
SELECT a.customer_unique_id, ROUND(SUM(c.price + c.freight_value), 2) AS total_spending
FROM customers AS a JOIN orders AS b ON a.customer_id = b.customer_id
    JOIN order_items AS c ON b.order_id = c.order_id
GROUP BY a.customer_unique_id
ORDER BY total_spending DESC
LIMIT 10;

-- Repeat vs One-Time Customers
SELECT (CASE WHEN frequency = 1 THEN 'One-Time' ELSE 'Repeat' END) AS cust_type, COUNT(*) AS total_customers
FROM(
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS frequency
    FROM customers AS a JOIN orders AS b
    ON a.customer_id = b.customer_id
    GROUP BY customer_unique_id
    ORDER BY frequency DESC)
GROUP BY cust_type;

-- Customer Acquisition by Month = Most customers were acquired in Aug followed by May and July whereas least was acquired in Sept
SELECT EXTRACT(MONTH FROM b.order_purchase_timestamp) AS months, COUNT(a.customer_unique_id) AS cust_acquired
FROM customers AS a JOIN orders AS b
ON a.customer_id = b.customer_id
GROUP BY months
ORDER BY cust_acquired DESC;