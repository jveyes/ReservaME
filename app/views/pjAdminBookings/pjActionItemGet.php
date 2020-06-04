<?php
if (isset($tpl['bi_arr']) && !empty($tpl['bi_arr']))
{
	?>
	<div class="table-responsive table-responsive-secondary">
		<table class="table table-striped table-hover">
			<thead>
				<tr>
					<th><?php __('booking_service_employee'); ?></th>
					<th><?php __('booking_dt'); ?></th>
					<th><?php __('booking_price'); ?></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<?php
				foreach ($tpl['bi_arr'] as $item)
				{
					?>
					<tr>
						<td>
							<?php echo pjSanitize::html($item['service']); ?>
							<br/>
							<?php echo pjSanitize::html($item['employee']); ?>
						</td>
						<td><?php echo date($tpl['option_arr']['o_date_format'] . ' ' . $tpl['option_arr']['o_time_format'], $item['start_ts']); ?></td>
						<td><?php echo pjCurrency::formatPrice($item['price']); ?></td>
						<td>
							<div class="m-t-xs text-right">
								<?php if (!$controller->_get->check('tmp_hash')) : ?>
									<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings" class="btn btn-primary btn-outline item-email" data-id="<?php echo $item['id']; ?>"><i class="fa fa-envelope"></i></a>
									<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings" class="btn btn-primary btn-outline item-sms" data-id="<?php echo $item['id']; ?>"><i class="fa fa-phone"></i></a>
								<?php endif; ?>
								<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings" class="btn btn-danger btn-outline btn-delete item-delete" data-id="<?php echo $item['id']; ?>"><i class="fa fa-trash"></i></a>
							</div>
						</td>
					</tr>
					<?php 
				}
				?>
			</tbody>
		</table>
	</div>
	<?php
} else {
	?><span class="left"><?php __('booking_i_empty'); ?></span><?php
}
?>