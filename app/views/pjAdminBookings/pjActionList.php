<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$statuses = __('booking_statuses', true, true);
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
				<h2><?php echo @$titles['ABK16']; ?></h2>
			</div>
		</div>
		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php echo @$bodies['ABK16']; ?></p>
	</div>
</div>
        
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content cardealer-no-border">
					<div class="row m-b-md">
						<div class="col-sm-3">
						</div>
						<div class="col-md-3 col-sm-5">
							<form action="" method="get" class="form-horizontal frm-filter">
								<div class="input-group">
									<input type="text" name="q" placeholder="<?php __('btnSearch', false, true); ?>" class="form-control">
									<div class="input-group-btn">
										<button class="btn btn-primary" type="submit">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
							</form>
                        </div>
                        <div class="col-md-2 col-sm-4">
							<a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" class="btn btn-primary btn-outline pj-button-detailed"><?php __('advance_search'); ?></a>
						</div>
						<div class="col-lg-2 col-lg-offset-2 col-md-4 col-sm-12 text-right">
							<select class="form-control btn-filter">
								<option value=""><?php __('lblAll'); ?></option>
								<option value="confirmed"><?php echo $statuses['confirmed']; ?></option>
								<option value="pending"><?php echo $statuses['pending']; ?></option>
								<option value="cancelled"><?php echo $statuses['cancelled']; ?></option>
							</select>
						</div>
					</div>				
					
					<div id="collapseOne" class="collapse">
						<div class="m-b-lg">
							<ul class="agile-list no-padding">
								<li class="success-element b-r-sm">
									<div class="panel-body">
										<form action="" method="get" class="frm-filter-advanced">
											<div class="row">
												<div class="col-md-3 col-md-4 col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('booking_query'); ?></label>
														<input type="text" name="q" id="q" class="form-control" value="<?php echo $controller->_get->check('q') ? pjSanitize::html($controller->_get->toString('q')) : NULL; ?>" />
													</div>
												</div>

												<div class="col-md-3 col-md-4 col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('booking_status'); ?></label>
														<select name="booking_status" id="booking_status" class="form-control">
															<option value="">-- <?php __('lblChoose'); ?> --</option>
															<?php
															foreach ($statuses as $k => $v)
															{
																?><option value="<?php echo $k; ?>"<?php echo $controller->_get->check('booking_status') && $controller->_get->toString('booking_status') == $k ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($v); ?></option><?php
															}
															?>
														</select>
													</div>
												</div>

												<div class="col-md-3 col-md-4 col-sm-6">
													<div class="form-group">
														<label class="control-label"><?php __('booking_service'); ?></label>
														<select name="service_id" id="service_id" class="form-control">
															<option value="">-- <?php __('lblChoose'); ?> --</option>
															<?php
															foreach ($tpl['service_arr'] as $service)
															{
																?><option value="<?php echo $service['id']; ?>"<?php echo $controller->_get->check('service_id') && $controller->_get->toInt('service_id') == $service['id'] ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($service['name']); ?></option><?php
															}
															?>
														</select>
													</div>
												</div>
											</div>
											
											<div class="hr-line-dashed"></div>
											
											<div class="row">
												<div class="col-lg-4 col-md-6">
													<div class="row">
														<div class="col-sm-6">
															<div class="form-group">
																<label class="control-label"><?php __('booking_from'); ?></label>
																
																<div class="input-group date"
				                                                         data-provide="datepicker"
				                                                         data-date-autoclose="true"
				                                                         data-date-format="<?php echo $jqDateFormat ?>"
				                                                         data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
				                                                    <input type="text" name="date_from" id="date_from" class="form-control required" autocomplete="off">
				                                                    <span class="input-group-addon">
				                                                        <span class="glyphicon glyphicon-calendar"></span>
				                                                    </span>
				                                                </div>
															</div>
														</div>
														<div class="col-sm-6">
															<div class="form-group">
																<label class="control-label"><?php __('booking_to'); ?></label>
																
																<div class="input-group date"
				                                                         data-provide="datepicker"
				                                                         data-date-autoclose="true"
				                                                         data-date-format="<?php echo $jqDateFormat ?>"
				                                                         data-date-week-start="<?php echo (int) $tpl['option_arr']['o_week_start'] ?>">
				                                                    <input type="text" name="date_to" id="date_to" class="form-control required" autocomplete="off">
				                                                    <span class="input-group-addon">
				                                                        <span class="glyphicon glyphicon-calendar"></span>
				                                                    </span>
				                                                </div>
															</div>
														</div>
                                                    </div>
                                                </div>
											</div>
											<div class="hr-line-dashed"></div>
											<button class="btn btn-primary" type="submit"><?php __('btnSearch'); ?></button>
											<button class="btn btn-primary btn-outline"><?php __('btnCancel'); ?></button>
										</form>
									</div>
								</li>
							</ul>
						</div>
					</div>
                            
					<div id="grid_list"></div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="modal inmodal fade" id="modalView" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<div class="modal inmodal fade" id="modalItemEmail" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<div class="modal inmodal fade" id="modalItemSms" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>

<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.jsDateFormat = "<?php echo pjUtil::jsDateFormat($tpl['option_arr']['o_date_format']); ?>";
var myLabel = myLabel || {};
myLabel.uuid = "<?php __('booking_uuid', false, true); ?>";
myLabel.services = "<?php __('booking_services', false, true); ?>";
myLabel.status = "<?php __('booking_status', false, true); ?>";
myLabel.customer = "<?php __('booking_customer', false, true); ?>";
myLabel.total = "<?php __('booking_total', false, true); ?>";
myLabel.confirmed = "<?php echo $statuses['confirmed']; ?>";
myLabel.pending = "<?php echo $statuses['pending']; ?>";
myLabel.cancelled = "<?php echo $statuses['cancelled']; ?>";
myLabel.export_selected = "<?php __('booking_export', false, true); ?>";
myLabel.delete_selected = "<?php __('delete_selected', false, true); ?>";
myLabel.delete_confirmation = "<?php __('delete_confirmation', false, true); ?>";
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";
</script>