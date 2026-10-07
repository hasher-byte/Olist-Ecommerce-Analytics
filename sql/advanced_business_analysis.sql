-- ====================================================
-- Advanced / Business Analysis
-- ====================================================

-- RFM Customer Segmentation (classify customers based on Recency, Frequency, and Monetary value)
SELECT a.customer_unique_id, EXTRACT(DAY FROM(CURRENT_DATE - MAX(b.order_purchase_timestamp))) AS recency, 
    COUNT(DISTINCT b.order_id) AS frequency, ROUND(SUM(c.price + c.freight_value), 2) As monetary
FROM customers AS a JOIN orders AS b ON a.customer_id = b.customer_id
    JOIN order_items AS c ON b.order_id = c.order_id
GROUP BY a.customer_unique_id
ORDER BY monetary DESC;

-- First-Time vs Repeat Customer Spending (compares the value of orders made by one-time customers versus repeat customers)
/* CTE1 -> customerwise, orderwise revenue, CTE2 -> calculate no. of orders for each customer, Main -> Join both CTEs
& based on order count calculate no.of cust, no. of orders(CTE2), avg revenue(CTE1) and total revenue(CTE1) */
WITH customer_orders AS (
    SELECT a.customer_unique_id, b.order_id, SUM(c.price + c.freight_value) AS order_value
    FROM customers AS a JOIN orders AS b ON a.customer_id = b.customer_id
        JOIN order_items AS c ON b.order_id = c.order_id
    GROUP BY a.customer_unique_id, b.order_id
),
customer_frequency AS (
    SELECT customer_unique_id, COUNT(*) AS order_count
    FROM customer_orders
    GROUP BY customer_unique_id
)
SELECT (CASE WHEN b.order_count = 1 THEN 'One-time Customer' ELSE 'Repeat Customer' END) AS customer_type,
    COUNT(DISTINCT a.customer_unique_id) AS customers, COUNT(*) AS orders, 
	ROUND(AVG(a.order_value), 2) AS avg_order_value, ROUND(SUM(a.order_value), 2) AS total_revenue
FROM customer_orders AS a JOIN customer_frequency AS b
ON a.customer_unique_id = b.customer_unique_id
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Revenue by Customer Segment and Product Category (which product categories generate revenue from different customer groups)
/* CTE1 -> customerwise, categorywise revenue, CTE2 -> no.of orders for each customer, Main -> Joins both CTEs
& based on order count(CTE2) & product category(CTE1), calculates total revenue(CTE1) */
WITH cust_prod_revenue AS (
    SELECT a.customer_unique_id, b.product_category_name_english, ROUND(SUM(c.price + c.freight_value), 2) AS revenue
    FROM customers AS a JOIN orders AS d ON a.customer_id = d.customer_id
        JOIN order_items AS c ON d.order_id = c.order_id
	    JOIN products_trans AS b ON b.product_id = c.product_id
    GROUP BY a.customer_unique_id, b.product_category_name_english
),
no_of_orders AS (
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
    FROM customers AS a JOIN orders AS b
	ON a.customer_id = b.customer_id
    GROUP BY customer_unique_id
)
SELECT (CASE WHEN b.order_count = 1 THEN 'One-Time Customer' ELSE 'Repeat Customer' END) AS customer_type,
    a.product_category_name_english, ROUND(SUM(a.revenue), 2) AS total_revenue
FROM cust_prod_revenue AS a JOIN no_of_orders AS b
ON a.customer_unique_id = b.customer_unique_id
GROUP BY customer_type, a.product_category_name_english
ORDER BY total_revenue DESC;

/* NOTE: In case of One-Time/Repeat customer case, we'll need 2 CTEs; 1st to calculate no of orders based 
on customer_id & 2nd to calculate other parameters based on customer_id and some other id */

-- Cancelled Orders and Potential Revenue (orders were cancelled/unavailable, and order value associated with them)
SELECT a.order_status, COUNT(DISTINCT a.order_id) AS orders, ROUND(SUM(b.price + b.freight_value), 2) AS order_value
FROM orders AS a LEFT JOIN order_items AS b
ON a.order_id = b.order_id
WHERE a.order_status IN ('canceled', 'unavailable')
GROUP BY a.order_status;

-- Delivery Delay vs Revenue (Dividing revenue in 4 categories & calculating its late delivery rate)
/* Main table -> Calculataing order id wise revenue; Creating 4 categories as per revenue & calculating no of orders 
avg delivery days and late delivery rate based on category; for days parameters we join orders to main table */
SELECT (CASE WHEN a.revenue < 100 THEN 'Under 100' WHEN a.revenue < 300 THEN '100 - 299' WHEN a.revenue < 500 
    THEN '300 - 499' ELSE '500+' END) AS order_value_group, COUNT(*) AS orders, 
	ROUND(AVG(EXTRACT(DAY FROM b.order_delivered_customer_date - b.order_purchase_timestamp)), 2) AS avg_delivery_days,
	ROUND(100.0 * COUNT(*) FILTER (WHERE b.order_delivered_customer_date > b.order_estimated_delivery_date)/COUNT(*), 2) AS late_delivery_rate
FROM(SELECT order_id, ROUND(SUM(price + freight_value), 2) AS revenue
    FROM order_items
    GROUP BY order_id) AS a JOIN orders AS b
ON a.order_id = b.order_id
GROUP BY order_value_group
ORDER BY order_value_group;

-- High Revenue but Low Review Categories (categories that generate high revenue but receive relatively low ratings)
SELECT a.product_category_name_english, ROUND(SUM(b.price + b.freight_value), 2) AS revenue, 
    ROUND(AVG(c.review_score), 2) AS rating
FROM products_trans AS a JOIN order_items AS b ON a.product_id = b.product_id
    JOIN order_reviews AS c ON b.order_id = c.order_id
GROUP BY a.product_category_name_english
ORDER BY revenue DESC, rating ASC;
