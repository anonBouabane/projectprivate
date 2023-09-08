-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 172.17.0.1:3306
-- Generation Time: Jun 27, 2023 at 05:57 AM
-- Server version: 5.7.35-log
-- PHP Version: 7.4.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `account`
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
-- Stand-in structure for view `dash_view`
-- (See below for the actual view)
--
CREATE TABLE `dash_view` (
`item_name` varchar(150)
,`total_price` float
,`po_date` date
,`price_type` varchar(7)
);

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
-- Table structure for table `tbl_income`
--

CREATE TABLE `tbl_income` (
  `ic_id` int(11) NOT NULL,
  `income` int(11) DEFAULT NULL,
  `sale_unit` float DEFAULT NULL,
  `date_register` date DEFAULT NULL,
  `income_type` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_income`
--

INSERT INTO `tbl_income` (`ic_id`, `income`, `sale_unit`, `date_register`, `income_type`) VALUES
(1, 14000000, NULL, '2023-06-02', 'ເງິນເດືອນ'),
(2, 4000000, NULL, '2023-06-02', 'ເງິນທີ່ປຶກສາ');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_item_list`
--

CREATE TABLE `tbl_item_list` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(150) DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL,
  `date_register` date DEFAULT NULL,
  `quota_type` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_item_list`
--

INSERT INTO `tbl_item_list` (`item_id`, `item_name`, `add_by`, `date_register`, `quota_type`) VALUES
(1, 'ຄ່ານ້ຳ', 1, '2023-01-30', 1),
(2, 'ຄ່າໄຟຟ້າ', 1, '2023-01-30', 1),
(3, 'ຄ່ານ້ຳມັນລົດ', 1, '2023-01-30', 4),
(4, 'ຄ່າເນັດມືຖື', 1, '2023-01-30', 1),
(5, 'ຄ່າເນັດບ້ານ', 1, '2023-01-30', 1),
(6, 'ຊື້ນ້ຳດື່ມ', 1, '2023-01-30', 6),
(7, 'ປ່ຽນນ້ຳມັນເຄື່ອງ click-i', 1, '2023-01-30', 2),
(8, 'ປ່ຽນນ້ຳມັນເຄື່ອງ xsr', 1, '2023-01-30', 3),
(10, 'ຫວຍ', 1, '2023-01-31', 1),
(11, 'ເຂົ້າປຽກ', 1, '2023-02-01', 6),
(12, 'ຄ່າຂົນສົ່ງເຄື່ອງ', 1, '2023-02-01', 9),
(13, 'ເຂົ້າໜຽວສຸກ', 1, '2023-02-01', 6),
(14, 'ແຈ່ວ', 1, '2023-02-01', 6),
(15, 'ອາຫານທີມງານ', 1, '2023-02-01', 7),
(16, 'ຢາສູບ', 1, '2023-02-01', 9),
(17, 'ອາຫານເຂົ້າເຮືອນ', 1, '2023-02-01', 5),
(19, 'ກາເຟ', 1, '2023-02-02', 6),
(22, 'ແລກເງິນໂດລ້າ', 1, '2023-02-03', 11),
(23, 'ກິນເຂົ້າ', 1, '2023-02-03', 6),
(24, 'ປິ້ງຫູໝູ', 1, '2023-02-04', 9),
(25, 'ເບຍ', 1, '2023-02-07', 9),
(26, 'ເຕີມເກມ', 1, '2023-02-07', 9),
(27, 'ອັນຖູຫ້ອງນ້ຳ', 1, '2023-02-07', 9),
(28, 'ກິນນ້ຳ', 1, '2023-02-07', 6),
(29, 'ໄປບູນ', 1, '2023-02-07', 9),
(30, 'ບັນແຊ່ວ', 1, '2023-02-07', 6),
(31, 'ຄ່າທາງ', 1, '2023-02-07', 1),
(32, 'ລ້າງແອ', 1, '2023-02-07', 1),
(43, 'ແຕ່ງລົດ', 1, '2023-02-28', 9),
(45, 'ໄປດອງ', 1, '2023-03-04', 9),
(46, 'ແລກເງິນບາດ', 1, '2023-03-04', 11),
(49, 'ຊື້ຕັ່ງ', 1, '2023-03-04', 9),
(50, 'ແກສກະປ໋ອງ', 1, '2023-03-04', 9),
(51, 'ຂະໜົມ', 1, '2023-03-04', 6),
(52, 'ອອກທິບ', 1, '2023-03-04', 9),
(53, 'ນ້ຳມັ່ນພືດ', 1, '2023-03-10', 6),
(54, 'ຊື້ເລກ', 1, '2023-03-10', 9),
(55, 'C-Tech (ເຂົ້າສານ)', 1, '2023-03-13', 7),
(56, 'ນ້ຳມັນລົດ(ອອກທິບ)', 1, '2023-03-31', 9),
(57, 'ຊື້ເຄື່ອງລາຊາດ້າ', 1, '2023-03-31', 9),
(58, 'ຊື້ເຄື່ອງເຂົ້າຫ້ອງການ', 1, '2023-04-03', 1),
(59, 'ກະແລ້ມ', 1, '2023-04-03', 6),
(63, 'C-Tech (ກິນລ້ຽງ)', 1, '2023-06-02', 7),
(64, 'ເຂົ້າສານ(ເຂົ້າຈ້າວ 1 ເປົ໋າ)', 1, '2023-06-02', 5),
(65, 'ນ້ຳດື່ມ (ອອກກຳລັງກາຍ)', 1, '2023-06-02', 8),
(66, 'ຄ່າຟິສເນສ', 1, '2023-06-02', 8),
(67, 'ນ້ຳດື່ມເຂົ້າເຮືອນ', 1, '2023-06-02', 5),
(68, 'ກ່ອງນ້ຳມັນເຄື່ອງ xsr', 1, '2023-06-03', 3),
(69, 'ສະບູ', 1, '2023-06-05', 1),
(71, 'ຊື້ເຄື່້ອງຊ່ວຍ', 1, '2023-06-12', 9),
(72, 'ຄ່າແກສ', 1, '2023-06-12', 5),
(73, 'ຟິສເນສ', 1, '2023-06-12', 8),
(74, 'ເກັບເງິນອອກທຣິບ', 1, '2023-06-12', 12),
(75, 'ຄ່າຮຽນພາສາອັງກິດ', 1, '2023-06-16', 7),
(76, 'ຄ່ານ້ຳມັນ (CTech)', 1, '2023-06-16', 7),
(77, 'ຄ່າທຳນຽມ I-Bank', 1, '2023-06-16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_item_order`
--

CREATE TABLE `tbl_item_order` (
  `itod_id` int(11) NOT NULL,
  `po_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `total_price` float DEFAULT NULL,
  `update_by` int(11) DEFAULT NULL,
  `last_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_item_order`
--

INSERT INTO `tbl_item_order` (`itod_id`, `po_id`, `item_id`, `total_price`, `update_by`, `last_date`) VALUES
(35, 1, 2, 500000, 1, '2023-06-02'),
(36, 1, 1, 25000, 1, '2023-06-02'),
(37, 1, 10, 6600000, 1, '2023-06-02'),
(38, 1, 64, 650000, 1, '2023-06-02'),
(39, 1, 63, 300000, 1, '2023-06-02'),
(40, 1, 25, 200000, 1, '2023-06-02'),
(41, 1, 16, 30000, 1, '2023-06-02'),
(55, 3, 28, 23000, 1, '2023-06-02'),
(56, 3, 16, 25000, 1, '2023-06-02'),
(57, 3, 67, 40000, 1, '2023-06-02'),
(58, 3, 23, 45000, 1, '2023-06-02'),
(70, 4, 23, 15000, 1, '2023-06-05'),
(71, 4, 28, 21000, 1, '2023-06-05'),
(72, 4, 68, 70000, 1, '2023-06-05'),
(73, 4, 56, 100000, 1, '2023-06-05'),
(74, 4, 69, 10000, 1, '2023-06-05'),
(79, 5, 23, 30000, 1, '2023-06-05'),
(80, 5, 23, 34000, 1, '2023-06-05'),
(81, 5, 28, 10000, 1, '2023-06-05'),
(82, 2, 23, 30000, 1, '2023-06-05'),
(83, 2, 3, 50000, 1, '2023-06-05'),
(84, 2, 57, 1925000, 1, '2023-06-05'),
(85, 2, 23, 65000, 1, '2023-06-05'),
(86, 2, 16, 30000, 1, '2023-06-05'),
(87, 2, 25, 50000, 1, '2023-06-05'),
(88, 2, 7, 70000, 1, '2023-06-05'),
(89, 2, 8, 80000, 1, '2023-06-05'),
(91, 6, 28, 14000, 1, '2023-06-06'),
(92, 6, 23, 34000, 1, '2023-06-06'),
(97, 7, 19, 15000, 1, '2023-06-07'),
(98, 7, 12, 257000, 1, '2023-06-07'),
(99, 7, 23, 28000, 1, '2023-06-07'),
(100, 7, 17, 336000, 1, '2023-06-07'),
(105, 9, 28, 15000, 1, '2023-06-09'),
(106, 9, 59, 9000, 1, '2023-06-09'),
(117, 10, 28, 15000, 1, '2023-06-12'),
(118, 10, 16, 120000, 1, '2023-06-12'),
(119, 10, 25, 100000, 1, '2023-06-12'),
(124, 11, 23, 100000, 1, '2023-06-12'),
(125, 11, 25, 320000, 1, '2023-06-12'),
(126, 11, 71, 350000, 1, '2023-06-12'),
(127, 11, 3, 50000, 1, '2023-06-12'),
(128, 11, 72, 125000, 1, '2023-06-12'),
(129, 8, 28, 30000, 1, '2023-06-12'),
(130, 8, 28, 15000, 1, '2023-06-12'),
(131, 8, 12, 79000, 1, '2023-06-12'),
(132, 8, 17, 271000, 1, '2023-06-12'),
(133, 12, 26, 160000, 1, '2023-06-12'),
(134, 13, 28, 15000, 1, '2023-06-13'),
(135, 13, 23, 15000, 1, '2023-06-13'),
(136, 13, 59, 9000, 1, '2023-06-13'),
(137, 13, 6, 30000, 1, '2023-06-13'),
(151, 15, 23, 18000, 1, '2023-06-16'),
(152, 15, 28, 15000, 1, '2023-06-16'),
(153, 15, 23, 35000, 1, '2023-06-16'),
(154, 15, 28, 15000, 1, '2023-06-16'),
(168, 14, 75, 2160000, 1, '2023-06-16'),
(169, 14, 76, 20000, 1, '2023-06-16'),
(170, 14, 12, 14000, 1, '2023-06-16'),
(171, 14, 59, 8000, 1, '2023-06-16'),
(172, 14, 16, 10000, 1, '2023-06-16'),
(173, 16, 28, 30000, 1, '2023-06-16'),
(174, 16, 12, 14000, 1, '2023-06-16'),
(175, 16, 3, 50000, 1, '2023-06-16'),
(176, 16, 17, 45000, 1, '2023-06-16'),
(177, 16, 59, 8000, 1, '2023-06-16'),
(178, 16, 77, 10000, 1, '2023-06-16'),
(181, 17, 23, 8000, 1, '2023-06-16'),
(182, 17, 28, 15000, 1, '2023-06-16'),
(183, 17, 5, 185000, 1, '2023-06-16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_purchase_order`
--

CREATE TABLE `tbl_purchase_order` (
  `po_id` int(11) NOT NULL,
  `po_date` date DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL,
  `register_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_purchase_order`
--

INSERT INTO `tbl_purchase_order` (`po_id`, `po_date`, `add_by`, `register_date`) VALUES
(1, '2023-06-01', 1, '2023-06-02'),
(2, '2023-06-01', 1, '2023-06-02'),
(3, '2023-06-02', 1, '2023-06-02'),
(4, '2023-06-03', 1, '2023-06-03'),
(5, '2023-06-04', 1, '2023-06-03'),
(6, '2023-06-05', 1, '2023-06-05'),
(7, '2023-06-06', 1, '2023-06-06'),
(8, '2023-06-07', 1, '2023-06-07'),
(9, '2023-06-08', 1, '2023-06-09'),
(10, '2023-06-09', 1, '2023-06-12'),
(11, '2023-06-10', 1, '2023-06-10'),
(12, '2023-06-11', 1, '2023-06-12'),
(13, '2023-06-12', 1, '2023-06-13'),
(14, '2023-06-13', 1, '2023-06-16'),
(15, '2023-06-14', 1, '2023-06-16'),
(16, '2023-06-15', 1, '2023-06-16'),
(17, '2023-06-16', 1, '2023-06-16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_quota_type`
--

CREATE TABLE `tbl_quota_type` (
  `qt_id` int(11) NOT NULL,
  `qt_name` varchar(300) DEFAULT NULL,
  `quota_price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_quota_type`
--

INSERT INTO `tbl_quota_type` (`qt_id`, `qt_name`, `quota_price`) VALUES
(1, 'ລາຍຈ່າຍຈຳເປັນ', 8000000),
(2, 'ແປງລົດ click-i', 100000),
(3, 'ແປງລົດ xsr', 100000),
(4, 'ນ້ຳມັນລົດ', 800000),
(5, 'ອາຫານເຂົ້າເຮືອນ', 2000000),
(6, 'ຈ່າຍກິນ', 1000000),
(7, 'C-Tech', 500000),
(8, 'ສຸຂະພາບ', 1000000),
(9, 'ຈ່າຍອື່ນໆ', 2000000),
(11, 'ເງິນເກັບ', 2000000),
(12, 'ອອກທຣີບ', 1000000);

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
(1, 'admin', '123', 'admin');

-- --------------------------------------------------------

--
-- Structure for view `dash_view`
--
DROP TABLE IF EXISTS `dash_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dash_view`  AS SELECT `b`.`item_name` AS `item_name`, `a`.`total_price` AS `total_price`, `c`.`po_date` AS `po_date`, 'ລາຍຈ່າຍ' AS `price_type` FROM ((`tbl_item_order` `a` left join `tbl_item_list` `b` on((`a`.`item_id` = `b`.`item_id`))) left join `tbl_purchase_order` `c` on((`a`.`po_id` = `c`.`po_id`))) ;

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
-- Indexes for table `tbl_income`
--
ALTER TABLE `tbl_income`
  ADD PRIMARY KEY (`ic_id`);

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
-- Indexes for table `tbl_quota_type`
--
ALTER TABLE `tbl_quota_type`
  ADD PRIMARY KEY (`qt_id`);

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
-- AUTO_INCREMENT for table `tbl_income`
--
ALTER TABLE `tbl_income`
  MODIFY `ic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_item_list`
--
ALTER TABLE `tbl_item_list`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `tbl_item_order`
--
ALTER TABLE `tbl_item_order`
  MODIFY `itod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=184;

--
-- AUTO_INCREMENT for table `tbl_purchase_order`
--
ALTER TABLE `tbl_purchase_order`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tbl_quota_type`
--
ALTER TABLE `tbl_quota_type`
  MODIFY `qt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `tbl_sale_list`
--
ALTER TABLE `tbl_sale_list`
  MODIFY `slid` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
