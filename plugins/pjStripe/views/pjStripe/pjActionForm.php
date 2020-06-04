<form id="<?php echo pjSanitize::html(@$tpl['arr']['id']); ?>" action="<?php echo pjSanitize::html(@$tpl['arr']['notify_url']) . '&id=' . pjSanitize::html(@$tpl['arr']['custom']); ?>" method="POST"></form>

<script type="text/javascript">
(function () {
	function loadScript(url, callback) {
	    var script = document.createElement("script");
	    script.type = "text/javascript";
	    script.async = true;
	    if (script.readyState) {
	        script.onreadystatechange = function () {
	            if (script.readyState == "loaded" || script.readyState == "complete") {
	                script.onreadystatechange = null;
	                if (callback && typeof callback === "function") {
	                    callback();
	                }
	            }
	        };
	    } else {
	        script.onload = function () {
	            if (callback && typeof callback === "function") {
	                callback();
	            }
	        };
	    }
	    script.src = url;
	    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(script);
	}
	<?php
	printf("var stripeObject = %s;", pjAppController::jsonEncode($tpl['arr']));
	?>
	function stripeCallback() {
		var handler = StripeCheckout.configure({
			key: '<?php echo pjSanitize::html(@$tpl['arr']['public_key']);?>',
		  	image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
		  	locale: '<?php echo pjSanitize::html(@$tpl['arr']['locale']);?>',
		  	token: function(token){
                var form = document.getElementById(stripeObject.id);
                if (form) {
                    var input = document.createElement('INPUT');
                    input.type = 'hidden';
                    input.id = 'stripeToken';
                    input.name = 'stripeToken';
                    input.value = token.id;
                    form.appendChild(input);
                    form.submit();
                }
            },
            closed: function() {
                // When click on Pay Now button this event is fired also, so we should prevent order cancellation if the payment token is already created.
                if(document.getElementById('stripeToken') === null)
                {
                    var form = document.getElementById(stripeObject.id);
                    if (form) {
                        var input = document.createElement('INPUT');
                        input.type = 'hidden';
                        input.name = 'cancel_hash';
                        input.value = stripeObject.cancel_hash;
                        form.appendChild(input);
                        form.submit();
                    }
                }
            }
		});
		handler.open({
    		name: 'Stripe.com',
			description: '<?php echo pjSanitize::html(@$tpl['arr']['item_name']);?>',
	    	amount: <?php echo pjSanitize::html(@$tpl['arr']['amount']);?>,
    		currency: '<?php echo pjSanitize::html(@$tpl['arr']['currency_code']);?>'
	  	});
	}

	if (!window.Stripe) {
		loadScript('https://checkout.stripe.com/checkout.js', stripeCallback);
	} else {
		stripeCallback();
	}

	window.addEventListener('popstate', function() {
	  	handler.close();
	});
})();
</script>