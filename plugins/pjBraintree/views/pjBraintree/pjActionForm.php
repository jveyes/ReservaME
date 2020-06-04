<?php
$tmp = $tpl['arr']['amount'].$tpl['arr']['custom'].$tpl['arr']['notify_url'].$tpl['arr']['private_key'];
$hash = hash('sha256', $tmp);
?>
<form method="post" action="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjBraintree&action=pjActionIndex" style="display: inline" name="<?php echo $tpl['arr']['name']; ?>" id="<?php echo $tpl['arr']['id']; ?>">
	<input type="hidden" name="amount" value="<?php echo $tpl['arr']['amount']; ?>" />
	<input type="hidden" name="custom" value="<?php echo $tpl['arr']['custom']; ?>" />
	<input type="hidden" name="notify_url" value="<?php echo $tpl['arr']['notify_url']; ?>" />
    <input type="hidden" name="cancel_url" value="<?php echo $tpl['arr']['cancel_url']; ?>" />
    <input type="hidden" name="locale" value="<?php echo $tpl['arr']['locale']; ?>" />
	<input type="hidden" name="hash" value="<?php echo $hash; ?>" />
	<?php
	if (isset($tpl['arr']['submit']))
	{
		?><input type="submit" value="<?php echo htmlspecialchars(@$tpl['arr']['submit']); ?>" class="<?php echo @$tpl['arr']['submit_class']; ?>" /><?php
	}
	?>
</form>