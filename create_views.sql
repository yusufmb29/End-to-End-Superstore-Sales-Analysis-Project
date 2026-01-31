
create view monthly_sales_profit_trend as
select 
    date_trunc('month', order_date) as year_month,
	round(sum(sales)) as total_sales,
    round(sum(profit)) as total_profit
from cleaned_superstore_orders
group by year_month
order by year_month;

select * from monthly_sales_profit_trend;

select *
from monthly_sales_profit_trend
where total_profit < 0;
-------------------------------------------------------------------------------------------------------------------
create view state_performance_summary as
select state, category,
	count(distinct order_id ) as total_orders,
	round(sum(sales),2) as total_sales,
	round(sum(profit),2) as total_profit
from cleaned_superstore_orders
group by state, category
order by state, total_sales;

select * from state_performance_summary;

--Which Sate generates highest sales?
select state, total_sales
from state_performance_summary
order by total_sales desc;

--Which states are most profitable?
select state, total_profit
from state_performance_summary
order by total_profit desc;

--Which sates have highest order volumn?
select state, sum(total_orders) as orders
from state_performance_summary
group by state
order by orders desc;
-------------------------------------------------------------------------------------------------------------------
