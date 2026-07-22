/*=====================================================================
Project : Maven Toys SQL Business Analytics

Description:
This project analyzes Maven Toys retail data to answer key business
questions using SQL. The analysis covers inventory management,
sales performance, profitability, and business KPIs.

Dataset:
- Products
- Stores
- Inventory
- Sales

Author: Venkkateshan
=====================================================================*/

/*=====================================================================
Business Question 1

Objective:
Calculate the inventory value of each store.

Business Value:
Helps identify stores with the highest inventory investment.

Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
- ORDER BY
=====================================================================*/

select s.store_name,
       sum(i.stock_on_hand * p.product_cost) as inventory_value
from inventory as i
inner join stores as s
 on i.store_id = s.store_id
inner join products as p
 on i.product_id = p.product_id
group by s.store_id,
         s.store_name
order by inventory_value desc,
         s.store_name asc;
         
         
         
/*=====================================================================
Business Question 02

Objective:
Identify stores whose inventory value is greater than the average
inventory value across all stores.

Business Value:
Stores carrying significantly higher inventory require closer
monitoring for inventory investment and holding costs.

Concepts Used:
- INNER JOIN
- GROUP BY
- HAVING
- Subquery
=====================================================================*/

select s.store_name, 
	   sum(i.stock_on_hand*p.product_cost)as inventory_value
from inventory as i
inner join stores as s
	on s.store_id=i.store_id
inner join products as p
	on p.product_id=i.product_id
group by s.store_id,
		 s.store_name
having sum(i.stock_on_hand*p.product_cost) >
		(
          select avg(inventory_value)
          from(
			   select sum(i.stock_on_hand*p.product_cost)as inventory_value
               from inventory i
               inner join products as p
					on p.product_id=i.product_id
				group by i.store_id) as store_inventory
		)
order by inventory_value desc;



/*=====================================================================
Business Question 03

Objective:
Identify the top 10 products with the highest inventory value across
all stores.

Business Value:
Products with high inventory investment tie up more capital and require
careful monitoring. This analysis helps inventory managers identify
which products contribute the most to total inventory value and optimize
stock levels.

Concepts Used:
- INNER JOIN
- GROUP BY
- Aggregate Functions
- ORDER BY
- LIMIT
=====================================================================*/


select p.product_id,
	   p.product_name,
	   p.product_category,
       sum(i.stock_on_hand*p.product_cost)as inventory_value
from inventory as i
inner join products as p
	on p.product_id=i.product_id
group by p.product_id,
		 p.product_name,
         p.product_category
order by inventory_value desc
limit 10;



/*=====================================================================
Business Question 04

Objective:
Classify products into High, Medium, and Low inventory investment
categories based on their total inventory value.

Business Value:
Helps inventory managers prioritize products that tie up the most
capital and identify low-investment products for stocking strategies.

Concepts Used:
- CASE
- INNER JOIN
- GROUP BY
- Aggregate Functions
- ORDER BY
=====================================================================*/

select  p.product_id,
		p.product_name,
        p.product_category,
	   sum(i.stock_on_hand*p.product_cost) as inventory_value,
	   case 
			when sum(i.stock_on_hand*p.product_cost)>=15000 then 'High'
            when sum(i.stock_on_hand*p.product_cost)>=5000 then 'Medium'
            else 'Low'
		end as inventory_category
from inventory as i
inner join products as p
	on p.product_id=i.product_id
group by p.product_id,
		 p.product_name,
		 p.product_category
order by inventory_value desc;



/*=====================================================================
Business Question 05

Objective:
Find the top 10 products by total units in stock across all stores.

Business Value:
Identifies the products with the highest physical inventory levels,
helping warehouse managers understand which products occupy the most
storage space and require inventory monitoring.

Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
- ORDER BY
- LIMIT
=====================================================================*/

select p.product_id,
	   p.product_name,
	   p.product_category,
       sum(i.stock_on_hand) as total_units_in_stock
from inventory as i
inner join products as p
    on i.product_id = p.product_id
group by p.product_id,
         p.product_name,
		 p.product_category
order by total_units_in_stock desc,
         p.product_name asc
limit 10;



/*=====================================================================
Business Question 06

Objective:
Identify the top 10 stores with the highest total units in stock.

Business Value:
Helps warehouse managers identify stores holding the largest physical
inventory.

Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
- ORDER BY
- LIMIT
=====================================================================*/

select s.store_id,
    s.store_name,
    s.store_city,
    sum(i.stock_on_hand) as total_units_in_stock
from inventory as i
inner join stores as s
    on i.store_id = s.store_id
group by s.store_id,
    s.store_name,
    s.store_city
order by total_units_in_stock desc,
    s.store_name asc
limit 10;



/*=====================================================================
Business Question 07

Objective:
Calculate the average inventory value for each product category.

Business Value:
Helps management understand which categories require higher inventory
investment.

Concepts Used:
- INNER JOIN
- GROUP BY
- AVG()
=====================================================================*/

select p.product_category,
    avg(i.stock_on_hand * p.product_cost) as avg_inventory_value
from inventory as i
inner join products as p
    on i.product_id = p.product_id
group by p.product_category
order by avg_inventory_value desc;
    
    
    
/*=====================================================================
Business Question 08

Objective:
Calculate total inventory investment for each product category.

Business Value:
Shows which product categories tie up the highest capital.

Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
=====================================================================*/

select p.product_category,
    sum(i.stock_on_hand * p.product_cost) as total_inventory_value
from inventory as i
inner join products as p
    on i.product_id = p.product_id
group by p.product_category
order by total_inventory_value desc;



/*=====================================================================
Business Question 09

Objective:
Identify stores with the largest variety of products.

Business Value:
Measures assortment diversity across stores.

Concepts Used:
- INNER JOIN
- COUNT(DISTINCT)
- GROUP BY
=====================================================================*/

select s.store_id,
    s.store_name,
    count(distinct i.product_id) as unique_products
from stores as s
inner join inventory as i
    on s.store_id = i.store_id
group by s.store_id,
    s.store_name
order by unique_products desc,
    s.store_name asc;
    
    

/*=====================================================================
Business Question 10

Objective:
Generate an inventory summary for every store.

Business Value:
Provides management with a one-page inventory overview for each store.

Concepts Used:
- INNER JOIN
- GROUP BY
- SUM()
- AVG()
- COUNT()
=====================================================================*/

select s.store_id,
    s.store_name,
    count(distinct i.product_id) as total_products,
    sum(i.stock_on_hand) as total_units,
    sum(i.stock_on_hand * p.product_cost) as inventory_value,
    avg(i.stock_on_hand) as avg_units_per_product
from stores as s
inner join inventory as i
    on s.store_id = i.store_id
inner join products as p
    on i.product_id = p.product_id
group by  s.store_id,  
    s.store_name
order by inventory_value desc;