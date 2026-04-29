CREATE VIEW sales_summary AS
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales)*1.0 / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM superstore_orders;
---------------------------------------------------------------------------------------------------------

CREATE VIEW sales_by_year AS
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_orders
GROUP BY 1
ORDER BY 1;
---------------------------------------------------------------------------------------------------------

CREATE VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore_orders
GROUP BY 1
ORDER BY 1;
---------------------------------------------------------------------------------------------------------

CREATE VIEW category_performance AS
SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS profit_margin
FROM superstore_orders
GROUP BY category;

select * from category_performance;
---------------------------------------------------------------------------------------------------------

CREATE VIEW state_performance AS
SELECT 
    state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales),0) * 100, 2) AS profit_margin
FROM superstore_orders
GROUP BY state;

select * from state_performance;
---------------------------------------------------------------------------------------------------------

CREATE VIEW yoy_sales_growth AS
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales) AS total_sales
    FROM superstore_orders
    GROUP BY 1
)
SELECT 
    year,
    total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year)) 
        * 100.0 / LAG(total_sales) OVER (ORDER BY year),
    2) AS yoy_growth
FROM yearly_sales;

select * from yoy_sales_growth;
---------------------------------------------------------------------------------------------------------

CREATE VIEW category_contribution AS
SELECT 
    category,
    SUM(sales) AS total_sales,
    ROUND(
        SUM(sales) * 100.0 / SUM(SUM(sales)) OVER(), 
    2) AS sales_percentage
FROM superstore_orders
GROUP BY category;

select * from category_contribution;
---------------------------------------------------------------------------------------------------------
