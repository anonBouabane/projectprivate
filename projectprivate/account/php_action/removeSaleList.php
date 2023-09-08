<?php 	

require_once 'core.php';


//$valid['success'] = array('success' => false, 'messages' => array());

//$categoriesId = $_POST['categoriesId'];
$saleid = $_GET['id'];
if($saleid) { 

 $sql = "delete from tbl_sale_list where  slid={$saleid} ";

 if($connect->query($sql) === TRUE) {
 	$valid['success'] = true;
	$valid['messages'] = "Successfully Removed"; 
	header('location:'.$_SERVER['HTTP_REFERER']);	
 } else {
 	$valid['success'] = false;
 	$valid['messages'] = "Error while remove the brand";
 }
 
 $connect->close();

 echo json_encode($valid);
 
} // /if $_POST