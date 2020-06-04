<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php __('infobox_schedule_title'); ?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php __('infobox_schedule_desc'); ?></p>
    </div><!-- /.col-md-12 -->
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
                <div class="m-b-sm">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-xs-8">
                        	<label class="control-label"><?php __('jumb_to'); ?></label>
                        	<div class="form-group">
                                <select id="jumb_to" name="jumb_to" class="form-control" data-type="Weekly">
                                	<?php
                                	$months = __('months', true);
									$first = reset($tpl['d_arr']);
									$last = end($tpl['d_arr']);
									$first_date_ts = strtotime($first);
									$last_date_ts = strtotime($last);
									$default_text = $months[date('n', $first_date_ts)] . ' ' . date('j', $first_date_ts);
									$default_text .= ' - ' . $months[date('n', $last_date_ts)] . ' ' . date('j', $last_date_ts);
                                	$week_range = pjUtil::getWeekRange(date('Y-m-d'), $tpl['option_arr']['o_week_start']);
                                	$selected_first_date = $tpl['option_arr']['o_week_start'] == 0 ? $week_range[0] : date('Y-m-d');
                                	if($controller->_get->check('date'))
                                	{
                                	    $selected_first_date = $controller->_get->toString('date');
                                	    $week_range = pjUtil::getWeekRange($selected_first_date, $tpl['option_arr']['o_week_start']);
                                	}
                                	
                                	for($i = -4; $i <= 4; $i++)
                                	{
                                	    $first_date_of_week = date('Y-m-d', strtotime($selected_first_date) + (86400*7*$i));
                                	    $week_number  = (int) date('W', strtotime($first_date_of_week));
                                	    $week_arr = pjUtil::getWeekRange($first_date_of_week, $tpl['option_arr']['o_week_start']);
                                	    $first_date_ts = strtotime($week_arr[0]);
                                	    $last_date_ts = strtotime($week_arr[1]);
                                	    $range_text = $months[date('n', $first_date_ts)] . ' ' . date('j', $first_date_ts);
                                	    $range_text .= ' - ' . $months[date('n', $last_date_ts)] . ' ' . date('j', $last_date_ts);
                                        if($first_date_of_week == $selected_first_date)
                                        {
                                            ?>
                                            <option value="<?php echo $first_date_of_week;?>" selected="selected"><?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? __('week', true) . ' ' . $week_number . ': ' : NULL;?><?php echo $range_text;?></option>
                                            <?php
                                        }else{
                                            ?>
                                            <option value="<?php echo $first_date_of_week;?>"><?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? __('week', true) . ' ' . $week_number . ': ' : NULL;?><?php echo $range_text;?></option>
                                            <?php
                                        }
                                	}
                                    ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-xs-8">
                        	<label class="control-label"><?php __('booking_employee'); ?></label>
                        	<div class="row">
                        		<div class="col-lg-10 col-md-10 col-xs-8">
                        			<div class="form-group">
                            			<select name="employee_id" id="employee_id" class="form-control" data-type="Weekly">
            								<option value="">-- <?php __('lblChoose'); ?> --</option>
            								<?php
            								foreach ($tpl['employee_arr'] as $employee)
            								{
            									?><option value="<?php echo $employee['id']; ?>"<?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') == $employee['id'] ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($employee['name']); ?></option><?php
            								}
            								?>
            							</select>
            						</div>
                        		</div>
                        		<div class="col-lg-2 col-md-2 col-xs-4">
                                	<div class="form-group">
                                        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionPrintWeekly&date=<?php echo $selected_first_date; ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline" target="_blank"><i class="fa fa-print m-r-xs"></i> <?php __('btn_print'); ?></a>
                                    </div>
                                </div>
                        	</div>
                        	
                        </div>

                        <div class="col-lg-6 col-md-6 col-xs-4">
                            <div class="form-group clearfix">
                                <div class="switch onoffswitch-data pull-right">
                                    <div class="onoffswitch">
                                        <input type="checkbox" class="onoffswitch-checkbox" id="status" name="status" checked="checked">
                                        <label class="onoffswitch-label" for="status">
                                            <span class="onoffswitch-inner" data-on="<?php __('weekly_view', false, true); ?>" data-off="<?php __('monthly_view', false, true); ?>"></span>
                                            <span class="onoffswitch-switch"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
						<div class="col-md-2 col-sm-3 col-xs-6">
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionWeekly&date=<?php echo date('Y-m-d', strtotime($selected_first_date) - 86400 * 7); ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline"><i class="fa fa-angle-left"></i></a>
						</div>

						<div class="col-md-2 col-sm-3 col-xs-6 text-right pull-right">
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionWeekly&date=<?php echo date('Y-m-d', strtotime($selected_first_date) + 86400 * 7); ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline"><i class="fa fa-angle-right"></i></a>
						</div>

						<div class="col-md-8 col-sm-6 col-xs-12 text-center">
							<h2 class="calendar-title"><?php echo $default_text;?></h2>
						</div> 
                    </div>
                </div>
				
                <div class="table-responsive table-appointment-management">
                    <table class="table table-bordered">
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
                                <td<?php echo $tpl['option_arr']['o_week_numbers'] == 1 ? NULL : ' style="display:none;"'; ?>><?php echo date('W', strtotime($selected_first_date));?></td>
                               	<?php
                               	foreach($tpl['d_arr'] as $date)
                               	{
                               	    ?>
                               	    <td>
                               	    	<strong class="appointment-management-date"><?php echo date('d', strtotime($date));?></strong>
                               	    	<?php
                            	    	include dirname(__FILE__) . '/elements/slots.php';
                            	    	?>
                               	    </td>
                               	    <?php
                               	}
                               	?>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="donut-chart-legend no-padding">
                    <strong class="donut-color-1"></strong>
                    <span><?php __('available'); ?></span>

                    <strong class="donut-color-2"></strong>
                    <span><?php __('booking_statuses_ARRAY_pending'); ?></span>
                    
                    <strong class="bg-danger"></strong>
                    <span><?php __('booking_statuses_ARRAY_confirmed'); ?></span>
                </div>
                
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="reminderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  	<div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
		      <div class="modal-header">
		        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        	<h4 class="modal-title"><?php __('send_reminder');?></h4>
		      </div>
		      <div id="emailContentWrapper" class="modal-body"></div>
		      <div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel');?></button>
		        	<button id="btnSendReminder" type="button" class="btn btn-primary"><?php __('btnSend');?></button>
		      </div>
	    </div>
  	</div>
</div>

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.are_you_sure = <?php x__encode('are_you_sure');?>;
myLabel.cancel_text = <?php x__encode('cancel_text');?>;
myLabel.btn_confirm_cancel = <?php x__encode('btn_confirm_cancel');?>;
</script>