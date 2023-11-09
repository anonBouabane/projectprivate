<?php //error_reporting(1); 
?>
<?php include('./constant/layout/head.php'); ?>
<?php include('./constant/layout/header.php'); ?>

<?php include('./constant/layout/sidebar.php'); ?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->
<?php


$lowStockSql = "select sum(total_price) as total_pay from tbl_item_order";
$lowStockQuery = $connect->query($lowStockSql);
$countLowStock = $lowStockQuery->num_rows;

$lowStockSql1 = "SELECT * FROM tbl_item_order ";
$lowStockQuery1 = $connect->query($lowStockSql1);
$countLowStock1 = $lowStockQuery1->num_rows;

$date = date('Y-m-d');
$lowStockSql3 = "SELECT * FROM tbl_sale_list ";

$lowStockQuery3 = $connect->query($lowStockSql3);
$countLowStock3 = $lowStockQuery3->num_rows;

$lowStockSql2 = "SELECT * FROM tbl_item_list ";
$lowStockQuery2 = $connect->query($lowStockSql2);
$countLowStock2 = $lowStockQuery2->num_rows;

//$connect->close();

?>


<style type="text/css">
    .ui-datepicker-calendar {
        display: none;
    }
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<div class="page-wrapper">

    <!--     <div class="row page-titles">
                <div class="col-md-12 align-self-center">
                    <div class="float-right"><h3 style="color:black;"><p style="color:black;"><?php echo date('l') . ' ' . date('d') . '- ' . date('m') . '- ' . date('Y'); ?></p></h3>
                    </div>
                    </div>
                
            </div> -->


    <div class="container-fluid ">

        <div class="row">
            <div class="col-md-6 dashboard">
                <div class="card" style="background: #F94687 ">
                    <div class="media widget-ten">
                        <div class="media-left meida media-middle">
                            <span><i class="ti-stats-down"></i></span>
                        </div>
                        <div class="media-body media-text-right">

                            <?php

                            $sql3 = "select sum(total_price) as total_pay from tbl_item_order";
                            $result3 = $connect->query($sql3);
                            foreach ($result3 as $row3) {

                            ?>

                                <h2 class="color-white"><?php echo number_format($row3['total_pay']); ?></h2>

                            <?php

                            }





                            ?>


                            <a href="product.php">
                                <p class="m-b-0">ລວມລາຍຈ່າຍ</p>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 dashboard ">
                <div class="card " style="    background-color: #2BC155 ">
                    <div class="media widget-ten">
                        <div class="media-left meida media-middle">
                            <span><i class="ti-stats-up"></i></span>
                        </div>
                        <div class="media-body media-text-right">

                            <?php

                            $sql4 = "select sum(income) as total_income from tbl_income";
                            $result4 = $connect->query($sql4);
                            foreach ($result4 as $row4) {

                            ?>

                                <h2 class="color-white"><?php echo number_format($row4['total_income']); ?></h2>

                            <?php

                            }





                            ?>

                            <a href="income.php">
                                <p class="m-b-0">ລວມລາຍຮັບ</p>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6 dashboard ">
                <div class="card " style="    background-color: #7430b8 ">
                    <div class="media widget-ten">
                        <div class="media-left meida media-middle">
                            <span><i class="ti-money"></i></span>
                        </div>
                        <div class="media-body media-text-right">

                            <?php

                            $sql6 = "SELECT  sum(total_price) as service_price from tbl_item_order where item_id = 23 ";
                            $result6 = $connect->query($sql6);
                            foreach ($result6 as $row6) {

                                $service_pay = $row6['service_price'];
                            }

                            ?>

                            <h2 class="color-white"><?php echo number_format($row4['total_income'] - $row3['total_pay']); ?></h2>



                            <a href="income.php">
                                <p class="m-b-0">ຍອດເຫຼືອໃນບັນຊີ(ທຶນ)</p>
                            </a>
                        </div>
                    </div>
                </div>
            </div>





            <?php

            $sqlqt = "select * from tbl_quota_type ";
            $resultqt = $connect->query($sqlqt);
            foreach ($resultqt as $rowqt) {

                $qt_id = $rowqt['qt_id'];



                $sql5 = " 
                select qt_name,sum(total_price) as iol_quota 
                from tbl_item_order a
                left join tbl_item_list b on a.item_id = b.item_id
                right join tbl_quota_type c on b.quota_type =c.qt_id
                where qt_id ='$qt_id'
                group by quota_type 
                  ";
                $result5 = $connect->query($sql5);
                foreach ($result5 as $row5) {



                    $price_quota = $rowqt['quota_price'];
                    $percent_quota = 100 - (($row5['iol_quota'] * 100) / $price_quota);

                    if ($qt_id == 11) {
                        if ($percent_quota > 75) {
                            $color_mark = "#FE4C76";
                        } else if ((($percent_quota <= 74))) {
                            $color_mark = "#2BC155";
                        }
                    } else {
                        if ($percent_quota > 75) {
                            $color_mark = "#266afc";
                        } else if (($percent_quota >= 50) && (($percent_quota <= 74))) {
                            $color_mark = "#2BC155";
                        } else if (($percent_quota >= 15) && (($percent_quota <= 49))) {
                            $color_mark = "#FE934C";
                        } else if ((($percent_quota <= 14))) {
                            $color_mark = "#FE4C76";
                        }
                    }




            ?>
                    <div class="col-md-6 dashboard ">
                        <div class="card " style='background-color: <?php echo "$color_mark"; ?>'>
                            <div class="media widget-ten">
                                <div class="media-left meida media-middle">
                                    <span><i class="ti-sharethis"></i></span>
                                </div>
                                <div class="media-body media-text-right">
                                    <h2 class="color-white"><?php echo  number_format($row5['iol_quota']); ?></h2>
                                    <a href="view_detail_quota.php?qt_id=<?php echo "$qt_id"; ?>"">
                                        <p class=" m-b-0"><?php echo $rowqt['qt_name']; ?></p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
            <?php

                }
            }
            ?>






            <div class="col-md-12">
                <div class="card">
                    <div class="card-header font">
                        <strong class="card-title ">ລາຍການ</strong>

                        <div class="table-responsive m-t-40">
                            <table id="myTable" class="table table-bordered table-striped">
                                <thead>
                                    <tr>
                                        <th>ລຳດັບ</th>
                                        <th>ຊື່ລາຍການ</th>
                                        <th>ລາຄາ</th>
                                        <th>ວັນທີຈ່າຍ</th>
                                        <th>ປະເພດ</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    //include('./constant/connect');

                                    $sql = " select * from dash_view order by po_date desc ";
                                    //echo $sql;exit;
                                    $result = $connect->query($sql);
                                    //print_r($result);exit;
                                    $i = 1;
                                    foreach ($result as $row) {


                                    ?>
                                        <tr>
                                            <td><?php echo  "$i"; ?></td>
                                            <td><?php echo  $row['item_name'] ?></td>
                                            <td><?php echo  number_format($row['total_price']);  ?></td>
                                            <td><?php echo  $row['po_date'] ?></td>
                                            <td>
                                                <?php

                                                if ($row['price_type'] == "ລາຍຮັບ") {
                                                    $color_alert =  "label-success";
                                                } else {
                                                    $color_alert =  "label-warning";
                                                }
                                                ?>

                                                <label class='label <?php echo "$color_alert"; ?>'>
                                                    <h4 class="font">ລາຍຮັບ</h4>
                                                </label>
                                            </td>


                                        </tr>

                                </tbody>
                            <?php
                                        $i++;
                                    }

                            ?>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div id="myChart" style="width:100%; max-width:600px; height:500px;">
                </div>
            </div>
            <div class="col-md-6">

                <div id="myChart1" style="width:100%; max-width:600px; height:500px;"></div>
            </div>
        </div>





    </div>
</div>
</div>


<?php include('./constant/layout/footer.php'); ?>
<script>
    $(function() {
        $(".preloader").fadeOut();
    })
</script>
<script>
    google.charts.load('current', {
        'packages': ['corechart']
    });
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var data = google.visualization.arrayToDataTable([
            ['Contry', 'Mhl'], <?php echo $datavalue1; ?>
        ]);

        var options = {
            title: 'World Wide Wine Production',
            is3D: true
        };

        var chart = new google.visualization.PieChart(document.getElementById('myChart'));
        chart.draw(data, options);

        var chart = new google.visualization.BarChart(document.getElementById('myChart1'));
        chart.draw(data, options);
    }
</script>