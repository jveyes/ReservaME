<select name="value-<?php echo $option['type']; ?>-<?php echo $option['key']; ?>" class="form-control">
    <?php
    $default = explode("::", $option['value']);
    $enum = explode("|", $default[0]);
    
    $enumLabels = array();
    if (!empty($option['label']) && strpos($option['label'], "|") !== false)
    {
        $enumLabels = explode("|", $option['label']);
    }
    
    $enum_arr = array();
    if(in_array($option['key'], array('o_booking_status', 'o_payment_status')) || in_array($option['tab_id'], array(1,3)))
    {
    	$enum_arr = __('enum_arr', true);
    }
    foreach ($enum as $k => $el)
    {
    	if ($default[1] == $el)
    	{
    		?><option value="<?php echo $default[0].'::'.$el; ?>" selected="selected"><?php echo isset($enum_arr[$el]) ? $enum_arr[$el] : (array_key_exists($k, $enumLabels) ? stripslashes($enumLabels[$k]) : stripslashes($el)); ?></option><?php
       	} else {
       	    ?><option value="<?php echo $default[0].'::'.$el; ?>"><?php echo isset($enum_arr[$el]) ? $enum_arr[$el] : (array_key_exists($k, $enumLabels) ? stripslashes($enumLabels[$k]) : stripslashes($el)); ?></option><?php
       	}
	}
    ?>
</select>