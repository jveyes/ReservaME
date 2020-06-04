<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjEmployeeServiceModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'employees_services';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'employee_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'service_id', 'type' => 'int', 'default' => ':NULL')
	);
	
	protected $validate = array(
		'rules' => array(
			'employee_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			),
			'service_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);

	public static function factory($attr=array())
	{
		return new pjEmployeeServiceModel($attr);
	}
}
?>