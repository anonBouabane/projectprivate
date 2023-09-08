<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>RemainVolumeReport</title>

		<style>
			.invoice-box {
				max-width: 800px;
				margin: auto;
				padding: 30px;
				border: 1px solid #eee;
				box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
				font-size: 16px;
				line-height: 24px;
				font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
				color: #555;
			}

			.invoice-box table {
				width: 100%;
				line-height: inherit;
				text-align: left;
				    border-collapse: collapse;
			}

			.invoice-box table td {
				padding: 5px;
				vertical-align: top;
			}

			.invoice-box table tr td:nth-child(2) {
				text-align: right;
			}

			.invoice-box table tr.top table td {
				padding-bottom: 20px;
			}

			.invoice-box table tr.top table td.title {
				font-size: 45px;
				line-height: 45px;
				color: #333;
			}

			.invoice-box table tr.information table td {
				padding-bottom: 40px;
			}

			.invoice-box table tr.heading td {
				background: #eee;
				border-bottom: 1px solid #ddd;
				font-weight: bold;
			}

			.invoice-box table tr.details td {
				padding-bottom: 20px;
			}

			.invoice-box table tr.item td {
				/*border-bottom: 1px solid #eee;*/
			}

			.invoice-box table tr.item.last td {
				border-bottom: none;
			}

			.invoice-box table tr.total td:nth-child(2) {
				/*border-top: 2px solid #eee;*/
				font-weight: bold;
			}

			@media only screen and (max-width: 600px) {
				.invoice-box table tr.top table td {
					width: 100%;
					display: block;
					text-align: center;
				}

				.invoice-box table tr.information table td {
					width: 100%;
					display: block;
					text-align: center;
				}
			}

			/** RTL **/
			.invoice-box.rtl {
				direction: rtl;
				font-family: Tahoma, 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
			}

			.invoice-box.rtl table {
				text-align: right;
			}

			.invoice-box.rtl table tr td:nth-child(2) {
				text-align: left;
			}
		</style>
	</head>
<?php
    $startdate = date('Y-m-d', strtotime($_POST['startdate']));
	$enddate = date('Y-m-d', strtotime($_POST['enddate']));
             ?>
	<body>
		<div class="invoice-box">
			<table cellpadding="0" cellspacing="0">
				<tr class="top">
					<td colspan="6">
						 
									<img src="./assets/uploadImage/Logo/shell-logo.png" style="width: 100%; max-width: 300px" />
								 
					</td>
					<td colspan="6">
								<h2 style="margin:0 0 11px;"><b>Remain VOLUME Report</b></h2> <b><?php echo"Date Report" ?></b><br />
									  <?php $dates = date("d-m-y") ;echo "$dates" ?><br />
								</td>
				</tr> 
				<tr class="heading">
					<td>Order Date</td>
					<td>PO No.</td>
					<td>Order Volume</td>
					<td>B2C</td>
					<td>B2B</td>
					<td>BIKE</td>
					<td>CAR</td>
					<td>Premium</td>
					<td>Amoun(USD)</td>

					
				</tr>
<?php 

 
 //echo "$startdate-$enddate";

							
						 
				
				 include('php_action/db_connect.php');
		 
 
								
								$listsql = "call rptremain('$startdate','$enddate');";
                      $listdata = $connect->query($listsql);

                      while($rowlist = $listdata->fetch_array()) { 
					  
						?>
						
						<tr> 
							<td><?php echo $rowlist['po_date'] ?></td>
							<td><?php echo $rowlist['pod_code'] ?></td>
							<td><?php echo number_format($rowlist['total_litre']) ?></td>
							<td><?php echo number_format($rowlist['b2b_litre']) ?></td>
							<td><?php echo number_format($rowlist['b2c_litre']) ?></td>
							<td><?php echo number_format($rowlist['bike_litre']) ?></td>
							<td><?php echo number_format($rowlist['car_litre']) ?></td>
							<td><?php echo number_format($rowlist['premium_litre']) ?></td>
							<td><?php echo number_format($rowlist['total_price']) ?></td>
						</tr>
						
						<?php
                      }
					  ?>
					  </table>
			<table cellpadding="0" cellspacing="0">
					  <?php
					 
					
					  include('php_action/db_connect.php');
							 
							  
					$footsql = "call rptremainfooter('$startdate','$enddate'); ";
                      $footdata = $connect->query($footsql);

                      while($rowfoot = $footdata->fetch_array()) { 
					  
					   
					  
					 
					  
					  ?>
  
				
				<tr>
					<td rowspan="4" colspan="5" style=" text-align: center;"> Check By (Signature) </td>
					<td colspan="1"  style=""></td>
					<td colspan="1"  style="border: 1px solid;text-align: left;">TOTAL rows: <?php echo $rowfoot['pod_code'];?></td> 
					<td  colspan="1" style="border: 1px solid;text-align: left;">  Volume: <?php echo number_format($rowfoot['total_litre']);?></td>
				</tr>
				<tr>
					 <td colspan="1"  style=""></td>
					<td colspan="1"  style="border: 1px solid;text-align: left;">  B2B: <?php echo number_format($rowfoot['b2b_litre']);?></td>
					<td colspan="1" style="border: 1px solid;text-align: left;">  B2C: <?php echo number_format($rowfoot['b2c_litre']);?></td>
				</tr>
				<tr>
					 <td colspan="1"  style=""></td>
					<td colspan="1" style="border: 1px solid;text-align: left;">  Bike: <?php echo number_format($rowfoot['bike_litre']);?></td>
					<td colspan="1" style="border: 1px solid;text-align: left;">  Car: <?php echo number_format($rowfoot['car_litre']);?></td>
				</tr>
				<tr>
					<td colspan="1" style=""></td>
					<td colspan="1" style="border: 1px solid;text-align: left;">  Premium: <?php echo number_format($rowfoot['premium_litre']);?></td>
					<td colspan="1" style="border: 1px solid;text-align: left;"> (USD): <?php echo number_format($rowfoot['total_price']);?></td>
				</tr>
				
				
<?php  
 }
?>

			 
				 
			</table>
		
		</div>
	</body>
 
</html>