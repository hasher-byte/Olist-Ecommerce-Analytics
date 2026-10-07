-- ====================================================
-- Advanced Sales & Product Analysis
-- ==================================================== 

-- Monthly Revenue Growth (how revenue changes compared with the previous month)
/* Inner -> Monthwise revenue, Outer -> calculate LAG and growth_percentage */
SELECT *, LAG(revenue) OVER() AS previous_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER())/LAG(revenue) OVER())*100, 2) AS growth_percentage
FROM(SELECT DATE_TRUNC('month', a.order_purchase_timestamp) AS months, ROUND(SUM(b.price + b.freight_value), 2) AS revenue
    FROM orders AS a JOIN order_items AS b
    ON a.order_id = b.order_id
    GROUP BY months)
ORDER BY months;

-- Top Categories by Revenue Within Each Year (best-performing categories for each year)
/* Inner -> Yearwise, categorywise revenue, Outer -> Ranking based on year and revenue (desc) calculated */
SELECT *, RANK() OVER(PARTITION BY year ORDER BY revenue DESC) AS yearwise_rank
FROM(SELECT EXTRACT(YEAR FROM a.order_purchase_timestamp) AS year, c.product_category_name_english AS product_category,
        ROUND(SUM(b.price + b.freight_value), 2) revenue
    FROM orders as a JOIN order_items AS b ON a.order_id = b.order_id
        JOIN products_trans AS c ON b.product_id = c.product_id
    GROUP BY year, product_category) AS t;

-- Top 10 Products by Revenue Within Each Category (strongest products inside each category)
/* CTE: Inner -> categorywise, productwise revenue, Outer -> Ranking based on category & revenue (desc)
   Main: Filter rank <= 10 */
WITH ranked AS (
SELECT *, RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS categorywise_rank
FROM(SELECT a.product_category_name_english AS category, a.product_id, ROUND(SUM(b.price + b.freight_value), 2) AS revenue
    FROM products_trans AS a JOIN order_items AS b
    ON a.product_id = b.product_id
    GROUP BY category, a.product_id) AS t
)
SELECT * 
FROM ranked 
WHERE categorywise_rank <= 10;

-- Category Revenue Contribution % (what percentage of total revenue each category contributes)
/* Inner -> categorywise revenue, Outer -> divide it by total revenue achieved via SUM windows function */
SELECT *, ROUND((revenue/SUM(revenue) OVER())*100, 2) AS revenue_percentage
FROM(SELECT a.product_category_name_english AS category,  ROUND(SUM(b.price + b.freight_value), 2) AS revenue
    FROM products_trans AS a JOIN order_items AS b
    ON a.product_id = b.product_id
    GROUP BY category) AS t
ORDER BY revenue_percentage DESC;

-- Product Price vs Sales Volume (how sales of product units vary with prices)
SELECT product_id, ROUND(SUM(price), 2) AS product_price, COUNT(*) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY product_price DESC;

-- Top Categories by Revenue Growth (each category's revenue between years)
SELECT a.product_category_name_english AS category, EXTRACT(YEAR from c.order_purchase_timestamp) AS year, 
    ROUND(SUM(b.price + b.freight_value), 2) AS revenue
FROM products_trans AS a JOIN order_items AS b ON a.product_id = b.product_id
    JOIN orders AS c ON b.order_id = c.order_id
GROUP BY category, year
ORDER BY category ASC, year ASC;

-- Revenue Concentration — Top 10% Products (how much of the total revenue comes from top 10% products by revenue)
/* Inner -> productwise revenue, Middle -> Calculate % revenue contribution of each product & divide entire rows into 10 using ntile, 
Outer -> Filter top 10% i.e. ntile = 1 & calc sum of revenue contribution which gives % share of top 10 % products by revenue */
SELECT ROUND(SUM(percent_cont), 2) AS top_10_percent_revenue_share
FROM(SELECT *, (revenue/(SUM(revenue) OVER()))*100 AS percent_cont, NTILE(10) OVER (ORDER BY revenue DESC) AS bucket
    FROM(SELECT product_id, ROUND(SUM(price + freight_value), 2) AS revenue
        FROM order_items
        GROUP BY product_id) AS t)
WHERE bucket = 1;