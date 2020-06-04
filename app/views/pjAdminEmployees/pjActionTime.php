<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$days = __('days', true);
$days = pjUtil::sortWeekDays($tpl['option_arr']['o_week_start'], $days);
$wdays = array(1 => 'monday', 2 => 'tuesday', 3 => 'wednesday', 4 => 'thursday', 5 => 'friday', 6 => 'saturday', 0 => 'sunday');
$week_start = isset($tpl['option_arr']['o_week_start']) && in_array((int) $tpl['option_arr']['o_week_start'], range(0,6)) ? (int) $tpl['option_arr']['o_week_start'] : 0;
$jqDateFormat = pjUtil::momentJsDateFormat($tpl['option_arr']['o_date_format']);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo @$titles['AT04']; ?></h2>
                <ol class="breadcrumb">
					<li><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionIndex"><?php __('menuEmployees'); ?></a></li>
					<li class="active">
						<strong><?php echo @$titles['AT04'];?></strong>
					</li>
				</ol>
            </div>

        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AT04']; ?></p>
    </div>
</div>

<div class="wrapper wrapper-content animated fadeInRight">
	<?php
	if ($controller->_get->check('err'))
	{
		$titles = __('error_titles', true);
		$bodies = __('error_bodies', true);
		switch (true)
		{
			case in_array($controller->_get->toString('err'), array('AT01', 'AT02')):
				?>
				<div class="alert alert-success">
					<i class="fa fa-check m-r-xs"></i>
					<strong><?php echo @$titles[$controller->_get->toString('err')]; ?></strong>
					<?php echo @$bodies[$controller->_get->toString('err')]?>
				</div>
				<?php 
				break;
			case in_array($controller->_get->toString('err'), array('')):	
				?>
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle m-r-xs"></i>
					<strong><?php echo @$titles[$controller->_get->toString('err')]; ?></strong>
					<?php echo @$bodies[$controller->_get->toString('err')]?>
				</div>
				<?php
				break;
		}
	}
	?>
    <div class="tabs-container tabs-reservations m-b-lg">
        <ul class="nav nav-tabs" role="tablist">
        	<?php 
        	if (($controller->isAdmin() || $controller->isEditor()) && $controller->_get->check('foreign_id') && $controller->_get->toInt('foreign_id') > 0)
        	{
	        	?>
	        	<li role="presentation"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&action=pjActionUpdate&id=<?php echo $controller->_get->toInt('foreign_id'); ?>" aria-controls="general" role="tab"><?php __('employee_general');?></a></li>
	        	<?php 
        	}
        	?>
            <li role="presentation"<?php echo !$controller->_get->check('tab') || $controller->_get->toInt('tab') == 2 ? ' class="active"' : NULL; ?>><a href="#default" aria-controls="default" role="tab" data-toggle="tab"><?php __('time_default_wt');?></a></li>
            <li role="presentation"<?php echo $controller->_get->check('tab') && $controller->_get->toInt('tab') == 3 ? ' class="active"' : NULL; ?>><a href="#days-off" aria-controls="days-off" role="tab" data-toggle="tab"><?php __('time_custom_wt');?></a></li>
        </ul>

        <div class="tab-content">
            <div role="tabpanel" class="tab-pane<?php echo !$controller->_get->check('tab') || $controller->_get->toInt('tab') == 2 ? ' active' : NULL; ?>" id="default">
                <div class="panel-body">
                    <form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionTime" method="post" id="frmDefaultWTime">
        				<input type="hidden" name="working_time" value="1" />
        				<?php
						if ($controller->isAdmin() || $controller->isEditor())
						{
							?><input type="hidden" name="id" value="<?php echo (int) $tpl['wt_arr']['id']; ?>" /><?php
						}
						if ($controller->_get->check('foreign_id') && $controller->_get->toInt('foreign_id') > 0)
						{
							?><input type="hidden" name="foreign_id" value="<?php echo (int) $tpl['wt_arr']['foreign_id']; ?>" /><?php
						}
						if ($controller->_get->check('type') && $controller->_get->toString('type') != '')
						{
							?><input type="hidden" name="type" value="<?php echo pjSanitize::html($tpl['wt_arr']['type']); ?>" /><?php
						}
						?>
                        <div class="time-table">
                            <div class="m-b-md">
                                <a href="#" class="btn btn-primary btn-outline no-margins" data-toggle="modal" data-target="#setWTimeModal"><i class="fa fa-clock-o m-r-xs"></i> <?php __('btn_set_wtime');?></a>
                            </div>

                            <div class="table-responsive table-responsive-secondary">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th><?php __('day');?></th>
                                            <th><?php __('hours');?></th>
                                            <th><?php __('lunch_break'); ?></th>
                                        </tr>
                                    </thead>
                            
                                    <tbody>
                                    	<?php
                                    	foreach($days as $day_num => $day_name)
                                    	{
                                    	    ?>
                                    	    <tr>
                                                <td><?php echo $day_name;?></td>
                                                <td id="week_day_<?php echo $day_num;?>">
                                                	<?php
                                                	if(isset($tpl['wt_arr'][$wdays[$day_num] . '_from']) && !empty($tpl['wt_arr'][$wdays[$day_num] . '_from']))
                                                	{
                                               	        $start_time = $tpl['wt_arr'][$wdays[$day_num] . '_from'];
                                               	        $end_time = $tpl['wt_arr'][$wdays[$day_num] . '_to'];
                                               	        ?>
                                               	        <span class="label label-primary"><input type="hidden" name="from[<?php echo $day_num;?>][<?php echo $k + 1;?>]" value="<?php echo date($tpl['option_arr']['o_time_format'], strtotime($start_time));?>" /><input type="hidden" name="to[<?php echo $day_num;?>][<?php echo $k + 1;?>]" value="<?php echo date($tpl['option_arr']['o_time_format'], strtotime($end_time));?>"/><?php echo date($tpl['option_arr']['o_time_format'], strtotime($start_time));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($end_time));?> <a href="#" class="text-primary remove-time" rev="day"><i class="fa fa-times m-l-xs"></i></a></span>&nbsp;
                                               	        <?php
                                                	}else{
                                                	    __('day_off');
                                                	}
                                                    ?> 
                                                </td>
                                                <td id="lunch_break_<?php echo $day_num;?>">
                                                	<?php
                                                	if(isset($tpl['wt_arr'][$wdays[$day_num] . '_lunch_from']) && !empty($tpl['wt_arr'][$wdays[$day_num] . '_lunch_from']))
                                                	{
                                               	        $start_time = $tpl['wt_arr'][$wdays[$day_num] . '_lunch_from'];
                                               	        $end_time = $tpl['wt_arr'][$wdays[$day_num] . '_lunch_to'];
                                               	        ?>
                                               	        <span class="label label-secondary"><input type="hidden" name="lunch_from[<?php echo $day_num;?>][<?php echo $k + 1;?>]" value="<?php echo date($tpl['option_arr']['o_time_format'], strtotime($start_time));?>" /><input type="hidden" name="lunch_to[<?php echo $day_num;?>][<?php echo $k + 1;?>]" value="<?php echo date($tpl['option_arr']['o_time_format'], strtotime($end_time));?>"/><?php echo date($tpl['option_arr']['o_time_format'], strtotime($start_time));?> - <?php echo date($tpl['option_arr']['o_time_format'], strtotime($end_time));?> <a href="#" class="text-primary remove-time" rev="lunch"><i class="fa fa-times m-l-xs"></i></a></span>&nbsp;
                                               	        <?php
                                                	}else{
                                                	    __('lunch_off');
                                                	}
                                                    ?> 
                                                </td>
                                            </tr>
                                    	    <?php
                                    	}
                                    	?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div role="tabpanel" class="tab-pane<?php echo $controller->_get->check('tab') && $controller->_get->toInt('tab') == 3 ? ' active' : NULL; ?>" id="days-off">
                <div class="panel-body ibox-content sk-custom-wrap">
                    <div class="row m-b-md">
                        <div class="col-lg-4 col-sm-4">
                            <a href="#" data-toggle="modal" data-target="#dayOffModal" class="btn btn-primary btn-outline"><i class="fa fa-plus"></i> <?php __('btn_add_day_off');?></a>
                        </div>
                    </div>

                    <div id="grid_time"></div>

                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="setWTimeModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="frmSetWTime" action="?" method="post">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only"></span></button>

                    <h2 class="no-margins"><?php __('set_working_times');?></h2>
                </div>

                <div class="panel-body">
                    <div class="form-group">
                        <label class="control-label"><?php __('select_day');?></label>

						<div class="input-group" style="width: 100% !important;">
                            <select id="choosen_week_day" name="week_day[]" class="form-control required chosen-select" multiple tabindex="4">
                                <?php
                                foreach($days as $k => $day)
                                {
                                    ?><option value="<?php echo $k;?>"><?php echo $day;?></option><?php
                                }
                                ?>
                            </select>
                    	</div>
                    </div><!-- /.form-group -->

                    <div class="row">
                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('wokring_from');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="from_time" class="form-control required" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->

                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('wokring_to');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="to_time" class="form-control required" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->

                    <div class="row">
                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('lunch_from');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="lunch_from_time" class="form-control" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->

                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('lunch_to');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="lunch_to_time" class="form-control" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->

                    <div class="form-group" style="display:none">
                    	<p class="text-danger" id="time-error-msg"></p>
                    </div>
                </div><!-- /.panel-body -->

                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary"><?php __('btn_set_wtime');?></button>
                    <a href="#" class="btn btn-default" data-dismiss="modal"><?php __('btn_cancel');?></a>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="dayOffModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="frmSetDayOff" action="?" method="post">
            	<input type="hidden" name="id" value="" />
            	<?php
				if ($controller->_get->check('foreign_id') && $controller->_get->toInt('foreign_id') > 0)
				{
					?><input type="hidden" name="foreign_id" value="<?php echo (int) $tpl['wt_arr']['foreign_id']; ?>" /><?php
				}
				if ($controller->_get->check('type') && $controller->_get->toString('type') != '')
				{
					?><input type="hidden" name="type" value="<?php echo pjSanitize::html($tpl['wt_arr']['type']); ?>" /><?php
				}
				?>
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only"></span></button>

                    <h2 id="dialog-title" class="no-margins"><?php __('add_day_off');?></h2>
                </div>

                <div class="panel-body">
                     <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('from_date');?></label>

                                <div class="input-group date"
									 data-provide="datepicker"
                                     data-date-autoclose="true"
                                     data-date-start-date="0d"
                                     data-date-format="<?php echo $jqDateFormat ?>"
                                     data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
                                    <input type="text" name="from_date" class="form-control required" value="<?php echo date($tpl['option_arr']['o_date_format']); ?>" data-msg-required="<?php __('required_field', false, true);?>" autocomplete="off">

                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('to_date');?></label>

                                <div class="input-group date"
									 data-provide="datepicker"
                                     data-date-autoclose="true"
                                     data-date-start-date="0d"
                                     data-date-format="<?php echo $jqDateFormat ?>"
                                     data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
                                    <input type="text" name="to_date" class="form-control required" value="<?php echo date($tpl['option_arr']['o_date_format']); ?>" data-msg-required="<?php __('required_field', false, true);?>" autocomplete="off">

                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->

                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="control-label"><input type="checkbox" name="is_dayoff" id="is_dayoff" value="T" /> <?php __('time_is');?></label>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->
                    
                    <div class="row box-time">
                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('from_time');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="start_time" id="start_time" class="form-control required" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->

                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('to_time');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="end_time" id="end_time" class="form-control required" data-msg-required="<?php __('required_field', false, true);?>" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->
                    
                    <div class="row box-time">
                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('lunch_from');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="start_lunch" class="form-control" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->

                        <div class="col-xs-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('lunch_to');?></label>

                                <div class="input-group clockpicker">
                                    <input type="text" name="end_lunch" class="form-control" readonly>

                                    <span class="input-group-addon"><i class="fa fa-clock-o"></i></span>
                                </div>
                            </div><!-- /.form-group -->
                        </div><!-- /.col-md-6 -->
                    </div><!-- /.row -->
                    
                    <div class="form-group" style="display:none">
                    	<p class="text-danger" id="dayoff-error-msg"></p>
                    </div>
                </div><!-- /.panel-body -->
                <div class="modal-footer">
                    <button type="submit" id="btn-dialog-submit" class="btn btn-primary"><?php __('btnSave');?></button>
                    <a href="#" class="btn btn-default" data-dismiss="modal"><?php __('btn_cancel');?></a>
                </div>
            </form>
        </div>
    </div>
