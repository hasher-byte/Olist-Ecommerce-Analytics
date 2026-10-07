# Olist-Ecommerce-Analytics

An end-to-end E-Commerce Data Analytics project using the Brazilian Olist dataset. The project combines Python, PostgreSQL, Pandas, Matplotlib, and Seaborn to analyze sales, customers, products, sellers, delivery performance, reviews, and payment behavior.


## Project Overview

The objective of this project is to analyse Olist's e-commerce data to identify trends and patterns in sales, revenue, customer behavior, product performance, seller performance, delivery, customer satisfaction, and payment behavior.

The project was developed in multiple stages:

**CSV Data → Data Inspection → Schema & Relationships → SQL Analysis → Python Visualization → Business Insights**


## Dataset

The dataset was obtained from Kaggle:

**Brazilian E-Commerce Public Dataset by Olist**

🔗 [Kaggle Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data)

**Dataset Files**

| File | Description |
|---|---|
| `olist_customers_dataset.csv` | Customer information |
| `olist_orders_dataset.csv` | Order information and order status |
| `olist_order_items_dataset.csv` | Products and sellers associated with orders |
| `olist_order_payments_dataset.csv` | Payment information |
| `olist_order_reviews_dataset.csv` | Customer reviews and ratings |
| `olist_products_dataset.csv` | Product information |
| `olist_sellers_dataset.csv` | Seller information |
| `olist_geolocation_dataset.csv` | Brazilian location and ZIP-code data |
| `product_category_name_translation.csv` | Product category translations |


## Tools & Technologies

- PostgreSQL
- SQL
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- SQLAlchemy
- Jupyter Notebook


## Analysis

The project analyzes the Olist e-commerce database to identify trends and patterns in sales, customers, products, sellers, delivery performance, reviews, and payments.

**Key Areas**

- KPI Analysis — revenue, orders, customers, average order value, delivery time, review score, and late delivery rate
- Sales & Revenue Analysis — monthly trends, state-wise revenue, category performance, top products, and top sellers
- Customer Analysis — customer spending, repeat purchases, customer acquisition, and RFM segmentation
- Product Analysis — product and category revenue, sales volume, pricing, and review performance
- Seller Analysis — seller revenue, order volume, ratings, seller concentration, and performance
- Delivery & Review Analysis — delivery time, estimated vs actual delivery, delays, and customer satisfaction
- Payment Analysis — payment methods, payment values, and installment preferences
- Advanced Analysis — revenue concentration, customer segments, category trends, product rankings, seller performance, and business patterns


## Key Insights

- Identified overall sales and revenue trends and analyzed their changes over time.
- Identified the major customer states, product categories, products, and sellers contributing to revenue.
- Found that a large proportion of customers make only one purchase, highlighting the importance of customer retention.
- Identified high-value and frequent customers using customer spending and RFM segmentation.
- Found that high sales volume does not always result in the highest revenue because product prices vary across categories.
- Identified revenue concentration among a relatively small group of products, categories, sellers, and customers.
- Analyzed seller performance and found that revenue and customer ratings are not necessarily directly correlated.
- Found that late deliveries generally receive lower customer review scores.
- Analyzed payment preferences and installment behavior to understand customer purchasing patterns.


## Project Structure
```text
Olist-Ecommerce-Analytics/
│
├── data/
│   ├── olist_customers_dataset.csv
│   ├── olist_geolocation_dataset.csv
│   ├── olist_order_items_dataset.csv
│   ├── olist_order_payments_dataset.csv
│   ├── olist_order_reviews_dataset.csv
│   ├── olist_orders_dataset.csv
│   ├── olist_products_dataset.csv
│   ├── olist_sellers_dataset.csv
│   └── product_category_name_translation.csv
│
├── sql/
│   ├── advanced_business_analysis.sql
│   ├── advanced_customer_analysis.sql
│   ├── advanced_sales&product_analysis.sql
│   ├── advanced_seller_analysis.sql
│   ├── create_table.sql
│   ├── customer_analysis.sql
│   ├── data_cleaning.sql
│   ├── data_validation.sql
│   ├── delivery_analysis.sql
│   ├── kpi_analysis.sql
│   ├── payment_analysis.sql
│   ├── product_analysis.sql
│   ├── review_analysis.sql
│   ├── sales_analysis.sql
│   └── seller_analysis.sql
│
├── notebooks/
│   ├── Data_Inspection.ipynb
│   └── Olist_Ecommerce_Analytics.ipynb
│
├── documentation/
│   └── Olist_Database_Schema_and_Relationships.docx
│
├── README.md
└── requirements.txt
```

## How to Run

### 1. Clone the repository
git clone https://github.com/hasher-byte/Olist-Ecommerce-Analytics.git

### 2. Navigate to the project directory
cd Olist-Ecommerce-Analytics

### 3. Install the required libraries
pip install -r requirements.txt

### 4. Set up PostgreSQL
Create a PostgreSQL database and import the Olist dataset tables.

Update the database connection details in:
notebooks/Olist_Ecommerce_Analytics.ipynb

### 5. Start Jupyter Notebook
jupyter notebook

Open:

notebooks/Data_Inspection.ipynb

and then:

notebooks/Olist_Ecommerce_Analytics.ipynb

Run the notebook cells sequentially.


## Author

**Harshit Singh**\
Aspiring Data Analyst\
✉️ Email: harshitsingh0801@gmail.com\
🔗 [LinkedIn](https://www.linkedin.com/in/harshit-singh-a08b681bb/)
