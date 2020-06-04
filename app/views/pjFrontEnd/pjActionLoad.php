<?php
$cid = (int) $controller->getForeignId();
$front_app = __('front_app', true);
?>
<div id="pjWrapperAppScheduler_<?php echo $cid;?>">
	<div id="asContainer_<?php echo $cid; ?>" class="asContainerInner"></div>
</div>
<script type="text/javascript">
var pjQ = pjQ || {},
	AppScheduler_<?php echo $cid; ?>;
(function () {
	"use strict";
	var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor),

	loadCssHack = function(url, callback){
		var link = document.createElement('link');
		link.type = 'text/css';
		link.rel = 'stylesheet';
		link.href = url;

		document.getElementsByTagName('head')[0].appendChild(link);

		var img = document.createElement('img');
		img.onerror = function(){
			if (callback && typeof callback === "function") {
				callback();
			}
		};
		img.src = url;
	},
	loadRemote = function(url, type, callback) {
		if (type === "css" && isSafari) {
			loadCssHack.call(null, url, callback);
			return;
		}
		var _element, _type, _attr, scr, s, element;
		
		switch (type) {
		case 'css':
			_element = "link";
			_type = "text/css";
			_attr = "href";
			break;
		case 'js':
			_element = "script";
			_type = "text/javascript";
			_attr = "src";
			break;
		}
		
		scr = document.getElementsByTagName(_element);
		s = scr[scr.length - 1];
		element = document.createElement(_element);
		element.type = _type;
		if (type == "css") {
			element.rel = "stylesheet";
		}
		if (element.readyState) {
			element.onreadystatechange = function () {
				if (element.readyState == "loaded" || element.readyState == "complete") {
					element.onreadystatechange = null;
					if (callback && typeof callback === "function") {
						callback();
					}
				}
			};
		} else {
			element.onload = function () {
				if (callback && typeof callback === "function") {
					callback();
				}
			};
		}
		element[_attr] = url;
		s.parentNode.insertBefore(element, s.nextSibling);
	},
	loadScript = function (url, callback) {
		loadRemote.call(null, url, "js", callback);
	},
	loadCss = function (url, callback) {
		loadRemote.call(null, url, "css", callback);
	},
	isMSIE = function() {
		var ua = window.navigator.userAgent,
        	msie = ua.indexOf("MSIE ");

        if (msie !== -1) {
            return true;
        }

		return false;
	},
	getSessionId = function () {
		return sessionStorage.getItem("session_id") == null ? "" : sessionStorage.getItem("session_id");
	},
	createSessionId = function () {
		if(getSessionId()=="") {
			sessionStorage.setItem("session_id", "<?php echo session_id(); ?>");
		}
	},
	options = {
		server: "<?php echo PJ_INSTALL_URL; ?>",
		folder: "<?php echo PJ_INSTALL_URL; ?>",
		cid: <?php echo $cid; ?>,
		seoUrl: <?php echo (int) $tpl['option_arr']['o_seo_url']; ?>,
		locale: <?php echo $controller->_get->toInt('locale') ? $controller->_get->toInt('locale') : $controller->pjActionGetLocale(); ?>,
		hide: <?php echo $controller->_get->toInt('hide') === 1 ? 1 : 0; ?>,
		layout: <?php echo $controller->_get->check('layout') && in_array($controller->_get->toString('layout'), $controller->getLayoutRange()) ? (int) $controller->_get->toString('layout') : (int) $tpl['option_arr']['o_layout']; ?>,
		theme: "<?php echo $controller->_get->check('theme') ? $controller->_get->toString('theme') : $tpl['option_arr']['o_theme']; ?>",
		fields: <?php echo pjAppController::jsonEncode(__('front_app', true)); ?>,
		firstDate: "<?php echo $tpl['first_working_date']; ?>",
		tab: "<?php echo $controller->_get->check('tab') ? $controller->_get->toString('tab') : 'both';?>"
	};
	<?php
	$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
	$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
	?>
	loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('storage_polyfill'); ?>storagePolyfill.min.js", function () {
		if (isSafari) {
			createSessionId();
			options.session_id = getSessionId();
		}else{
			options.session_id = "";
		}
		loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_jquery'); ?>pjQuery.min.js", function () {
			window.pjQ.$.browser = {
				msie: isMSIE()
			};
			loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_validate'); ?>pjQuery.validate.min.js", function () {
				loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_jquery_ui'); ?>js/pjQuery-ui.custom.min.js", function () {
					loadScript("<?php echo PJ_INSTALL_URL . $dm->getPath('pj_bootstrap'); ?>pjQuery.bootstrap.min.js", function () {
						loadScript("<?php echo PJ_INSTALL_URL . PJ_JS_PATH; ?>pjAppScheduler.js", function () {
							<?php if($tpl['option_arr']['o_captcha_type_front'] == 'google'): ?>
						    loadScript('https://www.google.com/recaptcha/api.js', function () {
                            <?php endif; ?>
							AppScheduler_<?php echo $cid; ?> = new AppScheduler(options);
							<?php if($tpl['option_arr']['o_captcha_type_front'] == 'google'): ?>
                            });
						    <?php endif; ?>
						});
					});
				});
			});
		});
	});
})();
</script>