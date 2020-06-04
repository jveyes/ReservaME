<?php
if (!defined("ROOT_PATH"))
{
	define("ROOT_PATH", dirname(__FILE__) . '/');
}
require ROOT_PATH . 'app/config/options.inc.php';
require PJ_FRAMEWORK_PATH . 'components/pjHttp.component.php';
$pjHttp = new pjHttp();
$response = $pjHttp->request(PJ_INSTALL_URL."index.php?controller=pjBaseCron&action=pjActionRun");
echo $response->getResponse();
?>