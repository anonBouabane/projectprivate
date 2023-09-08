<?php include('./constant/layout/head.php'); ?>
<?php include('./constant/layout/header.php'); ?>

<?php include('./constant/layout/sidebar.php'); ?>


<?php

$qt_id = $_GET['qt_id'];

$sql = "
select item_name,sum(total_price) as total_price
from tbl_item_order a
left join tbl_item_list b on a.item_id = b.item_id
where quota_type = '$qt_id'
group by item_name 
 ";
$result = $connect->query($sql);



?>
<div class="page-wrapper">

    <div class="row page-titles">
        <div class="col-md-5 align-self-center">
            <h3 class="text-primary font">ລາຍການລາຍຮັບ</h3>
        </div>
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

                <a href="add-income.php"><button class="btn btn-primary">ເພິ່ມລາຍຮັບ</button></a>

                <div class="table-responsive m-t-40">
                    <table id="myTable" class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ລາຍການ</th>
                                <th>ລາຄາ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            foreach ($result as $row) {

                            ?>
                                <tr>
                                    <td><?php echo $row['item_name'] ?></td>


                                    <td class="text-center">
                                        <?php echo  number_format($row['total_price']);  ?>
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


        <?php include('./constant/layout/footer.php'); ?>
        <!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->