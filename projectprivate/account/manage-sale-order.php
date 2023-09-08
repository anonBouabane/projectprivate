<?php include('./constant/layout/head.php');?>
<?php include('./constant/layout/header.php');?>

<?php include('./constant/layout/sidebar.php');?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->   
<!-- <link rel="stylesheet" href="custom/js/order.js"> -->




 
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
                                    <form class="row" method="POST" action="php_action/add-sale.php" id="editOrderForm">

        <?php $orderId = $_GET['id'];
        

        $sql = "  SELECT    po_id,po_date,pod_code FROM tbl_purchase_order WHERE po_id = {$orderId} ";
 
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
              <th style="width:40%;">Item Name</th> 
              <th style="width:10%;">Quantity</th>   
			  <th style="width:10%;">Item Total Litre</th>
			  <th style="width:10%;">Sector Type</th>
			  <th style="width:10%;">Remain</th>
			  <th style="width:10%;">Sell</th> 
            </tr>
          </thead>
          <tbody>
            <?php

            $orderItemSql = " 
			SELECT  a.itod_id,a.item_id as item_id,item_name,quantity,litre,sector_type,
			(quantity-(case when item_used is null then 0 else item_used end)) as remain
			FROM tbl_item_order a
			left join tbl_item_list b on a.item_id =b.item_id
            left join sumary_sale_item c on a.itod_id = c.itod_id and a.po_id =c.po_id
            where a.po_id = {$orderId}
            
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
				  <input type="hidden" name="itodid[]" id="itodid<?php echo $x; ?>" autocomplete="off" class="form-control" value="<?php echo $orderItemData['itod_id']; ?>" />
				  <input type="hidden" name="itemid[]" id="itemid<?php echo $x; ?>" autocomplete="off" class="form-control" value="<?php echo $orderItemData['item_id']; ?>" />
			 
				   <label><?php echo $orderItemData['item_name']; ?></label>  
                  </div>
                </td>
              
				
				
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['quantity']; ?>
				</div>
                </td>
		 
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['litre']; ?>
				</div>
                </td>
				
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['sector_type']; ?>
				</div>
                </td>
				
				<td>
				<div class="form-group">
                   <?php echo $orderItemData['remain']; ?>
				</div>
                </td>
				
				<td>
				<div class="form-group"> 
				  <input type="number" name="itemused[]" id="itemused<?php echo $x; ?>" 
				  <?php 
				  if($orderItemData['remain'] == 0){
					 echo  "disabled"; 
				  }
				   ?> 
				  
				  autocomplete="off" class="form-control" value="" />
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
        
          <button type="submit" id="editOrderBtn" data-loading-text="Loading..." class="btn btn-success"><i class="glyphicon glyphicon-ok-sign"></i>Add Sale</button>
            
          </div>
      </form>
	  
	  <div class="table-responsive m-t-40">
                                    <table id="myTable" class="table table-bordered table-striped">
                                        <thead>
                                            <tr>
                                              <th class="text-center">#</th>
												<th>Date Sale</th>
												<th>Item Name</th>
												<th>Sale Values</th> 
                                                <th>Action</th>
                                            </tr>
                                       </thead>
                                       <tbody>
                                        <?php
										
										$sqlsale = " select slid,date_registed,item_name,item_used
													from tbl_sale_list a
													left join tbl_item_list b on a.item_id = b.item_id
													WHERE po_id = {$orderId} order by slid desc";
 
										$resultsql = $connect->query($sqlsale);
										$data = $resultsql->fetch_row();


										foreach ($resultsql as $rowsale) {

										 
										?>
                                        <tr>
                                            <td class="text-center"><?php echo $rowsale['slid'] ?></td> 
                                            <td><?php echo $rowsale['date_registed'] ?></td>
                                            <td><?php echo $rowsale['item_name'] ?></td>
                                            <td><?php echo $rowsale['item_used'] ?></td>
                                             
                                               
                                             
                                            <td>
            
                                                <a href="edit-sale-manage.php?id=<?php echo $rowsale['slid']?>"><button type="button" class="btn btn-xs btn-primary" ><i class="fa fa-pencil"></i></button></a>
                                              

             
                                                <a href="php_action/removeSaleList.php?id=<?php echo $rowsale['slid']?>" ><button type="button" class="btn btn-xs btn-danger" onclick="return confirm('Are you sure to delete this record?')"><i class="fa fa-trash"></i></button></a>

                                             
                                                
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
                        </div>
                    </div>
                  
                </div>
                
               


 
<?php include('./constant/layout/footer.php');?>
 
