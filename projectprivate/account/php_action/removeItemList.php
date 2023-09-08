<?php 	

require_once 'core.php';


//$valid['success'] = array('success' => false, 'messages' => array());

//$categoriesId = $_POST['categoriesId'];
$itemid = $_GET['id'];
if($itemid) { 

 $sql = "delete from tbl_item_list where  item_id={$itemid} ";

 if($connect->query($sql) === TRUE) {
 	$valid['success'] = true;
	$valid['messages'] = "Successfully Removed";
	header('location:../itemlist.php');		
 } else {
 	$valid['success'] = false;
 	$valid['messages'] = "Error while remove the brand";
 }
 
 $connect->close();

 echo json_encode($valid);
 
} // /if $_POST