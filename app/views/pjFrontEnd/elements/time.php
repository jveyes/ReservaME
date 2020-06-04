<?php
$CART = $controller->cart->getAll();
$acceptBookings = (int) $tpl['option_arr']['o_accept_bookings'] === 1;

$employee = $tpl['employee'];

$step = $tpl['option_arr']['o_step'] * 60;
$service_total = $tpl['service']['total'] * 60;
$service_length = $tpl['service']['length'] * 60;
$service_before = $tpl['service']['before'] * 60;

$hour_earlier = $tpl['option_arr']['o_booking_earlier'] * 60 * 60;

$isAvailable = true;
$rows = array();
$cells = array();

if(!isset($in_cart))
{
	$in_cart = false;
}
if(!isset($cell))
{
	$cell = array();
}
if (!$employee['t_arr'])
{
	$isAvailable = false;
}else{
	# Fix for 24h support
	$offset = $employee['t_arr']['end_ts'] <= $employee['t_arr']['start_ts'] ? 86400 : 0;

	for ($i = $employee['t_arr']['start_ts']; $i <= $employee['t_arr']['end_ts'] + $offset - $step; $i += $step)
	{
		$is_free = true;
		$class = "pjAsTimeAvailable";
		foreach ($employee['bs_arr'] as $item)
		{
			if ($i >= $item['start_ts'] && $i < $item['start_ts'] + $item['total'] * 60)
			{
				$is_free = false;
				$class = "pjAsTimeBooked";
				break;
			}
		}
		foreach($CART as $key => $slot)
		{
			list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
			$fixed_start_ts = $start_ts + $cart_arr[$service_id]['before'] * 60;
			$fixed_end_ts = $end_ts - $cart_arr[$service_id]['after'] * 60;
			if ($i >= $fixed_start_ts && $i < $fixed_end_ts && $tpl['service']['id'] != $service_id)
			{
				$is_free = false;
				$class = "pjAsTimeBooked";
				break;
			}
		}
		if ($i < time() + $hour_earlier)
		{
			$is_free = false;
			$class = "pjAsTimeUnavailable";
		}

		if ($i >= $employee['t_arr']['lunch_start_ts'] && $i < $employee['t_arr']['lunch_end_ts'])
		{
			$is_free = false;
			$class = "pjAsTimeUnavailable";
		}

		# Before lunch break
		if ($i + $service_total - $service_before > $employee['t_arr']['lunch_start_ts'] && $i < $employee['t_arr']['lunch_end_ts'])
		{
			$is_free = false;
			$class = "pjAsTimeUnavailable";
		}
		if ($is_free)
		{
			foreach ($employee['bs_arr'] as $item)
			{
				if ($i + $service_total - $service_before > $item['start_ts'] && $i <= $item['start_ts'])
				{
					// before booking
					$class = "pjAsTimeUnavailable";
					break;
				}
			}
			if ($i + $service_total - $service_before > $employee['t_arr']['end_ts'] + $offset)
			{
				// end of working day
				$class = "pjAsTimeUnavailable";
			}

			$date = $tpl['date'];
			$key = sprintf("%u|%s|%u|%s|%s|%u", $controller->_get->toInt('cid'), $date, $tpl['service']['id'], $i - $service_before, $i + $service_total - $service_before, $employee['id']);
			if (array_key_exists($key, $CART))
			{
				$class = "pjAsTimeCart";
				$in_cart = true;
				$cell = array(
								'data_end' => date($tpl['option_arr']['o_time_format'], $i + $service_length),
								'data_start_ts' => $i - $service_before,
								'data_end_ts' => $i + $service_total - $service_before,
								'time' => date($tpl['option_arr']['o_time_format'], $i)
							);
				$key_in_cart = $key;
			}
		}
		$cells[] = array(
			'data-end' => date($tpl['option_arr']['o_time_format'], $i + $service_length),
			'data-start_ts' => $i - $service_before,
			'data-end_ts' => $i + $service_total - $service_before,
			'data-service_id' => $tpl['service']['id'],
			'data-employee_id' => $employee['id'],
			'class' => $class,
			'time' => date($tpl['option_arr']['o_time_format'], $i)
		);
		if(count($cells) == 5)
		{
			$rows[] = $cells;
			$cells = array();
		}
	}
	$rows[] = $cells;
}
if($isAvailable == true)
{
	$time_table .= '<table class="table" border="0" cellpadding="0" cellspacing="0" width="100%">';
	$time_table .= '<tbody>';
	foreach($rows as $r)
	{
		$time_table .= '<tr>';
		foreach($r as $col)
		{
			$time_table .= '<td class="text-uppercase pjAsTime ' . ($col['class'] == ' pjAsTimeCart' ? 'pjAsTimeAvailable pjAsTimeSelected' : $col['class']) . '">';
			$time_table .= '<a href="#" class="asSlotBlock ' . ($col['class'] == "pjAsTimeAvailable" ? ' asSlotAvailable' : null).'" data-end="'.$col['data-end'].'" data-start_ts="'.$col['data-start_ts'].'" data-end_ts="'.$col['data-end_ts'].'" data-employee_id="'.$col['data-employee_id'].'" data-service_id="'.$col['data-service_id'].'">'.$col['time'].'</a>';
			$time_table .= '</td>';
		}
		$time_table .= '</tr>';
	}
	$time_table .= '</tbody>';
	$time_table .= '</table>';
}else{
	$time_table .= '<p class="form-control-static">'.__('front_date_off', true).'</p>';
}
?>