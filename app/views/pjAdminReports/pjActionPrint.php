<?php
if (isset($tpl['arr']) && isset($tpl['arr']['data']) && !empty($tpl['arr']['data']))
{
	$total_bookings = $controller->_get->check('index') && $controller->_get->toString('index') == 'cnt';
	$total_amount = $controller->_get->check('index') && $controller->_get->toString('index') == 'amount';
	$confirmed_bookings = $controller->_get->check('index') && $controller->_get->toString('index') == 'cnt';
	$confirmed_amount = $controller->_get->check('index') && $controller->_get->toString('index') == 'amount';
	$pending_bookings = $controller->_get->check('index') && $controller->_get->toString('index') == 'cnt';
	$pending_amount = $controller->_get->check('index') && $controller->_get->toString('index') == 'amount';
	$cancelled_bookings = $controller->_get->check('index') && $controller->_get->toString('index') == 'cnt';
	$cancelled_amount = $controller->_get->check('index') && $controller->_get->toString('index') == 'amount';
	?>
	<table cellpadding="0" cellspacing="0" style="width: 100%">
		<thead>
			<tr>
				<th class="w200"><?php echo $controller->_get->toString('type') == 'services' ? __('service_name', true) : __('employee_name', true); ?></th>
				<?php if ($total_bookings) : ?>
				<th class="align_center"><?php __('report_total_bookings'); ?></th>
				<?php endif; ?>
				<?php if ($total_amount) : ?>
				<th class="align_right"><?php __('report_total_amount'); ?></th>
				<?php endif; ?>
				<?php if ($confirmed_bookings) : ?>
				<th class="align_center"><?php __('report_confirmed_bookings'); ?></th>
				<?php endif; ?>
				<?php if ($confirmed_amount) : ?>
				<th class="align_right"><?php __('report_confirmed_amount'); ?></th>
				<?php endif; ?>
				<?php if ($pending_bookings) : ?>
				<th class="align_center"><?php __('report_pending_bookings'); ?></th>
				<?php endif; ?>
				<?php if ($pending_amount) : ?>
				<th class="align_right"><?php __('report_pending_amount'); ?></th>
				<?php endif; ?>
				<?php if ($cancelled_bookings) : ?>
				<th class="align_center"><?php __('report_cancelled_bookings'); ?></th>
				<?php endif; ?>
				<?php if ($cancelled_amount) : ?>
				<th class="align_right"><?php __('report_cancelled_amount'); ?></th>
				<?php endif; ?>
			</tr>
		</thead>
		<tbody>
		<?php
		foreach ($tpl['arr']['data'] as $item)
		{
			?>
			<tr>
				<td><?php echo $item['name']; ?></td>
				<?php if ($total_bookings) : ?>
				<td class="align_center"><?php echo $item['total_bookings']; ?></td>
				<?php endif; ?>
				<?php if ($total_amount) : ?>
				<td class="align_right"><?php echo $item['total_amount_format']; ?></td>
				<?php endif; ?>
				<?php if ($confirmed_bookings) : ?>
				<td class="align_center"><?php echo $item['confirmed_bookings']; ?></td>
				<?php endif; ?>
				<?php if ($confirmed_amount) : ?>
				<td class="align_right"><?php echo $item['confirmed_amount_format']; ?></td>
				<?php endif; ?>
				<?php if ($pending_bookings) : ?>
				<td class="align_center"><?php echo $item['pending_bookings']; ?></td>
				<?php endif; ?>
				<?php if ($pending_amount) : ?>
				<td class="align_right"><?php echo $item['pending_amount_format']; ?></td>
				<?php endif; ?>
				<?php if ($cancelled_bookings) : ?>
				<td class="align_center"><?php echo $item['cancelled_bookings']; ?></td>
				<?php endif; ?>
				<?php if ($cancelled_amount) : ?>
				<td class="align_right"><?php echo $item['cancelled_amount_format']; ?></td>
				<?php endif; ?>
			</tr>
			<?php
		}
		?>
		</tbody>
	</table>
	<?php
}