</div>

<?php
$show_period = 'false';
if((strpos($tpl['option_arr']['o_time_format'], 'a') > -1 || strpos($tpl['option_arr']['o_time_format'], 'A') > -1))
{
    $show_period = 'true';
}
?>
<script type="text/javascript">
	var pjGrid = pjGrid || {};
	<?php
	if ($controller->isAdmin() || $controller->isEditor())
	{
		?>pjGrid.id = "<?php echo (int) $tpl['wt_arr']['id']; ?>";<?php
	} else {
		?>pjGrid.id = "";<?php
	}
	if ($controller->_get->check('foreign_id') && $controller->_get->toInt('foreign_id') > 0)
	{
		?>pjGrid.foreign_id = "<?php echo (int) $tpl['wt_arr']['foreign_id']; ?>";<?php
	} else {
		?>pjGrid.foreign_id = "";<?php
	}
	if ($controller->_get->check('type') && $controller->_get->toString('type') != '')
	{
		?>pjGrid.type = "<?php echo pjSanitize::html($tpl['wt_arr']['type']); ?>";<?php
	} else {
		?>pjGrid.type = "";<?php
	}
	?>
	
	var myLabel = myLabel || {};
	myLabel.current_date = "<?php echo date($tpl['option_arr']['o_date_format']); ?>";
	myLabel.showperiod = <?php echo $show_period; ?>;
	myLabel.placeholder_text = <?php x__encode('choose');?>;
	myLabel.day_off = <?php x__encode('day_off');?>;
	myLabel.lunch_off = <?php x__encode('lunch_off');?>;
	myLabel.dates = <?php x__encode('dates');?>;
	myLabel.hour = <?php x__encode('hour');?>;
	myLabel.is_dayoff = <?php x__encode('time_is');?>;
	myLabel.lunch = <?php x__encode('lunch_break');?>;
	myLabel.delete_selected = <?php x__encode('delete_selected'); ?>;
	myLabel.delete_confirmation = <?php x__encode('delete_confirmation'); ?>;

	myLabel.dialog_btn_add = <?php x__encode('btn_add_day_off'); ?>;
	myLabel.dialog_btn_save = <?php x__encode('btnSave'); ?>;
	myLabel.dialog_btn_cancel = <?php x__encode('btnCancel'); ?>;
	myLabel.dialog_title_add = <?php x__encode('add_day_off'); ?>;
	myLabel.dialog_title_save = <?php x__encode('btnUpdate'); ?>;
	myLabel.dialog_title_over = <?php x__encode('wt_title_over'); ?>;
	myLabel.dialog_body_over = <?php x__encode('wt_body_over'); ?>;
	myLabel.months = "<?php echo implode("_", $months);?>";
	myLabel.days = "<?php echo implode("_", $short_days);?>";
</script>