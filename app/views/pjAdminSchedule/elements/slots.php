<?php
if(isset($tpl['avail_arr'][$date]))
{
    if(isset($tpl['avail_arr'][$date]['avail']) && $tpl['avail_arr'][$date]['avail'] == true)
    {
        if(!isset($tpl['t_arr'][$date]['is_dayoff'])){
            if(isset($tpl['t_arr'][$date]) && is_array($tpl['t_arr'][$date]))
            {
            	$period = $tpl['t_arr'][$date];
				if (isset($period['start_time']) && ($date > date('Y-m-d') || ($date == date('Y-m-d') && $period['start_time'] >= date('H:i'))))
				{
					?>
        	        <div class="car-reservation-outer tooltip-demo">
                        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" class="car-reservation">
                            <div class="car-reservation-inner bg-confirmed">
                                <strong><?php echo date($tpl['option_arr']['o_time_format'], strtotime($period['start_time']));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($period['end_time']));?></strong>
                            </div>
                        </a>
                    </div>
        	        <?php
    	        }
            }
	    }
    }else if(isset($tpl['avail_arr'][$date]['is_dayoff']) && $tpl['avail_arr'][$date]['is_dayoff'] == true){
    }else{
        foreach($tpl['avail_arr'][$date] as $items)
        {
            if (isset($items['start_time']) && !isset($items[0])) {
	           	if (isset($items['start_time']) && ($date > date('Y-m-d') || ($date == date('Y-m-d') && $items['start_time'] >= date('H:i'))))
	           	{
					?>
	    	       	<div class="car-reservation-outer tooltip-demo">
	                    <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" class="car-reservation">
	                        <div class="car-reservation-inner bg-confirmed">
	                            <strong><?php echo date($tpl['option_arr']['o_time_format'], strtotime($items['start_time']));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($items['end_time']));?></strong>
	                        </div>
	                    </a>
	                </div>
	    	        <?php
            	}
            }else {
            	foreach($items as $item) {
	                if(isset($tpl['booking_arr'][$date][$item]))
	                {
	                    $booking = $tpl['booking_arr'][$date][$item];
	                    $status = 'bg-pending';
	                    $tooltip_text = '';
	                    $duration_text = '';
	                    if(in_array($booking['booking_status'], array('confirmed')))
	                    {
	                        $status = 'bg-danger';
	                    }
	                    if(in_array($booking['booking_status'], array('confirmed', 'pending')))
	                    {
	                        $duration_text = $booking['length'] . ' ' . __('minutes_lowercase', true, true);
	                        $tooltip_text = ' data-toggle="tooltip" data-html="true" data-placement="bottom" title="'.$booking['service_name'].' - '.  $duration_text.' - ' . pjCurrency::formatPrice($booking['price']).'"';
	                    }
	                    ?>
	           	    	<div class="car-reservation-outer tooltip-demo">
	                        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id=<?php echo $booking['booking_id'];?>" class="car-reservation"<?php echo $tooltip_text;?>>
	                            <div class="car-reservation-inner <?php echo $status;?>">
	                                <p><strong><?php echo date($tpl['option_arr']['o_time_format'], $booking['start_ts']);?> - <?php echo date($tpl['option_arr']['o_time_format'], $booking['end_ts']);?></strong></p>
	                                
	                                <?php echo pjSanitize::html($booking['c_name']);?>
	                            </div>
	                        </a>
							<?php
							if ($booking['start_ts'] >= time()) {
								?>
		                        <div class="clearfix">
		                            <a href="#" class="text-<?php echo $booking['booking_status'] == 'confirmed' ? 'danger' : 'pending'; ?> pull-left btn-reminder" data-booking_id="<?php echo $booking['booking_id'];?>"><i class="fa fa-bell"></i> <small><?php __('send_reminder', false, true); ?></small></a>
		                            <a href="#" class="text-<?php echo $booking['booking_status'] == 'confirmed' ? 'danger' : 'pending'; ?> pull-right btn-delete" data-id="<?php echo $booking['service_id'];?>" data-booking_id="<?php echo $booking['booking_id'];?>"><i class="fa fa-trash"></i> <small><?php __('btnCancel', false, true); ?></small></a>
		                        </div><!-- /.clearfix -->
		                        <?php 
							}
							?>
	                    </div>
	                    <?php
	                }
	            }
            }
        }
    }
}
?>