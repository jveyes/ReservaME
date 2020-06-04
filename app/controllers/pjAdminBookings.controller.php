<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminBookings extends pjAdmin
{
	public function pjActionCheckUID()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!$this->_get->check('uuid') || $this->_get->toString('uuid') == '')
		{
			echo 'false';
			exit;
		}
		$pjBookingModel = pjBookingModel::factory()->where('t1.uuid', $this->_get->toString('uuid'));
		if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$pjBookingModel->where('t1.id !=', $this->_get->toInt('id'));
		}
		echo $pjBookingModel->findCount()->getData() == 0 ? 'true' : 'false';
		exit;
	}
	
	public function pjActionCheckOverwrite()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}

		if (!$this->_post->check('id') || $this->_post->toInt('id') == 0)
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'No ID'));
		}
		
		if (!$this->_post->check('booking_status') || $this->_post->toString('booking_status') == '')
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'No Booking status'));
		}
		
		if ($this->_post->toString('booking_status') == 'confirmed') {
			$pjBookingServiceModel = pjBookingServiceModel::factory();
			$bs_arr = $pjBookingServiceModel
						->where('booking_id', $this->_post->toInt('id'))
						->findAll()
						->getData();
			
			$checked = false;
			if ($bs_arr) {
					
				foreach ($bs_arr as $item)
				{
					$cnt = $pjBookingServiceModel
							->reset()
							->join('pjBooking', sprintf("t1.booking_id=t2.id AND (t2.booking_status='confirmed' OR (t2.booking_status='pending' AND UNIX_TIMESTAMP(t2.created) >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL %u MINUTE)) ) )", $this->option_arr['o_pending_time']), 'inner')
							->where('t1.booking_id !=', $this->_post->toInt('id'))
							->whereIn('t1.date', $item['date'])
							->whereIn('t1.service_id', $item['service_id'])
							->whereIn('t1.employee_id', $item['employee_id'])
							->whereIn('t1.start_ts', $item['start_ts'])
							->findCount()
							->getData();
					if ($cnt > 0) {
						$checked = true;
						break;
					}
				}
			}
		
			if ($checked) {
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Existed'));
			} else {
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
		} else {
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
	}
	
	public function pjActionCreate()
	{
		$this->checkLogin();
		
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		if (self::isPost() && $this->_post->toInt('booking_create'))
		{
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$data['locale_id'] = $this->getLocaleId();
			$data['ip'] = $_SERVER['REMOTE_ADDR'];
			if ($this->_post->toString('payment_method') != "creditcard")
			{
				$data['cc_type'] = ':NULL';
				$data['cc_num'] = ':NULL';
				$data['cc_code'] = ':NULL';
				$data['cc_exp_year'] = ':NULL';
				$data['cc_exp_month'] = ':NULL';
			}
			$id = pjBookingModel::factory(array_merge($this->_post->raw(), $data))->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if ($this->_post->toString('tmp_hash') != '')
				{
					pjBookingServiceModel::factory()
						->where('tmp_hash', $this->_post->toString('tmp_hash'))
						->modifyAll(array('booking_id' => $id, 'tmp_hash' => ':NULL'));
				}
				$err = 'ABK03';
			} else {
				$err = 'ABK04';
			}
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=$err");
		}
		
		if (self::isGet())
		{
			$this->set('country_arr', pjBaseCountryModel::factory()
					->select('t1.*, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.status', 'T')
					->orderBy('`name` ASC')
					->findAll()->getData());
				
			
			$tmp_hash = md5(uniqid(rand(), true));
			
			if($this->_get->check('employee_id') && $this->_get->check('service_id') && $this->_get->check('start_ts'))
			{
				$date = date('Y-m-d', $this->_get->toString('start_ts'));
				
				$service_arr = pjServiceModel::factory()->find($this->_get->toString('service_id'))->getData();
					
				$bs_id = pjBookingServiceModel::factory()->setAttributes(array(
						'tmp_hash' => $tmp_hash,
						'booking_id' => 0,
						'service_id' => $this->_get->toString('service_id'),
						'employee_id' => $this->_get->toString('employee_id'),
						'date' => $date,
						'start' => date("H:i:s", $this->_get->toString('start_ts')),
						'start_ts' => $this->_get->toString('start_ts'),
						'total' => @$service_arr['total'],
						'price' => @$service_arr['price']
				))->insert()->getInsertId();
					
				if ($bs_id !== FALSE && (int) $bs_id > 0)
				{
					$this->set('bs_id', $bs_id);
				}
			}
			
			$this->set('tmp_hash', $tmp_hash);				

			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions(NULL));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
				
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			
			$this
				->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/')
				->appendJs('pjAdminBookings.js');
		}
	}
	
	public function pjActionDeleteBooking()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
		
		if (pjBookingModel::factory()->setAttributes(array('id' => $this->_get->toInt('id')))->erase()->getAffectedRows() == 1)
		{
			pjBookingServiceModel::factory()->where('booking_id', $this->_get->toInt('id'))->eraseAll();
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionDeleteBookingBulk()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
		
		$record = $this->_post->toArray('record');
		if (count($record))
		{
			pjBookingModel::factory()->whereIn('id', $record)->eraseAll();
			pjBookingServiceModel::factory()->whereIn('booking_id', $record)->eraseAll();
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionGetBooking()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjBookingModel = pjBookingModel::factory();
		$pjBookingServiceModel = pjBookingServiceModel::factory();
			
		if ($q = $this->_get->toString('q'))
		{
			$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
			$pjBookingModel->where(sprintf("t1.uuid LIKE '%1\$s' OR t1.c_email LIKE '%1\$s' OR t1.c_name LIKE '%1\$s'", "%$q%"));
		}

		if ($this->_get->check('booking_status') && in_array($this->_get->toString('booking_status'), array('confirmed', 'pending', 'cancelled')))
		{
			$pjBookingModel->where('t1.booking_status', $this->_get->toString('booking_status'));
		}
		
		if ($this->_get->check('employee_id') && $this->_get->toInt('employee_id') > 0)
		{
			$pjBookingModel->where(sprintf("t1.id IN (SELECT `booking_id` FROM `%s` WHERE `employee_id` = '%u')", $pjBookingServiceModel->getTable(), $this->_get->toInt('employee_id')));
		}
		
		if ($this->_get->check('service_id') && $this->_get->toInt('service_id') > 0)
		{
			$pjBookingModel->where(sprintf("t1.id IN (SELECT `booking_id` FROM `%s` WHERE `service_id` = '%u')", $pjBookingServiceModel->getTable(), $this->_get->toInt('service_id')));
		}
		
		if ($this->_get->check('date_from') && $this->_get->check('date_to') && $this->_get->toString('date_from') != '' && $this->_get->toString('date_to') != '') 
		{
			$date_from = pjDateTime::formatDate($this->_get->toString('date_from'), $this->option_arr['o_date_format']);
			$date_to = pjDateTime::formatDate($this->_get->toString('date_to'), $this->option_arr['o_date_format']);
			$pjBookingModel->where(sprintf("t1.id IN (SELECT `booking_id` FROM `%s` WHERE `date` BETWEEN '%s' AND '%s')", $pjBookingServiceModel->getTable(), $date_from, $date_to));
		} else {
			if ($this->_get->check('date_from') && $this->_get->toString('date_from') != '')
			{
				$date_from = pjDateTime::formatDate($this->_get->toString('date_from'), $this->option_arr['o_date_format']);
				$pjBookingModel->where(sprintf("t1.id IN (SELECT `booking_id` FROM `%s` WHERE `date` >= '%s')", $pjBookingServiceModel->getTable(), $date_from));
			}
			if ($this->_get->check('date_to') && $this->_get->toString('date_to') != '')
			{
				$date_to = pjUtil::formatDate($this->_get->toString('date_to'), $this->option_arr['o_date_format']);
				$pjBookingModel->where(sprintf("t1.id IN (SELECT `booking_id` FROM `%s` WHERE `date` <= '%s')", $pjBookingServiceModel->getTable(), $date_to));
			}
		}
		
		$column = 'id';
		$direction = 'DESC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjBookingModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjBookingModel
			->select(sprintf("t1.*,
				(SELECT GROUP_CONCAT(CONCAT_WS('~.~', bs.service_id, DATE_FORMAT(FROM_UNIXTIME(bs.start_ts), '%%Y-%%m-%%d %%H:%%i:%%s'), m.content) SEPARATOR '~:~')
					FROM `%1\$s` AS `bs`
					LEFT JOIN `%2\$s` AS `m` ON m.model='pjService' AND m.foreign_id=bs.service_id AND m.field='name' AND m.locale='%3\$u'
					WHERE bs.booking_id = t1.id) AS `items`
				", $pjBookingServiceModel->getTable(), pjMultiLangModel::factory()->getTable(), $this->getLocaleId()))
			->orderBy("$column $direction")->limit($rowCount, $offset)
			->findAll()
			->toArray('items', '~:~')
			->getData();

		foreach ($data as $k => $v)
		{
			foreach ($data[$k]['items'] as $key => $val)
			{
				$tmp = explode('~.~', $val);
				if (isset($tmp[1]))
				{
					$tmp[1] = date($this->option_arr['o_date_format'] . ' ' . $this->option_arr['o_time_format'], strtotime($tmp[1]));
					$v['items'][$key] = join("~.~", $tmp);
				}
			}
			$data[$k]['items'] = pjSanitize::clean($v['items']);
			$data[$k]['c_name'] = pjSanitize::clean($v['c_name']);
			$data[$k]['c_email'] = pjSanitize::clean($v['c_email']);
			$data[$k]['c_phone'] = pjSanitize::clean($v['c_phone']);
			$data[$k]['total_formated'] = pjCurrency::formatPrice($v['booking_total']);
		}
			
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionGetBookingService()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjBookingServiceModel = pjBookingServiceModel::factory()
			->join('pjBooking', 't2.id=t1.booking_id', 'inner')
			->where('t1.employee_id', $this->getUserId());
			
		if ($q = $this->_get->toString('q'))
		{
			$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
			$pjBookingServiceModel->where(sprintf("t2.uuid LIKE '%1\$s' OR t2.c_email LIKE '%1\$s' OR t2.c_name LIKE '%1\$s'", "%$q%"));
		}

		if ($this->_get->check('booking_status') && in_array($this->_get->toString('booking_status'), array('confirmed', 'pending', 'cancelled')))
		{
			$pjBookingServiceModel->where('t2.booking_status', $this->_get->toString('booking_status'));
		}
		
		if ($this->_get->check('service_id') && $this->_get->toInt('service_id') > 0)
		{
			$pjBookingServiceModel->where('t1.service_id', $this->_get->toInt('service_id'));
		}
		
		if ($this->_get->check('date_from') && $this->_get->check('date_to') && $this->_get->toString('date_from') != '' && $this->_get->toString('date_to') != '') 
		{
			$date_from = pjDateTime::formatDate($this->_get->toString('date_from'), $this->option_arr['o_date_format']);
			$date_to = pjDateTime::formatDate($this->_get->toString('date_to'), $this->option_arr['o_date_format']);
			$pjBookingServiceModel->where(sprintf("(t1.date BETWEEN '%s' AND '%s')", $date_from, $date_to));
		} else {
			if ($this->_get->check('date_from') && $this->_get->toString('date_from') != '')
			{
				$date_from = pjDateTime::formatDate($this->_get->toString('date_from'), $this->option_arr['o_date_format']);
				$pjBookingServiceModel->where('t1.date >=', $date_from);
			}
			if ($this->_get->check('date_to') && $this->_get->toString('date_to') != '')
			{
				$date_to = pjUtil::formatDate($this->_get->toString('date_to'), $this->option_arr['o_date_format']);
				$pjBookingServiceModel->where('t1.date <=', $date_to);
			}
		}
		
		$column = 't1.date';
		$direction = 'DESC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjBookingServiceModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjBookingServiceModel
			->select("t1.*, t2.uuid, t2.booking_status, t2.c_name, t2.c_email, t2.c_phone, t3.content AS `service_name`")
			->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.service_id AND t3.field='name' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
			->orderBy("$column $direction")->limit($rowCount, $offset)
			->findAll()
			->getData();

		foreach ($data as $k => $v)
		{
			$data[$k]['time'] = date($this->option_arr['o_date_format'] . ' ' . $this->option_arr['o_time_format'], $v['start_ts']);
			$data[$k]['c_name'] = pjSanitize::clean($v['c_name']);
			$data[$k]['c_email'] = pjSanitize::clean($v['c_email']);
			$data[$k]['c_phone'] = pjSanitize::clean($v['c_phone']);
			$data[$k]['service_name'] = pjSanitize::clean($v['service_name']);
		}
			
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionGetPrice()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$price = $deposit = $tax = $total = 0;
		
		if ($this->_post->check('id') && $this->_post->toInt('id') > 0)
		{
			$key = 't1.booking_id';
			$value = $this->_post->toInt('id');
		} elseif ($this->_post->check('tmp_hash') && $this->_post->toString('tmp_hash') != '') {
			$key = 't1.tmp_hash';
			$value = $this->_post->toString('tmp_hash');
		}
		
		if (isset($key) && isset($value))
		{
			$bs_arr = pjBookingServiceModel::factory()->where($key, $value)->findAll()->getData();
			if(empty($bs_arr))
			{
				self::jsonResponse(array('status' => 'ERR'));
			}
			foreach ($bs_arr as $service)
			{
				$price += $service['price'];
			}
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
		
		$price_format = pjCurrency::formatPrice($price);
		$tax_format = pjCurrency::formatPrice($tax);
		$total_format = pjCurrency::formatPrice($total);
		$deposit_format = pjCurrency::formatPrice($deposit);
		
		$data = compact('price', 'deposit', 'tax', 'total');
		$data = array_map('floatval', $data);
		$data_format = compact('price_format', 'deposit_format', 'tax_format', 'total_format');
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => '', 'data' => $data, 'data_format' => $data_format));
	}
	
	public function pjActionGetService()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if ($this->_get->check('id') && $this->_get->toInt('id') > 0 && $this->_get->check('date') && $this->_get->toString('date') != '')
		{
			$id = $this->_get->toInt('id');
			$date = pjDateTime::formatDate($this->_get->toString('date'), $this->option_arr['o_date_format']);
			
			$pjEmployeeServiceModel = pjEmployeeServiceModel::factory()
				->select("t1.*, t2.calendar_id, t2.avatar, t3.content AS `name`")
				->join('pjEmployee', 't2.id=t1.employee_id AND t2.is_active="T"', 'inner')
				->join('pjMultiLang', "t3.model='pjEmployee' AND t3.foreign_id=t1.employee_id AND t3.field='name' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.service_id', $id)
				->orderBy('`name` ASC')
				->findAll();
			
			$employee_arr = $pjEmployeeServiceModel->getData();
			$employee_ids = $pjEmployeeServiceModel->getDataPair(null, 'employee_id');
			$bs_arr = array();
			if (!empty($employee_ids))
			{
				$bs_arr = pjBookingServiceModel::factory()
				    ->join('pjBooking', sprintf("t1.booking_id=t2.id AND (t2.booking_status='confirmed' OR (t2.booking_status='pending' AND UNIX_TIMESTAMP(t2.created) >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL %u MINUTE)) ) )", $this->option_arr['o_pending_time']), 'inner')
					->whereIn('t1.employee_id', $employee_ids)
					->where('t1.date', $date)
					->findAll()
					->getData();
			}

			foreach ($employee_arr as $k => $employee)
			{
				$employee_arr[$k]['t_arr'] = pjAppController::getRawSlotsPerEmployee($employee['employee_id'], $date, $employee['calendar_id']);
				$employee_arr[$k]['bs_arr'] = array();
				foreach ($bs_arr as $item)
				{
					if ($item['employee_id'] != $employee['employee_id'])
					{
						continue;
					}
					$employee_arr[$k]['bs_arr'][] = $item;
				}
			}

			$this
				->set('service_arr', pjServiceModel::factory()
					->select('t1.*, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->find($id)
					->getData()
				)
				->set('employee_arr', $employee_arr);
		}else{
		    self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing headers.'));
		}
	}
	
	public function pjActionIndex()
	{
		$this->set('employee_arr', pjEmployeeModel::factory()
			->select('t1.id, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('role_id', 3)
			->orderBy('`name` ASC')
			->findAll()
			->getData()
		);
	
		$this->set('service_arr', pjServiceModel::factory()
			->select('t1.*, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->orderBy('`name` ASC')
			->findAll()
			->getData()
		);
		
		$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminBookings.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminBookings', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminBookings', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBooking')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminBookings', 'pjActionDeleteBookingBulk')->hasAccess());
	}
	
	public function pjActionList()
	{
		$this->set('service_arr', pjServiceModel::factory()
			->select('t1.*, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->orderBy('`name` ASC')
			->where(sprintf("t1.id IN (SELECT `service_id` FROM `%s` WHERE `employee_id` = '%u')", pjEmployeeServiceModel::factory()->getTable(), $this->getUserId()))
			->findAll()
			->getData()
		);

		$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
		
		$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjEmployeeBookings.js');
	}
	
	public function pjActionSaveBooking()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjBookingModel = pjBookingModel::factory();
		if (!in_array($this->_post->toString('column'), $pjBookingModel->getI18n()))
		{
			$pjBookingModel->set('id', $this->_get->toInt('id'))->modify(array($this->_post->toString('column') => $this->_post->toString('value')));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($this->_post->toString('column') => $this->_post->toString('value'))), $this->_get->toInt('id'), 'pjBooking');
		}
	}
	
	public function pjActionUpdate()
	{
		$pjBookingModel = pjBookingModel::factory();
		
		if ($this->_get->check('id') && $this->_get->toInt('id')) {
			$pjBookingModel->where('t1.id', $this->_get->toInt('id'));
		}
		if ($this->_get->check('uuid') && $this->_get->toString('uuid')) {
			$pjBookingModel->where('t1.uuid', $this->_get->toString('uuid'));
		}

		if ($this->_post->check('id') && $this->_post->toInt('id')) {
			$pjBookingModel->where('t1.id', $this->_post->toInt('id'));
		}
		
		$arr = $pjBookingModel
				->limit(1)
				->findAll()
				->getData();
			
		if (empty($arr))
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminBookings&action=pjActionIndex&err=ABK08");
		}
		$arr = $arr[0];
		
		if (self::isPost() && $this->_post->toInt('booking_update') > 0)
		{
			$data = array();
			if ($this->_post->toString('payment_method') != "creditcard")
			{
				$data['cc_type'] = ':NULL';
				$data['cc_num'] = ':NULL';
				$data['cc_code'] = ':NULL';
				$data['cc_exp_year'] = ':NULL';
				$data['cc_exp_month'] = ':NULL';
			}
			$arr = $pjBookingModel->find($this->_post->toInt('id'))->getData();
							
			pjBookingModel::factory()->set('id', $this->_post->toInt('id'))->modify(array_merge($this->_post->raw(), $data));
			pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminBookings&action=pjActionIndex&err=ABK01");
		} 
		
		if (self::isGet())
		{
			$this->set('arr', $arr)
				->set('country_arr', pjBaseCountryModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjBaseCountry' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->orderBy('`name` ASC')
				->findAll()->getData());
			
			$this->set('bi_arr', pjBookingServiceModel::factory()
				->select('t1.*, t2.content AS `title`')
				->join('pjMultiLang', sprintf("t2.model='pjService' AND t2.foreign_id=t1.service_id AND t2.field='name' AND t2.locale='%u'", $arr['locale_id']), 'left outer')
				->where('t1.booking_id', $arr['id'])
				->findAll()
				->getData()
			);
			
			if(pjObject::getPlugin('pjPayments') !== NULL)
			{
				$this->set('payment_option_arr', pjPaymentOptionModel::factory()->getOptions(NULL));
				$this->set('payment_titles', pjPayments::getPaymentTitles($this->getForeignId(), $this->getLocaleId()));
			}
			else
			{
				$this->set('payment_titles', __('payment_methods', true));
			}
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			
			$this->appendJs('tinymce.min.js', PJ_THIRD_PARTY_PATH . 'tinymce/');
			
			$this
				->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/')
				->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/')
				->appendJs('pjAdminBookings.js')
			;
		}
	}
		
	public function pjActionViewBookingService()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (self::isGet() && $this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$arr = pjBookingServiceModel::factory()
				->select('t2.*, t1.*, t3.content AS `service_name`, t4.content AS `country_name`')
				->join('pjBooking', 't2.id=t1.booking_id', 'inner')
				->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.service_id AND t3.field='name' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
				->join('pjMultiLang', "t4.model='pjBaseCountry' AND t4.foreign_id=t2.c_country_id AND t4.field='name' AND t4.locale='".$this->getLocaleId()."'", 'left outer')
				->find($this->_get->toInt('id'))
				->getData();
			
			$this->set('arr', $arr);
		}
	}
	
	public function pjActionItemAdd()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjBookingServiceModel = pjBookingServiceModel::factory();
		
		if (self::isPost() && $this->_post->check('item_add'))
		{
			if ($this->_post->check('service_id') && $this->_post->toInt('service_id') > 0)
			{
				$date = pjDateTime::formatDate($this->_post->toString('date'), $this->option_arr['o_date_format']);
			
				$service_arr = pjServiceModel::factory()->find($this->_post->toInt('service_id'))->getData();
				
				$bs_id = $pjBookingServiceModel->reset()->setAttributes(array(
					'tmp_hash' => @$this->_post->toString('tmp_hash'),
					'booking_id' => @$this->_post->toInt('booking_id'),
					'service_id' => $this->_post->toInt('service_id'),
					'employee_id' => $this->_post->toInt('employee_id'),
					'date' => $date,
					'start' => date("H:i:s", $this->_post->toString('start_ts')),
					'start_ts' => $this->_post->toString('start_ts'),
					'total' => @$service_arr['total'],
					'price' => @$service_arr['price']
				))->insert()->getInsertId();
				
				if ($bs_id !== FALSE && (int) $bs_id > 0)
				{
					self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service has been added.'));
				}
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Service has not been added.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Service couldn\'t be empty.'));
		}
		
		if (self::isGet()) 
		{
			$service_arr = pjServiceModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.is_active', 1)
				->findAll()->getData();
			
			$this->set('service_arr', $service_arr);
		}
	}
	
	public function pjActionItemDelete()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if ($this->_post->check('id') && $this->_post->toInt('id') > 0)
		{
			$pjBookingServiceModel = pjBookingServiceModel::factory();
			$arr = $pjBookingServiceModel->find($this->_post->toInt('id'))->getData();
			if (empty($arr))
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Item not found.'));
			}
			if (1 == $pjBookingServiceModel->set('id', $this->_post->toInt('id'))->erase()->getAffectedRows())
			{
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Item has been deleted.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Item has not been deleted.'));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing parameters.'));
	}
	
	public function pjActionItemGet()
	{
		$this->setAjax(true);
		
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjBookingServiceModel = pjBookingServiceModel::factory()
			->select("t1.*, t2.content AS `service`, t3.content AS `employee`")
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.service_id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'")
			->join('pjMultiLang', "t3.model='pjEmployee' AND t3.foreign_id=t1.employee_id AND t3.field='name' AND t3.locale='".$this->getLocaleId()."'");
		
		if ($this->_get->check('booking_id') && $this->_get->toInt('booking_id') > 0)
		{
			$pjBookingServiceModel
				->join('pjBooking', 't4.id=t1.booking_id', 'inner')
				->where('t1.booking_id', $this->_get->toInt('booking_id'));
		} elseif ($this->_get->check('tmp_hash') && $this->_get->toString('tmp_hash') != '') {
			$pjBookingServiceModel->where('t1.tmp_hash', $this->_get->toString('tmp_hash'));
		} else {
			$pjBookingServiceModel->where('t1.id', -999);
		}
		$bi_arr = $pjBookingServiceModel->findAll()->getData();
		
		$this->set('bi_arr', $bi_arr);
	}

	public function pjActionItemEmail()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if ($this->_post->check('send_email') && $this->_post->check('to') && $this->_post->toArray('to') != '' && $this->_post->toString('from') != '' &&
			$this->_post->toString('subject') != '' && $this->_post->toString('message') != '' && $this->_post->toString('id') != '')
		{
			$Email = self::getMailer($this->option_arr);
			
			$r = false;
			if ($this->_post->toString('message') != '')
			{
				$message = pjUtil::textToHtml($this->_post->toString('message'));
				$tos = $this->_post->toArray('to');
				foreach ($tos as $recipient)
				{
					$r = $Email
						->setTo($recipient)
						->setSubject($this->_post->toString('subject'))
						->send($message);
				}
			}
				
			if ($r)
			{
				pjBookingServiceModel::factory()->set('id', $this->_post->toInt('id'))->modify(array('reminder_email' => 1));
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Email has been sent.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Email failed to send.'));
		}
		
		if (self::isGet() && $this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$booking_arr = pjBookingServiceModel::factory()
				->select('t2.*, t1.*, t3.length, t3.before, t4.content AS `service_name`,
					t6.email AS `employee_email`, t7.content AS `country_name`, t8.content AS `o_reminder_subject`, t9.content AS `o_reminder_body`')
				->join('pjBooking', 't2.id=t1.booking_id', 'inner')
				->join('pjService', 't3.id=t1.service_id', 'inner')
				->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
				->join('pjCalendar', 't5.id=t2.calendar_id', 'left outer')
				->join('pjEmployee', 't6.id=t1.employee_id', 'left outer')
				->join('pjMultiLang', "t7.model='pjBaseCountry' AND t7.foreign_id=t2.c_country_id AND t7.locale=t2.locale_id AND t7.field='name'", 'left outer')
				->join('pjMultiLang', "t8.model='pjCalendar' AND t8.foreign_id=t2.calendar_id AND t8.locale=t2.locale_id AND t8.field='o_reminder_subject'", 'left outer')
				->join('pjMultiLang', "t9.model='pjCalendar' AND t9.foreign_id=t2.calendar_id AND t9.locale=t2.locale_id AND t9.field='o_reminder_body'", 'left outer')
				->find($this->_get->toInt('id'))
				->getData();
			
			$tokens = pjAppController::getTokens($booking_arr, $this->option_arr);
			
			$subject_client = str_replace($tokens['search'], $tokens['replace'], $booking_arr['o_reminder_subject']);
			$message_client = str_replace($tokens['search'], $tokens['replace'], $booking_arr['o_reminder_body']);
			
			$this->set('arr', array(
				'id' => $this->_get->toInt('id'),
				//'to' => $booking_arr['c_email'],
				'client_email' => pjSanitize::clean($booking_arr['c_email']),
				'employee_email' => pjSanitize::clean($booking_arr['employee_email']),
				'from' => !empty($booking_arr['admin_email']) ? $booking_arr['admin_email'] : $booking_arr['c_email'],
				'message' => $message_client,
				'subject' => $subject_client
			));
		} else {
			exit;
		}
	}
	
	public function pjActionItemSms()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if ($this->_post->check('send_sms') && $this->_post->check('to') && $this->_post->toString('to') != '' && $this->_post->toString('message') != '' && $this->_post->toString('id') != '')
		{
			$params = array(
				'text' => $this->_post->toString('message'),
				'type' => 'unicode',
				'key' => md5($this->option_arr['private_key'] . PJ_SALT)
			);
			
			foreach ($this->_post->toArray('to') as $recipient)
			{
				$params['number'] = $recipient;
				$result = $this->requestAction(array('controller' => 'pjBaseSms', 'action' => 'pjActionSend', 'params' => $params), array('return'));
			}

			if ((int) $result === 1)
			{
				pjBookingServiceModel::factory()->set('id', $this->_post->toInt('id'))->modify(array('reminder_sms' => 1));
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'SMS has been sent.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'SMS failed to send.'));
		}
		
		if (self::isGet() && $this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$booking_arr = pjBookingServiceModel::factory()
				->select('t2.*, t1.*, t3.before, t3.length, t4.content AS `service_name`,
					t6.phone AS `employee_phone`, t7.content AS `country_name`, t8.content AS `o_reminder_sms_message`')
				->join('pjBooking', 't2.id=t1.booking_id', 'inner')
				->join('pjService', 't3.id=t1.service_id', 'inner')
				->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
				->join('pjCalendar', 't5.id=t2.calendar_id', 'left outer')
				->join('pjEmployee', 't6.id=t1.employee_id', 'left outer')
				->join('pjMultiLang', "t7.model='pjBaseCountry' AND t7.foreign_id=t2.c_country_id AND t7.locale=t2.locale_id AND t7.field='name'", 'left outer')
				->join('pjMultiLang', "t8.model='pjCalendar' AND t8.foreign_id=t2.calendar_id AND t8.locale=t2.locale_id AND t8.field='o_reminder_sms_message'", 'left outer')
				->find($this->_get->toInt('id'))
				->getData();
			
			$tokens = pjAppController::getTokens($booking_arr, $this->option_arr);
			
			$message_client = str_replace($tokens['search'], $tokens['replace'], $booking_arr['o_reminder_sms_message']);
			
			$this->set('arr', array(
				'id' => $this->_get->toInt('id'),
				'client_phone' => $booking_arr['c_phone'],
				'employee_phone' => $booking_arr['employee_phone'],
				'message' => $message_client
			));
		} else {
			exit;
		}
	}
	
	public function pjActionExport()
	{
	    $this->checkLogin();
	    
	    if (!pjAuth::factory()->hasAccess())
	    {
	        $this->sendForbidden();
	        return;
	    }
	    
	    if(self::isPost() && $this->_post->check('bookings_export'))
	    {
	        if($this->_post->toString('type') == 'file')
	        {
	            $this->setLayout('pjActionEmpty');
	            $post = $this->_post->raw();
	            $post['type'] = $post['period'] == 'next' ? '1' : '2';
	            $post['period'] = $post['period'] == 'next' ? $post['coming_period'] : $post['made_period'];
	            $arr = pjExport::doExportData($post, 'download', $this->getLocaleId(), $this->option_arr);
	            exit;
	        }else{
	            $pjPasswordModel = pjPasswordModel::factory();
	            $password = md5($this->_post->toString('password').PJ_SALT);
	            $arr = $pjPasswordModel
	            ->where("t1.password", $password)
	            ->limit(1)
	            ->findAll()
	            ->getData();
	            if (count($arr) != 1)
	            {
	                $pjPasswordModel->setAttributes(array('password' => $password))->insert();
	            }
	            $this->set('password', $password);
	        }
	    }
	    
	    $this->appendCss('awesome-bootstrap-checkbox.css', PJ_THIRD_PARTY_PATH . 'awesome_bootstrap_checkbox/');
	    $this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
	    $this->appendJs('pjAdminBookings.js');
	}
}
?>