DROP TABLE IF EXISTS `appscheduler_bookings`;
CREATE TABLE IF NOT EXISTS `appscheduler_bookings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(12) DEFAULT NULL,
  `calendar_id` int(10) unsigned DEFAULT NULL,
  `booking_price` decimal(9,2) unsigned DEFAULT NULL,
  `booking_total` decimal(9,2) unsigned DEFAULT NULL,
  `booking_deposit` decimal(9,2) unsigned DEFAULT NULL,
  `booking_tax` decimal(9,2) unsigned DEFAULT NULL,
  `booking_status` enum('pending','confirmed','cancelled') DEFAULT NULL,
  `payment_method` enum('paypal','authorize','creditcard','bank') DEFAULT NULL,
  `c_name` varchar(255) DEFAULT NULL,
  `c_email` varchar(255) DEFAULT NULL,
  `c_phone` varchar(255) DEFAULT NULL,
  `c_country_id` int(10) unsigned DEFAULT NULL,
  `c_city` varchar(255) DEFAULT NULL,
  `c_state` varchar(255) DEFAULT NULL,
  `c_zip` varchar(255) DEFAULT NULL,
  `c_address_1` varchar(255) DEFAULT NULL,
  `c_address_2` varchar(255) DEFAULT NULL,
  `c_notes` text,
  `cc_type` varchar(255) DEFAULT NULL,
  `cc_num` varchar(255) DEFAULT NULL,
  `cc_exp_year` year(4) DEFAULT NULL,
  `cc_exp_month` varchar(2) DEFAULT NULL,
  `cc_code` varchar(255) DEFAULT NULL,
  `txn_id` varchar(255) DEFAULT NULL,
  `processed_on` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `locale_id` tinyint(3) unsigned DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `calendar_id` (`calendar_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_bookings_services`;
CREATE TABLE IF NOT EXISTS `appscheduler_bookings_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tmp_hash` varchar(32) DEFAULT NULL,
  `booking_id` int(10) unsigned DEFAULT NULL,
  `service_id` int(10) unsigned DEFAULT NULL,
  `employee_id` int(10) unsigned DEFAULT NULL,
  `date` date DEFAULT NULL,
  `start` time DEFAULT NULL,
  `start_ts` int(10) unsigned DEFAULT NULL,
  `total` smallint(5) unsigned DEFAULT NULL,
  `price` decimal(9,2) unsigned DEFAULT NULL,
  `reminder_email` tinyint(1) unsigned DEFAULT '0',
  `reminder_sms` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`),
  KEY `tmp_hash` (`tmp_hash`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_calendars`;
CREATE TABLE IF NOT EXISTS `appscheduler_calendars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_dates`;
CREATE TABLE IF NOT EXISTS `appscheduler_dates` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) UNSIGNED DEFAULT NULL,
  `type` enum('calendar','employee') DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `all_day` enum('T','F') DEFAULT 'F',
  PRIMARY KEY (`id`),
  KEY `foreign_id` (`foreign_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `appscheduler_plugin_auth_users` ADD `calendar_id` int(10) unsigned DEFAULT NULL;
ALTER TABLE `appscheduler_plugin_auth_users` ADD `notes` text;
ALTER TABLE `appscheduler_plugin_auth_users` ADD `avatar` varchar(255) DEFAULT NULL;
ALTER TABLE `appscheduler_plugin_auth_users` ADD `is_subscribed` tinyint(1) unsigned DEFAULT '0';
ALTER TABLE `appscheduler_plugin_auth_users` ADD `is_subscribed_sms` tinyint(1) unsigned DEFAULT '0';

DROP TABLE IF EXISTS `appscheduler_employees_services`;
CREATE TABLE IF NOT EXISTS `appscheduler_employees_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(10) unsigned NOT NULL,
  `service_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`,`service_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_options`;
CREATE TABLE IF NOT EXISTS `appscheduler_options` (
  `foreign_id` int(10) unsigned NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL DEFAULT '',
  `tab_id` tinyint(3) unsigned DEFAULT NULL,
  `value` text,
  `label` text,
  `type` enum('string','text','int','float','enum','bool') NOT NULL DEFAULT 'string',
  `order` int(10) unsigned DEFAULT NULL,
  `is_visible` tinyint(1) unsigned DEFAULT '1',
  `style` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`foreign_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_services`;
CREATE TABLE IF NOT EXISTS `appscheduler_services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendar_id` int(10) unsigned DEFAULT NULL,
  `price` decimal(9,2) unsigned DEFAULT NULL,
  `length` smallint(5) unsigned DEFAULT NULL,
  `length_unit` enum('minute','hour') NOT NULL DEFAULT 'minute',
  `before` smallint(5) unsigned DEFAULT NULL,
  `before_unit` enum('minute','hour') NOT NULL DEFAULT 'minute',
  `after` smallint(5) unsigned DEFAULT NULL,
  `after_unit` enum('minute','hour') NOT NULL DEFAULT 'minute',
  `total` smallint(5) unsigned DEFAULT NULL,
  `total_unit` enum('minute','hour') NOT NULL DEFAULT 'minute',
  `image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `calendar_id` (`calendar_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `appscheduler_working_times`;
CREATE TABLE IF NOT EXISTS `appscheduler_working_times` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) unsigned DEFAULT NULL,
  `type` enum('calendar','employee') DEFAULT NULL,
  `monday_from` time DEFAULT NULL,
  `monday_to` time DEFAULT NULL,
  `monday_lunch_from` time DEFAULT NULL,
  `monday_lunch_to` time DEFAULT NULL,
  `monday_dayoff` enum('T','F') DEFAULT 'F',
  `tuesday_from` time DEFAULT NULL,
  `tuesday_to` time DEFAULT NULL,
  `tuesday_lunch_from` time DEFAULT NULL,
  `tuesday_lunch_to` time DEFAULT NULL,
  `tuesday_dayoff` enum('T','F') DEFAULT 'F',
  `wednesday_from` time DEFAULT NULL,
  `wednesday_to` time DEFAULT NULL,
  `wednesday_lunch_from` time DEFAULT NULL,
  `wednesday_lunch_to` time DEFAULT NULL,
  `wednesday_dayoff` enum('T','F') DEFAULT 'F',
  `thursday_from` time DEFAULT NULL,
  `thursday_to` time DEFAULT NULL,
  `thursday_lunch_from` time DEFAULT NULL,
  `thursday_lunch_to` time DEFAULT NULL,
  `thursday_dayoff` enum('T','F') DEFAULT 'F',
  `friday_from` time DEFAULT NULL,
  `friday_to` time DEFAULT NULL,
  `friday_lunch_from` time DEFAULT NULL,
  `friday_lunch_to` time DEFAULT NULL,
  `friday_dayoff` enum('T','F') DEFAULT 'F',
  `saturday_from` time DEFAULT NULL,
  `saturday_to` time DEFAULT NULL,
  `saturday_lunch_from` time DEFAULT NULL,
  `saturday_lunch_to` time DEFAULT NULL,
  `saturday_dayoff` enum('T','F') DEFAULT 'F',
  `sunday_from` time DEFAULT NULL,
  `sunday_to` time DEFAULT NULL,
  `sunday_lunch_from` time DEFAULT NULL,
  `sunday_lunch_to` time DEFAULT NULL,
  `sunday_dayoff` enum('T','F') DEFAULT 'F',
  PRIMARY KEY (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `appscheduler_calendars` (`id`, `user_id`) VALUES
(1, 1);

INSERT INTO `appscheduler_working_times` (`id`, `foreign_id`, `type`, `monday_from`, `monday_to`, `monday_lunch_from`, `monday_lunch_to`, `monday_dayoff`, `tuesday_from`, `tuesday_to`, `tuesday_lunch_from`, `tuesday_lunch_to`, `tuesday_dayoff`, `wednesday_from`, `wednesday_to`, `wednesday_lunch_from`, `wednesday_lunch_to`, `wednesday_dayoff`, `thursday_from`, `thursday_to`, `thursday_lunch_from`, `thursday_lunch_to`, `thursday_dayoff`, `friday_from`, `friday_to`, `friday_lunch_from`, `friday_lunch_to`, `friday_dayoff`, `saturday_from`, `saturday_to`, `saturday_lunch_from`, `saturday_lunch_to`, `saturday_dayoff`, `sunday_from`, `sunday_to`, `sunday_lunch_from`, `sunday_lunch_to`, `sunday_dayoff`) VALUES
(1, 1, 'calendar', '09:30:00', '18:30:00', '12:30:00', '13:30:00', 'F', '09:00:00', '18:00:00', '12:30:00', '13:30:00', 'F', '09:45:00', '17:30:00', '11:00:00', '12:00:00', 'F', '09:00:00', '18:00:00', '12:30:00', '13:30:00', 'F', '09:00:00', '18:00:00', '12:30:00', '13:30:00', 'F', NULL, NULL, NULL, NULL, 'T', NULL, NULL, NULL, NULL, 'T');

INSERT INTO `appscheduler_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_accept_bookings', 1, '1|0::1', NULL, 'bool', 1, 1, NULL),
(1, 'o_allow_bank', 2, '1|0::0', NULL, 'bool', 24, 1, NULL),
(1, 'o_allow_cash', 2, '1|0::0', NULL, 'bool', 25, 1, NULL),
(1, 'o_allow_creditcard', 2, '1|0::0', NULL, 'bool', 23, 1, NULL),
(1, 'o_bank_account', 2, 'Bank of America', NULL, 'text', 25, 1, NULL),
(1, 'o_bf_address_1', 3, '1|2|3::2', 'No|Yes|Yes (Required)', 'enum', 6, 1, NULL),
(1, 'o_bf_address_2', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 7, 1, NULL),
(1, 'o_bf_captcha', 3, '1|3::3', 'No|Yes (Required)', 'enum', 16, 1, NULL),
(1, 'o_bf_city', 3, '1|2|3::2', 'No|Yes|Yes (Required)', 'enum', 12, 1, NULL),
(1, 'o_bf_country', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 15, 1, NULL),
(1, 'o_bf_email', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 4, 1, NULL),
(1, 'o_bf_name', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 3, 1, NULL),
(1, 'o_bf_notes', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 8, 1, NULL),
(1, 'o_bf_phone', 3, '1|2|3::3', 'No|Yes|Yes (Required)', 'enum', 5, 1, NULL),
(1, 'o_bf_state', 3, '1|2|3::2', 'No|Yes|Yes (Required)', 'enum', 13, 1, NULL),
(1, 'o_bf_terms', 3, '1|3::3', 'No|Yes (Required)', 'enum', 17, 1, NULL),
(1, 'o_bf_zip', 3, '1|2|3::2', 'No|Yes|Yes (Required)', 'enum', 14, 1, NULL),
(1, 'o_deposit', 1, '20', NULL, 'float', 8, 1, NULL),
(1, 'o_deposit_type', 1, 'amount|percent::percent', 'Amount|Percent', 'enum', NULL, 0, NULL),
(1, 'o_disable_payments', 1, '1|0::0', NULL, 'bool', 7, 1, NULL),
(1, 'o_hide_prices', 1, '1|0::0', NULL, 'bool', 2, 1, NULL),
(1, 'o_layout', 1, '1|2::1', 'Layout 1|Layout 2', 'enum', 1, 1, NULL),
(1, 'o_reminder_body', 4, 'Dear {Name},<br/><br/>Your booking is coming soon!<br/><br/>Booking ID: {BookingID}<br/><br/>Services<br/>{Services}<br/><br/>Regards,<br/>The Management', NULL, 'text', 4, 1, 'height:350px'),
(1, 'o_reminder_email_enable', 4, '1|0::1', NULL, 'bool', 1, 1, NULL),
(1, 'o_reminder_email_before', 4, '10', NULL, 'int', 2, 1, NULL),
(1, 'o_reminder_subject', 4, 'Booking Reminder', NULL, 'string', 3, 1, NULL),
(1, 'o_reminder_sms_enable', 4, '1|0::0', NULL, 'bool', 4, 1, NULL),
(1, 'o_reminder_sms_hours', 4, '2', NULL, 'int', 5, 1, NULL),
(1, 'o_reminder_sms_message', 4, '{Name}, your booking is coming.', NULL, 'text', 6, 1, 'height:200px'),
(1, 'o_seo_url', 1, '1|0::1', NULL, 'bool', 12, 1, NULL),
(1, 'o_status_if_not_paid', 1, 'confirmed|pending::pending', 'Confirmed|Pending', 'enum', 3, 1, NULL),
(1, 'o_status_if_paid', 1, 'confirmed|pending::confirmed', 'Confirmed|Pending', 'enum', 2, 1, NULL),
(1, 'o_step', 1, '5|10|15|20|25|30|35|40|45|50|55|60::30', NULL, 'enum', 1, 1, NULL),
(1, 'o_tax', 1, '10', NULL, 'float', 9, 1, NULL),
(1, 'o_thankyou_page', 1, 'https://www.phpjabbers.com/', NULL, 'string', 10, 1, NULL),
(1, 'o_week_numbers', 1, '1|0::1', NULL, 'bool', 11, 1, NULL);

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'user', 'backend', 'Username', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Username', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pass', 'backend', 'Password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'email', 'backend', 'E-Mail', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'url', 'backend', 'URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'URL', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'created', 'backend', 'Created', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'DateTime', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnSave', 'backend', 'Save', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Save', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnReset', 'backend', 'Reset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reset', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'addLocale', 'backend', 'Add language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add language', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuLang', 'backend', 'Menu Multi lang', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Multi Lang', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuPlugins', 'backend', 'Menu Plugins', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Plugins', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuUsers', 'backend', 'Menu Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuSchedule', 'backend', 'Menu Schedule', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Schedule', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuOptions', 'backend', 'Menu Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuLogout', 'backend', 'Menu Logout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Logout', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnUpdate', 'backend', 'Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblChoose', 'backend', 'Choose', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnSearch', 'backend', 'Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Search', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'backend', 'backend', 'Backend titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back-end titles', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'frontend', 'backend', 'Front-end titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Front-end titles', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'locales', 'backend', 'Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'adminLogin', 'backend', 'Admin Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin Login', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnLogin', 'backend', 'Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Login', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuDashboard', 'backend', 'Menu Dashboard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblOptionList', 'backend', 'Option list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Option list', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnAdd', 'backend', 'Button Add', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblDelete', 'backend', 'Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblType', 'backend', 'Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblName', 'backend', 'Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblRole', 'backend', 'Role', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Role', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblStatus', 'backend', 'Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblIsActive', 'backend', 'Is Active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is confirmed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblUpdateUser', 'backend', 'Update user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update user', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblAddUser', 'backend', 'Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblValue', 'backend', 'Value', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Value', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblOption', 'backend', 'Option', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Option', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblDays', 'backend', 'Days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'days', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuLocales', 'backend', 'Menu Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblYes', 'backend', 'Yes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblNo', 'backend', 'No', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblError', 'backend', 'Error', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Error', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnBack', 'backend', 'Button Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '&laquo; Back', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnCancel', 'backend', 'Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Forgot password', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'adminForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnSend', 'backend', 'Button Send', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'emailForgotSubject', 'backend', 'Email / Forgot Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'emailForgotBody', 'backend', 'Email / Forgot Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dear {Name},Your password: {Password}', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuProfile', 'backend', 'Menu Profile', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Profile', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesTitle', 'backend', 'Infobox / Locales Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesBody', 'backend', 'Infobox / Locales Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendTitle', 'backend', 'Infobox / Locales Backend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Backend Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendBody', 'backend', 'Infobox / Locales Backend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Backend Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendTitle', 'backend', 'Infobox / Locales Frontend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Frontend Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendBody', 'backend', 'Infobox / Locales Frontend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Frontend Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingPricesTitle', 'backend', 'Infobox / Listing Prices Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Prices Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingPricesBody', 'backend', 'Infobox / Listing Prices Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Prices Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingBookingsTitle', 'backend', 'Infobox / Listing Bookings Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Bookings Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingBookingsBody', 'backend', 'Infobox / Listing Bookings Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Bookings Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingContactTitle', 'backend', 'Infobox / Listing Contact Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Contact Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingContactBody', 'backend', 'Infobox / Listing Contact Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Contact Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingAddressTitle', 'backend', 'Infobox / Listing Address Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Address Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingAddressBody', 'backend', 'Infobox / Listing Address Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Listing Address Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingExtendTitle', 'backend', 'Infobox / Extend exp.date Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extend exp.date Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoListingExtendBody', 'backend', 'Infobox / Extend exp.date Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Extend exp.date Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuBackup', 'backend', 'Menu Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnBackup', 'backend', 'Button Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblBackupDatabase', 'backend', 'Backup / Database', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup database', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblBackupFiles', 'backend', 'Backup / Files', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup files', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridChooseAction', 'backend', 'Grid / Choose Action', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose Action', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridGotoPage', 'backend', 'Grid / Go to page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Go to page:', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridTotalItems', 'backend', 'Grid / Total items', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total items:', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridItemsPerPage', 'backend', 'Grid / Items per page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Items per page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridPrevPage', 'backend', 'Grid / Prev page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Prev page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridPrev', 'backend', 'Grid / Prev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '&laquo; Prev', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridNextPage', 'backend', 'Grid / Next page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridNext', 'backend', 'Grid / Next', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next &raquo;', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridDeleteConfirmation', 'backend', 'Grid / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridConfirmationTitle', 'backend', 'Grid / Confirmation Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected record?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridActionTitle', 'backend', 'Grid / Action Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Action confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridBtnOk', 'backend', 'Grid / Button OK', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'OK', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridBtnCancel', 'backend', 'Grid / Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridBtnDelete', 'backend', 'Grid / Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridEmptyResult', 'backend', 'Grid / Empty resultset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No records found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'multilangTooltip', 'backend', 'MultiLang / Tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblIp', 'backend', 'IP address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblUserCreated', 'backend', 'User / Registration Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Registration date/time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_T', 'arrays', 'u_statarr_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_F', 'arrays', 'u_statarr_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_active', 'arrays', 'filter_ARRAY_active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_inactive', 'arrays', 'filter_ARRAY_inactive', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_T', 'arrays', '_yesno_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_F', 'arrays', '_yesno_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mr', 'arrays', 'personal_titles_ARRAY_mr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mr.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mrs', 'arrays', 'personal_titles_ARRAY_mrs', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mrs.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_miss', 'arrays', 'personal_titles_ARRAY_miss', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Miss', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_ms', 'arrays', 'personal_titles_ARRAY_ms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Ms.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_dr', 'arrays', 'personal_titles_ARRAY_dr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dr.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_prof', 'arrays', 'personal_titles_ARRAY_prof', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Prof.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_rev', 'arrays', 'personal_titles_ARRAY_rev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Rev.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_other', 'arrays', 'personal_titles_ARRAY_other', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Other', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-43200', 'arrays', 'timezones_ARRAY_-43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-12:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-39600', 'arrays', 'timezones_ARRAY_-39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-11:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-36000', 'arrays', 'timezones_ARRAY_-36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-10:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-32400', 'arrays', 'timezones_ARRAY_-32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-09:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-28800', 'arrays', 'timezones_ARRAY_-28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-08:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-25200', 'arrays', 'timezones_ARRAY_-25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-07:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-21600', 'arrays', 'timezones_ARRAY_-21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-06:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-18000', 'arrays', 'timezones_ARRAY_-18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-05:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-14400', 'arrays', 'timezones_ARRAY_-14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-04:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-10800', 'arrays', 'timezones_ARRAY_-10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-03:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-7200', 'arrays', 'timezones_ARRAY_-7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-02:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-3600', 'arrays', 'timezones_ARRAY_-3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT-01:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_0', 'arrays', 'timezones_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_3600', 'arrays', 'timezones_ARRAY_3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+01:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_7200', 'arrays', 'timezones_ARRAY_7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+02:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_10800', 'arrays', 'timezones_ARRAY_10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+03:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_14400', 'arrays', 'timezones_ARRAY_14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+04:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_18000', 'arrays', 'timezones_ARRAY_18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+05:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_21600', 'arrays', 'timezones_ARRAY_21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+06:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_25200', 'arrays', 'timezones_ARRAY_25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+07:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_28800', 'arrays', 'timezones_ARRAY_28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+08:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_32400', 'arrays', 'timezones_ARRAY_32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+09:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_36000', 'arrays', 'timezones_ARRAY_36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+10:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_39600', 'arrays', 'timezones_ARRAY_39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+11:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_43200', 'arrays', 'timezones_ARRAY_43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+12:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_46800', 'arrays', 'timezones_ARRAY_46800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'GMT+13:00', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU01', 'arrays', 'error_titles_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU03', 'arrays', 'error_titles_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User added!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU04', 'arrays', 'error_titles_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User failed to add.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU08', 'arrays', 'error_titles_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User not found.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO01', 'arrays', 'error_titles_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Options updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB01', 'arrays', 'error_titles_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB02', 'arrays', 'error_titles_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup complete!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB03', 'arrays', 'error_titles_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB04', 'arrays', 'error_titles_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA10', 'arrays', 'error_titles_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Account not found!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA11', 'arrays', 'error_titles_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password send!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA12', 'arrays', 'error_titles_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password not send!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA13', 'arrays', 'error_titles_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Profile updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU01', 'arrays', 'error_bodies_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU03', 'arrays', 'error_bodies_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU04', 'arrays', 'error_bodies_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We are sorry, but the user has not been added.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU08', 'arrays', 'error_bodies_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'User your looking for is missing.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO01', 'arrays', 'error_bodies_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to options have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ALC01', 'arrays', 'error_bodies_ARRAY_ALC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to titles have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB01', 'arrays', 'error_bodies_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc at ligula non arcu dignissim pretium. Praesent in magna nulla, in porta leo.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB02', 'arrays', 'error_bodies_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All backup files have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB03', 'arrays', 'error_bodies_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No option was selected.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB04', 'arrays', 'error_bodies_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Backup not performed.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA10', 'arrays', 'error_bodies_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Given email address is not associated with any account.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA11', 'arrays', 'error_bodies_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'For further instructions please check your mailbox.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA12', 'arrays', 'error_bodies_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We''re sorry, please try again later.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA13', 'arrays', 'error_bodies_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to your profile have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_1', 'arrays', 'months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'January', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_2', 'arrays', 'months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'February', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_3', 'arrays', 'months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'March', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_4', 'arrays', 'months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'April', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_5', 'arrays', 'months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_6', 'arrays', 'months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'June', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_7', 'arrays', 'months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'July', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_8', 'arrays', 'months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'August', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_9', 'arrays', 'months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'September', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_10', 'arrays', 'months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'October', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_11', 'arrays', 'months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'November', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'months_ARRAY_12', 'arrays', 'months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'December', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_0', 'arrays', 'days_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sunday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_1', 'arrays', 'days_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Monday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_2', 'arrays', 'days_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tuesday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_3', 'arrays', 'days_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wednesday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_4', 'arrays', 'days_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Thursday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_5', 'arrays', 'days_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Friday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'days_ARRAY_6', 'arrays', 'days_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Saturday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_0', 'arrays', 'day_names_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_1', 'arrays', 'day_names_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'M', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_2', 'arrays', 'day_names_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_3', 'arrays', 'day_names_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'W', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_4', 'arrays', 'day_names_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_5', 'arrays', 'day_names_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'F', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_6', 'arrays', 'day_names_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_1', 'arrays', 'short_months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jan', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_2', 'arrays', 'short_months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Feb', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_3', 'arrays', 'short_months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mar', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_4', 'arrays', 'short_months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Apr', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_5', 'arrays', 'short_months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_6', 'arrays', 'short_months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jun', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_7', 'arrays', 'short_months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jul', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_8', 'arrays', 'short_months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Aug', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_9', 'arrays', 'short_months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sep', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_10', 'arrays', 'short_months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Oct', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_11', 'arrays', 'short_months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Nov', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_12', 'arrays', 'short_months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dec', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_1', 'arrays', 'status_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You are not loged in.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_2', 'arrays', 'status_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Access denied. You have not requisite rights to.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_3', 'arrays', 'status_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Empty resultset.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_7', 'arrays', 'status_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The operation is not allowed in demo mode.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_123', 'arrays', 'status_ARRAY_123', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your hosting account does not allow uploading such a large image.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_999', 'arrays', 'status_ARRAY_999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No permisions to edit the property', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_998', 'arrays', 'status_ARRAY_998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No permisions to edit the reservation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_997', 'arrays', 'status_ARRAY_997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No reservation found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_996', 'arrays', 'status_ARRAY_996', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No property for the reservation found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9999', 'arrays', 'status_ARRAY_9999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your registration was successfull.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9998', 'arrays', 'status_ARRAY_9998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your registration was successfull. Your account needs to be approved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9997', 'arrays', 'status_ARRAY_9997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'E-Mail address already exist', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_1', 'arrays', 'login_err_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong username or password', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_2', 'arrays', 'login_err_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Access denied', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_3', 'arrays', 'login_err_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Account is disabled', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'localeArrays', 'backend', 'Locale / Arrays titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Arrays titles', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysTitle', 'backend', 'Locale / Languages Array Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Arrays Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysBody', 'backend', 'Locale / Languages Array Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Languages Array Body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lnkBack', 'backend', 'Link Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'locale_order', 'backend', 'Locale / Order', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Order', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'locale_is_default', 'backend', 'Locale / Is default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is default', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'locale_flag', 'backend', 'Locale / Flag', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Flag', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'locale_title', 'backend', 'Locale / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnDelete', 'backend', 'Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnContinue', 'backend', 'Button Continue', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Continue', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'vr_email_taken', 'backend', 'Users / Email already taken', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email address is already in use', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'revert_status', 'backend', 'Revert status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblExport', 'backend', 'Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuServices', 'backend', 'Menu Services', 'script', '2013-09-16 09:50:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuEmployees', 'backend', 'Menu Employees', 'script', '2013-09-16 09:51:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_add', 'backend', 'Services / Add service', 'script', '2013-09-16 12:44:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblAll', 'backend', 'All', 'script', '2013-09-16 12:47:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_name', 'backend', 'Services / Name', 'script', '2013-11-22 09:45:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service name', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_price', 'backend', 'Services / Price', 'script', '2013-09-16 12:52:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_before', 'backend', 'Services / Before', 'script', '2013-09-16 12:53:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Before', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_after', 'backend', 'Services / After', 'script', '2013-09-16 12:53:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'After', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_total', 'backend', 'Services / Total', 'script', '2013-09-16 12:53:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_length', 'backend', 'Services / Length', 'script', '2013-09-16 12:53:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Length', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_desc', 'backend', 'Services / Description', 'script', '2013-09-16 12:54:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service description', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_status', 'backend', 'Services / Status', 'script', '2013-09-16 12:56:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_employees', 'backend', 'Services / Employees', 'script', '2013-09-16 12:59:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_update', 'backend', 'Services / Update service', 'script', '2013-09-16 13:21:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'is_active_ARRAY_1', 'arrays', 'is_active_ARRAY_1', 'script', '2013-09-16 13:42:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'is_active_ARRAY_0', 'arrays', 'is_active_ARRAY_0', 'script', '2013-09-16 13:43:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'delete_selected', 'backend', 'Grid / Delete selected', 'script', '2013-09-16 14:10:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'delete_confirmation', 'backend', 'Grid / Confirmation Title', 'script', '2013-09-16 14:09:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected records?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS08', 'arrays', 'error_bodies_ARRAY_AS08', 'script', '2013-09-16 14:11:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service your are looking for is missing.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS01', 'arrays', 'error_titles_ARRAY_AS01', 'script', '2013-09-16 14:11:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS03', 'arrays', 'error_titles_ARRAY_AS03', 'script', '2013-09-16 14:11:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service added!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS04', 'arrays', 'error_titles_ARRAY_AS04', 'script', '2013-09-16 14:11:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service failed to add.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS08', 'arrays', 'error_titles_ARRAY_AS08', 'script', '2013-09-16 14:11:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service not found.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS01', 'arrays', 'error_bodies_ARRAY_AS01', 'script', '2013-09-16 14:11:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this service have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS03', 'arrays', 'error_bodies_ARRAY_AS03', 'script', '2013-09-16 14:12:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this service have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS04', 'arrays', 'error_bodies_ARRAY_AS04', 'script', '2013-09-16 14:12:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We are sorry, but the service has not been added.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS09', 'arrays', 'error_titles_ARRAY_AS09', 'script', '2013-09-16 14:15:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add a service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS09', 'arrays', 'error_bodies_ARRAY_AS09', 'script', '2013-11-22 09:45:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new service. You can add title, description, price, length and employees who do this service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS10', 'arrays', 'error_bodies_ARRAY_AS10', 'script', '2013-11-22 09:49:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the form below to modify the service. You can change title, description, price, length and employees who do this service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS10', 'arrays', 'error_titles_ARRAY_AS10', 'script', '2013-09-16 14:15:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update a service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_add', 'backend', 'Employees / Add employee', 'script', '2013-09-16 14:20:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_name', 'backend', 'Employees / Employee Name', 'script', '2013-11-22 09:51:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee name', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_email', 'backend', 'Employees / Email', 'script', '2013-09-16 14:24:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_phone', 'backend', 'Employees / Phone', 'script', '2013-09-16 14:24:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_company', 'backend', 'Employees / Company', 'script', '2013-09-16 14:24:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Company', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_services', 'backend', 'Employees / Services', 'script', '2013-09-16 14:27:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_status', 'backend', 'Employees / Status', 'script', '2013-09-16 14:28:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_update', 'backend', 'Employees / Update employee', 'script', '2013-09-16 14:37:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE09', 'arrays', 'error_titles_ARRAY_AE09', 'script', '2013-09-16 14:39:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add an employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE10', 'arrays', 'error_titles_ARRAY_AE10', 'script', '2013-09-16 14:39:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update an employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE10', 'arrays', 'error_bodies_ARRAY_AE10', 'script', '2013-11-22 09:53:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the form below to update employee''s details. You can select the service that this employee does. You can also configure it so an email and/or sms notification is sent to the employee when a booking is made. Each employee can access the Appointment Scheduler and manage his/her bookings only.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE09', 'arrays', 'error_bodies_ARRAY_AE09', 'script', '2013-11-22 09:52:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new employee. You can select the service that this employee does. You can also configure it so an email and/or sms notification is sent to the employee when a booking is made. Each employee can access the Appointment Scheduler and manage his/her bookings only.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_notes', 'backend', 'Employees / Notes', 'script', '2013-09-16 14:39:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_is_subscribed', 'backend', 'Employees / Send email', 'script', '2013-09-17 06:14:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send email when new booking is made', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_password', 'backend', 'Employees / Password', 'script', '2013-09-17 06:17:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE01', 'arrays', 'error_bodies_ARRAY_AE01', 'script', '2013-09-17 06:21:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this employee have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE01', 'arrays', 'error_titles_ARRAY_AE01', 'script', '2013-09-17 06:21:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE03', 'arrays', 'error_titles_ARRAY_AE03', 'script', '2013-09-17 06:22:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee added!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE03', 'arrays', 'error_bodies_ARRAY_AE03', 'script', '2013-09-17 06:22:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to this employee have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE08', 'arrays', 'error_bodies_ARRAY_AE08', 'script', '2013-09-17 06:24:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee your are looking for is missing.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE08', 'arrays', 'error_titles_ARRAY_AE08', 'script', '2013-09-17 06:24:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee not found.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE04', 'arrays', 'error_titles_ARRAY_AE04', 'script', '2013-09-17 06:26:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee failed to add.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE04', 'arrays', 'error_bodies_ARRAY_AE04', 'script', '2013-09-17 06:26:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We are sorry, but the employee has not been added.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_last_login', 'backend', 'Employees / Last login', 'script', '2013-09-17 06:29:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last login', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuTime', 'backend', 'Menu Working Time', 'script', '2013-09-17 06:50:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT01', 'arrays', 'error_titles_ARRAY_AT01', 'script', '2013-09-17 07:25:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT01', 'arrays', 'error_bodies_ARRAY_AT01', 'script', '2013-09-17 07:25:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to working time have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT02', 'arrays', 'error_titles_ARRAY_AT02', 'script', '2013-09-17 07:26:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time saved!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT02', 'arrays', 'error_bodies_ARRAY_AT02', 'script', '2013-09-17 07:26:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to custom working time have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT03', 'arrays', 'error_titles_ARRAY_AT03', 'script', '2013-09-17 07:26:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT03', 'arrays', 'error_bodies_ARRAY_AT03', 'script', '2013-09-17 07:26:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to custom working time have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT04', 'arrays', 'error_titles_ARRAY_AT04', 'script', '2013-09-17 07:45:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT04', 'arrays', 'error_bodies_ARRAY_AT04', 'script', '2013-12-12 18:48:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Different working time can be set for each day of the week. You can also set days off and a lunch break. Under Edit Employee page you can set up custom working time for each of your employees.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_update_custom', 'backend', 'Working Time / Update custom', 'script', '2013-09-17 07:47:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update custom', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_default', 'backend', 'Working Time / Default', 'script', '2013-09-17 08:42:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_custom', 'backend', 'Working Time / Custom', 'script', '2013-09-17 07:47:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_day', 'backend', 'Working Time / Day of week', 'script', '2013-09-17 07:48:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day of week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_from', 'backend', 'Working Time / Start Time', 'script', '2013-09-17 07:48:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_to', 'backend', 'Working Time / End Time', 'script', '2013-09-17 07:48:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_is', 'backend', 'Working Time / Is Day off', 'script', '2013-09-17 07:48:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Is Day off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_date', 'backend', 'Working Time / Date', 'script', '2013-09-17 07:49:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_general', 'backend', 'Employees / General', 'script', '2013-09-17 08:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'General', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_default_wt', 'backend', 'Working Time / Default Working Time', 'script', '2013-09-17 08:42:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_custom_wt', 'backend', 'Working Time / Custom Working Time', 'script', '2013-09-17 08:42:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_lunch_from', 'backend', 'Working Time / Lunch from', 'script', '2013-09-17 10:28:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch from', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_lunch_to', 'backend', 'Working Time / Lunch to', 'script', '2013-09-17 10:29:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch to', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuInstall', 'backend', 'Menu Install', 'script', '2013-09-18 06:04:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuPreview', 'backend', 'Menu Preview', 'script', '2013-09-18 06:04:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuBookings', 'backend', 'Menu Bookings', 'script', '2013-09-18 06:05:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuGeneral', 'backend', 'Menu General', 'script', '2013-09-18 06:17:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'General', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuPayments', 'backend', 'Menu Payments', 'script', '2013-09-18 06:18:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuBookingForm', 'backend', 'Menu Booking form', 'script', '2013-09-18 06:18:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking form', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuConfirmation', 'backend', 'Menu Confirmation', 'script', '2013-09-18 06:19:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuTerms', 'backend', 'Menu Terms', 'script', '2013-09-18 06:19:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_address_1', 'backend', 'Options / Address 1', 'script', '2013-09-18 06:31:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address 1', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_captcha', 'backend', 'Options / Captcha', 'script', '2013-09-18 06:31:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_city', 'backend', 'Options / City', 'script', '2013-09-18 06:31:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_email', 'backend', 'Options / Email', 'script', '2013-09-18 06:32:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_name', 'backend', 'Options / Name', 'script', '2013-09-18 06:32:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_notes', 'backend', 'Options / Notes', 'script', '2013-09-18 06:32:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_phone', 'backend', 'Options / Phone ', 'script', '2013-09-18 06:33:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_state', 'backend', 'Options / State', 'script', '2013-09-18 06:33:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_terms', 'backend', 'Options / Terms', 'script', '2013-09-18 06:33:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_zip', 'backend', 'Options / Zip', 'script', '2013-09-18 06:34:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_country', 'backend', 'Options / Country', 'script', '2013-09-18 06:34:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_paypal_address', 'backend', 'Options / Paypal address', 'script', '2013-09-18 06:35:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paypal address', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_accept_bookings', 'backend', 'Options / Accept Bookings', 'script', '2013-09-18 06:35:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Accept Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_allow_authorize', 'backend', 'Options / Allow Authorize.net', 'script', '2013-09-18 06:36:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Allow payments with Authorize.net', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_allow_bank', 'backend', 'Options / Allow Bank', 'script', '2013-11-22 10:06:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Provide Bank account details for wire transfers', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_allow_cash', 'backend', 'Options / Allow payments with cash', 'script', '2013-11-22 10:06:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Allow payment with cash', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_allow_creditcard', 'backend', 'Options / Allow Credit Card', 'script', '2013-11-22 10:06:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Collect Credit Card details for offline processing', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_allow_paypal', 'backend', 'Options / Allow Paypal', 'script', '2013-09-18 06:37:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Allow payments with PayPal', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_key', 'backend', 'Options / Authorize.net transaction key', 'script', '2013-09-18 06:37:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net transaction key', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_mid', 'backend', 'Options / Authorize.net merchant ID', 'script', '2013-09-18 06:38:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net merchant ID', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bank_account', 'backend', 'Options / Bank account', 'script', '2013-09-18 06:38:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_deposit', 'backend', 'Options / Deposit', 'script', '2013-11-22 10:08:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set deposit amount to be collected for each appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_disable_payments', 'backend', 'Options / Disable payments', 'script', '2013-11-22 10:07:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Check if you want to disable payments and only collect reservation details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_status_if_not_paid', 'backend', 'Options / Default status for booked dates if not paid', 'script', '2013-09-18 06:40:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default status for booked dates if not paid', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_status_if_paid', 'backend', 'Options / Default status for booked dates if paid', 'script', '2013-09-18 06:40:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default status for booked dates if paid', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_tax', 'backend', 'Options / Tax payment', 'script', '2013-11-22 10:09:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax amount to be collected for each appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page', 'backend', 'Options / "Thank you" page location', 'script', '2013-11-22 10:06:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'URL for the web page where your clients will be redirected after PayPal or Authorize.net payment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_tz', 'backend', 'Options / Authorize.net Time zone', 'script', '2013-09-18 06:41:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net time zone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_email_new_reservation', 'backend', 'Options / New booking received', 'script', '2013-09-18 06:41:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New reservation received', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_email_reservation_cancelled', 'backend', 'Options / Booking cancelled', 'script', '2013-09-18 06:41:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reservation cancelled', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_email_password_reminder', 'backend', 'Notifications / Password reminder', 'script', '2013-09-18 06:42:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_bf_address_2', 'backend', 'Options / Address 2', 'script', '2013-09-18 06:42:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address 2', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_datetime_format', 'backend', 'Options / Datetime format', 'script', '2013-09-18 06:42:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time format', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_hash', 'backend', 'Options / Authorize.net hash value', 'script', '2013-09-18 06:42:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Authorize.net hash value', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_subject', 'backend', 'Confirmation / Email subject', 'script', '2013-09-18 06:51:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_body', 'backend', 'Confirmation / Email body', 'script', '2013-09-18 06:51:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_client_confirmation', 'backend', 'Confirmation / Client confirmation title', 'script', '2013-09-18 06:51:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_client_payment', 'backend', 'Confirmation / Client payment title', 'script', '2013-09-18 06:52:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_admin_confirmation', 'backend', 'Confirmation / Admin confirmation title', 'script', '2013-09-18 06:52:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_admin_payment', 'backend', 'Confirmation / Admin payment title', 'script', '2013-09-18 06:52:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblOptionsTermsURL', 'backend', 'Options / Booking terms URL', 'script', '2013-09-18 06:53:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking terms URL', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblOptionsTermsContent', 'backend', 'Options / Booking terms content', 'script', '2013-09-18 06:54:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking terms content', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_add', 'backend', 'Bookings / Add booking', 'script', '2013-09-18 06:57:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_confirmed', 'arrays', 'Bookings / Status: confirmed', 'script', '2013-09-18 06:58:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_pending', 'arrays', 'Bookings / Status: pending', 'script', '2013-09-18 06:58:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_cancelled', 'arrays', 'Bookings / Status: cancelled', 'script', '2013-09-18 06:58:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancelled', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_uuid', 'backend', 'Bookings / Unique ID', 'script', '2013-09-18 06:59:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Unique ID', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_status', 'backend', 'Bookings / Status', 'script', '2013-09-18 06:59:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_update', 'backend', 'Bookings / Update booking', 'script', '2013-09-18 06:59:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_exp', 'backend', 'Bookings / CC Exp.date', 'script', '2013-09-18 07:10:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Exp.date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_code', 'backend', 'Bookings / CC Code', 'script', '2013-09-18 07:10:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Code', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_num', 'backend', 'Bookings / CC Number', 'script', '2013-09-18 07:10:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Number', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_type', 'backend', 'Bookings / CC Type', 'script', '2013-09-18 07:11:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_types_ARRAY_maestro', 'arrays', 'booking_cc_types_ARRAY_maestro', 'script', '2013-09-18 07:11:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Maestro', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_types_ARRAY_amex', 'arrays', 'booking_cc_types_ARRAY_amex', 'script', '2013-09-18 07:11:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'AmericanExpress', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_types_ARRAY_mastercard', 'arrays', 'booking_cc_types_ARRAY_mastercard', 'script', '2013-09-18 07:17:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'MasterCard', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_cc_types_ARRAY_visa', 'arrays', 'booking_cc_types_ARRAY_visa', 'script', '2013-09-18 07:17:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Visa', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_phone', 'backend', 'Bookings / Phone', 'script', '2013-09-18 07:18:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_email', 'backend', 'Bookings / Email', 'script', '2013-09-18 07:18:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_invoice_details', 'backend', 'Bookings / Invoice details', 'script', '2013-09-18 07:18:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Invoice details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_create_invoice', 'backend', 'Bookings / Create Invoice', 'script', '2013-09-18 07:35:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Create Invoice', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_customer', 'backend', 'Bookings / Customer details', 'script', '2013-09-18 07:35:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_notes', 'backend', 'Bookings / Notes', 'script', '2013-09-18 07:35:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_address_2', 'backend', 'Bookings / Address Line 2', 'script', '2013-09-18 07:36:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_address_1', 'backend', 'Bookings / Address Line 1', 'script', '2013-09-18 07:36:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 1', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_name', 'backend', 'Bookings / Name', 'script', '2013-09-18 07:36:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_zip', 'backend', 'Bookings / Zip', 'script', '2013-09-18 07:36:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_city', 'backend', 'Bookings / City', 'script', '2013-09-18 07:37:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_state', 'backend', 'Bookings / State', 'script', '2013-09-18 07:37:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_country', 'backend', 'Bookings / Country', 'script', '2013-09-18 07:37:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_tab_client', 'backend', 'Bookings / Client', 'script', '2013-09-18 07:37:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_tab_details', 'backend', 'Bookings / Booking', 'script', '2013-09-18 07:37:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_general', 'backend', 'Bookings / Details', 'script', '2013-09-18 07:38:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_choose', 'backend', 'Bookings / Choose', 'script', '2013-09-18 07:38:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '-- Choose --', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_payment_method', 'backend', 'Bookings / Payment method', 'script', '2013-09-18 07:38:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment method', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_price', 'backend', 'Bookings / Price', 'script', '2013-09-18 07:38:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_tax', 'backend', 'Bookings / Tax', 'script', '2013-09-18 07:39:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_deposit', 'backend', 'Bookings / Deposit', 'script', '2013-09-18 07:47:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deposit', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_total', 'backend', 'Bookings / Total', 'script', '2013-09-18 07:47:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_created', 'backend', 'Bookings / Created', 'script', '2013-09-18 07:47:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Created', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_bank', 'arrays', 'payment_methods_ARRAY_bank', 'script', '2013-09-18 07:55:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_creditcard', 'arrays', 'payment_methods_ARRAY_creditcard', 'script', '2013-09-18 07:55:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Credit card', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_paypal', 'arrays', 'payment_methods_ARRAY_paypal', 'script', '2013-09-18 07:55:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Paypal', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO24', 'arrays', 'error_titles_ARRAY_AO24', 'script', '2013-09-18 08:44:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking form', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO25', 'arrays', 'error_titles_ARRAY_AO25', 'script', '2013-09-18 08:44:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO26', 'arrays', 'error_titles_ARRAY_AO26', 'script', '2013-09-18 08:44:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO24', 'arrays', 'error_bodies_ARRAY_AO24', 'script', '2013-09-18 08:45:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose the fields that should be available on the booking form.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO25', 'arrays', 'error_bodies_ARRAY_AO25', 'script', '2013-12-12 19:55:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email notifications will be sent to people who make a booking after the booking form is completed or/and payment is made. If you leave subject field blank no email will be sent.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO26', 'arrays', 'error_bodies_ARRAY_AO26', 'script', '2013-09-18 08:45:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter booking terms and conditions. You can also include a link to external web page where your terms and conditions page is.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO27', 'arrays', 'error_bodies_ARRAY_AO27', 'script', '2013-11-22 10:10:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set different payment options for your Appointment Scheduler software. Enable or disable the available payment processing companies.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO27', 'arrays', 'error_titles_ARRAY_AO27', 'script', '2013-09-18 08:47:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking payment options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO23', 'arrays', 'error_bodies_ARRAY_AO23', 'script', '2013-11-22 10:05:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can set some general options about the booking process.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO23', 'arrays', 'error_titles_ARRAY_AO23', 'script', '2013-09-18 08:48:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO21', 'arrays', 'error_bodies_ARRAY_AO21', 'script', '2013-09-18 08:48:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set-up general settings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO21', 'arrays', 'error_titles_ARRAY_AO21', 'script', '2013-09-18 08:48:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'General options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_hide_prices', 'backend', 'Options / Hide prices', 'script', '2013-09-18 08:53:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Hide prices', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_step', 'backend', 'Options / Step', 'script', '2013-09-18 08:54:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step (in minutes)', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_services', 'backend', 'Bookings / Services', 'script', '2013-09-18 09:04:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_avatar', 'backend', 'Employees / Picture', 'script', '2013-09-18 10:22:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_avatar_delete', 'backend', 'Employees / Delete picture', 'script', '2013-09-18 11:15:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete picture', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_avatar_dtitle', 'backend', 'Employees / Delete confirmation', 'script', '2013-09-18 11:23:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_avatar_dbody', 'backend', 'Employees / Delete content', 'script', '2013-09-18 11:23:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete this picture?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_title', 'backend', 'Install / Title', 'script', '2013-09-18 13:30:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install instructions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_body', 'backend', 'Install / Body', 'script', '2013-09-18 13:30:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In order to install the script on your website copy the code below and add it to your web page.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_1', 'backend', 'Install / Step 1', 'script', '2013-09-18 13:30:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install Code', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_2', 'backend', 'Install / Step 2', 'script', '2013-09-18 13:30:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2 (Optional) - for SEO purposes and better ranking you need to put next meta tag into the HEAD part of your page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_3', 'backend', 'Install / Step 3', 'script', '2013-09-18 13:30:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 3 (Optional) - for SEO purposes and better ranking you need to create a .htaccess file (or update existing one) with data below. Put the file in the same folder as your webpage.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_seo_url', 'backend', 'Options / Seo URLs', 'script', '2013-09-19 09:30:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use SEO URLs', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_week_numbers', 'backend', 'Options / Show week numbers', 'script', '2013-09-20 09:29:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Show week numbers', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_captcha', 'frontend', 'Checkout / Captcha', 'script', '2013-10-03 12:41:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_select_country', 'frontend', 'Checkout / Select Country', 'script', '2013-10-03 12:41:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select Country', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_terms', 'frontend', 'Checkout / Terms', 'script', '2013-10-03 12:42:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'I agree with terms and conditions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_empty_notice', 'frontend', 'Checkout / Empty notice', 'script', '2013-10-03 12:42:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please go back to your basket.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_payment', 'frontend', 'Frontend / Select Payment method', 'script', '2013-10-03 12:43:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select Payment method', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_cc_type', 'frontend', 'Bookings / Select CC Type', 'script', '2013-10-03 12:44:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select CC Type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_employee', 'backend', 'Bookings / Employee', 'script', '2013-10-04 13:04:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service', 'backend', 'Bookings / Service', 'script', '2013-10-04 13:04:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_from', 'backend', 'Bookings / Date from', 'script', '2013-10-04 13:04:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_to', 'backend', 'Bookings / Date to', 'script', '2013-10-04 13:04:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_query', 'backend', 'Bookings / Query', 'script', '2013-10-04 13:22:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Query', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_date', 'backend', 'Bookings / Date', 'script', '2013-10-04 13:57:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_export', 'backend', 'Bookings / Export', 'script', '2013-10-07 06:19:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export selected', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_delimiter_ARRAY_comma', 'arrays', 'booking_delimiter_ARRAY_comma', 'script', '2013-10-07 07:13:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Comma', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_delimiter_ARRAY_semicolon', 'arrays', 'booking_delimiter_ARRAY_semicolon', 'script', '2013-10-07 07:13:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Semicolon', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_delimiter_ARRAY_tab', 'arrays', 'booking_delimiter_ARRAY_tab', 'script', '2013-10-07 07:14:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tab', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_format_ARRAY_csv', 'arrays', 'booking_delimiter_ARRAY_csv', 'script', '2013-10-07 07:15:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CSV', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_format_ARRAY_xml', 'arrays', 'booking_delimiter_ARRAY_xml', 'script', '2013-10-07 07:15:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'XML', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_format_ARRAY_ical', 'arrays', 'booking_delimiter_ARRAY_ical', 'script', '2013-10-07 07:15:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'iCal', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_delimiter_lbl', 'backend', 'Bookings / Delimiter', 'script', '2013-10-07 07:18:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delimiter', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_format_lbl', 'backend', 'Bookings / Format', 'script', '2013-10-07 07:18:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Format', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_na', 'backend', 'Bookings / Not available', 'script', '2013-10-07 09:33:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Not Available', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_export_title', 'backend', 'Bookings / Export bookings', 'script', '2013-10-07 09:35:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_dt', 'backend', 'Bookings / Date Time', 'script', '2013-10-07 09:48:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_employee', 'backend', 'Bookings / Service/Employee', 'script', '2013-10-07 09:48:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service/Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuReminder', 'backend', 'Menu Reminder', 'script', '2013-10-07 10:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_email_enable', 'backend', 'Options / Enable notifications', 'script', '2013-12-12 19:56:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enable Email reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_email_before', 'backend', 'Options / Send email reminder', 'script', '2013-12-12 19:58:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set number of hours before the booking start time when an email reminder will be sent', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_subject', 'backend', 'Options / Email Reminder subject', 'script', '2013-10-07 10:05:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email Reminder subject', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_sms_enable', 'backend', 'Options / Enable notifications', 'script', '2013-12-12 19:56:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enable SMS reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_sms_hours', 'backend', 'Options / Send SMS reminder', 'script', '2013-12-12 20:00:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set number of hours before the booking start time when an SMS reminder will be sent', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_sms_message', 'backend', 'Options / SMS message', 'script', '2013-12-12 20:00:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_body', 'backend', 'Options / Email Reminder body', 'script', '2013-12-12 19:58:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email Reminder body', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'get_key', 'backend', 'Options / Get key', 'script', '2013-10-07 10:42:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Get key', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO28', 'arrays', 'error_bodies_ARRAY_AO28', 'script', '2013-12-12 20:00:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can send email and sms reminders to your clients X hours before their booking.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO28', 'arrays', 'error_titles_ARRAY_AO28', 'script', '2013-10-07 10:44:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reminder options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK01', 'arrays', 'error_titles_ARRAY_ABK01', 'script', '2013-10-07 10:48:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking updated', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK01', 'arrays', 'error_bodies_ARRAY_ABK01', 'script', '2013-10-07 10:48:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to the booking has been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK08', 'arrays', 'error_titles_ARRAY_ABK08', 'script', '2013-10-07 10:49:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking not found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK08', 'arrays', 'error_bodies_ARRAY_ABK08', 'script', '2013-10-07 10:50:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sorry, but the booking you''re looking for is missing.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK03', 'arrays', 'error_titles_ARRAY_ABK03', 'script', '2013-10-07 10:50:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking added', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK03', 'arrays', 'error_bodies_ARRAY_ABK03', 'script', '2013-10-07 10:51:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The booking has been successfully added.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK04', 'arrays', 'error_titles_ARRAY_ABK04', 'script', '2013-10-07 10:51:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking not added', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK04', 'arrays', 'error_bodies_ARRAY_ABK04', 'script', '2013-10-07 10:51:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sorry, but the booking has not been added.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK10', 'arrays', 'error_bodies_ARRAY_ABK10', 'script', '2013-11-22 09:43:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below to add a new booking. Under Clients tab you can enter information about the client. ', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK10', 'arrays', 'error_titles_ARRAY_ABK10', 'script', '2013-10-07 10:52:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add a booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK11', 'arrays', 'error_titles_ARRAY_ABK11', 'script', '2013-10-07 10:53:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK11', 'arrays', 'error_bodies_ARRAY_ABK11', 'script', '2013-11-22 09:44:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the form below to enter details about your client.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK13', 'arrays', 'error_bodies_ARRAY_ABK13', 'script', '2013-10-07 10:54:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use form below to update client related data.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK13', 'arrays', 'error_titles_ARRAY_ABK13', 'script', '2013-10-07 10:54:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK12', 'arrays', 'error_bodies_ARRAY_ABK12', 'script', '2013-10-07 10:55:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use form below to update booking details.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK12', 'arrays', 'error_titles_ARRAY_ABK12', 'script', '2013-10-07 10:55:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking update', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO08', 'arrays', 'error_bodies_ARRAY_AO08', 'script', '2013-10-07 11:41:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to reminder have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO08', 'arrays', 'error_titles_ARRAY_AO08', 'script', '2013-10-07 11:41:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reminder updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO06', 'arrays', 'error_bodies_ARRAY_AO06', 'script', '2013-10-07 11:42:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to terms have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO06', 'arrays', 'error_titles_ARRAY_AO06', 'script', '2013-10-07 11:42:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO05', 'arrays', 'error_titles_ARRAY_AO05', 'script', '2013-10-07 11:42:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmation updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO05', 'arrays', 'error_bodies_ARRAY_AO05', 'script', '2013-10-07 11:42:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to confirmation have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO04', 'arrays', 'error_bodies_ARRAY_AO04', 'script', '2013-10-07 11:43:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to booking form have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO04', 'arrays', 'error_titles_ARRAY_AO04', 'script', '2013-10-07 11:43:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking form updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO07', 'arrays', 'error_titles_ARRAY_AO07', 'script', '2013-10-07 11:44:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment options updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO07', 'arrays', 'error_bodies_ARRAY_AO07', 'script', '2013-10-07 11:44:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to payment options have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO03', 'arrays', 'error_bodies_ARRAY_AO03', 'script', '2013-10-07 11:45:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All the changes made to booking options have been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO03', 'arrays', 'error_titles_ARRAY_AO03', 'script', '2013-10-07 11:45:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking options updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_recalc', 'backend', 'Bookings / Recalculate the price', 'script', '2013-10-07 14:34:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Recalculate the price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_add', 'backend', 'Bookings / Add service', 'script', '2013-10-07 14:35:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_add_title', 'backend', 'Bookings / Add service (title)', 'script', '2013-10-07 14:36:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_delete_title', 'backend', 'Bookings / Remove service (title)', 'script', '2013-10-07 14:38:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_delete_body', 'backend', 'Bookings / Remove service (body)', 'script', '2013-10-07 14:38:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure you want to delete selected service from the current booking?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_empty', 'frontend', 'Frontend / Cart is empty', 'script', '2013-10-07 15:10:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'There are not any selected services yet.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_total', 'frontend', 'Frontend / Total', 'script', '2013-10-07 15:10:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_selected_services', 'frontend', 'Frontend / Selected Services', 'script', '2013-10-07 15:10:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Selected Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_date', 'frontend', 'Frontend / Select a Date', 'script', '2013-10-07 15:10:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select a Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_make_appointment', 'frontend', 'Frontend / Make an Appointment', 'script', '2013-10-07 15:09:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Make an Appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_start_time', 'frontend', 'Frontend / Start time', 'script', '2013-10-07 15:09:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_end_time', 'frontend', 'Frontend / End time', 'script', '2013-10-07 15:10:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_services', 'frontend', 'Frontend / Select Services', 'script', '2013-10-07 15:11:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select service on', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_availability', 'frontend', 'Frontend / Availability', 'script', '2013-10-07 15:12:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Availability', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_form', 'frontend', 'Frontend / Booking Form', 'script', '2013-10-07 15:12:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Form', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_system_msg', 'frontend', 'Frontend / System message', 'script', '2013-10-07 15:13:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'System message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_checkout_na', 'frontend', 'Frontend / Checkout form not available', 'script', '2013-10-07 15:14:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout form not available', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_return_back', 'frontend', 'Frontend / Return back', 'script', '2013-10-07 15:14:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Return back', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_preview_form', 'frontend', 'Frontend / Booking Preview', 'script', '2013-10-07 15:15:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Preview', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_confirm_booking', 'frontend', 'Frontend / Confirm booking', 'script', '2013-10-07 15:16:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirm booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_preview_na', 'frontend', 'Frontend / Preview not available', 'script', '2013-10-07 15:16:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Preview not available', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA14', 'arrays', 'error_titles_ARRAY_AA14', 'script', '2013-10-09 09:00:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Invalid data', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA14', 'arrays', 'error_bodies_ARRAY_AA14', 'script', '2013-10-09 09:00:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sorry, submitted data not validate.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA15', 'arrays', 'error_titles_ARRAY_AA15', 'script', '2013-10-09 09:01:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Profile', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA15', 'arrays', 'error_bodies_ARRAY_AA15', 'script', '2013-10-09 09:02:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use form below to update your profile settings.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_ip', 'backend', 'Bookings / IP address', 'script', '2013-10-09 12:04:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_view_title', 'backend', 'Bookings / Booking Service details', 'script', '2013-10-09 12:11:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Service details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_email_title', 'backend', 'Bookings / Resend email (title)', 'script', '2013-10-09 12:51:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_service_sms_title', 'backend', 'Bookings / Resend SMS (title)', 'script', '2013-10-09 12:52:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_subject', 'backend', 'Bookings / Subject', 'script', '2013-10-09 13:36:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_message', 'backend', 'Bookings / Message', 'script', '2013-10-09 13:36:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuReports', 'backend', 'Menu Reports', 'script', '2013-10-09 14:30:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reports', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_menu_employees', 'backend', 'Reports / Employees menu', 'script', '2013-10-09 14:37:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_menu_services', 'backend', 'Reports / Services menu', 'script', '2013-10-09 14:37:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_bookings', 'backend', 'Reports / Bookings', 'script', '2013-10-09 14:50:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_total_bookings', 'backend', 'Reports / Total bookings', 'script', '2013-10-10 06:21:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_confirmed_bookings', 'backend', 'Reports / Confirmed bookings', 'script', '2013-10-10 06:22:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_pending_bookings', 'backend', 'Reports / Pending bookings', 'script', '2013-10-10 06:22:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_cancelled_bookings', 'backend', 'Reports / Cancelled bookings', 'script', '2013-10-10 06:22:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancelled Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_total_amount', 'backend', 'Reports / Total amount', 'script', '2013-10-10 06:23:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_confirmed_amount', 'backend', 'Reports / Confirmed Bookings Amount', 'script', '2013-10-10 06:23:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Confirmed Bookings Amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_pending_amount', 'backend', 'Reports / Pending Bookings Amount', 'script', '2013-10-10 06:24:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Pending Bookings Amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_cancelled_amount', 'backend', 'Reports / Cancelled Bookings Amount', 'script', '2013-10-10 06:24:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancelled Bookings Amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_columns', 'backend', 'Reports / Columns', 'script', '2013-10-10 11:55:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Columns', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_print', 'backend', 'Reports / Print', 'script', '2013-10-10 13:36:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_pdf', 'backend', 'Reports / Save as PDF', 'script', '2013-10-11 06:18:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Save as PDF', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menu', 'backend', 'Menu', 'script', '2013-11-11 09:22:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_view_bookings', 'backend', 'Employees / View bookings', 'script', '2013-11-11 09:23:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_working_time', 'backend', 'Employees / Working time', 'script', '2013-11-11 09:23:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS11', 'arrays', 'error_titles_ARRAY_AS11', 'script', '2013-11-11 09:46:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS11', 'arrays', 'error_bodies_ARRAY_AS11', 'script', '2013-11-22 09:44:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see the available services that your clients can book. Under Add service tab you can add a new service. Or use the edit icon for each service to modify it.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_tip_length', 'backend', 'Services / Length tooltip', 'script', '2013-11-22 09:46:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Specify the time needed to do this service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_tip_before', 'backend', 'Services / Before tooltip', 'script', '2013-11-22 09:47:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In case you need some time before the start time for the service you can add it here. For example if your service is 60 minutes long and you input 30 minutes here, then when someone books a service at 10am you will not be available for other bookings between 9:30am and 10am', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_tip_after', 'backend', 'Services / After tooltip', 'script', '2013-11-22 09:48:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'In case you need some time after the end time for the service you can add it here. For example if your service is 60 minutes long and you input 30 minutes here, then when someone books a service at 10am till 11am you will not be available for other bookings between 11am and 11:30am', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_tip_employees', 'backend', 'Services / Employees tooltip', 'script', '2013-11-11 10:05:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select employee(s) who can do this service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'employee_is_subscribed_sms', 'backend', 'Employees / Send sms', 'script', '2013-11-11 12:34:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send SMS when new booking is made', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_reminder_client', 'backend', 'Bookings / Send to client', 'script', '2013-11-11 12:58:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send to client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_reminder_employee', 'backend', 'Bookings / Send to employee', 'script', '2013-11-11 12:59:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send to employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_click_available', 'frontend', 'Frontend / Click on available time', 'script', '2013-11-12 08:29:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Click on available time to make an appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE11', 'arrays', 'error_titles_ARRAY_AE11', 'script', '2013-11-18 07:36:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE11', 'arrays', 'error_bodies_ARRAY_AE11', 'script', '2013-11-22 09:50:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see a list of employees who do the different service you offer. You can have one or multiple employees.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menuSeo', 'backend', 'Menu SEO', 'script', '2013-11-18 08:37:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SEO', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallConfig', 'backend', 'Install / Config', 'script', '2013-11-18 08:40:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Language options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallConfigLocale', 'backend', 'Install / Locale', 'script', '2013-11-18 08:40:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Language', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallConfigHide', 'backend', 'Install / Config hide', 'script', '2013-11-18 08:41:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Hide language selector', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO30', 'arrays', 'error_titles_ARRAY_AO30', 'script', '2013-11-18 08:45:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To better optimize your appointment scheduler please follow the steps below.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO30', 'arrays', 'error_titles_ARRAY_AO30', 'script', '2013-11-18 08:45:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SEO Optimization', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallSeo_1', 'backend', 'Install / SEO Step 1', 'script', '2013-11-18 08:46:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 1. Webpage where your front end appointment scheduler is', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallSeo_2', 'backend', 'Install / SEO Step 2', 'script', '2013-11-18 08:47:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 2. Put the meta tag below between &lt;head&gt; and &lt;/head&gt; tags on your web page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallSeo_3', 'backend', 'Install / SEO Step 3', 'script', '2013-11-18 08:47:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 3. (SAME DOMAIN INSTALL ONLY) Create .htaccess file (or update existing one) in the folder where your web page is and put the data below in it', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnGenerate', 'backend', 'Generate', 'script', '2013-11-18 10:11:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Generate', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_index', 'backend', 'Bookings / Index', 'script', '2013-11-18 10:31:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Index', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR01', 'arrays', 'error_titles_ARRAY_AR01', 'script', '2013-11-19 07:05:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees report', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR01', 'arrays', 'error_bodies_ARRAY_AR01', 'script', '2013-11-26 11:30:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Using the form below you can generate a report for specific service and date range. You can also generate the results based on number of services each employee did or the total amount paid for these services.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR02', 'arrays', 'error_titles_ARRAY_AR02', 'script', '2013-11-19 08:58:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services report', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR02', 'arrays', 'error_bodies_ARRAY_AR02', 'script', '2013-11-26 11:32:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Using the form below you can generate a report for specific employee and date range. You can also generate the results based on number of services each employee did or the total amount paid for these services.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_amount', 'backend', 'Reports / Amount', 'script', '2013-11-19 09:11:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'report_cnt', 'backend', 'Reports / Count', 'script', '2013-11-19 09:11:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Count', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AD01', 'arrays', 'error_titles_ARRAY_AD01', 'script', '2013-11-26 11:28:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see working schedule for all employees. Using the date selector below to refresh the schedule. Click on Print button to print work timesheet.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AD01', 'arrays', 'error_titles_ARRAY_AD01', 'script', '2013-11-19 14:39:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnApply', 'backend', 'Save', 'script', '2013-11-19 15:19:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Apply', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dashboard_filter', 'backend', 'Dashboard / Filter', 'script', '2013-11-19 15:20:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dashboard filter', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT05', 'arrays', 'error_titles_ARRAY_AT05', 'script', '2013-12-12 18:48:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT05', 'arrays', 'error_bodies_ARRAY_AT05', 'script', '2013-12-12 18:49:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Using the form below you can set a custom working time for any date. Just select a date and set working time for it. Or you can just mark the date as a day off and bookings on that date will not be accepted. ', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT06', 'arrays', 'error_bodies_ARRAY_AT06', 'script', '2013-12-12 18:57:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can set working time for this employee only. Different working time can be set for each day of the week. You can also set days off and a lunch break. ', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT06', 'arrays', 'error_titles_ARRAY_AT06', 'script', '2013-12-12 18:44:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AT07', 'arrays', 'error_titles_ARRAY_AT07', 'script', '2013-12-12 18:57:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AT07', 'arrays', 'error_bodies_ARRAY_AT07', 'script', '2013-12-12 19:35:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Using the form below you can set a custom working time for any date for this employee only. Just select a date and set working time for it. Or you can just mark the date as a day off and bookings on that date for this employee will not be accepted.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnToday', 'backend', 'Button / Today', 'script', '2013-11-25 09:07:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnTomorrow', 'backend', 'Button / Tomorrow', 'script', '2013-11-25 09:07:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tomorrow', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AD02', 'arrays', 'error_titles_ARRAY_AD02', 'script', '2013-11-25 10:58:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Dashboard Notice', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AD02', 'arrays', 'error_titles_ARRAY_AD02', 'script', '2013-11-25 10:59:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Selected date is set to "day off". Use the date picker above to choose another date. Please, note that you can change working time under Options page.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_paypal_submit', 'frontend', 'Frontend / Paypal submit', 'script', '2013-12-18 10:49:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Go to PayPal Secure page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_authorize_submit', 'frontend', 'Frontend / Authorize.NET submit', 'script', '2013-12-18 10:49:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Go to Authorize.NET Secure page', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_status_ARRAY_11', 'arrays', 'front_booking_status_ARRAY_11', 'script', '2013-12-18 10:51:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please wait while redirect to secure payment processor webpage complete...', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_status_ARRAY_1', 'arrays', 'front_booking_status_ARRAY_1', 'script', '2013-12-18 10:51:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Your request has been sent successfully. Thank you.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_status_ARRAY_4', 'arrays', 'front_booking_status_ARRAY_4', 'script', '2013-12-18 10:52:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking not found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_status_ARRAY_3', 'arrays', 'front_booking_status_ARRAY_3', 'script', '2013-12-18 10:56:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The invoice for this booking is already paid.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_na', 'frontend', 'Frontend / Booking not available', 'script', '2013-12-18 12:19:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking not available', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_start_time', 'backend', 'Bookings / Start time', 'script', '2013-12-18 13:58:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_end_time', 'backend', 'Bookings / End time', 'script', '2013-12-18 13:59:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'End time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK14', 'arrays', 'error_titles_ARRAY_ABK14', 'script', '2013-12-18 14:26:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services not found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK14', 'arrays', 'error_bodies_ARRAY_ABK14', 'script', '2013-12-18 14:27:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You need to have at least a service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK15', 'arrays', 'error_titles_ARRAY_ABK15', 'script', '2013-12-18 14:49:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employees not found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK15', 'arrays', 'error_bodies_ARRAY_ABK15', 'script', '2013-12-18 14:50:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You need to create employee and assign service first.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABK16', 'arrays', 'error_titles_ARRAY_ABK16', 'script', '2013-11-11 09:46:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK16', 'arrays', 'error_bodies_ARRAY_ABK16', 'script', '2013-11-22 09:44:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see all the bookings. Click on any of them to view and edit it. Using the buttons you can filter the bookings by their status. Use the advance search to quickly locate a booking.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_minutes', 'frontend', 'Frontend / Minutes', 'script', '2014-01-09 09:50:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'mins', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_on', 'frontend', 'Frontend / On', 'script', '2014-01-09 12:29:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'on', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_back_services', 'backend', 'Frontend / Back to services', 'script', '2014-01-09 12:39:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'back to services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_checkout', 'frontend', 'Frontend / Checkout', 'script', '2014-01-09 12:55:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_done', 'frontend', 'Frontend / Service added', 'script', '2014-01-09 12:56:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service added to your cart.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_app_ARRAY_v_remote', 'arrays', 'front_app_ARRAY_v_remote', 'script', '2014-01-09 15:12:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Some of the items in your basket is not available.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_from', 'backend', 'Frontend / From', 'script', '2014-01-09 15:41:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'from', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_till', 'backend', 'Frontend / Till', 'script', '2014-01-09 15:41:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'till', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_1', 'arrays', 'cancel_err_ARRAY_1', 'script', '2014-01-22 07:55:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Missing, empty or invalid parameters.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_2', 'arrays', 'cancel_err_ARRAY_2', 'script', '2014-01-22 07:56:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking with such an ID did not exists.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_3', 'arrays', 'cancel_err_ARRAY_3', 'script', '2014-01-22 07:56:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Security hash did not match.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_4', 'arrays', 'cancel_err_ARRAY_4', 'script', '2014-01-22 07:56:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking is already cancelled.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_5', 'arrays', 'cancel_err_ARRAY_5', 'script', '2014-01-22 07:57:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been cancelled successfully.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_details', 'frontend', 'Cancel / Customer Details', 'script', '2014-01-22 08:42:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Customer Details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_confirm', 'frontend', 'Cancel / Cancel button', 'script', '2014-01-22 08:41:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_services', 'frontend', 'Cancel / Booking Services', 'script', '2014-01-22 08:42:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_title', 'frontend', 'Cancel / Page title', 'script', '2014-01-22 08:43:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking Cancellation', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_employee_confirmation', 'backend', 'Confirmation / Employee confirmation title', 'script', '2014-01-30 07:19:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_employee_payment', 'backend', 'Confirmation / Employee payment title', 'script', '2014-01-30 07:19:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'time_update_default', 'backend', 'Working Time / Update default working time', 'script', '2014-01-30 09:04:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update the default working time for all the employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_layout', 'backend', 'Options / Layout', 'script', '2014-02-06 09:05:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Layout', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_date', 'frontend', 'Single / Select date', 'script', '2014-02-06 10:36:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_service', 'frontend', 'Single / Service', 'script', '2014-02-06 10:36:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_time', 'frontend', 'Single / Select time', 'script', '2014-02-06 10:37:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_employee', 'frontend', 'Single / Employee', 'script', '2014-02-06 10:37:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnBook', 'backend', 'Button / Book', 'script', '2014-02-06 10:41:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Book', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_date_service', 'frontend', 'Single / Select date and service', 'script', '2014-02-06 10:41:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select date and service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_choose_date', 'frontend', 'Single / Choose date', 'script', '2014-02-06 10:45:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'single_date', 'frontend', 'Single / Date', 'script', '2014-02-10 14:04:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'single_price', 'frontend', 'Single / Price', 'script', '2014-02-10 14:04:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_booking_status_ARRAY_5', 'arrays', 'front_booking_status_ARRAY_5', 'script', '2014-02-17 07:38:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This invoice have been cancelled.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_single_na', 'frontend', 'Single / Not available', 'script', '2014-02-20 15:21:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'not available on selected date and time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnCheckout', 'backend', 'Button Checkout', 'script', '2014-06-03 12:51:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnBackToServices', 'backend', 'Button Back to services', 'script', '2014-06-03 12:52:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Back to services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnViewCart', 'backend', 'Button View cart', 'script', '2014-06-03 13:00:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View cart', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU10', 'arrays', 'error_titles_ARRAY_AU10', 'script', '2014-06-03 14:01:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Invalid data', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU10', 'arrays', 'error_bodies_ARRAY_AU10', 'script', '2014-06-03 14:02:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Form data has not been saved. Please review data and try again.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_terms_link', 'frontend', 'Frontend / Read terms and conditions', 'script', '2014-06-03 14:18:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Read terms and conditions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_app_ARRAY_btn_ok', 'arrays', 'front_app_ARRAY_btn_ok', 'script', '2014-06-03 14:24:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'OK', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_terms', 'frontend', 'Frontend / Terms and Conditions', 'script', '2014-06-03 14:25:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Terms and Conditions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_tax', 'frontend', 'Frontend / Tax', 'script', '2014-06-03 14:54:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_deposit', 'frontend', 'Frontend / Deposit', 'script', '2014-06-03 14:54:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deposit payment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_cart_price', 'frontend', 'Frontend / Price', 'script', '2014-06-03 14:55:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service(s) price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_captcha', 'frontend', 'Checkout / Validation / Captcha', 'script', '2014-06-24 07:26:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_captcha_remote', 'frontend', 'Checkout / Validation / Captcha remote', 'script', '2014-06-24 07:27:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha is wrong', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_terms', 'frontend', 'Checkout / Validation / Terms', 'script', '2014-06-24 07:27:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You need to agree with the terms and conditions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_notes', 'frontend', 'Checkout / Validation / Notes', 'script', '2014-06-24 07:28:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notes is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_zip', 'frontend', 'Checkout / Validation / Zip', 'script', '2014-06-24 07:28:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Zip is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_city', 'frontend', 'Checkout / Validation / City', 'script', '2014-06-24 07:28:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'City is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_state', 'frontend', 'Checkout / Validation / State', 'script', '2014-06-24 07:28:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'State is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_country', 'frontend', 'Checkout / Validation / Country', 'script', '2014-06-24 07:28:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Country is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_address_1', 'frontend', 'Checkout / Validation / Address Line 1', 'script', '2014-06-24 07:29:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 1 is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_address_2', 'frontend', 'Checkout / Validation / Address Line 2', 'script', '2014-06-24 07:29:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Address Line 2 is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_phone', 'frontend', 'Checkout / Validation / Phone', 'script', '2014-06-24 07:29:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_name', 'frontend', 'Checkout / Validation / Name', 'script', '2014-06-24 07:29:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Name is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_email', 'frontend', 'Checkout / Validation / Email', 'script', '2014-06-24 07:29:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_email_inv', 'frontend', 'Checkout / Validation / Email invalid', 'script', '2014-06-24 07:30:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email is invalid', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_payment', 'frontend', 'Checkout / Validation / Payment', 'script', '2014-06-24 07:32:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment method is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_cc_type', 'frontend', 'Checkout / Validation / CC Type', 'script', '2014-06-24 07:33:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Type is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_cc_num', 'frontend', 'Checkout / Validation / CC Number', 'script', '2014-06-24 07:33:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Number is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'co_v_cc_code', 'frontend', 'Checkout / Validation / CC Code', 'script', '2014-06-24 07:33:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CC Code is required', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_required', 'backend', 'Form / Validation / Required', 'script', '2014-06-24 08:06:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This field is required.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_remote', 'backend', 'Form / Validation / Remote', 'script', '2014-06-24 07:53:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please fix this field.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_email', 'backend', 'Form / Validation / Email', 'script', '2014-06-24 07:53:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid email address.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_url', 'backend', 'Form / Validation / URL', 'script', '2014-06-24 07:53:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid URL.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_date', 'backend', 'Form / Validation / Date', 'script', '2014-06-24 07:52:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid date.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_date_iso', 'backend', 'Form / Validation / Date ISO', 'script', '2014-06-24 07:52:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid date (ISO).', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_number', 'backend', 'Form / Validation / Number', 'script', '2014-06-24 07:52:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid number.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_digits', 'backend', 'Form / Validation / Digits', 'script', '2014-06-24 07:52:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter only digits.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_creditcard', 'backend', 'Form / Validation / Creditcard', 'script', '2014-06-24 07:52:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a valid credit card number.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_equal_to', 'backend', 'Form / Validation / Equal to', 'script', '2014-06-24 07:52:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter the same value again.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_maxlength', 'backend', 'Form / Validation / Maxlength', 'script', '2014-06-24 07:52:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter no more than {0} characters.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_minlength', 'backend', 'Form / Validation / Minlength', 'script', '2014-06-24 07:52:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter at least {0} characters.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_rangelength', 'backend', 'Form / Validation / Range length', 'script', '2014-06-24 07:52:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a value between {0} and {1} characters long.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_range', 'backend', 'Form / Validation / Range', 'script', '2014-06-24 07:52:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a value between {0} and {1}.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_max', 'backend', 'Form / Validation / Max', 'script', '2014-06-24 07:52:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a value less than or equal to {0}.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_min', 'backend', 'Form / Validation / Min', 'script', '2014-06-24 07:52:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a value greater than or equal to {0}.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'form_v_accept', 'backend', 'Form / Validation / Accept', 'script', '2014-06-24 07:52:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter a value with a valid extension.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_1', 'arrays', 'Frontend / Day suffix: 1', 'script', '2014-06-24 08:47:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'st', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_2', 'arrays', 'Frontend / Day suffix: 2', 'script', '2014-06-24 08:47:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'nd', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_3', 'arrays', 'Frontend / Day suffix: 3', 'script', '2014-06-24 08:47:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'rd', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_4', 'arrays', 'Frontend / Day suffix: 4', 'script', '2014-06-24 08:47:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_5', 'arrays', 'Frontend / Day suffix: 5', 'script', '2014-06-24 08:47:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_6', 'arrays', 'Frontend / Day suffix: 6', 'script', '2014-06-24 08:47:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_7', 'arrays', 'Frontend / Day suffix: 7', 'script', '2014-06-24 08:48:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_8', 'arrays', 'Frontend / Day suffix: 8', 'script', '2014-06-24 08:48:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_9', 'arrays', 'Frontend / Day suffix: 9', 'script', '2014-06-24 08:48:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_10', 'arrays', 'Frontend / Day suffix: 10', 'script', '2014-06-24 08:48:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_11', 'arrays', 'Frontend / Day suffix: 11', 'script', '2014-06-24 08:48:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_12', 'arrays', 'Frontend / Day suffix: 12', 'script', '2014-06-24 08:48:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_13', 'arrays', 'Frontend / Day suffix: 13', 'script', '2014-06-24 08:48:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_14', 'arrays', 'Frontend / Day suffix: 14', 'script', '2014-06-24 08:48:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_15', 'arrays', 'Frontend / Day suffix: 15', 'script', '2014-06-24 08:48:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_16', 'arrays', 'Frontend / Day suffix: 16', 'script', '2014-06-24 08:49:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_17', 'arrays', 'Frontend / Day suffix: 17', 'script', '2014-06-24 08:49:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_18', 'arrays', 'Frontend / Day suffix: 18', 'script', '2014-06-24 08:49:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_19', 'arrays', 'Frontend / Day suffix: 19', 'script', '2014-06-24 08:49:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_20', 'arrays', 'Frontend / Day suffix: 20', 'script', '2014-06-24 08:49:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_21', 'arrays', 'Frontend / Day suffix: 21', 'script', '2014-06-24 08:49:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'st', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_22', 'arrays', 'Frontend / Day suffix: 22', 'script', '2014-06-24 08:49:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'nd', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_23', 'arrays', 'Frontend / Day suffix: 23', 'script', '2014-06-24 08:49:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'rd', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_24', 'arrays', 'Frontend / Day suffix: 24', 'script', '2014-06-24 08:50:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_25', 'arrays', 'Frontend / Day suffix: 25', 'script', '2014-06-24 08:50:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_26', 'arrays', 'Frontend / Day suffix: 26', 'script', '2014-06-24 08:50:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_27', 'arrays', 'Frontend / Day suffix: 27', 'script', '2014-06-24 08:50:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_28', 'arrays', 'Frontend / Day suffix: 28', 'script', '2014-06-24 08:50:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_29', 'arrays', 'Frontend / Day suffix: 29', 'script', '2014-06-24 08:50:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_30', 'arrays', 'Frontend / Day suffix: 30', 'script', '2014-06-24 08:50:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_suffix_ARRAY_31', 'arrays', 'Frontend / Day suffix: 31', 'script', '2014-06-24 08:50:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'st', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_service_na', 'frontend', 'Frontend / Service not available', 'script', '2014-06-25 14:23:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'N/A', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_day_na', 'frontend', 'Frontend / Day not available', 'script', '2014-06-25 14:46:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'N/A', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'multiselect_check_all', 'backend', 'MultiSelect / Check all', 'script', '2014-07-14 07:21:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Check all', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'multiselect_uncheck_all', 'backend', 'MultiSelect / Uncheck all', 'script', '2014-07-14 07:21:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Uncheck all', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'multiselect_none_selected', 'backend', 'MultiSelect / Select options', 'script', '2014-07-14 07:22:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'multiselect_selected', 'backend', 'MultiSelect / # selected', 'script', '2014-07-14 07:22:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'selected', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_client_cancel', 'backend', 'Confirmation / Client cancellation title', 'script', '2014-07-14 10:24:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_employee_cancel', 'backend', 'Confirmation / Employee cancellation title', 'script', '2014-07-14 10:26:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'confirmation_admin_cancel', 'backend', 'Confirmation / Admin cancellation title', 'script', '2014-07-14 10:27:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_206', 'frontend', 'System / Service added', 'script', '2014-08-25 07:54:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service has been added to your cart.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_105', 'frontend', 'System / Missing data', 'script', '2014-08-25 07:54:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Missing, empty or invalid parameters.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_207', 'frontend', 'System / Service removed', 'script', '2014-08-25 07:53:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service has been removed from your cart.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_106', 'frontend', 'System / Missing data', 'script', '2014-08-25 07:53:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Missing, empty or invalid parameters.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_109', 'frontend', 'System / Checkout data is missing', 'script', '2014-08-25 07:52:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout data is missing (or not valid form submit).', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_110', 'frontend', 'System / Captcha doesn''t match', 'script', '2014-08-25 07:51:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Captcha doesn''t match.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_111', 'frontend', 'System / Cart is empty', 'script', '2014-08-25 07:50:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cart is empty or invalid services.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_114', 'frontend', 'System / Booking data is invalid', 'script', '2014-08-25 07:48:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking data is not valid.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_119', 'frontend', 'System / Booking failed', 'script', '2014-08-25 07:47:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking failed.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_211', 'frontend', 'System / Checkout form saved', 'script', '2014-08-25 07:45:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Checkout form has been saved.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_115', 'frontend', 'System / Service not available', 'script', '2014-08-25 07:55:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Some of the services in your cart are not available.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'system_210', 'frontend', 'System / Booking saved', 'script', '2014-08-25 07:47:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Booking has been successful.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblMinutes', 'backend', 'Minutes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Minutes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblHours', 'backend', 'Hours', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Hours', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblService', 'backend', 'Service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblEmployee', 'backend', 'Employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblImages', 'backend', 'Images', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Images', 'script');

-- Do not remove below

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES
(NULL, '1', 'pjCalendar', '1', 'confirm_subject_client', 'Booking confirmation', 'data'),
(NULL, '1', 'pjCalendar', '1', 'confirm_tokens_client', 'Thank you for your booking. \r\n\r\nID: {BookingID}\r\n\r\nServices\r\n{Services}\r\n\r\nPersonal details\r\nName: {Name}\r\nPhone: {Phone}\r\nEmail: {Email}\r\n\r\nThis is the price for your booking\r\nTax: {Price}\r\nTax: {Tax}\r\nTotal: {Total}\r\nDeposit required to confirm your booking: {Deposit}\r\n\r\nAdditional notes:\r\n{Notes}\r\n\r\nThank you,\r\nThe Management', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_subject_client', 'Payment received', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_tokens_client', 'We''ve received the payment for your booking and it is now confirmed.\r\n\r\nID: {BookingID}\r\n\r\nThank you,\r\nThe Management', 'data'),
(NULL, '1', 'pjCalendar', '1', 'confirm_subject_admin', 'New booking received', 'data'),
(NULL, '1', 'pjCalendar', '1', 'confirm_tokens_admin', 'New booking has been made. \r\n\r\nID: {BookingID}\r\n\r\nServices\r\n{Services}\r\n\r\nPersonal details\r\nName: {Name}\r\nPhone: {Phone}\r\nEmail: {Email}\r\n\r\nPrice\r\nTax: {Price}\r\nTax: {Tax}\r\nTotal: {Total}\r\nDeposit required to confirm the booking: {Deposit}\r\n\r\nAdditional notes:\r\n{Notes}', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_subject_admin', 'New payment received', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_tokens_admin', 'Booking deposit has been paid.\r\n\r\nID: {BookingID}', 'data'),
(NULL, '1', 'pjCalendar', '1', 'confirm_subject_employee', 'New appointment received', 'data'),
(NULL, '1', 'pjCalendar', '1', 'confirm_tokens_employee', 'New appointment has been made.\r\n\r\nID: {BookingID}\r\n\r\nServices\r\n{Services}\r\n\r\nPersonal details\r\nName: {Name}\r\nPhone: {Phone}\r\nEmail: {Email}\r\n\r\nAdditional notes:\r\n{Notes}', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_subject_employee', 'New payment received', 'data'),
(NULL, '1', 'pjCalendar', '1', 'payment_tokens_employee', 'Booking deposit has been paid.\r\n\r\nID: {BookingID}', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_subject_client', 'Boooking cancellation', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_tokens_client', 'Your booking has been cancelled.\r\n\r\nID: {BookingID}\r\n\r\nThank you,\r\nThe Management', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_subject_admin', 'Booking cancelled', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_tokens_admin', 'Booking has been cancelled.\r\n\r\nID: {BookingID}', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_subject_employee', 'Booking cancelled', 'data'),
(NULL, '1', 'pjCalendar', '1', 'cancel_tokens_employee', 'Booking has been cancelled.\r\n\r\nID: {BookingID}', 'data');

INSERT INTO `appscheduler_plugin_auth_roles` (`id`, `role`, `is_backend`, `is_admin`, `status`) VALUES
(3, 'Employee', 'T', 'F', 'T');

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "service_tip_employees");

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Select employee(s) who can do this service.' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE12', 'arrays', 'error_titles_ARRAY_AE12', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE12', 'arrays', 'error_bodies_ARRAY_AE12', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New employee could not be added because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE13', 'arrays', 'error_titles_ARRAY_AE13', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE13', 'arrays', 'error_bodies_ARRAY_AE13', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New employee has been added, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE14', 'arrays', 'error_titles_ARRAY_AE14', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE14', 'arrays', 'error_bodies_ARRAY_AE14', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE15', 'arrays', 'error_titles_ARRAY_AE15', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE15', 'arrays', 'error_bodies_ARRAY_AE15', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee could not be updated because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE16', 'arrays', 'error_titles_ARRAY_AE16', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE16', 'arrays', 'error_bodies_ARRAY_AE16', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee information has been updated, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE17', 'arrays', 'error_titles_ARRAY_AE17', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE17', 'arrays', 'error_bodies_ARRAY_AE17', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'positive_number', 'backend', 'Label / Please enter positive number', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Please enter positive number', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'uuid_used', 'backend', 'Label / Unique ID was used.', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Unique ID was used.', 'script');

UPDATE `appscheduler_options` SET `value` = '1|2|3::3' WHERE `foreign_id` = 1 AND `key` = "o_bf_address_1";
UPDATE `appscheduler_options` SET `value` = '1|2|3::2' WHERE `foreign_id` = 1 AND `key` = "o_bf_address_2";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_delete', 'arrays', 'buttons_ARRAY_delete', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_send', 'arrays', 'buttons_ARRAY_send', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_export', 'arrays', 'buttons_ARRAY_export', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_yes', 'arrays', 'buttons_ARRAY_yes', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_no', 'arrays', 'buttons_ARRAY_no', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_close', 'arrays', 'buttons_ARRAY_close', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Close', 'script');

INSERT INTO `appscheduler_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_fields_index', 99, 'd874fcc5fe73b90d770a544664a3775d', NULL, 'string', NULL, 0, NULL);

ALTER TABLE `appscheduler_plugin_auth_users` ADD `is_notify` enum('T','F') NOT NULL DEFAULT 'T' AFTER `status`;

DROP TABLE IF EXISTS `appscheduler_passwords`;
CREATE TABLE IF NOT EXISTS `appscheduler_passwords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

ALTER TABLE `appscheduler_bookings` ADD `modified` datetime DEFAULT NULL AFTER `created`;

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR21', 'arrays', 'error_titles_ARRAY_AR21', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR21', 'arrays', 'error_bodies_ARRAY_AR21', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can export bookings in different formats. You can either download a file with booking details or use a link for a feed which load all the bookings.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_ical', 'arrays', 'export_formats_ARRAY_ical', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'iCal', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_xml', 'arrays', 'export_formats_ARRAY_xml', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'XML', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_formats_ARRAY_csv', 'arrays', 'export_formats_ARRAY_csv', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'CSV', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_types_ARRAY_file', 'arrays', 'export_types_ARRAY_file', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'File', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_types_ARRAY_feed', 'arrays', 'export_types_ARRAY_feed', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Feed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_periods_ARRAY_next', 'arrays', 'export_periods_ARRAY_next', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Coming', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'export_periods_ARRAY_last', 'arrays', 'export_periods_ARRAY_last', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Created or Modified', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnExport', 'backend', 'Button / Export', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblFormat', 'backend', 'Label / Format', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Format', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblBookings', 'backend', 'Label / Bookings', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblBookingsMade', 'backend', 'Label / bookings made', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'bookings made', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblComingBookings', 'backend', 'Label / coming bookings ', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'coming bookings ', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblBookingsFeedURL', 'backend', 'Label / Bookings Feed URL', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings Feed URL', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnGetFeedURL', 'backend', 'Button / Get Feed URL', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Get Feed URL', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblCalendar', 'backend', 'Label / Calendar', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Calendar', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoBookingFeedTitle', 'backend', 'Infobox / Bookings Feed URL', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings Feed URL', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoBookingFeedDesc', 'backend', 'Infobox / Bookings Feed URL', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use the URL below to have access to all bookings. Please, note that if you change the password the URL will change too as password is used in the URL itself so no one else can open it.', 'script');


INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblEnterPassword', 'backend', 'Label / Enter password', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Enter password', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblNoAccessToFeed', 'backend', 'Label / No access to feed', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No access to feed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_1', 'arrays', 'coming_arr_ARRAY_1', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_2', 'arrays', 'coming_arr_ARRAY_2', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tomorrow', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_3', 'arrays', 'coming_arr_ARRAY_3', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_4', 'arrays', 'coming_arr_ARRAY_4', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_5', 'arrays', 'coming_arr_ARRAY_5', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This month', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'coming_arr_ARRAY_6', 'arrays', 'coming_arr_ARRAY_6', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next month', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_1', 'arrays', 'made_arr_ARRAY_1', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_2', 'arrays', 'made_arr_ARRAY_2', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yesterday', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_3', 'arrays', 'made_arr_ARRAY_3', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_4', 'arrays', 'made_arr_ARRAY_4', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_5', 'arrays', 'made_arr_ARRAY_5', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This month', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'made_arr_ARRAY_6', 'arrays', 'made_arr_ARRAY_6', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Last month', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblNotifications', 'backend', 'Label / Notifications', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'booking_client', 'backend', 'Label / Client', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblEmailPhone', 'backend', 'Label / Email & Phone', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email & Phone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'tabEmailNotifications', 'backend', 'Tab / Email Notifications', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_confirm', 'arrays', 'notify_arr_ARRAY_confirm', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_payment', 'arrays', 'notify_arr_ARRAY_payment', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_cancel', 'arrays', 'notify_arr_ARRAY_cancel', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_confirm_admin', 'arrays', 'notify_arr_ARRAY_confirm_admin', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_payment_admin', 'arrays', 'notify_arr_ARRAY_payment_admin', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_cancel_admin', 'arrays', 'notify_arr_ARRAY_cancel_admin', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Admin - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_confirm_employee', 'arrays', 'notify_arr_ARRAY_confirm_employee', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - booking confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_payment_employee', 'arrays', 'notify_arr_ARRAY_payment_employee', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notify_arr_ARRAY_cancel_employee', 'arrays', 'notify_arr_ARRAY_cancel_employee', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Employee - booking cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'services_required', 'backend', 'Label / Services is required.', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services is required.', 'script');

INSERT INTO `appscheduler_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_theme', 1, 'theme1|theme2|theme3|theme4|theme5|theme6|theme7|theme8|theme9|theme10::theme1', 'Theme 1|Theme 2|Theme 3|Theme 4|Theme 5|Theme 6|Theme 7|Theme 8|Theme 9|Theme 10', 'enum', 3, 1, NULL);

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_theme', 'backend', 'Options / Theme', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_filter', 'frontend', 'Label / Filter', 'script', '2015-04-08 06:24:39');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Filter', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_all', 'frontend', 'Label / All', 'script', '2015-04-08 06:40:26');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_appointment', 'frontend', 'Label / appointment', 'script', '2015-04-08 06:44:03');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_appointments', 'frontend', 'Label / appointments', 'script', '2015-04-08 06:44:20');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'appointments', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_no_employees_found', 'frontend', 'Label / No employees found', 'script', '2015-04-08 06:59:13');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No employees found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_service', 'frontend', 'Frontend / Select service', 'script', '2015-04-08 08:44:56');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_no_services_found', 'frontend', 'Label / No services found', 'script', '2015-04-08 08:49:24');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No services found', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_duration', 'frontend', 'Label / Duration', 'script', '2015-04-08 08:54:47');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Duration', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_back', 'frontend', 'Label / back', 'script', '2015-04-08 10:11:12');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'back', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_phone', 'frontend', 'Label / Phone', 'script', '2015-04-08 10:28:10');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_email', 'frontend', 'Label / Email', 'script', '2015-04-08 10:29:25');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_date_time', 'frontend', 'Label / Select date and time', 'script', '2015-04-08 10:45:06');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select date and time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_choose_date', 'frontend', 'Label / Choose date', 'script', '2015-04-08 10:47:53');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_time', 'frontend', 'Label / Time', 'script', '2015-04-09 10:41:27');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_date_off', 'frontend', 'Label / Selected date is a day off.', 'script', '2015-04-10 05:38:42');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Selected date is a day off.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_select_date_time_employee', 'frontend', 'Label / Select date and time & employee', 'script', '2015-04-10 08:06:32');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select date and time & employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_employees_not_avaiable', 'frontend', 'Label / Employees not available', 'script', '2015-04-10 08:29:15');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No employees available for this service.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_choose', 'frontend', 'Label / Choose', 'script', '2015-04-10 08:34:14');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_service_employee', 'frontend', 'Service/employee', 'script', '2015-04-13 03:42:38');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service/employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_date_time', 'frontend', 'Label / Date and time', 'script', '2015-04-13 03:45:00');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date and time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_tax', 'frontend', 'Label / Tax', 'script', '2015-04-13 05:58:13');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_total', 'frontend', 'Label / Total', 'script', '2015-04-13 05:58:33');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_deposit', 'frontend', 'Label / Deposit', 'script', '2015-04-13 05:58:53');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Deposit', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_close', 'frontend', 'Label / Close', 'script', '2015-04-13 07:26:43');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Close', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_start_over', 'frontend', 'Label / Start over', 'script', '2015-04-13 09:16:29');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Start over', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'service_image', 'backend', 'Label / Image', 'script', '2015-04-13 09:38:24');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Image', 'script');


INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS12', 'arrays', 'error_titles_ARRAY_AS12', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS12', 'arrays', 'error_bodies_ARRAY_AS12', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New service could not be added because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS13', 'arrays', 'error_titles_ARRAY_AS13', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS13', 'arrays', 'error_bodies_ARRAY_AS13', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'New service has been added, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS14', 'arrays', 'error_titles_ARRAY_AS14', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS14', 'arrays', 'error_bodies_ARRAY_AS14', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS15', 'arrays', 'error_titles_ARRAY_AS15', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size is too large', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS15', 'arrays', 'error_bodies_ARRAY_AS15', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service could not be updated because picture size is too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller picture.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS16', 'arrays', 'error_titles_ARRAY_AS16', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Picture size exceeded', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS16', 'arrays', 'error_bodies_ARRAY_AS16', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service information has been updated, but picture could not be uploaded as its size exceeds the maximum allowed file upload size.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AS17', 'arrays', 'error_titles_ARRAY_AS17', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AS17', 'arrays', 'error_bodies_ARRAY_AS17', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You uploaded picture is not allowed to upload because it''s in wrong content type. Please check the actual type of the file.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_about_employee', 'frontend', 'Label / About employee', 'script', '2015-04-14 10:06:43');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'About {EMPLOYEE}', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_reason_for_appointment', 'frontend', 'Label / Reason for Appointment', 'script', '2015-04-15 05:46:44');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reason for Appointment', 'script');

UPDATE `appscheduler_options` SET `label`='Layout 1 - Employees list|Layout 2 - Services list' WHERE `key`='o_layout';  

UPDATE `appscheduler_options` SET `value`=NULL WHERE `key`='o_authorize_hash';  
UPDATE `appscheduler_options` SET `value`=NULL WHERE `key`='o_authorize_key'; 
UPDATE `appscheduler_options` SET `value`=NULL WHERE `key`='o_authorize_mid'; 

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "lblInstallJs1_1");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Install Code' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "error_bodies_ARRAY_AO30");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'To better optimize your appointment scheduler please follow the steps below.' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "lblInstallJs1_body");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'In order to install the script on your website copy the code below and add it to your web page.' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

UPDATE `appscheduler_options` SET `is_visible`=0 WHERE `key`='o_accept_bookings';
UPDATE `appscheduler_options` SET `is_visible`=0 WHERE `key`='o_hide_prices';

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_service_required', 'frontend', 'Label / Reason for Appointment is required.', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Reason for appointment is required.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallSeo_4', 'backend', 'Install / SEO Step 1', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Step 4. (CROSS-DOMAIN INSTALL ONLY) Create .htaccess file (or update existing one) in the folder where your web page is and put the data below in it', 'script');

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "lblInstallSeo_3");

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Step 3. (SAME DOMAIN INSTALL ONLY) Create .htaccess file (or update existing one) in the folder where your web page is and put the data below in it' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblSelectLayoutTheme', 'backend', 'Label / Select layout & theme', 'script', '2015-06-26 04:32:27');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select layout & theme', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblSelectTheme', 'backend', 'Label / Select theme', 'script', '2015-06-26 04:36:03');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select theme', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblSelectLayout', 'backend', 'Label / Select layout', 'script', '2015-06-26 04:37:00');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select layout', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_0', 'arrays', 'short_days_ARRAY_0', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Su', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_1', 'arrays', 'short_days_ARRAY_1', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Mo', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_2', 'arrays', 'short_days_ARRAY_2', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Tu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_3', 'arrays', 'short_days_ARRAY_3', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'We', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_4', 'arrays', 'short_days_ARRAY_4', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Th', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_5', 'arrays', 'short_days_ARRAY_5', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fr', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_6', 'arrays', 'short_days_ARRAY_6', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Sa', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_browse_services', 'frontend', 'Label / Browse Services', 'script', '2015-10-20 03:55:03');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Browse Services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_browse_professionalists', 'frontend', 'Label / Browse Professionalists', 'script', '2015-10-20 03:43:02');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Browse Professionals', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoThemeTitle', 'backend', 'Infobox / Preview front end', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Preview front end', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoThemeDesc', 'backend', 'Infobox / Preview front end', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'There are multiple color schemes available for the front end. Click on each of the thumbnails below to preview it. Click on "Use this theme" button for the theme you want to use.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallTheme', 'backend', 'Label / Choose theme', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose theme', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_1', 'arrays', 'option_themes_ARRAY_1', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 1', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_2', 'arrays', 'option_themes_ARRAY_2', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 2', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_3', 'arrays', 'option_themes_ARRAY_3', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 3', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_4', 'arrays', 'option_themes_ARRAY_4', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 4', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_5', 'arrays', 'option_themes_ARRAY_5', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 5', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_6', 'arrays', 'option_themes_ARRAY_6', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 6', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_7', 'arrays', 'option_themes_ARRAY_7', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 7', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_8', 'arrays', 'option_themes_ARRAY_8', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 8', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_9', 'arrays', 'option_themes_ARRAY_9', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 9', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_10', 'arrays', 'option_themes_ARRAY_10', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Theme 10', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblCurrentlyInUse', 'backend', 'Label / Currently in use', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Currently in use', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnUseThisTheme', 'backend', 'Label / Use this theme', 'script', NULL);

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Use this theme', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_selected_date', 'frontend', 'Label / Selected date', 'script', '2015-10-23 06:55:04');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Selected date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnAddBooking', 'backend', 'Button / + Add booking', 'script', '2015-10-23 07:04:39');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnAddEmployee', 'backend', 'Button / + Add employee', 'script', '2015-10-23 07:12:26');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnAddService', 'backend', 'Button / Add service', 'script', '2015-10-23 07:16:39');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnAddUser', 'backend', 'Button / + Add user', 'script', '2015-10-23 07:20:33');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', '+ Add user', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoUsersTitle', 'backend', 'Infobox / List of users', 'script', '2015-10-23 07:21:48');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'List of users', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoUsersDesc', 'backend', 'Infobox / List of users', 'script', '2015-10-23 07:22:47');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Below you can see users who have access to the Appointment Scheduler administration pages. Click on "+ Add user" button to add a new user.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoAddUserTitle', 'backend', 'Infobox / Add user', 'script', '2015-10-23 07:24:00');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoAddUserDesc', 'backend', 'Infobox / Add user', 'script', '2015-10-23 07:26:22');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Fill in the form below and click "Save" button to add new user. You can decide whether user to receive notifications or not by checking on the check-box "Notifications".', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoUpdateUserTitle', 'backend', 'Infobox / Update user', 'script', '2015-10-23 07:26:53');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Update user', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoUpdateUserDesc', 'backend', 'Infobox / Update user', 'script', '2015-10-23 07:27:42');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You can make any changes on the form below and click "Save" button to update user information.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallServicesProfessionals', 'backend', 'Label / Services & Professionals', 'script', '2015-10-30 06:25:08');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services & Professionals', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'install_opt_ARRAY_both', 'arrays', 'install_opt_ARRAY_both', 'script', '2015-10-30 06:25:53');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Both', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'install_opt_ARRAY_service', 'arrays', 'install_opt_ARRAY_service', 'script', '2015-10-30 06:26:30');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Services only', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'install_opt_ARRAY_professional', 'arrays', 'install_opt_ARRAY_professional', 'script', '2015-10-30 06:27:20');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Professionals only', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lblInstallCode', 'backend', 'Label / Install code', 'script', '2015-10-30 06:27:53');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install code', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btnCancelAppointment', 'frontend', 'Button / Cancel Appointment', 'script', '2015-11-12 02:22:52');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel Appointment', 'script');

INSERT INTO `appscheduler_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_booking_earlier', 1, '1', NULL, 'int', 4, 1, NULL),
(1, 'o_cancel_earlier', 1, '2', NULL, 'int', 5, 1, NULL),
(1, 'o_booking_days_earlier', 1, '1', NULL, 'int', 6, 1, NULL);

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_booking_earlier', 'backend', 'Options / Book X hours earlier', 'script', '2015-11-17 07:11:13');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Book X hours earlier', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_earlier', 'backend', 'Options / Cancel X hours earlier', 'script', '2015-11-17 07:12:34');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of hours before appointment client can not cancel it.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_booking_days_earlier', 'backend', 'Options / Number of days ahead client can make appointment', 'script', '2015-11-17 07:13:40');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Number of days ahead client can make appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_6', 'arrays', 'cancel_err_ARRAY_6', 'script', '2015-11-17 15:02:58');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You need to cancel the booking %s hour(s) before the appointment start.', 'script');

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Thank you for your booking. <br/><br/>ID: {BookingID}<br/><br/>Services<br/>{Services}<br/><br/>Personal details<br/>Name: {Name}<br/>Phone: {Phone}<br/>Email: {Email}<br/><br/>This is the price for your booking<br/>Tax: {Price}<br/>Tax: {Tax}<br/>Total: {Total}<br/>Deposit required to confirm your booking: {Deposit}<br/><br/>Additional notes:<br/>{Notes}<br/><br/>Thank you,<br/>The Management' WHERE `model` = "pjCalendar" AND `field` = "confirm_tokens_client";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'We''ve received the payment for your booking and it is now confirmed.<br/><br/>ID: {BookingID}<br/><br/>Thank you,<br/>The Management' WHERE `model` = "pjCalendar" AND `field` = "payment_tokens_client";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'New booking has been made. <br/><br/>ID: {BookingID}<br/><br/>Services<br/>{Services}<br/><br/>Personal details<br/>Name: {Name}<br/>Phone: {Phone}<br/>Email: {Email}<br/><br/>Price<br/>Tax: {Price}<br/>Tax: {Tax}<br/>Total: {Total}<br/>Deposit required to confirm the booking: {Deposit}<br/><br/>Additional notes:<br/>{Notes}' WHERE `model` = "pjCalendar" AND `field` = "confirm_tokens_admin";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Booking deposit has been paid.<br/><br/>ID: {BookingID}' WHERE `model` = "pjCalendar" AND `field` = "payment_tokens_admin";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'New appointment has been made.<br/><br/>ID: {BookingID}<br/><br/>Services<br/>{Services}<br/><br/>Personal details<br/>Name: {Name}<br/>Phone: {Phone}<br/>Email: {Email}<br/><br/>Additional notes:<br/>{Notes}' WHERE `model` = "pjCalendar" AND `field` = "confirm_tokens_employee";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Booking deposit has been paid.<br/><br/>ID: {BookingID}' WHERE `model` = "pjCalendar" AND `field` = "payment_tokens_employee";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Your booking has been cancelled.<br/><br/>ID: {BookingID}<br/><br/>Thank you,<br/>The Management' WHERE `model` = "pjCalendar" AND `field` = "cancel_tokens_client";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Booking has been cancelled.<br/><br/>ID: {BookingID}' WHERE `model` = "pjCalendar" AND `field` = "cancel_tokens_admin";

UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Booking has been cancelled.<br/><br/>ID: {BookingID}' WHERE `model` = "pjCalendar" AND `field` = "cancel_tokens_employee";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_unavailable_making_appiontment', 'frontend', 'Label / The selected date is unavaiable for making appioinment', 'script', '2015-11-23 17:48:34');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'The selected date is unavailable for making appointment. Please select another date.', 'script');

UPDATE `appscheduler_options` SET `value` = '2' WHERE `key` = "o_booking_earlier";
UPDATE `appscheduler_options` SET `value` = '2' WHERE `key` = "o_cancel_earlier";
UPDATE `appscheduler_options` SET `value` = '60' WHERE `key` = "o_booking_days_earlier";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "opt_o_booking_earlier");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Accept bookings X hours before appointment start time' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "opt_o_cancel_earlier");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Clients can cancel a booking up to X hours before appointment start time' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "opt_o_booking_days_earlier");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Accept bookings X days ahead' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

UPDATE `appscheduler_options` SET `value` = 'confirmed|pending|cancelled::pending', `label` = 'Confirmed|Pending|Cancelled' WHERE `key` = "o_status_if_not_paid";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'front_btn_book_slot', 'frontend', 'Button / Book slot', 'script', '2017-03-09 05:27:35');

SET @id := (SELECT LAST_INSERT_ID());

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Book slot', 'script');

