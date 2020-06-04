<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAppController extends pjBaseAppController
{
	public $models = array();

	private $layoutRange = array(1, 2);
	
    public function pjActionCheckInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());
        $folders = array('app/web/upload');
        foreach ($folders as $dir)
        {
            if (!is_writable($dir))
            {
                $result['status'] = 'ERR';
                $result['code'] = 101;
                $result['text'] = 'Permission requirement';
                $result['info'][] = sprintf('Folder \'<span class="bold">%1$s</span>\' is not writable. You need to set write permissions (chmod 777) to directory located at \'<span class="bold">%1$s</span>\'', $dir);
            }
        }

        return $result;
    }

    /**
     * Sets some predefined role permissions and grants full permissions to Admin.
     */
    public function pjActionAfterInstall()
    {
        $this->setLayout('pjActionEmpty');

        $result = array('status' => 'OK', 'code' => 200, 'text' => 'Operation succeeded', 'info' => array());

        $pjAuthRolePermissionModel = pjAuthRolePermissionModel::factory();
        $pjAuthUserPermissionModel = pjAuthUserPermissionModel::factory();

        $permissions = pjAuthPermissionModel::factory()->findAll()->getDataPair('key', 'id');

        $roles = array(1 => 'admin', 2 => 'editor', 3 => 'employee');
        foreach ($roles as $role_id => $role)
        {
            if (isset($GLOBALS['CONFIG'], $GLOBALS['CONFIG']["role_permissions_{$role}"])
                && is_array($GLOBALS['CONFIG']["role_permissions_{$role}"])
                && !empty($GLOBALS['CONFIG']["role_permissions_{$role}"]))
            {
                $pjAuthRolePermissionModel->reset()->where('role_id', $role_id)->eraseAll();

                foreach ($GLOBALS['CONFIG']["role_permissions_{$role}"] as $role_permission)
                {
                    if($role_permission == '*')
                    {
                        // Grant full permissions for the role
                        foreach($permissions as $key => $permission_id)
                        {
                            $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                        }
                        break;
                    }
                    else
                    {
                        $hasAsterix = strpos($role_permission, '*') !== false;
                        if($hasAsterix)
                        {
                            $role_permission = str_replace('*', '', $role_permission);
                        }

                        foreach($permissions as $key => $permission_id)
                        {
                            if($role_permission == $key || ($hasAsterix && strpos($key, $role_permission) !== false))
                            {
                                $pjAuthRolePermissionModel->setAttributes(compact('role_id', 'permission_id'))->insert();
                            }
                        }
                    }
                }
            }
        }

		// Grant full permissions to Admin
        $user_id = 1; // Admin ID
        $pjAuthUserPermissionModel->reset()->where('user_id', $user_id)->eraseAll();
        foreach($permissions as $key => $permission_id)
        {
            $pjAuthUserPermissionModel->setAttributes(compact('user_id', 'permission_id'))->insert();
        }

        return $result;
    }
	
	public function getLayoutRange()
	{
		return $this->layoutRange;
	}
	
    public function beforeFilter()
    {
        parent::beforeFilter();

        if(!in_array($this->_get->toString('controller'), array('pjFront')))
        {
            $this->appendJs('pjAdminCore.js');
            // TODO: DELETE unnecessary files
            #$this->appendCss('reset.css');
            #$this->appendCss('pj-all.css', PJ_FRAMEWORK_LIBS_PATH . 'pj/css/');
            $this->appendCss('admin.css');
            
            /* $this->appendJs('jquery-ui.min.js', PJ_THIRD_PARTY_PATH . 'jquery_ui/');
            $this->appendCss('jquery-ui.min.css', PJ_THIRD_PARTY_PATH . 'jquery_ui/'); */
        }
        
        return true;
    }
    
    public function getForeignId()
    {
    	return 1;
    }
    
    public function isEmployee()
    {
    	return (int) $this->getRoleId() === 3;
    }
    
    public function isInvoiceReady()
	{
		return $this->isAdmin();
	}
    
    public function isCountryReady()
    {
    	return $this->isAdmin();
    }
    
    public function isOneAdminReady()
    {
    	return $this->isAdmin();
    }
    
    public static function jsonDecode($str)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->decode($str);
	}
	
	public static function jsonEncode($arr)
	{
		$Services_JSON = new pjServices_JSON();
		return $Services_JSON->encode($arr);
	}
	
	public static function jsonResponse($arr)
	{
		header("Content-Type: application/json; charset=utf-8");
		echo pjAppController::jsonEncode($arr);
		exit;
	}

	public function getLocaleId()
	{
		return isset($_SESSION[$this->defaultLocale]) && (int) $_SESSION[$this->defaultLocale] > 0 ? (int) $_SESSION[$this->defaultLocale] : 1;
	}
	
	public function setLocaleId($locale_id)
	{
		$_SESSION[$this->defaultLocale] = (int) $locale_id;
	}
	
	public static function getRawSlots($foreign_id, $date, $type, $option_arr)
	{
		$date_arr = pjDateModel::factory()->getDailyWorkingTime($foreign_id, $date, $type);
		if ($date_arr === false)
		{
			# There is not custom working time/prices for given date, so get for day of week (Monday, Tuesday...)
			$pjWorkingTimeModel = pjWorkingTimeModel::factory();
			$wt_data = $pjWorkingTimeModel->getWorkingTime($foreign_id, $type);
			$wt_arr = $pjWorkingTimeModel->filterDate($wt_data, $date);
			if (empty($wt_arr))
			{
				# It's Day off
				return false;
			}
			// $wt_arr['slot_length'] = $option_arr['slot_length'];
			return $wt_arr;
		} else {
			# There is custom working time/prices for given date
			if (count($date_arr) === 0)
			{
				# It's Day off
				return false;
			}
			return $date_arr;
		}
	}
	
	public static function getSingleDateSlots($calendar_id, $date)
	{
		$pjDateModel = pjDateModel::factory();
		$pjWorkingTimeModel = pjWorkingTimeModel::factory();
		
		$employee_arr = pjEmployeeModel::factory()
			->where('t1.calendar_id', $calendar_id)
			->where('t1.is_active', 'T')
			->findAll()
			->getData();

		foreach ($employee_arr as $key => $employee)
		{
			$employee_arr[$key]['custom'] = $pjDateModel->reset()->getDailyWorkingTime($employee['id'], $date, 'employee');
			$wt_data = $pjWorkingTimeModel->reset()->getWorkingTime($employee['id'], 'employee');
			$employee_arr[$key]['default'] = $pjWorkingTimeModel->filterDate($wt_data, $date);
		}
		
		$general_custom = $pjDateModel->reset()->getDailyWorkingTime($calendar_id, $date, 'calendar');
		
		$start_ts = array();
		$end_ts = array();
		foreach ($employee_arr as $i => $employee)
		{
			if (is_array($employee['custom']) && !empty($employee['custom']))
			{
				$start_ts[$i] = $employee['custom']['start_ts'];
				$end_ts[$i] = $employee['custom']['end_ts'];
				continue;
			}
		
			if (!empty($general_custom))
			{
				$start_ts[$i] = $general_custom['start_ts'];
				$end_ts[$i] = $general_custom['end_ts'];
				continue;
			}

			if (is_array($employee['default']) && !empty($employee['default']))
			{
				$start_ts[$i] = $employee['default']['start_ts'];
				$end_ts[$i] = $employee['default']['end_ts'];
			}
		}
		
		if (empty($start_ts) || empty($end_ts))
		{
			$wt_data = $pjWorkingTimeModel->reset()->getWorkingTime($calendar_id, 'calendar');
			$general_default = $pjWorkingTimeModel->filterDate($wt_data, $date);
			if (empty($start_ts) && !empty($general_default))
			{
				$start_ts[] = $general_default['start_ts'];
			}
			if (empty($end_ts) && !empty($general_default))
			{
				$end_ts[] = $general_default['end_ts'];
			}
		}
		
		return array(
			'start_ts' => min($start_ts),
			'end_ts' => max($end_ts)
		);
	}
	
	public static function getRawSlotsInRange($foreign_id, $date_from, $date_to, $type)
	{
		$date_arr = pjDateModel::factory()->getRangeWorkingTime($foreign_id, $date_from, $date_to, $type);
		
		$pjWorkingTimeModel = pjWorkingTimeModel::factory();
		$wt_data = $pjWorkingTimeModel->getWorkingTime($foreign_id, $type);

		$t_arr = array();
		foreach ($date_arr as $date => $item)
		{
			$t_arr[$date] = array();
			
			# There is not custom working time/prices for given date, so get for day of week (Monday, Tuesday...)
			if (empty($item))
			{
				$wt_arr = $pjWorkingTimeModel->filterDate($wt_data, $date);
				# It's Day off
				if (empty($wt_arr))
				{
					$t_arr[$date]['is_dayoff'] = 'T';
					continue;
				}
				
				$t_arr[$date] = $wt_arr;
				continue;
			}
			
			# Custom day is off
			if ($item['is_dayoff'] == 'T')
			{
				$t_arr[$date]['is_dayoff'] = 'T';
				continue;
			}
			
			$t_arr[$date] = $item;
		}
		
		return $t_arr;
	}
	
	public static function getRawSlotsPerEmployee($employee_id, $date, $cid)
	{
		$pjDateModel = pjDateModel::factory();
		
		# Get custom working time for given employee
		$date_arr = $pjDateModel->getDailyWorkingTime($employee_id, $date, 'employee');
		if ($date_arr !== false)
		{
			# It's Day off
			if (count($date_arr) === 0)
			{
				return false;
			}
			
			# Return custom working time per employee
			return $date_arr;
		}
		
		# There is not custom working time for given date & employee
		 
		# Now check for default/global custom working time
		$date_arr = $pjDateModel->getDailyWorkingTime($cid, $date);
		if ($date_arr !== false)
		{
			# It's Day off
			if (count($date_arr) === 0)
			{
				return false;
			}
			
			# Return default/global custom working time
			return $date_arr;
		}
		
		# There is not default/global custom working time for given date,
		
		# Now get default working time for given employee per weekday (Monday, Tuesday...)
		$pjWorkingTimeModel = pjWorkingTimeModel::factory();
		$wt_data = $pjWorkingTimeModel->getWorkingTime($employee_id, 'employee');
		$wt_arr = $pjWorkingTimeModel->filterDate($wt_data, $date);
		#$wt_arr = pjWorkingTimeModel::factory()->getWorkingTime($employee_id, $date, 'employee');
		if ($wt_arr === false)
		{
			return false; //FIXME
		}
		# It's Day off
		if (count($wt_arr) === 0)
		{
			return false;
		}
		
		# Return default working time per employee
		return $wt_arr;
	}
	
	public static function getDatesInRange($calendar_id, $date_from, $date_to)
	{
		# Build date array
		$_arr = array();
		$from = strtotime($date_from);
		$to = strtotime($date_to);
		if ($from > $to)
		{
			$tmp = $from;
			$from = $to;
			$to = $tmp;
		}
		for ($i = $from; $i <= $to; $i += 86400)
		{
			$_arr[date("Y-m-d", $i)] = '';
		}
		
		$pjDateModel = pjDateModel::factory();
		$pjWorkingTimeModel = pjWorkingTimeModel::factory();
		
		$employee_arr = pjEmployeeModel::factory()
			->where('t1.calendar_id', $calendar_id)
			->where('t1.is_active', 'T')
			->findAll()
			->getDataPair('id');

		foreach ($employee_arr as $key => $employee)
		{
			$employee_arr[$key]['custom'] = $pjDateModel->reset()->getRangeWorkingTime($employee['id'], $date_from, $date_to, 'employee');
			$employee_arr[$key]['default'] = $_arr;
			$wt_data = $pjWorkingTimeModel->reset()->getWorkingTime($employee['id'], 'employee');
			foreach ($_arr as $date => $whatever)
			{
				$employee_arr[$key]['default'][$date] = $pjWorkingTimeModel->filterDate($wt_data, $date);
			}
		}
		
		$general_custom = $pjDateModel->reset()->getRangeWorkingTime($calendar_id, $date_from, $date_to, 'calendar');
		
		$stack = array();
		$employee_cnt = count($employee_arr);
		foreach ($_arr as $date => $whatever)
		{
			$stack[$date] = array();
			foreach ($employee_arr as $key => $employee)
			{
				$stack[$date][$key] = NULL;
				
				if (!empty($employee['custom'][$date]) && isset($employee['custom'][$date]['is_dayoff']))
				{
					$stack[$date][$key] = $employee['custom'][$date]['is_dayoff'] == 'F' ? 'ON' : 'OFF';
					continue;
				}
				
				if (isset($general_custom[$date]) && !empty($general_custom[$date]) &&
					isset($general_custom[$date]['is_dayoff']))
				{
					$stack[$date][$key] = $general_custom[$date]['is_dayoff'] == 'F' ? 'ON' : 'OFF';
					continue;
				}
				
				if (isset($employee['default'][$date]))
				{
					$stack[$date][$key] = !empty($employee['default'][$date]) ? 'ON' : 'OFF';
				}
			}
		}

		$result = array();
		foreach ($stack as $date => $values)
		{
			if (in_array('ON', $values))
			{
				$result[$date] = 'ON';
			} else {
				$result[$date] = 'OFF';
			}
		}
		
		return array($result, $stack);
	}
	
	static public function getSingleService($booking, $option_arr)
	{
		//  Before and after time is not included in booking time
		$booking_data = stripslashes($booking['service_name']) . ":\n".
			date($option_arr['o_date_format'], strtotime($booking['date'])). "\n".
			date($option_arr['o_time_format'], $booking['start_ts'] + $booking['before'] * 60). " - ".
			date($option_arr['o_time_format'], $booking['start_ts'] + $booking['before'] * 60 + $booking['length'] * 60);
			
		return $booking_data;
	}
	
	static public function getMultiService($booking, $option_arr)
	{
		//  Before and after time is not included in booking time
		$booking_data = array();
		if (isset($booking['bs_arr']))
		{
			foreach ($booking['bs_arr'] as $item)
			{
				$booking_data[] = stripslashes($item['service_name']) . ":\n".
					date($option_arr['o_date_format'], strtotime($item['date'])). "\n".
					date($option_arr['o_time_format'], $item['start_ts'] + $item['before'] * 60). " - ".
					date($option_arr['o_time_format'], $item['start_ts'] + $item['before'] * 60 + $item['length'] * 60);
			}
		}

		return join("\n\n", $booking_data);
	}
	
	static public function getTokens($booking, $option_arr, $type='single')
	{
		switch ($type)
		{
			case 'single':
				$booking_data = pjAppController::getSingleService($booking, $option_arr);
				break;
			case 'multi':
			default:
				$booking_data = pjAppController::getMultiService($booking, $option_arr);
				break;
		}

		$cc = $booking['payment_method'] == 'creditcard';
		$cancelURL = PJ_INSTALL_URL . 'index.php?controller=pjFrontEnd&action=pjActionCancel&cid='.$booking['calendar_id'].'&id='.$booking['booking_id'].'&hash='.sha1($booking['booking_id'].$booking['created'].PJ_SALT);

		$payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentTitles(1, $booking['locale_id']): __('payment_methods',true);
		
		$search = array(
			'{Name}', '{Email}', '{Phone}', '{Country}', '{City}',
			'{State}', '{Zip}', '{Address1}', '{Address2}', '{Notes}',
			'{CCType}', '{CCNum}', '{CCExpMonth}', '{CCExpYear}', '{CCSec}', '{PaymentMethod}',
			'{Price}', '{Deposit}', '{Total}', '{Tax}',
			'{BookingID}', '{Services}', '{CancelURL}'
		);
		$replace = array(
			pjSanitize::clean(@$booking['c_name']), pjSanitize::clean(@$booking['c_email']), pjSanitize::clean(@$booking['c_phone']), pjSanitize::clean(@$booking['country_name']), pjSanitize::clean(@$booking['c_city']),
			pjSanitize::clean(@$booking['c_state']), pjSanitize::clean(@$booking['c_zip']), pjSanitize::clean(@$booking['c_address_1']), pjSanitize::clean(@$booking['c_address_2']), @$booking['c_notes'],
			$cc ? $booking['cc_type'] : NULL,
			$cc ? $booking['cc_num'] : NULL,
			$cc ? $booking['cc_exp_month'] : NULL,
			$cc ? $booking['cc_exp_year'] : NULL,
			$cc ? $booking['cc_code'] : NULL,
			@$payment_methods[$booking['payment_method']],
			pjCurrency::formatPrice($booking['booking_price']),
			pjCurrency::formatPrice($booking['booking_deposit']),
			pjCurrency::formatPrice($booking['booking_total']),
			pjCurrency::formatPrice($booking['booking_tax']),
			$booking['uuid'], $booking_data, '<a href="'.$cancelURL.'">'.$cancelURL.'</a>');
		
		return compact('search', 'replace');
	}
	
	static public function getWTimePerEmployee($employee_id, $cid, $option_arr, $date = NULL)
	{
		if($date == NULL)
		{
			$date = date('Y-m-d');
		}
		$bs_arr = pjBookingServiceModel::factory()
			->join('pjBooking', sprintf("t1.booking_id=t2.id AND (t2.booking_status='confirmed' OR (t2.booking_status='pending' AND UNIX_TIMESTAMP(t2.created) >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL %u MINUTE)) ) )", $option_arr['o_pending_time']), 'inner')
			->where('t1.employee_id', $employee_id)
			->where('t1.date', $date)
			->findAll()
			->getData();
		
		$t_arr = pjAppController::getRawSlotsPerEmployee($employee_id, $date, $cid);
		return compact('t_arr', 'bs_arr');
	}
	
	static public function getAppointmentInfo($employee_id, $service_id, $cid, $date, $locale_id, $option_arr)
	{
		$employee = pjEmployeeModel::factory()
			->select("t1.*, t2.content AS `name`")
			->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$locale_id."'", 'left outer')
			->where('t1.calendar_id', $cid)
			->find($employee_id)
			->getData();
		
		$service = pjServiceModel::factory()
			->select("t1.*, t2.content AS `name`, t3.content AS `description`")
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.locale='".$locale_id."' AND t2.field='name'", 'left outer')
			->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.locale='".$locale_id."' AND t3.field='description'", 'left outer')
			->where('t1.calendar_id', $cid)
			->where('t1.is_active', 1)
			->orderBy('`name` ASC')
			->find($service_id)
			->getData();
		
		$wt_arr = pjAppController::getWTimePerEmployee($employee_id, $cid, $option_arr, $date);
		$employee['t_arr'] = $wt_arr['t_arr'];
		$employee['bs_arr'] = $wt_arr['bs_arr'];
			
		return compact('employee', 'service');
	}
	
	static public function getFromEmail()
	{
		$arr = pjAuthUserModel::factory()
			->findAll()
			->orderBy("t1.id ASC")
			->limit(1)
			->getData();
		return !empty($arr) ? $arr[0]['email'] : null;
	}
	
	static public function getAdminEmail()
	{
		$arr = pjAuthUserModel::factory()
				->where('t1.role_id', '1')
				->where('t1.status', 'T')
				->findAll()
				->getDataPair('id', 'email');
		return $arr;
	}
	
	public static function getDaysInMonth($month, $year, $option_arr)
	{
		$d_arr = array();
		$daysInMonth = cal_days_in_month(CAL_GREGORIAN, $month, $year);
		$_date = getdate(mktime(12, 0, 0, $month, 1, $year));
		$first = $_date["wday"];
		$day = (int)$option_arr['o_week_start'] + 1 - $first;
		while ($day > 1)
		{
			$day -= 7;
		}
		while ($day <= $daysInMonth)
		{
			$timestamp = mktime(0, 0, 0, $month, $day, $year);
			$d_arr[] = date('Y-m-d', $timestamp);
			$day++;
		}
		$row_arr = array_chunk($d_arr, 7);
		$last_row = end($row_arr);
		while(count($last_row) < 7)
		{
			$last_date = end($last_row);
			$extra_date = date('Y-m-d', strtotime($last_date) + 86400);
			$last_row[] = $extra_date;
			$d_arr[] = $extra_date;
		}
		return $d_arr;
	}
	
	public static function getDateTimes($date, $type, $option_arr, $locale_id, $foreign_id, $id = null)
	{
		$d_arr = array();
		$date_arr = array();
		if($type == 'weekly')
		{
			$week_arr = pjUtil::getWeekRange($date, $option_arr['o_week_start']);
			foreach (range(0,6) as $i)
			{
				$d_arr[] = date("Y-m-d", strtotime($week_arr[0]) + 86400 * $i);
			}
			$date_arr = pjDateModel::factory()->getWorkingTime($foreign_id, $week_arr[0], 7);
		}else if($type == 'monthly'){
			$date_ts = strtotime($date);
			$month = date('n', $date_ts);
			$year = date('Y', $date_ts);
			$d_arr = pjAppController::getDaysInMonth($month, $year, $option_arr);
			$first_date = reset($d_arr);
			$date_arr = pjDateModel::factory()->getWorkingTime($foreign_id, $first_date, count($d_arr));
		}else if($type == 'array'){
			$d_arr = $date;
			$date_arr = pjDateModel::factory()->getWorkingTime($foreign_id, $d_arr, 0);
		}
		$pjWorkingTimeModel = pjWorkingTimeModel::factory();
		if($foreign_id == 1)
		{
            $wt_data = $pjWorkingTimeModel->getWorkingTime($foreign_id);
		}else{
		    $wt_data = $pjWorkingTimeModel->getWorkingTime($foreign_id, 'employee');
		}
		if($id != null)
		{
			$wt_arr = pjServiceModel::factory()->find($id)->getData();
			if($wt_arr['custom_time'] == 'T')
			{
				$wt_data = $wt_arr;
			}
		}

		$t_arr = array();
		
		foreach ($date_arr as $date => $item)
		{
			$t_arr[$date] = $pjWorkingTimeModel->filterDate($wt_data, $date, $item);
		}
		$pjBookingServiceModel = pjBookingServiceModel::factory();
		$pjBookingServiceModel
					->select("t1.*, t2.*, t3.*, t4.content as service_name")
					->join('pjBooking', sprintf("t1.booking_id=t2.id AND (t2.booking_status='confirmed' OR (t2.booking_status='pending' AND UNIX_TIMESTAMP(t2.created) >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL %u MINUTE)) ) )", $option_arr['o_pending_time']), 'inner')
					->join('pjService', "t3.id=t1.service_id", 'inner')
					->join('pjMultiLang', sprintf("t4.foreign_id = t3.id AND t4.model = 'pjService' AND t4.locale = '%u' AND t4.field = 'name'", $locale_id), 'left')
					->whereIn('t1.date', $d_arr)
					->where('t2.booking_status !=', 'cancelled');
		if($foreign_id != 1)
		{
		    $pjBookingServiceModel->where('employee_id', $foreign_id);
		}
		$bs_arr = $pjBookingServiceModel->orderBy("t1.date ASC, t1.start_ts ASC")->findAll()->getData();
		$b_arr = array();
		foreach($bs_arr as $k => $v)
		{
			$v['end_ts'] = $v['start_ts'] + $v['total'] * 60;
			$b_arr[$v['start_ts']][] = $v;
		}

		ksort($b_arr);
		$booking_arr = array();
		foreach($b_arr as $k => $v)
		{
			foreach($v as $_v) {
				$_v['start_time'] = date('H:i', $_v['start_ts']);
				$_v['end_time'] = date('H:i', $_v['start_ts'] + $_v['total'] * 60);
				$hash = sha1($_v['booking_id'] . $_v['start_ts'] . $_v['created']);
				$booking_arr[$_v['date']][$hash] = $_v;
			}
		}
		
		$avail_arr = array();
		foreach ($date_arr as $date => $item)
		{
			$avail_arr[$date] = $pjWorkingTimeModel->getAvailableSlots($date, $t_arr[$date], isset($booking_arr[$date]) ? $booking_arr[$date] : array());
		}
		
		return compact('d_arr', 't_arr', 'avail_arr', 'booking_arr', 'wtime_from');
	}
}
?>