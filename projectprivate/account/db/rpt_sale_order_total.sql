DROP PROCEDURE IF EXISTS rptsalefooter;

DELIMITER //
CREATE PROCEDURE rptsalefooter(startdate varchar(20), enddate varchar(20))
BEGIN

 
create TEMPORARY table tmpsumary 
SELECT po_date,pod_code, b.total_litre as total_litre,b.total_price as total_price,sector_type,vehicle_type,
(case when item_grade = '0' then 'Normal' else item_grade end  ) as item_grade
FROM  tbl_purchase_order a
left join tbl_sale_list b on a.po_id = b.po_id
left join tbl_item_order c on b.itod_id =c.itod_id
left join tbl_item_list d on b.item_id = d.item_id where po_date between startdate and enddate;

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


create TEMPORARY table tmprptpo
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
left join tmppremium f on a.pod_code = f.pod_code;

select count(pod_code) as pod_code,
sum(total_litre) as total_litre,
sum(b2b_litre) as b2b_litre,
sum(b2c_litre) as b2c_litre,
sum(bike_litre) as bike_litre,
sum(car_litre) as car_litre,
sum(premium_litre) as premium_litre,

sum(total_price) as total_price

from tmprptpo;






END //
DELIMITER ;