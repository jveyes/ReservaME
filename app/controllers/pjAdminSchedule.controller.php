<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminSchedule extends pjAdmin
{
	public function pjActionWeekly()
	{
		$this->checkLogin();
		
		$this->set('employee_arr', pjEmployeeModel::factory()
		    ->select('t1.id, t2.content AS `name`')
		    ->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
		    ->where('role_id', 3)
		    ->orderBy('`name` ASC')
		    ->findAll()
		    ->getData()
		    );
		
		$date = date('Y-m-d');
		if(self::isGet() && $this->_get->check('date'))
		{
			$date = $this->_get->toString('date');
		}
		$foreign_id = $this->getForeignId();
		if($this->_get->check('employee_id'))
		{
		    $foreign_id = $this->_get->toInt('employee_id');
		}
		$result = pjAppController::getDateTimes($date, 'weekly', $this->option_arr, $this->getLocaleId(), $foreign_id);
		foreach ($result as $key => $value)
		{
			$this->set($key, $value);
		}
		$this->appendCss('custom.css', $this->getConst('PLUGIN_CSS_PATH'));
		$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
		$this->appendJs('pjAdminSchedule.js');
	}
	
	public function pjActionMonthly()
	{
		$this->checkLogin();
		
		$this->set('employee_arr', pjEmployeeModel::factory()
		    ->select('t1.id, t2.content AS `name`')
		    ->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
		    ->where('role_id', 3)
		    ->orderBy('`name` ASC')
		    ->findAll()
		    ->getData()
		    );
		
		$date = date('Y-m-d');
		if(self::isGet() && $this->_get->check('date'))
		{
			$date = $this->_get->toString('date');
		}
		$foreign_id = $this->getForeignId();
		if($this->_get->check('employee_id'))
		{
		    $foreign_id = $this->_get->toInt('employee_id');
		}
		$result = pjAppController::getDateTimes($date, 'monthly', $this->option_arr, $this->getLocaleId(), $foreign_id);
		foreach ($result as $key => $value)
		{
			$this->set($key, $value);
		}
		$this->set('date', $date);
		$this->appendCss('custom.css', $this->getConst('PLUGIN_CSS_PATH'));
		$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
		$this->appendJs('pjAdminSchedule.js');
	}
	
	public function pjActionPrintWeekly()
	{
		$this->checkLogin();
		 
		$this->setLayout('pjActionPrint');
		$date = date('Y-m-d');
		if(self::isGet() && $this->_get->check('date'))
		{
			$date = $this->_get->toString('date');
		}
		$foreign_id = $this->getForeignId();
		if($this->_get->check('employee_id'))
		{
		    $foreign_id = $this->_get->toInt('employee_id');
		}
		$result = pjAppController::getDateTimes($date, 'weekly', $this->option_arr, $this->getLocaleId(), $foreign_id);
		foreach ($result as $key => $value)
		{
			$this->set($key, $value);
		}
	}
	
	public function pjActionPrintMonthly()
	{
		$this->checkLogin();
		 
		$this->setLayout('pjActionPrint');
		$date = date('Y-m-d');
		if(self::isGet() && $this->_get->check('date'))
		{
			$date = $this->_get->toString('date');
		}
		$foreign_id = $this->getForeignId();
		if($this->_get->check('employee_id'))
		{
		    $foreign_id = $this->_get->toInt('employee_id');
		}
		$result = pjAppController::getDateTimes($date, 'monthly', $this->option_arr, $this->getLocaleId(), $foreign_id);
		foreach ($result as $key => $value)
		{
			$this->set($key, $value);
		}
		$this->set('date', $date);
	}
	
	public function pjActionCancelServiceWeekly()
	{
		$this->setAjax(true);
		 
		if ($this->isXHR())
		{
			if (!self::isPost())
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
			}
			if (!($this->_post->check('id') && pjValidation::pjActionNumeric($this->_post->toInt('id')) && $this->_post->check('booking_id') && pjValidation::pjActionNumeric($this->_post->toInt('id'))))
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
			}

			pjBookingModel::factory()->where('id', $this->_post->toInt('booking_id'))->limit(1)->modifyAll(array('booking_status' => 'cancelled'));
			
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
	}
	
	public function pjActionCancelServiceMonthly()
	{
		$this->setAjax(true);
		 
		if ($this->isXHR())
		{
			if (!self::isPost())
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
			}
			if (!($this->_post->check('id') && pjValidation::pjActionNumeric($this->_post->toInt('id')) && $this->_post->check('booking_id') && pjValidation::pjActionNumeric($this->_post->toInt('id'))))
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
			}

			pjBookingModel::factory()->where('id', $this->_post->toInt('booking_id'))->limit(1)->modifyAll(array('booking_status' => 'cancelled'));
			
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
	}
	
	public function pjActionReminderEmailWeekly()
	{
		$this->setAjax(true);
		 
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (self::isPost() && $this->_post->check('send_email') && $this->_post->check('to') && !$this->_post->isEmpty('from') && !$this->_post->isEmpty('to') &&
				!$this->_post->isEmpty('subject') && !$this->_post->isEmpty('message') && !$this->_post->isEmpty('id'))
		{
			$from_email = self::getFromEmail($this->option_arr);
			$Email = self::getMailer($this->option_arr);
			 
			$r = $Email
				->setTo($this->_post->toString('to'))
				->setSubject($this->_post->toString('subject'))
				->send($this->_post->toString('message'));
			 
			if (isset($r) && $r)
			{
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Email failed to send.'));
		}
		 
		if (self::isGet() && $this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$from_email = self::getFromEmail($this->option_arr);
			
			$pjBookingModel = pjBookingModel::factory();
			$pjBookingServiceModel = pjBookingServiceModel::factory();
			
			$booking_arr = $pjBookingModel
							->reset()
							->select('t1.*, t1.id AS `booking_id`, t3.email AS `admin_email`, t4.content AS `country_name`,
								t5.content AS `o_reminder_subject`, t6.content AS `o_reminder_body`, t7.content AS `country_name`')
							->join('pjCalendar', 't2.id=t1.calendar_id', 'left outer')
							->join('pjAuthUser', 't3.id=t2.user_id', 'left outer')
							->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t1.c_country_id AND t4.locale=t1.locale_id AND t4.field='name'", 'left outer')
							->join('pjMultiLang', "t5.model='pjCalendar' AND t5.foreign_id=t1.calendar_id AND t5.locale=t1.locale_id AND t5.field='o_reminder_subject'", 'left outer')
							->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t1.calendar_id AND t6.locale=t1.locale_id AND t6.field='o_reminder_body'", 'left outer')
							->join('pjMultiLang', "t7.model='pjBaseCountry' AND t7.foreign_id=t1.c_country_id AND t7.locale=t1.locale_id AND t7.field='name'", 'left outer')
							->find($this->_get->toInt('id'))
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
									->where('t1.booking_id', $this->_get->toInt('id'))
									->findAll()
									->getData();

			$tokens = pjAppController::getTokens($booking_arr, $this->option_arr, 'multi');

			$lang_message = $booking_arr['o_reminder_body'];
			$lang_subject = $booking_arr['o_reminder_subject'];

			$subject_client = str_replace($tokens['search'], $tokens['replace'], $lang_subject);
			$message_client = str_replace($tokens['search'], $tokens['replace'], $lang_message);

			$this->set('arr', array(
					'id' => $this->_get->toInt('id'),
					'email' => $booking_arr['c_email'],
					'from' => $from_email,
					'message' => $message_client,
					'subject' => $subject_client
			));
		} else {
			exit;
		}
	}

	public function pjActionReminderEmailMonthly()
	{
		$this->setAjax(true);
		 
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (self::isPost() && $this->_post->check('send_email') && $this->_post->check('to') && !$this->_post->isEmpty('from') && !$this->_post->isEmpty('to') &&
				!$this->_post->isEmpty('subject') && !$this->_post->isEmpty('message') && !$this->_post->isEmpty('id'))
		{
			$from_email = self::getFromEmail($this->option_arr);
			$Email = self::getMailer($this->option_arr);
			 
			$r = $Email
				->setTo($this->_post->toString('to'))
				->setSubject($this->_post->toString('subject'))
				->send($this->_post->toString('message'));
			 
			if (isset($r) && $r)
			{
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Email failed to send.'));
		}
		 
		if (self::isGet() && $this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$from_email = self::getFromEmail($this->option_arr);
			
			$pjBookingModel = pjBookingModel::factory();
			$pjBookingServiceModel = pjBookingServiceModel::factory();
			
			$booking_arr = $pjBookingModel
							->reset()
							->select('t1.*, t1.id AS `booking_id`, t3.email AS `admin_email`, t4.content AS `country_name`,
								t5.content AS `o_reminder_subject`, t6.content AS `o_reminder_body`, t7.content AS `country_name`')
							->join('pjCalendar', 't2.id=t1.calendar_id', 'left outer')
							->join('pjAuthUser', 't3.id=t2.user_id', 'left outer')
							->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t1.c_country_id AND t4.locale=t1.locale_id AND t4.field='name'", 'left outer')
							->join('pjMultiLang', "t5.model='pjCalendar' AND t5.foreign_id=t1.calendar_id AND t5.locale=t1.locale_id AND t5.field='o_reminder_subject'", 'left outer')
							->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t1.calendar_id AND t6.locale=t1.locale_id AND t6.field='o_reminder_body'", 'left outer')
							->join('pjMultiLang', "t7.model='pjBaseCountry' AND t7.foreign_id=t1.c_country_id AND t7.locale=t1.locale_id AND t7.field='name'", 'left outer')
							->find($this->_get->toInt('id'))
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
									->where('t1.booking_id', $this->_get->toInt('id'))
									->findAll()
									->getData();

			$tokens = pjAppController::getTokens($booking_arr, $this->option_arr, 'multi');

			$lang_message = $booking_arr['o_reminder_body'];
			$lang_subject = $booking_arr['o_reminder_subject'];

			$subject_client = str_replace($tokens['search'], $tokens['replace'], $lang_subject);
			$message_client = str_replace($tokens['search'], $tokens['replace'], $lang_message);

			$this->set('arr', array(
					'id' => $this->_get->toInt('id'),
					'email' => $booking_arr['c_email'],
					'from' => $from_email,
					'message' => $message_client,
					'subject' => $subject_client
			));
		} else {
			exit;
		}
	}
}
?>