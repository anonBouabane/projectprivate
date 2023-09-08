<?php include('./constant/layout/head.php'); ?>
<?php include('./constant/layout/header.php'); ?>

<?php include('./constant/layout/sidebar.php'); ?>







<div class="page-wrapper">

  <div class="row page-titles">
    <div class="col-md-5 align-self-center">
      <h3 class="text-primary">Invoice Management</h3>
    </div>
    <div class="col-md-7 align-self-center">
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="javascript:void(0)">Home</a></li>
        <li class="breadcrumb-item active">Invoice Management</li>
      </ol>
    </div>
  </div>


  <div class="container-fluid">




    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-title">

          </div>
          <div id="add-brand-messages"></div>
          <div class="card-body">
            <div class="input-states">
              <form class="form-horizontal" method="POST" id="createOrderForm" action="php_action/PurchaseOrder.php" action="php_action/PurchaseOrder.php">


                <div class="form-group">
                  <div class="row">




                    <label class="col-sm-2 control-label">PO Date</label>

                    <div class="col-sm-4">
                      <input type="date" class="form-control" value="<?php echo date('Y-m-d'); ?>" id="orderDate" name="orderDate" autocomplete="off" />
                    </div>
                  </div>
                </div>
                <table class="table" id="productTable">
                  <thead>
                    <tr>
                      <th style="width:40%;">ການຈ່າຍ</th>
                      <th style="width:20%;">ລາຄາ</th> 
                      <th style="width:10%;">Add more</th>
                      <th style="width:5%;">Remove</th>

                    </tr>
                  </thead>
                  <tbody>
                    <?php
                    $arrayNumber = 0;
                    for ($x = 1; $x < 2; $x++) { ?>
                      <tr id="row<?php echo $x; ?>" class="<?php echo $arrayNumber; ?>">




                        <td style="margin-left:20px;">
                          <div class="form-group">

                            <select class="form-control" name="itemname[]" id="itemname<?php echo $x; ?>">
                              <option value="">~~SELECT~~</option>
                              <?php
                              $itemsql = "SELECT * FROM tbl_item_list order by item_name asc";
                              $itemData = $connect->query($itemsql);

                              while ($row = $itemData->fetch_array()) {
                                echo "<option value='" . $row['item_id'] . "' >" . $row['item_name'] . "</option>";
                              } // /while 

                              ?>
                            </select>
                          </div>
                        </td>

                        <td>
                          <div class="form-group">
                            <input type="number" step="any" name="total_price[]" id="total_price<?php echo $x; ?>" autocomplete="off" class="form-control" />
                          </div>
                        </td>
 


                        <td>

                          <div class="form-group"><button type="button" class="btn btn-primary btn-flat " onclick="addRow()" id="addRowBtn" data-loading-text="Loading..."> <i class="fa fa-plus"></i></button></div>


            </div>
            </td>

            <td>



              <div class="form-group"><button type="button" class="btn btn-danger  removeProductRowBtn" type="button" id="removeProductRowBtn" onclick="removeProductRow(<?php echo $x; ?>)"><i class="fa fa-trash"></i></button></div>
          </div>
          </td>


          </tr>
        <?php
                      $arrayNumber++;
                    } // /for
        ?>
        </tbody>
        </table>



        <div class="form-group submitButtonFooter">
          <div class="col-sm-offset-2 col-sm-10">

            <button type="submit" id="createOrderBtn" data-loading-text="Loading..." class="btn btn-success btn-flat m-b-30 m-t-30"><i class="glyphicon glyphicon-ok-sign"></i> Submit</button>

            <button type="reset" class="btn btn-danger btn-flat m-b-30 m-t-30" onclick="resetOrderForm()"><i class="glyphicon glyphicon-erase"></i> Reset</button>
          </div>
        </div>

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

          '<select class="form-control" name="itemname[]" id="itemname' + count + '" >' +
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

        


          '<td>  <div class="form-group">' +
          '<button class="btn btn-primary removeProductRowBtn" type="button" onclick="addRow(' + count + ')"><i class="fa fa-plus"></i></button>' +
          '</div></td>' +
          '<td>  <div class="form-group">' +
          '<button class="btn btn-danger removeProductRowBtn" type="button" onclick="removeProductRow(' + count + ')"><i class="fa fa-trash"></i></i></button>' +
          '</div></td>' +

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