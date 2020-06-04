<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjServiceModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'services';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'calendar_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'price', 'type' => 'decimal', 'default' => ':NULL'),
		array('name' => 'length', 'type' => 'smallint', 'default' => ':NULL'),
		array('name' => 'length_unit', 'type' => 'enum', 'default' => 'minute'),
		array('name' => 'before', 'type' => 'smallint', 'default' => ':NULL'),
		array('name' => 'before_unit', 'type' => 'enum', 'default' => 'minute'),
		array('name' => 'after', 'type' => 'smallint', 'default' => ':NULL'),
		array('name' => 'after_unit', 'type' => 'enum', 'default' => 'minute'),
		array('name' => 'total', 'type' => 'smallint', 'default' => ':NULL'),
		array('name' => 'total_unit', 'type' => 'enum', 'default' => 'minute'),
		array('name' => 'image', 'type' => 'varchar', 'default' => ':NULL'),
		array('name' => 'is_active', 'type' => 'tinyint', 'default' => 1)
	);
	
	protected $validate = array(
		'rules' => array(
			'calendar_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);
	
	public $i18n = array('name', 'description');
	
	public static function factory($attr=array())
	{
		return new pjServiceModel($attr);
	}
}
?>