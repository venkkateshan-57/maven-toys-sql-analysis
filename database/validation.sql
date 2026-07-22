
SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_stores
FROM stores;

SELECT COUNT(*) AS total_inventory
FROM inventory;

SELECT COUNT(*) AS total_sales
FROM sales;

select product_id,
count(*)
from products
group by product_id
having count(*)>1;


select *
from products
where product_name is null;