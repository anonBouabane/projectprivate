<?php 	

require_once 'core.php';
 
$itemid = $_GET['id'];
if($_POST) {	

	$materialcode = $_POST['materialcode'];
	$itemname = $_POST['itemname'];  
	$packing = $_POST['packing'];
	$unittype = $_POST['unittype'];
	$grade = $_POST['grade'];  
	
	$packsize =  $_POST['packsize'];
	$litreprice = $_POST['litreprice'];
	
	$unitprice = ($packsize*$litreprice) ;
	
	$vehicletype = $_POST['vehicletype'];

	$sql = "UPDATE tbl_item_list SET   item_name='$itemname' 
	WHERE item_id = '$itemid'";

	if($connect->query($sql) === TRUE) {
	 	$valid['success'] = true;
		$valid['messages'] = "Successfully Updated";
		header('location:../itemlist.php');	
	} else {
	 	$valid['success'] = false;
	 	$valid['messages'] = "Error while updating the categories";
	}
	 
	$connect->close();

	echo json_encode($valid);
 
} // /if $_POST