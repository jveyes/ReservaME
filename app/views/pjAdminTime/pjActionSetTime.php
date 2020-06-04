<?php
$week_days = array();
foreach($controller->_post->toArray('week_day') as $day)
{
    $week_days[$day] = '<span class="label label-primary">' . $controller->_post->toString('from_time') . ' - ' . $controller->_post->toString('modal_end_time') .  '<a href="#" class="text-primary remove-time"><i class="fa fa-times m-l-xs"></i></a></span>';
}
pjAppController::jsonResponse(array('status' => 'OK', 'code' => $tpl['code'], 'text' => '', 'week_days' => $week_days));
exit;
?>