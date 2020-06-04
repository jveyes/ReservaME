<?php
require_once $controller->getConst('PLUGIN_DIR') . 'anet_php_sdk/AuthorizeNet.php';

$url = PJ_TEST_MODE ? 'https://test.authorize.net/gateway/transact.dll' : 'https://secure2.authorize.net/gateway/transact.dll';

$x_login         = $tpl['arr']['merchant_id'];
$x_private_key = $tpl['arr']['private_key'];
$x_amount        = number_format($tpl['arr']['amount'], 2, '.', '');
$x_fp_sequence	 = md5(uniqid(rand(), true));

$timezone = $tpl['arr']['tz'] ? $tpl['arr']['tz'] : 'UTC';
$dateTime = new DateTime('now', new DateTimeZone($timezone));
$x_fp_timestamp = $dateTime->getTimestamp();

$fingerprint     = AuthorizeNetSIM_Form::getFingerprint($x_login, $x_private_key, $x_amount, $tpl['arr']['currency_code'], $x_fp_sequence, $x_fp_timestamp);
?>
<form method="post" action="<?php echo $url; ?>" style="display: inline" name="<?php echo $tpl['arr']['name']; ?>" id="<?php echo $tpl['arr']['id']; ?>" target="<?php echo @$tpl['arr']['target']; ?>">
	<input type="hidden" name="x_login" value="<?php echo $x_login; ?>" />
	<input type="hidden" name="x_amount" value="<?php echo $x_amount; ?>" />
	<input type="hidden" name="x_currency_code" value="<?php echo $tpl['arr']['currency_code']; ?>" />
	<input type="hidden" name="x_description" value="<?php echo $tpl['arr']['item_name']; ?>" />
	<input type="hidden" name="x_invoice_num" value="<?php echo $tpl['arr']['custom']; ?>" />
	<input type="hidden" name="x_fp_sequence" value="<?php echo $x_fp_sequence; ?>" />
	<input type="hidden" name="x_fp_timestamp" value="<?php echo $x_fp_timestamp; ?>" />
	<input type="hidden" name="x_fp_hash" value="<?php echo $fingerprint; ?>" />
	<input type="hidden" name="x_test_request" value="false" /> <!-- Even in Test Mode we send it as False because else Authorize will always return transaction id 0 -->
	<input type="hidden" name="x_version" value="3.1" />
	<input type="hidden" name="x_show_form" value="payment_form" />
	<input type="hidden" name="x_method" value="cc" />
	<input type="hidden" name="x_receipt_link_method" value="LINK" />
    <input type="hidden" name="x_receipt_link_url" value="<?php echo $tpl['arr']['return_url']; ?>" />
	<input type="hidden" name="x_relay_response" value="TRUE" />
	<input type="hidden" name="x_relay_url" value="<?php echo $tpl['arr']['notify_url']; ?>"/>
	<?php
	if (isset($tpl['arr']['submit']))
	{
		?><input type="submit" value="<?php echo htmlspecialchars(@$tpl['arr']['submit']); ?>" class="<?php echo @$tpl['arr']['submit_class']; ?>" /><?php
	}
	?>
</form>