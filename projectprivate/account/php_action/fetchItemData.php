<?php 	

require_once 'core.php';

$sql = "SELECT item_id, item_name FROM tbl_item_list order by item_name asc";
$result = $connect->query($sql);

$data = $result->fetch_all();

$connect->close();

echo json_encode($data);
?>