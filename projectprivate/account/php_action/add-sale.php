<?php 	

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if($_POST) {	
	$poid = $_POST['poid'];
	$pocode = $_POST['pocode']; 

	$orderDate = date('Y-m-d', strtotime($_POST['orderDate'])); 
	
   
	$addby =$_SESSION['userId'];
	
 
	 
	
	// add the quantity from the order item to product table
	for($x = 0; $x < count($_POST['itodid']); $x++) {
		
		if($_POST['itemused'][$x] != 0) {
			
			$qty = $_POST['itemused'][$x];

		$itemsql = "SELECT * FROM tbl_item_list where item_id = '".$_POST['itemid'][$x]."' ";
                      $itemData = $connect->query($itemsql);

                      while($row = $itemData->fetch_array()) {
						$litre = $row['pack_size'];
						 
						$total_litre = ($litre*$qty) ;
						$price = $row['unit_price'];
						$total_price = ($price*$qty) ;
                        
                      }

			
		
	  
		$updateQuantitySql = " insert into tbl_sale_list (po_id,itod_id,item_id,item_used,item_price,total_price,litre,total_litre,add_by,date_registed)
		
		values ('$poid','".$_POST['itodid'][$x]."', '".$_POST['itemid'][$x]."', '".$_POST['itemused'][$x]."' ,'$price','$total_price','$litre','$total_litre', '$addby', now()) ";
		 
		$connect->query($updateQuantitySql);
		}
		 
	} // /for quantity

	

	 

	

	$valid['success'] = true;
	$valid['messages'] = "Successfully Updated";
	//echo"gfg";exit;		
	$connect->close();
	header('location:'.$_SERVER['HTTP_REFERER']);

	echo json_encode($valid);
 
} // /if $_POST
// echo json_encode($valid);