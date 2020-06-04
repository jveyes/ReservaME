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
	        	    <div style="background-color: #5ac5b6;border-color: #5ac5b6;">
	                    <?php echo date($tpl['option_arr']['o_time_format'], strtotime($period['start_time']));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($period['end_time']));?>
	                </div>
	        	    <?php
            	}
            }
	    }
    }else if(isset($tpl['avail_arr'][$date]['is_dayoff']) && $tpl['avail_arr'][$date]['is_dayoff'] == true){
    }else{
        foreach($tpl['avail_arr'][$date] as $items)
        {
        	if (isset($items['start_time']) && !isset($items[0])) 
            {
            	if (isset($items['start_time']) && ($date > date('Y-m-d') || ($date == date('Y-m-d') && $items['start_time'] >= date('H:i'))))
            	{
	                ?>
	    	        <div style="background-color: #5ac5b6;border-color: #5ac5b6;">
	                    <?php echo date($tpl['option_arr']['o_time_format'], strtotime($items['start_time']));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($items['end_time']));?>
	                </div>
	    	        <?php
            	}
            }else {
            	foreach($items as $item) {
	                if(isset($tpl['booking_arr'][$date][$item]))
	                {
	                    $booking = $tpl['booking_arr'][$date][$item];
	                    $status = 'background-color: #fbc994;border-color: #fbc994;';
	                    $tooltip_text = '';
	                    $duration_text = '';
	                    if($booking['booking_status'] == 'confirmed')
	                    {
	                        $status = 'background-color: #ed5565;border-color: #ed5565;';
							$duration_text = $booking['length'] . ' ' . __('minutes_lowercase', true, true);
							$tooltip_text = ' data-toggle="tooltip" data-html="true" data-placement="bottom" title="'.$booking['service_name'].' <br> '. __('duration', true, true) .': '.$duration_text.' <br> ' . __('price', true, true) . ': '.pjCurrency::formatPrice($booking['price']).'"';
	                    }
	                    ?>
	           	    	<div style="<?php echo $status;?>">
	                        <?php echo date($tpl['option_arr']['o_time_format'], $booking['start_ts']);?> - <?php echo date($tpl['option_arr']['o_time_format'], $booking['end_ts']);?>
	                        <br/>
	                        <?php echo pjSanitize::html($booking['c_name']);?>
	                    </div>
	                    <?php
	                }
            	}
            	
            }
        }
    }
}
?>