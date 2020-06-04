<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$week_start = isset($tpl['option_arr']['o_week_start']) && in_array((int) $tpl['option_arr']['o_week_start'], range(0,6)) ? (int) $tpl['option_arr']['o_week_start'] : 0;
$jqDateFormat = pjUtil::momentJsDateFormat($tpl['option_arr']['o_date_format']);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php echo @$titles['AR01']; ; ?></h2>
            </div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AR01'];?></p>
    </div>
</div>

<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
					<div class="row m-b-md">
						<form action="" method="get" class="frm-filter-advanced" data-view="employees">
							<div class="col-md-3 col-sm-8">
								<label><?php __('booking_service'); ?></label>
								<select name="service_id" class="form-control">
									<option value="">-- <?php __('lblChoose'); ?> --</option>
									<?php
									foreach ($tpl['service_arr'] as $service)
									{
										?><option value="<?php echo $service['id']; ?>"<?php echo $controller->_get->check('service_id') && $controller->_get->toInt('service_id') == $service['id'] ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($service['name']); ?></option><?php
									}
									?>
								</select>
							</div>

							<div class="col-lg-2 col-md-3 col-sm-4">
								<label><?php __('booking_index'); ?></label>
								<select name="index" class="form-control">
									<option value="cnt"><?php __('report_cnt'); ?></option>
									<option value="amount"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency']);?> <?php __('report_amount'); ?></option>
								</select>
							</div>

							<div class="col-lg-2 col-md-3 col-sm-6">
								<div class="form-group">
									<label><?php __('booking_from'); ?></label>
									<div class="input-group date"
	                                     data-provide="datepicker"
	                                     data-date-autoclose="true"
	                                     data-date-format="<?php echo $jqDateFormat ?>"
	                                     data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
										<input type="text" name="date_from" id="date_from" class="form-control" value="<?php echo date($tpl['option_arr']['o_date_format']); ?>" autocomplete="off">
										<span class="input-group-addon">
											<span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
									<input type="hidden" id="validate_date" name="validate_date" value="1" data-msg-remote="<?php __('invalid_dates_off', false, true);?>"/>
								</div>
							</div>
		
							<div class="col-lg-2 col-md-3 col-sm-6">
								<label><?php __('booking_to'); ?></label>
		
								<div class="input-group date"
									 data-provide="datepicker"
                                     data-date-autoclose="true"
                                     data-date-format="<?php echo $jqDateFormat ?>"
                                     data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
									<input type="text" name="date_to" id="date_to" class="form-control" value="<?php echo date($tpl['option_arr']['o_date_format']); ?>" autocomplete="off">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
		
							<div class="col-lg-3 col-md-3">
								<label>&nbsp;</label>
		
								<div class="form-group">
									<button class="btn btn-primary" type="submit"><?php __('btnGenerate'); ?></button>
									<button class="btn btn-primary btn-outline btn-print" type="button"><i class="fa fa-print m-r-xs"></i><?php __('btn_print'); ?></button>
								</div>
							</div>
						</form>
					</div>

					<div class="hr-line-dashed"></div>

					<div id="grid_employees"></div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.jsDateFormat = "<?php echo pjUtil::jsDateFormat($tpl['option_arr']['o_date_format']); ?>";
var myLabel = myLabel || {};
myLabel.name = "<?php __('employee_name', false, true); ?>";
myLabel.sign = "<?php echo html_entity_decode(pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false), ENT_QUOTES, 'utf-8'); ?>";

myLabel.total_bookings = "<?php __('report_total_bookings', false, true); ?>";
myLabel.confirmed_bookings = "<?php __('report_confirmed_bookings', false, true); ?>";
myLabel.pending_bookings = "<?php __('report_pending_bookings', false, true); ?>";
myLabel.cancelled_bookings = "<?php __('report_cancelled_bookings', false, true); ?>";
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";
</script>