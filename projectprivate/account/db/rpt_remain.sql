DROP PROCEDURE IF EXISTS rptremain;

DELIMITER //
CREATE PROCEDURE rptremain(startdate varchar(20), enddate varchar(20))
BEGIN

create TEMPORARY table tmpsalesumary
select itod_id,sum(total_litre) as sale_litre,sum(total_price) as sale_price
from tbl_sale_list a
left join tbl_purchase_order b on a.po_id = b.po_id
where po_date between startdate and  enddate
group by itod_id ;


create TEMPORARY table tmpordersumary

select itod_id,item_id,total_litre as order_litre,total_price as order_price,sector_type,pod_code,po_date
from tbl_item_order a
left join tbl_purchase_order b on a.po_id =b.po_id
where po_date between startdate and enddate ;


create TEMPORARY table tmpsumary

select  po_date,pod_code, (order_litre-sale_litre) as total_litre,(order_price-sale_price) as total_price,sector_type,vehicle_type,
(case when item_grade = '0' then 'Normal' else item_grade end  ) as item_grade
from tmpordersumary a
left join tmpsalesumary b on a.itod_id =b.itod_id
left join tbl_item_list c on a.item_id = c.item_id;

create TEMPORARY table tmppo 
select po_date,pod_code,sum(total_litre) as total_litre,sum(total_price) as total_price from tmpsumary group by pod_code;

create TEMPORARY table tmpb2b
select  pod_code,sum(total_litre) as b2b_litre  from tmpsumary where sector_type = 'B2B' group by pod_code,sector_type;

create TEMPORARY table tmpb2c
select  pod_code,sum(total_litre) as b2c_litre  from tmpsumary where sector_type = 'B2C' group by pod_code,sector_type;

create TEMPORARY table tmpbike
select  pod_code,sum(total_litre) as bike_litre  from tmpsumary where vehicle_type = 'bike' group by pod_code,vehicle_type;

create TEMPORARY table tmpcar
select  pod_code,sum(total_litre) as car_litre  from tmpsumary where vehicle_type = 'car' group by pod_code,vehicle_type;

create TEMPORARY table tmppremium
select  pod_code,sum(total_litre) as premium_litre  from tmpsumary where item_grade = 'Premium' group by pod_code,item_grade;

select po_date,a.pod_code as pod_code,total_litre,
	
(case when b2b_litre is null then 0 else b2b_litre end) as b2b_litre,
(case when b2c_litre is null then 0 else b2c_litre end) as b2c_litre,
(case when bike_litre is null then 0 else bike_litre end) as bike_litre,
(case when car_litre is null then 0 else car_litre end) as car_litre,
(case when premium_litre is null then 0 else premium_litre end) as premium_litre, 
total_price

from tmppo a
left join tmpb2b b on a.pod_code =b.pod_code
left join tmpb2c c on a.pod_code = c.pod_code
left join tmpbike d on a.pod_code = d.pod_code
left join tmpcar e on a.pod_code =e.pod_code
left join tmppremium f on a.pod_code = f.pod_code
order by a.pod_code asc;



END //
DELIMITER ;