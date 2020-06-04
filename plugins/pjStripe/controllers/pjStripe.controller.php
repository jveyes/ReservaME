<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjStripe extends pjStripeAppController
{
    private $paymentMethod = 'stripe';

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
        $params['amount'] *= 100;

        return $params;
    }

    public static function getPaymentLocale($localeId = null)
    {
        $locale = 'en'; // English (default)

        if($localeId && $locale_arr = pjLocaleModel::factory()->select('language_iso')->find($localeId)->getData())
        {
            $lang = strtok($locale_arr['language_iso'], '-');
            if(strpos($locale_arr['language_iso'], '-FI'))
            {
                $lang = 'fi';
            }
            elseif(strpos($locale_arr['language_iso'], '-NO') || in_array($locale_arr['language_iso'], array('nb', 'nn')))
            {
                $lang = 'no';
            }
            elseif(strpos($locale_arr['language_iso'], '-SE'))
            {
                $lang = 'sv';
            }

            $locales = array(
                'zh' => 'zh', // Simplified Chinese
                'da' => 'da', // Danish
                'nl' => 'nl', // Dutch
                'fi' => 'fi', // Finnish
                'fr' => 'fr', // French
                'de' => 'de', // German
                'it' => 'it', // Italian
                'ja' => 'ja', // Japanese
                'no' => 'no', // Norwegian
                'es' => 'es', // Spanish
                'sv' => 'sv', // Swedish
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
        $custom = isset($request['id'])? $request['id']: null;

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

		$this->set('arr', $this->getParams());
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

        $_response = $this->requestAction(array(
            'controller' => 'pjStripe',
            'action' => 'pjActionProcess',
            'params' => array(
                'key' => md5($this->option_arr['private_key'] . PJ_SALT),
                'token' => $request['stripeToken'],
                'private_key' => $options['private_key'],
                'amount' => $params['amount'] * 100,
                'currency' => $this->option_arr['o_currency'],
                'description' => pjSanitize::html($params['uuid']),
                'foreign_id' => $params['order_id'],
            )
        ), array('return'));
        if($_response['status'] == 'OK')
        {
            $response['status'] = 'OK';
            $response['txn_id'] = @$_response['result']['balance_transaction'];
        }

        return $response;
    }

	public function pjActionProcess()
	{
		$params = $this->getParams();
		if (!isset($params['key']) || $params['key'] != md5($this->option_arr['private_key'] . PJ_SALT))
		{
            $this->log($this->logPrefix . "Missing or invalid key parameter.");
			return array('status' => 'FAIL', 'code' => 100);
		}
		
		if (!(isset($params['token'], $params['private_key'], $params['amount'], $params['currency'])))
		{
            $this->log($this->logPrefix . "Missing, empty or invalid parameters.");
			return array('status' => 'FAIL', 'code' => 101);
		}
		
		require self::getConst('PLUGIN_DIR') . 'libs/stripe_php/lib/Stripe.php';
		Stripe::setApiKey($params['private_key']);
		try {
			$result = Stripe_Charge::create(array(
				"description" => @$params['item_name'],
				"amount" => $params['amount'],
				"currency" => $params['currency'],
				"card" => $params['token']
			));
			$result = $result->x__toArray(true);
			
			if ($result['paid'])
			{
				if (isset($params['foreign_id']))
				{
					$data = array_merge($params, array(
						'stripe_id' => $result['id'],
						'created' => $result['created']
					));
					self::pjActionSavePayment($params['foreign_id'], $data);
				}

                $this->log($this->logPrefix . "Payment was successful. TXN ID: {$result['balance_transaction']}.");
				return array('status' => 'OK', 'code' => 200, 'result' => $result);
			} else {
                $this->log($this->logPrefix . "Payment was not successful.");
				return array('status' => 'FAIL', 'code' => 102);
			}
		} catch (Exception $e) {
            $this->log($this->logPrefix . "Error: " . $e->getMessage());
			return array('status' => 'FAIL', 'code' => 103);
		}
	}
	
	private static function pjActionSavePayment($foreign_id, $data)
	{
		return pjStripeModel::factory()
			->setAttributes(array(
				'foreign_id' => $foreign_id,
				'stripe_id' => @$data['stripe_id'],
				'token' => @$data['token'],
				'amount' => @$data['amount']/100,
				'currency' => @$data['currency'],
				'description' => @$data['item_name'],
				'created' => preg_match('|^\d{10}$|', @$data['created']) ? sprintf(':FROM_UNIXTIME(%u)', @$data['created']) : @$data['created']
			))
			->insert()
			->getInsertId();
	}
	
	public function pjActionGetDetails()
	{
		$this->setAjax(true);
	
		if ($this->isXHR() && $this->isLoged() && $this->isAdmin())
		{
		    $id = null;
		    if (class_exists('pjInput'))
            {
                $id = $this->_get->toInt('id');
            }
            elseif (isset($_GET['id']) && (int) $_GET['id'] > 0)
            {
                $id = (int) $_GET['id'];
            }

			if ($id)
			{
				$this->set('arr', pjStripeModel::factory()->find($id)->getData());
			}
		}
	}
	
	public function pjActionGetStripe()
	{
		$this->setAjax(true);
	
		if ($this->isXHR() && $this->isLoged() && $this->isAdmin())
		{
			$pjStripeModel = pjStripeModel::factory();

			$q = null;
			if (class_exists('pjInput'))
            {
                $q = $this->_get->toString('q');
            }
            elseif (isset($_GET['q']) && !empty($_GET['q']))
            {
                $q = $pjStripeModel->escapeStr($_GET['q']);
            }
			if ($q)
			{
				$q = str_replace(array('%', '_'), array('\%', '\_'), $q);
				$pjStripeModel
					->where('t1.stripe_id LIKE', "%$q%")
					->orWhere('t1.token LIKE', "%$q%")
					->orWhere('t1.amount LIKE', "%$q%")
					->orWhere('t1.currency LIKE', "%$q%")
					->orWhere('t1.description LIKE', "%$q%")
					->orWhere('t1.created LIKE', "%$q%");
			}

			$column = 'created';
			$direction = 'DESC';
			if (class_exists('pjInput'))
            {
                if (in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
                {
                    $column = $this->_get->toString('column');
                    $direction = strtoupper($this->_get->toString('direction'));
                }
            }
            elseif (isset($_GET['direction']) && isset($_GET['column']) && in_array(strtoupper($_GET['direction']), array('ASC', 'DESC')))
            {
                $column = $_GET['column'];
                $direction = strtoupper($_GET['direction']);
            }
	
			$total = $pjStripeModel->findCount()->getData();
			if (class_exists('pjInput'))
            {
                $rowCount = $this->_get->toInt('rowCount') ?: 10;
    			$page = $this->_get->toInt('page') ?: 1;
            }
            else
            {
                $rowCount = isset($_GET['rowCount']) && (int) $_GET['rowCount'] > 0 ? (int) $_GET['rowCount'] : 10;
                $page = isset($_GET['page']) && (int) $_GET['page'] > 0 ? intval($_GET['page']) : 1;
            }
            $pages = ceil($total / $rowCount);
            $offset = ((int) $page - 1) * $rowCount;
			if ($page > $pages)
			{
				$page = $pages;
			}
	
			$data = $pjStripeModel->select('t1.*')
			    ->orderBy("`$column` $direction")->limit($rowCount, $offset)->findAll()->getData();
	
			pjAppController::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
		}
		exit;
	}
	
	public function pjActionIndex()
	{
	    if (!$this->isAdmin())
        {
            $this->sendForbidden();
            return;
        }

        $this->appendJs('pjStripe.js', $this->getConst('PLUGIN_JS_PATH'));
        if (pjObject::getPlugin('pjCms') !== null)
        {
            $this->appendJs('jquery.datagrid.js', $this->getConstant('pjCms', 'PLUGIN_JS_PATH'), false, false);
            $this->appendJs('index.php?controller=pjCms&action=pjActionMessages', PJ_INSTALL_URL, true);
        }
        else
        {
            $this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
            $this->appendJs('index.php?controller=pjAdmin&action=pjActionMessages', PJ_INSTALL_URL, true);
        }
	}
}
?>