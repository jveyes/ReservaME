<?php
if (isset($tpl['arr']) && !empty($tpl['arr']))
{
	?>
	<form action="" method="post" class="form pj-form">
		<input type="hidden" name="send_sms" value="1" />
		<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>

			<h3 class="modal-title" id="myModalLabel"><?php __('booking_service_sms_title'); ?></h3>
		</div>
		
		<div class="container-fluid">
			<div class="row m-t-sm">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="control-label"><?php __('booking_message'); ?></label>
						<textarea name="message" id="confirm_message" class="form-control required"><?php echo stripslashes(str_replace(array('\r\n', '\n'), '&#10;', $tpl['arr']['message'])); ?></textarea>
					</div>
				</div>
				<div class="col-sm-12">
					<?php if (!empty($tpl['arr']['client_phone'])) : ?>
					<p>
						<label><input class="required" type="checkbox" name="to[]" value="<?php echo pjSanitize::html($tpl['arr']['client_phone']); ?>" checked="checked" /> <?php __('booking_reminder_client'); ?> (<?php echo pjSanitize::html($tpl['arr']['client_phone']); ?>)</label>
					</p>
					<?php endif; ?>
					<?php if (!empty($tpl['arr']['employee_phone'])) : ?>
					<p>
						<label><input class="required" type="checkbox" name="to[]" value="<?php echo pjSanitize::html($tpl['arr']['employee_phone']); ?>" checked="checked" /> <?php __('booking_reminder_employee'); ?> (<?php echo pjSanitize::html($tpl['arr']['employee_phone']); ?>)</label>
					</p>
					<?php endif; ?>
				</div>
			</div>
			
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btnItemSms"><?php __('btnSend'); ?></button>
				<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel'); ?></button>
			</div>
		</div>
	</form>
	<?php
}
?>