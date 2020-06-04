<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjAdminServices extends pjAdmin
{
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
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminServices&action=pjActionIndex&err=AS12");
		}
		
		if (self::isPost() && $this->_post->toInt('service_create'))
		{
			$err = 'AS03';

			$data = array();
			$data['calendar_id'] = $this->getForeignId();
			$data['is_active'] = $this->_post->check('is_active') ? 1 : 0;
			$data['price'] = $this->_post->toFloat('price');
			$data['length_unit'] = $this->_post->toString('length_unit');
			$data['length'] = $this->_post->toInt('length');
			if ($data['length_unit'] == 'hour') {
				$data['length'] *= 60;
			}
			$data['before_unit'] = $this->_post->toString('before_unit');
			$data['before'] = $this->_post->toInt('before');
			if ($data['before_unit'] == 'hour') {
				$data['before'] *= 60;
			}
			$data['after_unit'] = $this->_post->toString('after_unit');
			$data['after'] = $this->_post->toInt('after');
			if ($data['after_unit'] == 'hour') {
				$data['after'] *= 60;
			}
			$data['total_unit'] = $data['length_unit'];
			$data['total'] = $data['length'] + $data['before'] + $data['after'];

			$id = pjServiceModel::factory($data)->insert()->getInsertId();
			if ($id !== false && (int) $id > 0)
			{
				if (isset($_FILES['image']))
				{
					if($_FILES['image']['error'] == 0)
					{
						$size = getimagesize($_FILES['image']['tmp_name']);
						if($size == true)
						{
							$pjImage = new pjImage();
							$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
							if ($pjImage->load($_FILES['image']))
							{
								$dst = PJ_UPLOAD_PATH . 'services/' . md5($id . PJ_SALT) . ".jpg";
								$pjImage
								->loadImage()
								->resizeSmart(150, 170)
								->saveImage($dst);
				
								pjServiceModel::factory()->set('id', $id)->modify(array('image' => $dst));
							}
						}else{
							$err = 'AS14';
						}
					}else if($_FILES['image']['error'] != 4){
						$err = 'AS13';
					}
				}
				
				if ($this->_post->toArray('employee_id') && $this->_post->toArray('employee_id') != '')
				{
					$pjEmployeeServiceModel = pjEmployeeServiceModel::factory()->setBatchFields(array('employee_id', 'service_id'));
					foreach ($this->_post->toArray('employee_id') as $employee_id)
					{
						$pjEmployeeServiceModel->addBatchRow(array($employee_id, $id));
					}
					$pjEmployeeServiceModel->insertBatch();
				}
				
				$i18n_arr = $this->_post->toI18n('i18n');
				if (!empty($i18n_arr))
				{
					pjMultiLangModel::factory()->saveMultiLang($i18n_arr, $id, 'pjService');
				}
			} else {
				$err = 'AS04';
			}
			
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminServices&action=pjActionIndex&err=$err");
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
			
			$this->set('employee_arr', pjEmployeeModel::factory()
				->select('t1.*, t2.content AS `name`')
				->join('pjMultiLang', "t2.model='pjEmployee' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
				->where('t1.is_active', 'T')
				->where('t1.role_id', 3)
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			
			$this->appendCss('awesome-bootstrap-checkbox.css', PJ_THIRD_PARTY_PATH . 'awesome_bootstrap_checkbox/');
			
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
			
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminServices.js');
		}
	}
	
	public function pjActionDeleteImage()
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
	
		if ($this->_post->check('id') && $this->_post->toInt('id'))
		{
			$pjServiceModel = pjServiceModel::factory();
			$arr = $pjServiceModel->find($this->_post->toInt('id'))->getData();
			if (!empty($arr))
			{
				$pjServiceModel->modify(array('image' => ':NULL'));
	
				@clearstatcache();
				if (!empty($arr['image']) && is_file($arr['image']))
				{
					@unlink($arr['image']);
				}
	
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => ''));
			}
		}
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => ''));
	}
	
	public function pjActionDeleteService()
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

		if ($this->_get->check('id') && $this->_get->toInt('id') > 0)
		{
			$pjServiceModel = pjServiceModel::factory();
			$arr = $pjServiceModel->find($this->_get->toInt('id'))->getData();
			if (!empty($arr) && $pjServiceModel->setAttributes(array('id' => $arr['id']))->erase()->getAffectedRows() == 1)
			{
				pjMultiLangModel::factory()->where('model', 'pjService')->where('foreign_id', $this->_get->toInt('id'))->eraseAll();
				pjEmployeeServiceModel::factory()->where('service_id', $this->_get->toInt('id'))->eraseAll();
	
				if (!empty($arr['image']) && is_file($arr['image']))
				{
					@unlink($arr['image']);
				}
				
				self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service has been deleted.'));
			} else {
				self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Service has not been deleted.'));
			}
		}
		
		self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing, empty or invalid parameters.'));
	}
	
	public function pjActionDeleteServiceBulk()
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
			$pjServiceModel = pjServiceModel::factory();
			$arr = $pjServiceModel->whereIn('id', $record)->findAll()->getData();
			
			$pjServiceModel->reset()->whereIn('id', $record)->eraseAll();
			pjMultiLangModel::factory()->where('model', 'pjService')->whereIn('foreign_id', $record)->eraseAll();
			pjEmployeeServiceModel::factory()->whereIn('service_id', $record)->eraseAll();
		
			foreach ($arr as $service)
			{
				if (!empty($service['image']) && is_file($service['image']))
				{
					@unlink($service['image']);
				}
			}
			
			self::jsonResponse(array('status' => 'OK', 'code' => 200, 'text' => 'Service(s) has been deleted.'));
		}
		exit;
	}
	
	public function pjActionGetService()
	{
		$this->setAjax(true);
	
		if (!$this->isXHR())
		{
			self::jsonResponse(array('status' => 'ERR', 'code' => 100, 'text' => 'Missing headers.'));
		}
		
		$pjServiceModel = pjServiceModel::factory()
			->join('pjMultiLang', "t2.model='pjService' AND t2.foreign_id=t1.id AND t2.field='name' AND t2.locale='".$this->getLocaleId()."'", 'left outer')
			->join('pjMultiLang', "t3.model='pjService' AND t3.foreign_id=t1.id AND t3.field='description' AND t3.locale='".$this->getLocaleId()."'", 'left outer')
			->where('t1.calendar_id', $this->getForeignId());
		
		$get = $this->_get->raw();
		if ($q = $this->_get->toString('q'))
		{
			$pjServiceModel->where('t2.content LIKE', "%$q%");
			$pjServiceModel->orWhere('t3.content LIKE', "%$q%");
		}

		if ($this->_get->check('is_active') && $get['is_active'] != '' && in_array($this->_get->toString('is_active'), array(0,1))) {
			$pjServiceModel->where('t1.is_active', $this->_get->toString('is_active'));
		}

		$column = 'name';
		$direction = 'ASC';
		if ($this->_get->check('column') && in_array(strtoupper($this->_get->toString('direction')), array('ASC', 'DESC')))
		{
			$column = $this->_get->toString('column');
			$direction = strtoupper($this->_get->toString('direction'));
		}

		$total = $pjServiceModel->findCount()->getData();
		$rowCount = $this->_get->toInt('rowCount') ? $this->_get->toInt('rowCount') : 10;
		$pages = ceil($total / $rowCount);
		$page = $this->_get->toInt('page') ? $this->_get->toInt('page') : 1;
		$offset = ((int) $page - 1) * $rowCount;
		if ($page > $pages)
		{
			$page = $pages;
		}

		$data = $pjServiceModel
			->select(sprintf("t1.*, t2.content AS `name`,
				(SELECT COUNT(es.id)
					FROM `%1\$s` AS `es`
					INNER JOIN `%2\$s` AS `e` ON `e`.`id` = `es`.`employee_id`
					WHERE `es`.`service_id` = `t1`.`id` AND `e`.`is_active`='T'
					LIMIT 1) AS `employees`
				", pjEmployeeServiceModel::factory()->getTable(), pjEmployeeModel::factory()->getTable()))
			->orderBy("$column $direction")->limit($rowCount, $offset)->findAll()->getData();
			
		foreach ($data as $k => $v)
		{
			$data[$k]['price_format'] = pjCurrency::formatPrice($v['price']);
			$data[$k]['name'] = pjSanitize::clean($v['name']);
			$data[$k]['length'] = pjSanitize::clean($v['length']) . ' ' . __('service_minutes_unit', true, true);
			$data[$k]['total'] = pjSanitize::clean($v['total']) . ' ' . __('service_minutes_unit', true, true);
		}
			
		self::jsonResponse(compact('data', 'total', 'pages', 'page', 'rowCount', 'column', 'direction'));
	}
	
	public function pjActionIndex()
	{
		$this->appendJs('jquery.datagrid.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
		$this->appendJs('pjAdminServices.js');
		
		$this->set('has_update', pjAuth::factory('pjAdminServices', 'pjActionUpdate')->hasAccess());
		$this->set('has_create', pjAuth::factory('pjAdminServices', 'pjActionCreate')->hasAccess());
		$this->set('has_delete', pjAuth::factory('pjAdminServices', 'pjActionDeleteService')->hasAccess());
		$this->set('has_delete_bulk', pjAuth::factory('pjAdminServices', 'pjActionDeleteServiceBulk')->hasAccess());
	}
	
	public function pjActionSaveService()
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
		if (!pjAuth::factory('pjAdminServices', 'pjActionUpdate')->hasAccess())
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
		
		$pjServiceModel = pjServiceModel::factory();
		if (!in_array($params['column'], $pjServiceModel->getI18n()))
		{
			$pjServiceModel->set('id', $params['id'])->modify(array($params['column'] => $params['value']));
		} else {
			pjMultiLangModel::factory()->updateMultiLang(array($this->getLocaleId() => array($params['column'] => $params['value'])), $params['id'], 'pjService', 'data');
		}
		
		self::jsonResponse(array('status' => 'OK', 'code' => 200));
	}
	
	public function pjActionUpdate()
	{
		if (!pjAuth::factory()->hasAccess())
		{
			$this->sendForbidden();
			return;
		}
		
		$post_max_size = pjUtil::getPostMaxSize();
		if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_SERVER['CONTENT_LENGTH']) && (int) $_SERVER['CONTENT_LENGTH'] > $post_max_size)
		{
			pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminServices&action=pjActionIndex&err=AS15");
		}
		
		if (self::isPost() && $this->_post->toInt('service_update'))
		{
		    
			$err = 'AS01';
			
			$data = array();
			$data['is_active'] = $this->_post->check('is_active') ? 1 : 0;
			$data['price'] = $this->_post->toFloat('price');
			$data['length_unit'] = $this->_post->toString('length_unit');
			$data['length'] = $this->_post->toInt('length');
			if ($data['length_unit'] == 'hour') {
				$data['length'] *= 60;
			}
			$data['before_unit'] = $this->_post->toString('before_unit');
			$data['before'] = $this->_post->toInt('before');
			if ($data['before_unit'] == 'hour') {
				$data['before'] *= 60;
			}
			$data['after_unit'] = $this->_post->toString('after_unit');
			$data['after'] = $this->_post->toInt('after');
			if ($data['after_unit'] == 'hour') {
				$data['after'] *= 60;
			}
			$data['total_unit'] = $data['length_unit'];
			$data['total'] = $data['length'] + $data['before'] + $data['after'];
			
			if (isset($_FILES['image']))
			{
				if($_FILES['image']['error'] == 0)
				{
					$size = getimagesize($_FILES['image']['tmp_name']);
						
					if($size == true)
					{
						$pjServiceModel = pjServiceModel::factory();
						$arr = $pjServiceModel->find($this->_post->toInt('id'))->getData();
						if (!empty($arr))
						{
							@clearstatcache();
							if (!empty($arr['image']) && is_file($arr['image']))
							{
								@unlink($arr['image']);
							}
						}
							
						$pjImage = new pjImage();
						$pjImage->setAllowedExt($this->extensions)->setAllowedTypes($this->mimeTypes);
						if ($pjImage->load($_FILES['image']))
						{
							$data['image'] = PJ_UPLOAD_PATH . 'services/' . md5($this->_post->toInt('id') . PJ_SALT) . ".jpg";
							$pjImage
							->loadImage()
							->resizeSmart(150, 170)
							->saveImage($data['image']);
						}
					}else{
						$err = 'AS17';
					}
				}else if($_FILES['image']['error'] != 4){
					$err = 'AS16';
				}
			}
			
			pjServiceModel::factory()->set('id', $this->_post->toString('id'))->modify($data);
			
			$i18n_arr = $this->_post->toI18n('i18n');
			if (!empty($i18n_arr))
			{
				pjMultiLangModel::factory()->updateMultiLang($i18n_arr, $this->_post->toInt('id'), 'pjService');
			}
			
			$pjEmployeeServiceModel = pjEmployeeServiceModel::factory();
			$pjEmployeeServiceModel->where('service_id', $_POST['id'])->eraseAll();
			if ($this->_post->toArray('employee_id') && $this->_post->toArray('employee_id') != '')
			{
				$pjEmployeeServiceModel->reset()->setBatchFields(array('employee_id', 'service_id'));
				foreach ($this->_post->toArray('employee_id') as $employee_id)
				{
					$pjEmployeeServiceModel->addBatchRow(array($employee_id, $this->_post->toString('id')));
				}
				$pjEmployeeServiceModel->insertBatch();
			}
			
			if($err == 'AS01')
			{
				pjUtil::redirect(PJ_INSTALL_URL . "index.php?controller=pjAdminServices&action=pjActionIndex&err=AS01");
			}else{
				pjUtil::redirect($_SERVER['PHP_SELF'] . "?controller=pjAdminServices&action=pjActionUpdate&id=".$this->_post->toString('id')."&err=$err");
			}
				
		} 
		
		if (self::isGet())
		{
			$arr = pjServiceModel::factory()->find($this->_get->toInt('id'))->getData();
			if (empty($arr))
			{
				pjUtil::redirect(PJ_INSTALL_URL. "index.php?controller=pjAdminServices&action=pjActionIndex&err=AS08");
			}
			$arr['i18n'] = pjMultiLangModel::factory()->getMultiLang($arr['id'], 'pjService');
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
				->where('t1.is_active', 'T')
				->where('t1.role_id', 3)
				->orderBy('t2.content ASC')
				->findAll()
				->getData()
			);
			$this->set('es_arr', pjEmployeeServiceModel::factory()->where('t1.service_id', $arr['id'])->findAll()->getDataPair(null, 'employee_id'));
			
			$this->set('is_flag_ready', $this->requestAction(array('controller' => 'pjLocale', 'action' => 'pjActionIsFlagReady'), array('return')));
				
			$this->appendCss('awesome-bootstrap-checkbox.css', PJ_THIRD_PARTY_PATH . 'awesome_bootstrap_checkbox/');
			
			$this->appendCss('jasny-bootstrap.min.css', PJ_THIRD_PARTY_PATH . 'jasny/');
			$this->appendJs('jasny-bootstrap.min.js', PJ_THIRD_PARTY_PATH . 'jasny/');
			
			$this->appendCss('css/select2.min.css', PJ_THIRD_PARTY_PATH . 'select2/');
			$this->appendJs('js/select2.full.min.js', PJ_THIRD_PARTY_PATH . 'select2/');
				
			$this->appendJs('jquery.multilang.js', PJ_FRAMEWORK_LIBS_PATH . 'pj/js/');
			$this->appendJs('jquery.validate.min.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('additional-methods.js', PJ_THIRD_PARTY_PATH . 'validate/');
			$this->appendJs('pjAdminServices.js');
		}
	}
}
?>