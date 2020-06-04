<?php
if(!empty($tpl['service_arr']))
{
    $week_start = isset($tpl['option_arr']['o_week_start']) && in_array((int) $tpl['option_arr']['o_week_start'], range(0,6)) ? (int) $tpl['option_arr']['o_week_start'] : 0;
    $jqDateFormat = pjUtil::momentJsDateFormat($tpl['option_arr']['o_date_format']);
    ?>
    <form action="" method="post" class="frm-item-add">
    	<input type="hidden" name="item_add" value="1" />
    	<input type="hidden" name="booking_id" value="<?php echo @$controller->_get->toInt('id'); ?>" />
    	<input type="hidden" name="tmp_hash" value="<?php echo @$controller->_get->toString('tmp_hash'); ?>" />
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
    
            <h3 class="modal-title" id="myModalLabel"><?php __('booking_service_add_title'); ?></h3>
        </div>
    
        <div class="container-fluid">
            <div class="row m-t-sm">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label class="control-label"><?php __('booking_date'); ?></label>
    
    					<div class="input-group date"
    	                     data-date-autoclose="true"
    	                     data-date-start-date="0d"
    	                     data-date-format="<?php echo $jqDateFormat; ?>"
    	                     data-date-week-start="<?php echo $week_start; ?>">
    	                     <input type="text" name="date" id="date" class="form-control" autocomplete="off" value="<?php echo date($tpl['option_arr']['o_date_format']); ?>">
    	                     <span class="input-group-addon">
    	                	     <span class="glyphicon glyphicon-calendar"></span>
    	                     </span>
    	                </div>
                    </div>
                </div>
    
                <div class="col-sm-6">
                    <div class="form-group">
                        <label class="control-label"><?php __('booking_service'); ?></label>
    
    					<select name="service_id" class="form-control stock-product">
    						<option value="">-- <?php __('booking_service'); ?> --</option>
    						<?php
    						foreach ($tpl['service_arr'] as $service)
    						{
    							?><option value="<?php echo $service['id']; ?>"><?php echo pjSanitize::html($service['name']); ?></option><?php
    						}
    						?>
    					</select>
                    </div>
                </div>
            </div>
    
            <div class="row service-summary">
                <div class="col-md-4 col-sm-6 bEmployee">
                    <label><?php __('booking_employee'); ?>:</label>
                    <p class="data">---</p>
                    <input type="hidden" name="employee_id" value="" class="ignore" />
                </div>
    
                <div class="col-md-4 col-sm-6 bStartTime">
                    <label><?php __('booking_start_time'); ?>:</label>
                    <p class="data">---</p>
                    <input type="hidden" name="start_ts" value="" class="ignore" />
                </div>
    
                <div class="col-md-4 col-sm-6 bEndTime">
                    <label><?php __('booking_end_time'); ?>:</label>
                    <p class="data">---</p>
                    <input type="hidden" name="end_ts" value="" class="ignore" />
                </div>
            </div>
        </div>
        
        <div class="item_details" style="display: none"></div>
        
        <div class="modal-footer">
            <button type="button" class="btn btn-primary btnAddItem"><i class="fa fa-plus m-r-xs"></i> <?php __('btnAdd'); ?></button>
            <button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel'); ?></button>
        </div>
    </form>
    <?php
}else{
    $titles = __('error_titles', true);
    $bodies = __('error_bodies', true);
    ?>
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>

        <h3 class="modal-title" id="myModalLabel"><?php __('booking_service_add_title'); ?></h3>
    </div>
    <div class="item_details">
    	<div class="service-table">
    		<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php echo @$bodies['ABK14']; ?></p>
    	</div>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel'); ?></button>
    </div>
    <?php
}
?>