DROP TABLE IF EXISTS `appscheduler_notifications`;
CREATE TABLE IF NOT EXISTS `appscheduler_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` enum('client','admin', 'employee') DEFAULT NULL,
  `transport` enum('email','sms') DEFAULT NULL,
  `variant` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipient` (`recipient`,`transport`,`variant`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `appscheduler_notifications` (`id`, `recipient`, `transport`, `variant`, `is_active`) VALUES
(1, 'client', 'email', 'confirmation', 1),
(2, 'client', 'email', 'payment', 1),
(3, 'client', 'email', 'cancel', 1),
(4, 'admin', 'email', 'confirmation', 1),
(5, 'admin', 'email', 'payment', 1),
(6, 'admin', 'email', 'cancel', 1),
(7, 'employee', 'email', 'confirmation', 1),
(8, 'employee', 'email', 'payment', 1),
(9, 'employee', 'email', 'cancel', 1);

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_menu_settings', 'backend', 'Menu / Settings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Settings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_menu_notifications', 'backend', 'Menu / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_emails', 'backend', 'Label / Emails', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Emails', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_sms', 'backend', 'Label / SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_notifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_send_this_notifications', 'backend', 'Label / Send this notification', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send this notification', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_subject', 'backend', 'Label / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_message', 'backend', 'Label / Message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_change_labels', 'backend', 'Label / Change Labels', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change Labels', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_menu_payments', 'backend', 'Menu / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoPaymentsTitle', 'backend', 'Infobox / Payment options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infoPaymentsDesc', 'backend', 'Infobox / Payments', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Here you can choose your payment methods and set payment gateway accounts and payment preferences. Note that for cash payments the system will not be able to collect deposit amount online.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_offline_payment_methods', 'backend', 'Label / Offline Payment Methods', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Offline Payment Methods', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_request_antoher_payment', 'backend', 'Label / Request Another Payment Gateway', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Request Another Payment Gateway', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_online_payment_gateway', 'backend', 'Label / Online payment gateway', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Online payment gateway', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_offline_payment', 'backend', 'Label / Offline payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Offline payment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_reminder_body_text', 'backend', 'Options / Email Reminder body text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, @id, 'pjField', 1, 'title', '<div class="col-xs-6">
<p>{Name}</p>
<p>{Phone}</p>
<p>{Email}</p>
<p>{BookingID}</p>
<p>{Services}</p>
</div>
<div class="col-xs-6">
<p>{Price}</p>
<p>{Deposit}</p>
<p>{Tax}</p>
<p>{Total}</p>
<p>{CancelURL}</p>
</div>
', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation', 'script', '2018-05-31 06:19:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment', 'script', '2018-05-31 06:20:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel', 'script', '2018-05-31 06:20:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation', 'script', '2018-05-31 06:22:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment', 'script', '2018-05-31 06:23:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel', 'script', '2018-05-31 06:23:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_employee_email_confirmation', 'arrays', 'Notifications / Employee email confirmation', 'script', '2018-05-31 06:22:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_employee_email_payment', 'arrays', 'Notifications / Employee email payment', 'script', '2018-05-31 06:23:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_employee_email_cancel', 'arrays', 'Notifications / Employee email cancel', 'script', '2018-05-31 06:23:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation (title)', 'script', '2018-05-31 06:44:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Confirmation email sent to Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment (title)', 'script', '2018-05-31 06:45:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation email sent to Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel (title)', 'script', '2018-05-31 06:45:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking Cancellation email sent to Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation (title)', 'script', '2018-05-31 06:59:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New Booking Received email sent to Admin', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment (title)', 'script', '2018-05-31 06:59:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Payment Confirmation email sent to Admin', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation email sent to Admin', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_employee_email_confirmation', 'arrays', 'Notifications / Employee email confirmation (title)', 'script', '2018-05-31 06:59:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New Booking Received email sent to Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_employee_email_payment', 'arrays', 'Notifications / Employee email payment (title)', 'script', '2018-05-31 06:59:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Payment Confirmation email sent to Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_employee_email_cancel', 'arrays', 'Notifications / Employee email cancel (title)', 'script', '2018-05-31 06:59:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation email sent to Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_confirmation', 'arrays', 'Notifications / Client email confirmation (sub-title)', 'script', '2018-05-31 07:02:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to client when a new reservation is made.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_payment', 'arrays', 'Notifications / Client email payment (sub-title)', 'script', '2018-05-31 07:02:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a payment is made for a new reservation.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_cancel', 'arrays', 'Notifications / Client email cancel (sub-title)', 'script', '2018-05-31 07:02:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a client cancels a reservation.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_confirmation', 'arrays', 'Notifications / Admin email confirmation (sub-title)', 'script', '2018-05-31 07:01:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a new reservation is made.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_payment', 'arrays', 'Notifications / Admin email payment (sub-title)', 'script', '2018-05-31 07:01:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a payment for a new reservation is made.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_cancel', 'arrays', 'Notifications / Admin email cancel (sub-title)', 'script', '2018-05-31 07:01:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a client cancels a reservation.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_employee_email_confirmation', 'arrays', 'Notifications / Employee email confirmation (sub-title)', 'script', '2018-05-31 07:01:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the employee when a new reservation is made.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_employee_email_payment', 'arrays', 'Notifications / Employee email payment (sub-title)', 'script', '2018-05-31 07:01:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the employee when a payment for a new reservation is made.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_employee_email_cancel', 'arrays', 'Notifications / Employee email cancel (sub-title)', 'script', '2018-05-31 07:01:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the employee when a client cancels a reservation.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_subject', 'backend', 'Subject', 'script', '2018-05-31 09:22:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_message', 'backend', 'Message', 'script', '2018-05-31 09:23:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_is_active', 'backend', 'Send this message', 'script', '2018-05-31 09:23:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send this message', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_sms_na', 'backend', 'SMS not available', 'script', '2018-05-31 09:24:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notifications are currently not available for your website. See details', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_sms_na_here', 'backend', 'here', 'script', '2018-05-31 09:24:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'here', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_send', 'backend', 'Notifications / Send', 'script', '2018-05-31 09:25:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_do_not_send', 'backend', 'Notifications / Do not send', 'script', '2018-05-31 09:26:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Do not send', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_status', 'backend', 'Notifications / Status', 'script', '2018-05-31 09:26:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_client', 'backend', 'Notifications / Messages sent to Clients', 'script', '2018-05-31 09:27:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Clients', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_admin', 'backend', 'Notifications / Messages sent to Admin', 'script', '2018-05-31 09:30:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Admin', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_employee', 'backend', 'Notifications / Messages sent to Employee', 'script', '2018-05-31 09:30:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_default', 'backend', 'Notifications / Messages sent to Default', 'script', '2018-05-31 09:31:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_main_title', 'backend', 'Notifications', 'script', '2018-05-31 09:32:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_main_subtitle', 'backend', 'Notifications (sub-title)', 'script', '2018-05-31 09:33:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Automated messages are sent both to client and administrator(s) on specific events. Select message type to edit it - enable/disable or just change message text. For SMS notifications you need to enable SMS service. See more <a href="https://www.phpjabbers.com/web-sms/" target="_blank">here</a>.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_recipient', 'backend', 'Notifications / Recipient', 'script', '2018-05-31 09:33:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Recipient', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_tokens_note', 'backend', 'Notifications / Tokens (note)', 'script', '2018-05-31 09:35:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Personalize the message by including any of the available tokens and it will be replaced with corresponding data.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'notifications_tokens', 'backend', 'Notifications / Tokens', 'script', '2018-05-31 09:38:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens:', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_client', 'arrays', 'Recipients / Client', 'script', '2018-05-31 09:39:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_admin', 'arrays', 'Recipients / Administrator', 'script', '2018-05-31 09:39:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administrator', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'recipient_admin_note', 'backend', 'Recipients / Administrator (note)', 'script', '2018-05-31 09:40:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Go to <a href="index.php?controller=pjBaseUsers&action=pjActionIndex">Users menu</a> and edit each administrator profile to select if they should receive "Admin notifications" or not.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_employee', 'arrays', 'Recipients / Employee', 'script', '2018-05-31 09:39:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'opt_o_email_body_text', 'backend', 'Options / Email body text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, @id, 'pjField', 1, 'title', '<div class="col-xs-6">
<div><small>{Name}</small></div>
<div><small>{Phone}</small></div>
<div><small>{Email}</small></div>
<div><small>{Notes}</small></div>
<div><small>{Address1}</small></div>
<div><small>{Address2}</small></div>
<div><small>{City}</small></div>
<div><small>{State}</small></div>
<div><small>{Zip}</small></div>
<div><small>{Country}</small></div>
<div><small>{BookingID}</small></div>
<div><small>{Services}</small></div>
</div>
<div class="col-xs-6">
<div><small>{CCType}</small></div>
<div><small>{CCNum}</small></div>
<div><small>{CCExpMonth}</small></div>
<div><small>{CCExpYear}</small></div>
<div><small>{CCSec}</small></div>
<div><small>{PaymentMethod}</small></div>
<div><small>{Price}</small></div>
<div><small>{Deposit}</small></div>
<div><small>{Tax}</small></div>
<div><small>{Total}</small></div>
<div><small>{CancelURL}</small></div>
 </div>
', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'tab_default', 'backend', 'Label / Tab / Default', 'script', '2017-12-22 08:14:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Default', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'tab_days_off', 'backend', 'Label / Tab / Days off', 'script', '2017-12-22 08:15:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Days off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_set_wtime', 'backend', 'Label / Button / Set Working Times', 'script', '2017-12-22 08:17:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set Working Times', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day', 'backend', 'Label / Button / Day', 'script', '2017-12-28 08:04:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'hours', 'backend', 'Label / Hours', 'script', '2017-12-22 08:18:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working hours', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lunch_break', 'backend', 'Label / Lunch break', 'script', '2017-12-22 08:18:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch break', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'day_off', 'backend', 'Label / Button / Day off', 'script', '2017-12-22 08:26:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Day off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lunch_off', 'backend', 'Label / Button / Lunch off', 'script', '2017-12-22 08:26:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'set_working_times', 'backend', 'Label / Set Working Times', 'script', '2017-12-22 08:48:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Set Working Times', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'select_day', 'backend', 'Label / Select day', 'script', '2017-12-22 08:48:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select day', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'choose', 'backend', 'Label / Choose', 'script', '2017-12-22 08:52:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_cancel', 'backend', 'Label / Button / Cancel', 'script', '2017-12-22 08:58:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'wokring_from', 'backend', 'Label / Working Time From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time From', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'wokring_to', 'backend', 'Label / Working Time To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'from', 'backend', 'Label / Working Time From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'to', 'backend', 'Label / Working Time To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lunch_from', 'backend', 'Label / Lunch Break From', 'script', '2017-12-22 08:59:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break From', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'lunch_to', 'backend', 'Label / Lunch Break To', 'script', '2017-12-22 08:59:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'invalid_selected_time', 'backend', 'Label / End time cannot be less than start time.', 'script', '2017-12-22 10:41:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time From must precede Working Time To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'duplicated_time', 'backend', 'Label / Duplicated time on weekday', 'script', '2017-12-28 02:23:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Duplicated time on %s.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_PAMT01', 'arrays', 'error_titles_ARRAY_PAMT01', 'script', '2017-12-28 02:55:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Working Time Updated!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_PAMT01', 'arrays', 'error_bodies_ARRAY_PAMT01', 'script', '2017-12-28 02:56:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All changes made to the default working time have been saved successfully. ', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_add_day_off', 'backend', 'Label / Button / Add Day Off', 'script', '2017-12-28 03:22:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add Day Off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'add_day_off', 'backend', 'Label / Add Day Off', 'script', '2017-12-28 03:24:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Add custom working time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'from_date', 'backend', 'Label / From date', 'script', '2017-12-28 03:24:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'to_date', 'backend', 'Label / To date', 'script', '2017-12-28 03:24:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'from_time', 'backend', 'Label / From time', 'script', '2017-12-28 03:25:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'to_time', 'backend', 'Label / To time', 'script', '2017-12-28 03:25:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'To Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dates', 'backend', 'Label / Date(s)', 'script', '2017-12-28 03:35:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date(s)', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'hour', 'backend', 'Label / Hour', 'script', '2017-12-28 03:36:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Hour', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'all_day', 'backend', 'Label / All day', 'script', '2017-12-28 03:47:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All day', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'invalid_dates_off', 'backend', 'Label / From date must be less than To date.', 'script', '2017-12-28 04:17:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Date must precede To Date', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'invalid_day_off_time', 'backend', 'Label / From time must be less than To time.', 'script', '2017-12-28 04:20:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'From Time must precede To Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'advance_search', 'backend', 'Label / Advance Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Advance Search', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_select_image', 'backend', 'Label / Select image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Select image', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_change_image', 'backend', 'Label / Change image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Change image', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_next_7_days', 'backend', 'Label / Next 7 days', 'script', '2018-01-12 03:45:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Next 7 days', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_upcoming_bookings', 'backend', 'Label / Upcoming Bookings', 'script', '2018-01-12 03:46:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Upcoming Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_confirmed', 'backend', 'Label / confirmed', 'script', '2018-01-12 03:46:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'confirmed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_pending', 'backend', 'Label / pending', 'script', '2018-01-12 03:46:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'pending', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_this_month', 'backend', 'Label / This Month', 'script', '2018-01-12 03:47:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'This Month', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_all_bookings', 'backend', 'Label / All Bookings', 'script', '2018-01-12 03:48:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'All Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_singular_booking', 'backend', 'Label / booking', 'script', '2018-01-12 03:49:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_plural_bookings', 'backend', 'Label / bookings', 'script', '2018-01-12 03:50:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_total_amount', 'backend', 'Label / total amount', 'script', '2018-01-12 03:50:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'total amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_updated', 'backend', 'Label / Updated', 'script', '2018-01-12 03:52:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Updated', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_booking_past_6_months', 'backend', 'Label / Bookings past 6 months', 'script', '2018-01-12 03:53:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings past 6 months', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_what_on_today', 'backend', 'Label / What''s on today?', 'script', '2018-01-12 03:53:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'What''s on today?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_you_have', 'backend', 'Label / You have', 'script', '2018-01-12 03:55:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'You have', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_bookings_today', 'backend', 'Label / bookings today', 'script', '2018-01-12 03:56:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'bookings today', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_booking_today', 'backend', 'Label / booking today', 'script', '2018-01-12 03:57:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'booking today', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_view_schedule', 'backend', 'Label / View Schedule', 'script', '2018-01-12 03:58:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View Schedule', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_service', 'backend', 'Label / Service', 'script', '2018-01-12 04:00:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_duration', 'backend', 'Label / Duration', 'script', '2018-01-12 04:00:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Duration', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_hours', 'backend', 'Label / hours', 'script', '2018-01-12 04:07:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hours', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_hour', 'backend', 'Label / hour', 'script', '2018-01-12 04:08:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hour', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_mins', 'backend', 'Label / mins', 'script', '2018-01-12 04:08:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'mins', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_min', 'backend', 'Label / min', 'script', '2018-01-12 04:08:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'min', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_price', 'backend', 'Label / Price', 'script', '2018-01-12 04:09:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_package', 'backend', 'Label / Package', 'script', '2018-01-12 04:12:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Package', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_latest_bookings', 'backend', 'Label / Latest Bookings', 'script', '2018-01-12 04:52:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Latest Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_total', 'backend', 'Label / total', 'script', '2018-01-12 04:53:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'total', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_booking_made', 'backend', 'Label / booking made', 'script', '2018-01-12 04:54:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'booking made', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_bookings_made', 'backend', 'Label / bookings made', 'script', '2018-01-12 04:54:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'bookings made', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_view_all_bookings', 'backend', 'Label / View All Bookings', 'script', '2018-01-12 04:55:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'View All Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_date_time', 'backend', 'Label / Date/Time', 'script', '2018-01-12 04:55:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Date/Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_client', 'backend', 'Label / Client', 'script', '2018-01-12 04:56:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_service_package', 'backend', 'Label / Service', 'script', '2018-01-12 04:56:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_status', 'backend', 'Label / Status', 'script', '2018-01-12 04:57:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_bookings', 'backend', 'Label / Bookings', 'script', '2018-01-12 05:15:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'dash_no_bookings_found', 'backend', 'Label / No bookings found.', 'script', '2018-01-26 04:56:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'No bookings found.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'menu_schedule', 'backend', 'Label / Schedule', 'script', '2018-01-03 02:12:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Schedule', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infobox_schedule_title', 'backend', 'Label / Infobox / Schedule', 'script', '2018-01-03 03:05:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Schedule', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'infobox_schedule_desc', 'backend', 'Label / Infobox / Schedule', 'script', '2018-01-03 03:05:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'By default below you weekly or monthly schedules. Use "jump to" to switch to any week/month. You can also print the schedule by clicking on the Print button.', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'jumb_to', 'backend', 'Label / Jump to', 'script', '2018-01-03 03:22:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Jump to', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_print', 'backend', 'Label / Print', 'script', '2018-01-03 03:24:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'week', 'backend', 'Label / Week', 'script', '2018-01-03 03:42:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Week', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'available', 'backend', 'Label / Available', 'script', '2018-01-03 04:38:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Available', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'monthly_view', 'backend', 'Label / Monthly View', 'script', '2018-01-03 04:39:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Monthly View', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'weekly_view', 'backend', 'Label / Weekly View', 'script', '2018-01-03 04:39:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Weekly View', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'send_reminder', 'backend', 'Label / Send reminder', 'script', '2018-01-03 09:03:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send reminder', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'are_you_sure', 'backend', 'Label / Are you sure?', 'script', '2018-01-04 04:57:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_text', 'backend', 'Label / Cancel', 'script', '2018-01-04 04:58:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Are you sure that you want to cancel the selected service?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_confirm_cancel', 'backend', 'Label / Yes, cancel it!', 'script', '2018-01-04 04:59:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Yes, cancel it!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'cancel_appointment', 'backend', 'Label / Cancel appointment', 'script', '2018-01-04 07:24:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cancel appointment', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'client_email', 'backend', 'Label / Client email', 'script', '2018-01-04 07:36:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Client email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'btn_send', 'backend', 'Label / Send', 'script', '2018-01-04 07:40:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_install_your_website', 'backend', 'Label / Install your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Install your website', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_preview_your_website', 'backend', 'Label / Preview your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Open in new window', 'script');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdmin_pjActionIndex');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Dashboard', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, NULL, 'pjAdmin_pjActionProfile', 'F');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Profile', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminSchedule');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Schedule Menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminSchedule_pjActionWeekly');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Weekly', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionPrintWeekly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Print weekly', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionCancelServiceWeekly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Cancel Service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionReminderEmailWeekly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reminder Email', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminSchedule_pjActionMonthly');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Weekly', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionPrintMonthly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Print weekly', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionCancelServiceMonthly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Cancel Service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminSchedule_pjActionReminderEmailMonthly');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reminder Email', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminBookings');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Bookings Menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Booking List', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionCreate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Add booking', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionCheckUID');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check UID', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionCheckOverwrite');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check Overwrite', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionGetPrice');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get price', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionGetService');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show services', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemAdd');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item add', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemDelete');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item delete', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemGet');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item get', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemEmail');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item email', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemSms');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item SMS', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionUpdate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Edit booking', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionCheckUID');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check UID', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionCheckOverwrite');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check Overwrite', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionGetPrice');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get price', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionGetService');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get service', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemAdd');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item add', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemDelete');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item delete', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemGet');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item get', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemEmail');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item email', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminBookings_pjActionItemSms');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item SMS', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBooking');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single booking', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBookingBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete multiple bookings', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionGetBooking', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show list elements', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionSaveBooking', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save booking', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionList', 'F');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Booking List for employee', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionGetBookingService', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get booking', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionViewBookingService', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'View booking service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionItemEmail', 'F');
	SET @level_3_id := (SELECT LAST_INSERT_ID());
	INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item email', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionItemSms', 'F');
	SET @level_3_id := (SELECT LAST_INSERT_ID());
	INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Item SMS', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminServices');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Service menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminServices_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Service List', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionCreate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Add service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionUpdate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Edit service', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminServices_pjActionDeleteImage');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Image', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionDeleteService');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionDeleteServiceBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete multiple services', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionGetService', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show list elements', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminServices_pjActionSaveService', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save service', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminEmployees');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Employee menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminEmployees_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Employee List', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionCreate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Add employee', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminEmployees_pjActionCheckEmail');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check Email', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionUpdate');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Edit employee', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminEmployees_pjActionCheckEmail');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check Email', 'data');

      INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_3_id, 'pjAdminEmployees_pjActionDeleteAvatar');
	  SET @level_4_id := (SELECT LAST_INSERT_ID());
	  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_4_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Image', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionDeleteEmployee');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single employee', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionDeleteEmployeeBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete multiple employees', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionGetEmployee', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Show list elements', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionSaveEmployee', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save employee', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminEmployees_pjActionTime');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionSetTime');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionSaveTime', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionGetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionCheckDayOff', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check day off', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionSetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionDeleteDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionDeleteDayOffBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminEmployees_pjActionGetUpdate', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get Update', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminReports');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Report Menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminReports_pjActionEmployees');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Report employee', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminReports_pjActionGetEmployee', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get employee', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminReports_pjActionServices');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Report service', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminReports_pjActionGetService', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get service', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminReports_pjActionPrint');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Print', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Options Menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBooking');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reservation Options', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionPayments');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Payment Options', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBookingForm');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reservation Form', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionNotifications');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Notifications', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionTerm');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Terms & Conditions', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionReminder');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Reminder Options', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminTime');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Working Time Menu', 'data');

  INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminTime_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());
  INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_2_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Default Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSetTime');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSaveTime', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Save time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionGetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionCheckDayOff', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Check day off', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionSetDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionDeleteDayOff');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionDeleteDayOffBulk');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'data');

    INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`, `is_shown`) VALUES (NULL, @level_2_id, 'pjAdminTime_pjActionGetUpdate', 'F');
    SET @level_3_id := (SELECT LAST_INSERT_ID());
    INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_3_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Get Update', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionPreview');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Preview Menu', 'data');

