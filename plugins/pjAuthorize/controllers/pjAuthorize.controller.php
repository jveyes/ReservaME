<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAuthorize extends pjAuthorizeAppController
{
	private $currencies = array(
		'AUD',
		'GBP',
		'CAD',
		'DKK',
		'EUR',
		'NZD',
		'NOK',
		'PLN',
		'SEK',
		'CHF',
		'USD',
	);

    private $paymentMethod = 'authorize';

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

        $params = $this->getParams();

        $this->set('arr', pjPaymentOptionModel::factory()->getOptions($params['foreign_id'], $this->paymentMethod));
        
        $i18n = pjMultiLangModel::factory()->getMultiLang($params['fid'], 'pjPayment');
        $this->set('i18n', $i18n);
        
        $locale_arr = pjLocaleModel::factory()
        	->select('t1.*, t2.file')
	        ->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
	        ->where('t2.file IS NOT NULL')
	        ->orderBy('t1.sort ASC')
        	->findAll()
        	->getData();
        
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

        return $params;
    }

    public function pjActionGetCustom()
    {
        $request = $this->getParams();
        $custom = isset($request['x_invoice_num'])? $request['x_invoice_num']: null;

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

	public function pjActionGetCurrencies()
	{
		return $this->currencies;
	}
	
	public function pjActionCheckCurrency()
	{
		$params = $this->getParams();
		
		if (!isset($params['currency']) || empty($params['currency']))
		{
			return array('status' => 'ERR', 'code' => 100, 'text' => 'Missing or empty \'currency\' parameter');
		}
		
		$currency = strtoupper($params['currency']);
		
		if (!in_array($currency, $this->currencies))
		{
			return array(
				'status' => 'ERR', 
				'code' => 101, 
				'text' => sprintf(__('plugin_authorize_currency_not_supported', true), $currency),
				'currency' => $currency,
				'currencies' => $this->currencies,
			);
		}
		
		return array(
			'status' => 'OK', 
			'code' => 200, 
			'text' => sprintf(__('plugin_authorize_currency_supported', true), $currency),
			'currency' => $currency,
			'currencies' => $this->currencies,
		);
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

        $options = pjPaymentOptionModel::factory()->getOptions($params['foreign_id'], $this->paymentMethod);
		
		if (isset($options['merchant_id'], $options['public_key'], $options['private_key']) &&
			!empty($options['merchant_id']) && !empty($options['public_key']))
		{
			define("AUTHORIZENET_API_LOGIN_ID", $options['merchant_id']);
			define("AUTHORIZENET_TRANSACTION_KEY", $options['public_key']);
			define("AUTHORIZENET_PRIVATE_KEY", $options['private_key']);
			define("AUTHORIZENET_SANDBOX", PJ_TEST_MODE);
			define("TEST_REQUEST", PJ_TEST_MODE);
		
			require_once $this->getConst('PLUGIN_DIR') . 'anet_php_sdk/AuthorizeNet.php';
			$resp = new AuthorizeNetSIM($options['merchant_id'], $options['private_key'], $request);

	    	if ($resp->isAuthorizeNet())
	    	{
	        	if ($resp->approved)
	        	{
					// Transaction approved!
                    $response['status'] = 'OK';
                    $response['txn_id'] = $request['x_trans_id'];
                    $this->log($this->logPrefix . "Payment was successful. Transaction ID: {$response['txn_id']}.");
				} else {
					// There was a problem.
                    $this->log($this->logPrefix . "Error: " . sprintf('Reason text: %s | Reason code: %s | Code: %s', $resp->response_reason_text, $resp->response_reason_code, $resp->response_code));
                    $response['response_reason_code'] = $resp->response_reason_code;
                    $response['response_code'] = $resp->response_code;
                    $response['response_reason_text'] = $resp->response_reason_text;
				}
			} else {
                $this->log($this->logPrefix . "Payment was not successful. Hash mismatch.");
			}
		} else {
            $this->log($this->logPrefix . "Missing, empty or invalid parameters.");
		}

		return $response;
	}
	
	public function pjActionForm()
	{
        $this->setLayout('pjActionEmpty');

		$this->set('arr', $this->getParams());
	}
}
?>