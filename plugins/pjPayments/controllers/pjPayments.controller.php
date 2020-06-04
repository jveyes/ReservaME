<?php
if (!defined("ROOT_PATH"))
{
    header("HTTP/1.1 403 Forbidden");
    exit;
}
class pjPayments extends pjPaymentsAppController
{
    /*
     * Gets the titles set in payment methods' configuration. If a payment method's title is missing, the default name will be used.
     */
    public static function getPaymentTitles($foreign_id, $locale_id)
    {
        $i18n_arr = pjMultiLangModel::factory()->getMultiLang($foreign_id, 'pjPayment');
        $payment_titles = isset($i18n_arr[$locale_id]) ? $i18n_arr[$locale_id] : array();
        $payment_methods = __('payment_methods', true);
        foreach($payment_titles as $k => $v)
        {
            if(empty($v) && !empty($payment_methods[$k]))
            {
                $payment_titles[$k] = $payment_methods[$k];
            }
        }
        
        return $payment_titles;
    }
    
    /*
     * Gets the payment methods' keys and names.
     * Returns only the ones coming from the payment plugins. Excludes payment methods like cash, bank transfer etc.
     */
    public static function getPaymentMethods()
    {
        $payment_methods = __('payment_methods', true);
        $whitelist = pjPaymentOptionModel::factory()->getPaymentMethods();
        $payment_methods = array_intersect_key($payment_methods, $whitelist);
        
        return $payment_methods;
    }
    
    /*
     * Gets the active payment methods' keys and names.
     * Returns only the ones coming from the payment plugins. Excludes payment methods like cash, bank transfer etc.
     */
    public static function getActivePaymentMethods($foreign_id)
    {
        $payment_methods = __('payment_methods', true);
        $whitelist = pjPaymentOptionModel::factory()->getActivePaymentMethods($foreign_id);
        $payment_methods = array_intersect_key($payment_methods, $whitelist);
        
        return $payment_methods;
    }
    
    public static function getPluginName($payment_method = null)
    {
        $plugin_name = null;
        if($payment_method)
        {
            $plugin_name = 'pj' . str_replace(' ', '', ucwords(str_replace('_', ' ', $payment_method)));
        }
        return $plugin_name;
    }
    
    public static function getFormParams($post, $order_arr)
    {
        $payment_method = $post['payment_method'];
        $payment_options = pjPaymentOptionModel::factory()->getOptions($order_arr['foreign_id'], $payment_method);
        
        $item_name = __("plugin_{$payment_method}_payment_title", true);
        if(empty($item_name))
        {
            $item_name = "Unique ID: {$order_arr['uuid']}";
        }
        else
        {
            $item_name .= " (Unique ID: {$order_arr['uuid']})";
        }
        
        $first_name = $last_name = null;
        if(isset($order_arr['first_name']) && isset($order_arr['last_name']))
        {
            $first_name = pjSanitize::html($order_arr['first_name']);
            $last_name = pjSanitize::html($order_arr['last_name']);
        }
        elseif(isset($order_arr['name']))
        {
            $pos = stripos($order_arr['name'], ' ');
            $first_name = pjSanitize::html(substr($order_arr['name'], 0, $pos));
            $last_name = pjSanitize::html(substr($order_arr['name'], $pos + 1));
        }
        
        $params = array(
            'plugin'            => pjPayments::getPluginName($payment_method),
            'name'              => 'pjOnlinePaymentForm',
            'id'                => 'pjOnlinePaymentForm_' . $payment_method,
            'locale_id'         => $order_arr['locale_id'],
            'item_name'         => $item_name,
            'amount'            => $order_arr['amount'],
            'custom'            => $order_arr['uuid'],
            'currency_code'     => $order_arr['currency_code'],
            'return_url'        => $order_arr['return_url'],
            'notify_url'        => PJ_INSTALL_URL . 'payments_webhook.php?payment_method=' . $payment_method,
            'cancel_hash'       => $order_arr['cancel_hash'],
            'option_foreign_id' => $payment_options['foreign_id'],
            'merchant_id'       => $payment_options['merchant_id'],
            'merchant_email'    => $payment_options['merchant_email'],
            'public_key'        => $payment_options['public_key'],
            'private_key'       => $payment_options['private_key'],
            'tz'                => $payment_options['tz'],
            'success_url'       => $payment_options['success_url'],
            'failure_url'       => $payment_options['failure_url'],
            'description'       => $payment_options['description']? $payment_options['description']: $item_name,
            'target'            => '_self',
            'first_name'        => $first_name,
            'last_name'         => $last_name,
            'email'             => pjSanitize::html($order_arr['email']),
            'phone'             => pjSanitize::html($order_arr['phone']),
        );
        
        return $params;
    }
    
    public function pjActionOptions()
    {
        $this->checkLogin();
        $this->setLayout('pjActionEmpty');
        $this->set('params', $this->getParams());
    }
    
    public function pjActionSaveOptions()
    {
        $this->checkLogin();
        
        $params = $this->getParams();
        
        pjPaymentOptionModel::factory()->saveOptions($params['data'], $params['foreign_id']);
        
        foreach($params['data'] as $payment_method => $data)
        {
            $pjPlugin = self::getPluginName($payment_method);
            if(pjObject::getPlugin($pjPlugin) !== NULL)
            {
                $this->requestAction(array(
                    'controller' => $pjPlugin,
                    'action' => 'pjActionSaveOptions',
                    'params' => array('foreign_id' => $params['foreign_id'], 'data' => $data)
                ), array('return'));
            }
        }
    }
    
    public function pjActionCopyOptions()
    {
        $this->checkLogin();
        
        $params = $this->getParams();
        
        pjPaymentOptionModel::factory()->copyOptions($params['from_foreign_id'], $params['to_foreign_id']);
        
        foreach(self::getPaymentMethods() as $payment_method => $name)
        {
            $pjPlugin = self::getPluginName($payment_method);
            if(pjObject::getPlugin($pjPlugin) !== NULL)
            {
                $this->requestAction(array(
                    'controller' => $pjPlugin,
                    'action' => 'pjActionCopyOptions',
                    'params' => $params
                ), array('return'));
            }
        }
    }
    
    public function pjActionDeleteOptions()
    {
        $this->checkLogin();
        
        $params = $this->getParams();
        
        pjPaymentOptionModel::factory()->deleteOptions($params['foreign_id']);
        
        foreach(self::getPaymentMethods() as $payment_method => $name)
        {
            $pjPlugin = self::getPluginName($payment_method);
            if(pjObject::getPlugin($pjPlugin) !== NULL)
            {
                $this->requestAction(array(
                    'controller' => $pjPlugin,
                    'action' => 'pjActionDeleteOptions',
                    'params' => $params
                ), array('return'));
            }
        }
    }
    
    public function getPaymentPlugin($requestData = array())
    {
        if(!isset($requestData['payment_method']) || empty($requestData['payment_method']))
        {
            $this->log("Payments | Payment method not found<br>Request Data:<br>" . print_r($requestData, true));
            return false;
        }
        
        $pjPlugin = self::getPluginName($requestData['payment_method']);
        if(pjObject::getPlugin($pjPlugin) === NULL)
        {
            $this->log("Payments | {$pjPlugin} plugin not found<br>Request Data:<br>" . print_r($requestData, true));
            return false;
        }
        
        return $pjPlugin;
    }
}
?>