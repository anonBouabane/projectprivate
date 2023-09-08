<?php include('./constant/layout/head.php'); ?>
<?php include('./constant/layout/header.php'); ?>

<?php include('./constant/layout/sidebar.php'); ?>


<div class="page-wrapper">

    <div class="row page-titles">
        <div class="col-md-5 align-self-center">
            <h3 class="text-primary">Add Product Management</h3>
        </div>
        <div class="col-md-7 align-self-center">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="javascript:void(0)">Home</a></li>
                <li class="breadcrumb-item active">Add Product</li>
            </ol>
        </div>
    </div>


    <div class="container-fluid">




        <div class="row">
            <div class="col-lg-8" style=" margin-left: 10%;">
                <div class="card">
                    <div class="card-title">

                    </div>
                    <div id="add-brand-messages"></div>
                    <div class="card-body">
                        <div class="input-states">
                            <form class="form-horizontal" method="POST" id="submitBrandForm" action="php_action/createItemList.php" enctype="multipart/form-data">



                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-sm-3 control-label">ຊື່ຄ່າໃຊ້ຈ່າຍ</label>
                                        <div class="col-sm-9">
                                            <input type="text" class="form-control" id="itemname" placeholder="ຊື່ຄ່າໃຊ້ຈ່າຍ" name="itemname" required="" />
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <div class="row">
                                        <label class="col-sm-3 control-label">ຊື່ຄ່າໃຊ້ຈ່າຍ</label>
                                        <div class="col-sm-9">
                                            <select class="form-control" name="quota_type" id="quota_type">
                                                <option value="">~~SELECT~~</option>
                                                <?php
                                                $itemsql = "SELECT * FROM tbl_quota_type order by qt_name asc";
                                                $itemData = $connect->query($itemsql);

                                                while ($row = $itemData->fetch_array()) {
                                                    echo "<option value='" . $row['qt_id'] . "' >" . $row['qt_name'] . "</option>";
                                                } // /while 

                                                ?>
                                            </select>

                                        </div>
                                    </div>
                                </div>




                                <button type="submit" name="create" id="createCategoriesBtn" class="btn btn-primary btn-flat m-b-30 m-t-30">Submit</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>





        <?php include('./constant/layout/footer.php'); ?>
        <!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->