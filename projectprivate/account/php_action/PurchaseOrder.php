<?php

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if ($_POST) {

	$orderDate 	= $_POST['orderDate'];
	$addby = $_SESSION['userId'];




	$sql = "INSERT INTO tbl_purchase_order ( po_date,  add_by,register_date) 
				VALUES (  '$orderDate', '$addby', now())";

	if ($connect->query($sql) === TRUE) {

		$lastid = mysqli_insert_id($connect);
		$checkbox1 = count($_POST['itemname']);

		for ($i = 0; $i < ($checkbox1); $i++) {
			extract($_POST);




			$sql1 = "INSERT INTO tbl_item_order (po_id,item_id, total_price, update_by,last_date) 
				VALUES ('$lastid','$itemname[$i]', '$total_price[$i]','$addby',now())";

			if ($connect->query($sql1) === TRUE) {

				$valid['success'] = true;
				$valid['messages'] = "Successfully Added";
				header('location:../purchase.php');
			}
		}
	} else {
		$valid['success'] = false;
		$valid['messages'] = "Error while adding the members";
		header('location:../add-purchase.php');
	}


	$connect->close();

	echo json_encode($valid);
}
