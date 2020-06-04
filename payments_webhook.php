<?php
if (!defined("ROOT_PATH"))
{
    define("ROOT_PATH", dirname(__FILE__) . '/');
}
require ROOT_PATH . 'app/config/options.inc.php';

$http_referer = isset($_SERVER['HTTP_REFERER']) && !empty($_SERVER['HTTP_REFERER'])? $_SERVER['HTTP_REFERER']: gethostbyaddr($_SERVER['REMOTE_ADDR']);

$opts = array('http' => array(
    'method'  => 'POST',
    'header'  => 'Content-type: application/x-www-form-urlencoded',
    'follow_location' => 1,
    'content' => http_build_query($_REQUEST + array('pj_http_referer' => $http_referer))
));
$context = stream_context_create($opts);
$url = file_get_contents(PJ_INSTALL_URL."index.php?controller=pjFrontEnd&action=pjActionConfirm", false, $context);
if(!empty($url))
{
    if (strstr($_SERVER['SERVER_SOFTWARE'], 'Microsoft-IIS'))
    {
        echo '<html><head><title></title><script type="text/javascript">window.location.href="'.$url.'";</script></head><body></body></html>';
    } else {
        header("Location: $url", true, 303);
    }
}
?>