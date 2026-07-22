create table products(
 product_id int primary key ,
 product_name varchar(50) not  null,
 product_category varchar(50) not null,
 product_cost decimal(10,2) not null,
 product_price decimal(10,2) not null,
 check(product_price>=0),
 check(product_cost>=0)
 );
 
 
 create table stores(
  store_id int primary key,
  store_name varchar(50) not null,
  store_city varchar(50) not null,
  store_location varchar(50) not null,
  store_open_date date not null
  );
  
  
  create table sales(
   sale_id int primary key,
   sale_date date not null,
   store_id int not null ,
   product_id int not null,
   units int not null,
   check(units>0),
   
   foreign key(store_id)
   references stores(store_id)
   on delete restrict,
   
   foreign key(product_id)
   references products(product_id)
   on delete restrict
   );
   
   create table inventory(
   primary key(store_id,product_id),
   store_id int not null,
   product_id int not null,
   stock_on_hand int not null,
   check(stock_on_hand>=0),
   foreign key(store_id)
   references stores(store_id)
   on delete restrict,
   foreign key(product_id)
   references products(product_id)
   on delete restrict
   );
   