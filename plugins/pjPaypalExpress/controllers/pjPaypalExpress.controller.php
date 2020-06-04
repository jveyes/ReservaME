<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjPaypalExpress extends pjPaypalExpressAppController
{
    private $paymentMethod = 'paypal_express';

    private $logPrefix;

    public function __construct()
    {
        parent::__construct();
        $this->logPrefix = "Payments | " . get_class($this) . " plugin<br>";
    }

    private function getApiContext($client_id, $secret, $sandbox)
    {
        require(self::getConst('PLUGIN_DIR') . 'libs/Paypal/' . 'autoload.php');

        $apiContext = new \PayPal\Rest\ApiContext(new \PayPal\Auth\OAuthTokenCredential($client_id, $secret));

        $apiContext->setConfig(
            array(
                'mode' => $sandbox? 'sandbox': 'live',
                'log.LogEnabled' => true,
                'log.FileName' => '../PayPal.log',
                'log.LogLevel' => $sandbox? 'DEBUG': 'INFO',
                'cache.enabled' => true,
            )
        );

        return $apiContext;
    }

    public function pjActionOptions()
    {
        $this->checkLogin();

        $this->setLayout('pjActionEmpty');

        # PHP version -------------------
        $php_check = true;
        if (version_compare(phpversion(), '5.6.0', '<'))
        {
        	$php_check = false;
        }
        
        if ($php_check)
        {
	        $params = $this->getParams();
	
	        $this->set('arr', pjPaymentOptionModel::factory()->getOptions($params['foreign_id'], $this->paymentMethod));
	        
	        $i18n = pjMultiLangModel::factory()->getMultiLang($params['fid'], 'pjPayment');
	        $this->set('i18n', $i18n);
	        $locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
		        ->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
		        ->where('t2.file IS NOT NULL')
		        ->orderBy('t1.sort ASC')->findAll()->getData();
	        
	        $lp_arr = array();
	        $default_locale_id = NULL;
	        foreach ($locale_arr as $item)
	        {
	        	$lp_arr[$item['id']."_"] = $item['file'];
	        	if ($item['is_default'])
	        	{
	        		$default_locale_id = $item['id'];
	        	}
	        }
	        $this->set('lp_arr', $locale_arr);
	        $this->set('locale_str', pjAppController::jsonEncode($lp_arr));
	        $this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
	        
	        $this->set('locale_id', isset($params['locale_id']) ? $params['locale_id'] : $default_locale_id);
        }
        
        $this->set('php_check', $php_check);
    }

    public function pjActionSaveOptions()
    {
        $this->checkLogin();

        return true;
    }

    public function pjActionCopyOptions()
    {
        $this->checkLogin();

        return true;
    }

    public function pjActionDeleteOptions()
    {
        $this->checkLogin();

        return true;
    }

    public static function getFormParams($post, $order_arr)
    {
        $params = parent::getFormParams($post, $order_arr);

        $params['locale'] = self::getPaymentLocale($params['locale_id']);
        $params['notify_url'] .= '&custom=' . $params['custom'];
        $params['cancel_url'] = "{$params['notify_url']}&cancel_hash={$params['cancel_hash']}";

        return $params;
    }

    public static function getPaymentLocale($localeId = null)
    {
        $locale = 'en_US'; // English (default)

        if($localeId && $locale_arr = pjLocaleModel::factory()->select('language_iso')->find($localeId)->getData())
        {
            $lang = strtok($locale_arr['language_iso'], '-');
            if(in_array($locale_arr['language_iso'], array('zh-TW')))
            {
                $lang = 'tw';
            }
            elseif(in_array($locale_arr['language_iso'], array('es', 'es-ES')))
            {
                $lang = 'es_es';
            }
            elseif(strpos($locale_arr['language_iso'], '-NO') || in_array($locale_arr['language_iso'], array('nb', 'nn')))
            {
                $lang = 'no';
            }
            elseif(strpos($locale_arr['language_iso'], '-RU'))
            {
                $lang = 'ru';
            }
            elseif(strpos($locale_arr['language_iso'], '-SE'))
            {
                $lang = 'sv';
            }
            elseif(in_array($locale_arr['language_iso'], array('pt-BR')))
            {
                $lang = 'pt_br';
            }
            elseif(in_array($locale_arr['language_iso'], array('en-AU')))
            {
                $lang = 'en_au';
            }
            elseif(in_array($locale_arr['language_iso'], array('fr-BE', 'fr-FR')))
            {
                $lang = 'fr_fr';
            }
            elseif(in_array($locale_arr['language_iso'], array('fr-CA')))
            {
                $lang = 'fr_ca';
            }
            elseif(strpos($locale_arr['language_iso'], '-GB') || strpos($locale_arr['language_iso'], '-IN') || in_array($locale_arr['language_iso'], array('en-SG')))
            {
                $lang = 'en_gb';
            }
            elseif(in_array($locale_arr['language_iso'], array('zh-HK')))
            {
                $lang = 'hk';
            }

            $locales = array(
                'ar' => 'ar_EG',
                'es' => 'es_XC',
                'es_es' => 'es_ES',
                'de' => 'de_DE',
                'sv' => 'sv_SE',
                'tw' => 'zh_TW',
                'th' => 'th_TH',
                'ru' => 'ru_RU',
                'uk' => 'ru_RU',
                'et' => 'ru_RU',
                'lv' => 'ru_RU',
                'nl' => 'nl_NL',
                'he' => 'he_IL',
                'it' => 'it_IT',
                'ja' => 'ja_JP',
                'id' => 'id_ID',
                'pl' => 'pl_PL',
                'no' => 'no_NO',
                'pt' => 'pt_PT',
                'pt_br' => 'pt_BR',
                'da' => 'da_DK',
                'fo' => 'da_DK',
                'kl' => 'da_DK',
                'en_au' => 'en_AU',
                'ko' => 'ko_KR',
                'fr' => 'fr_XC',
                'fr_fr' => 'fr_FR',
                'fr_ca' => 'fr_CA',
                'en_gb' => 'en_GB',
                'zh' => 'zh_CN',
                'hk' => 'zh_HK',
            );

            if(array_key_exists($lang, $locales))
            {
                $locale = $locales[$lang];
            }
        }

        return $locale;
    }

    public function pjActionGetCustom()
    {
        $request = $this->getParams();
        $custom = isset($request['custom'])? $request['custom']: null;

        if(!empty($custom))
        {
            $this->log($this->logPrefix . "Start confirmation process for: {$custom}<br>Request Data:<br>" . print_r($request, true));
        }
        else
        {
            $this->log($this->logPrefix . "Missing parameters. Cannot start confirmation process.<br>Request Data:<br>" . print_r($request, true));
        }

        return $custom;
    }

    public function pjActionForm()
    {
        $this->setLayout('pjActionEmpty');

        $params = $this->getParams();

        $apiContext = $this->getApiContext($params['merchant_id'], $params['private_key'], PJ_TEST_MODE);

        $payerInfo = new \PayPal\Api\PayerInfo();
        $payerInfo
            ->setFirstName($params['first_name'])
            ->setLastName($params['last_name'])
            ->setEmail($params['email']);

        $payer = new \PayPal\Api\Payer();
        $payer
            ->setPaymentMethod("paypal")
            ->setPayerInfo($payerInfo);

        $amount = new \PayPal\Api\Amount();
        $amount
            ->setCurrency($params['currency_code'])
            ->setTotal(number_format($params['amount'], 2, '.', ''));

        $transaction = new \PayPal\Api\Transaction();
        $transaction
            ->setAmount($amount)
            ->setCustom($params['custom'])
            ->setDescription($params['item_name']);

        $redirectUrls = new \PayPal\Api\RedirectUrls();
        $redirectUrls
            ->setReturnUrl($params['notify_url'])
            ->setCancelUrl($params['cancel_url']);

        $payment = new \PayPal\Api\Payment();
        $payment
            ->setIntent("sale")
            ->setPayer($payer)
            ->setRedirectUrls($redirectUrls)
            ->setTransactions(array($transaction));


        try {
            $presentation = new \PayPal\Api\Presentation();
            $presentation->setLocaleCode($params['locale']);

            if(!empty($params['public_key']))
            {
                $webProfile = \PayPal\Api\WebProfile::get($params['public_key'], $apiContext);
                $webProfile->setPresentation($presentation);
                $webProfile->update($apiContext);
            }
            else
            {
                $webProfile = new \PayPal\Api\WebProfile();
                $webProfile->setName('p_' . uniqid());
                $webProfile->setPresentation($presentation);
                $webProfile = $webProfile->create($apiContext);
            }

            $payment->setExperienceProfileId($webProfile->getId());
        } catch (\PayPal\Exception\PayPalConnectionException $ex) {
            // Web profile is not required. It's still OK if it fails.
        }

        try {
            $payment->create($apiContext);
            $url = $payment->getApprovalLink();
        } catch (\PayPal\Exception\PayPalConnectionException $ex) {
            $this->log($this->logPrefix . "PayPal EC error on payment create: " . print_r($ex->getData(), true));
        } catch (Exception $ex) {
            $this->log($this->logPrefix . "PayPal EC error on payment create: " . $ex->getMessage());
        }

        $this->set('arr', array('name' => $params['name'], 'id' => $params['id'], 'target' => $params['target'], 'url' => @$url));
    }

	public function pjActionConfirm()
	{
        $params = $this->getParams();
        $request = $params['request'];

        if (!isset($params['key']) || $params['key'] != md5($this->option_arr['private_key'] . PJ_SALT))
        {
            $this->log($this->logPrefix . "Missing or invalid 'key' parameter.");
            return FALSE;
        }

        $response = array('status' => 'FAIL', 'redirect' => true);
        if(isset($request['cancel_hash']) && $request['cancel_hash'] == $params['cancel_hash'])
        {
            $this->log($this->logPrefix . "Payment was cancelled.");
            $response['status'] = 'CANCEL';
            return $response;
        }

        $options = pjPaymentOptionModel::factory()->getOptions($params['foreign_id'], $this->paymentMethod);

		$apiContext = $this->getApiContext($options['merchant_id'], $options['private_key'], PJ_TEST_MODE);
		$payment = \PayPal\Api\Payment::get($request['paymentId'], $apiContext);
		
		$transactions = $payment->getTransactions();
		$order_id = json_decode($transactions[0]->custom);
		
		$execution = new \PayPal\Api\PaymentExecution();
		$execution->setPayerId($request['PayerID']);
		
		$execution->addTransaction($transactions[0]);

		try {
			$result = $payment->execute($execution, $apiContext);
		
			try {
				$payment = \PayPal\Api\Payment::get($request['paymentId'], $apiContext);
                $response['status'] = 'OK';
                $response['txn_id'] = $request['PayerID'];
                $this->log($this->logPrefix . "Payment was successful. TXN ID: {$response['txn_id']}.");
			} catch (Exception $ex) {
                $this->log($this->logPrefix . "Error: " . $ex->getMessage());
			}
		} catch (Exception $ex) {
            $this->log($this->logPrefix . "Error: " . $ex->getMessage());
		}
		
		return $response;
	}
}
?>