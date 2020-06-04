<!doctype html>
<html>
<head>
    <meta charset="UTF-8">
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
                        <strong><?php __('plugin_braintree_site_name'); ?></strong>
                    </div>

                    <?php if(PJ_TEST_MODE): ?>
                        <div class="fit">
                            <a class="braintree" href="https://developers.braintreepayments.com/guides/drop-in" target="_blank"><?php __('plugin_braintree_braintree_name'); ?></a>
                        </div>
                    <?php endif; ?>
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
    if (class_exists('pjInput'))
    {
        $hash       = $controller->_post->toString('hash');
        $amount     = $controller->_post->toFloat('amount');
        $custom     = $controller->_post->toString('custom');
        $notify_url = $controller->_post->toString('notify_url');
        $cancel_url = $controller->_post->toString('cancel_url');
        $locale     = $controller->_post->toString('locale');
    }
    else
    {
        $pjAppModel = pjAppModel::factory();
        $hash       = @$_POST['hash'] ? $pjAppModel->escapeStr($_POST['hash']): null;
        $amount     = @$_POST['amount'] ? (float) $_POST['amount']: 0.00;
        $custom     = @$_POST['custom'] ? $pjAppModel->escapeStr($_POST['custom']): null;
        $notify_url = @$_POST['notify_url'] ? $pjAppModel->escapeStr($_POST['notify_url']): null;
        $cancel_url = @$_POST['cancel_url'] ? $pjAppModel->escapeStr($_POST['cancel_url']): null;
        $locale     = @$_POST['locale'] ? $pjAppModel->escapeStr($_POST['locale']): null;
    }
    ?>
    <?php if (!empty($amount) && !empty($hash) && !empty($custom) && !empty($notify_url)): ?>
        <div class="wrapper">
            <div class="checkout container">
                <header>
                    <p><?php __('plugin_braintree_make_a_payment');?></p>
                </header>

                <form method="post" id="payment-form" action="<?php echo PJ_INSTALL_URL; ?>?controller=pjBraintree&action=pjActionCheckout">
                    <input type="hidden" name="hash" value="<?php echo $hash; ?>">
                    <input type="hidden" name="custom" value="<?php echo $custom; ?>">
                    <input type="hidden" name="notify_url" value="<?php echo $notify_url; ?>">

                    <section>
                        <label for="amount">
                            <span class="input-label"><?php __('plugin_braintree_amount');?></span>
                            <div class="input-wrapper amount-wrapper">
                                <input id="amount" name="amount" type="tel" min="1" readonly placeholder="<?php __('plugin_braintree_amount', true, false);?>" value="<?php echo $amount ?>">
                            </div>
                        </label>

                        <div class="bt-drop-in-wrapper">
                            <div id="bt-dropin"></div>
                        </div>
                    </section>

                    <input id="nonce" name="payment_method_nonce" type="hidden" />
                    <button class="button" type="submit"><span><?php __('plugin_braintree_btn_pay_now');?></span></button>
                    <a href="<?php echo $cancel_url ?>" target="_self"><span><?php __('plugin_braintree_btn_cancel');?></span></a>
                </form>
            </div>
        </div>

        <script src="https://js.braintreegateway.com/web/dropin/1.3.1/js/dropin.min.js"></script>
        <script>
            var form = document.querySelector('#payment-form');
            var client_token = "<?php echo(Braintree\ClientToken::generate()); ?>";
            braintree.dropin.create({
                authorization: client_token,
                selector: '#bt-dropin',
                locale: '<?php echo $locale; ?>',
                paypal: {
                    flow: 'vault'
                }
            }, function (createErr, instance) {
                form.addEventListener('submit', function (event) {
                    event.preventDefault();

                    instance.requestPaymentMethod(function (err, payload) {
                        if (err) {
                            console.log('Error', err);
                            return;
                        }

                        // Add the nonce to the form and submit
                        document.querySelector('#nonce').value = payload.nonce;
                        form.submit();
                    });
                });
            });

            var checkout = new Demo({
                formID: 'payment-form'
            });
        </script>
    <?php else: ?>
        <div class="wrapper">
            <div class="checkout container">
                <div class="content">
                    <div class="icon">
                        <img src="<?php echo $controller->getConst('PLUGIN_IMG_PATH'); ?>fail.svg" alt="">
                    </div>

                    <h1><?php __('plugin_braintree_transaction_failed');?></h1>
                    <section>
                        <p><?php __('plugin_braintree_missing_parameters');?></p>
                    </section>
                </div>
            </div>
        </div>
    <?php endif; ?>
</body>
</html>
