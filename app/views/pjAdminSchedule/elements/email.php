<?php
if (isset($tpl['arr']) && !empty($tpl['arr']))
{
	?>
	<form action="" method="post" class="">
		<input type="hidden" name="send_email" value="1" />
		<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
		<input type="hidden" name="from" value="<?php echo $tpl['arr']['from']; ?>" />
		
		<div class="form-group">
			<label class="control-label"><?php __('subject');?></label>
	
			<input type="text" name="subject" id="confirm_subject" class="form-control required" value="<?php echo pjSanitize::html($tpl['arr']['subject']); ?>" />
		</div>
		<div class="form-group">
			<label class="control-label"><?php __('message');?></label>
			<div id="crMessageEditorWrapper">
				<textarea name="message" id="mceEditor" class="form-control required"><?php echo stripslashes(str_replace(array('\r\n', '\n'), '&#10;', $tpl['arr']['message'])); ?></textarea>
			</div>			
		</div>
		
		<?php if (!empty($tpl['arr']['email'])) :?>
		<p>
			<label><b><?php __('client_email');?>:</b> <input type="hidden" name="to" value="<?php echo pjSanitize::html($tpl['arr']['email']); ?>"/> <?php echo pjSanitize::html($tpl['arr']['email']); ?></label>
		</p>
		<?php endif; ?>
	</form>
	<?php
}
?>