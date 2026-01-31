select * from cleaned_superstore_orders;

--Understanding Data
--Number of Rows and Columns
select count(*) from cleaned_superstore_orders;
select count(*) as column_count
from information_schema.columns
where table_name = 'cleaned_superstore_orders';

--Order Date Range
select min(order_date) as first_order_date, 
	max(order_date) as last_order_date
from cleaned_superstore_orders;

--Unique Customers and Products per Order
select order_id, count(distinct customer_id) as unique_customers, count(distinct product_id) as unique_products
from cleaned_superstore_orders
group by 1
order by 2 desc;

--Unique Categories per Order
select order_id, count(distinct category) as unique_category
from cleaned_superstore_orders
group by 1;

------------------------------------------------------------------------------------------------------------------
--Total Sales and Profit of Superstore
select 
	sum(sales) as total_sales,
	sum(profit) as total_profit
from cleaned_superstore_orders;

--Minimum and Maximum Sales and Profit
select 
	min(sales) as min_sales,
	max(sales) as max_sales,
	min(profit) as mix_profit,
	max(profit) as max_profit
from cleaned_superstore_orders;

--What is the Sales per Year?
select extract(year from order_date) as Year,
sum(sales) as sales_per_year
from cleaned_superstore_orders
group by 1
order by 1;

--What is the Average Order Value?
select round(sum(sales)*1.0/count(distinct order_id)) as avg_order_value
from cleaned_superstore_orders;

--How are total sales distributed across product categories, 
--and what percentage does each category contribute to overall sales?
select category, sum(sales) as total_sales,
round(sum(sales)*100.0/sum(sum(sales)) over(),2) AS sales_percentage
from cleaned_superstore_orders
group by 1
order by 2 desc;

--Within each product category, how do different sub-categories contribute to category-level sales?
select category, sub_category, round(sum(sales)) as total_sales,
sum(sum(sales)) over(partition by category) as sales_per_category
from cleaned_superstore_orders
group by 1,2
order by 1,3;

--Which states generate the highest total sales?
select state, round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by 1
order by 2 desc;

------------------------------------------------------------------------------------------------------------------
--Time series Analysis
--Which Year had the highest sales?
select extract(year from order_date) as Year,
	round(sum(sales)) as total_sales,
	rank() over(order by sum(sales) desc) as sales_rank
from cleaned_superstore_orders
group by 1;

--Toatal Sales by month
select 
    to_char(order_date,'Month') as Month,
    extract(month from order_date) as Month_no,
	round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by 1,2
order by 2;

--How do sales evolve month-by-month?
select 
    date_trunc('month', order_date) as year_month,
    round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by year_month
order by year_month;

--Is profit increasing along with sales?
select 
    date_trunc('month', order_date) as year_month,
	round(sum(sales)) as total_sales,
    round(sum(profit)) as total_profit
from cleaned_superstore_orders
group by year_month
order by year_month;

--What is the Year over Year growth percentage?
with yearly_sales as(
    select
    extract(Year from order_date) as Year,
	round(sum(sales)) as TotalSales
	from cleaned_superstore_orders
	group by Year
)
select Year,TotalSales,
round((TotalSales - lag(TotalSales) over(order by Year))
	* 100.0 / lag(TotalSales) over(order by Year),2) as YoY_growth_percentage
from yearly_sales
order by Year;

--What is the Year over Year growth percentage?
with monthly_sales as(
    select
    date_trunc('month',order_date) as month,
	round(sum(sales)) as TotalSales
	from cleaned_superstore_orders
	group by month
)
select month,TotalSales,
round((TotalSales - lag(TotalSales) over(order by month))
	* 100.0 / lag(TotalSales) over(order by month),2) as MoM_growth_percentage
from monthly_sales
order by month;

------------------------------------------------------------------------------------------------------------------
--Geographic (State) level Analysis.
--Metrics Analysis by state
select 
	state,
	count(distinct order_id) as total_orders,
	round(sum(sales),2) as total_sales,
	round(sum(profit),2) as total_profit
from cleaned_superstore_orders
group by 1
order by total_sales desc;
	
--Per Sate profit margin
select
	state,
	round(sum(sales),2) as total_sales,
	round(sum(profit),2) as total_profit,
	round(sum(profit) / nullif(sum(sales),0) * 100 ,2) as profit_margin
from cleaned_superstore_orders
group by state
order by profit_margin desc;

--Loss making states
select 
	state, round(sum(profit)) as total_profit
from cleaned_superstore_orders
group by state
having round(sum(profit)) < 0
order by total_profit;

--Category Performance by State
select state, category,
	round(sum(sales),2) as total_sales,
	round(sum(profit),2) as total_profit
from cleaned_superstore_orders
group by state, category
order by state, total_sales;

--Top & Bottom States
select state, round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by state
order by 2 desc
limit 5;

select state, round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by state
order by 2 asc
limit 5;
------------------------------------------------------------------------------------------------------------------
-- Customer Segmentation
-- Customer Aggregation
select customer_id,
	round(sum(sales)) as total_sales,
	round(sum(profit)) as total_profit,
	round(avg(discount),2) as avg_discount
from cleaned_superstore_orders
group by 1;

select 
	customer_id, 
	total_sales,
	ntile(3) over(order by total_sales desc) as sales_bucket
from(
	select 
		customer_id, 
		round(sum(sales)) as total_sales
	from cleaned_superstore_orders
	group by customer_id
)t;

--Repeat vs One Time customers
select 
	customer_id,
	count(distinct order_id) as order_count,
	case
		when count(distinct order_id) = 1 then 'One-Time'
		when count(distinct order_id) between 2 and 5  then 'Occasional'
		else 'Frequent'
	end as customer_type
from cleaned_superstore_orders
group by customer_id;

--Discount segmentation
update cleaned_superstore_orders
set discount = discount * 10;

select 
	customer_id,
	round(avg(discount),2) as avg_discount,
	round(sum(profit)) as total_profit,
	case
		when avg(discount) = 0 then 'No Discount'
		when avg(discount) <= 0.2 then 'Low Discount'
		else 'High Discount'
	end as discount_type
from cleaned_superstore_orders
group by customer_id;
------------------------------------------------------------------------------------------------------------------
--Product Analysis
--Top 10 products by sales
select product_id, category, sub_category, round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by product_id, category, sub_category
order by 4 desc
limit 10;

--Bottom 10 products by sales
select product_id, category, sub_category, round(sum(sales)) as total_sales
from cleaned_superstore_orders
group by product_id, category, sub_category
order by 4 asc
limit 10;

--Top 10 products by profit
select product_id, category, sub_category, round(sum(profit)) as total_profit
from cleaned_superstore_orders
group by product_id, category, sub_category
order by 4 desc
limit 10;

--Bottom 10 products by profit
select product_id, category, sub_category, round(sum(profit)) as total_profit
from cleaned_superstore_orders
group by product_id, category, sub_category
order by 4 asc
limit 10;
------------------------------------------------------------------------------------------------------------------

