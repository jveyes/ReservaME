<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo @$titles['AE09'];?></h2>
                <ol class="breadcrumb">
					<li><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionIndex"><?php __('menuEmployees'); ?></a></li>
					<li class="active">
						<strong><?php echo @$titles['AE09'];?></strong>
					</li>
				</ol>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
				<?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
			</div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AE09']; ?></p>
    </div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionCreate" method="post" id="frmCreateEmployee" class="form pj-form" autocomplete="off" enctype="multipart/form-data">
				<input type="hidden" name="employee_create" value="1" />
            	<div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_status');?></label>

                                <div class="clearfix">
                                    <div class="switch onoffswitch-data pull-left">
                                        <div class="onoffswitch">
                                            <input type="checkbox" value="T" class="onoffswitch-checkbox" id="is_active" name="is_active" checked>
                                            <label class="onoffswitch-label" for="is_active">
                                                <span class="onoffswitch-inner" data-on="<?php __('is_active_ARRAY_1', false, true); ?>" data-off="<?php __('is_active_ARRAY_0', false, true); ?>"></span>
                                                <span class="onoffswitch-switch"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_is_subscribed');?></label>

                                <div class="clearfix">
                                    <div class="switch onoffswitch-data pull-left">
                                        <div class="onoffswitch">
                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="is_subscribed" name="is_subscribed" checked>
                                            <label class="onoffswitch-label" for="is_subscribed">
                                                <span class="onoffswitch-inner" data-on="<?php __('plugin_base_yesno_ARRAY_T', false, true); ?>" data-off="<?php __('plugin_base_yesno_ARRAY_F', false, true); ?>"></span>
                                                <span class="onoffswitch-switch"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_is_subscribed_sms');?></label>

                                <div class="clearfix">
                                    <div class="switch onoffswitch-data pull-left">
                                        <div class="onoffswitch">
                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="is_subscribed_sms" name="is_subscribed_sms">
                                            <label class="onoffswitch-label" for="is_subscribed_sms">
                                                <span class="onoffswitch-inner" data-on="<?php __('plugin_base_yesno_ARRAY_T', false, true); ?>" data-off="<?php __('plugin_base_yesno_ARRAY_F', false, true); ?>"></span>
                                                <span class="onoffswitch-switch"></span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
					</div>
					<div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_name');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][name]" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
						</div>
						<div class="col-sm-6">
							<div class="form-group">
								<label class="control-label"><?php __('employee_services'); ?></label>

								<select name="service_id[]" class="select-item form-control" multiple>
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
					
					<div class="hr-line-dashed"></div>
					
					<div class="row">
						<div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_email');?></label>

                                <div class="input-group">
    								<span class="input-group-addon"><i class="fa fa-at"></i></span>
    								<input type="text" name="email" id="email" class="form-control required email" maxlength="255" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-email="<?php __('plugin_base_email_invalid', false, true);?>" data-msg-remote="<?php __('plugin_base_email_in_used', false, true);?>">
    							</div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_password');?></label>

                                <div class="input-group">
    								<span class="input-group-addon"><i class="fa fa-lock"></i></span> 
    								<input type="text" name="password" id="password" class="form-control required" maxlength="100" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
    							</div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_phone');?></label>

                                <div class="input-group">
    								<span class="input-group-addon"><i class="fa fa-phone"></i></span> 
    								<input type="text" name="phone" id="phone" class="form-control" maxlength="255">
    							</div>
                            </div>
                        </div>
                        
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('employee_company');?></label>

                                <?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control" name="i18n[<?php echo $v['id']; ?>][company]" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
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
					<div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
								<label class="control-label"><?php __('employee_notes'); ?></label>
                                
								<textarea class="form-control" name="notes" cols="30" rows="10" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>"></textarea>	
							</div>
                        </div>
                    	<div class="col-md-6">
                    		<div class="form-group">
								<label class="control-label"><?php __('employee_avatar'); ?></label>
								<br/>
	                    		<div class="fileinput fileinput-new" data-provides="fileinput">
									<span class="btn btn-primary btn-outline btn-file">
										<span class="fileinput-new"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_select_image'); ?></span>
										<span class="fileinput-exists"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_change_image'); ?></span>
										<input type="file" name="avatar">
									</span>
									<span class="fileinput-filename"></span>
									<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
								</div>
							</div>
						</div>
					</div>
            	</div>
            	
				<div class="hr-line-dashed"></div>
                    
				<div class="clearfix">
					<button type="submit" class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
						<span class="ladda-label"><?php __('btnSave', false, true); ?></span>
						<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
					</button>

					<button type="button" class="btn btn-white btn-lg pull-right" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminServices&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
				</div>
			</form>
        </div>
    </div>
</div>

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.email_taken = "<?php __('vr_email_taken', false, true); ?>";
myLabel.invalid_password_title = <?php x__encode('plugin_base_invalid_password_title'); ?>;
myLabel.btn_ok = <?php x__encode('plugin_base_btn_ok'); ?>;
myLabel.isFlagReady = "<?php echo $tpl['is_flag_ready'] ? 1 : 0;?>";
myLabel.choose = "<?php __('lblChoose', false, true); ?>";
<?php if ($tpl['is_flag_ready']) : ?>
	var pjLocale = pjLocale || {};
	pjLocale.langs = <?php echo $tpl['locale_str']; ?>;
	pjLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
<?php endif; ?>
</script>