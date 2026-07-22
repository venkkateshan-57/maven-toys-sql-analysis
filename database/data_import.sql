LOAD DATA LOCAL INFILE 'dataset/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id,
 product_name,
 product_category,
 product_cost,
 product_price);
 

LOAD DATA LOCAL INFILE 'dataset/stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(store_id,
 store_name,
 store_city,
 store_location,
 store_open_date);
 
 

LOAD DATA LOCAL INFILE 'dataset/inventory.csv'
INTO TABLE inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(store_id,
 product_id,
 stock_on_hand);
 


LOAD DATA LOCAL INFILE 'dataset/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    sale_id,
    sale_date,
    store_id,
    product_id,
    units
);
