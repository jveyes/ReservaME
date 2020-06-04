<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo @$titles['AO28']; ?></h2>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
				<?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
			</div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i><?php echo @$bodies['AO28']; ?></p>
    </div><!-- /.col-md-12 -->
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<?php
	$error_code = $controller->_get->toString('err');
	if (!empty($error_code))
	{
		$titles = __('error_titles', true);
		$bodies = __('error_bodies', true);
		switch (true)
		{
			case in_array($error_code, array('AO08')):
				?>
				<div class="alert alert-success">
					<i class="fa fa-check m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code]?>
				</div>
				<?php
				break;
			case in_array($error_code, array('')):
				?>
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code]?>
				</div>
				<?php
				break;
		}
	}
	if (isset($tpl['arr']) && is_array($tpl['arr']) && !empty($tpl['arr']))
	{
		$yesno = __('plugin_base_yesno', true);
		$locale = $controller->_get->check('locale') && $controller->_get->toInt('locale') > 0 ? $controller->_get->toInt('locale') : NULL;
		if (is_null($locale))
		{
			foreach ($tpl['lp_arr'] as $v)
			{
				if ($v['is_default'] == 1)
				{
					$locale = $v['id'];
					break;
				}
			}
		}
		if (is_null($locale))
		{
			$locale = @$tpl['lp_arr'][0]['id'];
		}

		$tab_id = $controller->_get->check('tab_id') && $controller->_get->toString('tab_id') ? $controller->_get->toString('tab_id') : 'client';
		?>
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
					<form id="frmReminder" action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionUpdate" class="form-horizontal" method="post">
						<input type="hidden" name="options_update" value="1" />
						<input type="hidden" name="tab" value="4" />
						<input type="hidden" name="next_action" value="pjActionReminder" />

						<div class="m-b-lg">
							<h2 class="no-margins"><?php __('script_emails');?></h2>
						</div>

						<div class="row">
							<div class="col-lg-8">
								<div class="form-group">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_email_enable') ?></label>

									<div class="col-lg-2 col-md-3">
										<div class="switch onoffswitch-data m-t-xs">
											<div class="onoffswitch">
												<input type="checkbox" class="onoffswitch-checkbox" id="switch_o_reminder_email_enable" name="o_reminder_email_enable" <?php echo $tpl['option_arr']['o_reminder_email_enable'] == '1' ? ' checked="checked"' : NULL;?>>
												<label class="onoffswitch-label" for="switch_o_reminder_email_enable">
													<span class="onoffswitch-inner" data-on="<?php echo $yesno['T'] ?>" data-off="<?php echo $yesno['F'] ?>"></span>
													<span class="onoffswitch-switch"></span>
												</label>
											</div>
										</div>
										<input type="hidden" name="value-enum-o_reminder_email_enable" value="<?php echo '1|0::' . $tpl['option_arr']['o_reminder_email_enable'];?>">
									</div>
								</div>

								<div class="form-group boxReminder">
									<label class="col-lg-3 col-md-4 control-label">&nbsp;</label>

									<div class="col-md-8">
										<p class="alert alert-warning alert-with-icon"> <i class="fa fa-warning"></i> <?php __('opt_o_reminder_cron_text') ?></p>
									</div>
								</div>

								<div class="form-group boxReminder">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_email_before') ?></label>

									<div class="col-md-3">
										<input type="text" name="value-enum-o_reminder_email_before" class="form-control field-int" value="<?php echo pjSanitize::html($tpl['option_arr']['o_reminder_email_before']); ?>">
									</div>

									<p class="m-t-xs"><?php __('lblHoursBefore');?></p>
								</div>

								<div class="form-group boxReminder">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_subject') ?></label>

									<div class="col-lg-9 col-md-8">
										<?php
										foreach ($tpl['lp_arr'] as $v)
										{
											?>
											<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 0 ? 'none' : NULL; ?>">
												<input type="text" name="i18n[<?php echo $v['id']; ?>][o_reminder_subject]" class="form-control" value="<?php echo pjSanitize::html(@$tpl['arr']['i18n'][$v['id']]['o_reminder_subject']); ?>">
												<?php if ($tpl['is_flag_ready']) : ?>
												<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
												<?php endif; ?>
											</div>
											<?php
										}
										?>
									</div>
								</div>

								<div class="form-group boxReminder">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_body') ?></label>

									<div class="col-lg-9 col-md-8 mce-md">
										<?php
										foreach ($tpl['lp_arr'] as $v)
										{
											?>
											<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 0 ? 'none' : NULL; ?>">
												<textarea name="i18n[<?php echo $v['id']; ?>][o_reminder_body]" class="form-control mceEditor"><?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['o_reminder_body'])); ?></textarea>
												<?php if ($tpl['is_flag_ready']) : ?>
												<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
												<?php endif; ?>
											</div>
											<?php
										}
										?>
									</div>
								</div>
							</div><!-- /.col-lg-8 -->

							<div class="col-lg-4">
								<div class="boxReminder">
									<h3 class="m-b-md"><?php __('plugin_base_available_tokens') ?>:</h3>

									<div class="row">
										<?php echo __('opt_o_reminder_body_text') ?>
									</div>
								</div>
							</div><!-- /.col-lg-4 -->
						</div><!-- /.row -->
	
						<div class="hr-line-dashed"></div>

						<div class="m-b-lg">
							<h2 class="no-margins"><?php __('script_sms');?></h2>
						</div>

						<div class="row">
							<div class="col-lg-8">
								<div class="form-group">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_sms_enable') ?></label>

									<div class="col-lg-2 col-md-3">
										<div class="switch onoffswitch-data m-t-xs">
											<div class="onoffswitch">
												<input type="checkbox" class="onoffswitch-checkbox" id="switch_o_reminder_sms_enable" name="o_reminder_sms_enable" <?php echo $tpl['option_arr']['o_reminder_sms_enable'] == '1' ? ' checked="checked"' : NULL;?>>
												<label class="onoffswitch-label" for="switch_o_reminder_sms_enable">
													<span class="onoffswitch-inner" data-on="<?php echo $yesno['T'] ?>" data-off="<?php echo $yesno['F'] ?>"></span>
													<span class="onoffswitch-switch"></span>
												</label>
											</div>
										</div>
										<input type="hidden" name="value-enum-o_reminder_sms_enable" value="<?php echo '1|0::' . $tpl['option_arr']['o_reminder_sms_enable'];?>">
									</div>
								</div>

								<div class="form-group boxReminderSms">
									<div class="col-lg-9 col-md-8 col-lg-offset-3 col-md-offset-4">
										<p class="alert alert-warning alert-with-icon no-margins"><i class="fa fa-warning m-r-xs"></i><?php __('plugin_base_sms_warning') ?></p>
									</div>
								</div>
							
								<div class="form-group boxReminderSms">
									<label class="col-lg-3 col-md-4 col-sm-12 col-xs-12 control-label"><?php __('opt_o_reminder_sms_hours') ?></label>

									<div class="col-md-3 col-sm-6 col-xs-6">
										<input type="text" name="value-enum-o_reminder_sms_hours" class="form-control field-int" value="<?php echo pjSanitize::html($tpl['option_arr']['o_reminder_sms_hours']); ?>">
									</div>

									<div class="col-md-5 col-sm-6 col-xs-6">
									</div>
								</div>

								<div class="form-group boxReminderSms">
									<label class="col-lg-3 col-md-4 control-label"><?php __('opt_o_reminder_sms_message') ?></label>

									<div class="col-lg-9 col-md-8">
										<?php
										foreach ($tpl['lp_arr'] as $v)
										{
											?>
											<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 0 ? 'none' : NULL; ?>">
												<textarea name="i18n[<?php echo $v['id']; ?>][o_reminder_sms_message]" class="form-control" rows="10"><?php echo htmlspecialchars(stripslashes(@$tpl['arr']['i18n'][$v['id']]['o_reminder_sms_message'])); ?></textarea>
												<?php if ($tpl['is_flag_ready']) : ?>
												<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
												<?php endif; ?>
											</div>
											<?php
										}
										?>
									</div>
								</div>
							</div>

							<div class="col-lg-4 boxReminderSms">
								<h3 class="m-b-md"><?php __('plugin_base_available_tokens') ?>:</h3>

								<div class="row">
									<?php echo __('opt_o_reminder_body_text') ?>
								</div>
							</div>
						</div>

						<div class="hr-line-dashed"></div>

						<div class="clearfix">
							<button type="submit" class="ladda-button btn btn-primary btn-lg pull-left btn-phpjabbers-loader" data-style="zoom-in">
								<span class="ladda-label"><?php __('plugin_base_btn_save'); ?></span>
								<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
							</button>
						</div><!-- /.clearfix -->
					</form>
				</div>
			</div>
		</div><!-- /.col-lg-12 -->
		<?php
	}
	?>
</div>
<script type="text/javascript">
<?php if ($tpl['is_flag_ready']) : ?>
	var pjCmsLocale = pjCmsLocale || {};
	pjCmsLocale.langs = <?php echo $tpl['locale_str']; ?>;
	pjCmsLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
<?php endif; ?>
</script>