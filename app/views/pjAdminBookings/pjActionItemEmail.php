<?php
if (isset($tpl['arr']) && !empty($tpl['arr']))
{
	?>
	<form action="" method="post" class="frm-item-email">
		<input type="hidden" name="send_email" value="1" />
		<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
		<input type="hidden" name="from" value="<?php echo $tpl['arr']['from']; ?>" />
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>

			<h3 class="modal-title" id="myModalLabel"><?php __('booking_service_email_title'); ?></h3>
		</div>
		
		<div class="container-fluid">
			<div class="row m-t-sm">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="control-label"><?php __('booking_subject'); ?></label>
						<input type="text" name="subject" id="confirm_subject" class="form-control required" value="<?php echo pjSanitize::html($tpl['arr']['subject']); ?>" />
					</div>
				</div>
				<div class="col-sm-12">
					<div class="form-group">
						<label class="control-label"><?php __('booking_message'); ?></label>
						<textarea name="message" id="confirm_message" class="form-control mceEditor required"><?php echo stripslashes(str_replace(array('\r\n', '\n'), '&#10;', $tpl['arr']['message'])); ?></textarea>
					</div>
				</div>
				<div class="col-sm-12">
					<?php if (!empty($tpl['arr']['client_email'])) : ?>
					<p>
						<label><input class="required" type="checkbox" name="to[]" value="<?php echo pjSanitize::html($tpl['arr']['client_email']); ?>" checked="checked" /> <?php __('booking_reminder_client'); ?> (<?php echo pjSanitize::html($tpl['arr']['client_email']); ?>)</label>
					</p>
					<?php endif; ?>
					<?php if (!empty($tpl['arr']['employee_email'])) : ?>
					<p>
						<label><input class="required" type="checkbox" name="to[]" value="<?php echo pjSanitize::html($tpl['arr']['employee_email']); ?>" checked="checked" /> <?php __('booking_reminder_employee'); ?> (<?php echo pjSanitize::html($tpl['arr']['employee_email']); ?>)</label>
					</p>
				</div>
				<?php endif; ?>
			</div>
			
			<div class="modal-footer">
				<button type="button" class="btn btn-primary btnItemEmail"><?php __('btnSend'); ?></button>
				<button type="button" class="btn btn-default" data-dismiss="modal"><?php __('btnCancel'); ?></button>
			</div>
		</div>
	</form>
	<?php
}
?>