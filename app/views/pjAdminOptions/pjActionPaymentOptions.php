<?php
$payment_method = $controller->_get->toString('payment_method');
?>
<form id="frmPaymentOptions" action="?" method="post" class="form-horizontal">
	<input type="hidden" id="options_update" name="options_update" value="1"/>
	<input type="hidden" id="payment_method" name="payment_method" value="<?php echo $payment_method;?>"/>           	
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only"><?php __('plugin_base_btn_close');?></span></button>
		
		<div class="modal-image">
			<span class="payment active">
				<img src="<?php echo PJ_IMG_PATH?>backend/payments/<?php echo $payment_method?>.png">
			</span>
		</div><!-- /.modal-image -->
		<?php
		if($payment_method == 'cash')
		{ 
			?>
			<div class="modal-text">
				<p><?php __('plugin_carrental_cash_payment_text');?></p>
			</div>
			<?php
		}
		if($payment_method == 'bank')
		{
			?>
			<div class="modal-text">
				<p><?php __('plugin_carrental_bank_payment_text');?></p>
			</div>
			<?php
		} 
		?>
	</div>

	<div class="modal-body">
		<?php
		if(!in_array($payment_method, array('bank', 'cash')))
		{
			$pjPlugin = pjPayments::getPluginName($payment_method);
			if(pjObject::getPlugin($pjPlugin) !== NULL)
			{
				$controller->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionOptions', 'params' => array('foreign_id' => NULL, 'fid' => $controller->getForeignId())));
			}
		}else{
			if($payment_method == 'cash')
			{
				?>
				<div class="form-group">
					<label class="control-label col-lg-4"><?php __('opt_o_allow_cash'); ?></label>
					
					<div class="col-lg-8">
						<div class="switch m-t-xs">
							<div class="onoffswitch onoffswitch-data">
								<input id="payment_is_active" name="o_allow_cash" value="<?php echo @$tpl['option_arr']['o_allow_cash'] == '1' ? '1' : '0';?>"  type="hidden" />
								<input class="onoffswitch-checkbox" id="enablePayment" name="enablePayment" type="checkbox"<?php echo @$tpl['option_arr']['o_allow_cash'] == '1' ? ' checked="checked"' : NULL; ?>>
								<label class="onoffswitch-label" for="enablePayment">
									<span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span>
									<span class="onoffswitch-switch"></span>
								</label>
							</div>
						</div>
					</div><!-- /.col-lg-4 -->
				</div><!-- /.form-group -->
				<div class="hidden-area" style="display: <?php echo $tpl['option_arr']['o_allow_cash'] == '1' ? 'block' : 'none'; ?>">
					<?php
					foreach ($tpl['lp_arr'] as $v)
					{
						?>
						<div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? 'block' : 'none'; ?>">
							<label class="control-label col-lg-4"><?php __('plugin_paypal_payment_label'); ?></label>
							<div class="col-lg-8">
								<div class="input-group">
									<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][cash]" value="<?php echo pjSanitize::html(@$tpl['i18n'][$v['id']]['cash']); ?>">
									<?php if ($tpl['is_flag_ready']) : ?>
									<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
									<?php endif; ?>
								</div>
							</div>
						</div>
						<?php 
					}
					?>
				</div>
				<?php
			}
			if($payment_method == 'bank')
			{
				?>
				<div class="form-group">
					<label class="control-label col-lg-4"><?php __('opt_o_allow_bank'); ?></label>
					
					<div class="col-lg-8">
						<div class="switch m-t-xs">
							<div class="onoffswitch onoffswitch-data">
								<input id="payment_is_active" name="o_allow_bank" value="<?php echo @$tpl['option_arr']['o_allow_bank'] == '1' ? '1' : '0';?>"  type="hidden" />
								<input class="onoffswitch-checkbox" id="enablePayment" name="enablePayment" type="checkbox"<?php echo @$tpl['option_arr']['o_allow_bank'] == '1' ? ' checked="checked"' : NULL; ?>>
								<label class="onoffswitch-label" for="enablePayment">
									<span class="onoffswitch-inner" data-on="<?php __('_yesno_ARRAY_T', false, true);?>" data-off="<?php __('_yesno_ARRAY_F', false, true);?>"></span>
									<span class="onoffswitch-switch"></span>
								</label>
							</div>
						</div>
					</div><!-- /.col-lg-4 -->
				</div><!-- /.form-group -->
				<div class="hidden-area" style="display: <?php echo $tpl['option_arr']['o_allow_bank'] == '1' ? 'block' : 'none'; ?>">
					<?php
					foreach ($tpl['lp_arr'] as $v)
					{
						?>
						<div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? 'block' : 'none'; ?>">
							<label class="control-label col-lg-4"><?php __('plugin_paypal_payment_label'); ?></label>
							<div class="col-lg-8">
								<div class="input-group">
									<input type="text" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>" name="i18n[<?php echo $v['id']; ?>][bank]" value="<?php echo pjSanitize::html(@$tpl['i18n'][$v['id']]['bank']); ?>">
									<?php if ($tpl['is_flag_ready']) : ?>
									<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
									<?php endif; ?>
								</div>
							</div>
						</div>
						<?php 
					}
					?>
				</div>
                <div class="hidden-area" style="display: <?php echo $tpl['option_arr']['o_allow_bank'] == '1' ? 'block' : 'none'; ?>">
					<?php
					foreach ($tpl['lp_arr'] as $v)
					{
						?>
						<div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? 'block' : 'none'; ?>">
							<label class="control-label col-lg-4"><?php __('opt_o_bank_account'); ?></label>
							<div class="col-lg-8">
								<div class="input-group">
                                    <textarea name="i18n_options[<?php echo $v['id']; ?>][o_bank_account]" class="form-control<?php echo (int) $v['is_default'] === 0 ? NULL : ' required'; ?>"><?php echo htmlspecialchars(stripslashes(@$tpl['i18n_options'][$v['id']]['o_bank_account'])); ?></textarea>
									<?php if ($tpl['is_flag_ready']) : ?>
									<span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
									<?php endif; ?>
								</div>
							</div>
						</div>
						<?php
					}
					?>
				</div>
				<?php
			}
		} 
		?>
	</div>

	<div class="modal-footer">
		<button type="button" class="btn btn-white" data-dismiss="modal"><?php __('plugin_base_btn_close');?></button>
		<button type="button" class="btn btn-primary" id="btnSavePaymentOptions"><?php __('plugin_base_btn_save');?></button>
	</div>
</form>