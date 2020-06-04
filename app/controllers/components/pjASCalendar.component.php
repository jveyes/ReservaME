<?php
class pjASCalendar extends pjBaseCalendar
{
	private $dates = array();
	
	public function __construct()
	{
		parent::__construct();
		
		$this->classMonthPrev = "pjAsCalendarLinkMonth";
		$this->classMonthNext = "pjAsCalendarLinkMonth";
		$this->classCalendar = "pjAsCalendarDate";
		
		$this->classPast = "pj-calendar-day-past";
		$this->classToday = "pj-calendar-day-today";
		$this->classReserved = "pj-calendar-day-inactive";
		$this->classSelected = "pj-calendar-day-selected";
		$this->classEmpty = "pj-calendar-day-disabled";
	}
	
	public function getMonthView($month, $year)
    {
        return $this->getMonthHTML($month, $year, 1);
    }
    
	public function get($key)
	{
		if (isset($this->$key))
		{
			return $this->$key;
		}
		return FALSE;
	}
	
	public function set($key, $value)
	{
		if (in_array($key, array('calendarId', 'weekNumbers', 'options', 'dates')))
		{
			$this->$key = $value;
		}
		return $this;
	}
	
	public function onBeforeShow($timestamp, $iso, $today, $current, $year, $month, $d)
    {
    	$date = getdate($timestamp);
    	
    	$today_ts = strtotime(date('Y-m-d 00:00:00', $today[0]));
    	
    	$ahead_ts = $timestamp;
    	if((int) $this->options['o_booking_days_earlier'] > 0)
    	{
	    	$days_earlier = $this->options['o_booking_days_earlier'] * 24 * 60 * 60;
	    	$ahead_ts = $today_ts + $days_earlier;
    	}
    	
    	if ($timestamp < $today_ts || $timestamp > $ahead_ts){
    		$class = $this->classPast;
    	} elseif (isset($this->dates[$iso]) && $this->dates[$iso] == 'OFF') {
			$class = $this->classReserved;
		} else {
			$class = $this->classCalendar;

			if ($year == $today["year"] && $month == $today["mon"] && $d == $today["mday"])
			{
				$class .= " " . $this->classToday;
			}
			if ($year == $current["year"] && $month == $current["mon"] && $d == $current["mday"])
			{
				$class .= " " . $this->classSelected;
			}
		}

		return $class;
    }
}
?>