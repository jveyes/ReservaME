<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminReports extends pjAdmin
{
	public function pjActionCheckDate()
	{
		$this->setAjax(true);
	
		if ($this->isXHR())
		{
			$dt_from = strtotime(pjDateTime::formatDate($this->_post->toString('date_from'), $this->option_arr['o_date_format']));
			$dt_to = strtotime(pjDateTime::formatDate($this->_post->toString('date_to'), $this->option_arr['o_date_format']));
			echo $dt_to >= $dt_from ? 'true' : 'false';
		}
		exit;
	}
	
	private function getEmployees($params)
	{
		$pjEmployeeModel = pjEmployeeModel::factory()
			->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.calendar_id', $this->getForeignId())
			->where('t1.is_active', 'T');
		
		if (isset($params['q']) && !empty($params['q']))
		{
			$q = str_replace(array('_', '%'), array('\_', '\%'), trim($pjEmployeeModel->escapeString($params['q'])));
			$pjEmployeeModel->where(sprintf("(t2.content LIKE '%1\$s' OR t1.email LIKE '%1\$s' OR t1.notes LIKE '%1\$s')", "%$q%"));
		}

		if (isset($params['employee_id']) && (int) $params['employee_id'] > 0)
		{
			$pjEmployeeModel->where('t1.id', $params['employee_id']);
		}
		
		$c_service = NULL;
		if (isset($params['service_id']) && (int) $params['service_id'] > 0)
		{
			$c_service = sprintf(" AND bs.service_id = '%u'", (int) $params['service_id']);
		}
		
		$c_date = NULL;
		if (!isset($params['date_from']) && !isset($params['date_to'])) {
			$params['date_from'] = date($this->option_arr['o_date_format']);
			$params['date_to'] = date($this->option_arr['o_date_format']);
		}
		if (isset($params['date_from']) && !empty($params['date_from']) && isset($params['date_to']) && !empty($params['date_to']))
		{
			$date_from = pjDateTime::formatDate($params['date_from'], $this->option_arr['o_date_format']);
			$date_to = pjDateTime::formatDate($params['date_to'], $this->option_arr['o_date_format']);
			$c_date = sprintf(" AND (bs.date BETWEEN '%s' AND '%s')", $date_from, $date_to);
		} else {
			if (isset($params['date_from']) && !empty($params['date_from']))
			{
				$date_from = pjDateTime::formatDate($params['date_from'], $this->option_arr['o_date_format']);
				$c_date = sprintf(" AND bs.date >= '%s'", $date_from);
			} else if (isset($params['date_to']) && !empty($params['date_to'])) {
				$date_to = pjDateTime::formatDate($params['date_to'], $this->option_arr['o_date_format']);
				$c_date = sprintf(" AND bs.date <= '%s'", $date_to);
			}
		}

		$column = 'name';
		$direction = 'ASC';
		if (isset($params['direction']) && isset($params['column']) && in_array(strtoupper($params['direction']), array('ASC', 'DESC')))
		{
			$column = $params['column'];
			$direction = strtoupper($params['direction']);
		}

		$total = $pjEmployeeModel->findCount()->getData();
		$rowCount = isset($params['rowCount']) && (int) $params['rowCount'] > 0 ? (int) $params['rowCount'] : 100;
		$pages = ceil($total / $rowCount);
		$page = isset($params['page']) && (int) $params['page'] > 0 ? intval($params['page']) : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjEmployeeModel
			->select(sprintf("t1.id, NULL AS `password`, t2.content AS `name`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id`
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `total_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'confirmed'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `confirmed_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'pending'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `pending_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'cancelled'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `cancelled_bookings`,
					
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id`
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `total_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'confirmed'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `confirmed_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'pending'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `pending_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'cancelled'
					WHERE `bs`.`employee_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `cancelled_amount`
				", pjBookingServiceModel::factory()->getTable(), pjBookingModel::factory()->getTable(), $c_date, $c_service))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		foreach ($data as $k => $v)
		{
			$data[$k]['name'] = pjSanitize::clean($v['name']);
			$data[$k]['total_amount_format'] = pjCurrency::formatPrice($v['total_amount']);
			$data[$k]['confirmed_amount_format'] = pjCurrency::formatPrice($v['confirmed_amount']);
			$data[$k]['pending_amount_format'] = pjCurrency::formatPrice($v['pending_amount']);
			$data[$k]['cancelled_amount_format'] = pjCurrency::formatPrice($v['cancelled_amount']);
		}
		
		return compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction');
	}
	
	private function getServices($params)
	{
		$pjServiceModel = pjServiceModel::factory()
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.field='description' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.calendar_id', $this->getForeignId());
		
		if (isset($params['q']) && !empty($params['q']))
		{
			$q = str_replace(array('_', '%'), array('\_', '\%'), trim($params['q']));
			$pjServiceModel->where('t2.content LIKE', "%$q%");
			$pjServiceModel->orWhere('t3.content LIKE', "%$q%");
		}

		if (isset($params['service_id']) && (int) $params['service_id'] > 0)
		{
			$pjServiceModel->where('t1.id', $params['service_id']);
		}
		
		$c_employee = NULL;
		if (isset($params['employee_id']) && (int) $params['employee_id'] > 0)
		{
			$c_employee = sprintf(" AND bs.employee_id = '%u'", (int) $params['employee_id']);
		}
		
		$c_date = NULL;
		if (!isset($params['date_from']) && !isset($params['date_to'])) {
			$params['date_from'] = date($this->option_arr['o_date_format']);
			$params['date_to'] = date($this->option_arr['o_date_format']);
		}
		if (isset($params['date_from']) && !empty($params['date_from']) && isset($params['date_to']) && !empty($params['date_to']))
		{
			$date_from = pjDateTime::formatDate($params['date_from'], $this->option_arr['o_date_format']);
			$date_to = pjDateTime::formatDate($params['date_to'], $this->option_arr['o_date_format']);
			$c_date = sprintf(" AND (bs.date BETWEEN '%s' AND '%s')", $date_from, $date_to);
		} else {
			if (isset($params['date_from']) && !empty($params['date_from']))
			{
				$date_from = pjDateTime::formatDate($params['date_from'], $this->option_arr['o_date_format']);
				$c_date = sprintf(" AND bs.date >= '%s'", $date_from);
			} else if (isset($params['date_to']) && !empty($params['date_to'])) {
				$date_to = pjDateTime::formatDate($params['date_to'], $this->option_arr['o_date_format']);
				$c_date = pjDateTime(" AND bs.date <= '%s'", $date_to);
			}
		}

		$column = 'name';
		$direction = 'ASC';
		if (isset($params['direction']) && isset($params['column']) && in_array(strtoupper($params['direction']), array('ASC', 'DESC')))
		{
			$column = $params['column'];
			$direction = strtoupper($params['direction']);
		}

		$total = $pjServiceModel->findCount()->getData();
		$rowCount = isset($params['rowCount']) && (int) $params['rowCount'] > 0 ? (int) $params['rowCount'] : 100;
		$pages = ceil($total / $rowCount);
		$page = isset($params['page']) && (int) $params['page'] > 0 ? intval($params['page']) : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjServiceModel
			->select(sprintf("t1.*, t2.content AS `name`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id`
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `total_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'confirmed'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `confirmed_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'pending'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `pending_bookings`,
				(SELECT COUNT(*)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'cancelled'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `cancelled_bookings`,
					
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id`
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `total_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'confirmed'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `confirmed_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'pending'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `pending_amount`,
				(SELECT COALESCE(SUM(`b`.`booking_total`), 0)
					FROM `%1\$s` AS `bs`
					INNER JOIN `%2\$s` AS `b` ON `b`.`id` = `bs`.`booking_id` AND `b`.`booking_status` = 'cancelled'
					WHERE `bs`.`service_id` = `t1`.`id` %3\$s %4\$s
					LIMIT 1) AS `cancelled_amount`
				", pjBookingServiceModel::factory()->getTable(), pjBookingModel::factory()->getTable(), $c_date, $c_employee
			))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		foreach ($data as $k => $v)
		{
			$data[$k]['name'] = pjSanitize::clean($v['name']);
			$data[$k]['total_amount_format'] = pjCurrency::formatPrice($v['total_amount']);
			$data[$k]['confirmed_amount_format'] = pjCurrency::formatPrice($v['confirmed_amount']);
			$data[$k]['pending_amount_format'] = pjCurrency::formatPrice($v['pending_amount']);
			$data[$k]['cancelled_amount_format'] = pjCurrency::formatPrice($v['cancelled_amount']);
		}
		
		return compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction');
	}
	
	public function pjActionGetEmployee()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}

		$data = $this->getEmployees($this->_get->raw());
		self::jsonResponse($data);
	}
	
	public function pjActionGetService()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$data = $this->getServices($this->_get->raw());
		self::jsonResponse($data);
	}
	
	public function pjActionEmployees()
	{
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
		$this->appendJs('pjAdminReports.js');
	}
	
	public function pjActionServices()
	{
		$this->set('employee_arr', pjEmployeeModel::factory()
			->select('t1.id, t2.content AS `name`')
			->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('role_id', 3)
			->orderBy('`name` ASC')
			->findAll()
			->getData()
		);
		
		$this->appendCss('datepicker.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminReports.js');
	}

	public function pjActionPrint()
	{
		$this->setLayout('pjActionPrint');
		
		if ($this->_get->check('type') && in_array($this->_get->toString('type'), array('services', 'employees')))
		{
			switch ($this->_get->toString('type'))
			{
				case 'services':
					$arr = $this->getServices($this->_get->raw());
					break;
				case 'employees':
					$arr = $this->getEmployees($this->_get->raw());
					break;
			}
			
			$this->set('arr', $arr);
		}
	}
}
?>