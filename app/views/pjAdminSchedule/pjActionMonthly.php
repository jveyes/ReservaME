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
                                <select id="jumb_to" name="jumb_to" class="form-control" data-type="Monthly">
                                	<?php
                                	$date_ts = strtotime(date('Y-m-d'));
                                	if($controller->_get->check('date'))
                                	{
                                	    $date_ts = strtotime($controller->_get->toString('date'));
                                	}
                                	$months = __('months', true);
                                	$first_day_of_month = date('Y-m-01', $date_ts);
                                	$first_date_of_month_ts = strtotime($first_day_of_month);
                                	foreach(range(5, 1) as $i)
                                	{
                                	    $day_of_month = date('Y-m-01', strtotime('-' .$i.' month', $first_date_of_month_ts));
                                	    $day_of_month_ts = strtotime($day_of_month);
                                	    $n = date('n', $day_of_month_ts);
                                	    ?>
                                	    <option value="<?php echo date('Y-m-d', $day_of_month_ts);?>"><?php echo $months[$n];?>, <?php echo date('Y', $day_of_month_ts);?></option>
                                	    <?php
                                	}
                                	foreach(range(0, 6) as $i)
                                	{
                                	    $day_of_month = date('Y-m-01', strtotime('+' .$i.' month', $first_date_of_month_ts));
                                	    $day_of_month_ts = strtotime($day_of_month);
                                	    $n = date('n', $day_of_month_ts);
                                	    if($day_of_month == $first_day_of_month)
                                	    {
                                	        ?>
                                    	    <option value="<?php echo date('Y-m-d', $day_of_month_ts);?>" selected="selected"><?php echo $months[$n];?>, <?php echo date('Y', $day_of_month_ts);?></option>
                                    	    <?php
                                	    }else{
                                	        ?>
                                    	    <option value="<?php echo date('Y-m-d', $day_of_month_ts);?>"><?php echo $months[$n];?>, <?php echo date('Y', $day_of_month_ts);?></option>
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
                            			<select name="employee_id" id="employee_id" class="form-control" data-type="Monthly">
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
                                        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionPrintMonthly&date=<?php echo $tpl['date']; ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline" target="_blank"><i class="fa fa-print m-r-xs"></i> <?php __('btn_print'); ?></a>
                                    </div>
                                </div>
                        	</div>
                        </div>

                        <div class="col-lg-6 col-md-6 col-xs-12">
                            <div class="form-group clearfix">
                                <div class="switch onoffswitch-data pull-right">
                                    <div class="onoffswitch">
                                        <input type="checkbox" class="onoffswitch-checkbox" id="status" name="status">
                                        <label class="onoffswitch-label" for="status">
                                            <span class="onoffswitch-inner" data-on="<?php __('weekly_view', false, true); ?>" data-off="<?php __('monthly_view', false, true); ?>"></span>
                                            <span class="onoffswitch-switch"></span>
                                        </label>
                                    </div>
                                </div>
                            </div><!-- /.form-group -->
                        </div>
                    </div>
                    <div class="row">
						<?php
						$next_month = date('Y-m-01', strtotime('+1 month', strtotime($tpl['date'])));
						$prev_month = date('Y-m-01', strtotime('-1 month', strtotime($tpl['date'])));
						?>
						<div class="col-md-2 col-sm-3 col-xs-6">
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionMonthly&date=<?php echo $prev_month; ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline"><i class="fa fa-angle-left"></i></a>
						</div>

						<div class="col-md-2 col-sm-3 col-xs-6 text-right pull-right">
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionMonthly&date=<?php echo $next_month; ?><?php echo $controller->_get->check('employee_id') && $controller->_get->toInt('employee_id') > 0 ? '&employee_id=' . $controller->_get->toInt('employee_id') : NULL;?>" class="btn btn-primary btn-outline"><i class="fa fa-angle-right"></i></a>
						</div>
								
						<div class="col-md-8 col-sm-6 col-xs-12 text-center">
							<h2 class="calendar-title"><?php echo $months[date('n', strtotime($tpl['date']))];?>, <?php echo date('Y', strtotime($tpl['date']));?></h2>
						</div> 
                    </div>
                </div>
				<?php
				$days = __('days', true);
				$week_start = $tpl['option_arr']['o_week_start'];
				$row_arr = array_chunk($tpl['d_arr'], 7);
				?>
                <div class="table-responsive table-appointment-management">
                    <table class="table table-bordered">
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
                                	    	include dirname(__FILE__) . '/elements/slots.php';
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
                </div>

                <div class="donut-chart-legend no-padding">
                    <strong class="donut-color-1"></strong>
                    <span><?php __('available'); ?></span>

                    <strong class="donut-color-2"></strong>
                    <span><?php __('booking_statuses_ARRAY_pending'); ?></span>
                    
                    <strong class="bg-danger"></strong>
                    <span><?php __('booking_statuses_ARRAY_confirmed'); ?></span>
                </div>
                
                <!-- remove this -->
            </div>
        </div>
    </div><!-- /.col-lg-12 -->
</div><!-- /.wrapper wrapper-content -->

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
	    </div><!-- /.modal-content -->
  	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.are_you_sure = <?php x__encode('are_you_sure');?>;
myLabel.cancel_text = <?php x__encode('cancel_text');?>;
myLabel.btn_confirm_cancel = <?php x__encode('btn_confirm_cancel');?>;
</script>