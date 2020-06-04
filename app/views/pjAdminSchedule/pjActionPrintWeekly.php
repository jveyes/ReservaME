<?php
$months = __('months', true);
$first = reset($tpl['d_arr']);
$last = end($tpl['d_arr']);
$first_date_ts = strtotime($first);
$last_date_ts = strtotime($last);
$range_text = $months[date('n', $first_date_ts)] . ' ' . date('j', $first_date_ts);
$range_text .= ' - ' . $months[date('n', $last_date_ts)] . ' ' . date('j', $last_date_ts);
?>
<h2 style="text-align: center;"><?php echo $range_text;?></h2>
<table>
	<thead>
        <tr>
        	<th<?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? NULL : ' style="display:none;"'; ?>>#</th>
           	<?php
			$days = __('days', true);
           	foreach($tpl['d_arr'] as $date)
           	{
               	?>
                <th><strong><?php echo $days[date('w', strtotime($date))];?></strong></th>
                <?php
           	}
            ?>
        </tr>
    </thead>
    <tbody>
        <tr>
        	<td<?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? NULL : ' style="display:none;"'; ?>><?php echo date('W', $first_date_ts);?></td>
	        <?php
           	foreach($tpl['d_arr'] as $date)
           	{
           	    ?>
           	    <td>
           	    	<strong><?php echo date('d', strtotime($date));?></strong>
           	    	<?php
        	    	include dirname(__FILE__) . '/elements/print_slots.php';
        	    	?>
           	    </td>
           	    <?php
           	}
           	?>
        </tr>
    </tbody>
</table>