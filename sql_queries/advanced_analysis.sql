/*=====================================================================
Business Question 11

Objective:
Identify the top 10 stores with the highest inventory value using a CTE.

Business Value:
Demonstrates the use of Common Table Expressions (CTEs) to improve
query readability and maintainability.

Concepts Used:
- CTE
- INNER JOIN
- GROUP BY
=====================================================================*/

with store_inventory as (
    select s.store_id,
        s.store_name,
        sum(i.stock_on_hand * p.product_cost) as inventory_value
    from inventory as i
    inner join stores as s
        on i.store_id = s.store_id
    inner join products as p
        on i.product_id = p.product_id
    group by s.store_id,
        s.store_name
)

select
    *
from store_inventory
order by inventory_value desc
limit 10;



/*=====================================================================
Business Question 12

Objective:
Rank all products based on inventory value.

Concepts Used:
- CTE
- ROW_NUMBER()
=====================================================================*/

with inventory_summary as (

select p.product_id,
    p.product_name,
    sum(i.stock_on_hand*p.product_cost) as inventory_value
from inventory i
inner join products p
    on i.product_id=p.product_id
group by p.product_id,
    p.product_name

)

select
    *,
    row_number() over(order by inventory_value desc) as product_rank
from inventory_summary;



/*=====================================================================
Business Question 13

Objective:
Assign dense ranks to products.

Concepts Used:
- DENSE_RANK()
=====================================================================*/

with inventory_summary as (

select p.product_name,
    sum(i.stock_on_hand*p.product_cost) as inventory_value
from inventory i
inner join products p
    on i.product_id=p.product_id
group by p.product_name
)

select *,
    dense_rank() over(order by inventory_value desc) as dense_rank1
from inventory_summary;



/*=====================================================================
Business Question 14

Objective:
Rank products inside every product category.

Concepts Used:
- PARTITION BY
- RANK()
=====================================================================*/

with inventory_summary as (

select p.product_category,
    p.product_name,
    sum(i.stock_on_hand*p.product_cost) as inventory_value
from inventory i
inner join products p
    on i.product_id=p.product_id
group by p.product_category,
    p.product_name

)

select *,
    rank() over(
        partition by product_category
        order by inventory_value desc
    ) as category_rank
from inventory_summary;



/*=====================================================================
Business Question 15

Objective:
Find the best-selling products.

Concepts Used:
- SUM()
- GROUP BY
=====================================================================*/

select p.product_name,
    sum(s.units) as total_units_sold
from sales s
inner join products p
    on s.product_id=p.product_id
group by p.product_id,
    p.product_name
order by total_units_sold desc
limit 10;



/*=====================================================================
Business Question 16

Objective:
Find stores with highest sales volume.

Concepts Used:
- GROUP BY
- SUM()
=====================================================================*/

select st.store_name,
    sum(sa.units) as total_units_sold
from sales sa
inner join stores st
    on sa.store_id=st.store_id
group by st.store_id,
    st.store_name
order by total_units_sold desc;



/*=====================================================================
Business Question 17

Objective:
Analyze monthly sales trend.

Concepts Used:
- MONTH()
- YEAR()
=====================================================================*/

select year(sale_date) as sales_year,
    month(sale_date) as sales_month,
    sum(units) as total_units
from sales
group by year(sale_date),
    month(sale_date)
order by sales_year,
    sales_month;
    
    
    
    /*=====================================================================
Business Question 18

Objective:
Calculate cumulative sales.

Concepts Used:
- Window Function
- SUM() OVER()
=====================================================================*/

select sale_date,
    sum(units) as daily_sales,
    sum(sum(units))
        over(order by sale_date) as running_total
from sales
group by sale_date
order by sale_date;
    
    
    
    
/*=====================================================================
Business Question 19

Objective:
Find products whose sales are above average.

Concepts Used:
- Correlated Subquery
=====================================================================*/

select p.product_name,
    sum(s.units) as total_units
from sales s
inner join products p
    on s.product_id=p.product_id
group by p.product_id,
    p.product_name
having sum(s.units)>
(
    select avg(total_sales)
    from
    (
        select sum(units) as total_sales
        from sales
        group by product_id
    ) x
);



/*=====================================================================
Business Question 20

Objective:
Generate an executive inventory dashboard.

Concepts Used:
- CTE
- CASE
- Window Functions
- Aggregates
=====================================================================*/

with inventory_summary as (
select p.product_name,
    p.product_category,
    sum(i.stock_on_hand) as units,
    sum(i.stock_on_hand*p.product_cost) as inventory_value
from inventory i
inner join products p
    on i.product_id=p.product_id
group by p.product_name,
    p.product_category

)

select *,
    case
        when inventory_value>=7000 then 'High'
        when inventory_value>=5000 then 'Medium'
        else 'Low'
    end as investment_level,
    rank() over(order by inventory_value desc) as inventory_rank
from inventory_summary
order by inventory_rank;    