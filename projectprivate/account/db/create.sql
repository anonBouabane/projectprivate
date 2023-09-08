create table tbl_purchase_order
(po_id int not null PRIMARY KEY AUTO_INCREMENT, 
 po_date date, 
 add_by int,
 register_date date
);


create table tbl_item_order (
itod_id int not null PRIMARY KEY AUTO_INCREMENT,
po_id int,
item_id int,   
quantity int,
item_price float,
total_price float,
sector_type varchar(30),
update_by int,
last_date date
);

create table tbl_unit_type (
ui_id int not null PRIMARY KEY AUTO_INCREMENT,
unit_name varchar(30)
);

insert into tbl_unit_type values ('1','B2B');
insert into tbl_unit_type values ('2','B2C');
insert into tbl_unit_type values ('3','SWH'); 


create table tbl_grade (
grade_id int not null PRIMARY KEY AUTO_INCREMENT,
grade_name varchar(30)
);
insert into tbl_grade values ('1','Normal');
insert into tbl_grade values ('2','Premium');

create table tbl_item_list
(
item_id int not null PRIMARY KEY AUTO_INCREMENT, 
item_name varchar(150), 
add_by int,
date_register date
);

create table tbl_sale_list 
(
slid int not null PRIMARY KEY AUTO_INCREMENT,
po_id int,
itod_id int,
item_id int,
item_used int,
item_price float,
total_price float,
litre float,
total_litre float,
add_by int,
date_registed date
);


create view sumary_sale_item as (
select po_id,itod_id,item_id,sum(item_used) as item_used from tbl_sale_list
group by po_id,itod_id,item_id
);


create table tbl_income (
ic_id int not null PRIMARY KEY AUTO_INCREMENT,
income int,
sale_unit float, 
date_register date
);


create or replace  view dash_view as (
SELECT    item_name,total_price,po_date,'ລາຍຈ່າຍ' as price_type
FROM tbl_item_order a
left join tbl_item_list b on a.item_id = b.item_id
left join tbl_purchase_order c on a.po_id = c.po_id  
union ALL
select   income_type  ,  income, date_register ,'ລາຍຮັບ' as price_type
from tbl_income

);