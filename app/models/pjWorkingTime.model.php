<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjWorkingTimeModel extends pjAppModel
{
	protected $primaryKey = 'id';
	
	protected $table = 'working_times';
	
	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'foreign_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'type', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'monday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'monday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'tuesday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'tuesday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'wednesday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'wednesday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'thursday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'thursday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'friday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'friday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'saturday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'saturday_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'sunday_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_lunch_from', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_lunch_to', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'sunday_dayoff', 'type' => 'enum', 'default' => 'F')
	);
	
	protected $validate = array(
		'rules' => array(
			'foreign_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			),
			'type' => array(
				'pjActionRequired' => true
			)
		)
	);

	public static function factory($attr=array())
	{
		return new pjWorkingTimeModel($attr);
	}
	
	public function getDaysOff($foreign_id)
	{
	    $data = array();
	    $arr = $this->reset()->where('foreign_id', $foreign_id)->limit(1)->findAll()->getDataIndex(0);
	    $wdays = array(1 => 'monday', 2 => 'tuesday', 3 => 'wednesday', 4 => 'thursday', 5 => 'friday', 6 => 'saturday', 0 => 'sunday');
	    foreach($wdays as $k => $day)
	    {
	        if(empty($arr[$day]))
	        {
	            $data[] = $k;
	        }
	    }
	    return $data;
	}
	
	public function getWorkingTime($foreign_id, $type='calendar')
	{
		$arr = $this->reset()->where('t1.foreign_id', $foreign_id)->where('t1.type', $type)->limit(1)->findAll()->getData();
		
		return !empty($arr) ? $arr[0] : $arr;
	}
	
	public function filterDate($arr, $date, $item = null)
	{
		$day = strtolower(date("l", strtotime($date)));
		
		if ($arr[$day . '_dayoff'] == 'T')
		{
			return array();
		}
		
		if (!empty($item) && $date >= $item[0]['from_date'] && $date <= $item[0]['to_date'] && $item[0]['is_dayoff'] == 'T') {
			return array();
		}
		
		$wt = array();
		if (!empty($item) && $date >= $item[0]['from_date'] && $date <= $item[0]['to_date']) {
			$d = getdate(strtotime($item[0]['start_time']));
			$wt['start_hour'] = $d['hours'];
			$wt['start_minutes'] = $d['minutes'];
			$wt['start_ts'] = strtotime($date . " " . $item[0]['start_time']);
			$wt['start_time'] = date('H:i', strtotime($date . " " . $item[0]['start_time']));
			
			$d = getdate(strtotime($item[0]['end_time']));
			$wt['end_hour'] = $d['hours'];
			$wt['end_minutes'] = $d['minutes'];
			$wt['end_ts'] = strtotime($date . " " . $item[0]['end_time']);
			$wt['end_time'] = date('H:i', strtotime($date . " " . $item[0]['end_time']));
				
			$d = getdate(strtotime($item[0]['start_lunch']));
			$wt['lunch_start_hour'] = $d['hours'];
			$wt['lunch_start_minutes'] = $d['minutes'];
			$wt['lunch_start_ts'] = strtotime($date . " " . $item[0]['start_lunch']);
			$wt['lunch_start_time'] = date('H:i', strtotime($date . " " . $item[0]['start_lunch']));
			
			$d = getdate(strtotime($item[0]['end_lunch']));
			$wt['lunch_end_hour'] = $d['hours'];
			$wt['lunch_end_minutes'] = $d['minutes'];
			$wt['lunch_end_ts'] = strtotime($date . " " . $item[0]['end_lunch']);
			$wt['lunch_end_time'] = date('H:i', strtotime($date . " " . $item[0]['end_lunch']));
		} else {
			foreach ($arr as $k => $v)
			{
				if (strpos($k, $day . '_lunch_from') !== false)
				{
					$d = getdate(strtotime($v));
					$wt['lunch_start_hour'] = $d['hours'];
					$wt['lunch_start_minutes'] = $d['minutes'];
					$wt['lunch_start_ts'] = strtotime($date . " " . $v);
					$wt['lunch_start_time'] = date('H:i', strtotime($date . " " . $v));
					continue;
				}
				
				if (strpos($k, $day . '_lunch_to') !== false)
				{
					$d = getdate(strtotime($v));
					$wt['lunch_end_hour'] = $d['hours'];
					$wt['lunch_end_minutes'] = $d['minutes'];
					$wt['lunch_end_ts'] = strtotime($date . " " . $v);
					$wt['lunch_end_time'] = date('H:i', strtotime($date . " " . $v));
					continue;
				}
				
				if (strpos($k, $day . '_from') !== false && strpos($k, $day . '_lunch_from') === false && !is_null($v))
				{
					$d = getdate(strtotime($v));
					$wt['start_hour'] = $d['hours'];
					$wt['start_minutes'] = $d['minutes'];
					$wt['start_ts'] = strtotime($date . " " . $v);
					$wt['start_time'] = date('H:i', strtotime($date . " " . $v));
					continue;
				}
			
				if (strpos($k, $day . '_to') !== false && strpos($k, $day . '_lunch_to') === false && !is_null($v))
				{
					$d = getdate(strtotime($v));
					$wt['end_hour'] = $d['hours'];
					$wt['end_minutes'] = $d['minutes'];
					$wt['end_ts'] = strtotime($date . " " . $v);
					$wt['end_time'] = date('H:i', strtotime($date . " " . $v));
					continue;
				}
			}
		}
		return $wt;
	}
	
	public function init($foreign_id, $type='calendar')
	{
		$data = array();
		$data['foreign_id']     = $foreign_id;
		$data['type']           = $type;
		
		$data['monday_from']    = '08:00:00';
		$data['monday_to']      = '18:00:00';
		$data['tuesday_from']   = '08:00:00';
		$data['tuesday_to']     = '18:00:00';
		$data['wednesday_from'] = '08:00:00';
		$data['wednesday_to']   = '18:00:00';
		$data['thursday_from']  = '08:00:00';
		$data['thursday_to']    = '18:00:00';
		$data['friday_from']    = '08:00:00';
		$data['friday_to']      = '18:00:00';
		$data['saturday_from']  = '08:00:00';
		$data['saturday_to']    = '18:00:00';
		$data['sunday_from']    = '08:00:00';
		$data['sunday_to']      = '18:00:00';
		
		$data['monday_lunch_from']    = '12:00:00';
		$data['monday_lunch_to']      = '13:00:00';
		$data['tuesday_lunch_from']   = '12:00:00';
		$data['tuesday_lunch_to']     = '13:00:00';
		$data['wednesday_lunch_from'] = '12:00:00';
		$data['wednesday_lunch_to']   = '13:00:00';
		$data['thursday_lunch_from']  = '12:00:00';
		$data['thursday_lunch_to']    = '13:00:00';
		$data['friday_lunch_from']    = '12:00:00';
		$data['friday_lunch_to']      = '13:00:00';
		$data['saturday_lunch_from']  = '12:00:00';
		$data['saturday_lunch_to']    = '13:00:00';
		$data['sunday_lunch_from']    = '12:00:00';
		$data['sunday_lunch_to']      = '13:00:00';
		
		return $this->reset()->setAttributes($data)->insert()->getInsertId();
	}
	
	public function initFrom($from_foreign_id, $to_foreign_id, $from_type='calendar', $to_type='employee')
	{
		$haystack = array('calendar', 'employee');
		if (!in_array($from_type, $haystack) || !in_array($to_type, $haystack))
		{
			return FALSE;
		}
		$arr = $this->reset()->where('t1.foreign_id', $from_foreign_id)->where('t1.type', $from_type)->limit(1)->findAll()->getData();
		if (empty($arr))
		{
			return FALSE;
		}
		
		$arr = $arr[0];
		unset($arr['id']);
		$arr['foreign_id'] = $to_foreign_id;
		$arr['type'] = $to_type;
		return $this->reset()->setAttributes($arr)->insert()->getInsertId();
	}
	
	public function getAvailableSlots($date, $t_arr, $booking_arr)
	{
	    $wt = array();
	    if(empty($booking_arr))
	    {
	        if(isset($t_arr['is_dayoff']) && $t_arr['is_dayoff'] == true)
	        {
	            $wt['is_dayoff'] = true;
	        }else{
	            $wt['avail'] = true;
	        }
	    }else{
	    	$period = $t_arr;
            $default_start_time = $period['start_time'];
            $default_end_time = $period['end_time'];
            $default_start_ts = strtotime($date . ' ' . $default_start_time);
            $default_end_ts = strtotime($date . ' ' . $default_end_time);
            $in_range = false;
            $k = 0;
            foreach($booking_arr as $hash => $v)
            {
                $custom_start_ts = strtotime($date . ' ' . $v['start_time']);
                $custom_end_ts = strtotime($date . ' ' . $v['end_time']);
                if( ($custom_start_ts > $default_start_ts && $custom_start_ts < $default_end_ts) && ($custom_end_ts > $default_start_ts && $custom_end_ts < $default_end_ts) )
                {
                    $wt[$default_start_ts] = array('start_time' => $default_start_time, 'end_time' => $v['start_time']);
                    $wt[$custom_end_ts] = array('start_time' => $v['end_time'], 'end_time' => $default_end_time);
                    $in_range = true;
                }else if(($custom_start_ts > $default_start_ts && $custom_start_ts < $default_end_ts) && ($custom_end_ts >= $default_end_ts)){
                    $wt[$default_start_ts] = array('start_time' => $default_start_time, 'end_time' => $v['start_time']);
                    $in_range = true;
                }else if(($custom_end_ts > $default_start_ts && $custom_end_ts < $default_end_ts) && ($custom_start_ts <= $default_start_ts)){
                    $wt[$custom_end_ts] = array('start_time' => $v['end_time'], 'end_time' => $default_end_time);
                    if($k + 1 < count($booking_arr))
                    {
                        $default_start_time = $v['end_time'];
                        $default_start_ts = strtotime($date . ' ' . $default_start_time);
                    }else{
                        $wt[$custom_end_ts] = array('start_time' => $v['end_time'], 'end_time' => $default_end_time);
                    }
                    $in_range = true;
                }
                $wt[$custom_start_ts][] = $hash;
                $k++;
            }
            
            if($in_range == false)
            {
                $wt[$default_start_ts] = array('start_time' => $default_start_time, 'end_time' => $default_end_time);
            }
	    }
	    ksort($wt);
	    return $wt;
	}
}