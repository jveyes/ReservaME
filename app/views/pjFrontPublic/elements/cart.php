<ul class="list-group pjAsChosenServices">
	<li class="list-group-item alert pjAsChosenService">
		<h3 class="text-uppercase pjAsSectionTitle"><?php __('front_selected_services');?></h3><!-- /.text-uppercase pjAsSectionTitle -->

		<div class="row">
			<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
				<h4 class="text-capitalize pjAsServiceTitle"><?php __('front_service_employee');?></h4><!-- /.pjAsServiceTitle -->
			</div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->

			<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
				<div class="row">
					<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
						<h4 class="pjAsServiceTitle"><?php __('front_date_time');?></h4><!-- /.pjAsServiceTitle -->
					</div><!-- /.col-lg-8 col-md-8 col-sm-8 col-xs-8 -->

					<div class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
						<h4 class="text-capitalize pjAsServiceTitle"><?php __('single_price');?></h4><!-- /.pjAsServiceTitle -->
					</div><!-- /.col-lg-4 col-md-4 col-sm-4 col-xs-4 -->
				</div><!-- /.row -->
			</div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->
		</div><!-- /.row -->
	</li><!-- /.list-group-item alert alert-dismissible pjAsChosenService -->
	<?php
	foreach ($cart as $key => $value)
	{
		list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
		
		$fixed_start_ts = $start_ts + $cart_arr[$service_id]['before'] * 60;
		$fixed_end_ts = $end_ts - $cart_arr[$service_id]['after'] * 60;
		?>
		<li class="list-group-item alert alert-dismissible pjAsChosenService">
			<div class="row">
				<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
					<p>
						<strong><?php echo pjSanitize::html($cart_arr[$service_id]['name']);?></strong>
					</p>
					<p>
						<?php
						$slug = NULL;
						$iso_date = $date;
						if ((int) $tpl['option_arr']['o_seo_url'] === 1)
						{
							list($year, $month, $day) = explode("-", $iso_date);
							$slug = sprintf("%s/%s/%s/%s/%s-%u/%s-%u.html", 'Employee', $year, $month, $day, $controller->friendlyURL($cart_arr[$service_id]['employee_arr'][$employee_id]['name']), $employee_id, $controller->friendlyURL($cart_arr[$service_id]['name']), $service_id);
						}
						?><a href="#" class="text-capitalize pjAsEmployeeAppointment" data-iso="<?php echo $iso_date;?>" data-eid="<?php echo $employee_id; ?>" data-sid="<?php echo $service_id; ?>" data-slug="<?php echo $slug;?>"><?php echo pjSanitize::html($cart_arr[$service_id]['employee_arr'][$employee_id]['name']);?></a>
					</p>
				</div><!-- /.col-lg-7 col-md-7 col-sm-7 col-xs-12 -->

				<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
					<div class="row">
						<div class="col-lg-7 col-md-7 col-sm-7 col-xs-7">
							<p class="text-capitalize"><?php echo date($tpl['option_arr']['o_date_format'], strtotime($date));?></p><!-- /.text-capitalize -->

							<p class="text-uppercase"><?php echo date($tpl['option_arr']['o_time_format'], $fixed_start_ts);?> - <?php echo date($tpl['option_arr']['o_time_format'], $fixed_end_ts);?></p><!-- /.text-uppercase -->
						</div><!-- /.col-lg-8 col-md-8 col-sm-7 col-xs-7 -->

						<div class="col-lg-5 col-md-5 col-sm-5 col-xs-5 pjAsChosenServiceActions">
							<p>
								<strong><?php echo "$ "; echo pjCurrency::formatPrice($cart_arr[$service_id]['price'])?></strong>
							</p>
							<button type="button" class="close pjAsBtnRemove asSelectorRemoveFromCart" data-dismiss="alert" aria-label="Close" data-start_ts="<?php echo $start_ts; ?>" data-end_ts="<?php echo $end_ts; ?>" data-date="<?php echo $date; ?>" data-service_id="<?php echo $service_id; ?>" data-employee_id="<?php echo $employee_id; ?>"><span aria-hidden="true">×</span></button>
						</div><!-- /.col-lg-4 col-md-4 col-sm-5 col-xs-5 pjAsChosenServiceActions -->
					</div><!-- /.row -->
				</div><!-- /.col-lg-5 col-md-5 col-sm-5 col-xs-12 -->
			</div><!-- /.row -->
		</li><!-- /.list-group-item alert alert-dismissible pjAsChosenService -->
		<?php
	}
	?>
</ul><!-- /.list-group pjAsChosenServices -->