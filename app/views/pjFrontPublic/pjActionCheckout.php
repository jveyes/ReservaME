<div class="panel-heading pjAsHead">
	<img src="https://citas.jmvb.co/wp-content/uploads/2020/05/SuLogotipo.png" alt="" class="img-responsive center-block">
</div><!-- /.panel-heading pjAsHead -->

<div class="container-fluid">
	<div class="panel panel-default pjAsContainer">
		<?php
		if (isset($tpl['status']) && $tpl['status'] == 'OK')
		{
			$FORM = @$_SESSION[$controller->defaultForm];
			$cart = $tpl['cart'];
			$cart_arr = $tpl['cart_arr'];
			end($cart);
			$key = key($cart);
			reset($cart);
			
			list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
			list($year, $month, $day) = explode("-", $date);
			
			$back_url = '';
			
			$get_cid = (int) pjObject::escapeString($controller->_get->toInt('cid'));
			?>
			<div class="panel-heading pjAsHead">
				<div class="row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<?php
						$slug = NULL;
						if($controller->_get->toString('layout') == '1')
						{
							if ((int) $tpl['option_arr']['o_seo_url'] === 1)
							{
								$slug = sprintf("%s/%s/%s/%s/%s-%u/%s-%u.html", 'Employee', $year, $month, $day, $controller->friendlyURL($cart_arr[$service_id]['employee_arr'][$employee_id]['name']), $employee_id, $controller->friendlyURL($cart_arr[$service_id]['name']), $service_id);
							}
							$back_url = '<a href="#" class="btn btn-default pjAsBtn pjAsBtnSecondary pjAsBackToEmployee" data-iso="'.$date.'" data-eid="'.$employee_id.'" data-sid="'.$service_id.'" data-slug="'.$slug.'">' . __('btnCancel', true) . '</a>';
							?>
							<a href="#" class="btn btn-link pjAsBtnBack pjAsBackToEmployee" data-iso="<?php echo $date;?>" data-eid="<?php echo $employee_id; ?>" data-sid="<?php echo $service_id; ?>" data-slug="<?php echo $slug;?>">
								<i class="fa fa-angle-double-left"></i> <?php __('front_back');?>
							</a>
							<?php
						}else{	
							if ((int) $tpl['option_arr']['o_seo_url'] === 1)
							{
								$slug = sprintf("%s/%s/%s/%s/%s-%u/%s-%u.html", 'Service', $year, $month, $day, $controller->friendlyURL($cart_arr[$service_id]['name']), $service_id, $controller->friendlyURL($cart_arr[$service_id]['employee_arr'][$employee_id]['name']), $employee_id);
							}
							$back_url = '<a href="#" class="btn btn-default pjAsBtn pjAsBtnSecondary pjAsBackToService" data-iso="'.$date.'" data-eid="'.$employee_id.'" data-sid="'.$service_id.'" data-slug="'.$slug.'">' . __('btnCancel', true) . '</a>';
							?>
							<a href="#" class="btn btn-link pjAsBtnBack pjAsBackToService" data-iso="<?php echo $date;?>" data-eid="<?php echo $employee_id; ?>" data-sid="<?php echo $service_id; ?>" data-slug="<?php echo $slug;?>">
								<i class="fa fa-angle-double-left"></i> <?php __('front_back');?>
							</a>
							<?php
						} 
						?>
					</div>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<?php include PJ_VIEWS_PATH . 'pjFrontEnd/elements/locale.php';?>
					</div>
				</div><!-- /.row -->
			</div><!-- /.panel-heading pjAsHead -->
			
			<?php include PJ_VIEWS_PATH . 'pjFrontPublic/elements/cart.php';  ?>
			
			<div class="panel-body pjAsBody pjAsCheckout">
				<div class="clearfix">
					<h3 class="pull-left text-uppercase pjAsSectionTotal"><?php __('single_price');?></h3><!-- /.pull-left text-uppercase pjAsSectionTotal -->

					<h3 class="pull-right text-uppercase pjAsSectionPrice">
						<strong><?php echo "$ "; echo pjCurrency::formatPrice($tpl['summary']['price']);?></strong>
					</h3><!-- /.pull-right text-uppercase pjAsSectionPrice -->
				</div><!-- /.clearfix -->
				<?php 
				if ($tpl['summary']['tax'] > 0)
				{
					?>
					<div class="clearfix">
						<h3 class="pull-left text-uppercase pjAsSectionTotal"><?php __('front_tax');?> (<?php echo $tpl['option_arr']['o_tax'];?>%)</h3><!-- /.pull-left text-uppercase pjAsSectionTotal -->
	
						<h3 class="pull-right text-uppercase pjAsSectionPrice">
							<strong><?php echo "$ "; echo pjCurrency::formatPrice($tpl['summary']['tax']);?></strong>
						</h3><!-- /.pull-right text-uppercase pjAsSectionPrice -->
					</div><!-- /.clearfix -->
					<?php 
				}
				?>
				<div class="clearfix">
					<h3 class="pull-left text-uppercase pjAsSectionTotal"><?php __('front_total');?></h3><!-- /.pull-left text-uppercase pjAsSectionTotal -->

					<h3 class="pull-right text-uppercase pjAsSectionPrice">
						<strong><?php echo "$ "; echo pjCurrency::formatPrice($tpl['summary']['total']);?></strong>
					</h3><!-- /.pull-right text-uppercase pjAsSectionPrice -->
				</div><!-- /.clearfix -->
				<div class="clearfix">
					<!-- <h3 class="pull-left text-uppercase pjAsSectionTotal"><?php __('front_deposit');?><?php echo $tpl['option_arr']['o_deposit_type'] == 'percent' ? ' ('.$tpl['option_arr']['o_deposit'].'%)' : NULL;?></h3><!-- /.pull-left text-uppercase pjAsSectionTotal -->

                    <!--
					<h3 class="pull-right text-uppercase pjAsSectionPrice">
						<strong><?php echo pjCurrency::formatPrice($tpl['summary']['deposit']);?></strong>
					</h3><!-- /.pull-right text-uppercase pjAsSectionPrice -->
				</div><!-- /.clearfix -->
				
				<h3 class="text-uppercase pjAsSectionTitle"><?php __('front_booking_form');?>:</h3><!-- /.pull-left text-uppercase pjAsSectionTitle -->
				
				<div class="form-horizontal">
					<form role="form" data-toggle="validator" method="post" action="" novalidate="true" class="asSelectorCheckoutForm">
						<input type="hidden" name="as_checkout" value="1" />
						<?php if (in_array((int) $tpl['option_arr']['o_bf_name'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_name'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_name'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_name'] === 3 ? ' required' : NULL; ?>" name="c_name"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_name']); ?>" data-msg-required="<?php __('co_v_name', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_email'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_email'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_email'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control email<?php echo (int) $tpl['option_arr']['o_bf_email'] === 3 ? ' required' : NULL; ?>" name="c_email"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_email']); ?>" data-msg-required="<?php __('co_v_email', false, true); ?>" data-msg-email="<?php __('co_v_email_inv', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_phone'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_phone'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_phone'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_phone'] === 3 ? ' required' : NULL; ?>" name="c_phone"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_phone']); ?>" data-msg-required="<?php __('co_v_phone', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_address_1'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_address_1'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_address_1'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_address_1'] === 3 ? ' required' : NULL; ?>" name="c_address_1"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_address_1']); ?>" data-msg-required="<?php __('co_v_address_1', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_address_2'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_address_2'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_address_2'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_address_2'] === 3 ? ' required' : NULL; ?>" name="c_address_2"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_address_2']); ?>" data-msg-required="<?php __('co_v_address_2', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_country'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_country'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_country'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<select name="c_country_id" class="form-control<?php echo (int) $tpl['option_arr']['o_bf_country'] === 3 ? ' required' : NULL; ?>" data-msg-required="<?php __('co_v_country', false, true); ?>">
									<option value="">-- <?php __('co_select_country'); ?> --</option>
									<?php
									foreach ($tpl['country_arr'] as $country)
									{
										?><option value="<?php echo $country['id']; ?>"<?php echo $country['id'] != @$FORM['c_country_id'] ? NULL : ' selected="selected"'; ?>><?php echo pjSanitize::html($country['name']); ?></option><?php
									}
									?>
								</select>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_state'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_state'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_state'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_state'] === 3 ? ' required' : NULL; ?>" name="c_state"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_state']); ?>" data-msg-required="<?php __('co_v_state', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_city'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_city'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_city'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_city'] === 3 ? ' required' : NULL; ?>" name="c_city"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_city']); ?>" data-msg-required="<?php __('co_v_city', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_zip'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_zip'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_zip'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input class="form-control<?php echo (int) $tpl['option_arr']['o_bf_zip'] === 3 ? ' required' : NULL; ?>" name="c_zip"  type="text" value="<?php echo pjSanitize::html(@$FORM['c_zip']); ?>" data-msg-required="<?php __('co_v_zip', false, true); ?>">
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_notes'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_notes'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_notes'] === 3) : ?><span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<textarea name="c_notes" class="form-control<?php echo (int) $tpl['option_arr']['o_bf_notes'] === 3 ? ' required' : NULL; ?>" cols="30" rows="10" data-msg-required="<?php __('co_v_notes', false, true); ?>"><?php echo pjSanitize::html(@$FORM['c_notes']); ?></textarea>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif;?>
						
						<?php if ((int) $tpl['option_arr']['o_disable_payments'] === 0 && !empty($tpl['option_arr']['o_deposit'])) : ?>
						
						
						<div class="form-group">
							
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label ">
								<?php __('booking_payment_method'); ?> 
								<!-- <span class="asterisk">*</span> -->
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
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
								<select name="payment_method" class="form-control required" data-msg-required="<?php __('co_v_payment', false, true); ?>" disabled>
									<option value=""> <?php __('front_select_payment'); ?> </option>
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
                                             ?><option value="<?php echo $k; ?>"<?php echo isset($FORM['payment_method']) && $FORM['payment_method']==$k ? ' selected="selected"' : NULL;?>><?php echo $v; ?></option><?php
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
                                                     ?><option value="<?php echo $k; ?>"<?php echo isset($FORM['payment_method']) && $FORM['payment_method']==$k ? ' selected="selected"' : NULL;?> selected><?php echo "En tienda"//$v; ?></option><?php
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
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorBank" style="display: <?php echo @$FORM['payment_method'] != 'bank' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_bank_account'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<?php echo pjSanitize::html($tpl['option_arr']['o_bank_account']); ?>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_cc_type'); ?> 
								<span class="asterisk">*</span>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<select name="cc_type" class="form-control" data-msg-required="<?php __('co_v_cc_type', false, true); ?>">
									<option value="">-- <?php __('front_select_cc_type'); ?> --</option>
									<?php
									foreach (__('booking_cc_types', true) as $k => $v)
									{
										?><option value="<?php echo $k; ?>"<?php echo @$FORM['cc_type'] != $k ? NULL : ' selected="selected"'; ?>><?php echo $v; ?></option><?php
									}
									?>
								</select>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_num'); ?> <span class="asterisk">*</span></label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input type="text" name="cc_num" class="form-control" value="<?php echo pjSanitize::html(@$FORM['cc_num']); ?>" autocomplete="off" data-msg-required="<?php __('co_v_cc_num', false, true); ?>" />
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_code'); ?> <span class="asterisk">*</span></label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<input type="text" name="cc_code" class="form-control" value="<?php echo pjSanitize::html(@$FORM['cc_code']); ?>" autocomplete="off" data-msg-required="<?php __('co_v_cc_code', false, true); ?>" />
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_exp'); ?> <span class="asterisk">*</span></label>
							
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<div class="row">
									<?php
									$months = __('months', true);
									?>
									<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
										<select name=cc_exp_month class="form-control">
											<?php
											foreach (range(1, 12) as $v)
											{
												$m = $v;
												if (strlen($v) == 1)
												{
													$m = '0' . $v;
												}
												?><option value="<?php echo $m; ?>"<?php echo @$FORM['cc_exp_month'] != $m ? NULL : ' selected="selected"'; ?>><?php echo $months[$v]; ?></option><?php
											}
											?>
										</select>
									</div>
									<?php
									$time = pjDateTime::factory()
										->attr('name', 'cc_exp_year')
										->attr('id', 'cc_exp_year_' . $get_cid)
										->attr('class', 'form-control')
										->prop('left', 0)
										->prop('right', 6);
										
									if (isset($FORM['cc_exp_year']))
									{
										$time->prop('selected', $FORM['cc_exp_year']);
									} 
									?>
									<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
										<?php echo $time->year();?>
									</div>
								</div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_captcha'], array(3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('co_captcha'); ?>
								<?php if ((int) $tpl['option_arr']['o_bf_captcha'] === 3) : ?> <span class="asterisk">*</span><?php endif; ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<?php
								if($tpl['option_arr']['o_captcha_type_front'] == 'system')
								{
    								?>
									<div class="row">
										<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
											<input type="text" id="pjAsCaptchaField_<?php echo $get_cid;?>" name="captcha" class="form-control<?php echo (int) $tpl['option_arr']['o_bf_captcha'] === 3 ? ' asRequired' : NULL; ?>" maxlength="<?php echo $tpl['option_arr']['o_captcha_mode_front'] == 'string'? (int) $tpl['option_arr']['o_captcha_length_front']: 10 ?>" autocomplete="off" data-msg-required="<?php __('co_v_captcha', false, true); ?>" data-msg-remote="<?php __('co_v_captcha_remote', false, true); ?>" />
										</div>
										<div class="col-lg-6 col-md-6 col-sm-6 col-sx-12">
											<img id="pjAsCaptchaImage_<?php echo $get_cid;?>" alt="Captcha" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionCaptcha&rand=<?php echo rand(1000, 999999); ?>&session_id=<?php echo $controller->_get->check('session_id') ? pjObject::escapeString($controller->_get->toString('session_id')) : NULL;?>" style="vertical-align: middle; cursor: pointer;" />
										</div>
									</div>
									<?php 
								} else {
									?>
								    <div id="g-recaptcha_<?php echo $get_cid; ?>" class="g-recaptcha" data-sitekey="<?php echo $tpl['option_arr']['o_captcha_site_key_front'] ?>"></div>
									<input type="hidden" id="recaptcha" name="recaptcha" class="recaptcha<?php echo ($tpl['option_arr']['o_bf_captcha'] == 3) ? ' required' : NULL; ?>" autocomplete="off" data-msg-required="<?php __('co_v_captcha');?>" data-msg-remote="<?php __('co_v_captcha_remote');?>"/>
									<?php 
								}
								?>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php
						if (isset($tpl['terms_arr']) && !empty($tpl['terms_arr']))
						{
							$t_url = $tpl['terms_arr']['terms_url'];
							$t_body = trim($tpl['terms_arr']['terms_body']);
							?>
							<?php if (((!empty($t_url) && preg_match('/^http(s)?:\/\//i', $t_url)) || !empty($t_body)) && in_array((int) $tpl['option_arr']['o_bf_terms'], array(3))) : ?>
							<div class="form-group">
								<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
									<div class="checkbox">
										<label for="terms_<?php echo $get_cid; ?>">
											<input id="terms_<?php echo $get_cid; ?>" name="terms" class="<?php echo (int) $tpl['option_arr']['o_bf_terms'] === 3 ? 'required' : NULL; ?>" data-msg-required="<?php __('co_v_terms', false, true); ?>" type="checkbox">
											<?php __('co_terms'); ?>
										</label>
	
										<div class="help-block with-errors"></div>
									</div><!-- /.checkbox -->
									<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
								</div><!-- /.col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12 -->
							</div><!-- /.form-group -->
							<?php endif; ?>
							<div class="form-group">
								<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
									
									<?php
									if (!empty($t_url) && preg_match('/^http(s)?:\/\//i', $t_url))
									{
										?><a href="<?php echo pjSanitize::html($t_url); ?>" target="_blank"><?php __('front_terms_link'); ?></a><?php
									} elseif (!empty($t_body)) {
										?><a href="#" data-target="#asTermModal" data-toggle="modal"><?php __('front_terms_link'); ?></a><?php
									}
									?>
									
								</div><!-- /.col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12 -->
							</div><!-- /.form-group -->	
							<?php
						} 
						?>
						
						<div class="form-group">
							<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
								<input style="pointer-events: all; cursor: pointer;" class="btn btn-default pjAsBtn pjAsBtnPrimary" value="<?php __('btnContinue', false, true); ?>" type="submit"<?php echo count($cart) == 0 ? ' disabled="disabled"' : null;?>>
								<?php echo $back_url;?>
							</div><!-- /.col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12 -->
						</div><!-- /.form-group -->
					</form>
					
					<div class="modal fade pjTbModal" id="asTermModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					  	<div class="modal-dialog">
					    	<div class="modal-content">
							    <div class="modal-body">
							    	<?php echo $t_body;?>
							    </div>
						      	<div class="modal-footer">
						        	<button type="button" class="btn btn-default pjTbBtn pjTbBtnPrimary" data-dismiss="modal"><?php __('front_close');?></button>
						      	</div>
					    	</div>
					  	</div>
					</div>
				</div><!-- /.form-horizontal -->
			</div><!-- /.panel-body pjAsBody pjAsCheckout -->
			<?php
		} elseif (isset($tpl['status']) && $tpl['status'] == 'ERR') {
			?>
			<div class="panel-heading pjAsHead">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
						<div class="alert alert-warning" role="alert">
						  	<?php __('front_system_msg'); ?><br/><?php __('front_checkout_na'); ?> <a href="#" class="alert-link pjAsBtnBackToServices"><?php __('front_return_back');?></a>
						</div>
					</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
				</div><!-- /.row -->
			</div><!-- /.panel-heading pjAsHead -->
			<?php
		}
		?>
	</div><!-- /.panel panel-default pjAsContainer -->
</div>