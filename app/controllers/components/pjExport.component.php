<?php
if (!defined("ROOT_PATH"))
{
    header("HTTP/1.1 403 Forbidden");
    exit;
}
class pjExport
{
    static public function iCalUID()
    {
        return chr(rand(65,90)) . chr(rand(65,90)) . (time() + mt_rand(1, 1000));
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
    
    static public function getComingWhere($period, $week_start)
    {
        $where_str = '';
        switch ($period) {
            case 1:
                $where_str = "(CURDATE() = t2.date)";
                break;
                ;
            case 2:
                $where_str = "(DATE(DATE_ADD(NOW(), INTERVAL 1 DAY)) = t2.date)";
                break;
                ;
            case 3:
                list($start_week, $end_week) = pjExport::getWeekRange(date('Y-m-d'), $week_start);
                $where_str = "(t2.date BETWEEN CURDATE() AND '$end_week')";
                break;
                ;
            case 4:
                list($start_week, $end_week) = pjExport::getWeekRange(date('Y-m-d', strtotime("+7 days")), $week_start);
                $where_str = "(t2.date BETWEEN '$start_week' AND '$end_week')";
                break;
                ;
            case 5:
                $end_month = date('Y-m-t',strtotime('this month'));
                $where_str = "(t2.date BETWEEN CURDATE() AND '$end_month')";
                break;
                ;
            case 6:
                $start_month = date("Y-m-d", mktime(0, 0, 0, date("m") + 1, 1, date("Y")));
                $end_month = date("Y-m-d", mktime(0, 0, 0, date("m") + 2, 0, date("Y")));
                $where_str = "(t2.date BETWEEN '$start_month' AND '$end_month')";
                break;
                ;
        }
        return $where_str;
    }
    
    static public function getMadeWhere($period, $week_start)
    {
        $where_str = '';
        switch ($period) {
            case 1:
                $where_str = "(DATE(t1.created) = CURDATE() OR DATE(t1.modified) = CURDATE())";
                break;
                ;
            case 2:
                $where_str = "(DATE(t1.created) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)) OR DATE(t1.modified) = DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)))";
                break;
                ;
            case 3:
                list($start_week, $end_week) = pjExport::getWeekRange(date('Y-m-d'), $week_start);
                $where_str = "((DATE(t1.created) BETWEEN '$start_week' AND '$end_week') OR (DATE(t1.modified) BETWEEN '$start_week' AND '$end_week'))";
                break;
                ;
            case 4:
                list($start_week, $end_week) = pjExport::getWeekRange(date('Y-m-d', strtotime("-7 days")), $week_start);
                $where_str = "((DATE(t1.created) BETWEEN '$start_week' AND '$end_week') OR (DATE(t1.modified) BETWEEN '$start_week' AND '$end_week'))";
                break;
                ;
            case 5:
                $start_month = date('Y-m-01',strtotime('this month'));
                $end_month = date('Y-m-t',strtotime('this month'));
                $where_str = "((DATE(t1.created) BETWEEN '$start_month' AND '$end_month') OR (DATE(t1.modified) BETWEEN '$start_month' AND '$end_month'))";
                break;
                ;
            case 6:
                $start_month = date("Y-m-d", mktime(0, 0, 0, date("m")-1, 1, date("Y")));
                $end_month = date("Y-m-d", mktime(0, 0, 0, date("m"), 0, date("Y")));
                $where_str = "((DATE(t1.created) BETWEEN '$start_month' AND '$end_month') OR (DATE(t1.modified) BETWEEN '$start_month' AND '$end_month'))";
                break;
                ;
        }
        return $where_str;
    }
    
    static function getFeedData($request, $locale_id, $option_arr)
    {
        $arr = array();
        $status = true;
        $type = '';
        $period = '';
        if(isset($request['period']))
        {
            if(!ctype_digit($request['period']))
            {
                $status = false;
            }else{
                $period = $request['period'];
            }
        }else{
            $status = false;
        }
        if(isset($request['type']))
        {
            if(!ctype_digit($request['type']))
            {
                $status = false;
            }else{
                $type = $request['type'];
            }
        }else{
            $status = false;
        }
        if($status == true && $type != '' && $period != '')
        {
            $pjBookingModel = pjBookingModel::factory()
            ->select('t1.*, t2.*, t3.total as service_length, t4.content as employee_name, t5.content as service_name')
            ->join('pjBookingService', 't2.booking_id=t1.id', 'left outer')
            ->join('pjService', 't2.service_id=t3.id', 'left outer')
            ->join('pjMultiLang', sprintf("t4.model='pjEmployee' AND t4.foreign_id=t2.employee_id AND t4.field='name' AND t4.locale=%u", $locale_id), 'left outer')
            ->join('pjMultiLang', sprintf("t5.model='pjService' AND t5.foreign_id=t2.service_id AND t5.field='name' AND t5.locale=%u", $locale_id), 'left outer');
            
            if($type == '1')
            {
                $column = 't2.date';
                $direction = 'ASC';
                
                $where_str = pjExport::getComingWhere($period, $option_arr['o_week_start']);
                if($where_str != '')
                {
                    $pjBookingModel->where($where_str);
                }
            }else{
                $column = 't1.created';
                $direction = 'DESC';
                $where_str = pjExport::getMadeWhere($period, $option_arr['o_week_start']);
                if($where_str != '')
                {
                    $pjBookingModel->where($where_str);
                }
            }
            $arr= $pjBookingModel->orderBy("$column $direction")->findAll()->getData();
        }
        return $arr;
    }
    
    static function doExportData($request, $action, $locale_id, $option_arr)
    {
        $data = pjExport::getFeedData($request, $locale_id, $option_arr);
        if($request['format'] == 'xml')
        {
            $xml = new pjXML();
            if($action == 'feed')
            {
                echo $xml->setEncoding('UTF-8')->process($data)->getData();
            }else if($action == 'download'){
                $xml->setEncoding('UTF-8')->setName("Export-".time().".xml")->process($data)->download();
            }
        }
        if($request['format'] == 'csv')
        {
            $csv = new pjCSV();
            if($action == 'feed')
            {
                echo $csv->setHeader(true)->process($data)->getData();
            }else if($action == 'download'){
                $csv->setHeader(true)->setName("Export-".time().".csv")->process($data)->download();
            }
        }
        if($request['format'] == 'ical')
        {
            date_default_timezone_set("UTC");
            foreach($data as $k => $v)
            {
                $v['uuid'] = pjExport::iCalUID();
                $end_ts = $v['start_ts'] + 60 * $v['service_length'];
                $v['date_from'] = date('Y-m-d H:i:s', $v['start_ts']);
                $v['date_to'] = date('Y-m-d H:i:s', $end_ts);
                $_arr = array();
                if(!empty($v['c_name']))
                {
                    $_arr[] = pjSanitize::html($v['c_name']);
                }
                if(!empty($v['service_name']))
                {
                    $_arr[] =  __('service_name', true) . ': ' . pjSanitize::html($v['service_name']);
                }
                if(!empty($v['employee_name']))
                {
                    $_arr[] = __('employee_name', true) . ': ' . pjSanitize::html($v['employee_name']);
                }
                if(!empty($v['c_email']))
                {
                    $_arr[] = __('employee_email', true) . ': ' . pjSanitize::html($v['c_email']);
                }
                if(!empty($v['c_phone']))
                {
                    $_arr[] = __('employee_phone', true) . ': ' . pjSanitize::html($v['c_phone']);
                }
                if(!empty($v['booking_total']))
                {
                    $_arr[] = __('service_price', true) . ': ' . pjSanitize::html($v['booking_total']);
                }
                if(!empty($v['c_notes']))
                {
                    $_arr[] = __('booking_notes', true) . ': ' . pjSanitize::html(preg_replace('/\n|\r|\r\n/', ' ', $v['c_notes']));
                }
                $_arr[] = __('lblStatus', true) . ': ' . pjSanitize::html($v['booking_status']);
                
                $v['desc'] = join("\; ", $_arr);
                $v['location'] = '';
                $v['summary'] = 'Booking';
                $data[$k] = $v;
            }
            
            $ical = new pjICal();
            $ical
            ->setProdID('Appointment Scheduler')
            ->setSummary('summary')
            ->setCName('desc')
            ->setLocation('location')
            ->process($data);
            if($action == 'feed')
            {
                echo $ical->getData();
            }else if($action == 'download'){
                $ical->setName("Export-".time().".ics")->download();
            }
            
        }
    }
}
?>