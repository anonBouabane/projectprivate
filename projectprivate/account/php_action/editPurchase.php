<?php 	

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if($_POST) {	
	$poid = $_POST['poid'];
	 

	$orderDate = date('Y-m-d', strtotime($_POST['orderDate'])); 
	
   
	$addby =$_SESSION['userId'];
	
	
	$sql = "UPDATE tbl_purchase_order   po_date = '$orderDate '  WHERE po_id = {$poid}";
	//echo $sql;exit;	
	$connect->query($sql);
	$readyToUpdateOrderItem = false;
	
	
	// remove the order item data from order item table
	$removeOrderSql = "DELETE FROM tbl_item_order WHERE po_id = {$poid}"; 
	$connect->query($removeOrderSql);
	
	
	
	// add the quantity from the order item to product table
	for($x = 0; $x < count($_POST['itemname']); $x++) {	
		
		
		$totalprice = $_POST['total_price'][$x] ;
	 
		  
	
	  
		$updateQuantitySql = " insert into tbl_item_order (po_id,item_id,total_price ,update_by,last_date)
		values ('$poid','".$_POST['itemname'][$x]."', '".$_POST['total_price'][$x]."', '$addby', now()) ";
		$connect->query($updateQuantitySql);
		
		if(count($_POST['productName']) == count($_POST['productName'])) {
			$readyToUpdateOrderItem = true;			
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