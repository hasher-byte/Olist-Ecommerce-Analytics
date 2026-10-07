-- ====================================================
-- Review Analysis
-- ====================================================

-- Overall Review Score Distribution = most customers have given rating of 5
SELECT review_score, COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY total_reviews DESC;

-- Average Review Score = 4.09
SELECT ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews;

-- Review Score by Order Status = Highest customer rating is provided for 'delivered' whereas lowest for 'processing'
SELECT a.order_status, ROUND(AVG(b.review_score), 2) AS review_score, COUNT(*) AS total_reviews
FROM orders AS a JOIN order_reviews AS b
ON a.order_id = b.order_id
GROUP BY a.order_status
ORDER BY review_score DESC;

-- Review Score by Product Category = Highest customer rating is provided for 'cds_dvds_musicals'
SELECT a.product_category_name_english AS product_category, ROUND(AVG(b.review_score), 2) AS review_score
FROM products_trans AS a JOIN order_items AS c ON a.product_id = c.product_id
    JOIN order_reviews AS b ON b.order_id = c.order_id
GROUP BY product_category
ORDER BY review_score DESC;

-- Review Score by Customer State = Customers from AP state has rated highest 4.19 whereas RR has rated lowest 3.61
SELECT a.customer_state AS state, ROUND(AVG(b.review_score), 2) AS review_score 
FROM customers AS a JOIN orders AS c ON a.customer_id = c.customer_id
    JOIN order_reviews AS b ON b.order_id = c.order_id
GROUP BY state
ORDER BY review_score DESC;

-- Review Score vs Delivery Delay = late deliveries are lead to lower ratings (Delayed = 2.57 & On Time = 4.29)
SELECT (CASE WHEN a.order_delivered_customer_date > a.order_estimated_delivery_date THEN 'Delayed' ELSE 'On Time' END)
    AS delay_status, ROUND(AVG(b.review_score), 2) AS review_score
FROM orders AS a JOIN order_reviews AS b
ON a.order_id = b.order_id
WHERE a.order_delivered_customer_date IS NOT NULL
GROUP BY delay_status;

-- Reviews with Comments vs Without Comments = 3.67 & 4.38 respectively
SELECT (CASE WHEN review_comment_message = 'Unknown' THEN 'Review w/o Comments' ELSE 'Review with Comments' END)
    AS comment_status, ROUND(AVG(review_score), 2) AS review_score, COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY comment_status;