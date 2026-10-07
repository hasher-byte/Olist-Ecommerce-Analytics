-- ====================================================
-- Delivery Analysis
-- ====================================================

-- Average Delivery Time = 12.09 days
SELECT ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))), 2) AS avg_delivery_days
FROM orders;

-- Average Estimated vs Actual Delivery Time = 23.40 and 12.09 days i.e. order is delivered earlier than expected date
SELECT ROUND(AVG(EXTRACT(DAY FROM order_estimated_delivery_date - order_purchase_timestamp)), 2) AS estimated_delivery_days,
    ROUND(AVG(EXTRACT(DAY FROM order_delivered_customer_date - order_purchase_timestamp)), 2) AS actual_delivery_days
FROM orders;

-- Late Delivery Rate = 8.11 %
SELECT ROUND((COUNT(*) FILTER(WHERE order_delivered_customer_date > order_estimated_delivery_date AND order_status = 'delivered') 
	/ COUNT(*))*100, 2) AS late_delivery_rate
FROM orders;

-- Delivery Time by Customer State = SP has least delivery time of 8.30 days whereas RR has most of 28.96 days 
SELECT a.customer_state AS state, 
    AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))) AS delivery_time
FROM customers AS a JOIN orders AS b
ON a.customer_id = b.customer_id
GROUP BY state
ORDER BY delivery_time ASC;

-- Delivery Time by Seller State = RS has least delivery time of 11.09 days whereas AM has most of 47.33 days 
SELECT a.seller_state AS state, 
    AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamp))) AS delivery_time
FROM sellers AS a JOIN order_items AS c ON a.seller_id = c.seller_id
    JOIN orders AS b ON c.order_id = b.order_id
GROUP BY state
ORDER BY delivery_time ASC;

-- Delivery Time by Order Status = For delivered it is 12.09 days & for canceled it is 19.83 days
SELECT order_status, COUNT(*) AS total_orders,
    ROUND(AVG(EXTRACT(DAY FROM order_delivered_customer_date - order_purchase_timestamp)), 2) AS delivery_time
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY order_status;

-- Delivery Time vs Review Score = longer delivery times are associated with lower customer ratings
SELECT b.review_score, ROUND(AVG(EXTRACT(DAY FROM a.order_delivered_customer_date - a.order_purchase_timestamp)), 2) 
    AS delivery_time
FROM orders AS a JOIN order_reviews AS b
ON a.order_id = b.order_id
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY b.review_score
ORDER BY b.review_score DESC;

-- Average Delivery Time by Months
SELECT EXTRACT(MONTH FROM order_purchase_timestamp) AS month, 
    ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamP))), 2) AS avg_delivery_days
FROM orders
GROUP BY month
ORDER BY month;

-- Actual vs Estimated Delivery Time trend
SELECT EXTRACT(MONTH FROM order_purchase_timestamp) AS month, 
    ROUND(AVG(EXTRACT(DAY FROM (order_delivered_customer_date - order_purchase_timestamP))), 2) AS avg_delivery_days,
    ROUND(AVG(EXTRACT(DAY FROM (order_estimated_delivery_date - order_purchase_timestamP))), 2) AS estimated_delivery_days
FROM orders
GROUP BY month
ORDER BY month;