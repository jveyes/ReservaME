<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFront extends pjAppController
{
	public $defaultForm = 'AppSched_Form';
	
	public $defaultCaptcha = 'AppSched_Captcha';
	
	public $defaultCart = 'AppSched_Cart';
	
	public $defaultLocale = 'AppSched_LocaleId';
	
	public $defaultView = 'AppSched_View';
	
	public $cart = NULL;
	
	public function __construct()
	{
		$this->setLayout('pjActionFront');
		
		if (!isset($_SESSION[$this->defaultCart]))
		{
			$_SESSION[$this->defaultCart] = array();
		}
		
		$this->cart = new pjCart($_SESSION[$this->defaultCart]);
		
		self::allowCORS();
	}
	
	public function afterFilter()
	{
		if ($this->_get->check('locale') && $this->_get->toInt('locale') > 0)
		{
			$this->pjActionSetLocale($this->_get->toInt('locale'));
		}
		
		if ($this->pjActionGetLocale() === FALSE)
		{
			$locale_arr = pjLocaleModel::factory()->where('is_default', 1)->limit(1)->findAll()->getData();
			if (count($locale_arr) === 1)
			{
				$this->pjActionSetLocale($locale_arr[0]['id']);
			}
		}
		if ($this->_get->check('action') && !in_array($this->_get->toArray('action'), array('pjActionLoadCss')))
		{
			$this->loadSetFields(true);
		}
		
		if (!$this->_get->check('hide') || ($this->_get->check('hide') && $this->_get->toInt('hide') !== 1) &&
				in_array($this->_get->toString('action'), array('pjActionServices', 'pjActionService', 'pjActionEmployees', 'pjActionEmployee', 'pjActionLoadCart', 'pjActionCart', 'pjActionCheckout', 'pjActionBooking', 'pjActionPreview', 'pjActionGetPaymentForm')))
		{
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file, t2.title')
			->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
				
			$this->set('locale_arr', $locale_arr);
		}
	}
	
	public function beforeFilter()
	{
		if (!isset($_SESSION[$this->defaultForm]))
		{
			$_SESSION[$this->defaultForm] = array(
				'date_from' => NULL,
				'date_to' => NULL,
				'hour_from' => NULL,
				'hour_to' => NULL,
				'minute_from' => NULL,
				'minute_to' => NULL
			);
		}
		
		return parent::beforeFilter();
	}

	public function beforeRender()
	{
		
	}
	
	public function pjActionLocale()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			if ($this->_get->toInt('locale_id'))
			{
				$this->pjActionSetLocale($this->_get->toInt('locale_id'));
				$this->loadSetFields(true);
			}
		}
		exit;
	}
	
	public function pjActionSetLocale($locale)
	{
		if ((int) $locale > 0)
		{
			$_SESSION[$this->defaultLocale] = (int) $locale;
		}
		return $this;
	}
	
	public function pjActionGetLocale()
	{
		return isset($_SESSION[$this->defaultLocale]) && (int) $_SESSION[$this->defaultLocale] > 0 ? (int) $_SESSION[$this->defaultLocale] : FALSE;
	}
	
	protected function getValidate($summary)
	{
		if ($this->cart->isEmpty())
		{
			return false;
		}

		if (!isset($summary['services']) || empty($summary['services']))
		{
			return false;
		}

		foreach ($summary['services'] as $service)
		{
			/*$key = $item['type'] . '_' . $item['id'];
			if ((int) $item['unavailable_days'] === 0 && (int) $item['cnt'] >= (int) $item['booked_qty'] + (int) $summary['cart'][$key])
			{
				//ok
			} else {
				// item not available
				return false;
			}*/
		}
		// Pass all checks
		return true;
	}
	
	protected function getSummary()
	{
		$FORM = @$_SESSION[$this->defaultForm];
		$tax = $total = $deposit = $price = 0;
		$service_ids = $services = $service_arr = array();
		
		$cart = $this->cart->getAll();
		foreach ($cart as $key => $qty)
		{
			list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
			$service_ids[] = $service_id;
		}
		
		if (!empty($service_ids))
		{
			$service_arr = pjServiceModel::factory()
				->select("t1.*, t2.content AS `name`")
				->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.locale='".$this->getLocaleId()."' AND t2.field='name'", 'left outer')
				->whereIn('t1.id', $service_ids)
				->findAll()
				->getDataPair('id');
		}
		
		foreach ($cart as $key => $qty)
		{
			list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
			$price += @$service_arr[$service_id]['price'];
			
			$start = date("H:i:s", (int) $start_ts);
			$services[] = array_merge(@$service_arr[$service_id], compact('date', 'start', 'start_ts', 'end_ts', 'employee_id'));
		}
		
		if ((float) $this->option_arr['o_tax'] > 0)
		{
			$tax = ($price * (float) $this->option_arr['o_tax']) / 100;
		}
		$total = $price + $tax;
		switch ($this->option_arr['o_deposit_type'])
		{
			case 'percent':
				$deposit = ($total * (float) $this->option_arr['o_deposit']) / 100;
				break;
			case 'amount':
				$deposit = (float) $this->option_arr['o_deposit'];
				break;
		}
		
		return compact('cart', 'services', 'tax', 'total', 'deposit', 'price');
	}

	protected function getDates($cid, $year=null, $month=null)
	{
		list($y, $n) = explode("-", date("Y-n"));
		$year = is_null($year) ? $y : $year;
		$month = is_null($month) ? $n : $month;
		
		return pjAppController::getDatesInRange($cid,
			date("Y-m-d", mktime(0, 0, 0, $month, 1, $year)),
			date("Y-m-d", mktime(0, 0, 0, $month+1, 0, $year))
		);
	}
	
	protected function getCalendar($dates, $year=null, $month=null, $day=null)
	{
		list($y, $n) = explode("-", date("Y-n"));
		$year = is_null($year) ? $y : $year;
		$month = is_null($month) ? $n : $month;
		
		$pjASCalendar = new pjASCalendar();
		
		$pjASCalendar
			->setPrevLink("&nbsp;")
			->setNextLink("&nbsp;")
			->setStartDay($this->option_arr['o_week_start'])
			->setWeekNumbers($this->option_arr['o_week_numbers'] == 1 ? 'left' : NULL)
			->setMonthNames(__('months', true))
			->setDayNames(__('day_names', true))
			->set('options', $this->option_arr)
			->set('dates', $dates);
			
		if (!is_null($day))
		{
			$pjASCalendar->setCurrentDate(mktime(0, 0, 0, $month, $day, $year));
		} else {
			$pjASCalendar->setCurrentDate(null);
		}
		
		return $pjASCalendar;
	}
	
	protected function getCart($cid)
	{
		$service_arr = array();
		if (!$this->cart->isEmpty())
		{
			$cart = $this->cart->getAll();
			$service_ids = $employee_ids = array();
			foreach ($cart as $key => $value)
			{
				list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
				$service_ids[] = $service_id;
				$employee_ids[] = $employee_id;
			}
			$service_ids = array_unique($service_ids);
			$employee_ids = array_unique($employee_ids);
			if (!empty($service_ids))
			{
				$service_arr = pjServiceModel::factory()
					->select('t1.*, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->whereIn('t1.id', $service_ids)
					->where('t1.calendar_id', $cid)
					->findAll()
					->getDataPair('id');
			}
			$employee_arr = array();
			if (!empty($employee_ids))
			{
				$employee_arr = pjEmployeeModel::factory()
					->select('t1.id, t1.email, t1.phone, t1.avatar, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->whereIn('t1.id', $employee_ids)
					->where('t1.calendar_id', $cid)
					->findAll()
					->getDataPair('id');
			}
			foreach ($cart as $key => $value)
			{
				list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key);
				
				if (isset($service_arr[$service_id]))
				{
					if (!isset($service_arr[$service_id]['employee_arr']))
					{
						$service_arr[$service_id]['employee_arr'] = array();
					}
					$service_arr[$service_id]['employee_arr'][$employee_id] = @$employee_arr[$employee_id];
				}
			}
		}
		
		return $service_arr;
	}
	
	protected function getServices($cid, $page=1)
	{
		$data = pjServiceModel::factory()
			->select(sprintf("t1.*, t2.content AS `name`, t3.content AS `description`,
				(SELECT GROUP_CONCAT(`employee_id` SEPARATOR '|')
					FROM `%1\$s` AS `es`
					INNER JOIN `%2\$s` AS `e` ON `e`.`id` = `es`.`employee_id` AND `e`.`is_active` = 'T'
					WHERE `es`.`service_id` = `t1`.`id`
					LIMIT 1) AS `employee_ids`", pjEmployeeServiceModel::factory()->getTable(), pjEmployeeModel::factory()->getTable()))
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.locale='".$this->getLocaleId()."' AND t2.field='name'", 'left outer')
			->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.locale='".$this->getLocaleId()."' AND t3.field='description'", 'left outer')
			->where('t1.calendar_id', $cid)
			->where('t1.is_active', 1)
			->orderBy('`name` ASC')
			->findAll()
			->toArray('employee_ids')
			->getData();
		
		return compact('data');
	}

	protected function getTerms($cid)
	{
		return pjCalendarModel::factory()
			->select('t1.*, t2.content AS terms_url, t3.content AS terms_body')
			->join('pjMultiLang', "t2.model='pjCalendar' AND t2.foreign_id=t1.id AND t2.field='terms_url' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->join('pjMultiLang', "t3.model='pjCalendar' AND t3.foreign_id=t1.id AND t3.field='terms_body' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
			->find($cid)
			->getData();
	}
	
	public function isXHR()
	{
		// CORS
		return parent::isXHR() || isset($_SERVER['HTTP_ORIGIN']);
	}
	
	static protected function allowCORS()
	{
		if (!isset($_SERVER['HTTP_ORIGIN']))
		{
			return;
		}
		
		header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
		header("Access-Control-Allow-Credentials: true");
		header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
		header("Access-Control-Allow-Headers: Origin, X-Requested-With");
		header('P3P: CP="ALL DSP COR CUR ADM TAI OUR IND COM NAV INT"');
		
		if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS')
		{
			exit;
		}
	}
	
	
	public function pjActionExportFeed()
	{
	    $this->setLayout('pjActionEmpty');
	    $access = true;
	    if($this->_get->check('p'))
	    {
	        $pjPasswordModel = pjPasswordModel::factory();
	        $arr = $pjPasswordModel
	        ->where('t1.password', $this->_get->toString('p'))
	        ->limit(1)
	        ->findAll()
	        ->getData();
	        if (count($arr) != 1)
	        {
	            $access = false;
	        }
	    }
	    if($access == true)
	    {
	        $get = $this->_get->raw();
	        pjExport::doExportData($get, 'feed', $this->getLocaleId(), $this->option_arr);
	    }else{
	        __('lblNoAccessToFeed');
	    }
	    exit;
	}
}
?>