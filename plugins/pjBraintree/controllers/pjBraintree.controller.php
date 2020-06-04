<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjBraintree extends pjBraintreeAppController
{
	private $pjBraintreeConfig = 'pjBraintreeConfig';
	
	private $pjBraintreeError = 'pjBraintreeError';

    private $paymentMethod = 'braintree';

    private $logPrefix;

    public function __construct()
    {
        parent::__construct();
        $this->logPrefix = "Payments | " . get_class($this) . " plugin<br>";
    }

    public function pjActionOptions()
    {
        $this->checkLogin();

        $this->setLayout('pjActionEmpty');

        # PHP version -------------------
		$php_check = true;
		if (version_compare(phpversion(), '5.4.0', '<'))
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
        $params['amount'] = number_format($params['amount'], 2, '.', '');
        $params['cancel_url'] = "{$params['notify_url']}&custom={$params['custom']}&cancel_hash={$params['cancel_hash']}";
        $params['notify_url'] = base64_encode($params['notify_url']);

        return $params;
    }

    public static function getPaymentLocale($localeId = null)
    {
        $locale = 'en_US'; // English (default)

        if($localeId && $locale_arr = pjLocaleModel::factory()->select('language_iso')->find($localeId)->getData())
        {
            $lang = strtok($locale_arr['language_iso'], '-');
            if(in_array($locale_arr['language_iso'], array('en-AU')))
            {
                $lang = 'en_au';
            }
            elseif(strpos($locale_arr['language_iso'], '-GB') || strpos($locale_arr['language_iso'], '-IN') || in_array($locale_arr['language_iso'], array('en-SG')))
            {
                $lang = 'en_gb';
            }
            elseif(in_array($locale_arr['language_iso'], array('fr-CA')))
            {
                $lang = 'fr_ca';
            }
            elseif(strpos($locale_arr['language_iso'], '-NO') || in_array($locale_arr['language_iso'], array('nb', 'nn')))
            {
                $lang = 'no';
            }
            elseif(in_array($locale_arr['language_iso'], array('pt-BR')))
            {
                $lang = 'pt_br';
            }
            elseif(strpos($locale_arr['language_iso'], '-RU'))
            {
                $lang = 'ru';
            }
            elseif(strpos($locale_arr['language_iso'], '-SE'))
            {
                $lang = 'sv';
            }
            elseif(in_array($locale_arr['language_iso'], array('zh-HK')))
            {
                $lang = 'hk';
            }
            if(in_array($locale_arr['language_iso'], array('zh-TW')))
            {
                $lang = 'tw';
            }

            $locales = array(
                'da' => 'da_DK',
                'fo' => 'da_DK',
                'kl' => 'da_DK',
                'de' => 'de_DE',
                'en_au' => 'en_AU',
                'en_gb' => 'en_GB',
                'es' => 'es_ES',
                'fr_ca' => 'fr_CA',
                'fr' => 'fr_FR',
                'id' => 'id_ID',
                'it' => 'it_IT',
                'ja' => 'ja_JP',
                'ko' => 'ko_KR',
                'nl' => 'nl_NL',
                'no' => 'no_NO',
                'pl' => 'pl_PL',
                'pt_br' => 'pt_BR',
                'pt' => 'pt_PT',
                'ru' => 'ru_RU',
                'sv' => 'sv_SE',
                'th' => 'th_TH',
                'zh' => 'zh_CN',
                'hk' => 'zh_HK',
                'tw' => 'zh_TW',
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
		
		$config_arr = array();
		$config_arr['environment'] = PJ_TEST_MODE ? 'sandbox' : 'production';
		$config_arr['merchant_id'] = $params['merchant_id'];
		$config_arr['public_key']  = $params['public_key'];
		$config_arr['private_key'] = $params['private_key'];
		
		$_SESSION[$this->pjBraintreeConfig] = $config_arr;
		
		$this->set('arr', array_merge($params, $config_arr));
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

        $response = array('status' => 'FAIL', 'redirect' => false);
        if(isset($request['cancel_hash']) && $request['cancel_hash'] == $params['cancel_hash'])
        {
            $this->log($this->logPrefix . "Payment was cancelled.");
            $response['status'] = 'CANCEL';
            $response['redirect'] = true;
            return $response;
        }

        $options = pjPaymentOptionModel::factory()->getOptions($params['foreign_id'], $this->paymentMethod);

        if (!(isset($request['amount'], $request['custom'], $request['notify_url'], $options['private_key'])))
        {
            $this->log($this->logPrefix . "Missing, empty or invalid parameters.");
            return $response;
        }

        $tmp = $request['amount'].$request['custom'].base64_decode($request['notify_url']).$options['private_key'];
        $check_hash = hash('sha256', $tmp);

        if ($request['hash'] == $check_hash)
        {
            $response['status'] = 'OK';
            $response['txn_id'] = isset($request['transaction_id']) ? $request['transaction_id'] : '';
            $response['redirect'] = true;
            $this->log($this->logPrefix . "Payment was successful. TXN ID: {$response['txn_id']}.");
        } else {
            $this->log($this->logPrefix . "Payment was not successful. Hash mismatch.");
        }

        return $response;
    }

	public function pjActionIndex()
	{
		if(isset($_SESSION[$this->pjBraintreeConfig]) && is_array($_SESSION[$this->pjBraintreeConfig]))
		{
			require_once $this->getConst('PLUGIN_DIR') . "vendor/lib/autoload.php";
	
			$config_arr = $_SESSION[$this->pjBraintreeConfig];
			
			if (!empty($config_arr['merchant_id']) && !empty($config_arr['public_key']) && !empty($config_arr['private_key'])) {
				Braintree\Configuration::environment($config_arr['environment']);
				Braintree\Configuration::merchantId($config_arr['merchant_id']);
				Braintree\Configuration::publicKey($config_arr['public_key']);
				Braintree\Configuration::privateKey($config_arr['private_key']);
	
				if (class_exists('pjInput'))
	            {
	                $tm = $this->_get->toString('tm');
	            }
	            else
	            {
	                $pjAppModel = pjAppModel::factory();
	                $tm = @$_GET['tm'] ? $pjAppModel->escapeStr($_GET['tm']): null;
	            }
	
				if (isset($_SESSION[$this->pjBraintreeError][$tm]))
				{
					$this->set('tm_text', $_SESSION[$this->pjBraintreeError][$tm]);
					$_SESSION[$this->pjBraintreeError] = NULL;
					unset($_SESSION[$this->pjBraintreeError]);
				}
			} else {
				$this->set('tm_text', __('plugin_braintree_config_missing', true));
			}
		}else{
			$this->set('tm_text', __('plugin_braintree_config_missing', true));
		}
	}

	public function pjActionCheckout()
	{
		$time = time();
		if (!isset($_SESSION[$this->pjBraintreeError]))
		{
			$_SESSION[$this->pjBraintreeError] = array();
		}
		
		if(isset($_SESSION[$this->pjBraintreeConfig]) && is_array($_SESSION[$this->pjBraintreeConfig]))
		{
			require_once $this->getConst('PLUGIN_DIR') . "vendor/lib/autoload.php";
	
			$config_arr = $_SESSION[$this->pjBraintreeConfig];
			
			Braintree\Configuration::environment($config_arr['environment']);
			Braintree\Configuration::merchantId($config_arr['merchant_id']);
			Braintree\Configuration::publicKey($config_arr['public_key']);
			Braintree\Configuration::privateKey($config_arr['private_key']);

			if (class_exists('pjInput'))
			{
				$hash = $this->_post->toString('hash');
				$amount = number_format($this->_post->toFloat('amount'), 2, '.', '');
				$custom = $this->_post->toString('custom');
				$notify_url = $this->_post->toString('notify_url');
			}
			else
			{
				$pjAppModel = pjAppModel::factory();
				$hash = @$_POST['hash'] ? $pjAppModel->escapeStr($_POST['hash']): null;
				$amount = @$_POST['amount'] ? (float) $_POST['amount']: 0.00;
				$custom = @$_POST['custom'] ? $pjAppModel->escapeStr($_POST['custom']): null;
				$notify_url = @$_POST['notify_url'] ? $pjAppModel->escapeStr($_POST['notify_url']): null;
			}
			
			$tmp = $amount.$custom.$notify_url.$config_arr['private_key'];
			
			$check_hash = hash('sha256', $tmp);
			
			if ($hash == $check_hash) {
			    if (class_exists('pjInput'))
                {
                    $nonce = $this->_post->toString('payment_method_nonce');
                }
                else
                {
                    $nonce = @$_POST['payment_method_nonce'] ? $pjAppModel->escapeStr($_POST['payment_method_nonce']): null;
                }

				try {
					$result = Braintree\Transaction::sale(array(
						'amount' => $amount,
						'paymentMethodNonce' => $nonce,
						'options' => array(
							'submitForSettlement' => true
	                    )
	                ));
		
					if ($result->success || !is_null($result->transaction)) {
						$transaction_result = $result->transaction;
						$transaction = Braintree\Transaction::find($transaction_result->id);
		
						$transactionSuccessStatuses = array(
	                        Braintree\Transaction::AUTHORIZED,
	                        Braintree\Transaction::AUTHORIZING,
	                        Braintree\Transaction::SETTLED,
	                        Braintree\Transaction::SETTLING,
	                        Braintree\Transaction::SETTLEMENT_CONFIRMED,
	                        Braintree\Transaction::SETTLEMENT_PENDING,
	                        Braintree\Transaction::SUBMITTED_FOR_SETTLEMENT
	                    );
		
						if (in_array($transaction->status, $transactionSuccessStatuses)) 
						{
							$_SESSION[$this->pjBraintreeConfig] = NULL;
							unset($_SESSION[$this->pjBraintreeConfig]);
							
							$decoded_url = base64_decode($notify_url);
							pjUtil::redirect($decoded_url."&amount=".$amount.'&notify_url='.base64_encode($notify_url).'&custom='.$custom.'&hash='.$hash);
						} else {
							pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjBraintree&action=pjActionTransaction&id=".$transaction_result->id.'&notify_url='.$notify_url.'&custom='.$custom.'&hash='.$hash);
						}
					} else {
						$errorString = "";
		
						foreach ($result->errors->deepAll() as $error) {
							$errorString .= 'Error: ' . $error->code . ": " . $error->message . "\n";
						}
						
						$_SESSION[$this->pjBraintreeError][$time] = $errorString;
						pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjBraintree&action=pjActionIndex&tm=".$time);
					}
				} catch (Exception $e) {
					$_SESSION[$this->pjBraintreeError][$time] = __('plugin_braintree_config_missing', true);
					pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjBraintree&action=pjActionIndex&tm=".$time);
				}
			} else {
				$_SESSION[$this->pjBraintreeError][$time] = __('plugin_braintree_hash_error', true);
				pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjBraintree&action=pjActionIndex&tm=".$time);
			}
		}else{
			$_SESSION[$this->pjBraintreeError][$time] = __('plugin_braintree_config_missing', true);
			pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjBraintree&action=pjActionIndex&tm=".$time);
		}
	}
	public function pjActionTransaction()
	{
		if(isset($_SESSION[$this->pjBraintreeConfig]) && is_array($_SESSION[$this->pjBraintreeConfig]))
		{
			require_once $this->getConst('PLUGIN_DIR') . "vendor/lib/autoload.php";
		
			$config_arr = $_SESSION[$this->pjBraintreeConfig];
				
			Braintree\Configuration::environment($config_arr['environment']);
			Braintree\Configuration::merchantId($config_arr['merchant_id']);
			Braintree\Configuration::publicKey($config_arr['public_key']);
			Braintree\Configuration::privateKey($config_arr['private_key']);

			if (class_exists('pjInput'))
            {
                $id = $this->_get->toInt('id');
                $tm = $this->_get->toString('tm');
            }
            else
            {
                $pjAppModel = pjAppModel::factory();
                $id = (int) @$_GET['id'];
                $tm = @$_GET['tm'] ? $pjAppModel->escapeStr($_GET['tm']): null;
            }
			if($id)
			{
				$transaction = Braintree\Transaction::find($id);
				$this->set('transaction', $transaction);
			}
			
			if ($tm && isset($_SESSION[$this->pjBraintreeError][$tm]))
			{
				$this->set('tm_text', $_SESSION[$this->pjBraintreeError][$tm]);
				$_SESSION[$this->pjBraintreeError] = NULL;
				unset($_SESSION[$this->pjBraintreeError]);
			}
		}else{
			$this->set('tm_text', __('plugin_braintree_config_missing', true));
		}
	}
}
?>