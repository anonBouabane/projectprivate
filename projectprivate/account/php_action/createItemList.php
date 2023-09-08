<?php 	

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if($_POST) {	

	$materialcode = $_POST['materialcode'];
	$itemname = $_POST['itemname']; 
	
	$packsize =  $_POST['packsize'];
	$litreprice = $_POST['litreprice'];
	
	$unitprice = ($packsize*$litreprice) ;
	
	$packing = $_POST['packing'];
	$unittype = $_POST['unittype'];
	$grade = $_POST['grade']; 
	$vehicletype = $_POST['vehicletype'];
	$addby =$_SESSION['userId'];

	$quota_type =$_POST['quota_type'];

	$sql = "INSERT INTO tbl_item_list (item_name,add_by,date_register,quota_type) 
	VALUES (  '$itemname',  '$addby',now(),'$quota_type')";

	if($connect->query($sql) === TRUE) {
	 	$valid['success'] = true;
		$valid['messages'] = "Successfully Added";
		header('location:../itemlist.php');
	} else {
	 	$valid['success'] = false;
	 	$valid['messages'] = "Error while adding the members";
	}

	$connect->close();

	echo json_encode($valid);
 
} // /if $_POST