-- ====================================================
-- Product Analysis
-- ====================================================

-- Top 10 Products by Revenue
SELECT a.product_id, ROUND(SUM(b.price + b.freight_value), 2) AS revenue
FROM products AS a JOIN order_items AS b
ON a.product_id = b.product_id
GROUP BY a.product_id
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 Products by Quantity Sold = Max quantity for a particular product sold is 527
SELECT product_id, COUNT(*) AS quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY quantity_sold DESC
LIMIT 10;

-- Revenue by Product Category = health_beaulty generates most revenue followed by watches_gifts and bed_bath_table
SELECT a.product_category_name_english AS category, ROUND(SUM(b.price + b.freight_value), 2) AS revenue
FROM products_trans AS a JOIN order_items AS b
ON a.product_id = b.product_id
GROUP BY category
ORDER BY revenue DESC;

-- Quantity Sold by Category = max quantity for product category sold is bed_bath_table followed by health_beauty
SELECT b.product_category_name_english AS category, COUNT(*) AS quantity_sold
FROM order_items AS a JOIN products_trans AS b
ON a.product_id = b.product_id
GROUP BY category
ORDER BY quantity_sold DESC;

-- Average Product Price by Category = computers have highest avg price 1146.80 and home_comfort_2 lowest 39.02
SELECT a.product_category_name_english AS category, ROUND(AVG(b.price + b.freight_value), 2) as avg_price
FROM products_trans AS a JOIN order_items AS b
ON a.product_id = b.product_id
GROUP BY category
ORDER BY avg_price DESC;

-- Products with High Sales but Low Review Scores (sales>500 & rating<3)
SELECT a.product_id
FROM order_items AS a JOIN order_reviews AS b 
ON a.order_id = b.order_id
GROUP BY a.product_id
HAVING SUM(a.price + a.freight_value) > 500 AND AVG(b.review_score) < 3; 