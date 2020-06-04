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
			
			$back_url = '';
			?>
			<div class="panel-heading pjAsHead">
				<div class="row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
						<a href="#" class="btn btn-link pjAsBtnBack pjAsBtnBackToCheckout" data-eid="<?php echo $employee_id; ?>" data-sid="<?php echo $service_id; ?>" data-slug="<?php echo $slug;?>">
							<i class="fa fa-angle-double-left"></i> <?php __('front_back');?>
						</a>
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
				<!-- JMVB
				<div class="clearfix">
					<h3 class="pull-left text-uppercase pjAsSectionTotal"><?php __('front_deposit');?><?php echo $tpl['option_arr']['o_deposit_type'] == 'percent' ? ' ('.$tpl['option_arr']['o_deposit'].'%)' : NULL;?></h3><!-- /.pull-left text-uppercase pjAsSectionTotal -->
                <!-- JMVB
					<h3 class="pull-right text-uppercase pjAsSectionPrice">
						<strong><?php echo pjCurrency::formatPrice($tpl['summary']['deposit']);?></strong>
					</h3><!-- /.pull-right text-uppercase pjAsSectionPrice -->
				<!-- JMVB
				</div><!-- /.clearfix -->
				
				<h3 class="text-uppercase pjAsSectionTitle"><?php __('front_preview_form');?>:</h3><!-- /.pull-left text-uppercase pjAsSectionTitle -->
				
				<div class="form-horizontal">
					<form role="form" data-toggle="validator" method="post" action="" novalidate="true" class="asSelectorPreviewForm">
						<input type="hidden" name="as_preview" value="1" />
						<?php if (in_array((int) $tpl['option_arr']['o_bf_name'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_name'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_name']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_email'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_email'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_email']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_phone'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_phone'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_phone']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_address_1'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_address_1'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_address_1']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_address_2'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_address_2'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_address_2']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_country'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_country'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$tpl['country_arr']['name']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_state'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_state'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">	
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_state']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_city'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_city'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_city']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_zip'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_zip'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['c_zip']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if (in_array((int) $tpl['option_arr']['o_bf_notes'], array(2,3))) : ?>
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_notes'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo nl2br(pjSanitize::html(@$FORM['c_notes'])); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<?php if ((int) $tpl['option_arr']['o_disable_payments'] === 0 && !empty($tpl['option_arr']['o_deposit'])) : ?>
						
						<div class="form-group">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label ">
								<?php __('booking_payment_method'); ?> 
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo $tpl['payment_titles'][$FORM['payment_method']];; ?> En tienda</p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorBank" style="display: <?php echo @$FORM['payment_method'] != 'bank' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_bank_account'); ?>
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<?php echo nl2br(pjSanitize::html($tpl['bank_account'])); ?>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize">
								<?php __('booking_cc_type'); ?> 
							</label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<?php
								$ct = __('booking_cc_types', true);
								?>
								<p class="form-control-static"><?php echo @$ct[$FORM['cc_type']]; ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_num'); ?></label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['cc_num']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_code'); ?></label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php echo pjSanitize::html(@$FORM['cc_code']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<div class="form-group asSelectorCCard" style="display: <?php echo @$FORM['payment_method'] != 'creditcard' ? 'none' : NULL; ?>">
							<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('booking_cc_exp'); ?></label>
							<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
								<p class="form-control-static"><?php printf("%s/%s", $FORM['cc_exp_month'], $FORM['cc_exp_year']); ?></p>
							</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-sx-12 -->
						</div><!-- /.form-group -->
						<?php endif; ?>
						
						<div class="alert alert-warning asSelectorError" role="alert" style="display: none"></div>
						
						<div class="form-group">
							<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
								<input style="pointer-events: all; cursor: pointer;" class="btn btn-default pjAsBtn pjAsBtnPrimary" value="<?php __('front_confirm_booking', false, true); ?>" type="submit"<?php echo count($cart) == 0 ? ' disabled="disabled"' : null;?>>
								<a href="#" class="btn btn-default pjAsBtn pjAsBtnSecondary pjAsBtnBackToCheckout"><?php __('btnCancel', false, true); ?></a>
							</div><!-- /.col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12 -->
						</div><!-- /.form-group -->
					</form>
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