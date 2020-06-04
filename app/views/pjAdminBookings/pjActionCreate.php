<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php echo @$titles['ABK10']; ?></h2>
			</div>
		</div>

		<p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['ABK10']; ?></p>
	</div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-9">
		<div class="tabs-container tabs-reservations m-b-lg">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#booking-details" aria-controls="booking-details" role="tab" data-toggle="tab" aria-expanded="true"><?php __('booking_tab_details'); ?></a></li>
				<li role="presentation" class=""><a href="#client-details" aria-controls="client-details" role="tab" data-toggle="tab" aria-expanded="false"><?php __('booking_tab_client'); ?></a></li>
			</ul>

			<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" method="post" id="frmCreateBooking" class="form pj-form frmBooking">
				<input type="hidden" name="booking_create" value="1" />
				<input type="hidden" name="tmp_hash" value="<?php echo $tpl['tmp_hash']; ?>" />
				<input type="hidden" name="booking_price" id="booking_price" >
				<input type="hidden" name="booking_tax" id="booking_tax" >
				<input type="hidden" name="booking_total" id="booking_total" >
				<input type="hidden" name="booking_deposit" id="booking_deposit" >
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="booking-details">
						<div class="panel-body">
							<div class="row">
                            	<div class="col-lg-4 col-md-4 col-sm-6">
                                    <div class="form-group">
                                        <label class="control-label"><?php __('booking_uuid'); ?></label>
    
                                        <input type="text" name="uuid" id="uuid" class="form-control required" value="<?php echo pjUtil::uuid(); ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" maxlength="12"/>
                                    </div>
                                </div><!-- /.col-md-3 -->
                                <div class="col-lg-4 col-md-4 col-sm-6">
                                    <div class="form-group">
										<label class="control-label"><?php __('booking_status'); ?></label>
                                                    
										<select name="booking_status" id="booking_status" class="form-control required" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
											<?php
											foreach (__('booking_statuses', true) as $k => $v)
											{
												?><option value="<?php echo $k; ?>"<?php echo $k == 'pending' ? ' selected="selected"': NULL; ?>><?php echo $v; ?></option><?php
											}
											?>
										</select>
									</div>
                                </div><!-- /.col-md-3 -->
    
    							<div class="col-lg-4 col-md-4 col-sm-6">
                                    <?php
                                    $plugins_payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentMethods(): array();
                                    $haveOnline = $haveOffline = false;
                                    foreach ($tpl['payment_titles'] as $k => $v)
                                    {
                                    	if($k == 'creditcard') continue;
                                    	if (array_key_exists($k, $plugins_payment_methods))
                                    	{
                                    		if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
                                    		{
                                    			continue;
                                    		}
                                    	}else if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '0') || $k == 'cash' || $k == 'bank' ){
                                    		continue;
                                    	}
                                    	$haveOnline = true;
                                    	break;
                                    }
                                    foreach ($tpl['payment_titles'] as $k => $v)
                                    {
                                    	if($k == 'creditcard') continue;
                                    	if( $k == 'cash' || $k == 'bank' )
                                    	{
                                    		if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '1'))
                                    		{
                                    			$haveOffline = true;
                                    			break;
                                        	}
                                    	}
									}
                                    ?>
                                    <div class="form-group">
                                        <label class="control-label"><?php __('booking_payment_method') ?></label>

                                        <select name="payment_method" id="payment_method" class="form-control<?php echo $tpl['option_arr']['o_disable_payments'] != '1' ? ' required' : NULL; ?>" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>">
                                            <option value="">-- <?php __('plugin_base_choose'); ?> --</option>
                                            <?php 
                                            if ($haveOnline && $haveOffline)
                                            {
	                                            ?><optgroup label="<?php __('script_online_payment_gateway', false, true); ?>"><?php 
                                            }
                                            ?>
	                                                <?php
	                                                foreach ($tpl['payment_titles'] as $k => $v)
	                                                {
	                                                    if($k == 'creditcard') continue;
	                                                    if (array_key_exists($k, $plugins_payment_methods))
	                                                    {
	                                                        if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
	                                                        {
	                                                            continue;
	                                                        }
	                                                    }else if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '0') || $k == 'cash' || $k == 'bank' ){
	                                                        continue;
	                                                    }
	                                                    ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
	                                                }
	                                                ?>
                                            <?php
                                            if ($haveOnline && $haveOffline)
                                            {
                                            	?>
                                            	</optgroup>
                                            	<optgroup label="<?php __('script_offline_payment', false, true); ?>">
                                            	<?php 
                                            }
                                            ?>
	                                                <?php
	                                                foreach ($tpl['payment_titles'] as $k => $v)
	                                                {
	                                                    if($k == 'creditcard') continue;
	                                                    if( $k == 'cash' || $k == 'bank' )
	                                                    {
	                                                        if( (isset($tpl['option_arr']['o_allow_'.$k]) && $tpl['option_arr']['o_allow_'.$k] == '1'))
	                                                        {
	                                                            ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
	                                                        }
	                                                    }
	                                                }
	                                                ?>
                                            <?php
                                            if ($haveOnline && $haveOffline)
                                            {
                                            	?></optgroup><?php 
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div><!-- /.col-md-3 -->
    						</div>
    						
    						<div class="hr-line-dashed"></div>
    						
							<div class="m-b-md">
								<a href="#" class="btn btn-primary btn-outline m-t-xs item-add" data-toggle="modal" data-target="#modalAddItem"><i class="fa fa-plus"></i> <?php __('booking_service_add'); ?></a>
							</div>
	
							<div class="row">
								<div class="col-lg-12 has-error">
									<div id="boxBookingItems"></div>
									<input type="hidden" name="booking_items" value=""/>
								</div>
							</div>
	
							<div class="hr-line-dashed"></div>
	
							<div class="clearfix">
								<button class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
									<span class="ladda-label"><?php __('btnSave'); ?></span>
									<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>   
								</button>
	
								<button class="btn btn-white btn-lg pull-right" type="button" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
							</div>
						</div>
					</div>

					<div role="tabpanel" class="tab-pane" id="client-details">
						<div class="panel-body">
							<div class="row">
								<div class="col-md-8 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_name'); ?></label>

										<input type="text" name="c_name" id="c_name" class="form-control required" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" />
									</div>
								</div>

								<div class="col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_email'); ?></label>

										<input type="text" name="c_email" id="c_email" class="form-control email required" data-msg-required="<?php __('plugin_base_this_field_is_required', false, true);?>" data-msg-email="<?php __('plugin_base_email_invalid', false, true);?>"/>
									</div>
								</div>

								<div class="col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_phone'); ?></label>

										<input class="form-control" type="text" name="c_phone" id="c_phone" class="form-control">
									</div>
								</div>
								
								<div class="col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_address_1'); ?></label>

										<input type="text" name="c_address_1" id="c_address_1" class="form-control" />
									</div>
								</div>

								<div class="col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_address_2'); ?></label>

										<input type="text" name="c_address_2" id="c_address_2" class="form-control" />
									</div>
								</div>
							</div>

							<div class="hr-line-dashed"></div>

							<div class="row">
								<div class="col-lg-3 col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_country'); ?></label>

										<select name="c_country_id" id="c_country_id" class="form-control select-countries">
											<option value=""><?php __('booking_choose'); ?></option>
											<?php
											foreach ($tpl['country_arr'] as $country)
											{
												?><option value="<?php echo $country['id']; ?>"><?php echo pjSanitize::html($country['name']); ?></option><?php
											}
											?>
										</select>
									</div>
								</div>

								<div class="col-lg-3 col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_state'); ?></label>

										<input type="text" name="c_state" id="c_state" class="form-control" />
									</div>
								</div>

								<div class="col-lg-3 col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_city'); ?></label>

										<input type="text" name="c_city" id="c_city" class="form-control" />
									</div>
								</div>

								<div class="col-lg-3 col-md-4 col-sm-6">
									<div class="form-group">
										<label class="control-label"><?php __('booking_zip'); ?></label>

										<input type="text" name="c_zip" id="c_zip" class="form-control" />
									</div>
								</div>
							</div>

							<div class="hr-line-dashed"></div>
							
							<div class="row">
								<div class="col-lg-12">
									<div class="form-group">
										<label class="control-label"><?php __('booking_notes'); ?></label>
	
										<textarea name="c_notes" id="c_notes" class="form-control" cols="30" rows="10"></textarea>
									</div>
								</div>
							</div>
	
							<div class="hr-line-dashed"></div>

							<div class="clearfix">
								<button class="ladda-button btn btn-primary btn-lg btn-phpjabbers-loader pull-left" data-style="zoom-in">
									<span class="ladda-label"><?php __('btnSave'); ?></span>
									<?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>   
								</button>
	
								<button class="btn btn-white btn-lg pull-right" type="button" onclick="window.location.href='<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjAdminBookings&action=pjActionIndex';"><?php __('btnCancel'); ?></button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="col-lg-3">
        <div class="m-b-lg">
            <div id="pjFdPriceWrapper" class="panel no-borders ibox-content">
            	<div class="sk-spinner sk-spinner-double-bounce"><div class="sk-double-bounce1"></div><div class="sk-double-bounce2"></div></div>
            	<?php 
            	foreach(__('booking_statuses', true) as $k => $status) 
            	{
	            	?>
	                <div class="panel-heading bg-status bg-<?php echo $k; ?>"<?php echo $k == 'pending' ? '' : ' style="display:none"'; ?>>
	                    <p class="lead m-n"><i class="fa fa-check"></i> <?php __('booking_status'); ?>: <span class="pull-right status-text"><?php echo $status; ?></span></p>    
	                </div>
	                <?php 
            	}
            	?>

                <div class="panel-body">
                    <p class="lead m-b-md"><?php __('booking_price'); ?>: <span id="price_format" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
                    <p class="lead m-b-md"><?php __('booking_tax'); ?>: <span id="tax_format" class="pull-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>

                    <div class="hr-line-dashed"></div>

                    <h3 class="lead m-b-md"><?php __('booking_total'); ?>: <strong id="total_format" class="pull-right text-right"><?php echo pjCurrency::formatPrice(0); ?></strong></h3>
                    <p class="lead m-b-md"><?php __('booking_deposit'); ?>: <span id="deposit_format" class="pull-right text-right"><?php echo pjCurrency::formatPrice(0); ?></span></p>
                </div><!-- /.panel-body -->
            </div>

        </div><!-- /.m-b-lg -->
    </div>
</div>
        
<div class="modal inmodal fade" id="modalAddItem" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>
		
<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.uuid_used = "<?php __('uuid_used', false, true); ?>";
myLabel.choose = "<?php __('booking_choose'); ?>";
myLabel.services_required = "<?php __('services_required', false, true); ?>";
myLabel.service_delete_title = "<?php __('booking_service_delete_title', false, true); ?>";
myLabel.service_delete_body = "<?php __('booking_service_delete_body', false, true); ?>";
myLabel.btn_delete = "<?php __('btnDelete', false, true); ?>";
myLabel.btnCancel = "<?php __('btnCancel', false, true); ?>";
myLabel.months = "<?php echo implode("_", $months);?>";
myLabel.days = "<?php echo implode("_", $short_days);?>";
</script>