<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjBookingServiceModel extends pjAppModel
{
	protected $primaryKey = 'id';

	protected $table = 'bookings_services';

	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'tmp_hash', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'booking_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'service_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'employee_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'date', 'type' => 'date', 'default' => ':NULL'),
		array('name' => 'start', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'start_ts', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'total', 'type' => 'smallint', 'default' => ':NULL'),
		array('name' => 'price', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'reminder_email', 'type' => 'tinyint', 'default' => 0),
		array('name' => 'reminder_sms', 'type' => 'tinyint', 'default' => 0)
	);
	
	protected $validate = array(
		'rules' => array(
			'booking_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);

	public static function factory($attr=array())
	{
		return new pjBookingServiceModel($attr);
	}
}
?>