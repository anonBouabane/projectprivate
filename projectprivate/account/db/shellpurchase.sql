-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 13, 2022 at 06:36 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shellpurchase`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomer` (IN `pocode` VARCHAR(30))  BEGIN
   SELECT pod_code,po_date,a.po_id as po_id,total_price,total_litre,sector_type,(case when item_grade = '0' then 'Normal' else item_grade end  ) as item_grade,vehicle_type
FROM tbl_item_order a
left join tbl_item_list b on a.item_id = b.item_id
left join tbl_purchase_order c on a.po_id = c.po_id
   where pod_code = pocode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptpofooter` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN

 
create TEMPORARY table tmpsumary 
   SELECT pod_code,po_date,a.po_id as po_id,total_price,total_litre,sector_type,(case when item_grade = '0' then 'Normal' else item_grade end  ) as item_grade,vehicle_type
FROM tbl_item_order a
left join tbl_item_list b on a.item_id = b.item_id
left join tbl_purchase_order c on a.po_id = c.po_id where po_date between startdate and enddate;

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






END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptpurchaseorder` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN

 
create TEMPORARY table tmpsumary 
   SELECT pod_code,po_date,a.po_id as po_id,total_price,total_litre,sector_type,(case when item_grade = '0' then 'Normal' else item_grade end  ) as item_grade,vehicle_type
FROM tbl_item_order a
left join tbl_item_list b on a.item_id = b.item_id
left join tbl_purchase_order c on a.po_id = c.po_id where po_date between startdate and enddate;

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



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptremain` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN

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



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptremainfooter` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN

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






END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsalefooter` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN

 
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






END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rptsaleorder` (`startdate` VARCHAR(20), `enddate` VARCHAR(20))  BEGIN
 
 
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



