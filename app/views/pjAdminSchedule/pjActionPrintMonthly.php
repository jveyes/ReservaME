<?php
$date_ts = strtotime($tpl['date']);
$months = __('months', true);
$days = __('days', true);
$week_start = $tpl['option_arr']['o_week_start'];
$row_arr = array_chunk($tpl['d_arr'], 7);
?>
<h2 style="text-align: center;"><?php echo $months[date('n', $date_ts)];?>, <?php echo date('Y', $date_ts);?></h2>
<table>
	<thead>
        <tr>
        	<th<?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? NULL : ' style="display:none;"'; ?>>#</th>
            <th><strong><?php echo $days[$week_start%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 1)%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 2)%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 3)%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 4)%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 5)%7];?></strong></th>
            <th><strong><?php echo $days[($week_start + 6)%7];?></strong></th>
        </tr>
    </thead>
    <tbody>
        <?php
        foreach($row_arr as $k => $row)
        {                               
            ?>
            <tr>
            	<td<?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? NULL : ' style="display:none;"'; ?>><?php echo date('W', strtotime($row[0]));?></td>
	            <?php
				foreach($row as $date)
            	{
            	    $date_ts = strtotime($date);
            	    ?>
            	    <td>
            	    	<strong class="appointment-management-date"><?php echo date('d', $date_ts);?></strong>
            	    	<?php
            	    	include dirname(__FILE__) . '/elements/print_slots.php';
            	    	?>
            	    </td>
            	    <?php
            	}
            	?>
            </tr>
            <?php
        }
        ?>
    </tbody>
</table>