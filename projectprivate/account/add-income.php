<?php include('./constant/layout/head.php');?>
<?php include('./constant/layout/header.php');?>

<?php include('./constant/layout/sidebar.php');?>
 
 
        <div class="page-wrapper font">
            
            <div class="row page-titles">
                <div class="col-md-5 align-self-center">
                    <h3 class="text-primary font">ລາຍຮັບ</h3> </div>
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
                                    <form class="form-horizontal" method="POST"  id="submitBrandForm" action="php_action/income.php" enctype="multipart/form-data">

										<div class="form-group">
										
										<div class="row">
                                                <label class="col-sm-3 control-label">ປະເພດລາຍຮັບ</label>
                                                <div class="col-sm-9">
                                                  <select class="form-control" name="incometype" id="incometype" >
													<option value="">~~SELECT~~</option>
													<option value="ເງິນເດືອນ">ເງິນເດືອນ</option>
													<option value="ເງິນໂປແກຣມ">ເງິນໂປແກຣມ</option> 
                                                    <option value="ຍອດເຫຼືອເກົ່າ">ຍອດເຫຼືອເກົ່າ</option> 
												  </select>
                                                </div>
                                            </div>

										  
										</div>
                                       
										<div class="form-group">
                                            <div class="row">
                                                <label class="col-sm-3 control-label">ຂາຍໄດ້</label>
                                                <div class="col-sm-9">
                                                  <input type="number"  class="form-control"id="income" placeholder="ຂາຍໄດ້" name="income"  required="" />
                                                </div>
                                            </div>
                                        </div>
										
										<div class="form-group">
                                            <div class="row">
                                                <label class="col-sm-3 control-label">ຈຳນວນຂາຍ(ກິໂລ)</label>
                                                <div class="col-sm-9">
                                                  <input type="text"  class="form-control"id="sale_unit" placeholder="ຈຳນວນຂາຍ(ກິໂລ)" name="sale_unit"  required="" />
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
                
               


 
<?php include('./constant/layout/footer.php');?>
<!--  Author Name: Mayuri K. 
 for any PHP, Codeignitor, Laravel OR Python work contact me at mayuri.infospace@gmail.com  
 Visit website : www.mayurik.com -->


