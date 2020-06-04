<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjDateModel extends pjAppModel
{
	protected $primaryKey = 'id';

	protected $table = 'dates';

	protected $schema = array(
		array('name' => 'id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'foreign_id', 'type' => 'int', 'default' => ':NULL'),
		array('name' => 'type', 'type' => 'enum', 'default' => ':NULL'),
		array('name' => 'from_date', 'type' => 'date', 'default' => ':NULL'),
		array('name' => 'to_date', 'type' => 'date', 'default' => ':NULL'),
		array('name' => 'start_time', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'end_time', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'start_lunch', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'end_lunch', 'type' => 'time', 'default' => ':NULL'),
		array('name' => 'is_dayoff', 'type' => 'enum', 'default' => 'F'),
		array('name' => 'all_day', 'type' => 'enum', 'default' => 'F')
	);

	protected $validate = array(
		'rules' => array(
			'foreign_id' => array(
				'pjActionNumeric' => true,
				'pjActionRequired' => true
			)
		)
	);

	public static function factory($attr=array())
	{
		return new pjDateModel($attr);
	}
	
	public function getDailyWorkingTime($foreign_id, $date, $type='calendar')
	{
		$arr = $this->reset()
			->where('t1.foreign_id', $foreign_id)
			->where('t1.type', $type)
			->where('t1.to_date >=', $date)
			->where('t1.from_date <=', $date)
			->orderBy('t1.start_time ASC')
			->limit(1)
			->findAll()
			->getData();
		
		if (empty($arr))
		{
			return false;
		}
		$arr = $arr[0];

		if ($arr['is_dayoff'] == 'T')
		{
			return array();
		}
		
		$wt = array();
		$d = getdate(strtotime($arr['start_time']));
		$wt['start_hour'] = $d['hours'];
		$wt['start_minutes'] = $d['minutes'];
	
		$d = getdate(strtotime($arr['end_time']));
		$wt['end_hour'] = $d['hours'];
		$wt['end_minutes'] = $d['minutes'];
		
		$wt['start_ts'] = strtotime($date . " " . $arr['start_time']);
		$wt['end_ts'] = strtotime($date . " " . $arr['end_time']);
		
		# Lunch
		$d = getdate(strtotime($arr['start_lunch']));
		$wt['lunch_start_hour'] = $d['hours'];
		$wt['lunch_start_minutes'] = $d['minutes'];
	
		$d = getdate(strtotime($arr['end_lunch']));
		$wt['lunch_end_hour'] = $d['hours'];
		$wt['lunch_end_minutes'] = $d['minutes'];
		
		$wt['lunch_start_ts'] = strtotime($date . " " . $arr['start_lunch']);
		$wt['lunch_end_ts'] = strtotime($date . " " . $arr['end_lunch']);
		
		return $wt;
	}
	
	public function getRangeWorkingTime($foreign_id, $date_from, $date_to, $type='calendar')
	{
		$_arr = array();
		$from = strtotime($date_from);
		$to = strtotime($date_to);
		if ($from > $to)
		{
			$tmp = $from;
			$from = $to;
			$to = $tmp;
		}
		for ($i = $from; $i <= $to; $i += 86400)
		{
			$_date = date("Y-m-d", $i);
			$_arr[$_date] = array();
			
			
			$arr = $this
				->reset()
				->where('t1.foreign_id', $foreign_id)
				->where('t1.type', $type)
				->where('t1.to_date >=', $_date)
				->where('t1.from_date <=', $_date)
				->orderBy('t1.start_time ASC')
				->findAll()
				->getData();
				
			foreach ($arr as $item)
			{
				$_arr[$_date] = $item;
				
				$d = getdate(strtotime($item['start_time']));
				$_arr[$_date]['start_hour'] = $d['hours'];
				$_arr[$_date]['start_minutes'] = $d['minutes'];
			
				$d = getdate(strtotime($item['end_time']));
				$_arr[$_date]['end_hour'] = $d['hours'];
				$_arr[$_date]['end_minutes'] = $d['minutes'];
				
				$_arr[$_date]['start_ts'] = strtotime($_date . " " . $item['start_time']);
				$_arr[$_date]['end_ts'] = strtotime($_date . " " . $item['end_time']);
				
				# Lunch
				$d = getdate(strtotime($item['start_lunch']));
				$_arr[$_date]['lunch_start_hour'] = $d['hours'];
				$_arr[$_date]['lunch_start_minutes'] = $d['minutes'];
			
				$d = getdate(strtotime($item['end_lunch']));
				$_arr[$_date]['lunch_end_hour'] = $d['hours'];
				$_arr[$_date]['lunch_end_minutes'] = $d['minutes'];
				
				$_arr[$_date]['lunch_start_ts'] = strtotime($_date . " " . $item['start_lunch']);
				$_arr[$_date]['lunch_end_ts'] = strtotime($_date . " " . $item['end_lunch']);
			}
		}
		
		return $_arr;
	}
		
	public function getWorkingTime($foreign_id, $iso_first_date, $total_days)
	{
		if($total_days == 0 && is_array($iso_first_date))
		{
			$first_string = join("','", $iso_first_date);
			$temp_arr = array();
			foreach($iso_first_date as $date)
			{
				$temp_arr[] = "('$date' BETWEEN t1.from_date AND t1.to_date)";
			}
			$second_string = join(" OR ", $temp_arr);
			$arr = $this
			->reset()
			->where('t1.foreign_id', $foreign_id)
			->where(sprintf("( (t1.to_date IS NULL AND (t1.from_date IN ('%1\$s') ) ) OR
                               (t1.to_date IS NOT NULL AND (%2\$s) ))", $first_string, $second_string))
	                               ->orderBy('t1.from_date ASC, t1.start_time ASC')
	                               ->findAll()
	                               ->getData();
	                               $_arr = array();
	                               foreach ($iso_first_date as $date_iso)
	                               {
	                               	$_arr[$date_iso] = array();
	                               }
		}else{
			list($year, $month, $day) = explode('-', $iso_first_date);
			$_arr = array();
			foreach (range(0,$total_days-1) as $i)
			{
				$_arr[date("Y-m-d", strtotime($iso_first_date) + 86400 * $i)] = array();
			}
				
			$arr = $this
			->reset()
			->where('t1.foreign_id', $foreign_id)
			->where(sprintf("( (t1.to_date IS NULL AND (t1.from_date BETWEEN '%1\$s' AND DATE_ADD('%1\$s', INTERVAL '%2\$u' DAY)) ) OR
                               (t1.to_date IS NOT NULL AND ( (t1.from_date BETWEEN '%1\$s' AND DATE_ADD('%1\$s', INTERVAL '%2\$u' DAY)) OR (t1.to_date BETWEEN '%1\$s' AND DATE_ADD('%1\$s', INTERVAL '%2\$u' DAY)) OR ('%1\$s' BETWEEN t1.from_date AND t1.to_date) OR (DATE_ADD('%1\$s', INTERVAL '%2\$u' DAY) BETWEEN t1.from_date AND t1.to_date) ))  )", $iso_first_date, $total_days-1))
	                               ->orderBy('t1.from_date ASC, t1.start_time ASC')
	                               ->findAll()
	                               ->getData();
		}
		 
		foreach ($arr as $item)
		{
			if(empty($item['to_date']))
			{
				$_arr[$item['from_date']][] = $item;
			}else{
				if($item['to_date'] == $item['from_date'])
				{
					$_arr[$item['from_date']][] = $item;
				}else{
					$from_date = $item['from_date'];
					while($from_date <= $item['to_date'])
					{
						$_arr[$from_date][] = $item;
						$from_date = date('Y-m-d', strtotime($from_date) + 86400);
					}
				}
			}
		}
		return $_arr;
	}
	
	public function getDatesOff($foreign_id)
	{
		$arr = $this
		->reset()
		->where('t1.foreign_id', $foreign_id)
		->where("( (t1.to_date IS NULL AND t1.from_date>=CURRENT_DATE() ) OR (t1.to_date IS NOT NULL AND ( (t1.from_date >=CURRENT_DATE()) OR (CURRENT_DATE() >= t1.from_date AND CURRENT_DATE() <= t1.to_date) )))")
		->orderBy('t1.from_date ASC, t1.start_time ASC')
		->findAll()
		->getData();
		$data = array();
		foreach($arr as $item)
		{
			if(empty($item['start_time']) && empty($item['end_time']))
			{
				if(empty($item['to_date']))
				{
					$data[] = $item['from_date'];
				}else{
					if($item['to_date'] == $item['from_date'])
					{
						$data[] = $item['from_date'];
					}else{
						$from_date = $item['from_date'];
						while($from_date <= $item['to_date'])
						{
							if($from_date >= date('Y-m-d'))
							{
								$data[] = $from_date;
							}
							$from_date = date('Y-m-d', strtotime($from_date) + 86400);
						}
					}
				}
			}
		}
		return $data;
	}
}
?>