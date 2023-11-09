-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 08, 2023 at 06:13 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `private`
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
(1, 750000, NULL, '2023-06-02', 'ເງິນເດືອນ'),
(5, 300000, 0, '2023-11-04', 'ເງິນນອກ'),
(6, 100000, 0, '2023-11-04', 'ເງິນນອກ'),
(7, 190000, 0, '2023-11-06', 'ເງິນນອກ'),
(8, 400000, 0, '2023-11-06', 'ເງິນນອກ'),
(9, 300000, 0, '2023-11-07', 'ເງິນນອກ');

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
(1, 'ຊີ້ນດາດ', 1, '2023-11-01', 1),
(2, 'ສະຕິງ', 1, '2023-11-01', 1),
(3, 'Vila', 1, '2023-11-01', 6),
(4, 'ຄ່າເບຍ', 1, '2023-11-01', 3),
(5, 'ຄ່າຮັບນ້ອງ', 1, '2023-11-01', 7),
(6, 'ຄ່ານ້ຳມັນ', 1, '2023-11-01', 4),
(7, 'ໃຊ້ຫນີ້', 1, '2023-11-01', 8),
(8, 'ຄ່າກາເຟ', 1, '2023-11-04', 1),
(9, 'ຄ່າເຄື່ອງນຸ່ງ', 1, '2023-11-05', 5),
(10, 'ຄ່າຂະຫນົມ', 1, '2023-11-06', 1),
(11, 'ຕຳຫມາກຮຸ່ງ', 1, '2023-11-07', 1);

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
(1, 1, 1, 50000, 1, '2023-11-01'),
(2, 2, 4, 30000, 1, '2023-11-01'),
(3, 2, 2, 9000, 1, '2023-11-01'),
(4, 2, 3, 9000, 1, '2023-11-01'),
(5, 3, 6, 30000, 1, '2023-11-01'),
(6, 3, 5, 60000, 1, '2023-11-01'),
(7, 4, 7, 200000, 1, '2023-11-03'),
(8, 5, 4, 10000, 1, '2023-11-03'),
(9, 6, 8, 10000, 1, '2023-11-04'),
(10, 7, 9, 400000, 1, '2023-11-05'),
(11, 7, 2, 10000, 1, '2023-11-05'),
(12, 8, 4, 135000, 1, '2023-11-06'),
(13, 9, 4, 150000, 1, '2023-11-06'),
(14, 10, 6, 20000, 1, '2023-11-06'),
(15, 11, 10, 20000, 1, '2023-11-06'),
(16, 12, 6, 30000, 1, '2023-11-06'),
(17, 12, 4, 15000, 1, '2023-11-06'),
(18, 13, 6, 50000, 1, '2023-11-07'),
(19, 13, 2, 10000, 1, '2023-11-07'),
(20, 13, 11, 20000, 1, '2023-11-07'),
(21, 13, 11, 20000, 1, '2023-11-07');

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
(1, '2023-11-01', 1, '2023-11-01'),
(2, '2023-11-01', 1, '2023-11-01'),
(3, '2023-11-01', 1, '2023-11-01'),
(4, '2023-11-03', 1, '2023-11-03'),
(5, '2023-11-03', 1, '2023-11-03'),
(6, '2023-11-04', 1, '2023-11-04'),
(7, '2023-11-05', 1, '2023-11-05'),
(8, '2023-11-05', 1, '2023-11-06'),
(9, '2023-11-05', 1, '2023-11-06'),
(10, '2023-11-06', 1, '2023-11-06'),
(11, '2023-11-06', 1, '2023-11-06'),
(12, '2023-11-06', 1, '2023-11-06'),
(13, '2023-11-07', 1, '2023-11-07');

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
(1, 'ຄ່າກິນ', 1000),
(3, 'ສັງສັນ', 10),
(4, 'ຄ່ານ້ຳມັນ', 10),
(5, 'ຄ່າເຄື່ອງນຸ່ງ', 10),
(6, 'ຄ່າເຄື່ອງໃຊ້ສ່ວນຕົວ', 10),
(7, 'ຄ່າໃຊ້ຈ່າຍໃນໂຮງຮຽນ', 10),
(8, 'ໃຊ້ຫນີ້', 10);

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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dash_view`  AS  select `b`.`item_name` AS `item_name`,`a`.`total_price` AS `total_price`,`c`.`po_date` AS `po_date`,'ລາຍຈ່າຍ' AS `price_type` from ((`tbl_item_order` `a` left join `tbl_item_list` `b` on(`a`.`item_id` = `b`.`item_id`)) left join `tbl_purchase_order` `c` on(`a`.`po_id` = `c`.`po_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `sumary_sale_item`
--
DROP TABLE IF EXISTS `sumary_sale_item`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sumary_sale_item`  AS  (select `tbl_sale_list`.`po_id` AS `po_id`,`tbl_sale_list`.`itod_id` AS `itod_id`,`tbl_sale_list`.`item_id` AS `item_id`,sum(`tbl_sale_list`.`item_used`) AS `item_used` from `tbl_sale_list` group by `tbl_sale_list`.`po_id`,`tbl_sale_list`.`itod_id`,`tbl_sale_list`.`item_id`) ;

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
  MODIFY `ic_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tbl_item_list`
--
ALTER TABLE `tbl_item_list`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_item_order`
--
ALTER TABLE `tbl_item_order`
  MODIFY `itod_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tbl_purchase_order`
--
ALTER TABLE `tbl_purchase_order`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `tbl_quota_type`
--
ALTER TABLE `tbl_quota_type`
  MODIFY `qt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

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
