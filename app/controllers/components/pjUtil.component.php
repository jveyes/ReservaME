<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjUtil extends pjToolkit
{
	static public function uuid()
	{
		return chr(rand(65,90)) . chr(rand(65,90)) . time();
	}
	
	static public function getReferer()
	{
		if (isset($_GET['_escaped_fragment_']))
		{
			if (isset($_SERVER['REDIRECT_URL']))
			{
				return $_SERVER['REDIRECT_URL'];
			}
		}
		
		if (isset($_SERVER['HTTP_REFERER']))
		{
			$pos = strpos($_SERVER['HTTP_REFERER'], "#");
			if ($pos !== FALSE)
			{
				// IE fix
				return substr($_SERVER['HTTP_REFERER'], 0, $pos);
			}
			return $_SERVER['HTTP_REFERER'];
		}
	}
	
	static public function getTimezone($offset)
	{
		$db = array(
			'-14400' => 'America/Porto_Acre',
			'-18000' => 'America/Porto_Acre',
			'-7200' => 'America/Goose_Bay',
			'-10800' => 'America/Halifax',
			'14400' => 'Asia/Baghdad',
			'-32400' => 'America/Anchorage',
			'-36000' => 'America/Anchorage',
			'-28800' => 'America/Anchorage',
			'21600' => 'Asia/Aqtobe',
			'18000' => 'Asia/Aqtobe',
			'25200' => 'Asia/Almaty',
			'10800' => 'Asia/Yerevan',
			'43200' => 'Asia/Anadyr',
			'46800' => 'Asia/Anadyr',
			'39600' => 'Asia/Anadyr',
			'0' => 'Atlantic/Azores',
			'-3600' => 'Atlantic/Azores',
			'7200' => 'Europe/London',
			'28800' => 'Asia/Brunei',
			'3600' => 'Europe/London',
			'-39600' => 'America/Adak',
			'32400' => 'Asia/Shanghai',
			'36000' => 'Asia/Choibalsan',
			'-21600' => 'America/Chicago',
			'-25200' => 'Chile/EasterIsland',
			'-43200' => 'Pacific/Kwajalein'
		);
		if (is_null($offset) && strlen($offset) === 0)
		{
			return $db;
		}
		return array_key_exists($offset, $db) ? $db[$offset] : false;
	}
	
	public static function printNotice($title, $body, $convert = true, $close = true, $autoClose = false)
	{
		?>
		<div class="notice-box">
			<span class="notice-info">&nbsp;</span>
			<?php
			if (!empty($title))
			{
				printf('<span class="block bold">%s</span>', $convert ? htmlspecialchars(stripslashes($title)) : stripslashes($title));
			}
			if (!empty($body))
			{
				printf('<span class="block">%s</span>', $convert ? htmlspecialchars(stripslashes($body)) : stripslashes($body));
			}
			if ($close)
			{
				?><a href="#" class="notice-close"></a><?php
			}
			?>
		</div>
		<?php
	}
	
	static public function textToHtml($content)
	{
		return '<html><head><title></title></head><body>'.stripslashes($content).'</body></html>';
	}
	
	static public function getPostMaxSize()
	{
		$post_max_size = ini_get('post_max_size');
		switch (substr($post_max_size, -1))
		{
			case 'G':
				$post_max_size = (int) $post_max_size * 1024 * 1024 * 1024;
				break;
			case 'M':
				$post_max_size = (int) $post_max_size * 1024 * 1024;
				break;
			case 'K':
				$post_max_size = (int) $post_max_size * 1024;
				break;
		}
		return $post_max_size;
	}
	
	static public function getWeekRange($date, $week_start)
	{
		$week_arr = array(
				0=>'sunday',
				1=>'monday',
				2=>'tuesday',
				3=>'wednesday',
				4=>'thursday',
				5=>'friday',
				6=>'saturday');
			
		$ts = strtotime($date);
		$start = (date('w', $ts) == $week_start) ? $ts : strtotime('last ' . $week_arr[$week_start], $ts);
		$week_start = ($week_start == 0 ? 6 : $week_start -1);
		return array(date('Y-m-d', $start), date('Y-m-d', strtotime('next ' . $week_arr[$week_start], $start)));
	}
	
	static public function sortArrayByArray(Array $array, Array $orderArray) {
		$ordered = array();
		foreach($orderArray as $key) 
		{
			if(array_key_exists($key,$array)) 
			{
				$ordered[$key] = $array[$key];
				unset($array[$key]);
			}
		}
		return $ordered + $array;
	}

    public static function sortWeekDays($week_start, $days)
    {
        if($week_start > 0){
            $arr = array();
            for($i = $week_start; $i <= 6; $i++)
            {
                $arr[] = $i;
            }
            for($i = 0; $i < $week_start; $i++)
            {
                $arr[] = $i;
            }
            return pjUtil::sortArrayByArray($days, $arr);
        }else{
            return $days;
        }
    }
    
    public static function toBootstrapDate($format)
    {
    	return str_replace(
    			array('Y', 'm', 'n', 'd', 'j'),
    			array('yyyy', 'mm', 'm', 'dd', 'd'),
    			$format);
    }
    
    public static function getHourMinFromSeconds($seconds)
    {
        $hours = floor($seconds / 3600);
        $mins = round(($seconds - $hours * 3600) / 60);
        return compact('hours', 'mins');
    }
    
    public static function getSixMonths()
    {
    	$result = array();
    	$i = 1;
    	$month = time();
    	while($i <= 6)
    	{
    		$result[$i]['year'] = date('Y', $month);
    		$result[$i]['month'] = date('m', $month);
    		$month = strtotime('-1 month', $month);
    		$i++;
    	}
    	krsort($result);
    	return $result;
    }
}
?>