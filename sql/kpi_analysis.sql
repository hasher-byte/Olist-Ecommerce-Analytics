-- ====================================================
-- KPI Analysis
-- ====================================================

-- Total Orders = 99441
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- Total Revenue = 15843553.24
SELECT ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items;

-- Total Customers = 96096
SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Total Products Sold = 32951
SELECT COUNT(DISTINCT product_id) AS total_items_sold
FROM products;

-- Total Sellers = 3095
SELECT COUNT(DISTINCT seller_id) AS total_sellers
FROM sellers;

-- Average revenue per order = 160.58
SELECT ROUND(AVG(revenue_per_order), 2) AS avg_revenue_per_order
FROM(
    SELECT order_id, SUM(price + freight_value) AS revenue_per_order
    FROM order_items
    GROUP BY order_id);

-- Average Items per Order = 1.37
SELECT ROUND(AVG(items_per_order), 2) AS avg_items_per_order
FROM(
    SELECT order_id, SUM(order_item_id) AS items_per_order
    FROM order_items
    GROUP BY order_id);

-- Average Delivery Time = 23.40 days
SELECT ROUND(AVG(EXTRACT(DAYS FROM (order_estimated_delivery_date - order_purchase_timestamp))), 2) AS avg_delivery_time
FROM orders;

-- Average Review Score = 4.09 
SELECT ROUND(AVG(review_score), 2) AS avg_review_score
FROM order_reviews;

-- Order Status Distribution
SELECT *, ROUND((order_count*1.0/(SELECT COUNT(*) FROM orders)*100), 2) AS order_percent
FROM(
    SELECT order_status, COUNT(*) AS order_count
    FROM orders
    GROUP BY order_status)
ORDER BY order_percent DESC;

-- Repeat Customer Rate = 3.01
SELECT ROUND((COUNT(customer_unique_id)*1.0/(SELECT COUNT(*) FROM customers))*100, 2) AS repeat_customer_rate
FROM(
    SELECT a.customer_unique_id, COUNT(b.order_id) AS order_count
    FROM customers AS a JOIN orders AS b
    ON a.customer_id = b.customer_id
    GROUP BY a.customer_unique_id)
WHERE order_count > 1;