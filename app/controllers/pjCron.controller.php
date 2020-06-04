<?php
if (!defined("ROOT_PATH"))
{
	header("HTTP/1.1 403 Forbidden");
	exit;
}
class pjCron extends pjAppController
{
	public function __construct()
	{
		$this->setLayout('pjActionEmpty');
	}
	
	public function pjActionIndex()
	{
		$pjOptionModel = pjOptionModel::factory();
		$pjBookingServiceModel = pjBookingServiceModel::factory();
		
		$calendar_arr = pjCalendarModel::factory()
			->select('t1.*, t2.email')
			->join('pjAuthUser', 't2.id=t1.user_id', 'left outer')
			->findAll()
			->getData();

		foreach ($calendar_arr as $calendar)
		{
			$this->option_arr = array_merge($this->option_arr, $pjOptionModel->reset()->getPairs($calendar['id']));
			
			$pjEmail = self::getMailer($this->option_arr);
			
			# Emails
			if ((int) $this->option_arr['o_reminder_email_enable'] === 1)
			{
				$hours_email = (int) $this->option_arr['o_reminder_email_before'];
				
				$booking_arr = $pjBookingServiceModel
					->reset()
					->select("t2.*, t1.*, t3.before, t3.length, t3.after, t4.content AS `service_name`, t5.content AS `country_name`, 
							t6.content AS `o_reminder_subject`, t7.content AS `o_reminder_body`")
					->join('pjBooking', "t2.id=t1.booking_id AND t2.calendar_id = '".$calendar['id']."' AND t2.booking_status='confirmed'", 'inner')
					->join('pjService', 't3.id=t1.service_id', 'inner')
					->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t5.model='pjBaseCountry' AND t5.foreign_id=t2.c_country_id AND t5.field='name' AND t5.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t2.calendar_id AND t6.locale=t2.locale_id AND t6.field='o_reminder_subject'", 'left outer')
					->join('pjMultiLang', "t7.model='pjCalendar' AND t7.foreign_id=t2.calendar_id AND t7.locale=t2.locale_id AND t7.field='o_reminder_body'", 'left outer')
					->where(sprintf("TIMESTAMP(NOW()) BETWEEN FROM_UNIXTIME(t1.start_ts - %1\$u) AND FROM_UNIXTIME(t1.start_ts)", $hours_email * 3600))
					->where('t1.reminder_email < 1')
					->findAll()
					->getData();

				$booking_ids = array();
				foreach ($booking_arr as $booking)
				{
					$tokens = pjAppController::getTokens($booking, $this->option_arr);
					
					$message = str_replace($tokens['search'], $tokens['replace'], str_replace(array('\r\n', '\n'), '<br>', $booking['o_reminder_body']));
					
					if (!empty($message)) {
						$message = pjUtil::textToHtml($message);
						$pjEmail
							->setSubject($booking['o_reminder_subject'])
							->setTo($booking['c_email'])
							->setContentType('text/html');
						if ($pjEmail->send($message))
						{
							$booking_ids[] = $booking['id'];
						}
					}
				}
				if (!empty($booking_ids))
				{
					$pjBookingServiceModel->reset()->whereIn('id', $booking_ids)->modifyAll(array('reminder_email' => 1));
				}
			}

			# SMS
			if ((int) $this->option_arr['o_reminder_sms_enable'] === 1)
			{
				$hours_sms = (int) $this->option_arr['o_reminder_sms_hours'];
				
				$booking_arr = $pjBookingServiceModel
					->reset()
					->select("t2.*, t1.*, t3.before, t3.length, t3.after, t4.content AS `service_name`, t5.content AS `country_name`, t6.content AS `o_reminder_sms_message`")
					->join('pjBooking', "t2.id=t1.booking_id AND t2.calendar_id = '".$calendar['id']."' AND t2.booking_status='confirmed'", 'inner')
					->join('pjService', 't3.id=t1.service_id', 'inner')
					->join('pjMultiLang', "t4.model='pjService' AND t4.foreign_id=t1.service_id AND t4.field='name' AND t4.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t5.model='pjBaseCountry' AND t5.foreign_id=t2.c_country_id AND t5.field='name' AND t5.locale=t2.locale_id", 'left outer')
					->join('pjMultiLang', "t6.model='pjCalendar' AND t6.foreign_id=t2.calendar_id AND t6.locale=t2.locale_id AND t6.field='o_reminder_sms_message'", 'left outer')
					->where(sprintf("TIMESTAMP(NOW()) BETWEEN FROM_UNIXTIME(t1.start_ts - %1\$u) AND FROM_UNIXTIME(t1.start_ts)", $hours_sms * 3600))
					->where('t1.reminder_sms < 1')
					->findAll()
					->getData();
				
				$booking_ids = array();
				foreach ($booking_arr as $booking)
				{
					if (empty($booking['c_phone']))
					{
						continue;
					}
			
					$tokens = pjAppController::getTokens($booking, $this->option_arr);
					
					$message = str_replace($tokens['search'], $tokens['replace'], str_replace(array('\r\n', '\n'), ' ', $booking['o_reminder_sms_message']));
					$message = stripslashes($message);
	
					if (!empty($message)) {
						$params = array(
							'number' => $booking['c_phone'],
							'text' => $message,
							'type' => 'unicode',
							'key' => md5($this->option_arr['private_key'] . PJ_SALT)
						);
						
						$result = pjBaseSms::init($params)->pjActionSend();
						
						if ((int) $result === 1)
						{
							$booking_ids[] = $booking['id'];
						}
					}
				}
				if (!empty($booking_ids))
				{
					$pjBookingServiceModel->reset()->whereIn('id', $booking_ids)->modifyAll(array('reminder_sms' => 1));
				}
			}
		}
		
		return "Send Email and SMS reminders";
	}
}
?>