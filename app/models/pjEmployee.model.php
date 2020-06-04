<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjEmployeeModel extends pjAuthUserModel
{
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'calendar_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'role_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'name', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'email', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'password', 'type' => 'blob', 'default' => ':NULL', 'encrypt' => 'AES'),
		array('name' => 'phone', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'created', 'type' => 'datetime', 'default' => ':NOW()'),
		array('name' => 'last_login', 'type' => 'datetime', 'default' => ':NULL'),
    	array('name' => 'pswd_modified', 'type' => 'datetime', 'default' => ':NOW()'),
        array('name' => 'status', 'type' => 'enum', 'default' => 'T'),
        array('name' => 'is_active', 'type' => 'enum', 'default' => 'F'),
        array('name' => 'locked', 'type' => 'enum', 'default' => 'F'),
        array('name' => 'login_token', 'type' => 'varchar', 'default' => ':NULL'),
        array('name' => 'ip', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'notes', 'type' => 'text', 'default' => ':NULL'),
		array('name' => 'avatar', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'is_subscribed', 'type' => 'tinyint', 'default' => 0),
		array('name' => 'is_subscribed_sms', 'type' => 'tinyint', 'default' => 0)
	);
	
	protected $validate = array(
		'rules' => array(
			'calendar_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			),
			'email' => array(
				'pjActionEmail' => true,
				'pjActionRequired' => true,
				'pjActionNotEmpty' => true
			),
			'password' => array(
				'pjActionRequired' => true,
				'pjActionNotEmpty' => true
			),
		)
	);

	public $i18n = array('name','company');
	
	public static function factory($attr=array())
	{
		return new pjEmployeeModel($attr);
	}
}
?>