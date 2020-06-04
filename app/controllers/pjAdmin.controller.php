<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdmin extends pjAppController
{
	protected $extensions = array('gif', 'png', 'jpg', 'jpeg');
	
	protected $mimeTypes = array('image/gif', 'image/png', 'image/jpg', 'image/jpeg', 'image/pjpeg');
	
	public $defaultUser = 'admin_user';
	
	public $requireLogin = true;
	
	public function __construct($requireLogin=null)
	{
		$this->setLayout('pjActionAdmin');
		
		if (!is_null($requireLogin) && is_bool($requireLogin))
		{
			$this->requireLogin = $requireLogin;
		}
		
		if ($this->requireLogin)
		{
			if (!$this->isLoged() && $this->_get !=  null && !in_array(@$this->_get->toString('action'), array('pjActionLogin', 'pjActionForgot', 'pjActionValidate', 'pjActionExportFeed')))
			{
				if (!$this->isXHR())
				{
					pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjBase&action=pjActionLogin");
				} else {
					header('HTTP/1.1 401 Unauthorized');
					exit;
				}
			}
		}
		
		pjRegistry::getInstance()->set('inherits', array(
				'pjAdminBookings::pjActionGetBooking' => 'pjAdminBookings::pjActionIndex',
				'pjAdminBookings::pjActionSaveBooking' => 'pjAdminBookings::pjActionUpdate',
				'pjAdminBookings::pjActionCheckUID' => 'pjAdminBookings::pjActionCreate',
				'pjAdminBookings::pjActionCheckDate' => 'pjAdminBookings::pjActionCreate',
				'pjAdminBookings::pjActionConfirmation' => 'pjAdminBookings::pjActionUpdate',
				'pjAdminBookings::pjActionCancellation' => 'pjAdminBookings::pjActionUpdate',
				'pjAdminEmployees::pjActionGetEmployee' => 'pjAdminEmployees::pjActionIndex',
				'pjAdminEmployees::pjActionDeleteAvatar' => 'pjAdminEmployees::pjActionIndex',
				'pjAdminEmployees::pjActionDeleteAvatar' => 'pjAdmin::pjActionProfile',
				'pjAdminEmployees::pjActionSaveEmployee' => 'pjAdminEmployees::pjActionIndex',
				'pjAdminEmployees::pjActionSaveTime' => 'pjAdminEmployees::pjActionSetTime',
				'pjAdminEmployees::pjActionCheckDayOff' => 'pjAdminEmployees::pjActionTime',
				'pjAdminReports::pjActionGetEmployee' => 'pjAdminReports::pjActionEmployees',
				'pjAdminReports::pjActionGetService' => 'pjAdminReports::pjActionServices',
				'pjAdminReports::pjActionCheckDate' => 'pjAdminReports::pjActionServices',
				'pjAdminServices::pjActionGetService' => 'pjAdminServices::pjActionIndex',
				'pjAdminServices::pjActionDeleteImage' => 'pjAdminServices::pjActionIndex',
				'pjAdminServices::pjActionSaveService' => 'pjAdminServices::pjActionIndex',
				'pjAdminTime::pjActionSaveTime' => 'pjAdminTime::pjActionSetTime',
				'pjAdminOptions::pjActionUpdate' => 'pjAdminOptions::pjActionBooking',
				'pjAdminOptions::pjActionUpdate' => 'pjAdminOptions::pjActionBookingForm',
				'pjAdminOptions::pjActionUpdate' => 'pjAdminOptions::pjActionTerm',
				'pjAdminOptions::pjActionUpdate' => 'pjAdminOptions::pjActionNotifications',
				'pjAdminOptions::pjActionUpdate' => 'pjAdminOptions::pjActionReminder',
				'pjAdminOptions::pjActionNotificationsSetContent' => 'pjAdminOptions::pjActionNotifications',
				'pjAdminOptions::pjActionNotificationsGetContent' => 'pjAdminOptions::pjActionNotifications',
				'pjAdminOptions::pjActionNotificationsGetMetaData' => 'pjAdminOptions::pjActionNotifications',
				'pjAdminOptions::pjActionPaymentOptions' => 'pjAdminOptions::pjActionPayments'
		));
		
	}
	
	public function beforeFilter()
	{
		parent::beforeFilter();
		
		if (!pjAuth::factory()->hasAccess())
		{
			if (!$this->isXHR())
			{
				$this->sendForbidden();
				return false;
			} else {
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Access denied.'));
			}
		}
		
		return true;
	}
	
	public function afterFilter()
	{
		parent::afterFilter();
		
		if ($this->isEmployee()) {
			$arr = pjEmployeeModel::factory()
					->select('t1.*, t2.content as name')
					->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->find($this->getUserId())
					->getData();
			$_SESSION[$this->defaultUser]['name'] = $arr['name'];
		}
		
		$this->appendJs('index.php?controller=pjBase&action=pjActionMessages', PJ_INSTALL_URL, true);
	}
	
	public function beforeRender()
	{
		
	}
		
	public function setLocalesData()
    {
        $locale_arr = pjLocaleModel::factory()
            ->select('t1.*, t2.file')
            ->join('pjBaseLocaleLanguage', 't2.iso=t1.language_iso', 'left')
            ->where('t2.file IS NOT NULL')
            ->orderBy('t1.sort ASC')->findAll()->getData();

        $lp_arr = array();
        foreach ($locale_arr as $item)
        {
            $lp_arr[$item['id']."_"] = $item['file'];
        }
        $this->set('lp_arr', $locale_arr);
        $this->set('locale_str', pjAppController::jsonEncode($lp_arr));
        $this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjBaseLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
    }
	
    public function pjActionVerifyAPIKey()
    {
        $this->setAjax(true);

        if ($this->isXHR())
        {
            if (!self::isPost())
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method is not allowed.'));
            }

            $option_key = $this->_post->toString('key');
            if (!array_key_exists($option_key, $this->option_arr))
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Option cannot be found.'));
            }

            $option_value = $this->_post->toString('value');
            if(empty($option_value))
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'API key is empty.'));
            }

            $html = '';
            $isValid = false;
            switch ($option_key)
            {
                case 'o_google_maps_api_key':
                    $address = preg_replace('/\s+/', '+', $this->option_arr['o_timezone']);
                    $api_key_str = $option_value;
                    $gfile = "https://maps.googleapis.com/maps/api/geocode/json?key=".$api_key_str."&address=".$address;
                    $Http = new pjHttp();
                    $response = $Http->request($gfile)->getResponse();
                    $geoObj = pjAppController::jsonDecode($response);
                    $geoArr = (array) $geoObj;
                    if ($geoArr['status'] == 'OK')
                    {
                        $html = '<img src="' . $url . '" class="img-responsive" />';
                        $isValid = true;
                    }
                    break;
                default:
                    // API key for an unknown service. We can't verify it so we assume it's correct.
                    $isValid = true;
            }

            if ($isValid)
            {
                self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Key is correct!', 'html' => $html));
            }
            else
            {
                self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Key is not correct!', 'html' => $html));
            }
        }
        exit;
    }

    public function pjActionIndex()
	{
		$this->checkLogin();
		
		$pjBookingModel = pjBookingModel::factory();
		$pjBookingServiceModel = pjBookingServiceModel::factory();
		
		$to_date = date('Y-m-d');
		$next_7_days = date('Y-m-d', time() + 7 * 86400);
		
		if ($this->isAdmin()) {
			$cnt_confirmed = $pjBookingModel
							->where('t1.booking_status', 'confirmed')
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND (`TBS`.`date` BETWEEN '%s' AND '%s'))", $pjBookingServiceModel->getTable(), $to_date, $next_7_days))
							->findCount()->getData();
			
			$cnt_pending = $pjBookingModel
							->reset()
							->where('t1.booking_status', 'pending')
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND (`TBS`.`date` BETWEEN '%s' AND '%s'))", $pjBookingServiceModel->getTable(), $to_date, $next_7_days))
							->findCount()->getData();
			
			$cnt_bookings = $pjBookingModel
									->reset()
									->where("(MONTH(created) = MONTH(CURRENT_DATE()) AND YEAR(created) = YEAR(CURRENT_DATE()))")
									->findCount()->getData();
			
			$total_amount = $pjBookingModel
							->reset()
							->select("SUM(t1.booking_total) AS total_amount")
							->where("(MONTH(created) = MONTH(CURRENT_DATE()) AND YEAR(created) = YEAR(CURRENT_DATE()))")
							->limit(1)->findAll()->getDataIndex(0);
		} else {
			$cnt_confirmed = $pjBookingModel
							->where('t1.booking_status', 'confirmed')
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND (`TBS`.`date` BETWEEN '%s' AND '%s') AND `TBS`.`employee_id`= '%s')", $pjBookingServiceModel->getTable(), $to_date, $next_7_days, $this->getUserId()))
							->findCount()->getData();
				
			$cnt_pending = $pjBookingModel
							->reset()
							->where('t1.booking_status', 'pending')
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND (`TBS`.`date` BETWEEN '%s' AND '%s') AND `TBS`.`employee_id`= '%s')", $pjBookingServiceModel->getTable(), $to_date, $next_7_days, $this->getUserId()))
							->findCount()->getData();
				
			$cnt_bookings = $pjBookingModel
							->reset()
							->where("(MONTH(created) = MONTH(CURRENT_DATE()) AND YEAR(created) = YEAR(CURRENT_DATE()))")
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND `TBS`.`employee_id`= '%s')", $pjBookingServiceModel->getTable(), $this->getUserId()))
							->findCount()->getData();
				
			$total_amount = $pjBookingModel
							->reset()
							->select("SUM(t1.booking_total) AS total_amount")
							->where("(MONTH(created) = MONTH(CURRENT_DATE()) AND YEAR(created) = YEAR(CURRENT_DATE()))")
							->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND `TBS`.`employee_id`= '%s')", $pjBookingServiceModel->getTable(), $this->getUserId()))
							->limit(1)->findAll()->getDataIndex(0);
		}
		
		$six_months = pjUtil::getSixMonths();
		$monthly_bookings = array();
		foreach($six_months as $pair)
		{
		    $monthly_bookings[$pair['month']] = $pjBookingModel->reset()->where('YEAR(created)', $pair['year'])->where('MONTH(created)', $pair['month'])->findCount()->getData();
		}
		
		if ($this->isAdmin()) {
			$latest_bookings = $pjBookingModel
									->reset()
									->select(sprintf("t1.*,
							                (SELECT `TBS`.start_ts FROM `%s` AS `TBS` WHERE `TBS`.booking_id=t1.id ORDER BY `start_ts` ASC LIMIT 1) AS `service_start_ts`",
									    $pjBookingServiceModel->getTable()))
								    ->orderBy("created DESC")
								    ->limit(10)
								    ->findAll()
								    ->getData();
		} else {
			$latest_bookings = $pjBookingModel
								->reset()
								->select(sprintf("t1.*,
							                (SELECT `TBS`.start_ts FROM `%s` AS `TBS` WHERE `TBS`.booking_id=t1.id ORDER BY `start_ts` ASC LIMIT 1) AS `service_start_ts`",
										$pjBookingServiceModel->getTable()))
								->where(sprintf("t1.id IN (SELECT `TBS`.`booking_id` FROM `%s` AS `TBS` WHERE `TBS`.`booking_id`=t1.id AND `TBS`.`employee_id`= '%s')", $pjBookingServiceModel->getTable(), $this->getUserId()))
								->orderBy("created DESC")
								->limit(10)
								->findAll()
								->getData();
		}
	    $booking_id_arr = $pjBookingModel->findAll()->getDataPair(null, 'id');
	    $service_arr = array();
	    $package_arr = array();
	    $service_duration_arr = array();
	    $package_duration_arr = array();
	    if(!empty($booking_id_arr))
	    {
	    	if ($this->isAdmin()) {
		        $temp_service_arr = $pjBookingServiceModel
							        ->reset()
							        ->select("t1.booking_id, t1.service_id, t1.start_ts, t2.content as name, t3.total")
							        ->join('pjMultiLang', sprintf("t2.foreign_id = t1.service_id AND t2.model = 'pjService' AND t2.locale = '%u' AND t2.field = 'name'", $this->getLocaleId()), 'left')
							        ->join('pjService', 't1.service_id=t3.id', 'left')
							        ->whereIn('t1.booking_id', $booking_id_arr)
							        ->findAll()->getData();
	    	} else {
	    		$temp_service_arr = $pjBookingServiceModel
						    		->reset()
						    		->select("t1.booking_id, t1.service_id, t1.start_ts, t2.content as name, t3.total")
						    		->join('pjMultiLang', sprintf("t2.foreign_id = t1.service_id AND t2.model = 'pjService' AND t2.locale = '%u' AND t2.field = 'name'", $this->getLocaleId()), 'left')
						    		->join('pjService', 't1.service_id=t3.id', 'left')
						    		->where('t1.employee_id', $this->getUserId())
						    		->whereIn('t1.booking_id', $booking_id_arr)
						    		->findAll()->getData();
	    	}
	        foreach($temp_service_arr as $k => $v)
	        {
	            $service_arr[$v['booking_id']][] = $v['name'];
	            if(isset($service_duration_arr[$v['booking_id']]))
	            {
	                $service_duration_arr[$v['booking_id']] += (int) $v['total'];
	            }else{
	                $service_duration_arr[$v['booking_id']] = (int) $v['total'];
	            }
	        }
	    }
	    foreach($latest_bookings as $k => $v)
	    {
	        $v['service_package'] = '';
	        $v['date_time'] = '';
	        $service_package = array();
	        $duration = 0;
	        if(isset($service_arr[$v['id']]) && !empty($service_arr[$v['id']]))
	        {
	            $service_package[] = join("<br/>", $service_arr[$v['id']]);
	        }
	        if(isset($service_duration_arr[$v['id']]) && $service_duration_arr[$v['id']] > 0)
	        {
	            $duration += $service_duration_arr[$v['id']];
	        }
	        if(!empty($service_package))
	        {
	            $v['service_package'] = join("<br/>", $service_package);
	        }
	        if(!empty($v['service_start_ts']))
	        {
	            $v['date_time'] = date($this->option_arr['o_date_format'] . ', ' . $this->option_arr['o_time_format'], $v['service_start_ts']);
	        }else if($v['package_start_ts']){
	            $v['date_time'] = date($this->option_arr['o_date_format'] . ', ' . $this->option_arr['o_time_format'], $v['package_start_ts']);
	        }
	        $v['duration'] = $duration;
	        $latest_bookings[$k] = $v;
	    }
		
	    if ($this->isAdmin()) {
		    $today_service_arr = $pjBookingServiceModel
							    ->reset()
							    ->select("t1.*, t4.content as service_name, t2.c_name as client_name, t3.price as service_price, t3.total, t2.booking_status")
							    ->join('pjBooking', "t1.booking_id=t2.id", "left")
							    ->join('pjService', "t1.service_id=t3.id", "left")
							    ->join('pjMultiLang', sprintf("t4.foreign_id = t1.service_id AND t4.model = 'pjService' AND t4.locale = '%u' AND t4.field = 'name'", $this->getLocaleId()), 'left')
							    ->where("(t1.date=CURRENT_DATE())")
							    ->findAll()->getData();
	    } else {
	    	$today_service_arr = $pjBookingServiceModel
						    	->reset()
						    	->select("t1.*, t4.content as service_name, t2.c_name as client_name, t3.price as service_price, t3.total, t2.booking_status")
						    	->join('pjBooking', "t1.booking_id=t2.id", "left")
						    	->join('pjService', "t1.service_id=t3.id", "left")
						    	->join('pjMultiLang', sprintf("t4.foreign_id = t1.service_id AND t4.model = 'pjService' AND t4.locale = '%u' AND t4.field = 'name'", $this->getLocaleId()), 'left')
						    	->where('t1.employee_id', $this->getUserId())
						    	->where("(t1.date=CURRENT_DATE())")
						    	->findAll()->getData();
	    }
							    
	    $total_bookings = $pjBookingModel->reset()->findCount()->getData();
	    
		$this->set('cnt_confirmed', $cnt_confirmed);
		$this->set('cnt_pending', $cnt_pending);
		$this->set('cnt_bookings', $cnt_bookings);
		$this->set('total_amount', $total_amount);
		$this->set('monthly_bookings', $monthly_bookings);
		$this->set('latest_bookings', $latest_bookings);
		$this->set('today_service_arr', $today_service_arr);
		$this->set('total_bookings', $total_bookings);
		
		$this->appendCss('morris.min.css', PJ_THIRD_PARTY_PATH . 'morris/');
		$this->appendJs('raphael.min.js', PJ_THIRD_PARTY_PATH . 'raphael/');
		$this->appendJs('morris.min.js', PJ_THIRD_PARTY_PATH . 'morris/');
		$this->appendCss('custom.css', $this->getConst('PLUGIN_CSS_PATH'));
		$this->appendJs('pjAdmin.js');
		
		if ($this->isEmployee())
		{
			$this->appendJs('pjEmployeeBookings.js');
		}
	}
	
	public function pjActionProfile()
	{
		$this->checkLogin();
	
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
	
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEmployees&action=pjActionIndex&err=AE15");
		}
			
		if (self::isPost() && $this->_post->toInt('employee_update'))
		{
			$err = 'AA13';
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$data['role_id'] = 3;
			$data['email'] = $this->_post->toString('email');
			$data['password'] = $this->_post->toString('password');
			$data['phone'] = $this->_post->toString('phone');
			$data['notes'] = $this->_post->toString('notes');
			$data['is_subscribed'] = $this->_post->check('is_subscribed') ? 1 : 0;
			$data['is_subscribed_sms'] = $this->_post->check('is_subscribed_sms') ? 1 : 0;
				
			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				foreach($i18n_arr as $k => $v) {
					$data['name'] = $v['name'];
				}
			}
				
			if (isset($_FILES['avatar']))
			{
				if($_FILES['avatar']['error'] == 0)
				{
					$size = getimagesize($_FILES['avatar']['tmp_name']);
						
					if($size == true)
					{
						$pjEmployeeModel = pjEmployeeModel::factory();
						$arr = $pjEmployeeModel->find($this->getUserId())->getData();
						if (!empty($arr))
						{
							@clearstatcache();
							if (!empty($arr['avatar']) && is_file($arr['avatar']))
							{
								@unlink($arr['avatar']);
							}
						}
							
						$pjImage = new pjImage();
						$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
						if ($pjImage->load($_FILES['avatar']))
						{
							$data['avatar'] = PJ_UPLOAD_PATH . 'employees/' . md5($this->getUserId() . PJ_SALT) . ".jpg";
							$pjImage
							->loadImage()
							->resizeSmart(150, 170)
							->saveImage($data['avatar']);
						}
					}else{
						$err = 'AE17';
					}
				}else if($_FILES['avatar']['error'] != 4){
					$err = 'AE16';
				}
			}
				
			pjEmployeeModel::factory()->set('id', $this->getUserId())->modify($data);
	
			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->getUserId(), 'pjEmployee');
			}
				
			$pjEmployeeServiceModel = pjEmployeeServiceModel::factory();
			$pjEmployeeServiceModel->where('employee_id', $this->getUserId())->eraseAll();
			if ($this->_post->check('service_id') && $this->_post->toInt('service_id') != 0)
			{
				$pjEmployeeServiceModel->reset()->setBatchFields(array('employee_id', 'service_id'));
				foreach ($this->_post->toArray('service_id') as $service_id)
				{
					$pjEmployeeServiceModel->addBatchRow(array($this->getUserId(), $service_id));
				}
				$pjEmployeeServiceModel->insertBatch();
			}

			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdmin&action=pjActionProfile&err=$err");
		}
	
		if (self::isGet())
		{
			$arr = pjEmployeeModel::factory()->find($this->getUserId())->getData();
			if (count($arr) === 0)
			{
				pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminEmployees&action=pjActionIndex&err=AE08");
			}
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjEmployee');
			$this->set('arr', $arr);
				
			$locale_arr = pjLocaleModel::factory()->select('t1.*, t2.file')
			->join('pjLocaleLanguage', 't2.iso=t1.language_iso', 'left')
			->where('t2.file IS NOT NULL')
			->orderBy('t1.sort ASC')->findAll()->getData();
	
			$lp_arr = array();
			foreach ($locale_arr as $item)
			{
				$lp_arr[$item['id']."_"] = $item['file'];
			}
			$this->set('lp_arr', $locale_arr);
			$this->set('locale_str', self::jsonEncode($lp_arr));
			
			$this->set('employee_arr', pjEmployeeModel::factory()
					->select('t1.*, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->where('t1.is_active', 1)
					->where('t1.role_id', 3)
					->orderBy('t2.content ASC')
					->findAll()
					->getData()
					);
			$this->set('es_arr', pjEmployeeServiceModel::factory()->where('t1.service_id', $arr['id'])->findAll()->getDataPair(null, 'employee_id'));
				
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
	
			$this->set('service_arr', pjServiceModel::factory()
					->select('t1.*, t2.content AS `name`')
					->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
					->orderBy('`name` ASC')
					->findAll()
					->getData()
					)->set('es_arr', pjEmployeeServiceModel::factory()
							->where('t1.employee_id', $arr['id'])
							->findAll()
							->getDataPair('id', 'service_id'));
						
					$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
					$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
						
					$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
					$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
						
					$this->appendJs('pjAdminEmployees.js');
		}
	}
}
?>