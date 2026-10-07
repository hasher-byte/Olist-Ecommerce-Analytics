--1. customers table
CREATE TABLE customers(
customer_id VARCHAR(50) PRIMARY KEY,
customer_unique_id VARCHAR(50),
customer_zip_code_prefix INTEGER,
customer_city VARCHAR(100),
customer_state VARCHAR(10)
);

COPY customers
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_customers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM customers;
SELECT COUNT(*) FROM customers;


--2. geolocation table
CREATE TABLE geolocation(
geolocation_zip_code_prefix INT,
geolocation_lat FLOAT(6),
geolocation_lng FLOAT(6),             
geolocation_city VARCHAR(50),  
geolocation_state VARCHAR(50)
);

COPY geolocation
FROM 'C:/Users/harsh/Documents/Projects/Olist Ecommerce Analytics/data/olist_geolocation_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM geolocation;
SELECT COUNT(*) FROM geolocation;


--3. orders table
CREATE TABLE orders(
order_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(50),
order_status VARCHAR(50),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP,
FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

COPY orders
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_orders_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM orders;
SELECT COUNT(*) FROM orders;


--4. order_items table
CREATE TABLE order_items(
order_id VARCHAR(50),
order_item_id INT, 
product_id VARCHAR(50), 
seller_id VARCHAR(50), 
shipping_limit_date TIMESTAMP, 
price DECIMAL(10,2),
freight_value DECIMAL(10,2),
PRIMARY KEY(order_id, order_item_id)
);

COPY order_items
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_order_items_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM order_items;
SELECT COUNT(*) FROM order_items;


--5. order_payments table
CREATE TABLE order_payments(
order_id VARCHAR(50),         
payment_sequential INT,   
payment_type VARCHAR(50),        
payment_installments INT,  
payment_value DECIMAL(10,2),
PRIMARY KEY(order_id, payment_sequential)
);

COPY order_payments
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_order_payments_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM order_payments;
SELECT COUNT(*) FROM order_payments;


--6. order_reviews table
CREATE TABLE order_reviews(
review_id VARCHAR(50),
order_id VARCHAR(50),
review_score INT,
review_comment_title TEXT,
review_comment_message TEXT,
review_creation_date TIMESTAMP,
review_answer_timestamp TIMESTAMP,
PRIMARY KEY (review_id, order_id)
);

COPY order_reviews
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_order_reviews_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM order_reviews;
SELECT COUNT(*) FROM order_reviews;


--7. products table
CREATE TABLE products(
product_id VARCHAR(50) PRIMARY KEY,  
product_category_name VARCHAR(50), 
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT
);

COPY products
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_products_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM products;
SELECT COUNT(*) FROM products;


--8. sellers table
CREATE TABLE sellers(
seller_id VARCHAR(50) PRIMARY KEY,
seller_zip_code_prefix INT, 
seller_city VARCHAR(50), 
seller_state VARCHAR(50)
);

COPY sellers
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\olist_sellers_dataset.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM sellers;
SELECT COUNT(*) FROM sellers;


--9. category_translation table
CREATE TABLE category_translation(
product_category_name VARCHAR(50) PRIMARY KEY,
product_category_name_english VARCHAR(50)
);

COPY category_translation
FROM 'C:\Users\harsh\Documents\Projects\Olist Ecommerce Analytics\data\product_category_name_translation.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"'
);

SELECT * FROM category_translation;
SELECT COUNT(*) FROM category_translation;