INSERT INTO `appscheduler_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionInstall');
SET @level_1_id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @level_1_id, 'pjAuthPermission', '::LOCALE::', 'title', 'Integration Code Menu', 'data');

ALTER TABLE `appscheduler_bookings` MODIFY `payment_method` varchar(255) DEFAULT NULL;

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionIndex', 'backend', 'Label / Dashboard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionProfile', 'backend', 'Label / Profile', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule', 'backend', 'Label / Schedule Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Schedule Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionWeekly', 'backend', 'Label / Weekly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Weekly', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionPrintWeekly', 'backend', 'Label / Print weekly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print weekly', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionCancelServiceWeekly', 'backend', 'Label / Cancel Service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionCancelServiceMonthly', 'backend', 'Label / Cancel Service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel Service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionReminderEmailWeekly', 'backend', 'Label / Reminder Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reminder Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionReminderEmailMonthly', 'backend', 'Label / Reminder Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reminder Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionMonthly', 'backend', 'Label / Monthly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monthly', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminSchedule_pjActionPrintMonthly', 'backend', 'Label / Print weekly', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print weekly', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings', 'backend', 'Label / Bookings Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionIndex', 'backend', 'Label / Booking List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking List', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCreate', 'backend', 'Label / Add booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCheckUID', 'backend', 'Label / Check UID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check UID', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCheckOverwrite', 'backend', 'Label / Check Overwrite', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check Overwrite', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionGetPrice', 'backend', 'Label / Get price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get price', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionGetService', 'backend', 'Label / Get service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionItemAdd', 'backend', 'Label / Item add', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Item add', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionItemDelete', 'backend', 'Label / Item delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Item delete', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionItemGet', 'backend', 'Label / Item get', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Item get', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionItemEmail', 'backend', 'Label / Item email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Item email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionItemSms', 'backend', 'Label / Item SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Item SMS', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionUpdate', 'backend', 'Label / Edit booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBooking', 'backend', 'Label / Delete single booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBookingBulk', 'backend', 'Label / Delete multiple bookings', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple bookings', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionGetBooking', 'backend', 'Label / Get booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show list elements', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionSaveBooking', 'backend', 'Label / Save booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionList', 'backend', 'Label / Booking List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking List for employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionGetBookingService', 'backend', 'Label / Get booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get booking', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionViewBookingService', 'backend', 'Label / View booking service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'View booking service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices', 'backend', 'Label / Service menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Service menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionIndex', 'backend', 'Label / Service List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Service List', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionCreate', 'backend', 'Label / Add service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionUpdate', 'backend', 'Label / Edit service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionDeleteImage', 'backend', 'Label / Delete Image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Image', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionDeleteService', 'backend', 'Label / Delete single service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionDeleteServiceBulk', 'backend', 'Label / Delete multiple services', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple services', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionGetService', 'backend', 'Label / Get service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show list elements', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminServices_pjActionSaveService', 'backend', 'Label / Get service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees', 'backend', 'Label / Employee menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Employee menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionIndex', 'backend', 'Label / Employee List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Employee List', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionCreate', 'backend', 'Label / Add employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionCheckEmail', 'backend', 'Label / Check Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check Email', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionUpdate', 'backend', 'Label / Edit employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionDeleteAvatar', 'backend', 'Label / Delete Image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Image', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionDeleteEmployee', 'backend', 'Label / Delete single employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionDeleteEmployeeBulk', 'backend', 'Label / Delete multiple employees', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple employees', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionGetEmployee', 'backend', 'Label / Get employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show list elements', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionSaveEmployee', 'backend', 'Label / Save employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionTime', 'backend', 'Label / Working Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionSetTime', 'backend', 'Label / Set time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionSaveTime', 'backend', 'Label / Save time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionGetDayOff', 'backend', 'Label / Get day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionCheckDayOff', 'backend', 'Label / Check day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check day off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionSetDayOff', 'backend', 'Label / Set day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionDeleteDayOff', 'backend', 'Label / Delete day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionDeleteDayOffBulk', 'backend', 'Label / Delete day off bulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminEmployees_pjActionGetUpdate', 'backend', 'Label / Get Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports', 'backend', 'Label / Report Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Report Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports_pjActionEmployees', 'backend', 'Label / Report employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Report employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports_pjActionGetEmployee', 'backend', 'Label / Get employee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get employee', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports_pjActionServices', 'backend', 'Label / Report service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Report service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports_pjActionGetService', 'backend', 'Label / Get service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get service', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminReports_pjActionPrint', 'backend', 'Label / Print', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions', 'backend', 'Label / Options Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBooking', 'backend', 'Label / Reservation Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation Options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionPayments', 'backend', 'Label / Payment Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBookingForm', 'backend', 'Label / Reservation Form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation Form', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionNotifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionTerm', 'backend', 'Label / Terms & Conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms & Conditions', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionReminder', 'backend', 'Label / Reminder Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reminder Options', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime', 'backend', 'Label / Working Time Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Working Time Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionIndex', 'backend', 'Label / Default Working Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSetTime', 'backend', 'Label / Set time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSaveTime', 'backend', 'Label / Save time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionGetDayOff', 'backend', 'Label / Get day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionCheckDayOff', 'backend', 'Label / Check day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Check day off', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionSetDayOff', 'backend', 'Label / Set day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create/Update Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionDeleteDayOff', 'backend', 'Label / Delete day off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionDeleteDayOffBulk', 'backend', 'Label / Delete day off bulk', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete Multiple Custom Working Times', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminTime_pjActionGetUpdate', 'backend', 'Label / Get Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update Custom Working Time', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionPreview', 'backend', 'Label / Preview Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview Menu', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionInstall', 'backend', 'Label / Integration Code Menu', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Integration Code Menu', 'script');

UPDATE `appscheduler_options` SET `value` = '1|0::1' WHERE `key` = 'o_allow_cash';
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES(NULL, '1', 'pjPayment', '1', 'cash', 'Cash', 'data');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_cash', 'arrays', 'payment_methods_ARRAY_cash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Cash', 'script');

ALTER TABLE `appscheduler_dates` ADD `start_lunch` time DEFAULT NULL AFTER `end_time`;
ALTER TABLE `appscheduler_dates` ADD `end_lunch` time DEFAULT NULL AFTER `start_lunch`;
ALTER TABLE `appscheduler_dates` ADD `is_dayoff` enum('T','F') DEFAULT 'F' AFTER `end_lunch`;

UPDATE `appscheduler_options` SET `order` = '15' WHERE `key` = 'o_bf_city';
UPDATE `appscheduler_options` SET `order` = '12' WHERE `key` = 'o_bf_country';

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "services_required");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Adding a service is required' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "btn_add_day_off");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Add custom' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

SET @id := (SELECT `id` FROM `appscheduler_plugin_base_fields` WHERE `key` = "booking_query");
UPDATE `appscheduler_plugin_base_multi_lang` SET `content` = 'Search for' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridTotalPrefix', 'backend', 'Grid / of', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'of', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridTotalSuffix', 'backend', 'Grid / total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'total', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridShow', 'backend', 'Grid / Show', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridEmptyDate', 'backend', 'Grid / (empty date)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '(empty date)', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'gridInvalidDate', 'backend', 'Grid / (invalid date)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '(invalid date)', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_confirmed', 'backend', 'enum_arr_ARRAY_confirmed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_pending', 'backend', 'enum_arr_ARRAY_pending', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_cancelled', 'backend', 'enum_arr_ARRAY_cancelled', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelled', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_1', 'backend', 'enum_arr_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_2', 'backend', 'enum_arr_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_3', 'backend', 'enum_arr_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes (required)', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_amount', 'backend', 'enum_arr_ARRAY_amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Amount', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'enum_arr_ARRAY_percent', 'backend', 'enum_arr_ARRAY_percent', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Percent', 'script');

UPDATE `appscheduler_plugin_base_options` SET `value`='Yes|No::Yes' WHERE `key`='o_auto_backup';

INSERT INTO `appscheduler_plugin_base_cron_jobs` (`name`, `controller`, `action`, `interval`, `period`, `is_active`) VALUES
('Send Email and SMS reminders', 'pjCron', 'pjActionIndex', 10, 'minute', 1);

INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES
(NULL, '1', 'pjCalendar', '1', 'o_reminder_subject', 'Booking Reminder', 'data'),
(NULL, '1', 'pjCalendar', '1', 'o_reminder_body', 'Dear {Name},<br/><br/>Your booking is coming soon!<br/><br/>Booking ID: {BookingID}<br/><br/>Services<br/>{Services}<br/><br/>Regards,<br/>The Management', 'data'),
(NULL, '1', 'pjCalendar', '1', 'o_reminder_sms_message', '{Name}, your booking is coming.', 'data');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjBaseBackup_pjActionAutoBackup', 'backend', 'Label / backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Create automatic back-ups for database and files', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'pjCron_pjActionIndex', 'backend', 'Label / backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Send Email and SMS reminders', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'script_name', 'backend', 'Label / Script name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Appointment Scheduler', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'wt_title_over', 'backend', 'Label / Warning', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Warning', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'wt_body_over', 'backend', 'Label / Overwrite current working time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Do you want to overwrite current working time?', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'invalid_lunch_selected_time', 'backend', 'Label / Invalid lunch time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break From must precede Lunch Break To', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'minutes_lowercase', 'backend', 'Label / Minutes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'minutes', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'hours_lowercase', 'backend', 'Label / Hours', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'hours', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'invalid_lunch_time', 'backend', 'Label / Invalid lunch time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Lunch Break hours you have set are not within the Working Time hours', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'overwrite_title', 'backend', 'Label / Warning', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'Warning', 'script');

INSERT INTO `appscheduler_plugin_base_fields` VALUES (NULL, 'overwrite_body', 'backend', 'Label / Overwrite current working time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` VALUES (NULL, @id, 'pjField', '::LOCALE::', 'title', 'There is a Confirmed booking with same time!', 'script');

INSERT INTO `appscheduler_plugin_base_fields` (`id`, `key`, `type`, `label`, `source`, `modified`) VALUES
(NULL, 'opt_o_reminder_cron_text', 'backend', 'Option / Cron text', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `appscheduler_plugin_base_multi_lang` (`id`, `foreign_id`, `model`, `locale`, `field`, `content`, `source`) VALUES
(NULL, @id, 'pjField', 1, 'title', 'You need to set CRON jobs. Please, go to System Options - Cron jobs and follow the instructions.', 'script');
