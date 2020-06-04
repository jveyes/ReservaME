<?php
if(!empty($cart))
{ 
	?>
	<li class="list-group-item pjAsAsideService">
		<h3 class="pjAsAsideTitle"><?php __('front_selected_services'); ?></h3><!-- /.pjAsAsideTitle -->
	</li><!-- /.list-group-item pjAsAsideService -->
	<?php
	foreach ($cart as $key => $value)
	{
		list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
	
		$fixed_start_ts = $start_ts + $cart_arr[$service_id]['before'] * 60;
		$fixed_end_ts = $end_ts - $cart_arr[$service_id]['after'] * 60;
		?>
		<li class="list-group-item pjAsAsideService">
			<dl>
				<dt class="pjAsServiceTitle"><?php echo pjSanitize::html($cart_arr[$service_id]['name']);?></dt>
				
				<dd>
					<p><?php echo date($tpl['option_arr']['o_date_format'], strtotime($date));?></p>
					<p><?php echo date($tpl['option_arr']['o_time_format'], $fixed_start_ts);?> - <?php echo date($tpl['option_arr']['o_time_format'], $fixed_end_ts);?></p>
				</dd>
			</dl>
		
			<button class="pjAsBtn pjAsBtnRemove pjAsBtnRemoveFromCart" data-start_ts="<?php echo $start_ts; ?>" data-end_ts="<?php echo $end_ts; ?>" data-date="<?php echo $date; ?>" data-service_id="<?php echo $service_id; ?>" data-employee_id="<?php echo $employee_id; ?>">
				<span class="glyphicon glyphicon-remove"></span>
			</button>
		</li><!-- /.list-group-item pjAsAsideService -->
		<?php
	} 
	?>
	<li class="list-group-item pjAsAsideService">
		<a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsBtnGotoCheckout" data-start_ts="<?php echo $start_ts; ?>" data-end_ts="<?php echo $end_ts; ?>" data-date="<?php echo $date; ?>" data-service_id="<?php echo $service_id; ?>" data-employee_id="<?php echo $employee_id; ?>"><?php __('front_checkout');?></a>
	</li><!-- /.list-group-item pjAsAsideService -->
	<?php
} 
?>