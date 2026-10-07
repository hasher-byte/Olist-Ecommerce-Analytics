-- ====================================================
-- Data Validation (Find and verify problems)
-- ====================================================

/* Total rows */
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items
UNION ALL
SELECT 'order_payments' AS table_name, COUNT(*) AS row_count FROM order_payments
UNION ALL
SELECT 'order_reviews' AS table_name, COUNT(*) AS row_count FROM order_reviews
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'sellers' AS table_name, COUNT(*) AS row_count FROM sellers
UNION ALL
SELECT 'geolocation' AS table_name, COUNT(*) AS row_count FROM geolocation
UNION ALL
SELECT 'category_translation' AS table_name, COUNT(*) AS row_count FROM category_translation;


/* Checking NULL values */
-- orders = order_approved_at, order_delivered_carrier_date & order_delivered_customer_date
SELECT
    COUNT(*) - COUNT(order_id) AS order_id_nulls,
    COUNT(*) - COUNT(customer_id) AS customer_id_nulls,
    COUNT(*) - COUNT(order_status) AS status_nulls,
    COUNT(*) - COUNT(order_purchase_timestamp) AS purchase_date_nulls,
	COUNT(*) - COUNT(order_approved_at) AS approved_at_nulls,
	COUNT(*) - COUNT(order_delivered_carrier_date) AS carrier_date_nulls,
    COUNT(*) - COUNT(order_delivered_customer_date) AS customer_date_nulls,
	COUNT(*) - COUNT(order_estimated_delivery_date) AS delivery_date_nulls
FROM orders;

-- order_items = No NULL values
SELECT
    COUNT(*) - COUNT(order_id) AS order_id_nulls,
	COUNT(*) - COUNT(order_item_id) AS order_item_id_nulls,
    COUNT(*) - COUNT(product_id) AS product_id_nulls,
    COUNT(*) - COUNT(seller_id) AS seller_id_nulls,
    COUNT(*) - COUNT(shipping_limit_date) AS shipping_limit_date_nulls,
	COUNT(*) - COUNT(price) AS price_nulls,
    COUNT(*) - COUNT(freight_value) AS freight_nulls
FROM order_items;

-- order_reviews = review_comment_title & review_comment_message
SELECT
    COUNT(*) - COUNT(review_id) AS review_id_nulls,
	COUNT(*) - COUNT(order_id) AS order_id_nulls,
    COUNT(*) - COUNT(review_score) AS review_score_nulls,
    COUNT(*) - COUNT(review_comment_title) AS comment_title_nulls,
    COUNT(*) - COUNT(review_comment_message) AS comment_message_nulls,
	COUNT(*) - COUNT(review_creation_date) AS creation_date_nulls,
    COUNT(*) - COUNT(review_answer_timestamp) AS answer_timestamp_nulls
FROM order_reviews;

-- products = product_category_name, product_name_lenght, product_description_lenght & product_photos_qty
SELECT
    COUNT(*) - COUNT(product_id) AS product_id_nulls,
    COUNT(*) - COUNT(product_category_name) AS category_nulls,
	COUNT(*) - COUNT(product_name_lenght) AS name_lenght_nulls,
	COUNT(*) - COUNT(product_description_lenght) AS description_lenght_nulls,
	COUNT(*) - COUNT(product_photos_qty) AS photos_qty_nulls,
	COUNT(*) - COUNT(product_weight_g) AS weight_nulls,
	COUNT(*) - COUNT(product_length_cm) AS length_nulls,
	COUNT(*) - COUNT(product_height_cm) AS height_nulls,
    COUNT(*) - COUNT(product_width_cm) AS width_nulls
FROM products;


/* Duplicate rows */
-- customers = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id) AS row_num
     FROM customers)
WHERE row_num > 1;

-- orders = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id) AS row_num
     FROM orders)
WHERE row_num > 1;

-- order_items = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id, order_item_id) AS row_num
     FROM order_items)
WHERE row_num > 1;

-- order_payments = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY order_id, payment_sequential) AS row_num
     FROM order_payments)
WHERE row_num > 1;

-- order_reviews = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY review_id, order_id) AS row_num
     FROM order_reviews)
WHERE row_num > 1;

-- products = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY product_id) AS row_num
     FROM products)
WHERE row_num > 1;

-- sellers = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY seller_id) AS row_num
     FROM sellers)
WHERE row_num > 1;

-- geolocation = multiple rows
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY geolocation_zip_code_prefix) AS row_num
     FROM geolocation)
WHERE row_num > 1;

-- category_translation = 0
SELECT *
FROM(SELECT *, ROW_NUMBER() OVER(PARTITION BY product_category_name) AS row_num
     FROM category_translation)
WHERE row_num > 1;


/* Checking Incorrect values */
-- Delivery before purchase = None
SELECT *
FROM orders 
WHERE order_purchase_timestamp > order_approved_at OR order_purchase_timestamp > order_delivered_customer_date
      OR order_purchase_timestamp > order_estimated_delivery_date;

-- Negative price or freight_value = None
SELECT *
FROM order_items
WHERE price < 0 OR freight_value < 0;

-- Review score = None
SELECT * 
FROM order_reviews
WHERE review_score < 1 OR review_score > 5;