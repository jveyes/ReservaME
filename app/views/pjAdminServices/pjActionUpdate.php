<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-lg-9 col-md-8 col-sm-6">
                <h2><?php echo @$titles['AS10'];?></h2>
                <ol class="breadcrumb">
					<li><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminServices&amp;action=pjActionIndex"><?php __('menuServices'); ?></a></li>
					<li class="active">
						<strong><?php echo @$titles['AS10'];?></strong>
					</li>
				</ol>
            </div>
            <div class="col-lg-3 col-md-4 col-sm-6 btn-group-languages">
				<?php if ($tpl['is_flag_ready']) : ?>
				<div class="multilang"></div>
				<?php endif; ?>
			</div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AS09']; ?></p>
    </div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-12">
        <div class="ibox float-e-margins">
			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminServices&amp;action=pjActionUpdate" method="post" id="frmUpdateService" class="form pj-form" enctype="multipart/form-data">
				<input type="hidden" name="service_update" value="1" />
				<input type="hidden" name="id" value="<?php echo $tpl['arr']['id']; ?>" />
				<div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="form-group">
                                <label class="control-label"><?php __('service_status');?></label>

                                <div class="clearfix">
                                    <div class="switch onoffswitch-data pull-left">
                                        <div class="onoffswitch">
                                            <input type="checkbox" value="1" class="onoffswitch-checkbox" id="is_active" name="is_active"<?php echo $tpl['arr']['is_active'] == 1 ?' checked' : NULL; ?>>
                                            <label class="onoffswitch-label" for="is_active">
                                                <span class="onoffswitch-inner" data-on="<?php __('is_active_ARRAY_1', false, true); ?>" data-off="<?php __('is_active_ARRAY_0', false, true); ?>"></span>
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
                                <label class="control-label"><?php __('service_name');?></label>
								<?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][name]" value="<?php echo pjSanitize::html($tpl['arr']['i18n'][$v['id']]['name']); ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
                            </div>
                            <div class="form-group">
								<label class="control-label"><?php __('service_desc'); ?></label>
                                
                                <?php
								foreach ($tpl['lp_arr'] as $v)
								{
									?>
									<div class="<?php echo $tpl['is_flag_ready'] ? 'input-group ' : NULL;?>pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? NULL : 'none'; ?>">
										<textarea class="form-control mceEditor" name="i18n[<?php echo $v['id']; ?>][description]" cols="30" rows="10" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>"><?php echo pjSanitize::html($tpl['arr']['i18n'][$v['id']]['description']); ?></textarea>	
										<?php if ($tpl['is_flag_ready']) : ?>
										<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
										<?php endif; ?>
									</div>
									<?php 
								}
								?>
							</div>
							<div class="form-group">
								<label class="control-label"><?php __('service_image'); ?></label>
								<br/>
								<?php
								if (!empty($tpl['arr']['image']) && is_file($tpl['arr']['image']))
								{
									?>
									<div class="pj-user-thumb">
										<p class="m-b-md">
											<img src="<?php echo PJ_INSTALL_URL . $tpl['arr']['image'];?>" alt="" class="pj-scale">
										</p>
										<p class="m-b-md">
											<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminServices&amp;action=pjActionDeleteImage&amp;id=<?php echo $tpl['arr']['id'];?>" rev="<?php echo $tpl['arr']['id']; ?>" class="btn btn-xs btn-danger btn-outline btn-file pj-delete-thumb"><i class="fa fa-trash"></i> <?php __('btn_delete_image');?></a>
										</p>
									</div>
									<?php
								}
								?>
	                    		<div class="fileinput fileinput-new" data-provides="fileinput">
									<span class="btn btn-primary btn-outline btn-file">
										<span class="fileinput-new"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_select_image'); ?></span>
										<span class="fileinput-exists"><i class="fa fa-upload m-r-xs"></i> <?php __('btn_change_image'); ?></span>
										<input type="file" name="image">
									</span>
									<span class="fileinput-filename"></span>
									<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">×</a>
								</div>
							</div>
                        </div>
                        <div class="col-md-6">
							<div class="row">
								<div class="col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('service_price'); ?></label>

										<div class="input-group">
											<input type="text" name="price" id="price" value="<?php echo number_format($tpl['arr']['price'], 2, ".", ""); ?>" class="form-control required number text-right" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />

											<span class="input-group-addon"><?php echo pjCurrency::getCurrencySign($tpl['option_arr']['o_currency'], false); ?></span>
										</div>
									</div>
								</div>

								<div class="col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('service_employees'); ?></label>

										<select name="employee_id[]" class="select-item form-control" multiple>
											<?php
											foreach ($tpl['employee_arr'] as $employee)
											{
												?><option value="<?php echo $employee['id']; ?>"<?php echo in_array($employee['id'], $tpl['es_arr']) ? ' selected="selected"' : NULL; ?>><?php echo pjSanitize::html($employee['name']); ?></option><?php
											}
											?>
										</select>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="control-label"><?php __('service_length'); ?></label>
                                            
								<div class="row">
									<div class="col-sm-6">
										<input type="text" name="length" id="length" value="<?php echo $tpl['arr']['length_unit'] == 'hour' ? (int) $tpl['arr']['length'] / 60 : (int) $tpl['arr']['length']; ?>" class="touchspinLength form-control required" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
									</div>
									<div class="col-sm-6">
										<div class="radio radio-inline">
                                          	<input type="radio" name="length_unit" id="length_unit_minute" value="minute"<?php echo $tpl['arr']['length_unit'] == 'minute' ?' checked' : NULL; ?>>
                                          	<label for="length_unit_minute"><?php __('lblMinutes', false, true);?></label>
                                        </div>
                                        <div class="radio radio-inline">
                                          	<input type="radio" name="length_unit" id="length_unit_hour" value="hour"<?php echo $tpl['arr']['length_unit'] == 'hour' ?' checked' : NULL; ?>>
                                          	<label for="length_unit_hour"><?php __('lblHours', false, true);?></label>
                                        </div>
                                        <span class="service-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("service_tip_length", false, true) ?>"><i class="fa fa-info-circle"></i></span>
									</div>	
								</div>
							</div>

							<div class="form-group">
								<label class="control-label"><?php __('service_before'); ?></label>
                                            
								<div class="row">
									<div class="col-sm-6">
										<input type="text" name="before" id="before" value="<?php echo $tpl['arr']['before_unit'] == 'hour' ? (int) $tpl['arr']['before'] / 60 : $tpl['arr']['before']; ?>" class="touchspin3 form-control" value="0" />
									</div>
									<div class="col-sm-6">
										<div class="radio radio-inline">
                                          	<input type="radio" name="before_unit" id="before_unit_minute" value="minute"<?php echo $tpl['arr']['before_unit'] == 'minute' ?' checked' : NULL; ?>>
                                          	<label for="before_unit_minute"><?php __('lblMinutes', false, true);?></label>
                                        </div>
                                        <div class="radio radio-inline">
                                          	<input type="radio" name="before_unit" id="before_unit_hour" value="hour"<?php echo $tpl['arr']['before_unit'] == 'hour' ?' checked' : NULL; ?>>
                                          	<label for="before_unit_hour"><?php __('lblHours', false, true);?></label>
                                        </div>
                                        <span class="service-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("service_tip_before", false, true) ?>"><i class="fa fa-info-circle"></i></span>
									</div>
								</div>
							</div>

							<div class="form-group">
								<label class="control-label"><?php __('service_after'); ?></label>
                                            
								<div class="row">
									<div class="col-sm-6">
										<input type="text" name="after" id="after" value="<?php echo $tpl['arr']['after_unit'] == 'hour' ? (int) $tpl['arr']['after'] / 60 : $tpl['arr']['after']; ?>" class="touchspin3 form-control" value="0" />
									</div>
									<div class="col-sm-6">
										<div class="radio radio-inline">
                                          	<input type="radio" name="after_unit" id="after_unit_minute" value="minute"<?php echo $tpl['arr']['after_unit'] == 'minute' ?' checked' : NULL; ?>>
                                          	<label for="after_unit_minute"><?php __('lblMinutes', false, true);?></label>
                                        </div>
                                        <div class="radio radio-inline">
                                          	<input type="radio" name="after_unit" id="after_unit_hour" value="hour"<?php echo $tpl['arr']['after_unit'] == 'hour' ?' checked' : NULL; ?>>
                                          	<label for="after_unit_hour"><?php __('lblHours', false, true);?></label>
                                        </div>
                                        <span class="service-tooltip" data-toggle="tooltip" data-placement="top" title="<?php __("service_tip_after", false, true) ?>"><i class="fa fa-info-circle"></i></span>
									</div>
								</div>
							</div>
							<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('infoServiceExample');?></p>
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
				</div>
			</form>
		</div>
	</div>
</div>

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.positiveNumber = "<?php __('positive_number', false, true); ?>";
myLabel.alert_title = <?php x__encode('employee_avatar_dtitle');?>;
myLabel.alert_text = <?php x__encode('employee_avatar_dbody');?>;
myLabel.btn_delete = <?php x__encode('btnDelete'); ?>;
myLabel.btn_cancel = <?php x__encode('btnCancel'); ?>;
myLabel.isFlagReady = "<?php echo $tpl['is_flag_ready'] ? 1 : 0;?>";
myLabel.choose = "<?php __('lblChoose', false, true); ?>";
<?php if ($tpl['is_flag_ready']) : ?>
	var pjLocale = pjLocale || {};
	pjLocale.langs = <?php echo $tpl['locale_str']; ?>;
	pjLocale.flagPath = "<?php echo PJ_FRAMEWORK_LIBS_PATH; ?>pj/img/flags/";
<?php endif; ?>
</script>