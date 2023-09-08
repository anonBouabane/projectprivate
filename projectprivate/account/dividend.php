<?php include('./constant/layout/head.php');?>
<?php include('./constant/layout/header.php');?>

<?php include('./constant/layout/sidebar.php');?>


<?php 
 $user=$_SESSION['userId'];
$sql = "SELECT dv_id,dv_values , date_register FROM tbl_devidend order by dv_id desc";
$result = $connect->query($sql);

//echo $sql;exit;

    //echo $itemCountRow;exit; 
	
	
?>
       <div class="page-wrapper">
            
            <div class="row page-titles">
                <div class="col-md-5 align-self-center">
                    <h3 class="text-primary font">ລາຍການເງິນປັນຜົນ</h3> </div>
                <div class="col-md-7 align-self-center">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Home</a></li>
                        <li class="breadcrumb-item active">View Order</li>
                    </ol>
                </div>
            </div>
            
            
            <div class="container-fluid">
                
                
                
                
                 <div class="card font">
                            <div class="card-body"> 
                              
                            <a href="add-dividend.php"><button class="btn btn-primary ">ເບີກເງິນປັນຜົນ</button></a>
                         
                                <div class="table-responsive m-t-40">
                                    <table id="myTable" class="table table-bordered table-striped">
                                        <thead>
                                            <tr> 
												<th>ຍອດເບີກ</th> 
												<th>ວັນທີລົງບິນ</th>
                                                <th></th>
                                            </tr>
                                       </thead>
                                       <tbody>
                                        <?php
foreach ($result as $row) {
      
    ?>
                                        <tr> 
										 
                                            <td class="text-center">
											<?php echo  number_format($row['dv_values']);  ?>
											</td>  
                                            <td><?php echo $row['date_register'] ?></td>
                                             
                                               
                                             
                                            <td> 
             
                                                <a href="php_action/deletedividend.php?id=<?php echo $row['dv_id']?>" ><button type="button" class="btn btn-xs btn-danger" onclick="return confirm('Are you sure to delete this record?')"><i class="fa fa-trash"></i></button></a>

                                                
                                                
                                                </td>
                                        </tr>
                                     
                                    </tbody>
                                   <?php    
}

?>
                               </table>
                                </div>
                            </div>
                        </div>

 
<?php include('./constant/layout/footer.php');?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->


