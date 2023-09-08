<?php include('./constant/layout/head.php'); ?>
<?php include('./constant/layout/header.php'); ?>

<?php include('./constant/layout/sidebar.php'); ?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->
<!-- <link rel="stylesheet" href="custom/js/order.js"> -->

<?php




?>



<div class="page-wrapper">

  <div class="row page-titles">
    <div class="col-md-5 align-self-center">
      <h3 class="text-primary">ແກ້ໄຂລາຍການບິນ</h3>
    </div>
    <div class="col-md-7 align-self-center">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0)">Home</a></li>
        <li class="breadcrumb-item active">Edit Utilization</li>
      </ol>
    </div>
  </div>


  <div class="container-fluid">
    <div class="row">
      <div class="col-lg-12">
        <div class="card font">
          <div class="card-title">

          </div>
          <div id="add-brand-messages"></div>
          <div class="card-body">
            <div class="input-states">
              <form class="row" method="POST" action="php_action/editPurchase.php" id="editOrderForm">

                <?php $orderId = $_GET['id'];


                $sql = "  SELECT    po_id,po_date  FROM tbl_purchase_order WHERE po_id = {$orderId} ";

                $result = $connect->query($sql);
                $data = $result->fetch_row();


                ?>

                <div class="form-group col-md-6">
                  <label class="control-label">ວັນທີລົງບິນ</label>
                  <input type="hidden" class="form-control" id="poid" name="poid" autocomplete="off" value="<?php echo $data[0] ?>" />
                  <input type="date" class="form-control" id="orderDate" name="orderDate" autocomplete="off" value="<?php echo $data[1] ?>" />
                </div>


                <table class="table" id="productTable">
                  <thead>
                    <tr>
                      <th style="width:30%;">ຊື່ລາຍຈ່າຍ</th>
                      <th style="width:10%;">ລາຄາ</th>
                      <th style="width:10%;">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <?php

                    $orderItemSql = "SELECT  * FROM tbl_item_order WHERE  po_id = {$orderId}";
                    $orderItemResult = $connect->query($orderItemSql);
                    $x = 1;
                    $arrayNumber = 1;
                    while ($orderItemData = $orderItemResult->fetch_array()) {

                    ?>
                      <tr id="row<?php echo $x; ?>" class="<?php echo $arrayNumber; ?>">
                        <td>
                          <div class="form-group">



                            <select class="form-control" name="itemname[]" id="itemname<?php echo $x; ?>">
                              <option value="">~~SELECT~~</option>
                              <?php
                              $productSql = "SELECT * FROM tbl_item_list  order by item_name asc";
                              $productData = $connect->query($productSql);

                              while ($row = $productData->fetch_array()) {
                                $selected = "";
                                if ($row['item_id'] == $orderItemData['item_id']) {
                                  $selected = "selected";
                                } else {
                                  $selected = "";
                                }

                                echo "<option value='" . $row['item_id'] . "'  " . $selected . " >" . $row['item_name'] . "</option>";
                              } // /while 

                              ?>
                            </select>
                          </div>
                        </td>

                        <td>
                          <div class="form-group">
                            <input type="text" name="total_price[]" id="total_price<?php echo $x; ?>" autocomplete="off" class="form-control" value="<?php echo $orderItemData['total_price']; ?>" />
                          </div>

                        </td>





                        <td>

                          <button class="btn btn-xs btn-danger removeProductRowBtn" type="button" id="removeProductRowBtn" onclick="removeProductRow(<?php echo $x; ?>)"><i class="fa fa-trash"></i></button>
                        </td>
                      </tr>
                    <?php
                      $arrayNumber++;
                      $x++;
                    } // /for
                    ?>
                  </tbody>
                </table>





                <div class="form-group editButtonFooter col-md-12 mx-auto text-center">
                  <button type="button" class="btn btn-default" onclick="addRow()" id="addRowBtn" data-loading-text="Loading..."> <i class="glyphicon glyphicon-plus-sign"></i> Add Row </button>

                  <input type="hidden" name="orderId" id="orderId" value="<?php echo $orderId; ?>" />

                  <button type="submit" id="editOrderBtn" data-loading-text="Loading..." class="btn btn-success"><i class="glyphicon glyphicon-ok-sign"></i> Save Changes</button>

                </div>
              </form>
            </div>
          </div>
        </div>
      </div>

    </div>

  </div>

  



  <?php include('./constant/layout/footer.php'); ?>
  <!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->

  <script>
    function addRow() {
      $("#addRowBtn").button("loading");

      var tableLength = $("#productTable tbody tr").length;

      var tableRow;
      var arrayNumber;
      var count;

      if (tableLength > 0) {
        tableRow = $("#productTable tbody tr:last").attr('id');
        arrayNumber = $("#productTable tbody tr:last").attr('class');
        count = tableRow.substring(3);
        count = Number(count) + 1;
        arrayNumber = Number(arrayNumber) + 1;
      } else {
        // no table row
        count = 1;
        arrayNumber = 0;
      }

      $.ajax({
        url: 'php_action/fetchItemData.php',
        type: 'post',
        dataType: 'json',
        success: function(response) {
          $("#addRowBtn").button("reset");





          var tr = '<tr id="row' + count + '" class="' + arrayNumber + '">' +
            '<td>' +
            '<div class="form-group">' +

            '<select class="form-control" name="itemname[]" id="itemname' + count + '"  >' +
            '<option value="">~~SELECT~~</option>';
          // console.log(response);
          $.each(response, function(index, value) {
            tr += '<option value="' + value[0] + '">' + value[1] + '</option>';
          });

          tr += '</select>' +
            '</div>' +
            '</td>' +

            '<td>  <div class="form-group">' +
            '<input type="text" name="total_price[]" id="total_price' + count + '" autocomplete="off" class="form-control" />' +
            '</div></td>' +



            '<td>' +

            '<button class="btn btn-xs btn-danger removeProductRowBtn" type="button" onclick="removeProductRow(' + count + ')"><i class="fa fa-trash"></i></button>' +
            '</td>' +
            '</tr>';
          if (tableLength > 0) {
            $("#productTable tbody tr:last").after(tr);
          } else {
            $("#productTable tbody").append(tr);
          }

        } // /success
      }); // get the product data

    } // /add row

    function removeProductRow(row = null) {
      if (row) {
        $("#row" + row).remove();


        subAmount();
      } else {
        alert('error! Refresh the page again');
      }
    }
  </script>