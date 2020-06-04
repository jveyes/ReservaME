<?php
if(!empty($tpl['service_arr']))
{
    if (isset($tpl['employee_arr']) && !empty($tpl['employee_arr']))
    {
    	$wideCell = NULL;
    	if (in_array($tpl['option_arr']['o_time_format'], array('h:i a', 'h:i A', 'g:i a', 'g:i A')))
    	{
    		$wideCell = " asSlotBlockWide";
    	}
    	$step = $tpl['option_arr']['o_step'] * 60;
    	$service_length = $tpl['service_arr']['length'] * 60;
    	$service_total = $tpl['service_arr']['total'] * 60;
    	$service_before = $tpl['service_arr']['before'] * 60;
    	$service_after = $tpl['service_arr']['after'] * 60;
    	foreach ($tpl['employee_arr'] as $employee)
    	{
    		# Fix for 24h support
    		$offset = $employee['t_arr']['end_ts'] <= $employee['t_arr']['start_ts'] ? 86400 : 0;
    		?>
    		<div class="asElement service-table">
    			<h3 class="asEmployeeName"><?php echo pjSanitize::html($employee['name']); ?></h3>
    	                    
    			<div class="row">
    				<div class="col-sm-3">
    					<p>
    						<?php
    						if (!empty($employee['avatar']) && is_file($employee['avatar']))
    						{
    							$src = PJ_INSTALL_URL . $employee['avatar'];
    						} else {
    							$src = PJ_INSTALL_URL . PJ_IMG_PATH . 'frontend/as-nopic-gray.gif';
    						}
    						?>
    						<img class="img-responsive" src="<?php echo $src; ?>" alt="<?php echo pjSanitize::html($employee['name']); ?>" />
    					</p>
    				</div>
    	                    
    				<div class="col-sm-9">
    					<?php
    					if (!$employee['t_arr'])
    					{
    						?><div class="asEmployeeNA"><?php __('booking_na'); ?></div><?php
    					} else {
    						for ($i = $employee['t_arr']['start_ts']; $i <= $employee['t_arr']['end_ts'] + $offset - $step; $i += $step)
    						{
    							$is_free = true;
    							$class = "label-primary asSlotAvailable";
    							foreach ($employee['bs_arr'] as $item)
    							{
    								if ($i >= $item['start_ts'] && $i < $item['start_ts'] + $item['total'] * 60)
    								{
    									$is_free = false;
    									$class = "label-danger asSlotBooked";
    									break;
    								}
    							}
    							
    							if ($i < time())
    							{
    								$is_free = false;
    								$class = "label-secondary asSlotUnavailable";
    							}
    							
    							if ($i >= $employee['t_arr']['lunch_start_ts'] && $i < $employee['t_arr']['lunch_end_ts'])
    							{
    								$is_free = false;
    								$class = "label-secondary asSlotUnavailable";
    							}
    							
    							# Before lunch break
    							if ($i + $service_total - $service_before > $employee['t_arr']['lunch_start_ts'] && $i < $employee['t_arr']['lunch_end_ts'])
    							{
    								$is_free = false;
    								$class = "label-secondary asSlotUnavailable";
    							}
    									
    							if ($is_free)
    							{
    								foreach ($employee['bs_arr'] as $item)
    								{
    									if ($i + $service_total - $service_before > $item['start_ts'] && $i <= $item['start_ts'])
    									{
    										// before booking
    										$class = "label-secondary asSlotUnavailable";
    										break;
    									}
    								}
    								if ($i + $service_total - $service_before > $employee['t_arr']['end_ts'] + $offset)
    								{
    									// end of working day
    									$class = "label-secondary asSlotUnavailable";
    								}
    							}
    							?><a href="#" class="label <?php echo $class; ?><?php echo $wideCell; ?>" 
    								data-start="<?php echo date($tpl['option_arr']['o_time_format'], $i - $service_before); ?>"
    								data-end="<?php echo date($tpl['option_arr']['o_time_format'], $i + $service_length + $service_after); ?>" 
    								data-start_ts="<?php echo $i - $service_before; ?>" 
    								data-end_ts="<?php echo $i + $service_total - $service_before; ?>" 
    								data-service_id="<?php echo $employee['service_id']; ?>" 
    								data-employee_id="<?php echo $employee['employee_id']; ?>"><?php echo date($tpl['option_arr']['o_time_format'], $i); ?></a><?php
    						}
    					}
    					?>
    				</div>
    			</div>
    		</div>
    		<?php
    	}
    } else {
    	$bodies = __('error_bodies', true);
    	?>
    	<div class="service-table">
    		<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php echo @$bodies['ABK17']; ?></p>
    	</div>
    	<?php 
    }
}else{
    $bodies = __('error_bodies', true);
    ?>
	<div class="service-table">
		<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php echo @$bodies['ABK14']; ?></p>
	</div>
	<?php 
}
?>