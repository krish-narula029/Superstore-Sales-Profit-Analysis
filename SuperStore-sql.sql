use superstore_db;
show tables;
select count(*) as total_orders from orders;

select * from orders limit 10;
select count(*) as total_returns from returns;
select count(*) as total_people from people;
select count(*) as total_records from orders;
select count(*) as total_records from returns;
select count(*) as total_records from people;

select 
(select count(*) from orders) as orders_records,
(select count(*) from returns) as returns_records,
(select count(*) from people) as people_records;

describe orders;
select * from orders limit 10;
select count(*) as total_rows from orders;
alter table orders change column ï»¿order_id order_id text;
select count(*) as total_rows, count(order_id) as non_null_order_ids, count(distinct order_id) as unique_order_ids from orders;

select count(*) as total_rows, count(distinct order_id) as unique_orders from orders;
select sum(order_id is null or order_id = '') as missing_order_id,
sum(order_date is null or order_id = '') as missing_order_date,
sum(customer_name is null or customer_name = '') as missing_customer,
sum(sales is null or sales = '') as missing_sales,
sum(profit is null or profit = '') as missing_profit from orders;

select sum(sales) as total_sales,sum(profit) as total_profit, sum(quantity) as total_quantity, count(distinct order_id) as total_orders,
sum(sales) / count(distinct order_id) as average_order_value, sum(profit) / sum(sales) * 100 as profit_margin from orders;

select date_format(order_date, '%Y-%m') as month, sum(sales) as total_sales, sum(profit) as total_profit from orders
group by date_format(order_date, '%Y-%m') order by month;

select category, sum(sales) as total_sales, sum(profit) as total_profit, sum(quantity) as total_quantity, sum(profit) / sum(sales) * 100
as profit_margin from orders group by category order by total_sales desc;

select sub_category, sum(sales) as total_sales, sum(profit) as total_profit, sum(quantity) as total_quantity, sum(profit) / sum(sales) * 100 
as profit_margin from orders group by sub_category order by total_profit desc;

select sub_category, sum(sales) as total_sales, sum(profit) as total_profit from orders group by sub_category
having sum(profit) < 0 order by total_profit desc;

select customer_name, count(distinct order_id) as total_orders, sum(sales) as total_sales, sum(profit) as total_profit
from orders group by customer_name order by total_sales desc limit 10;

select customer_name, sum(sales) as total_sales, sum(profit) as total_profit, sum(profit) / sum(sales) * 100 as profit_margin
from orders group by customer_name having sum(sales) > 1000 order by profit_margin;

select region, sum(sales) as total_sales, sum(profit) as total_profit, sum(profit) / sum(sales) * 100 as profit_margin from orders
group by region order by total_sales desc;

select state, sum(sales) as total_sales, sum(profit) as total_profit from orders
group by state order by total_profit desc limit 10;

select state, sum(sales) as total_sales, sum(profit) as total_profit from orders
group by state order by total_profit limit 10;

select count(distinct r.order_id) as returned_orders, count(distinct o.order_id) as total_orders, count(distinct r.order_id) * 100.0 / 
count(distinct o.order_id) as return_rate from orders as o left join returns as r on o.order_id = r.order_id;

select o.category,count(distinct o.order_id) as total_orders, count(distinct r.order_id) as returned_orders, count(distinct r.order_id) * 100.0
/ count(distinct o.order_id) as return_rate from orders o left join returns r on o.order_id = r.order_id group by o.category
order by return_rate desc;

select ship_mode, count(distinct o.order_id) as total_orders,sum(sales) as total_sales, sum(profit) as total_profit, sum(profit) / sum(sales) * 100 as profit_margin
from orders group by ship_mode order by total_profit desc;

select count(*) as return_records from returns;

drop view if exists monthly_sales;
create view monthly_sales as
select date_format(order_date, '%Y-%m') as month, sum(sales) as total_sales, sum(profit) as total_profit from orders group by
month;

select * from monthly_sales;

select customer_name, sum(sales) as total_sales, sum(profit) as total_profit, count(distinct order_id) as total_orders from orders
group by customer_name order by total_sales desc limit 20;

select customer_name, sum(sales) as total_sales, sum(profit) as total_profit from orders group by customer_name order by total_profit asc
limit 10;

select category, count(distinct order_id) as toal_orders, sum(sales) as total_sales, sum(profit) as total_profit, round(sum(profit) / sum(sales) 
* 100,2) as profit_margin from orders group by category order by total_profit desc;

describe orders;
select product_name, sum(sales) as total_sales, sum(profit) as total_profit from orders group by product_name having sum(profit) < 0
order by total_profit asc limit 10;

drop view if exists category_performance;
create view category_performance as
select category, count(distinct order_id) as total_orders, sum(sales) as total_sales, sum(profit) as total_profit, round(sum(profit) / sum(sales) *
100,2) as profit_margin from orders group by category;

select * from category_performance;

select customer_name, sum(sales) as total_sales, sum(profit) as total_profit, count(distinct order_id) as total_orders from orders 
group by customer_name order by total_sales desc limit 10;

select customer_name, sum(sales) as total_sales, sum(profit) as total_profit from orders group by customer_name having sum(profit) < 0 
order by total_profit asc limit 10;

select category, count(distinct order_id) as total_orders, sum(sales) as total_sales, sum(profit) as total_profit, round(sum(profit) / sum(sales)
* 100 / 2 )as profit_margin from orders group by category order by total_profit desc;

select discount, count(*) as total_orders, sum(sales) as total_sales, sum(profit) as total_profit, round(sum(profit) / sum(sales)
* 100 / 2 ) as profit_margin from orders group by discount order by discount;

select year(str_to_date(order_date, '%m/%d/%Y'))as order_year, sum(sales) as total_sales, sum(profit) as total_profit, round(sum(profit) / sum(sales) * 100,2) as profit_margin
from orders group by year(str_to_date(order_date, '%m/%d/%Y')) order by order_year;

describe people;
alter table people change column ï»¿person person text;
select p.person, o.region, count(distinct o.order_id) as total_orders, round(sum(o.sales),2) as total_sales, round(sum(o.profit),2) as total_profit
from orders o join people p on o.region = p.region group by p.person, o.region order by total_profit desc;

select o.ship_mode, count(distinct o.order_id) as total_orders, count(distinct r.order_id) as returned_orders, round(count(distinct r.order_id) * 100.0 / count(distinct o.order_id),2 )as return_rate,
round(sum(o.sales),2) as total_sales, round(sum(o.profit),2) as total_profit from orders o left join returns r on o.order_id = r.order_id
group by o.ship_mode order by return_rate desc;