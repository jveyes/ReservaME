<?php
ob_start();
include PJ_VIEWS_PATH . 'pjFrontEnd/elements/time.php';
$ob_time = ob_get_contents();
ob_end_clean(); 
pjAppController::jsonResponse(compact('ob_time', 'in_cart', 'cell'));
?>