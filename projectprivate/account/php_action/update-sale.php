<?php 	

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if($_POST) {	
	$saleid = $_POST['saleid'];
	$itemuse = $_POST['itemuse']; 
	$itemid = $_POST['itemid']; 
	
	
	$itemsql = "SELECT * FROM tbl_item_list where item_id = '$itemid' ";
                      $itemData = $connect->query($itemsql);

                      while($row = $itemData->fetch_array()) {
						$litre = $row['pack_size'];
						 
						$total_litre = ($litre*$itemuse) ;
						$price = $row['unit_price'];
						$total_price = ($price*$itemuse) ;
                        
                      }

	 
	
	$updateQuantitySql = "update tbl_sale_list set item_used ='$itemuse',total_price ='$total_price', total_litre ='$total_litre' where slid ='$saleid'  ";	 
	$connect->query($updateQuantitySql);
	  
	 

		
	

	$valid['success'] = true;
	$valid['messages'] = "Successfully Updated";
	//echo"gfg";exit;		
	$connect->close();
	header('location:'.$_SERVER['HTTP_REFERER']);

	echo json_encode($valid);
 
} // /if $_POST
// echo json_encode($valid);