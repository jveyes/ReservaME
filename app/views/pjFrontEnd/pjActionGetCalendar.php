<div class="pjIcCalendar">
	<div class="pj-calendar">
		<?php
		echo $tpl['calendar']->getMonthHTML($controller->_get->toString('month'), $controller->_get->toString('year'));
		?>
	</div><!-- /.pj-calendar -->
</div>