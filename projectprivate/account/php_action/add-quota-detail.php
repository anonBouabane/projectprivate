<?php

require_once 'core.php';

$valid['success'] = array('success' => false, 'messages' => array());

if ($_POST) {

    extract($_POST);

    $sql = "INSERT INTO tbl_quota_type (qt_name, quota_price) 
	VALUES (  '$quota_name', '$quota_price')";

    if ($connect->query($sql) === TRUE) {
        $valid['success'] = true;
        $valid['messages'] = "Successfully Added";
        header('location:../quota.php');
    } else {
        $valid['success'] = false;
        $valid['messages'] = "Error while adding the members";
    }

    $connect->close();

    echo json_encode($valid);
} // /if $_POST