END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `sumary_sale_item`
-- (See below for the actual view)
--
CREATE TABLE `sumary_sale_item` (
`po_id` int(11)
,`itod_id` int(11)
,`item_id` int(11)
,`item_used` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_item_list`
--

CREATE TABLE `tbl_item_list` (
  `item_id` int(11) NOT NULL,
  `material_code` varchar(30) DEFAULT NULL,
  `item_name` varchar(150) DEFAULT NULL,
  `pack_size` float DEFAULT NULL,
  `price_litre` float DEFAULT NULL,
  `unit_price` float DEFAULT NULL,
  `packing` varchar(30) DEFAULT NULL,
  `unit_type` varchar(30) DEFAULT NULL,
  `item_grade` varchar(30) DEFAULT NULL,
  `vehicle_type` varchar(30) DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL,
  `date_register` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_item_list`
--

INSERT INTO `tbl_item_list` (`item_id`, `material_code`, `item_name`, `pack_size`, `price_litre`, `unit_price`, `packing`, `unit_type`, `item_grade`, `vehicle_type`, `add_by`, `date_register`) VALUES
(1, '550055834', 'Hydraulic S1 M 68_1*200L', 200, 1.33, 266, '1x200L', 'Drum', '0', NULL, 1, '2022-05-05'),
(2, '550055833', 'Hydraulic S1 M 46_1*200L', 200, 1.33, 266, '1x200L', 'Drum', '0', NULL, 1, '2022-05-05'),
(3, '550055661', 'Rimula R3+ 40_1*18L', 18, 1.71, 30.78, '1x18L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(4, '550055656', 'Rimula R4 X 15W-40_1*18L', 18, 1.93, 34.74, '1x18L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(5, '550053337', 'Helix HX7 Diesel 10W-30_2*6L', 12, 2.37, 28.44, '2x6L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(6, '550053335', 'Helix HX7 Diesel 10W-30_12*1L', 12, 3.16, 37.92, '12x1L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(7, '550052272', 'Gadus S2 OG 80_1*190Kg', 190, 11.25, 2137.5, '1x190Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(8, '550052240', 'Advance 4T AX7 10W-40_12*1L', 12, 3.13, 37.56, '12x1L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(9, '550052208', 'Advance 4T Ultra 10W-40_12*1L', 12, 5.88, 70.56, '12x1L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(10, '550052206', 'Advance 4T AX5 15W-40_12*0.8L', 9.6, 2.84, 27.26, '12x0.8L', 'Carton', '0', NULL, 1, '2022-05-05'),
(11, '550052205', 'Advance 4T AX5 15W-40_12*1L', 12, 2.85, 34.2, '12x1L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(12, '550051844', 'Helix HX5 15W-40_4*4L', 16, 2.66, 42.56, '4x4L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(13, '550051842', 'Helix HX8 5W-40_4*4L', 16, 0, 0, '4x4L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(14, '550051840', 'Helix HX7 5W-40_4*4L', 16, 2.86, 45.76, '4x4L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(15, '550051463', 'Helix Ultra 0W-40_4*4L', 16, 8.76, 140.16, '4x4L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(16, '550051459', 'Helix HX5 15W-40_12*1L', 12, 3.08, 36.96, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(17, '550051454', 'Helix HX7_5W-40_12*1L', 12, 3.96, 47.52, '12x1L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(18, '550051213', 'Advance AX5 Sct. 10W-30_12*0.8L', 9.6, 2.87, 27.55, '12x0.8L', 'Carton', '0', NULL, 1, '2022-05-05'),
(19, '550051212', 'Advance 4T AX7 10W-30_12*0.8L', 9.6, 3.13, 30.05, '12x0.8L', 'Carton', 'Premium', NULL, 1, '2022-05-05'),
(20, '550050438', 'BMW TPT LL04 5W-30_12*1L', 12, 7.08, 84.96, '12x1L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(21, '550050437', 'BMW GR LL04 5W-30_1*209L', 209, 5.01, 1047.09, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(22, '550050434', 'BMW TP TLL01 5W-30_12*1L', 12, 5.6, 67.2, '12x1L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(23, '550063974', 'BMW GR LL01 5W-30_1*209L', 209, 4.96, 1036.64, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(24, '550050115', 'Helix HX5 Diesel 15W-40_2*6L', 12, 1.89, 22.68, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(25, '550050113', 'Helix Ultra Diesel 5W-40_2*6L', 12, 6.86, 82.32, '2x6L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(26, '550049693', 'Gear Oil S1 G 220_1*209L', 209, 0, 0, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(27, '550049638', 'Gadus S2 V150C 3_12*0.5kg', 6, 3.7, 22.2, '12*0.5kg', 'Carton', 'Premium', NULL, 1, '2022-05-05'),
(28, '550049627', 'Gadus S2 V150C 3_6*2Kg', 12, 3.43, 41.16, '6*2Kg', 'Carton', 'Premium', NULL, 1, '2022-05-05'),
(29, '550048514', 'Gadus S2 V150C 3_1*18Kg', 18, 3.15, 56.7, '1x18L', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(30, '550048513', 'Gadus S2 V150C 3_1*180Kg', 180, 3.07, 552.6, '1x18L0', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(31, '550047461', 'Omala S4 GXV 320_1*209L', 209, 7.65, 1598.85, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(32, '550045693', 'Spirax S2 G 90_4*4L', 16, 0, 0, '4x4L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(33, '550045691', 'Spirax S2 A 90_4*4L', 16, 2.15, 34.4, '4x4L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(34, '550045690', 'Spirax S2 A 140_4*4L', 16, 2.07, 33.12, '4x4L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(35, '550045688', 'Spirax S2 ATF D2_12*1L', 12, 3.13, 37.56, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(36, '550045687', 'Spirax S3 ATF MD3_12*1L', 12, 4.94, 59.28, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(37, '550045672', 'Helix Ultra Diesel 5W-40_12*1L', 12, 8.64, 103.68, '12x1L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(38, '550045671', 'Helix Ultra Diesel 5W-40_2*6L', 12, 6.86, 82.32, '2x6L', 'Carton', 'Premium', 'CAR', 1, '2022-05-05'),
(39, '550045668', 'Advance 4T AX3 40SF_12*0.8L', 9.6, 1.93, 18.53, '12x0.8L', 'Carton', '0', NULL, 1, '2022-05-05'),
(40, '550045662', 'Helix HX3 Diesel 20W-50_2*6L', 12, 0, 0, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(41, '550045648', 'Helix HX5 Diesel 15W-40_12*1L', 12, 2.61, 31.32, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(42, '550045644', 'Helix HX3 40 SLCF_12*1L', 12, 1.65, 19.8, '12x1L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(43, '550045641', 'Advance 4T AX3 40SF_12*1L', 12, 1.92, 23.04, '12x1L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(44, '550045122', 'Tellus S2 MX 46_1*20L', 20, 2.13, 42.6, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(45, '550045113', 'Tellus S2 MX 32_1*20L', 20, 2.4, 48, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(46, '550045111', 'Tellus S2 MX 22_1*209L', 209, 3.09, 645.81, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(47, '550045087', 'Tellus S2 VX 68_1*209L', 209, 3.34, 698.06, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(48, '550045086', 'Tellus S2 MX 100_1*209L', 209, 1.88, 392.92, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(49, '550045085', 'Tellus S2 VX 46_1*209L', 209, 2.9, 606.1, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(50, '550045084', 'Tellus S2 VX 32_1*209L', 209, 3.54, 739.86, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(51, '550045082', 'Tellus S2 VX 15_1*209L', 209, 3.52, 735.68, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(52, '550045081', 'Tellus S2 VX 100_1*209L', 209, 2.94, 614.46, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(53, '550045080', 'Tellus S2 MX 68_1*209L', 209, 1.73, 361.57, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(54, '550045079', 'Tellus S2 MX 46_1*209L', 209, 1.83, 382.47, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(55, '550045078', 'Tellus S2 MX 32_1*209L', 209, 2.1, 438.9, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(56, '550045051', 'Advance 4T AX3 20W-50_12*1L', 12, 2.38, 28.56, '12x1L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(57, '550044595', 'Rimula R2 Extra 20W-50_1*209L', 209, 2.27, 474.43, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(58, '550044573', 'Rimula R3 10W_1*209L', 209, 0, 0, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(59, '550044572', 'Rimula R3+ 40_1*209L', 209, 1.86, 388.74, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(60, '550044565', 'Rimula R3+ 40_12*1L', 12, 1.84, 22.08, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(61, '550044564', 'Rimula R3+ 40_2*6L', 12, 1.75, 21, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(62, '550044531', 'Rimula R1 50_2*6L', 12, 1.7, 20.4, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(63, '550044489', 'Rimula R4 X 15W-40_2*6L', 12, 1.91, 22.92, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(64, '550044488', 'Rimula R4 X 15W-40_12*1L', 12, 2.53, 30.36, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(65, '550044360', 'Rimula R4 X 15W-40_1*209L', 209, 1.87, 390.83, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(66, '550044096', 'Gadus S2 OGH 0/00_1*180Kg', 180, 12.08, 2174.4, '1x18L0', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(67, '550041510', 'Omala S2 GX 68_1*209L', 209, 2.35, 491.15, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(68, '550041501', 'Omala S2 GX 460_1*209L', 209, 2.2, 459.8, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(69, '550041500', 'Omala S2 GX 320_1*209L', 209, 2.21, 461.89, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(70, '550041493', 'Omala S2 GX 320_1*20L', 20, 2.51, 50.2, '1x20L', 'Pail', '0', NULL, 1, '2022-05-05'),
(71, '550041492', 'Omala S2 GX 220_1*209L', 209, 1.91, 399.19, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(72, '550041491', 'Omala S2 GX 150_1*20L', 20, 2.61, 52.2, '1x20L', 'Pail', '0', NULL, 1, '2022-05-05'),
(73, '550041490', 'Omala S2 GX 150_1*209L', 209, 2.31, 482.79, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(74, '550041471', 'Omala S2 GX 220_1*20L', 20, 2.21, 44.2, '1x20L', 'Pail', '0', NULL, 1, '2022-05-05'),
(75, '550041470', 'Omala S2 GX 100_1*209L', 209, 2.31, 482.79, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(76, '550041340', 'Omala S2 GX 680_1*209L', 209, 2.35, 491.15, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(77, '550040743', 'Brake & Clutch DOT3_24*0.5L', 12, 4, 48, '24x0.5L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(78, '550040742', 'Brake & Clutch DOT3_12*1L', 12, 3.9, 46.8, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(79, '550040071', 'Diala S4 ZX-I_1*209L', 209, 2.46, 514.14, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(80, '550063080', 'Advance Scooter Gear Oil_24*0.12L', 2.88, 5.12, 14.75, '24x0.12L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(81, '550032957', 'Turbo T 32_1*209L', 209, 2.67, 558.03, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(82, '550032917', 'Turbo T 46_1*209L', 209, 2.15, 449.35, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(83, '550032916', 'Turbo T 68_1*209L', 209, 3.21, 670.89, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(84, '550030284', 'Brake & Clutch DOT4_24*0.5L', 12, 4.7, 56.4, '24x0.5L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(85, '550027931', 'Spirax S5 ATE 75W-90_1*20L', 20, 8.51, 170.2, '1x20L', 'Pail', 'Premium', 'CAR', 1, '2022-05-05'),
(86, '550027185', 'Omala S4 WE 220_1*209L', 209, 10.59, 2213.31, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(87, '550027056', 'Gadus S2 V220D 2_1*180kg', 180, 4.64, 835.2, '1x18Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(88, '550027051', 'Gadus S2 V100 2_1*180kg', 180, 3.79, 682.2, '1x18Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(89, '550027049', 'Gadus S2 V100 2_1*18kg', 18, 3.86, 69.48, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(90, '550027048', 'Gadus S2 V100 3_1*180kg', 180, 3.88, 698.4, '1x18Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(91, '550027047', 'Gadus S2 V220 3_1*18kg', 18, 3.58, 64.44, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(92, '550027046', 'Gadus S2 V220 3_1*180kg', 180, 2.85, 513, '1x180Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(93, '550027045', 'Gadus S2 V220 0_1*180kg', 180, 3.46, 622.8, '1x180Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(94, '550027043', 'Gadus S3 V220C 2_1*18kg', 18, 5.59, 100.62, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(95, '550027035', 'Gadus S2 V220 0_1*18kg', 18, 3.64, 65.52, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(96, '550027033', 'Gadus S2 V220 1_1*18kg', 18, 3.8, 68.4, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(97, '550027032', 'Gadus S2 V100 3_1*18kg', 18, 3.89, 70.02, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(98, '550027031', 'Gadus S2 V220 2_1*18kg', 18, 3.52, 63.36, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(99, '550027030', 'Gadus S2 V220 1_1*180kg', 180, 3.21, 577.8, '1x180Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(100, '550027004', 'Gadus S3 V460D 2_1*18kg', 18, 8.44, 151.92, '1x18Kg', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(101, '550025745', 'Advance SX2 Molla_24*0.5L', 12, 2.25, 27, '24x0.5L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(102, '550025737', 'Refrig S2 FR-A 46_1*209L', 209, 0, 0, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(103, '550025703', 'Refrig S4 FR-V 68_1*209L', 209, 8.87, 1853.83, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(104, '550025673', 'Gadus S3 V220C 2_1*180kg', 180, 5.58, 1004.4, '1x18Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(105, '550025669', 'Gadus S2 V220 2_1*180kg', 180, 2.75, 495, '1x180Kg', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(106, '550025572', 'Flushing Oil 32_4*4L_A05C', 16, 2.49, 39.84, '4x4L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(107, '550025055', 'Spirax S4 TXM_1*209L', 209, 3.06, 639.54, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(108, '550025044', 'Spirax S2 A 85W-140_1*209L', 209, 2.07, 432.63, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(109, '550025026', 'Tellus S3 M 68_1*209L', 209, 4.47, 934.23, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(110, '550024992', 'Corena S2 P 100_1*209L', 209, 4.71, 984.39, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(111, '550024991', 'Corena S3 R 46_1*209L', 209, 2.97, 620.73, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(112, '550024990', 'Corena S2 P 150_1*209L', 209, 4.65, 971.85, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(113, '550024989', 'Corena S3 R 32_1*209L', 209, 4.01, 838.09, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(114, '550024985', 'Spirax S3 AX 80W-90_1*20L', 20, 4.1, 82, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(115, '550024984', 'Heat Transfer S2_1*209L', 209, 2.54, 530.86, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(116, '550024974', 'Spirax S3 TLV_1*209L', 209, 3.38, 706.42, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(117, '550024973', 'Air Tool Oil S2 A320_1*209L', 209, 2.62, 547.58, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(118, '550024968', 'Air Tool Oil S2 A100_1*209L', 209, 2.89, 604.01, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(119, '550024966', 'Spirax S2 ATF D2_1*209L', 209, 3.55, 741.95, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(120, '550024964', 'Corena S3 R 68_1*209L', 209, 2.99, 624.91, '1x209L', 'Drum', 'Premium', NULL, 1, '2022-05-05'),
(121, '550024963', 'Corena S3 R 68_1*20L', 20, 2.93, 58.6, '1x20L', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(122, '550024959', 'Refrig S2 FR-A 68_1*209L', 209, 3.41, 712.69, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(123, '550024938', 'Spirax S3 ATF MD3_1*209L', 209, 3.73, 779.57, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(124, '550024937', 'Spirax S3 ATF MD3_1*20L', 20, 4.34, 86.8, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(125, '550024933', 'Spirax S3 AX 80W-90_1*209L', 209, 3.32, 693.88, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(126, '550024931', 'Spirax S2 A 140_1*209L', 209, 1.89, 395.01, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(127, '550024930', 'Spirax S2 A 140_1*20L', 20, 2.58, 51.6, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(128, '550024929', 'Spirax S2 A 90_1*209L', 209, 1.95, 407.55, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(129, '550024917', 'Spirax S4 TXM_1*20L', 20, 2.9, 58, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(130, '550024909', 'Corena S2 P 100_1*20L', 20, 4.87, 97.4, '1x20L', 'Pail', '0', NULL, 1, '2022-05-05'),
(131, '550024908', 'Corena S3 R 46_1*20L', 20, 3.13, 62.6, '1x20L', 'Pail', 'Premium', NULL, 1, '2022-05-05'),
(132, '550021440', 'Advance VSX 2 FC/EGD_12*1L', 12, 2.75, 33, '12x1L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(133, '550021439', 'Advance VSX 2 FC/EGD_24*0.5L', 12, 2.8, 33.6, '24x0.5L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(134, '550045112', 'Tellus S2 MX 68_1*20', 20, 1.85, 37, '1x20L', 'Pail', '0', 'CAR', 1, '2022-05-05'),
(135, '550052209', 'Advance 4T Ultra 15W-50_12*1L', 12, 3.15, 37.8, '12x1L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(136, '550045681', 'Advance 4T AX7 Scooter 10W-40_12*1L', 12, 3.13, 37.56, '12x1L', 'Carton', 'Premium', 'BIKE', 1, '2022-05-05'),
(137, '550063165', 'Diala S4 ZX-I 1*200L', 200, 2.09, 418, '1x200L', 'Drum', '0', NULL, 1, '2022-05-05'),
(138, '550051993', 'Rimula R4 X 20W-50_1*209L', 209, 2.06, 430.54, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(139, '550025043', 'Spirax S2 A 80W-90_1*209L', 209, 2.06, 430.54, '1x209L', 'Drum', '0', NULL, 1, '2022-05-05'),
(140, '550050494', 'Helix Ultra Diesel 0W-40_12*1L', 12, 6.55, 78.6, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(141, '550050495', 'Helix Ultra Diesel 0W-40_2*6L', 12, 6.05, 72.6, '2x6L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(142, '550036748', 'Advance Scooter Gear Oil_24*0.12L', 2.88, 5.12, 14.75, '24x0.12L', 'Carton', '0', 'BIKE', 1, '2022-05-05'),
(143, '550064194', 'Brake & Clutch DOT3_24*0.5L', 12, 4, 48, '24x0.5L', 'Carton', '0', 'CAR', 1, '2022-05-05'),
(144, '550064193', 'Brake & Clutch DOT3_12*1L', 12, 3.9, 46.8, '12x1L', 'Carton', '0', 'CAR', 1, '2022-05-05');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_item_order`
--

CREATE TABLE `tbl_item_order` (
  `itod_id` int(11) NOT NULL,
  `po_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `item_price` float DEFAULT NULL,
  `total_price` float DEFAULT NULL,
  `sector_type` varchar(10) DEFAULT NULL,
  `litre` float DEFAULT NULL,
  `total_litre` float DEFAULT NULL,
  `update_by` int(11) DEFAULT NULL,
  `last_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_item_order`
--

INSERT INTO `tbl_item_order` (`itod_id`, `po_id`, `item_id`, `quantity`, `item_price`, `total_price`, `sector_type`, `litre`, `total_litre`, `update_by`, `last_date`) VALUES
(25, 3, 101, 600, 27, 16200, 'B2C', 12, 7200, 2, '2022-05-10'),
(26, 3, 35, 100, 37.56, 3756, 'B2C', 12, 1200, 2, '2022-05-10'),
(27, 3, 34, 200, 33.12, 6624, 'B2C', 16, 3200, 2, '2022-05-10'),
(28, 3, 24, 500, 22.68, 11340, 'B2C', 12, 6000, 2, '2022-05-10'),
(29, 3, 12, 300, 42.56, 12768, 'B2C', 16, 4800, 2, '2022-05-10'),
(30, 3, 14, 100, 45.76, 4576, 'B2C', 16, 1600, 2, '2022-05-10'),
(31, 3, 61, 500, 21, 10500, 'B2C', 12, 6000, 2, '2022-05-10'),
(32, 4, 24, 1250, 22.68, 28350, 'SWH', 12, 15000, 2, '2022-05-10'),
(33, 5, 63, 200, 22.92, 4584, 'SWH', 12, 2400, 2, '2022-05-10'),
(34, 5, 62, 250, 20.4, 5100, 'SWH', 12, 3000, 2, '2022-05-10'),
(35, 5, 61, 250, 21, 5250, 'SWH', 12, 3000, 2, '2022-05-10'),
(36, 5, 24, 500, 22.68, 11340, 'SWH', 12, 6000, 2, '2022-05-10'),
(37, 5, 35, 50, 37.56, 1878, 'SWH', 12, 600, 2, '2022-05-10'),
(38, 6, 65, 40, 390.83, 15633.2, 'B2B', 209, 8360, 2, '2022-05-10'),
(39, 6, 53, 17, 361.57, 6146.69, 'B2B', 209, 3553, 2, '2022-05-10'),
(40, 6, 126, 5, 395.01, 1975.05, 'B2B', 209, 1045, 2, '2022-05-10'),
(41, 6, 128, 3, 407.55, 1222.65, 'B2B', 209, 627, 2, '2022-05-10'),
(42, 6, 98, 20, 63.36, 1267.2, 'B2B', 18, 360, 2, '2022-05-10'),
(43, 6, 23, 3, 1036.64, 3109.92, 'B2B', 209, 627, 2, '2022-05-10');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_purchase_order`
--

CREATE TABLE `tbl_purchase_order` (
  `po_id` int(11) NOT NULL,
  `pod_code` varchar(30) DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL,
  `register_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_purchase_order`
--

INSERT INTO `tbl_purchase_order` (`po_id`, `pod_code`, `po_date`, `add_by`, `register_date`) VALUES
(3, 'SH-001-22', '2022-01-30', 2, '2022-05-10'),
(4, 'SH-002-22', '2022-02-16', 2, '2022-05-10'),
(5, 'SH-003-22', '2022-02-21', 2, '2022-05-10'),
(6, 'SH-004-22', '2022-02-26', 2, '2022-05-10');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_sale_list`
--

CREATE TABLE `tbl_sale_list` (
  `slid` int(11) NOT NULL,
  `po_id` int(11) DEFAULT NULL,
  `itod_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_used` int(11) DEFAULT NULL,
  `item_price` float DEFAULT NULL,
  `total_price` float DEFAULT NULL,
  `litre` float DEFAULT NULL,
  `total_litre` float DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL,
  `date_registed` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_sale_list`
--

INSERT INTO `tbl_sale_list` (`slid`, `po_id`, `itod_id`, `item_id`, `item_used`, `item_price`, `total_price`, `litre`, `total_litre`, `add_by`, `date_registed`) VALUES
(1, 1, 17, 35, 33, 37.56, 1239.48, 12, 396, 1, '2022-05-05'),
(2, 1, 18, 34, 33, 33.12, 1092.96, 16, 528, 1, '2022-05-05'),
(3, 1, 19, 61, 33, 21, 693, 12, 396, 1, '2022-05-05'),
(4, 1, 17, 35, 17, 37.56, 638.52, 12, 204, 1, '2022-05-05'),
(5, 1, 18, 34, 17, 33.12, 563.04, 16, 272, 1, '2022-05-05');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`) VALUES
(1, 'admin', '123', 'admin'),
(2, 'oypn', '123', 'oyon');

-- --------------------------------------------------------

--
-- Structure for view `sumary_sale_item`
--
DROP TABLE IF EXISTS `sumary_sale_item`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sumary_sale_item`  AS   (select `tbl_sale_list`.`po_id` AS `po_id`,`tbl_sale_list`.`itod_id` AS `itod_id`,`tbl_sale_list`.`item_id` AS `item_id`,sum(`tbl_sale_list`.`item_used`) AS `item_used` from `tbl_sale_list` group by `tbl_sale_list`.`po_id`,`tbl_sale_list`.`itod_id`,`tbl_sale_list`.`item_id`)  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_item_list`
--
ALTER TABLE `tbl_item_list`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_item_order`
--
ALTER TABLE `tbl_item_order`
  ADD PRIMARY KEY (`itod_id`);

--
-- Indexes for table `tbl_purchase_order`
--
ALTER TABLE `tbl_purchase_order`
  ADD PRIMARY KEY (`po_id`);

--
-- Indexes for table `tbl_sale_list`
--
ALTER TABLE `tbl_sale_list`
  ADD PRIMARY KEY (`slid`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_item_list`
--
ALTER TABLE `tbl_item_list`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=146;

--
-- AUTO_INCREMENT for table `tbl_item_order`
--
ALTER TABLE `tbl_item_order`
  MODIFY `itod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `tbl_purchase_order`
--
ALTER TABLE `tbl_purchase_order`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_sale_list`
--
ALTER TABLE `tbl_sale_list`
  MODIFY `slid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
