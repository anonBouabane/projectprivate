<?php include('./constant/layout/head.php');?>
<?php include('./constant/layout/header.php');?>

<?php include('./constant/layout/sidebar.php');?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->   
<!-- <link rel="stylesheet" href="custom/js/order.js"> -->

<?php 

 

 
?>
 


 
        <div class="page-wrapper">
            
            <div class="row page-titles">
                <div class="col-md-5 align-self-center">
                    <h3 class="text-primary">Edit Utilization Management</h3> </div>
                <div class="col-md-7 align-self-center">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="javascript:void(0)">Home</a></li>
                        <li class="breadcrumb-item active">Edit Utilization</li>
                    </ol>
                </div>
            </div>
            
            
            <div class="container-fluid">
                
                
                
                
                <div class="row">
                    <div class="col-lg-12"  >
                        <div class="card">
                            <div class="card-title">
                               
                            </div>
                            <div id="add-brand-messages"></div>
                            <div class="card-body">
                                <div class="input-states">
                                    <form class="row" method="POST" action="php_action/update-sale.php" id="editOrderForm">

        <?php $saleid = $_GET['id'];
        

        $sql = "   
		SELECT distinct a.po_id as po_id,po_date,pod_code 
		FROM tbl_purchase_order a
		left join tbl_sale_list b on a.po_id = b.po_id 
		WHERE slid = {$saleid} ";
 
        $result = $connect->query($sql);
        $data = $result->fetch_row();
       

        ?>

        <div class="form-group col-md-6">
          <label class="control-label">Utilization Date</label>
		  <input type="hidden" class="form-control" id="poid" name="poid" autocomplete="off" value="<?php echo $data[0] ?>" />
            <input type="date" class="form-control" id="orderDate" name="orderDate" autocomplete="off" value="<?php echo $data[1] ?>"  disabled="true"/> 
      </div>
        <div class="form-group col-md-6">
            <label class="control-label">PO Code</label>
            <input type="text" class="form-control" id="pocode" name="pocode" placeholder="Purchase Order No" autocomplete="off" value="<?php echo $data[2] ?>"  disabled="true" />
        </div> 
        

        <table class="table" id="productTable">
          <thead>
            <tr>
				<th style="width:10%;">Sale Number</th>
              <th style="width:40%;">Item Name</th> 
			  <th style="width:30%;">Date Sale</th>
              <th style="width:10%;">Item Sale</th>
			   
            </tr>
          </thead>
          <tbody>
            <?php

            $orderItemSql = " 
			select slid,item_used,item_name,date_registed,a.item_id as item_id
			from tbl_sale_list a 
			left join tbl_item_list b on a.item_id = b.item_id 
			where slid = {$saleid} 
			 ";
            //echo $orderItemSql;exit;
            $orderItemResult = $connect->query($orderItemSql);
            // $orderItemData = $orderItemResult->fetch_all();            
            
            // print_r($orderItemData);
            $arrayNumber = 0;
            // for($x = 1; $x <= count($orderItemData); $x++) {
            $x = 1;
            while($orderItemData = $orderItemResult->fetch_array()) { 
              // print_r($orderItemData); ?>
              <tr id="row<?php echo $x; ?>" class="<?php echo $arrayNumber; ?>">    

				
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['slid']; ?>
				   <input type="hidden" name="saleid" id="saleid" autocomplete="off" class="form-control" value="<?php echo $orderItemData['slid']; ?>" />
				</div>
                </td>
				 
			  
                <td>
                  <div class="form-group"> 
				  <input type="hidden" name="itemid" id="itemid" autocomplete="off" class="form-control" value="<?php echo $orderItemData['item_id']; ?>" />
				   <label><?php echo $orderItemData['item_name']; ?></label>  
                  </div>
                </td>
				
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['date_registed']; ?>
				</div>
                </td>
              
				
				
				<td>
				<div class="form-group"> 
				   <input type="number" name="itemuse" id="itemuse" autocomplete="off" class="form-control" value="<?php echo $orderItemData['item_used']; ?>" />
				</div>
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
        
          <button type="submit" id="editOrderBtn" data-loading-text="Loading..." class="btn btn-success"><i class="glyphicon glyphicon-ok-sign"></i>Update Sale</button>
            
          </div>
      </form>
	  
	  
                            </div>
                        </div>
                    </div>
                  
                </div>
                
               


 
<?php include('./constant/layout/footer.php');?>
 
