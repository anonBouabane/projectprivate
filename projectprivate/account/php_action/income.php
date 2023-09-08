<?php 	

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if($_POST) {	
 
	$income = $_POST['income'];
	$sale_unit = $_POST['sale_unit']; 
	$incometype = $_POST['incometype']; 
	
	

	$sql = "INSERT INTO tbl_income (income,sale_unit,income_type ,date_register) 
	VALUES (  '$income',  '$sale_unit','$incometype',now())";

	if($connect->query($sql) === TRUE) {
	 	$valid['success'] = true;
		$valid['messages'] = "Successfully Added";
		header('location:../income.php');
	} else {
	 	$valid['success'] = false;
	 	$valid['messages'] = "Error while adding the members";
	}

	$connect->close();

	echo json_encode($valid);
 
} // /if $_POST