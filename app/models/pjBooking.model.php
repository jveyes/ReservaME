<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjBookingModel extends pjAppModel
{
	protected $primaryKey = 'id';

	protected $table = 'bookings';

	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'uuid', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'calendar_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'booking_price', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'booking_total', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'booking_deposit', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'booking_tax', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'booking_status', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'payment_method', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'c_name', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_email', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_phone', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_country_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'c_city', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_state', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_zip', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_address_1', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_address_2', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'c_notes', 'type' => 'text', 'default' => ':NULL'),
		array('name' => 'cc_type', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'cc_num', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'cc_exp_year', 'type' => 'year', 'default' => ':NULL'),
		array('name' => 'cc_exp_month', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'cc_code', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'txn_id', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'processed_on', 'type' => 'datetime', 'default' => ':NULL'),
		array('name' => 'created', 'type' => 'datetime', 'default' => ':NOW()'),
		array('name' => 'locale_id', 'type' => 'tinyint', 'default' => ':NULL'),
		array('name' => 'ip', 'type' => 'varchar', 'default' => ':NULL')
	);
	
	protected $validate = array(
		'rules' => array(
			'uuid' => array(
				'pjActionAlphaNumeric' => true,
				'pjActionNotEmpty' => true,
				'pjActionRequired' => true
			),
			'calendar_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);

	public static function factory($attr=array())
	{
		return new pjBookingModel($attr);
	}
}
?>