<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjCalendarModel extends pjAppModel
{
	protected $primaryKey = 'id';

	protected $table = 'calendars';

	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'user_id', 'type' => 'int', 'default' => ':NULL')
	);
	
	protected $validate = array(
		'rules' => array(
			'user_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);
	
	protected $i18n = array(
		'confirm_subject_client', 'confirm_tokens_client',
		'payment_subject_client', 'payment_tokens_client',
		'cancel_subject_client', 'cancel_tokens_client',
		'confirm_subject_admin', 'confirm_tokens_admin',
		'payment_subject_admin', 'payment_tokens_admin',
		'cancel_subject_admin', 'cancel_tokens_admin',
		'confirm_subject_employee', 'confirm_tokens_employee',
		'payment_subject_employee', 'payment_tokens_employee',
		'cancel_subject_employee', 'cancel_tokens_employee',
		'terms_url', 'terms_body'
	);

	public static function factory($attr=array())
	{
		return new pjCalendarModel($attr);
	}
}
?>