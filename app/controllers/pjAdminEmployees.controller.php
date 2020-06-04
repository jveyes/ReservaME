<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminEmployees extends pjAdmin
{
	public function pjActionCheckEmail()
	{
		$this->setAjax(true);
	
		if ($this->isXHR() && $this->isLoged())
		{
			if (!$this->_get->check('email') || $this->_get->toString('email') == '')
			{
				echo 'false';
				exit;
			}
			$pjEmployeeModel = pjEmployeeModel::factory()->where('t1.email', $this->_get->toString('email'));
			if ($this->isEmployee())
			{
				$pjEmployeeModel->where('t1.id !=', $this->getUserId());
			} elseif ($this->_get->check('id') && $this->_get->toInt('id') > 0) {
				$pjEmployeeModel->where('t1.id !=', $this->_get->toInt('id'));
			}

			echo $pjEmployeeModel->findCount()->getData() == 0 ? 'true' : 'false';
		}
		exit;
	}
	
	public function pjActionCreate()
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
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEmployees&action=pjActionIndex&err=AE12");
		}
		
		if (self::isPost() && $this->_post->toInt('employee_create'))
		{
			$err = 'AE03';
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$data['role_id'] = 3;
			$data['is_subscribed'] = $this->_post->check('is_subscribed') ? 1 : 0;
			$data['is_subscribed_sms'] = $this->_post->check('is_subscribed_sms') ? 1 : 0;
			$data['is_active'] = $this->_post->check('is_active') ? 'T' : 'F';
			
			$id = pjEmployeeModel::factory(array_merge($this->_post->raw(),$data))->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if (isset($_FILES['avatar']))
				{
					if($_FILES['avatar']['error'] == 0)
					{
						$size = getimagesize($_FILES['avatar']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['avatar']))
							{
								$dst = PJ_UPLOAD_PATH . 'employees/' . md5($id . PJ_SALT) . ".jpg";
								$pjImage
								->loadImage()
								->resizeSmart(150, 170)
								->saveImage($dst);
				
								pjEmployeeModel::factory()->set('id', $id)->modify(array('avatar' => $dst));
							}
						}else{
							$err = 'AE14';
						}
					}else if($_FILES['avatar']['error'] != 4){
						$err = 'AE13';
					}
				}
				
				if ($this->_post->toArray('service_id') && $this->_post->toArray('service_id') != '')
				{
					$pjEmployeeServiceModel = pjEmployeeServiceModel::factory()->setBatchFields(array('employee_id', 'service_id'));
					foreach ($this->_post->toArray('service_id') as $service_id)
					{
						$pjEmployeeServiceModel->addBatchRow(array($id, $service_id));
					}
					$pjEmployeeServiceModel->insertBatch();
				}
				
				pjWorkingTimeModel::factory()->initFrom($this->getForeignId(), $id);
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $id, 'pjEmployee');
				}
			} else {
				$err = 'AE04';
			}
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEmployees&action=pjActionIndex&err=$err");
		}
		
		if (self::isGet())
		{
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
			
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
			
			$this->set('service_arr', pjServiceModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->orderBy('`name` ASC')
				->findAll()
				->getData()
			);
			
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminEmployees.js');
		}
	}
	
	public function pjActionDeleteAvatar()
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
		
		$id = NULL;
		if ($this->isEmployee())
		{
			$id = $this->getUserId();
		} elseif ($this->_post->check('id') && $this->_post->toInt('id') > 0) {
			$id = $this->_post->toInt('id');
		}
		
		if (!is_null($id))
		{
			$pjEmployeeModel = pjEmployeeModel::factory();
			$arr = $pjEmployeeModel->find($id)->getData();
			if (!empty($arr))
			{
				$pjEmployeeModel->modify(array('avatar' => ':NULL'));
				
				@clearstatcache();
				if (!empty($arr['avatar']) && is_file($arr['avatar']))
				{
					@unlink($arr['avatar']);
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionDeleteEmployee()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		
		if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$pjEmployeeModel = pjEmployeeModel::factory();
			$arr = $pjEmployeeModel->find($this->_get->toInt('id'))->getData();
			if (!empty($arr) && $pjEmployeeModel->set('id', $arr['id'])->erase()->getAffectedRows() == 1)
			{
				pjMultiLangModel::factory()->where('model', 'pjEmployee')->where('foreign_id', $arr['id'])->eraseAll();
				pjEmployeeServiceModel::factory()->where('employee_id', $arr['id'])->eraseAll();
				pjWorkingTimeModel::factory()->where('foreign_id', $arr['id'])->where('`type`', 'employee')->limit(1)->eraseAll();
				pjDateModel::factory()->where('foreign_id', $arr['id'])->where('`type`', 'employee')->eraseAll();

				if (!empty($arr['avatar']) && is_file($arr['avatar']))
				{
					@unlink($arr['avatar']);
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Employee have been deleted.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Employee not found.'));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 104, 'text' => 'Missing, empty or invalid parameters.'));
	}
	
	public function pjActionDeleteEmployeeBulk()
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
			$pjEmployeeModel = pjEmployeeModel::factory();
			$arr = pjEmployeeModel::factory()->whereIn('id', $record)->findAll()->getData();
			if (!empty($arr))
			{
				$pjEmployeeModel->reset()->whereIn('id', $record)->eraseAll();
				pjMultiLangModel::factory()->where('model', 'pjEmployee')->whereIn('foreign_id', $record)->eraseAll();
				pjEmployeeServiceModel::factory()->whereIn('employee_id', $record)->eraseAll();
				pjWorkingTimeModel::factory()->whereIn('foreign_id', $record)->where('`type`', 'employee')->eraseAll();
				pjDateModel::factory()->whereIn('foreign_id', $record)->where('`type`', 'employee')->eraseAll();
				
				foreach ($arr as $employee)
				{
					if (!empty($employee['avatar']) && is_file($employee['avatar']))
					{
						@unlink($employee['avatar']);
					}
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Employee(s) have been deleted.'));
			}
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Employee(s) not found.'));
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing, empty or invalid parameters.'));
	}
	
	public function pjActionGetEmployee()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		if (!pjAuth::factory('pjAdminEmployees')->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$pjEmployeeModel = pjEmployeeModel::factory()
			->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.calendar_id', $this->getForeignId());
		
		if ($q = $this->_get->toString('q'))
		{
			$q = str_replace(array('%', '_'), array('\%', '\_'), trim($q));
			$pjEmployeeModel->where(sprintf("t2.content LIKE '%1\$s' OR t1.email LIKE '%1\$s' OR t1.phone LIKE '%1\$s' OR t1.notes LIKE '%1\$s'", "%$q%"));
		}
		if ($this->_get->toInt('service_id') > 0)
		{
		    $pjEmployeeModel->where(sprintf("(t1.id IN(SELECT `TES`.employee_id FROM `%s` AS `TES` WHERE `TES`.service_id=%u))", pjEmployeeServiceModel::factory()->getTable(), $this->_get->toInt('service_id')));
		}
		if ($this->_get->check('is_active') && in_array($this->_get->toString('is_active'), array('T', 'F')))
		{
			$pjEmployeeModel->where('t1.is_active', $this->_get->toString('is_active'));
		}

		$column = 'name';
		$direction = 'ASC';
		if ($this->_get->toString('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}
		
		$total = $pjEmployeeModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjEmployeeModel
			->select(sprintf("t1.id, t1.email, t1.phone, t1.avatar, t1.is_active, t2.content AS `name`,
				(SELECT COUNT(es.id)
					FROM `%1\$s` AS `es`
					INNER JOIN `%2\$s` AS `s` ON `s`.`id` = `es`.`service_id`
					WHERE `es`.`employee_id` = `t1`.`id` AND `s`.`is_active`='1'
					LIMIT 1) AS `services`
				", pjEmployeeServiceModel::factory()->getTable(), pjServiceModel::factory()->getTable()))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		$data = pjSanitize::clean($data);

		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionIndex()
	{
		$this->checkLogin();
		
		if (!pjAuth::factory('pjAdminEmployees')->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminEmployees.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminEmployees', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminEmployees', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminEmployees', 'pjActionDeleteEmployee')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminEmployees', 'pjActionDeleteEmployeeBulk')->hasAccess());
	}
	
	public function pjActionSaveEmployee()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
		if (!pjAuth::factory('pjAdminEmployees', 'pjActionUpdate')->hasAccess())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => 'Access denied.'));
		}
		
		$params = array(
				'id' => $this->_get->toInt('id'),
				'column' => $this->_post->toString('column'),
				'value' => $this->_post->toString('value'),
		);
		if (!(isset($params['id'], $params['column'], $params['value'])
				&& pjValidation::pjActionNumeric($params['id'])
				&& pjValidation::pjActionNotEmpty($params['column'])))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Missing, empty or invalid parameters.'));
		}
		
		$pjEmployeeModel = pjEmployeeModel::factory();
		if (!in_array($params['column'], $pjEmployeeModel->getI18n()))
		{
			$pjEmployeeModel->set('id', $params['id'])->modify(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjEmployee', 'data');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
	
	public function pjActionUpdate()
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
			$err = 'AE01';
			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$data['role_id'] = 3;
			$data['is_subscribed'] = $this->_post->check('is_subscribed') ? 1 : 0;
			$data['is_subscribed_sms'] = $this->_post->check('is_subscribed_sms') ? 1 : 0;
			$data['is_active'] = $this->_post->check('is_active') ? 'T' : 'F';
			
			if (isset($_FILES['avatar']))
			{
				if($_FILES['avatar']['error'] == 0)
				{
					$size = getimagesize($_FILES['avatar']['tmp_name']);
			
					if($size == true)
					{
						$pjEmployeeModel = pjEmployeeModel::factory();
						$arr = $pjEmployeeModel->find($this->_post->toInt('id'))->getData();
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
							$data['avatar'] = PJ_UPLOAD_PATH . 'employees/' . md5($this->_post->toInt('id') . PJ_SALT) . ".jpg";
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
			
			pjEmployeeModel::factory()->set('id', $this->_post->toInt('id'))->modify(array_merge($this->_post->raw(),$data));

			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->_post->toInt('id'), 'pjEmployee');
			}
			
			$pjEmployeeServiceModel = pjEmployeeServiceModel::factory();
			$pjEmployeeServiceModel->where('employee_id', $this->_post->toInt('id'))->eraseAll();
			if ($this->_post->check('service_id') && $this->_post->toInt('service_id') != 0)
			{
				$pjEmployeeServiceModel->reset()->setBatchFields(array('employee_id', 'service_id'));
				foreach ($this->_post->toArray('service_id') as $service_id)
				{
					$pjEmployeeServiceModel->addBatchRow(array($this->_post->toInt('id'), $service_id));
				}
				$pjEmployeeServiceModel->insertBatch();
			}
			if($err == 'AE01')
			{
				pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminEmployees&action=pjActionIndex&err=AE01");
			}else{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminEmployees&action=pjActionUpdate&id=".$this->_post->toInt('id')."&err=$err");
			}
		} 
		
		if (self::isGet())
		{
			$arr = pjEmployeeModel::factory()->find($this->_get->toInt('id'))->getData();
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
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminEmployees.js');
		}
	}
	
	public function pjActionTime()
	{
		$this->checkLogin();
	
		if (self::isGet())
		{
			if ($this->isAdmin() || $this->isEditor())
			{
				$foreign_id = $this->getForeignId();
				$type = 'calendar';
				if ($this->_get->check('foreign_id') && $this->_get->toInt('foreign_id') > 0)
				{
					$foreign_id = $this->_get->toInt('foreign_id');
				}
				if ($this->_get->check('type'))
				{
					$type = $this->_get->toString('type');
				}
			} elseif ($this->isEmployee()) {
				$foreign_id = $this->getUserId();
				$type = 'employee';
			}
			 
			$wt_arr = pjWorkingTimeModel::factory()
			->where('t1.foreign_id', $foreign_id)
			->where('t1.type', $type)
			->limit(1)
			->findAll()
			->getDataIndex(0);
	
			$this->set('wt_arr', $wt_arr);
	
			$this->appendCss('bootstrap-chosen.css', PJ_THIRD_PARTY_PATH . 'chosen/');
			$this->appendJs('chosen.jquery.js', PJ_THIRD_PARTY_PATH . 'chosen/');
			$this->appendCss('clockpicker.css', PJ_THIRD_PARTY_PATH . 'clockpicker/');
			$this->appendJs('clockpicker.js');
			$this->appendCss('datepicker3.css', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('bootstrap-datepicker.js', PJ_THIRD_PARTY_PATH . 'bootstrap_datepicker/');
			$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('pjAdminEmployees.js');
		}
	}
	
	public function pjActionSetTime()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
	
		if (!($this->_post->check('week_day') && is_array($this->_post->toArray('week_day')) && is_array($this->_post->toArray('week_day')) &&
				$this->_post->check('from_time') && pjValidation::pjActionNotEmpty($this->_post->toString('from_time')) &&
				$this->_post->check('to_time') && pjValidation::pjActionNotEmpty($this->_post->toString('to_time'))))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
		}
	
		$start_time_ts = strtotime($this->_post->toString('from_time'));
		$end_time_ts = strtotime($this->_post->toString('to_time'));
	
		if($end_time_ts <= $start_time_ts)
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('invalid_selected_time', true)));
		}
	
		$lunch_from_time = $this->_post->toString('lunch_from_time');
		$lunch_to_time = $this->_post->toString('lunch_to_time');
	
		if (!empty($lunch_from_time) && !empty($lunch_to_time)) {
			$lunch_start_time_ts = strtotime($lunch_from_time);
			$lunch_end_time_ts = strtotime($lunch_to_time);
				
			if($lunch_end_time_ts <= $lunch_start_time_ts)
			{
				self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('invalid_lunch_selected_time', true)));
			}
				
			if ($lunch_start_time_ts < $start_time_ts || $lunch_start_time_ts > $end_time_ts || $lunch_end_time_ts < $start_time_ts || $lunch_end_time_ts > $end_time_ts) {
				self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('invalid_lunch_time', true)));
			}
		}
	
		$code = 200;
		if($this->_post->check('from') && is_array($this->_post->toArray('from')))
		{
			$days = __('days', true);
			foreach($this->_post->toArray('from') as $weekday => $time_arr)
			{
				foreach($time_arr as $index => $_stime)
				{
					$stime = strtotime($_stime);
					$to = $this->_post->toArray('to');
					$etime = strtotime($to[$weekday][$index]);
					if(in_array($weekday, $this->_post->toArray('week_day')))
					{
						$code = '201';
						break;
					}
				}
			}
		}
	
		$this->set('code', $code);
	}
	
	public function pjActionSaveTime()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
	
		if($this->_post->check('working_time') && $this->_post->check('from') && is_array($this->_post->toArray('from')))
		{
			$wdays = array(1 => 'monday', 2 => 'tuesday', 3 => 'wednesday', 4 => 'thursday', 5 => 'friday', 6 => 'saturday', 0 => 'sunday');
			$data = array();
			if ($this->isAdmin() || $this->isEditor())
			{
				$foreign_id = $this->getForeignId();
				$type = 'calendar';
				if ($this->_post->check('foreign_id') && $this->_post->toInt('foreign_id') > 0)
				{
					$foreign_id = $this->_post->toInt('foreign_id');
				}
				if ($this->_post->check('type'))
				{
					$type = $this->_post->toString('type');
				}
			} elseif ($this->isEmployee()) {
				$foreign_id = $this->getUserId();
				$type = 'employee';
			}
			$data['foreign_id'] = $foreign_id;
			$data['type'] = $type;
			foreach($wdays as $wday_index => $week_day)
			{
				$from = $this->_post->toArray('from');
				$to = $this->_post->toArray('to');
				$_from = ':NULL';
				$_to = ':NULL';
				if(isset($from[$wday_index]) && is_array($from[$wday_index]) && !empty($from[$wday_index]))
				{
					foreach($from[$wday_index] as $index => $_stime)
					{
						$_from = date('H:i:00', strtotime($_stime));
						$_to = date('H:i:00', strtotime($to[$wday_index][$index]));
					}
				}
	
				$lunch_from = $this->_post->toArray('lunch_from');
				$lunch_to = $this->_post->toArray('lunch_to');
				$_lunch_from = ':NULL';
				$_lunch_to = ':NULL';
				if(isset($lunch_from[$wday_index]) && is_array($lunch_from[$wday_index]) && !empty($lunch_from[$wday_index]))
				{
					foreach($lunch_from[$wday_index] as $index => $_stime)
					{
						if (!empty($_stime) && !empty($lunch_to[$wday_index][$index])) {
							$_lunch_from = date('H:i:00', strtotime($_stime));
							$_lunch_to = date('H:i:00', strtotime($lunch_to[$wday_index][$index]));
						}
					}
				}
	
				if ($_from == ':NULL' && $_lunch_from != ':NULL') {
					$_lunch_from = ':NULL';
					$_lunch_to = ':NULL';
				}
	
				if ($_from == ':NULL') {
					$data[$week_day . '_dayoff'] = 'T';
				} else {
					$data[$week_day . '_dayoff'] = 'F';
				}
	
				$data[$week_day . '_from'] = $_from;
				$data[$week_day . '_to'] = $_to;
				$data[$week_day . '_lunch_from'] = $_lunch_from;
				$data[$week_day . '_lunch_to'] = $_lunch_to;
			}
				
			$pjWorkingTimeModel = pjWorkingTimeModel::factory();
			$wt_arr = $pjWorkingTimeModel
			->where('t1.foreign_id', $foreign_id)
			->where('t1.type', $type)
			->limit(1)
			->findAll()
			->getDataIndex(0);
	
			if(!empty($wt_arr))
			{
				$pjWorkingTimeModel->reset()->where('id', $wt_arr['id'])->limit(1)->modifyAll($data);
			} else {
				$pjWorkingTimeModel->reset()->setAttributes($data)->insert();
			}
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}else{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
		}
	}
	
	public function pjActionGetDayOff()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		$pjDateModel = pjDateModel::factory();
	
		if ($this->isAdmin() || $this->isEditor())
		{
			$foreign_id = $this->getForeignId();
			$type = 'calendar';
			if ($this->_get->check('foreign_id') && $this->_get->toInt('foreign_id') > 0)
			{
				$foreign_id = $this->_get->toInt('foreign_id');
			}
			if ($this->_get->check('type'))
			{
				$type = $this->_get->toString('type');
			}
		} elseif ($this->isEmployee()) {
			$foreign_id = $this->getUserId();
			$type = 'employee';
		}
	
		$pjDateModel->where('t1.foreign_id', $foreign_id)->where('t1.type', $type);
	
		$column = 'from_date';
		$direction = 'DESC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}
	
		$total = $pjDateModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}
	
		$data = $pjDateModel
		->select('t1.*, t1.from_date as dates')
		->orderBy("$column $direction")
		->limit($rowCount, $offset)
		->findAll()
		->getData();
	
		$yesno = __('_yesno', true);
		foreach($data as $k => $v)
		{
			$v['hour'] = __('all_day', true);
			if(!empty($v['start_time']) && !empty($v['end_time']))
			{
				$v['hour'] = date($this->option_arr['o_time_format'], strtotime($v['start_time'])) . ' - ' . date($this->option_arr['o_time_format'], strtotime($v['end_time']));
			} else if(!empty($v['start_time']) && empty($v['end_time'])) {
				$v['hour'] = __('from', true) . ' '. date($this->option_arr['o_time_format'], strtotime($v['start_time']));
			} else if(empty($v['start_time']) && !empty($v['end_time'])) {
				$v['hour'] = __('to', true) . ' '. date($this->option_arr['o_time_format'], strtotime($v['end_time']));
			}
	
			$v['lunch'] = '';
			if(!empty($v['start_lunch']) && !empty($v['end_lunch']))
			{
				$v['lunch'] = date($this->option_arr['o_time_format'], strtotime($v['start_lunch'])) . ' - ' . date($this->option_arr['o_time_format'], strtotime($v['end_lunch']));
			} else if(!empty($v['start_lunch']) && empty($v['end_lunch'])) {
				$v['lunch'] = __('from', true) . ' '. date($this->option_arr['o_time_format'], strtotime($v['start_lunch']));
			} else if(empty($v['start_lunch']) && !empty($v['end_lunch'])) {
				$v['lunch'] = __('to', true) . ' '. date($this->option_arr['o_time_format'], strtotime($v['end_lunch']));
			}
				
			$v['dates'] = date($this->option_arr['o_date_format'], strtotime($v['from_date']));
			if(!empty($v['from_date']) && !empty($v['to_date']) && $v['from_date'] != $v['to_date'])
			{
				$v['dates'] = __('from', true) . ' ' . date($this->option_arr['o_date_format'], strtotime($v['from_date'])) . ' '.  __('to', true) . ' '. date($this->option_arr['o_date_format'], strtotime($v['to_date']));
			}
			$v['is_dayoff'] = $yesno[$v['is_dayoff']];
			$data[$k] = $v;
		}
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionCheckDayOff()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
	
		if (!($this->_post->check('from_date') && $this->_post->toString('from_date') != ''))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
		}
	
		if ($this->isAdmin() || $this->isEditor())
		{
			$foreign_id = $this->getForeignId();
			$type = 'calendar';
			if ($this->_post->check('foreign_id') && $this->_post->toInt('foreign_id') > 0)
			{
				$foreign_id = $this->_post->toInt('foreign_id');
			}
			if ($this->_post->check('type'))
			{
				$type = $this->_post->toString('type');
			}
		} else if ($this->isEmployee()) {
			$foreign_id = $this->getUserId();
			$type = 'employee';
		}
		 
		$from_date = pjDateTime::formatDate($this->_post->toString('from_date'), $this->option_arr['o_date_format']);
		$to_date = pjDateTime::formatDate($this->_post->toString('to_date'), $this->option_arr['o_date_format']);
	
		if(strtotime($from_date) > strtotime($to_date))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('invalid_dates_off', true)));
		}
	
		if (!$this->_post->check('is_dayoff'))
		{
			$start_time = $this->_post->toString('start_time');
			$end_time = $this->_post->toString('end_time');
				
			if(!empty($start_time) && !empty($end_time))
			{
				$start_time_ts = strtotime($start_time);
				$end_time_ts = strtotime($end_time);
				 
				if($end_time_ts <= $start_time_ts)
				{
					self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => __('invalid_day_off_time', true)));
				}
			}
			 
			$start_lunch = $this->_post->toString('start_lunch');
			$end_lunch = $this->_post->toString('end_lunch');
				
			if(!empty($start_lunch) && !empty($start_lunch))
			{
				$start_lunch_ts = strtotime($start_lunch);
				$end_lunch_ts = strtotime($end_lunch);
				 
				if($end_lunch_ts <= $start_lunch_ts)
				{
					self::jsonResponse(array('status' => 'ERR', 'code' => 103, 'text' => __('invalid_lunch_selected_time', true)));
				}
	
				if(!empty($start_time) && !empty($end_time))
				{
					if ($start_lunch_ts < $start_time_ts || $start_lunch_ts > $end_time_ts || $end_lunch_ts < $start_time_ts || $end_lunch_ts > $end_time_ts) {
						self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => __('invalid_lunch_time', true)));
					}
				}
			}
		}
		 
		$pjDateModel = pjDateModel::factory()
		->where('foreign_id', $foreign_id)
		->where('type', $type)
		->where("((`from_date` BETWEEN '$from_date' AND '$to_date') OR (`to_date` BETWEEN '$from_date' AND '$to_date') OR (`from_date` < '$from_date' AND `to_date` > '$to_date') OR (`from_date` > '$from_date' AND `to_date` < '$to_date'))");
	
		if ($this->_post->check('id') && $this->_post->toInt('id') > 0) {
			$pjDateModel->where('id !=', $this->_post->toInt('id'));
		}
	
		$cnt = $pjDateModel->findCount()->getData();
		 
		if ($cnt > 0) {
			self::jsonResponse(array('status' => 'OK', 'code' => 201, 'text' => ''));
		} else {
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
		}
	}
	
	public function pjActionSetDayOff()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isPost())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'HTTP method not allowed.'));
		}
	
		$data = array();
		if ($this->isAdmin() || $this->isEditor())
		{
			$foreign_id = $this->getForeignId();
			$type = 'calendar';
			if ($this->_post->check('foreign_id') && $this->_post->toInt('foreign_id') > 0)
			{
				$foreign_id = $this->_post->toInt('foreign_id');
			}
			if ($this->_post->check('type'))
			{
				$type = $this->_post->toString('type');
			}
		} elseif ($this->isEmployee()) {
			$foreign_id = $this->getUserId();
			$type = 'employee';
		}
	
		$data['foreign_id'] = $foreign_id;
		$data['type'] = $type;
		$data['from_date'] = $from_date = pjDateTime::formatDate($this->_post->toString('from_date'), $this->option_arr['o_date_format']);
		$data['to_date'] = $to_date = pjDateTime::formatDate($this->_post->toString('to_date'), $this->option_arr['o_date_format']);
	
		$pjDateModel = pjDateModel::factory();
	
		$id = 0;
		if ($this->_post->check('id') && $this->_post->toInt('id') > 0)
		{
			$id = $this->_post->toInt('id');
		} else {
			$arr = $pjDateModel
			->where('foreign_id', $foreign_id)
			->where('type', $type)
			->where("((`from_date` BETWEEN '$from_date' AND '$to_date') OR (`to_date` BETWEEN '$from_date' AND '$to_date') OR (`from_date` < '$from_date' AND `to_date` > '$to_date') OR (`from_date` > '$from_date' AND `to_date` < '$to_date'))")
			->limit(1)
			->findAll()
			->getData();
			if ($arr) {
				$id = $arr[0]['id'];
			}
		}
		$data['start_time'] = ':NULL';
		$data['end_time'] = ':NULL';
		$data['start_lunch'] = ':NULL';
		$data['end_lunch'] = ':NULL';
		$data['is_dayoff'] = $this->_post->check('is_dayoff') ? 'T' : 'F';
		$data['all_day'] = 'T';
	
		if (!$this->_post->check('is_dayoff'))
		{
			$start_time = $this->_post->toString('start_time');
			$end_time = $this->_post->toString('end_time');
				
			if(!empty($start_time) && !empty($end_time))
			{
				$start_time_ts = strtotime($start_time);
				$end_time_ts = strtotime($end_time);
				 
				$data['start_time'] = date('H:i', $start_time_ts);
				$data['end_time'] = date('H:i', $end_time_ts);
				$data['all_day'] = 'F';
			}
			 
			$start_lunch = $this->_post->toString('start_lunch');
			$end_lunch = $this->_post->toString('end_lunch');
				
			if(!empty($start_lunch) && !empty($start_lunch))
			{
				$start_lunch_ts = strtotime($start_lunch);
				$end_lunch_ts = strtotime($end_lunch);
				 
				$data['start_lunch'] = date('H:i', $start_lunch_ts);
				$data['end_lunch'] = date('H:i', $end_lunch_ts);
			}
		}
	
		if($id > 0)
		{
			$pjDateModel->reset()->where('id', $id)->limit(1)->modifyAll($data);
		} else {
			$pjDateModel->reset()->setAttributes($data)->insert();
		}
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => '', 'data' => $data));
	}
	
	public function pjActionDeleteDayOff()
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
	
		if (!($this->_get->check('id') && pjValidation::pjActionNumeric($this->_get->toInt('id'))))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
		}
	
		if (pjDateModel::factory()->setAttributes(array('id' => $this->_get->toInt('id')))->erase()->getAffectedRows() == 1)
		{
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Day off is deleted.'));
		} else {
			self::jsonResponse(array('status' => 'ERR', 'code' => 102, 'text' => 'Day off could not be deleted.'));
		}
	}
	
	public function pjActionDeleteDayOffBulk()
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
	
		if (!($this->_post->check('record') && !empty($record)))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
		}
	
		pjDateModel::factory()->whereIn('id', $record)->eraseAll();
	
		self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Day(s) off has been deleted.'));
	}
	
	public function pjActionGetUpdate()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
	
		if (!self::isGet())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'HTTP method not allowed.'));
		}
	
		if (!($this->_get->check('id') && pjValidation::pjActionNumeric($this->_get->toInt('id'))))
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 101, 'text' => 'Missing, empty or invalid parameters.'));
		}
	
		$arr = pjDateModel::factory()->find($this->_get->toInt('id'))->getData();
		$arr['from_date'] = date($this->option_arr['o_date_format'], strtotime($arr['from_date']));
		$arr['to_date'] = !empty($arr['to_date']) ? date($this->option_arr['o_date_format'], strtotime($arr['to_date'])) : '';
		$arr['start_time'] = !empty($arr['start_time']) ? date($this->option_arr['o_time_format'], strtotime($arr['start_time'])) : '';
		$arr['end_time'] = !empty($arr['end_time']) ? date($this->option_arr['o_time_format'], strtotime($arr['end_time'])) : '';
		$arr['start_lunch'] = !empty($arr['start_lunch']) ? date($this->option_arr['o_time_format'], strtotime($arr['start_lunch'])) : '';
		$arr['end_lunch'] = !empty($arr['end_lunch']) ? date($this->option_arr['o_time_format'], strtotime($arr['end_lunch'])) : '';
		self::jsonResponse($arr);
	}
}
?>