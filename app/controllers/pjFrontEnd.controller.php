<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjFrontEnd extends pjFront
{
	public function __construct()
	{
		parent::__construct();
		
		$this->setAjax(true);
		
		$this->setLayout('pjActionEmpty');
	}
	
	public function pjActionAddToCart()
	{
		if ($this->isXHR())
		{
			if ($this->_get->check('cid') && $this->_post->check('date') && $this->_post->check('start_ts') && $this->_post->check('end_ts') && $this->_post->check('service_id') && $this->_post->check('employee_id'))
			{
				$cid = (int) pjObject::escapeString($this->_get->toString('cid'));
				$date = pjDateTime::formatDate($this->_post->toString('date'), $this->option_arr['o_date_format']);
				$key = sprintf("%u|%s|%u|%s|%s|%u", $cid, $date, $this->_post->toString('service_id'), $this->_post->toString('start_ts'), $this->_post->toString('end_ts'), $this->_post->toString('employee_id'));
				
				# Remove services at same date
				$cart = $this->cart->getAll();
				foreach ($cart as $cart_key => $whatever)
				{
					$pattern = sprintf('/^%u\|%s\|%u/', $cid, $date, $this->_post->toString('service_id'));
					if (preg_match($pattern, $cart_key))
					{
						$this->cart->remove($cart_key);
					}
				}
				# --
				
				$this->cart->update($key, 1);
				pjAppController::jsonResponse(array('status' => 'OK', 'code' => 206, 'text' => __('system_206', true)));
			}
			pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 105, 'text' => __('system_105', true)));
		}
		exit;
	}
	
	public function pjActionRemoveFromCart()
	{
		if ($this->isXHR())
		{
			if ($this->_get->check('cid') && $this->_post->check('date') && $this->_post->check('start_ts') && $this->_post->check('end_ts') && $this->_post->check('service_id') && $this->_post->check('employee_id') && !$this->cart->isEmpty())
			{
				$cid = (int) pjObject::escapeString($this->_get->toString('cid'));
				$date = $this->_post->toString('date');
				$key = sprintf("%u|%s|%u|%s|%s|%u", $cid, $date, $this->_post->toString('service_id'), $this->_post->toString('start_ts'), $this->_post->toString('end_ts'), $this->_post->toString('employee_id'));
				$this->cart->remove($key);
				pjAppController::jsonResponse(array('status' => 'OK', 'cnt' => $this->cart->getCount(), 'code' => 207, 'text' => __('system_207', true)));
			}
			pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 106, 'text' => __('system_106', true)));
		}
		exit;
	}

	public function pjActionValidateCart()
	{
		if ($this->isXHR())
		{
			$is_valid = $this->getValidate($this->getSummary());
			die($is_valid ? 'true' : 'false');
		}
		die('false');
	}
	
	public function pjActionProcessOrder()
	{
		$this->setAjax(true);
		
		if ($this->isXHR())
		{
			if (!$this->_post->check('as_preview') || !isset($_SESSION[$this->defaultForm]) || empty($_SESSION[$this->defaultForm]))
			{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 109, 'text' => __('system_109', true)));
			}
			
			$summary = $this->getSummary();
			if (!$this->getValidate($summary))
			{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 111, 'text' => __('system_111', true)));
			}
			
			$dates = array();
			foreach ($summary['services'] as $service)
			{
				$dates[] = $service['date'];
			}
			if (!empty($dates))
			{
				$bs_arr = pjBookingServiceModel::factory()
					->select('t1.*')
					->join('pjBooking', sprintf("t1.booking_id=t2.id AND (t2.booking_status='confirmed' OR (t2.booking_status='pending' AND UNIX_TIMESTAMP(t2.created) >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL %u MINUTE)) ) )", $this->option_arr['o_pending_time']), 'inner')
					->whereIn('t1.date', $dates)
					->findAll()
					->getData();
					
				foreach ($bs_arr as $item)
				{
					foreach ($summary['services'] as $service)
					{
						if ($service['date'] == $item['date']
							&& $service['id'] == $item['service_id']
							&& $service['employee_id'] == $item['employee_id']
							&& $service['start_ts'] == $item['start_ts']
						)
						{
							pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 115, 'text' => __('system_115', true)));
							break;
						}
					}
				}
			}
			
			$data = array();
			
			$data['calendar_id'] = $this->getForeignId();
			$data['booking_status'] = $this->option_arr['o_status_if_not_paid'];
			$data['uuid'] = pjUtil::uuid();
			$data['ip'] = $_SERVER['REMOTE_ADDR'];
			$data['locale_id'] = $this->getLocaleId();
			
			$data = array_merge($_SESSION[$this->defaultForm], $data);
			
			if (isset($data['payment_method']) && $data['payment_method'] != 'creditcard')
			{
				unset($data['cc_type']);
				unset($data['cc_num']);
				unset($data['cc_exp_month']);
				unset($data['cc_exp_year']);
				unset($data['cc_code']);
			}
			
			$data['booking_price'] = $summary['price'];
			$data['booking_deposit'] = $summary['deposit'];
			$data['booking_tax'] = $summary['tax'];
			$data['booking_total'] = $summary['total'];
			
			$pjBookingModel = pjBookingModel::factory();
			if (!$pjBookingModel->validates($data))
			{
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 114, 'text' => __('system_114', true)));
			}
			
			$booking_id = $pjBookingModel->setAttributes($data)->insert()->getInsertId();
			if ($booking_id !== false && (int) $booking_id > 0)
			{
				$pjBookingServiceModel = pjBookingServiceModel::factory()->setBatchFields(array(
					'booking_id', 'service_id', 'employee_id', 'date', 'start', 'start_ts', 'total', 'price', 'reminder_email', 'reminder_sms'
				));
				foreach ($summary['services'] as $service)
				{
					$pjBookingServiceModel->addBatchRow(array(
						$booking_id, $service['id'], $service['employee_id'],
						$service['date'], @$service['start'], $service['start_ts'],
						$service['total'], $service['price'], 0, 0
					));
				}
				$pjBookingServiceModel->insertBatch();
				
				# Confirmation email(s)
				$booking_arr = $pjBookingModel
					->reset()
					->select('t1.*, t1.id AS `booking_id`, t3.email AS `admin_email`, t4.content AS `country_name`,
						t5.content AS `confirm_subject_client`, t6.content AS `confirm_tokens_client`,
						t7.content AS `confirm_subject_admin`, t8.content AS `confirm_tokens_admin`,
						t9.content AS `confirm_subject_employee`, t10.content AS `confirm_tokens_employee`,
						t11.content AS `o_reminder_sms_message`')
					->join('pjCalendar', 't2.id=t1.calendar_id', 'left outer')
					->join('pjAuthUser', 't3.id=t2.user_id', 'left outer')
					->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t1.c_country_id AND t4.locale=t1.locale_id AND t4.field='name'", 'left outer')
					->join('pjMultiLang', "t5.model='pjCalendar' AND t5.foreign_id=t1.calendar_id AND t5.locale=t1.locale_id AND t5.field='confirm_subject_client'", 'left outer')
					->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t1.calendar_id AND t6.locale=t1.locale_id AND t6.field='confirm_tokens_client'", 'left outer')
					->join('pjMultiLang', "t7.model='pjCalendar' AND t7.foreign_id=t1.calendar_id AND t7.locale=t1.locale_id AND t7.field='confirm_subject_admin'", 'left outer')
					->join('pjMultiLang', "t8.model='pjCalendar' AND t8.foreign_id=t1.calendar_id AND t8.locale=t1.locale_id AND t8.field='confirm_tokens_admin'", 'left outer')
					->join('pjMultiLang', "t9.model='pjCalendar' AND t9.foreign_id=t1.calendar_id AND t9.locale=t1.locale_id AND t9.field='confirm_subject_employee'", 'left outer')
					->join('pjMultiLang', "t10.model='pjCalendar' AND t10.foreign_id=t1.calendar_id AND t10.locale=t1.locale_id AND t10.field='confirm_tokens_employee'", 'left outer')
					->join('pjMultiLang', "t11.model='pjCalendar' AND t11.foreign_id=t1.calendar_id AND t11.locale=t1.locale_id AND t11.field='o_reminder_sms_message'", 'left outer')
					->find($booking_id)
					->getData();
					
				$booking_arr['bs_arr'] = $pjBookingServiceModel
					->reset()
					->select('t1.*, t3.before, t3.length, t4.content AS `service_name`, t5.content AS `employee_name`,
						t6.phone AS `employee_phone`, t6.email AS `employee_email`, t6.is_subscribed, t6.is_subscribed_sms')
					->join('pjBooking', 't2.id=t1.booking_id', 'inner')
					->join('pjService', 't3.id=t1.service_id', 'inner')
					->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t5.model='pjEmployee' AND t5.foreign_id=t1.employee_id AND t5.field='name' AND t5.locale=t2.locale_id", 'left outer')
					->join('pjEmployee', 't6.id=t1.employee_id', 'left outer')
					->where('t1.booking_id', $booking_id)
					->findAll()
					->getData();

				$bs_ids = $pjBookingServiceModel->getDataPair('id', null);
					
				pjFrontEnd::pjActionConfirmSend($this->option_arr, $booking_arr, 'confirm');
				# Confirmation email(s)

				# Sms
				if ((int) $this->option_arr['o_reminder_sms_enable'] === 1 && !empty($bs_ids))
				{
					$tmp_booking = $booking_arr;
					unset($tmp_booking['bs_arr']);
					
					$params = array(
						'key' => md5($this->option_arr['private_key'] . PJ_SALT)
					);
					
					foreach ($booking_arr['bs_arr'] as $item)
					{
						if ((int) $item['is_subscribed_sms'] === 1 && !empty($item['employee_phone']))
						{
							$tmp = array_merge($tmp_booking, $item);

							$tokens = pjAppController::getTokens($tmp, $this->option_arr);
							$message = str_replace($tokens['search'], $tokens['replace'], str_replace(array('\r\n', '\n'), ' ', $booking_arr['o_reminder_sms_message']));
							$message = stripslashes($message);
							
							$params['text'] = $message;
							$params['type'] = 'unicode';
							$params['number'] = $item['employee_phone'];
							
							$result = $this->requestAction(array(
								'controller' => 'pjBaseSms',
								'action' => 'pjActionSend',
								'params' => $params
							), array('return'));
						}
					}
				}
				# Sms
				
				// Reset SESSION vars
				$this->cart->clear();
				
				$_SESSION[$this->defaultForm] = NULL;
				unset($_SESSION[$this->defaultForm]);
				
				$_SESSION[$this->defaultCaptcha] = NULL;
				unset($_SESSION[$this->defaultCaptcha]);
				
				pjAppController::jsonResponse(array(
					'status' => 'OK',
					'code' => 210,
					'text' => __('system_210', true),
					'booking_id' => $booking_id,
					'booking_uuid' => $booking_arr['uuid'],
					'payment_method' => ((int) $this->option_arr['o_disable_payments'] === 0 && isset($data['payment_method']) ?
						$data['payment_method'] : 'none')
				));
			} else {
				pjAppController::jsonResponse(array('status' => 'ERR', 'code' => 119, 'text' => __('system_119', true)));
			}
		}
		exit;
	}
	
	public function pjActionLoad()
	{
		$this->setAjax(false);
		$this->setLayout('pjActionFront');
		
		ob_start();
		header("Content-Type: text/javascript; charset=utf-8");
		
		if($this->_get->check('tab'))
		{
			$_SESSION[$this->defaultView] = $this->_get->toString('tab');
		}else{
			$_SESSION[$this->defaultView] = 'both';
		}
		
		$days_off = $dates_off = $dates_on = array();
		$w_arr = pjWorkingTimeModel::factory()->where('t1.foreign_id', $this->getForeignId())->where('t1.type', 'calendar')->findAll()->getData();
		if (!empty($w_arr))
		{
			$w_arr = $w_arr[0];
			
			if ($w_arr['monday_dayoff'] == 'T')
			{
				$days_off[] = 1;
			}
			if ($w_arr['tuesday_dayoff'] == 'T')
			{
				$days_off[] = 2;
			}
			if ($w_arr['wednesday_dayoff'] == 'T')
			{
				$days_off[] = 3;
			}
			if ($w_arr['thursday_dayoff'] == 'T')
			{
				$days_off[] = 4;
			}
			if ($w_arr['friday_dayoff'] == 'T')
			{
				$days_off[] = 5;
			}
			if ($w_arr['saturday_dayoff'] == 'T')
			{
				$days_off[] = 6;
			}
			if ($w_arr['sunday_dayoff'] == 'T')
			{
				$days_off[] = 0;
			}
		}
		
		$d_arr = pjDateModel::factory()
			->where('t1.foreign_id', $this->getForeignId())
			->where('t1.type', 'calendar')
			->where('t1.from_date <= CURDATE()')
			->where('t1.to_date >= CURDATE()')
			->findAll()
			->getData();

		foreach ($d_arr as $date)
		{
			$from_ts = strtotime($date['from_date']);
			$to_ts = strtotime($date['to_date']);
			for($i = $from_ts; $i <= $to_ts; $i += 86400) {
				if ($date['is_dayoff'] == 'T')
				{
					$_d = date('Y-m-d', $i);
					if (!in_array($_d, $dates_off)) {
						$dates_off[] = $_d;
					}
				} else {
					if (!in_array(date('Y-m-d', $i), $dates_on)) {
						$dates_on[] = $_d;
					}
				}
			}
		}

		$this->set('days_off', $days_off);
		$this->set('dates_off', $dates_off);
		$this->set('dates_on', $dates_on);
				
		# Find first working day starting from tomorrow
		$first_working_date = NULL;
		list($y, $m, $d, $w) = explode("-", date("Y-n-j-w", time()));
		foreach (range(0, 365) as $i)
		{
			$timestamp = mktime(0, 0, 0, $m, $d + $i, $y);
			list($date, $wday) = explode("|", date("Y-m-d|w", $timestamp));
			
			if (!in_array($wday, $days_off) && !in_array($date, $dates_off))
			{
				$first_working_date = $date;
				break;
			}
			
			if (in_array($wday, $days_off) && in_array($date, $dates_on))
			{
				$first_working_date = $date;
				break;
			}
		}
		
		$this->set('first_working_date', $first_working_date);
	}
	
	public function pjActionLoadCss()
	{
		$theme = $this->_get->check('theme') ? $this->_get->toString('theme') : $this->option_arr['o_theme'];
		if((int) $theme > 0)
		{
			$theme = 'theme' . $theme;
		}
		$dm = new pjDependencyManager(PJ_INSTALL_PATH, PJ_THIRD_PARTY_PATH);
		$dm->load(PJ_CONFIG_PATH . 'dependencies.php')->resolve();
		$arr = array(
			array('file' => 'jquery-ui.custom.min.css', 'path' => $dm->getPath('pj_jquery_ui') . 'css/smoothness'),
			array('file' => 'pj-calendar.css', 'path' => PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'),
			array('file' => 'ASCalendar.css', 'path' => PJ_CSS_PATH),				
			array('file' => 'font-awesome.min.css', 'path' => $dm->getPath('font_awesome') . 'css/'),
			array('file' => "AppScheduler.css", 'path' => PJ_CSS_PATH),
			array('file' => "$theme.css", 'path' => PJ_CSS_PATH . "themes/")
		);
		header("Content-Type: text/css; charset=utf-8");
		foreach ($arr as $item)
		{
			ob_start();
			@readfile($item['path'] . $item['file']);
			$string = ob_get_contents();
			ob_end_clean();
			
			if ($string !== FALSE)
			{
				echo str_replace(
					array('../fonts/glyphicons', '../fonts/', 'images/', "pjWrapper"),
					array(
						PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/fonts/glyphicons',
						PJ_INSTALL_URL . $dm->getPath('font_awesome') . 'fonts/',
						PJ_INSTALL_URL . $dm->getPath('pj_jquery_ui') . 'css/smoothness/images/',
						"pjWrapperAppScheduler_" . $this->getForeignId()
					),
					$string
				) . "\n";
			}
		}
		exit;
	}
	
	public function pjActionCancel()
	{
		$pjBookingModel = pjBookingModel::factory();
				
		if (self::isPost() && $this->_post->check('booking_cancel'))
		{
			$arr = $pjBookingModel->find($this->_post->toInt('id'))->getData();
			if (!empty($arr))
			{
				$pjBookingModel
					->reset()
					->where(sprintf("SHA1(CONCAT(`id`, `created`, '%s')) = ", PJ_SALT), $this->_post->toString('hash'))
					->limit(1)
					->modifyAll(array('booking_status' => 'cancelled'));

				# Confirmation email(s)
				$booking_arr = $pjBookingModel
					->reset()
					->select('t1.*, t1.id AS `booking_id`, t3.email AS `admin_email`, t4.content AS `country_name`,
						t5.content AS `cancel_subject_client`, t6.content AS `cancel_tokens_client`,
						t7.content AS `cancel_subject_admin`, t8.content AS `cancel_tokens_admin`,
						t9.content AS `cancel_subject_employee`, t10.content AS `cancel_tokens_employee`')
					->join('pjCalendar', 't2.id=t1.calendar_id', 'left outer')
					->join('pjAuthUser', 't3.id=t2.user_id', 'left outer')
					->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t1.c_country_id AND t4.locale=t1.locale_id AND t4.field='name'", 'left outer')
					->join('pjMultiLang', "t5.model='pjCalendar' AND t5.foreign_id=t1.calendar_id AND t5.locale=t1.locale_id AND t5.field='cancel_subject_client'", 'left outer')
					->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t1.calendar_id AND t6.locale=t1.locale_id AND t6.field='cancel_tokens_client'", 'left outer')
					->join('pjMultiLang', "t7.model='pjCalendar' AND t7.foreign_id=t1.calendar_id AND t7.locale=t1.locale_id AND t7.field='cancel_subject_admin'", 'left outer')
					->join('pjMultiLang', "t8.model='pjCalendar' AND t8.foreign_id=t1.calendar_id AND t8.locale=t1.locale_id AND t8.field='cancel_tokens_admin'", 'left outer')
					->join('pjMultiLang', "t9.model='pjCalendar' AND t9.foreign_id=t1.calendar_id AND t9.locale=t1.locale_id AND t9.field='cancel_subject_employee'", 'left outer')
					->join('pjMultiLang', "t10.model='pjCalendar' AND t10.foreign_id=t1.calendar_id AND t10.locale=t1.locale_id AND t10.field='cancel_tokens_employee'", 'left outer')
					->find($arr['id'])
					->getData();
					
				$booking_arr['bs_arr'] = pjBookingServiceModel::factory()
					->reset()
					->select('t1.*, t3.before, t3.length, t4.content AS `service_name`, t5.content AS `employee_name`,
						t6.phone AS `employee_phone`, t6.email AS `employee_email`, t6.is_subscribed, t6.is_subscribed_sms')
					->join('pjBooking', 't2.id=t1.booking_id', 'inner')
					->join('pjService', 't3.id=t1.service_id', 'inner')
					->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t5.model='pjEmployee' AND t5.foreign_id=t1.employee_id AND t5.field='name' AND t5.locale=t2.locale_id", 'left outer')
					->join('pjEmployee', 't6.id=t1.employee_id', 'left outer')
					->where('t1.booking_id', $arr['id'])
					->findAll()
					->getData();

				pjFrontEnd::pjActionConfirmSend($this->option_arr, $booking_arr, 'cancel');
				# Confirmation email(s)
					
				pjUtil::redirect($_SERVER['PHP_SELF'] . '?controller=pjFrontEnd&action=pjActionCancel&err=5');
			}
		} else {
			if ($this->_get->check('hash') && $this->_get->check('id'))
			{
				$arr = $pjBookingModel
					->select('t1.*, t2.content AS `country_title`')
					->join('pjMultiLang', "t2.model='pjCountry' AND t2.foreign_id=t1.c_country_id AND t2.field='name' AND t2.locale='t1.locale_id'", 'left outer')
					->find($this->_get->toInt('id'))
					->getData();
				if (empty($arr))
				{
					$this->set('status', 2);
				} else {
					if ($arr['locale_id'] != $this->pjActionGetLocale()) {
						$this->pjActionSetLocale($arr['locale_id']);
						$this->loadSetFields(true);
					}
					if ($arr['booking_status'] == 'cancelled')
					{
						$this->set('status', 4);
					} else {
						$hash = sha1($arr['id'] . $arr['created'] . PJ_SALT);
						if ($this->_get->toString('hash') != $hash)
						{
							$this->set('status', 3);
						} else {
							
							$details_arr = pjBookingServiceModel::factory()
								->select('t1.*, t2.content AS `service_name`, t3.content AS `employee_name`, t4.before, t4.length')
								->join('pjMultiLang', sprintf("t2.model='pjService' AND t2.foreign_id=t1.service_id AND t2.field='name' AND t2.locale='%u'", $arr['locale_id']), 'left outer')
								->join('pjMultiLang', sprintf("t3.model='pjEmployee' AND t3.foreign_id=t1.employee_id AND t3.field='name' AND t3.locale='%u'", $arr['locale_id']), 'left outer')
								->join('pjService', 't4.id=t1.service_id', 'left outer')
								->where('t1.booking_id', $arr['id'])
								->orderBy("t1.start_ts ASC")
								->findAll()
								->getData();
							
							$start_time = $details_arr[0]['start_ts'];
							$cancel_earlier = $this->option_arr['o_cancel_earlier'] * 60 * 60;
							if(time() + $cancel_earlier > $start_time)					
							{
								$this->set('status', 6);
							}else{
								$arr['details_arr'] = $details_arr;
								$this->set('arr', $arr);
							}
						}
					}
				}
			} elseif (!$this->_get->check('err')) {
				$this->set('status', 1);
			}
			$this->appendCss('index.php?controller=pjFrontEnd&action=pjActionLoadCss', PJ_INSTALL_URL, true);
		}
	}
	
	public function pjActionCaptcha()
	{
		$this->setAjax(true);
		 
		header("Cache-Control: max-age=3600, private");
		
		$rand = $this->_get->toInt('rand') ?: rand(1, 9999);
		$patterns = 'app/web/img/button.png';
		if(!empty($this->option_arr['o_captcha_background_front']) && $this->option_arr['o_captcha_background_front'] != 'plain')
		{
			$patterns = PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_IMG_PATH') . 'captcha_patterns/' . $this->option_arr['o_captcha_background_front'];
		}
		$Captcha = new pjCaptcha(PJ_INSTALL_PATH . $this->getConstant('pjBase', 'PLUGIN_WEB_PATH') . 'obj/arialbd.ttf', $this->defaultCaptcha, (int) $this->option_arr['o_captcha_length_front']);
		$Captcha->setImage($patterns)->setMode($this->option_arr['o_captcha_mode_front'])->init($rand);
		
		exit;
	}
	
	public function pjActionCheckCaptcha()
	{
		if ($this->isXHR())
		{
			echo isset($_SESSION[$this->defaultCaptcha]) && $this->_get->check('captcha') && $_SESSION[$this->defaultCaptcha] == strtoupper($this->_get->toString('captcha')) ? 'true' : 'false';
		}
		exit;
	}
		
	public function pjActionCheckReCaptcha()
	{
		$this->setAjax(true);
		$verifyResponse = file_get_contents('https://www.google.com/recaptcha/api/siteverify?secret='.$this->option_arr['o_captcha_secret_key_front'].'&response='.$this->_get->toString('recaptcha'));
		$responseData = json_decode($verifyResponse);
		echo $responseData->success ? 'true': 'false';
		exit;
	}
	
	public function pjActionConfirm()
	{
		$this->setAjax(true);

		if (pjObject::getPlugin('pjPayments') === NULL)
		{
			$this->log('pjPayments plugin not installed');
			exit;
		}

		$pjPayments = new pjPayments();
		if($pjPlugin = $pjPayments->getPaymentPlugin($_REQUEST))
		{
			if($uuid = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionGetCustom', 'params' => $_REQUEST), array('return')))
			{
				$pjBookingModel = pjBookingModel::factory();

				$booking_arr = $pjBookingModel
								->select('t1.*, t1.id AS `booking_id`, t3.email AS `admin_email`, t4.content AS `country_name`,
									t5.content AS `payment_subject_client`, t6.content AS `payment_tokens_client`,
									t7.content AS `payment_subject_admin`, t8.content AS `payment_tokens_admin`,
									t9.content AS `payment_subject_employee`, t10.content AS `payment_tokens_employee`')
								->join('pjCalendar', 't2.id=t1.calendar_id', 'left outer')
								->join('pjAuthUser', 't3.id=t2.user_id', 'left outer')
								->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t1.c_country_id AND t4.locale=t1.locale_id AND t4.field='name'", 'left outer')
								->join('pjMultiLang', "t5.model='pjCalendar' AND t5.foreign_id=t1.calendar_id AND t5.locale=t1.locale_id AND t5.field='payment_subject_client'", 'left outer')
								->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t1.calendar_id AND t6.locale=t1.locale_id AND t6.field='payment_tokens_client'", 'left outer')
								->join('pjMultiLang', "t7.model='pjCalendar' AND t7.foreign_id=t1.calendar_id AND t7.locale=t1.locale_id AND t7.field='payment_subject_admin'", 'left outer')
								->join('pjMultiLang', "t8.model='pjCalendar' AND t8.foreign_id=t1.calendar_id AND t8.locale=t1.locale_id AND t8.field='payment_tokens_admin'", 'left outer')
								->join('pjMultiLang', "t9.model='pjCalendar' AND t9.foreign_id=t1.calendar_id AND t9.locale=t1.locale_id AND t9.field='payment_subject_employee'", 'left outer')
								->join('pjMultiLang', "t10.model='pjCalendar' AND t10.foreign_id=t1.calendar_id AND t10.locale=t1.locale_id AND t10.field='payment_tokens_employee'", 'left outer')
								->where('t1.uuid', $uuid)
								->limit(1)
								->findAll()
								->getData();
				
				if (!empty($booking_arr))
				{
					$booking_arr = $booking_arr[0];
					$option_arr = pjOptionModel::factory()->getPairs($booking_arr['calendar_id']);
					
					$params = array(
							'request'		=> $_REQUEST,
							'payment_method' => $_REQUEST['payment_method'],
							'foreign_id'	 => NULL,
							'amount'		 => $booking_arr['booking_deposit'],
							'txn_id'		 => $booking_arr['txn_id'],
							'order_id'	   => $booking_arr['id'],
							'cancel_hash'	=> sha1($booking_arr['uuid'].strtotime($booking_arr['created']).PJ_SALT),
							'key'			=> md5($this->option_arr['private_key'] . PJ_SALT)
					);
					$response = $this->requestAction(array('controller' => $pjPlugin, 'action' => 'pjActionConfirm', 'params' => $params), array('return'));
					
					if($response['status'] == 'OK')
					{
						$this->log("Payments | {$pjPlugin} plugin<br>Reservation was confirmed. UUID: {$uuid}");
						$pjBookingModel
							->reset()
							->set('id', $booking_arr['id'])
							->modify(array('booking_status' => $this->option_arr['o_status_if_paid']));
							
						$booking_arr['bs_arr'] = pjBookingServiceModel::factory()
							->select('t1.*, t3.before, t3.length, t4.phone AS `employee_phone`, t4.email AS `employee_email`, t4.is_subscribed, t4.is_subscribed_sms,
								t5.content AS `service_name`, t6.content AS `employee_name`')
							->join('pjBooking', 't2.id=t1.booking_id', 'inner')
							->join('pjService', 't3.id=t1.service_id', 'inner')
							->join('pjEmployee', 't4.id=t1.employee_id', 'inner')
							->join('pjMultiLang', "t5.model='pjService' AND t5.foreign_id=t1.service_id AND t5.field='name' AND t5.locale=t2.locale_id", 'left outer')
							->join('pjMultiLang', "t6.model='pjEmployee' AND t6.foreign_id=t1.employee_id AND t6.field='name' AND t6.locale=t2.locale_id", 'left outer')
							->where('t1.booking_id', $booking_arr['id'])
							->findAll()
							->getData();
						
						pjFrontEnd::pjActionConfirmSend($this->option_arr, $booking_arr, 'payment');

						echo $this->option_arr['o_thankyou_page'];
						exit;
					}elseif($response['status'] == 'CANCEL'){
						$this->log("Payments | {$pjPlugin} plugin<br>Payment was cancelled. UUID: {$uuid}");
						$pjBookingModel
							->reset()
							->set('id', $booking_arr['id'])
							->modify(array('status' => 'cancelled', 'processed_on' => ':NOW()'));

						echo $this->option_arr['o_thankyou_page'];
						exit;
					}else{
						$this->log("Payments | {$pjPlugin} plugin<br>Reservation confirmation was failed. UUID: {$uuid}");
					}

					if(isset($response['redirect']) && $response['redirect'] == true)
					{
						echo $this->option_arr['o_thankyou_page'];
						exit;
					}
				}else{
					$this->log("Payments | {$pjPlugin} plugin<br>Reservation with UUID {$uuid} not found.");
				}
				echo $this->option_arr['o_thankyou_page'];
				exit;
			}
		}

		echo $this->option_arr['o_thank_you_page'];
		exit;
	}
	
	private static function pjActionConfirmSend($option_arr, $booking_arr, $type)
	{
		if (!in_array($type, array('confirm', 'payment', 'cancel')))
		{
			return false;
		}
		$Email = self::getMailer($option_arr);
		
		$tokens = pjAppController::getTokens($booking_arr, $option_arr, 'multi');
		
		$pjNotificationModel = pjNotificationModel::factory();

        $admin_email = pjAppController::getAdminEmail();
		
		switch ($type)
		{
			case 'confirm':
				// Client
				$notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_subject_client']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_tokens_client']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						$Email
							->setTo($booking_arr['c_email'])
							->setSubject($subject)
							->send($message);
					}
		        }
		        // Admin
		        $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_subject_admin']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_tokens_admin']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						foreach($admin_email as $email)
						{
							$Email
								->setTo($email)
								->setSubject($subject)
								->send($message);
						}
					}
		        }
				// Employee
		        $notification = $pjNotificationModel->reset()->where('recipient', 'employee')->where('transport', 'email')->where('variant', 'confirmation')->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
			        foreach ($booking_arr['bs_arr'] as $item)
					{
						if ((int) $item['is_subscribed'] === 1 && !empty($item['employee_email']))
						{
							$tokens = pjAppController::getTokens(array_merge($booking_arr, $item), $option_arr);
							$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_subject_employee']);
							$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['confirm_tokens_employee']);
							if (!empty($subject) && !empty($message))
							{
								$message = pjUtil::textToHtml($message);
								$Email
									->setTo($item['employee_email'])
									->setSubject($subject)
									->send($message);
							}
						}
					}
		        }
				break;
			case 'payment':
				// Client
		        $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_subject_client']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_tokens_client']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						$Email
							->setTo($booking_arr['c_email'])
							->setSubject($subject)
							->send($message);
					}
		        }
				// Admin
		        $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
			        $subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_subject_admin']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_tokens_admin']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						foreach($admin_email as $email)
						{
							$Email
								->setTo($email)
								->setSubject($subject)
								->send($message);
						}
					}
		        }
				// Employee
		        $notification = $pjNotificationModel->reset()->where('recipient', 'employee')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
			        foreach ($booking_arr['bs_arr'] as $item)
					{
						if ((int) $item['is_subscribed'] === 1 && !empty($item['employee_email']))
						{
							$tokens = pjAppController::getTokens(array_merge($booking_arr, $item), $option_arr, 'single');
							$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_subject_employee']);
							$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['payment_tokens_employee']);
							if (!empty($subject) && !empty($message))
							{
								$message = pjUtil::textToHtml($message);
								$Email
									->setTo($item['employee_email'])
									->setSubject($subject)
									->send($message);
							}
						}
					}
		        }
				break;
			case 'cancel':
				// Client
		        $notification = $pjNotificationModel->reset()->where('recipient', 'client')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_subject_client']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_tokens_client']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						$Email
							->setTo($booking_arr['c_email'])
							->setSubject($subject)
							->send($message);
					}
		        }
				// Admin
		        $notification = $pjNotificationModel->reset()->where('recipient', 'admin')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
					$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_subject_admin']);
					$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_tokens_admin']);
					if (!empty($subject) && !empty($message))
					{
						$message = pjUtil::textToHtml($message);
						foreach($admin_email as $email)
						{
							$Email
								->setTo($email)
								->setSubject($subject)
								->send($message);
						}
					}
		        }
				// Employee
		        $notification = $pjNotificationModel->reset()->where('recipient', 'employee')->where('transport', 'email')->where('variant', $type)->findAll()->getDataIndex(0);
		        if((int) $notification['id'] > 0 && $notification['is_active'] == 1)
		        {
			        foreach ($booking_arr['bs_arr'] as $item)
					{
						if ((int) $item['is_subscribed'] === 1 && !empty($item['employee_email']))
						{
							$tokens = pjAppController::getTokens(array_merge($booking_arr, $item), $option_arr, 'single');
							$subject = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_subject_employee']);
							$message = str_replace($tokens['search'], $tokens['replace'], @$booking_arr['cancel_tokens_employee']);
							if (!empty($subject) && !empty($message))
							{
								$message = pjUtil::textToHtml($message);
								$Email
									->setTo($item['employee_email'])
									->setSubject($subject)
									->send($message);
							}
						}
					}
		        }
				break;
		}
	}
	
	public function pjActionGetCalendar()
	{
		$cid = (int) pjObject::escapeString($this->_get->toInt('cid'));
		$date = pjObject::escapeString($this->_get->toString('date'));
		$get_month = pjObject::escapeString($this->_get->toString('month'));
		$get_year = pjObject::escapeString($this->_get->toString('year'));
		list($year, $month, $day) = explode("-", $date);
		$dates = $this->getDates($cid, $get_year, $get_month);
		if((int) $month === (int) $this->_get->toString('month') && (int) $year === (int) $this->_get->toString('year'))
		{
			$this->set('calendar', $this->getCalendar($dates[0], $get_year, $get_month, $day));
		}else{
			$this->set('calendar', $this->getCalendar($dates[0], $get_year, $get_month));
		}
	}
	
	public function pjActionGetCart()
	{
		$cid = (int) pjObject::escapeString($this->_get->toInt('cid'));
		$this->set('cart_arr', $this->getCart($cid));
	}

	public function pjActionGetTerms()
	{
		if ($this->isXHR())
		{
			$cid = (int) pjObject::escapeString($this->_get->toInt('cid'));
			$this->set('terms_arr', $this->getTerms($cid));
		}
	}
	
	public function pjActionGetTime()
	{
		$service_id = (int) pjObject::escapeString($this->_get->toInt('service_id'));
		$cid = (int) pjObject::escapeString($this->_get->toInt('cid'));
		$date = pjObject::escapeString($this->_get->toString('date'));
		$this->set('service_arr', pjServiceModel::factory()->find($service_id)->getData());
		$this->set('t_arr', pjAppController::getSingleDateSlots($cid, $date));
	}
	
	public function pjActionGetEmployees()
	{
		$employee_arr = array();
		if($this->_get->check('service_id'))
		{
			$service_id = (int) pjObject::escapeString($this->_get->toInt('service_id'));
			$cid = (int) pjObject::escapeString($this->_get->toInt('cid'));
			
			$pjEmployeeModel = pjEmployeeModel::factory();
			$table = pjEmployeeServiceModel::factory()->getTable();
			if((int) $service_id > 0)
			{
				$pjEmployeeModel->where("(t1.id IN (SELECT TES2.employee_id FROM `".$table."` AS TES2 WHERE TES2.service_id = '".$service_id."'))");
			}
			
			$employee_arr = $pjEmployeeModel
				->select("t1.*, t2.content AS `name`, 
							(
								SELECT GROUP_CONCAT(TL.content SEPARATOR ',') 
								FROM `".pjServiceModel::factory()->getTable()."` AS TS LEFT OUTER JOIN `".pjMultiLangModel::factory()->getTable()."` AS TL ON TL.model='pjService' AND TL.foreign_id=TS.id AND TL.locale='".$this->getLocaleId()."' AND TL.field='name' 
								WHERE TS.id IN (
						                         	SELECT TES.service_id 
													FROM `".$table."` AS TES 
													WHERE TES.employee_id = t1.id
												) 
							) AS services")
				->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.calendar_id', $cid)
				->where('t1.is_active', 'T')
				->orderBy('`name` ASC')
				->findAll()
				->getData();
		}
		$this->set('employee_arr', $employee_arr);
	}
	
	public function pjActionGetIsoDate()
	{
		if ($this->isXHR())
		{
			if(self::isGet() && $this->_get->check('date') && !$this->_get->isEmpty('date'))
			{
				$date = pjUtil::formatDate(pjObject::escapeString($this->_get->toString('date')), $this->option_arr['o_date_format']);
				pjAppController::jsonResponse(array('date' => $date));
			}
			exit;
		}
	}
}
?>