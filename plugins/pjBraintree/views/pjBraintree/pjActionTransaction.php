<!doctype html>
<html>
<head>
    <title><?php __('plugin_braintree_header_title'); ?></title>
    <link rel=stylesheet type=text/css href="<?php echo $controller->getConst('PLUGIN_CSS_PATH'); ?>app.css">
    <link rel=stylesheet type=text/css href="<?php echo $controller->getConst('PLUGIN_CSS_PATH'); ?>overrides.css">
    <script src="<?php echo $controller->getConst('PLUGIN_JS_PATH'); ?>jquery-2.1.4.min.js"></script>
    <script src="<?php echo $controller->getConst('PLUGIN_JS_PATH'); ?>jquery.lettering-0.6.1.min.js"></script>
    <script src="<?php echo $controller->getConst('PLUGIN_JS_PATH'); ?>braintree.js"></script>
</head>
<body>
<header class="main">
    <div class="container wide">
        <div class="content slim">
            <div class="set">
                <div class="fill">
                    <a class="pseudoshop" href="#"><strong><?php __('front_site_name') ?></strong></a>
                </div>

                <div class="fit">
                    <a class="braintree" href="https://developers.braintreepayments.com/guides/drop-in" target="_blank"><?php __('plugin_braintree_braintree_name'); ?></a>
                </div>
            </div>
        </div>
    </div>

    <div class="notice-wrapper">
        <?php if(isset($tpl['tm_text'])) : ?>
            <div class="show notice error notice-error">
                <span class="notice-message">
                    <?php echo pjSanitize::html($tpl['tm_text']);?>
                    <span>
            </div>
        <?php endif; ?>
    </div>
</header>
<?php
if(isset($tpl['transaction']))
{ 
	$transaction = $tpl['transaction'];
	?>
	<div class="wrapper">
	    <div class="response container">
	        <div class="content">
	            <div class="icon">
	                <img src="<?php echo $controller->getConst('PLUGIN_IMG_PATH'); ?>fail.svg" alt="">
	            </div>
	
	            <h1><?php __('plugin_braintree_transaction_failed');?></h1>
	            <section>
	                <p><?php __('plugin_braintree_transaction_has_status');?> <?php echo ($transaction->status)?></p>
	            </section>
	        </div>
	    </div>
	</div>
	
	<aside class="drawer dark">
	    <header>
	        <div class="content compact">
	            <a href="https://developers.braintreepayments.com" class="braintree" target="_blank"><?php __('plugin_braintree_braintree_name'); ?></a>
	            <h3><?php __('plugin_braintree_response'); ?></h3>
	        </div>
	    </header>
	
	    <article class="content compact">
	        <section>
	            <h5><?php __('plugin_braintree_transaction'); ?></h5>
	            <table cellpadding="0" cellspacing="0">
	                <tbody>
	                <tr>
	                    <td><?php __('plugin_braintree_trasaction_id'); ?></td>
	                    <td><?php echo($transaction->id)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_trasaction_type'); ?></td>
	                    <td><?php echo($transaction->type)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_trasaction_amount'); ?></td>
	                    <td><?php echo($transaction->amount)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_trasaction_status'); ?></td>
	                    <td><?php echo($transaction->status)?></td>
	                </tr>
	                </tbody>
	            </table>
	        </section>
	
	        <section>
	            <h5><?php __('plugin_braintree_payment'); ?></h5>
	
	            <table cellpadding="0" cellspacing="0">
	                <tbody>
	                <tr>
	                    <td><?php __('plugin_braintree_card_type'); ?></td>
	                    <td><?php echo($transaction->creditCardDetails->cardType)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_card_exp'); ?></td>
	                    <td><?php echo($transaction->creditCardDetails->expirationDate)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_card_holder_name'); ?></td>
	                    <td><?php echo($transaction->creditCardDetails->cardholderName)?></td>
	                </tr>
	                <tr>
	                    <td><?php __('plugin_braintree_card_location'); ?></td>
	                    <td><?php echo($transaction->creditCardDetails->customerLocation)?></td>
	                </tr>
	                </tbody>
	            </table>
	        </section>
	
	        <?php if (!is_null($transaction->customerDetails->id)) : ?>
	            <section>
	                <h5><?php __('plugin_braintree_customer_details'); ?></h5>
	                <table cellpadding="0" cellspacing="0">
	                    <tbody>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_id');?></td>
	                        <td><?php echo($transaction->customerDetails->id)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_fname');?></td>
	                        <td><?php echo($transaction->customerDetails->firstName)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_lname');?></td>
	                        <td><?php echo($transaction->customerDetails->lastName)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_email');?></td>
	                        <td><?php echo($transaction->customerDetails->email)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_company');?></td>
	                        <td><?php echo($transaction->customerDetails->company)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_website');?></td>
	                        <td><?php echo($transaction->customerDetails->website)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_phone');?></td>
	                        <td><?php echo($transaction->customerDetails->phone)?></td>
	                    </tr>
	                    <tr>
	                        <td><?php __('plugin_braintree_cust_fax');?></td>
	                        <td><?php echo($transaction->customerDetails->fax)?></td>
	                    </tr>
	                    </tbody>
	                </table>
	            </section>
	        <?php endif; ?>
	        <section>
                <?php
                if (class_exists('pjInput'))
                {
                    $hash = $controller->_get->toString('hash');
                    $custom = $controller->_get->toString('custom');
                    $notify_url = $controller->_get->toString('notify_url');
                }
                else
                {
                    $hash = @$_GET['hash'];
                    $custom = @$_GET['custom'];
                    $notify_url = @$_GET['notify_url'];
                }
                ?>
	            <form method="post"
	                  action="<?php echo PJ_INSTALL_URL; ?>?controller=pjBraintree&action=pjActionIndex">
	                <input type="hidden" name="amount" value="<?php echo($transaction->amount) ?>">
	                <input type="hidden" name="hash" value="<?php echo $hash; ?>">
	                <input type="hidden" name="custom" value="<?php echo $custom; ?>">
	                <input type="hidden" name="notify_url" value="<?php echo $notify_url; ?>">
	                <button class="button secondary full" type="submit"><?php __('plugin_braintree_btn_try_again');?></button>
	            </form>
	        </section>
	    </article>
	</aside>
	<?php
} 
?>
</body>
</html>
