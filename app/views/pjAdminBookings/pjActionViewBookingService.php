<?php
if (isset($tpl['arr']) && !empty($tpl['arr']))
{
	?>
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>

		<h3 class="modal-title" id="myModalLabel"><?php __('booking_view_title'); ?></h3>
	</div>
	<div class="container-fluid">
		<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('booking_general') ?></p>
		
		<div class="row m-t-sm">
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_uuid'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['uuid']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_status'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['booking_status']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_created'); ?></label>
					<?php echo date($tpl['option_arr']['o_date_format'] . ' ' . $tpl['option_arr']['o_time_format'], strtotime($tpl['arr']['created'])); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_ip'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['ip']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_service'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['service_name']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_dt'); ?></label>
					<?php echo date($tpl['option_arr']['o_date_format'] . ' ' . $tpl['option_arr']['o_time_format'], strtotime($tpl['arr']['date'] . " " . $tpl['arr']['start'])); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_notes'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_notes']); ?>
				</div>
			</div>
		</div>
		
		<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('booking_customer') ?></p>
		
		<div class="row m-t-sm">
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_name'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_name']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_email'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_email']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_phone'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_phone']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_address_1'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_address_1']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_address_2'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_address_2']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_country'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['country_name']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_state'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_state']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_city'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_city']); ?>
				</div>
			</div>
			<div class="col-sm-12">
				<div class="form-group">
					<label class="control-label"><?php __('booking_zip'); ?></label>
					<?php echo pjSanitize::html($tpl['arr']['c_zip']); ?>
				</div>
			</div>
		</div>
		
		<div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('buttons_ARRAY_close'); ?></button>
		</div>
	</div>
	<?php
}
?>