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
							<form class="form-horizontal" method="POST" id="submitBrandForm" action="php_action/add-quota-detail.php" enctype="multipart/form-data">



								<div class="form-group">
									<div class="row">
										<label class="col-sm-3 control-label">ຊື່ໂຕຄ້າ</label>
										<div class="col-sm-9">
											<input type="text" class="form-control" id="quota_name" placeholder="ຊື່ໂຕຄ້າ" name="quota_name" required="" />
										</div>
									</div>
								</div>

								<div class="form-group">
									<div class="row">
										<label class="col-sm-3 control-label">ມູນຄ່າໂຄຕ້າ</label>
										<div class="col-sm-9">
											<input type="number" class="form-control" id="quota_price" placeholder="ມູນຄ່າໂຄຕ້າ" name="quota_price" required="" />
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