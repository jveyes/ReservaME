<!doctype html>
<html>
	<head>
		<title><?php __('cancel_title'); ?></title>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
		<?php
		foreach ($controller->getCss() as $css)
		{
			echo '<link type="text/css" rel="stylesheet" href="'.(isset($css['remote']) && $css['remote'] ? NULL : PJ_INSTALL_URL).$css['path'].htmlspecialchars($css['file']).'" />';
		}
		$cid = $controller->_get->check('cid') && $controller->_get->toInt('cid') > 0 ? $controller->_get->toInt('cid') : 1;
		?>
	</head>
	<body>
		<div style="margin: 0 auto; width: 1024px">
			<?php
			$cancel_err = __('cancel_err', true);
			if (isset($tpl['status']))
			{
				?>
				<p>
					<?php
					switch ($tpl['status'])
					{
						case 1:
							echo $cancel_err[1];
							break;
						case 2:
							echo $cancel_err[2];
							break;
						case 3:
							echo $cancel_err[3];
							break;
						case 4:
							echo $cancel_err[4];
							break;
						case 5:
							echo $cancel_err[5];
							break;
						case 6:
							printf($cancel_err[6], $tpl['option_arr']['o_cancel_earlier']);
							break;
					}
					?>
				</p>
				<?php
			} else {

				if ($controller->_get->check('err'))
				{
					?>
					<table cellspacing="2" cellpadding="5" style="width: 100%">
						<tbody>	
							<tr>
								<td>
								<?php
								switch ((int) $controller->_get->toString('err'))
								{
									case 5:
										echo $cancel_err[5];
										break;
								}
								?>
								</td>
							</tr>
						</tbody>
					</table>
					<?php
				}

				if (isset($tpl['arr']))
				{
					?>
					<table cellspacing="2" cellpadding="5" style="width: 100%">
						<thead>
							<tr>
								<th colspan="2" style="text-transform: uppercase; font-weight:bold; text-align: left"><br/><?php __('cancel_services'); ?></th>
							</tr>
						</thead>
						<tbody>	
							<tr>
								<td colspan="2">
									<?php
									$hidePrices = (int) $tpl['option_arr']['o_hide_prices'] === 1;
									foreach ($tpl['arr']['details_arr'] as $v)
									{
										$date = date($tpl['option_arr']['o_date_format'], strtotime($v['date']));
										$price = pjCurrency::formatPrice($v['price']);
										$from = date($tpl['option_arr']['o_time_format'], $v['start_ts'] + $v['before'] * 60);
										$to = date($tpl['option_arr']['o_time_format'], $v['start_ts'] + $v['before'] * 60 + $v['length'] * 60);
										?>
										<div class="asElement asElementOutline">
											<div class="asCartService"><?php echo pjSanitize::html($v['service_name']); ?> | <?php echo pjSanitize::html($v['employee_name']); ?></div>
											<div class="asCartInfo">
												<div class="asCartDate<?php echo $hidePrices ? ' asCartFix' : NULL; ?>"><?php echo $date; ?>
													- <?php __('front_from'); ?> <?php echo $from; ?> <?php __('front_till'); ?> <?php echo $to; ?>
													<?php if (!$hidePrices) : ?>
													- <?php echo $price; ?>
													<?php endif; ?>
												</div>
											</div>
										</div>
										<?php
									}
									?>
								</td>
							</tr>
							<?php if (!$hidePrices) : ?>
							<tr>
								<td colspan="2"><?php __('front_cart_total'); ?>: <?php echo pjCurrency::formatPrice($tpl['arr']['booking_total'])?></td>
							</tr>
							<?php endif; ?>
					
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" style="text-transform: uppercase; font-weight:bold; text-align: left"><?php __('cancel_details'); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_name'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_name']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_email'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_email']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_phone'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_phone']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_country'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['country_title']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_city'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_city']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_state'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_state']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_zip'); ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_zip']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_address_1');; ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_address_1']); ?></td>
							</tr>
							<tr>
								<td><?php __('booking_address_2');; ?></td>
								<td><?php echo pjSanitize::html($tpl['arr']['c_address_2']); ?></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="2">								
									<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjFrontEnd&amp;action=pjActionCancel" method="post">
										<input type="hidden" name="booking_cancel" value="1" />
										<input type="hidden" name="id" value="<?php echo $controller->_get->toInt('id'); ?>" />
										<input type="hidden" name="hash" value="<?php echo $controller->_get->toString('hash'); ?>" />
										<input type="submit" value="<?php __('cancel_confirm', false, true); ?>" class="asButton asButtonGreen" />
									</form>
								</td>
							</tr>
						</tfoot>
					</table>
					<?php
				}
			}
			?>
		</div>
	</body>
</html>