-- RAW SUPERSTORE SALES DATA CLEANING

select * from superstore_orders;

create table orders(
	like superstore_orders
);

insert into orders
select * from superstore_orders;

select * from orders;

-- Dropping unnecessary columns

alter table orders drop column row_id;
alter table orders drop column city;
alter table orders drop column product_name;

-- Understanding Data

select count(*) from orders;

select count(*) as col_counts
from information_schema.columns
where table_name = 'orders';

select distinct category from orders;
select distinct sub_category from orders;

-- Removing Duplicates based on all Columns i.e full matching rows

select *,
	row_number() over(partition by order_id, order_date, ship_date, ship_mode, customer_id,
	state, product_id, category, sub_category, sales, quantity, discount, profit ) as row_num
from orders;

with duplicates as(
	select ctid,
		row_number() over(partition by order_id, order_date, ship_date, ship_mode, customer_id,
		state, product_id, category, sub_category, sales, quantity, discount, profit ) as row_num
	from orders
)
select * from duplicates
where row_num > 1;

with duplicates as(
	select ctid
	from(
		select ctid,
		row_number() over(partition by order_id, order_date, ship_date, ship_mode, customer_id,
		state, product_id, category, sub_category, sales, quantity, discount, profit 
		order by ctid) as row_num
		from orders
	)t
	where row_num > 1	
)
delete from orders
where ctid in (select ctid from duplicates);

select count(*) from orders;

-- standardizing and formatting values

-- Trim whitespaces

update orders
set order_id = trim(order_id),
	order_date = trim(order_date),
	ship_date = trim(ship_date),
	ship_mode = trim(ship_mode),
	customer_id = trim(customer_id),
	state = trim(state),
	product_id = trim(product_id),
	category = trim(category),
	sub_category = trim(sub_category),
	sales = trim(sales),
	quantity = trim(quantity),
	discount = trim(discount),
	profit = trim(profit);

-- convert empty string to null

update orders
set order_id = nullif(order_id,''),
	order_date = nullif(order_date,''),
	ship_date = nullif(ship_date,''),
	ship_mode = nullif(ship_mode,''),
	customer_id = nullif(customer_id,''),
	state = nullif(state,''),
	product_id = nullif(product_id,''),
	category = nullif(category,''),
	sub_category = nullif(sub_category,''),
	sales = nullif(sales,''),
	quantity = nullif(quantity,''),
	discount = nullif(discount,''),
	profit = nullif(profit,'');

select * from orders;

-- Standardizing category column

select distinct category from orders;

update orders
set category = 'Furniture'
where category = 'Furni';

update orders
set category = 'Technology'
where category = 'Tech';

update orders
set category = 'Technology'
where category = 'technologies';

update orders
set category = 'Office Supply'
where category = 'OfficeSupply';

select * from orders;

select distinct sub_category from orders;
select distinct state from orders;

-- Standardizing Date formats

select order_date, ship_date from orders;

update orders
set order_date = replace(order_date,'/','-');

update orders
set ship_date = replace(ship_date,'/','-');

select order_date, to_date(order_date,'MM-DD-YYYY')
from orders;

update orders
set order_date = to_date(order_date,'MM-DD-YYYY');

update orders
set ship_date = to_date(ship_date,'MM-DD-YYYY');

select * from orders;

-- Deleting records with same order_id and product_id as they are duplicates.

select order_id, count(distinct product_id) as product_count
from orders
group by 1
having count(distinct product_id) = 1;

with duplicates as(
	select ctid
	from(
		select ctid,
		row_number() over(partition by order_id, product_id 
		order by ctid) as row_num
		from orders
	)t
	where row_num > 1	
)
delete from orders
where ctid in (select ctid from duplicates);

select order_id, product_id, count(*)
from orders
group by 1,2
having count(*) > 1;

-- Preventing Duplicates forever

alter table orders
add constraint uq_order_product unique(order_id,product_id);

select * from orders;

-- Handling Null values

select * from orders
where discount is null or discount = '';

update orders
set discount = '0'
where discount is null or trim(discount) = '';

alter table orders
alter column discount
set default 0;        -- set default value to zero

update orders
set sales = replace(sales,',',''),
	profit = replace(profit,',','')
where sales like '%,%' or profit like '%,%';

-- Converting all types of data to their specific type and creating new cleaned table

create table cleaned_superstore_orders as
select
    order_id::text as order_id,

    order_date::date AS order_date,
    ship_date::date AS ship_date,

    ship_mode::text AS ship_mode,
    customer_id::text AS customer_id,
    state::text AS state,
    product_id::text AS product_id,
    category::text AS category,
    sub_category::text AS sub_category,

    sales::numeric AS sales,
    quantity::integer AS quantity,
    discount::numeric AS discount,
    profit::numeric AS profit
from orders;

select * from cleaned_superstore_orders;

select
  (select count(*) from orders)       as raw_rows,
  (select count(*) from cleaned_superstore_orders) as clean_rows;

alter table cleaned_superstore_orders
add constraint unique_order_product unique (order_id, product_id);

alter table cleaned_superstore_orders
alter column discount set default 0;

----------------------------------------------------------------------------------