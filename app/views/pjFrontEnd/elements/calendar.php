<div class="pjIcCalendar">
	<div class="pj-calendar">
		<?php
		list($year, $month,) = explode("-", $controller->_get->toString('date'));
		echo $tpl['calendar']->getMonthHTML((int) $month, $year);
		?>
	</div>
</div>