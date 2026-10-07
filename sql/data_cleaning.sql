-- ====================================================
-- Data Cleaning (Fix the identified problems)
-- ====================================================

/* Handling NULL values*/
-- orders = NULL vlaues may signify unfulfilled orders, thus we don't replace them

-- order_reviews = setting NULL values as 'Unknown'
UPDATE order_reviews
SET review_comment_title = 'Unknown'
WHERE review_comment_title IS NULL;

UPDATE order_reviews
SET review_comment_message = 'Unknown'
WHERE review_comment_message IS NULL;

-- products 
UPDATE products
SET product_category_name = 'unknown', product_name_lenght = 0, product_description_lenght = 0, product_photos_qty = 0
WHERE product_category_name IS NULL;

UPDATE products
SET product_weight_g = 0, product_length_cm = 0, product_height_cm = 0, product_width_cm = 0
WHERE product_weight_g IS NULL; 


/* Removing Duplicate values */
-- geolocation = have duplicate rows but no need to remove as it give geographical info which can repeat


/* Correcting incorrect values and Standardizing*/
-- Since None incorrect values found, no cleaning for it

-- 'products' contain product_category_name in portugese whereas its translation is present in 'category_translation'
SELECT a.*, b.product_category_name_english
FROM products AS a LEFT JOIN category_translation AS b
ON a.product_category_name = b.product_category_name;

CREATE TABLE products_trans AS
SELECT *
FROM (SELECT a.*, b.product_category_name_english
      FROM products AS a LEFT JOIN category_translation AS b
      ON a.product_category_name = b.product_category_name);

SELECT * FROM products_trans;