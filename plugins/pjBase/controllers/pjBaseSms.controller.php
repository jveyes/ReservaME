<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjBaseSms extends pjBase
{
	public function __construct()
	{
		$requireLogin = false;
		$_get = pjRegistry::getInstance()->get('_get');
		if (in_array($_get->toString('action'), array('pjActionIndex'))) {
			$requireLogin = true;
		}
		parent::__construct($requireLogin);
	}
    public function pjActionIndex()
    {
        $pjAuth = pjAuth::factory();
        if (!$pjAuth->hasAccess('settings') && !$pjAuth->hasAccess('list'))
        {
            $this->sendForbidden();
            return;
        }

        if (self::isPost() && $this->_post->toInt('sms_post') == 1)
        {
            $pjBaseOptionModel = pjBaseOptionModel::factory();
            
            if (0 != $pjBaseOptionModel
                ->where('foreign_id', $this->getForeignId())
                ->where('`key`', 'plugin_sms_api_key')
                ->findCount()->getData()
                )
            {
                $pjBaseOptionModel
                ->limit(1)
                ->modifyAll(array(
                    'value' => $this->_post->toString('plugin_sms_api_key')
                ));
            } else {
                $pjBaseOptionModel->setAttributes(array(
                    'foreign_id' => $this->getForeignId(),
                    'key' => 'plugin_sms_api_key',
                    'tab_id' => '99',
                    'value' => $this->_post->toString('plugin_sms_api_key'),
                    'type' => 'string',
                    'is_visible' => 0
                ))->insert();
            }
            
            pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjBaseSms&action=pjActionIndex&err=PSS01");
        }
        if(self::isGet())
        {
            $this->set('has_access_settings', $pjAuth->hasAccess('settings'));
            $this->set('has_access_list', $pjAuth->hasAccess('list'));
            
            $this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
            $this->appendJs('pjBaseSms.js', $this->getConst('PLUGIN_JS_PATH'));
        }
    }
    
    public function pjActionGetSms()
    {
        $this->setAjax(true);
        
        $this->checkLogin();
        if (!pjAuth::factory('pjBaseSms', 'pjActionIndex_list')->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
        
        $pjBaseSmsModel = pjBaseSmsModel::factory();
        
        if ($q = $this->_get->toString('q'))
        {
            $q = str_replace(array('%', '_'), array('\%', '\_'), $q);
            $pjBaseSmsModel->where("(t1.number LIKE '%$q%' OR t1.text LIKE '%$q%')");
        }
        
        $column = 'created';
        $direction = 'DESC';
        if ($this->_get->toString('direction') && $this->_get->toString('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
        {
            $column = $this->_get->toString('column');
            $direction = strtoupper($this->_get->toString('direction'));
        }
        
        $total = $pjBaseSmsModel->findCount()->getData();
        $rowCount = $this->_get->toInt('rowCount') > 0 ? $this->_get->toInt('rowCount') : 10;
        $pages = ceil($total / $rowCount);
        $page = $this->_get->toInt('page') > 0 ? $this->_get->toInt('page') : 1;
        $offset = ((int) $page - 1) * $rowCount;
        if ($page > $pages)
        {
            $page = $pages;
        }
        
        $data = $pjBaseSmsModel->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
        
        foreach ($data as &$item)
        {
            if (!empty($item['created']))
            {
                $ts = strtotime($item['created']);
                $date = date('Y-m-d', $ts);
                $time = date('H:i:s', $ts);
                if (isset($this->option_arr['o_date_format']) && !empty($this->option_arr['o_date_format']))
                {
                    $date = date($this->option_arr['o_date_format'], $ts);
                }
                if (isset($this->option_arr['o_time_format']) && !empty($this->option_arr['o_time_format']))
                {
                    $time = date($this->option_arr['o_time_format'], $ts);
                }
                $item['created'] = $date . ', ' . $time;
            } else {
                $item['created'] = NULL;
            }
            $statuses = __('plugin_base_sms_statuses', true);
            $item['status'] = isset($statuses[$item['status']]) ? $statuses[$item['status']] : $item['status'];
        }
        
        self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
        
        exit;
    }
    
    public function pjActionTestSms()
    {
        $this->setAjax(true);
        
        $this->checkLogin();
        if (!pjAuth::factory('pjBaseSms', 'pjActionIndex_settings')->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
            
        if(!self::isPost())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'title' => __('plugin_base_sms_failed_to_send', true), 'text' => __('plugin_base_sms_test_invalid_method', true)));
        }
        if(!$this->_post->toString('plugin_sms_api_key'))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'title' => __('plugin_base_sms_failed_to_send', true), 'text' => __('plugin_base_sms_test_empty_api_key', true)));
        }
        if(!$this->_post->toString('number'))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'title' => __('plugin_base_sms_failed_to_send', true), 'text' => __('plugin_base_sms_test_empty_number', true)));
        }
        
        $pjSmsApi = new pjSmsApi();
        
        $response = $pjSmsApi
        ->setType('unicode')
        ->setApiKey($this->_post->toString('plugin_sms_api_key'))
        ->setNumber($this->_post->toString('number'))
        ->setText(__('plugin_base_sms_test_message', true))
        ->setSender(null)
        ->send();
        
        if($response == 1)
        {
            $text = __('plugin_base_sms_test_sms_sent_to', true) . ' ' . $this->_post->toString('number');
            self::jsonResponse(array('status' => 'OK', 'code' => 200, 'title' => __('plugin_base_sms_sent', true), 'text' => $text));
        }else{
            $statuses = __('plugin_base_sms_statuses', true);
            $text = isset($statuses[$response]) ? $statuses[$response] : $response;
            self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'title' => __('plugin_base_sms_failed_to_send', true), 'text' => $text));
        }
        exit;
    }
    
    public function pjActionVerify()
    {
        $this->setAjax(true);
        
        $this->checkLogin();
        if (!pjAuth::factory('pjBaseSms', 'pjActionIndex_settings')->hasAccess())
        {
            $this->sendForbidden();
            return;
        }
        
        if(!self::isPost())
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => __('plugin_base_sms_key_text_ARRAY_100',true)));
        }
        if(!$this->_post->toString('plugin_sms_api_key'))
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => __('plugin_base_sms_key_text_ARRAY_101',true)));
        }
        
        $pjHttp = new pjHttp();
        $response = $pjHttp
        ->setMethod('post')
        ->setData(array('key' => $this->_post->toString('plugin_sms_api_key')))
        ->curlRequest('https://www.phpjabbers.com/web-sms/api/verify.php')
        ->getResponse();
        
        $response = self::jsonDecode($response);
        if ($response['status'] == 'OK')
        {
            self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => __('plugin_base_sms_key_is_correct', true)));
        }
        else
        {
            self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => __('plugin_base_sms_key_text_ARRAY_' . $response['code'],true)));
        }
    }
    
    public function pjActionSend()
    {
        $this->setAjax(true);
        
        $params = $this->getParams();
        if (!isset($params['key']) || $params['key'] != md5($this->option_arr['private_key'] . PJ_SALT) ||
            !isset($params['number']) || !isset($params['text']) || !isset($this->option_arr['plugin_sms_api_key']))
        {
            return FALSE;
        }
        
        $pjSmsApi = new pjSmsApi();
        
        if (isset($params['type']))
        {
            $pjSmsApi->setType($params['type']);
        }
        
        $sender = null;
        if(isset($params['sender']) && !empty($params['sender']))
        {
            $sender = $params['sender'];
        }
        
        $response = $pjSmsApi
        ->setApiKey($this->option_arr['plugin_sms_api_key'])
        ->setNumber($params['number'])
        ->setText($params['text'])
        ->setSender($sender)
        ->send();
        
        pjBaseSmsModel::factory()->setAttributes(array(
            'number' => $pjSmsApi->getNumber(),
            'text' => $pjSmsApi->getText(),
            'status' => $response
        ))->insert();
        
        return $response;
    }
}
?>