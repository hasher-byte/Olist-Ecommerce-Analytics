-- ====================================================
-- Payment Analysis
-- ====================================================

-- Payment Method Distribution = Most frequent payment mode is via cedit_card
SELECT payment_type, COUNT(*) AS total_users
FROM order_payments
GROUP BY payment_type
ORDER BY total_users DESC;

-- Revenue by Payment Method = credit_card account for most payment value
SELECT a.payment_type, ROUND(SUM(b.price + b.freight_value), 2) As revenue
FROM order_payments AS a JOIN order_items AS b
ON a.order_id = b.order_id 
GROUP BY a.payment_type
ORDER BY revenue DESC;

-- Average Payment Value by Payment Method = credit_card account for highest average payment value
SELECT a.payment_type, ROUND(AVG(payment_value)) As avg_payment_value
FROM order_payments AS a JOIN order_items AS b
ON a.order_id = b.order_id 
GROUP BY a.payment_type
ORDER BY avg_payment_value DESC;

-- Payment Installments
SELECT payment_installments, COUNT(*) AS total_payments, ROUND(SUM(payment_value), 2) AS total_payment
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

-- Payment Method vs Review Score = customers using debit_card as payment mode have given the highest rating
SELECT a.payment_type, ROUND(AVG(b.review_score), 2) AS review_score
FROM order_payments AS a JOIN order_reviews AS b
ON a.order_id = b.order_id
GROUP BY a.payment_type
HAVING COUNT(*) > 10
ORDER BY review_score DESC;

-- Payment Method by Customer State (payment perferences varied geographically)
SELECT b.customer_state, a.payment_type, COUNT(*) AS statewise_payment_count
FROM order_payments AS a JOIN orders AS c ON a.order_id = c.order_id
    JOIN customers AS b ON c.customer_id = b.customer_id
GROUP BY b.customer_state, a.payment_type
ORDER BY statewise_payment_count DESC;