<?php
$url = PJ_TEST_MODE ? 'https://sandbox.2checkout.com/checkout/purchase' : 'https://www.2checkout.com/checkout/purchase';
?>
<form action="<?php echo $url; ?>" method="post" style="display: inline" name="<?php echo $tpl['arr']['name']; ?>" id="<?php echo $tpl['arr']['id']; ?>" target="<?php echo $tpl['arr']['target']; ?>">
	<?php if (PJ_TEST_MODE){?><input type="hidden" name="demo" value="Y" /><?php } ?>

    <input type="hidden" name="sid" value="<?php echo $tpl['arr']['merchant_id']; ?>"/>
    <input type="hidden" name="cart_order_id" value="<?php echo $tpl['arr']['custom']; ?>"/>
    <input type="hidden" name="total" value="<?php echo $tpl['arr']['amount']; ?>"/>
    <input type="hidden" name="tco_currency" value="<?php echo $tpl['arr']['currency_code']; ?>"/>
    <input type="hidden" name="card_holder_name" value="<?php echo $tpl['arr']['first_name'] . ' ' . $tpl['arr']['last_name']; ?>"/>
    <input type="hidden" name="email" value="<?php echo $tpl['arr']['email']; ?>"/>
    <input type="hidden" name="phone" value="<?php echo $tpl['arr']['phone']; ?>"/>
    <input type="hidden" name="x_receipt_link_url" value="<?php echo $tpl['arr']['notify_url']; ?>"/>
    <input type="hidden" name="lang" value="<?php echo $tpl['arr']['locale']; ?>"/>
</form>