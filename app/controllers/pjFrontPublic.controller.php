<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFrontPublic extends pjFront
{
	public function __construct()
	{
		parent::__construct();
		
		$this->setAjax(true);
		
		$this->setLayout('pjActionEmpty');
	}
	
	public function pjActionCart()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			$this->set('cart_arr', $this->getCart($this->getForeignId()));
		}
	}
	
	public function pjActionCheckout()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			if ($this->cart->isEmpty())
			{
				$this->set('status', 'ERR');
				$this->set('code', '101'); //Empty cart
				return;
			}
			
			if ($this->_post->check('as_checkout'))
			{
				$_SESSION[$this->defaultForm] = array_merge($_SESSION[$this->defaultForm], $this->_post->raw());
				self::jsonResponse(array('status' => 'OK', 'code' => 211, 'text' => __('system_211', true)));
			}
			
			if (in_array($this->option_arr['o_bf_country'], array(2,3)))
			{
				$this->set('country_arr', pjBaseCountryModel::factory()
					->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.status', 'T')
					->orderBy('`name` ASC')
					->findAll()
					->getData()
				);
			}
			
			$cart = $this->cart->getAll();
			$cart_arr = $this->getCart($this->getForeignId());
			
			if ($this->option_arr['o_allow_bank'] == '1')
			{
				$bank_account = pjMultiLangModel::factory()->select('t1.content')
				->where('t1.model','pjOption')
				->where('t1.locale', $this->getLocaleId())
				->where('t1.field', 'o_bank_account')
				->limit(1)
				->findAll()->getDataIndex(0);
				$this->set('bank_account', $bank_account['content']);
			}
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions(NULL));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
			
			$this->set('status', 'OK');
			$this->set('terms_arr', $this->getTerms($this->getForeignId()));
			$this->set('summary', $this->getSummary());
			$this->set('cart', $cart);
			$this->set('cart_arr', $cart_arr);
		}
	}
	
	public function pjActionService()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			$service_id = null;
			$employee_id = null;
			$date = date('Y-m-d');
				
			if($this->_get->check('date'))
			{
				$date = $this->_get->toString('date');
			}
			
			if ($this->_get->check('service_id') && $this->_get->toInt('service_id') > 0 && $this->_get->check('employee_id') && $this->_get->toInt('employee_id') > 0){
				$service_id = $this->_get->toInt('service_id');
				$employee_id = $this->_get->toInt('employee_id');
			}elseif ($this->_get->check('service_id') && $this->_get->toInt('service_id') > 0){
				$service_id = $this->_get->toInt('service_id');
			}elseif ($this->_get->check('_escaped_fragment_')) {
				preg_match('/\/Service\/(\d+)/', $this->_get->toString('_escaped_fragment_'), $matches);
				if (isset($matches[1]))
				{
					$service_id = $matches[1];
				}
				preg_match('/\/Service\/(\d+)\/(\d+)/', $this->_get->toString('_escaped_fragment_'), $matches);
				if (isset($matches[1]))
				{
					$service_id = $matches[1];
				}
				if (isset($matches[2]))
				{
					$employee_id = $matches[2];
				}
			
				preg_match('@^/Service/[\w\-]+\-(\d+)\.html$@', $this->_get->toString('_escaped_fragment_'), $matches);
				if ($matches)
				{
					$service_id = $matches[1];
				}
			
				preg_match('@^/Service/\d{4}/\d{2}/\d{2}/[\w\-]+\-(\d+)/[\w\-]+\-(\d+)\.html$@', $this->_get->toString('_escaped_fragment_'), $matches);
				if ($matches)
				{
					$service_id = $matches[1];
					$employee_id = $matches[2];
				}
			}
			
			list($year, $month, $day) = explode("-", $this->_get->toString('date'));
			$dates = $this->getDates($this->getForeignId(), $year, $month);
			$this->set('calendar', $this->getCalendar($dates[0], $year, $month, $day));
			
			$_employee_arr = pjEmployeeModel::factory()
				->select("t1.*, t2.content AS `name`")
				->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.calendar_id', $this->getForeignId())
				->where("t1.id IN (SELECT TES.employee_id FROM `".pjEmployeeServiceModel::factory()->getTable()."` AS TES WHERE TES.service_id='".$service_id."') ")
				->where('t1.is_active', 'T')
				->findAll()
				->getData();
			$employee_arr = array();
			foreach($_employee_arr as $k => $v)
			{
				$app_info = pjAppController::getAppointmentInfo($v['id'], $service_id, $this->getForeignId(), $date, $this->getLocaleId(), $this->option_arr);
				if (!$app_info['employee']['t_arr'])
				{
					unset($_employee_arr[$k]);
				}else{
					$employee_arr[] = $v;
				}
			}
			if(count($employee_arr) == 1)
			{
				$employee_id = $employee_arr[0]['id'];
			}
			if($service_id != null && $employee_id != null)
			{
			    $app_info = pjAppController::getAppointmentInfo($employee_id, $service_id, $this->getForeignId(), $date, $this->getLocaleId(), $this->option_arr);
				$this->set('service', $app_info['service']);
				$this->set('employee', $app_info['employee']);
			}
			
			if ($this->cart->isEmpty())
			{
				$this->set('status', 'ERR');
				$this->set('code', '101');
			}
			
			$this->set('date', $date);
			
			$this
				->set('service_arr', pjServiceModel::factory()
					->select("t1.*, t2.content AS `name`, t3.content AS `description`")
					->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.locale='".$this->getLocaleId()."' AND t2.field='name'", 'left outer')
					->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.locale='".$this->getLocaleId()."' AND t3.field='description'", 'left outer')
					->where('t1.calendar_id', $this->getForeignId())
					->where('t1.is_active', 1)
					->orderBy('`name` ASC')
					->findAll()
					->getData()
				)
				->set('employee_arr', $employee_arr)
				->set('cart_arr', $this->getCart($this->getForeignId()));
			
			if((int) $this->option_arr['o_booking_days_earlier'] > 0)
			{
				$today_ts = strtotime(date('Y-m-d 00:00:00', time()));
				$days_earlier = $this->option_arr['o_booking_days_earlier'] * 24 * 60 * 60;
				$ahead_ts = $today_ts + $days_earlier;
				$selected_ts = strtotime($this->_get->toString('date') . ' 00:00:00');
				
				if($selected_ts > $ahead_ts)
				{
					$this->set('unavailable', true);
				}
			}
		}
	}
	
	public function pjActionServices()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			$service_arr = pjServiceModel::factory()
				->select("t1.*, t2.content AS `name`, t3.content AS `description`")
				->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.locale='".$this->getLocaleId()."' AND t2.field='name'", 'left outer')
				->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.locale='".$this->getLocaleId()."' AND t3.field='description'", 'left outer')
				->where('t1.calendar_id', $this->getForeignId())
				->where('t1.is_active', 1)
				->orderBy('`name` ASC')
				->findAll()
				->getData();
			
			$_employee_arr = pjEmployeeModel::factory()
				->select("t1.*, t2.content AS `name`, 
							(
								SELECT GROUP_CONCAT(TL.content SEPARATOR ',') 
								FROM `".pjServiceModel::factory()->getTable()."` AS TS LEFT OUTER JOIN `".pjMultiLangModel::factory()->getTable()."` AS TL ON TL.model='pjService' AND TL.foreign_id=TS.id AND TL.locale='".$this->getLocaleId()."' AND TL.field='name' 
								WHERE TS.is_active='1' AND TS.id IN (
						                         	SELECT TES.service_id 
													FROM `".pjEmployeeServiceModel::factory()->getTable()."` AS TES 
													WHERE TES.employee_id = t1.id
												) 
							) AS services,
							(	SELECT GROUP_CONCAT(TS.id SEPARATOR '~:~') 
								FROM `".pjServiceModel::factory()->getTable()."` AS TS
								WHERE TS.is_active='1' AND TS.id IN (
						                         	SELECT TES.service_id 
													FROM `".pjEmployeeServiceModel::factory()->getTable()."` AS TES 
													WHERE TES.employee_id = t1.id
												)
							) AS service_ids")
				->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.calendar_id', $this->getForeignId())
				->where('t1.is_active', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData();
			
			$service_id_arr = array();
			$employee_arr = array();
			foreach($_employee_arr as $k => $v)
			{
				$wt_arr = pjAppController::getRawSlotsPerEmployee($v['id'], $this->_get->toString('date'),  $this->getForeignId());
				if($wt_arr == false)
				{
					unset($_employee_arr[$k]);
				}else{
					$employee_arr[] = $v;
				}
			}
			foreach($employee_arr as $k => $v)
			{
				if(!empty($v['service_ids']))
				{
					$_arr = explode("~:~", $v['service_ids']);
					foreach($_arr as $sid)
					{
						if(isset($service_id_arr[$sid]))
						{
							$service_id_arr[$sid] += 1;
						}else{
							$service_id_arr[$sid] = 1;
						}
					}
				}
			}
			
			$this->set('service_id_arr', $service_id_arr);
			$this->set('service_arr', $service_arr);
			$this->set('employee_arr', $employee_arr);
			$this->set('cart_arr',  $this->getCart($this->getForeignId()));
			
			list($year, $month, $day) = explode("-", $this->_get->toString('date'));
			$dates = $this->getDates($this->getForeignId(), $year, $month);
			$this->set('calendar', $this->getCalendar($dates[0], $year, $month, $day));
			
			if((int) $this->option_arr['o_booking_days_earlier'] > 0)
			{
				$today_ts = strtotime(date('Y-m-d 00:00:00', time()));
				$days_earlier = $this->option_arr['o_booking_days_earlier'] * 24 * 60 * 60;
				$ahead_ts = $today_ts + $days_earlier;
				$selected_ts = strtotime($this->_get->toString('date') . ' 00:00:00');
				
				if($selected_ts > $ahead_ts)
				{
					$this->set('unavailable', true);
				}
			}
			switch ($this->_get->toString('layout'))
			{
				case 2:
					$this->setTemplate('pjFrontPublic', 'pjActionServices');
					break;
				case 1:
				default:
					$this->setTemplate('pjFrontPublic', 'pjActionEmployees');
					break;
			}
		}
	}
	
	public function pjActionEmployee()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			$service_id = null;
			$employee_id = null;
			$date = date('Y-m-d');
	
			if($this->_get->check('date'))
			{
				$date = $this->_get->toString('date');
			}
				
			if ($this->_get->check('service_id') && (int) $this->_get->toInt('service_id') > 0 && $this->_get->check('employee_id') && $this->_get->toInt('employee_id') > 0){
				$service_id = (int) $this->_get->toInt('service_id');
				$employee_id = $this->_get->toInt('employee_id');
			}elseif ($this->_get->check('employee_id') && $this->_get->toInt('employee_id') > 0){
				$employee_id = $this->_get->toInt('employee_id');
			}elseif ($this->_get->check('_escaped_fragment_')) {
				preg_match('/\/Employee\/(\d+)/', $this->_get->toString('_escaped_fragment_'), $matches);
				if (isset($matches[1]))
				{
					$employee_id = $matches[1];
				}
				preg_match('/\/Employee\/(\d+)\/(\d+)/', $this->_get->toString('_escaped_fragment_'), $matches);
				if (isset($matches[1]))
				{
					$employee_id = $matches[1];
				}
				if (isset($matches[2]))
				{
					$service_id = $matches[2];
				}
					
				preg_match('@^/Employee/[\w\-]+\-(\d+)\.html$@', $this->_get->toString('_escaped_fragment_'), $matches);
				if ($matches)
				{
					$employee_id = $matches[1];
				}
					
				preg_match('@^/Employee/\d{4}/\d{2}/\d{2}/[\w\-]+\-(\d+)/[\w\-]+\-(\d+)\.html$@', $this->_get->toString('_escaped_fragment_'), $matches);
				if ($matches)
				{
					$employee_id = $matches[1];
					$service_id = $matches[2];
				}
			}
				
			list($year, $month, $day) = explode("-", $this->_get->toString('date'));
			$dates = $this->getDates($this->getForeignId(), $year, $month);
			$this->set('calendar', $this->getCalendar($dates[0], $year, $month, $day));

			$service_arr = pjServiceModel::factory()
				->select("t1.*, t2.content AS `name`")
				->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.calendar_id', $this->getForeignId())
				->where("t1.id IN (SELECT TES.service_id FROM `".pjEmployeeServiceModel::factory()->getTable()."` AS TES WHERE TES.employee_id='".$employee_id."') ")
				->where('t1.is_active', 1)
				->findAll()
				->getData();
			
			if(count($service_arr) == 1)
			{
				$service_id = $service_arr[0]['id'];
			}
			if($service_id != null && $employee_id != null)
			{
			    $app_info = pjAppController::getAppointmentInfo($employee_id, $service_id, $this->getForeignId(), $date, $this->getLocaleId(), $this->option_arr);
				$this->set('service', $app_info['service']);
				$this->set('employee', $app_info['employee']);
			}
			if ($this->cart->isEmpty())
			{
				$this->set('status', 'ERR');
				$this->set('code', '101');
			}
			
			$this->set('date', $date);
				
			$_employee_arr = pjEmployeeModel::factory()
				->select("t1.*, t2.content AS `name`,
							(
								SELECT GROUP_CONCAT(TL.content SEPARATOR ',')
								FROM `".pjServiceModel::factory()->getTable()."` AS TS LEFT OUTER JOIN `".pjMultiLangModel::factory()->getTable()."` AS TL ON TL.model='pjService' AND TL.foreign_id=TS.id AND TL.locale='".$this->getLocaleId()."' AND TL.field='name'
								WHERE TS.is_active='1' AND TS.id IN (
						                         	SELECT TES.service_id
													FROM `".pjEmployeeServiceModel::factory()->getTable()."` AS TES
													WHERE TES.employee_id = t1.id
												)
							) AS services")
				->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.calendar_id', $this->getForeignId())
				->where('t1.is_active', 'T')
				->orderBy('t2.content ASC')
				->findAll()
				->getData();

			$employee_arr = array();
			foreach($_employee_arr as $k => $v)
			{
				$wt_arr = pjAppController::getRawSlotsPerEmployee($v['id'], $date,  $this->getForeignId());
				if($wt_arr == false)
				{
					unset($_employee_arr[$k]);
				}else{
					$employee_arr[] = $v;
				}
			}
			if((int) $this->option_arr['o_booking_days_earlier'] > 0)
			{
				$today_ts = strtotime(date('Y-m-d 00:00:00', time()));
				$days_earlier = $this->option_arr['o_booking_days_earlier'] * 24 * 60 * 60;
				$ahead_ts = $today_ts + $days_earlier;
				$selected_ts = strtotime($this->_get->toString('date') . ' 00:00:00');
					
				if($selected_ts > $ahead_ts)
				{
					$this->set('unavailable', true);
				}
			}
			
			$this
				->set('employee_arr', $employee_arr)
				->set('service_arr', $service_arr)
				->set('cart_arr', $this->getCart($this->getForeignId()));
		}
	}
	
	public function pjActionBooking()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			$this->set('status', 'OK');
			
			if ($this->_get->check('booking_uuid') && $this->_get->toString('booking_uuid') != '')
			{
				$booking_uuid = $this->_get->toString('booking_uuid');
			} elseif ($this->_get->check('_escaped_fragment_')) {
				preg_match('/\/Booking\/([A-Z]{2}\d{10})/', $this->_get->toString('_escaped_fragment_'), $matches);
				if (isset($matches[1]))
				{
					$booking_uuid = $matches[1];
				}
			}
			
			$booking_arr = pjBookingModel::factory()->where('t1.uuid', $booking_uuid)->findAll()->limit(1)->getData();
			if (!empty($booking_arr))
			{
				$booking_arr = $booking_arr[0];
				
				if(pjObject::getPlugin('pjPayments') !== NULL)
				{
					$pjPlugin = pjPayments::getPluginName($booking_arr['payment_method']);
					if(pjObject::getPlugin($pjPlugin) !== NULL)
					{
						$this->set('params', $pjPlugin::getFormParams(array('payment_method' => $booking_arr['payment_method']), array(
								'locale_id'	 => $this->getLocaleId(),
								'return_url'	=> $this->option_arr['o_thankyou_page'],
								'id'			=> $booking_arr['id'],
								'foreign_id'	=> NULL,
								'uuid'		  => $booking_arr['uuid'],
								'name'		  => $booking_arr['c_name'],
								'email'		 => $booking_arr['c_email'],
								'phone'		 => $booking_arr['c_phone'],
								'amount'		=> $booking_arr['booking_deposit'],
								'cancel_hash'   => sha1($booking_arr['uuid'].strtotime($booking_arr['created']).PJ_SALT),
								'currency_code' => $this->option_arr['o_currency'],
						)));
					}
				
					if ($booking_arr['payment_method'] == 'bank')
					{
						$bank_account = pjMultiLangModel::factory()->select('t1.content')
						->where('t1.model','pjOption')
						->where('t1.locale', $this->getLocaleId())
						->where('t1.field', 'o_bank_account')
						->limit(1)
						->findAll()->getDataIndex(0);
						$this->set('bank_account', $bank_account['content']);
					}
				}
				
				$this->set('booking_arr', $booking_arr);
			}
		}
	}
	
	public function pjActionPreview()
	{
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			if ($this->cart->isEmpty())
			{
				$this->set('status', 'ERR');
				$this->set('code', '101'); //Empty cart
				return;
			}
			
			if (!isset($_SESSION[$this->defaultForm]) || empty($_SESSION[$this->defaultForm]))
			{
				$this->set('status', 'ERR');
				$this->set('code', '102'); //Checkout form not filled
				return;
			}
			
			if (in_array($this->option_arr['o_bf_country'], array(2,3)) && (int) @$_SESSION[$this->defaultForm]['c_country_id'] > 0)
			{
				$this->set('country_arr', pjBaseCountryModel::factory()
					->select('t1.*, t2.content AS name')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->find($_SESSION[$this->defaultForm]['c_country_id'])
					->getData()
				);
			}
			$cart = $this->cart->getAll();
			$cart_arr = $this->getCart($this->getForeignId());
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions(NULL));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
			
			if ($this->option_arr['o_allow_bank'] == '1')
			{
				$bank_account = pjMultiLangModel::factory()->select('t1.content')
				->where('t1.model','pjOption')
				->where('t1.locale', $this->getLocaleId())
				->where('t1.field', 'o_bank_account')
				->limit(1)
				->findAll()->getDataIndex(0);
				$this->set('bank_account', $bank_account['content']);
			}
			
			$this->set('status', 'OK');
			$this->set('summary', $this->getSummary());
			$this->set('cart', $cart);
			$this->set('cart_arr', $cart_arr);
		}
	}
		
	public function pjActionLoadCart()
	{	
		$this->setAjax(true);
		
		if ($this->isXHR() || $this->_get->check('_escaped_fragment_'))
		{
			if ($this->cart->isEmpty())
			{
				$this->set('status', 'ERR');
				$this->set('code', '101');
				return;
			}
			$this->set('status', 'OK');
			$this->set('cart_arr', $this->getCart($this->getForeignId()));
			$this->setTemplate('pjFrontPublic', 'pjActionLoadCart');
		}
	}
	
	public function pjActionRouter()
	{
		$this->setAjax(false);

		if ($this->_get->check('_escaped_fragment_'))
		{
			$templates = array('Checkout', 'Preview', 'Service', 'Services', 'Booking', 'Cart', 'Appointment');
			preg_match('/^\/(\w+).*/', $this->_get->toString('_escaped_fragment_'), $m);
			if (isset($m[1]) && in_array($m[1], $templates))
			{
				$template = 'pjAction'.$m[1];
			
				if (method_exists($this, $template))
				{
					$this->$template();
				}
				$this->setTemplate('pjFrontPublic', $template);
			}
		}
	}
	
}
?>