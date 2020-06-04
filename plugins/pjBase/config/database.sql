DROP TABLE IF EXISTS `plugin_base_countries`;
CREATE TABLE IF NOT EXISTS `plugin_base_countries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alpha_2` varchar(2) DEFAULT NULL,
  `alpha_3` varchar(3) DEFAULT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`),
  UNIQUE KEY `alpha_2` (`alpha_2`),
  UNIQUE KEY `alpha_3` (`alpha_3`),
  KEY `status` (`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_cron_jobs`;
CREATE TABLE IF NOT EXISTS `plugin_base_cron_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `controller` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `interval` int(11) DEFAULT NULL,
  `period` enum('minute','hour','day','week','month') DEFAULT 'hour',
  `next_run` datetime DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `status` text,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `controller_action` (`controller`,`action`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_currencies`;
CREATE TABLE IF NOT EXISTS `plugin_base_currencies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(10) DEFAULT NULL,
  `sign` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_fields`;
CREATE TABLE IF NOT EXISTS `plugin_base_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) DEFAULT NULL,
  `type` enum('backend','frontend','arrays') DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `source` enum('script','plugin') DEFAULT 'script',
  `modified` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key` (`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_locale`;
CREATE TABLE IF NOT EXISTS `plugin_base_locale` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language_iso` varchar(20) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `flag` varchar(255) DEFAULT NULL,
  `dir` enum('ltr','rtl') DEFAULT 'ltr',
  `sort` int(10) unsigned DEFAULT NULL,
  `is_default` tinyint(1) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `language_iso` (`language_iso`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_locale_languages`;
CREATE TABLE IF NOT EXISTS `plugin_base_locale_languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `iso` varchar(20) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `native` varchar(255) DEFAULT NULL,
  `dir` enum('ltr','rtl') DEFAULT 'ltr',
  `country_abbr` varchar(3) DEFAULT NULL,
  `language_abbr` varchar(3) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iso` (`iso`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_log`;
CREATE TABLE IF NOT EXISTS `plugin_base_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  `function` varchar(255) DEFAULT NULL,
  `value` text,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_log_config`;
CREATE TABLE IF NOT EXISTS `plugin_base_log_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_multi_lang`;
CREATE TABLE IF NOT EXISTS `plugin_base_multi_lang` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) unsigned DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `locale` tinyint(3) unsigned DEFAULT NULL,
  `field` varchar(50) DEFAULT NULL,
  `content` text,
  `source` enum('script','plugin','data') DEFAULT 'script',
  PRIMARY KEY (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`model`,`locale`,`field`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `plugin_base_options`;
CREATE TABLE IF NOT EXISTS `plugin_base_options` (
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

DROP TABLE IF EXISTS `plugin_base_sms`;
CREATE TABLE IF NOT EXISTS `plugin_base_sms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(255) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `plugin_base_cron_jobs` (`name`, `controller`, `action`, `interval`, `period`, `is_active`) VALUES
('Create automatic back-ups for database and files', 'pjBaseBackup', 'pjActionAutoBackup', 1, 'week', 1);

INSERT INTO `plugin_base_currencies` (`id`, `code`, `sign`) VALUES
(NULL, 'USD', '$'),
(NULL, 'GBP', '&pound;'),
(NULL, 'EUR', '&euro;');

INSERT INTO `plugin_base_multi_lang` VALUES
(NULL, 1, 'pjBaseCountry', '::LOCALE::', 'name', 'Afghanistan', 'plugin'),
(NULL, 2, 'pjBaseCountry', '::LOCALE::', 'name', 'Åland Islands', 'plugin'),
(NULL, 3, 'pjBaseCountry', '::LOCALE::', 'name', 'Albania', 'plugin'),
(NULL, 4, 'pjBaseCountry', '::LOCALE::', 'name', 'Algeria', 'plugin'),
(NULL, 5, 'pjBaseCountry', '::LOCALE::', 'name', 'American Samoa', 'plugin'),
(NULL, 6, 'pjBaseCountry', '::LOCALE::', 'name', 'Andorra', 'plugin'),
(NULL, 7, 'pjBaseCountry', '::LOCALE::', 'name', 'Angola', 'plugin'),
(NULL, 8, 'pjBaseCountry', '::LOCALE::', 'name', 'Anguilla', 'plugin'),
(NULL, 9, 'pjBaseCountry', '::LOCALE::', 'name', 'Antarctica', 'plugin'),
(NULL, 10, 'pjBaseCountry', '::LOCALE::', 'name', 'Antigua and Barbuda', 'plugin'),
(NULL, 11, 'pjBaseCountry', '::LOCALE::', 'name', 'Argentina', 'plugin'),
(NULL, 12, 'pjBaseCountry', '::LOCALE::', 'name', 'Armenia', 'plugin'),
(NULL, 13, 'pjBaseCountry', '::LOCALE::', 'name', 'Aruba', 'plugin'),
(NULL, 14, 'pjBaseCountry', '::LOCALE::', 'name', 'Australia', 'plugin'),
(NULL, 15, 'pjBaseCountry', '::LOCALE::', 'name', 'Austria', 'plugin'),
(NULL, 16, 'pjBaseCountry', '::LOCALE::', 'name', 'Azerbaijan', 'plugin'),
(NULL, 17, 'pjBaseCountry', '::LOCALE::', 'name', 'Bahamas', 'plugin'),
(NULL, 18, 'pjBaseCountry', '::LOCALE::', 'name', 'Bahrain', 'plugin'),
(NULL, 19, 'pjBaseCountry', '::LOCALE::', 'name', 'Bangladesh', 'plugin'),
(NULL, 20, 'pjBaseCountry', '::LOCALE::', 'name', 'Barbados', 'plugin'),
(NULL, 21, 'pjBaseCountry', '::LOCALE::', 'name', 'Belarus', 'plugin'),
(NULL, 22, 'pjBaseCountry', '::LOCALE::', 'name', 'Belgium', 'plugin'),
(NULL, 23, 'pjBaseCountry', '::LOCALE::', 'name', 'Belize', 'plugin'),
(NULL, 24, 'pjBaseCountry', '::LOCALE::', 'name', 'Benin', 'plugin'),
(NULL, 25, 'pjBaseCountry', '::LOCALE::', 'name', 'Bermuda', 'plugin'),
(NULL, 26, 'pjBaseCountry', '::LOCALE::', 'name', 'Bhutan', 'plugin'),
(NULL, 27, 'pjBaseCountry', '::LOCALE::', 'name', 'Bolivia, Plurinational State of', 'plugin'),
(NULL, 28, 'pjBaseCountry', '::LOCALE::', 'name', 'Bonaire, Sint Eustatius and Saba', 'plugin'),
(NULL, 29, 'pjBaseCountry', '::LOCALE::', 'name', 'Bosnia and Herzegovina', 'plugin'),
(NULL, 30, 'pjBaseCountry', '::LOCALE::', 'name', 'Botswana', 'plugin'),
(NULL, 31, 'pjBaseCountry', '::LOCALE::', 'name', 'Bouvet Island', 'plugin'),
(NULL, 32, 'pjBaseCountry', '::LOCALE::', 'name', 'Brazil', 'plugin'),
(NULL, 33, 'pjBaseCountry', '::LOCALE::', 'name', 'British Indian Ocean Territory', 'plugin'),
(NULL, 34, 'pjBaseCountry', '::LOCALE::', 'name', 'Brunei Darussalam', 'plugin'),
(NULL, 35, 'pjBaseCountry', '::LOCALE::', 'name', 'Bulgaria', 'plugin'),
(NULL, 36, 'pjBaseCountry', '::LOCALE::', 'name', 'Burkina Faso', 'plugin'),
(NULL, 37, 'pjBaseCountry', '::LOCALE::', 'name', 'Burundi', 'plugin'),
(NULL, 38, 'pjBaseCountry', '::LOCALE::', 'name', 'Cambodia', 'plugin'),
(NULL, 39, 'pjBaseCountry', '::LOCALE::', 'name', 'Cameroon', 'plugin'),
(NULL, 40, 'pjBaseCountry', '::LOCALE::', 'name', 'Canada', 'plugin'),
(NULL, 41, 'pjBaseCountry', '::LOCALE::', 'name', 'Cape Verde', 'plugin'),
(NULL, 42, 'pjBaseCountry', '::LOCALE::', 'name', 'Cayman Islands', 'plugin'),
(NULL, 43, 'pjBaseCountry', '::LOCALE::', 'name', 'Central African Republic', 'plugin'),
(NULL, 44, 'pjBaseCountry', '::LOCALE::', 'name', 'Chad', 'plugin'),
(NULL, 45, 'pjBaseCountry', '::LOCALE::', 'name', 'Chile', 'plugin'),
(NULL, 46, 'pjBaseCountry', '::LOCALE::', 'name', 'China', 'plugin'),
(NULL, 47, 'pjBaseCountry', '::LOCALE::', 'name', 'Christmas Island', 'plugin'),
(NULL, 48, 'pjBaseCountry', '::LOCALE::', 'name', 'Cocos array(Keeling) Islands', 'plugin'),
(NULL, 49, 'pjBaseCountry', '::LOCALE::', 'name', 'Colombia', 'plugin'),
(NULL, 50, 'pjBaseCountry', '::LOCALE::', 'name', 'Comoros', 'plugin'),
(NULL, 51, 'pjBaseCountry', '::LOCALE::', 'name', 'Congo', 'plugin'),
(NULL, 52, 'pjBaseCountry', '::LOCALE::', 'name', 'Congo, the Democratic Republic of the', 'plugin'),
(NULL, 53, 'pjBaseCountry', '::LOCALE::', 'name', 'Cook Islands', 'plugin'),
(NULL, 54, 'pjBaseCountry', '::LOCALE::', 'name', 'Costa Rica', 'plugin'),
(NULL, 55, 'pjBaseCountry', '::LOCALE::', 'name', 'Côte d''Ivoire', 'plugin'),
(NULL, 56, 'pjBaseCountry', '::LOCALE::', 'name', 'Croatia', 'plugin'),
(NULL, 57, 'pjBaseCountry', '::LOCALE::', 'name', 'Cuba', 'plugin'),
(NULL, 58, 'pjBaseCountry', '::LOCALE::', 'name', 'Curaçao', 'plugin'),
(NULL, 59, 'pjBaseCountry', '::LOCALE::', 'name', 'Cyprus', 'plugin'),
(NULL, 60, 'pjBaseCountry', '::LOCALE::', 'name', 'Czech Republic', 'plugin'),
(NULL, 61, 'pjBaseCountry', '::LOCALE::', 'name', 'Denmark', 'plugin'),
(NULL, 62, 'pjBaseCountry', '::LOCALE::', 'name', 'Djibouti', 'plugin'),
(NULL, 63, 'pjBaseCountry', '::LOCALE::', 'name', 'Dominica', 'plugin'),
(NULL, 64, 'pjBaseCountry', '::LOCALE::', 'name', 'Dominican Republic', 'plugin'),
(NULL, 65, 'pjBaseCountry', '::LOCALE::', 'name', 'Ecuador', 'plugin'),
(NULL, 66, 'pjBaseCountry', '::LOCALE::', 'name', 'Egypt', 'plugin'),
(NULL, 67, 'pjBaseCountry', '::LOCALE::', 'name', 'El Salvador', 'plugin'),
(NULL, 68, 'pjBaseCountry', '::LOCALE::', 'name', 'Equatorial Guinea', 'plugin'),
(NULL, 69, 'pjBaseCountry', '::LOCALE::', 'name', 'Eritrea', 'plugin'),
(NULL, 70, 'pjBaseCountry', '::LOCALE::', 'name', 'Estonia', 'plugin'),
(NULL, 71, 'pjBaseCountry', '::LOCALE::', 'name', 'Ethiopia', 'plugin'),
(NULL, 72, 'pjBaseCountry', '::LOCALE::', 'name', 'Falkland Islands array(Malvinas)', 'plugin'),
(NULL, 73, 'pjBaseCountry', '::LOCALE::', 'name', 'Faroe Islands', 'plugin'),
(NULL, 74, 'pjBaseCountry', '::LOCALE::', 'name', 'Fiji', 'plugin'),
(NULL, 75, 'pjBaseCountry', '::LOCALE::', 'name', 'Finland', 'plugin'),
(NULL, 76, 'pjBaseCountry', '::LOCALE::', 'name', 'France', 'plugin'),
(NULL, 77, 'pjBaseCountry', '::LOCALE::', 'name', 'French Guiana', 'plugin'),
(NULL, 78, 'pjBaseCountry', '::LOCALE::', 'name', 'French Polynesia', 'plugin'),
(NULL, 79, 'pjBaseCountry', '::LOCALE::', 'name', 'French Southern Territories', 'plugin'),
(NULL, 80, 'pjBaseCountry', '::LOCALE::', 'name', 'Gabon', 'plugin'),
(NULL, 81, 'pjBaseCountry', '::LOCALE::', 'name', 'Gambia', 'plugin'),
(NULL, 82, 'pjBaseCountry', '::LOCALE::', 'name', 'Georgia', 'plugin'),
(NULL, 83, 'pjBaseCountry', '::LOCALE::', 'name', 'Germany', 'plugin'),
(NULL, 84, 'pjBaseCountry', '::LOCALE::', 'name', 'Ghana', 'plugin'),
(NULL, 85, 'pjBaseCountry', '::LOCALE::', 'name', 'Gibraltar', 'plugin'),
(NULL, 86, 'pjBaseCountry', '::LOCALE::', 'name', 'Greece', 'plugin'),
(NULL, 87, 'pjBaseCountry', '::LOCALE::', 'name', 'Greenland', 'plugin'),
(NULL, 88, 'pjBaseCountry', '::LOCALE::', 'name', 'Grenada', 'plugin'),
(NULL, 89, 'pjBaseCountry', '::LOCALE::', 'name', 'Guadeloupe', 'plugin'),
(NULL, 90, 'pjBaseCountry', '::LOCALE::', 'name', 'Guam', 'plugin'),
(NULL, 91, 'pjBaseCountry', '::LOCALE::', 'name', 'Guatemala', 'plugin'),
(NULL, 92, 'pjBaseCountry', '::LOCALE::', 'name', 'Guernsey', 'plugin'),
(NULL, 93, 'pjBaseCountry', '::LOCALE::', 'name', 'Guinea', 'plugin'),
(NULL, 94, 'pjBaseCountry', '::LOCALE::', 'name', 'Guinea-Bissau', 'plugin'),
(NULL, 95, 'pjBaseCountry', '::LOCALE::', 'name', 'Guyana', 'plugin'),
(NULL, 96, 'pjBaseCountry', '::LOCALE::', 'name', 'Haiti', 'plugin'),
(NULL, 97, 'pjBaseCountry', '::LOCALE::', 'name', 'Heard Island and McDonald Islands', 'plugin'),
(NULL, 98, 'pjBaseCountry', '::LOCALE::', 'name', 'Holy See array(Vatican City State)', 'plugin'),
(NULL, 99, 'pjBaseCountry', '::LOCALE::', 'name', 'Honduras', 'plugin'),
(NULL, 100, 'pjBaseCountry', '::LOCALE::', 'name', 'Hong Kong', 'plugin'),
(NULL, 101, 'pjBaseCountry', '::LOCALE::', 'name', 'Hungary', 'plugin'),
(NULL, 102, 'pjBaseCountry', '::LOCALE::', 'name', 'Iceland', 'plugin'),
(NULL, 103, 'pjBaseCountry', '::LOCALE::', 'name', 'India', 'plugin'),
(NULL, 104, 'pjBaseCountry', '::LOCALE::', 'name', 'Indonesia', 'plugin'),
(NULL, 105, 'pjBaseCountry', '::LOCALE::', 'name', 'Iran, Islamic Republic of', 'plugin'),
(NULL, 106, 'pjBaseCountry', '::LOCALE::', 'name', 'Iraq', 'plugin'),
(NULL, 107, 'pjBaseCountry', '::LOCALE::', 'name', 'Ireland', 'plugin'),
(NULL, 108, 'pjBaseCountry', '::LOCALE::', 'name', 'Isle of Man', 'plugin'),
(NULL, 109, 'pjBaseCountry', '::LOCALE::', 'name', 'Israel', 'plugin'),
(NULL, 110, 'pjBaseCountry', '::LOCALE::', 'name', 'Italy', 'plugin'),
(NULL, 111, 'pjBaseCountry', '::LOCALE::', 'name', 'Jamaica', 'plugin'),
(NULL, 112, 'pjBaseCountry', '::LOCALE::', 'name', 'Japan', 'plugin'),
(NULL, 113, 'pjBaseCountry', '::LOCALE::', 'name', 'Jersey', 'plugin'),
(NULL, 114, 'pjBaseCountry', '::LOCALE::', 'name', 'Jordan', 'plugin'),
(NULL, 115, 'pjBaseCountry', '::LOCALE::', 'name', 'Kazakhstan', 'plugin'),
(NULL, 116, 'pjBaseCountry', '::LOCALE::', 'name', 'Kenya', 'plugin'),
(NULL, 117, 'pjBaseCountry', '::LOCALE::', 'name', 'Kiribati', 'plugin'),
(NULL, 118, 'pjBaseCountry', '::LOCALE::', 'name', 'Korea, Democratic People''s Republic of', 'plugin'),
(NULL, 119, 'pjBaseCountry', '::LOCALE::', 'name', 'Korea, Republic of', 'plugin'),
(NULL, 120, 'pjBaseCountry', '::LOCALE::', 'name', 'Kuwait', 'plugin'),
(NULL, 121, 'pjBaseCountry', '::LOCALE::', 'name', 'Kyrgyzstan', 'plugin'),
(NULL, 122, 'pjBaseCountry', '::LOCALE::', 'name', 'Lao People''s Democratic Republic', 'plugin'),
(NULL, 123, 'pjBaseCountry', '::LOCALE::', 'name', 'Latvia', 'plugin'),
(NULL, 124, 'pjBaseCountry', '::LOCALE::', 'name', 'Lebanon', 'plugin'),
(NULL, 125, 'pjBaseCountry', '::LOCALE::', 'name', 'Lesotho', 'plugin'),
(NULL, 126, 'pjBaseCountry', '::LOCALE::', 'name', 'Liberia', 'plugin'),
(NULL, 127, 'pjBaseCountry', '::LOCALE::', 'name', 'Libya', 'plugin'),
(NULL, 128, 'pjBaseCountry', '::LOCALE::', 'name', 'Liechtenstein', 'plugin'),
(NULL, 129, 'pjBaseCountry', '::LOCALE::', 'name', 'Lithuania', 'plugin'),
(NULL, 130, 'pjBaseCountry', '::LOCALE::', 'name', 'Luxembourg', 'plugin'),
(NULL, 131, 'pjBaseCountry', '::LOCALE::', 'name', 'Macao', 'plugin'),
(NULL, 132, 'pjBaseCountry', '::LOCALE::', 'name', 'Macedonia, The Former Yugoslav Republic of', 'plugin'),
(NULL, 133, 'pjBaseCountry', '::LOCALE::', 'name', 'Madagascar', 'plugin'),
(NULL, 134, 'pjBaseCountry', '::LOCALE::', 'name', 'Malawi', 'plugin'),
(NULL, 135, 'pjBaseCountry', '::LOCALE::', 'name', 'Malaysia', 'plugin'),
(NULL, 136, 'pjBaseCountry', '::LOCALE::', 'name', 'Maldives', 'plugin'),
(NULL, 137, 'pjBaseCountry', '::LOCALE::', 'name', 'Mali', 'plugin'),
(NULL, 138, 'pjBaseCountry', '::LOCALE::', 'name', 'Malta', 'plugin'),
(NULL, 139, 'pjBaseCountry', '::LOCALE::', 'name', 'Marshall Islands', 'plugin'),
(NULL, 140, 'pjBaseCountry', '::LOCALE::', 'name', 'Martinique', 'plugin'),
(NULL, 141, 'pjBaseCountry', '::LOCALE::', 'name', 'Mauritania', 'plugin'),
(NULL, 142, 'pjBaseCountry', '::LOCALE::', 'name', 'Mauritius', 'plugin'),
(NULL, 143, 'pjBaseCountry', '::LOCALE::', 'name', 'Mayotte', 'plugin'),
(NULL, 144, 'pjBaseCountry', '::LOCALE::', 'name', 'Mexico', 'plugin'),
(NULL, 145, 'pjBaseCountry', '::LOCALE::', 'name', 'Micronesia, Federated States of', 'plugin'),
(NULL, 146, 'pjBaseCountry', '::LOCALE::', 'name', 'Moldova, Republic of', 'plugin'),
(NULL, 147, 'pjBaseCountry', '::LOCALE::', 'name', 'Monaco', 'plugin'),
(NULL, 148, 'pjBaseCountry', '::LOCALE::', 'name', 'Mongolia', 'plugin'),
(NULL, 149, 'pjBaseCountry', '::LOCALE::', 'name', 'Montenegro', 'plugin'),
(NULL, 150, 'pjBaseCountry', '::LOCALE::', 'name', 'Montserrat', 'plugin'),
(NULL, 151, 'pjBaseCountry', '::LOCALE::', 'name', 'Morocco', 'plugin'),
(NULL, 152, 'pjBaseCountry', '::LOCALE::', 'name', 'Mozambique', 'plugin'),
(NULL, 153, 'pjBaseCountry', '::LOCALE::', 'name', 'Myanmar', 'plugin'),
(NULL, 154, 'pjBaseCountry', '::LOCALE::', 'name', 'Namibia', 'plugin'),
(NULL, 155, 'pjBaseCountry', '::LOCALE::', 'name', 'Nauru', 'plugin'),
(NULL, 156, 'pjBaseCountry', '::LOCALE::', 'name', 'Nepal', 'plugin'),
(NULL, 157, 'pjBaseCountry', '::LOCALE::', 'name', 'Netherlands', 'plugin'),
(NULL, 158, 'pjBaseCountry', '::LOCALE::', 'name', 'New Caledonia', 'plugin'),
(NULL, 159, 'pjBaseCountry', '::LOCALE::', 'name', 'New Zealand', 'plugin'),
(NULL, 160, 'pjBaseCountry', '::LOCALE::', 'name', 'Nicaragua', 'plugin'),
(NULL, 161, 'pjBaseCountry', '::LOCALE::', 'name', 'Niger', 'plugin'),
(NULL, 162, 'pjBaseCountry', '::LOCALE::', 'name', 'Nigeria', 'plugin'),
(NULL, 163, 'pjBaseCountry', '::LOCALE::', 'name', 'Niue', 'plugin'),
(NULL, 164, 'pjBaseCountry', '::LOCALE::', 'name', 'Norfolk Island', 'plugin'),
(NULL, 165, 'pjBaseCountry', '::LOCALE::', 'name', 'Northern Mariana Islands', 'plugin'),
(NULL, 166, 'pjBaseCountry', '::LOCALE::', 'name', 'Norway', 'plugin'),
(NULL, 167, 'pjBaseCountry', '::LOCALE::', 'name', 'Oman', 'plugin'),
(NULL, 168, 'pjBaseCountry', '::LOCALE::', 'name', 'Pakistan', 'plugin'),
(NULL, 169, 'pjBaseCountry', '::LOCALE::', 'name', 'Palau', 'plugin'),
(NULL, 170, 'pjBaseCountry', '::LOCALE::', 'name', 'Palestine, State of', 'plugin'),
(NULL, 171, 'pjBaseCountry', '::LOCALE::', 'name', 'Panama', 'plugin'),
(NULL, 172, 'pjBaseCountry', '::LOCALE::', 'name', 'Papua New Guinea', 'plugin'),
(NULL, 173, 'pjBaseCountry', '::LOCALE::', 'name', 'Paraguay', 'plugin'),
(NULL, 174, 'pjBaseCountry', '::LOCALE::', 'name', 'Peru', 'plugin'),
(NULL, 175, 'pjBaseCountry', '::LOCALE::', 'name', 'Philippines', 'plugin'),
(NULL, 176, 'pjBaseCountry', '::LOCALE::', 'name', 'Pitcairn', 'plugin'),
(NULL, 177, 'pjBaseCountry', '::LOCALE::', 'name', 'Poland', 'plugin'),
(NULL, 178, 'pjBaseCountry', '::LOCALE::', 'name', 'Portugal', 'plugin'),
(NULL, 179, 'pjBaseCountry', '::LOCALE::', 'name', 'Puerto Rico', 'plugin'),
(NULL, 180, 'pjBaseCountry', '::LOCALE::', 'name', 'Qatar', 'plugin'),
(NULL, 181, 'pjBaseCountry', '::LOCALE::', 'name', 'Réunion', 'plugin'),
(NULL, 182, 'pjBaseCountry', '::LOCALE::', 'name', 'Romania', 'plugin'),
(NULL, 183, 'pjBaseCountry', '::LOCALE::', 'name', 'Russian Federation', 'plugin'),
(NULL, 184, 'pjBaseCountry', '::LOCALE::', 'name', 'Rwanda', 'plugin'),
(NULL, 185, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Barthélemy', 'plugin'),
(NULL, 186, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Helena, Ascension and Tristan da Cunha', 'plugin'),
(NULL, 187, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Kitts and Nevis', 'plugin'),
(NULL, 188, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Lucia', 'plugin'),
(NULL, 189, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Martin array(French part)', 'plugin'),
(NULL, 190, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Pierre and Miquelon', 'plugin'),
(NULL, 191, 'pjBaseCountry', '::LOCALE::', 'name', 'Saint Vincent and the Grenadines', 'plugin'),
(NULL, 192, 'pjBaseCountry', '::LOCALE::', 'name', 'Samoa', 'plugin'),
(NULL, 193, 'pjBaseCountry', '::LOCALE::', 'name', 'San Marino', 'plugin'),
(NULL, 194, 'pjBaseCountry', '::LOCALE::', 'name', 'Sao Tome and Principe', 'plugin'),
(NULL, 195, 'pjBaseCountry', '::LOCALE::', 'name', 'Saudi Arabia', 'plugin'),
(NULL, 196, 'pjBaseCountry', '::LOCALE::', 'name', 'Senegal', 'plugin'),
(NULL, 197, 'pjBaseCountry', '::LOCALE::', 'name', 'Serbia', 'plugin'),
(NULL, 198, 'pjBaseCountry', '::LOCALE::', 'name', 'Seychelles', 'plugin'),
(NULL, 199, 'pjBaseCountry', '::LOCALE::', 'name', 'Sierra Leone', 'plugin'),
(NULL, 200, 'pjBaseCountry', '::LOCALE::', 'name', 'Singapore', 'plugin'),
(NULL, 201, 'pjBaseCountry', '::LOCALE::', 'name', 'Sint Maarten array(Dutch part)', 'plugin'),
(NULL, 202, 'pjBaseCountry', '::LOCALE::', 'name', 'Slovakia', 'plugin'),
(NULL, 203, 'pjBaseCountry', '::LOCALE::', 'name', 'Slovenia', 'plugin'),
(NULL, 204, 'pjBaseCountry', '::LOCALE::', 'name', 'Solomon Islands', 'plugin'),
(NULL, 205, 'pjBaseCountry', '::LOCALE::', 'name', 'Somalia', 'plugin'),
(NULL, 206, 'pjBaseCountry', '::LOCALE::', 'name', 'South Africa', 'plugin'),
(NULL, 207, 'pjBaseCountry', '::LOCALE::', 'name', 'South Georgia and the South Sandwich Islands', 'plugin'),
(NULL, 208, 'pjBaseCountry', '::LOCALE::', 'name', 'South Sudan', 'plugin'),
(NULL, 209, 'pjBaseCountry', '::LOCALE::', 'name', 'Spain', 'plugin'),
(NULL, 210, 'pjBaseCountry', '::LOCALE::', 'name', 'Sri Lanka', 'plugin'),
(NULL, 211, 'pjBaseCountry', '::LOCALE::', 'name', 'Sudan', 'plugin'),
(NULL, 212, 'pjBaseCountry', '::LOCALE::', 'name', 'Suriname', 'plugin'),
(NULL, 213, 'pjBaseCountry', '::LOCALE::', 'name', 'Svalbard and Jan Mayen', 'plugin'),
(NULL, 214, 'pjBaseCountry', '::LOCALE::', 'name', 'Swaziland', 'plugin'),
(NULL, 215, 'pjBaseCountry', '::LOCALE::', 'name', 'Sweden', 'plugin'),
(NULL, 216, 'pjBaseCountry', '::LOCALE::', 'name', 'Switzerland', 'plugin'),
(NULL, 217, 'pjBaseCountry', '::LOCALE::', 'name', 'Syrian Arab Republic', 'plugin'),
(NULL, 218, 'pjBaseCountry', '::LOCALE::', 'name', 'Taiwan, Province of China', 'plugin'),
(NULL, 219, 'pjBaseCountry', '::LOCALE::', 'name', 'Tajikistan', 'plugin'),
(NULL, 220, 'pjBaseCountry', '::LOCALE::', 'name', 'Tanzania, United Republic of', 'plugin'),
(NULL, 221, 'pjBaseCountry', '::LOCALE::', 'name', 'Thailand', 'plugin'),
(NULL, 222, 'pjBaseCountry', '::LOCALE::', 'name', 'Timor-Leste', 'plugin'),
(NULL, 223, 'pjBaseCountry', '::LOCALE::', 'name', 'Togo', 'plugin'),
(NULL, 224, 'pjBaseCountry', '::LOCALE::', 'name', 'Tokelau', 'plugin'),
(NULL, 225, 'pjBaseCountry', '::LOCALE::', 'name', 'Tonga', 'plugin'),
(NULL, 226, 'pjBaseCountry', '::LOCALE::', 'name', 'Trinidad and Tobago', 'plugin'),
(NULL, 227, 'pjBaseCountry', '::LOCALE::', 'name', 'Tunisia', 'plugin'),
(NULL, 228, 'pjBaseCountry', '::LOCALE::', 'name', 'Turkey', 'plugin'),
(NULL, 229, 'pjBaseCountry', '::LOCALE::', 'name', 'Turkmenistan', 'plugin'),
(NULL, 230, 'pjBaseCountry', '::LOCALE::', 'name', 'Turks and Caicos Islands', 'plugin'),
(NULL, 231, 'pjBaseCountry', '::LOCALE::', 'name', 'Tuvalu', 'plugin'),
(NULL, 232, 'pjBaseCountry', '::LOCALE::', 'name', 'Uganda', 'plugin'),
(NULL, 233, 'pjBaseCountry', '::LOCALE::', 'name', 'Ukraine', 'plugin'),
(NULL, 234, 'pjBaseCountry', '::LOCALE::', 'name', 'United Arab Emirates', 'plugin'),
(NULL, 235, 'pjBaseCountry', '::LOCALE::', 'name', 'United Kingdom', 'plugin'),
(NULL, 236, 'pjBaseCountry', '::LOCALE::', 'name', 'United States', 'plugin'),
(NULL, 237, 'pjBaseCountry', '::LOCALE::', 'name', 'United States Minor Outlying Islands', 'plugin'),
(NULL, 238, 'pjBaseCountry', '::LOCALE::', 'name', 'Uruguay', 'plugin'),
(NULL, 239, 'pjBaseCountry', '::LOCALE::', 'name', 'Uzbekistan', 'plugin'),
(NULL, 240, 'pjBaseCountry', '::LOCALE::', 'name', 'Vanuatu', 'plugin'),
(NULL, 241, 'pjBaseCountry', '::LOCALE::', 'name', 'Venezuela, Bolivarian Republic of', 'plugin'),
(NULL, 242, 'pjBaseCountry', '::LOCALE::', 'name', 'Viet Nam', 'plugin'),
(NULL, 243, 'pjBaseCountry', '::LOCALE::', 'name', 'Virgin Islands, British', 'plugin'),
(NULL, 244, 'pjBaseCountry', '::LOCALE::', 'name', 'Virgin Islands, U.S.', 'plugin'),
(NULL, 245, 'pjBaseCountry', '::LOCALE::', 'name', 'Wallis and Futuna', 'plugin'),
(NULL, 246, 'pjBaseCountry', '::LOCALE::', 'name', 'Western Sahara', 'plugin'),
(NULL, 247, 'pjBaseCountry', '::LOCALE::', 'name', 'Yemen', 'plugin'),
(NULL, 248, 'pjBaseCountry', '::LOCALE::', 'name', 'Zambia', 'plugin'),
(NULL, 249, 'pjBaseCountry', '::LOCALE::', 'name', 'Zimbabwe', 'plugin');

INSERT INTO `plugin_base_locale` (`id`, `language_iso`, `name`, `flag`, `dir`, `sort`, `is_default`) VALUES
(1, 'en-GB', 'English', NULL, 'ltr', 1, 1);

INSERT INTO `plugin_base_locale_languages` (`id`, `iso`, `title`, `region`, `native`, `dir`, `country_abbr`, `language_abbr`, `file`) VALUES
(1, 'af-ZA', 'Afrikaans', 'South Africa', 'Afrikaans (Suid Afrika)', 'ltr', 'ZAF', 'AFK', 'za.png'),
(2, 'sq-AL', 'Albanian', 'Albania', 'shqipe (Shqipëria)', 'ltr', 'ALB', 'SQI', 'al.png'),
(3, 'gsw-FR', 'Alsatian', 'France', 'Elsässisch (Frànkrisch)', 'ltr', 'FRA', 'GSW', 'fr.png'),
(4, 'am-ET', 'Amharic', 'Ethiopia', 'አማርኛ (ኢትዮጵያ)', 'ltr', 'ETH', 'AMH', 'et.png'),
(5, 'ar', 'Arabic‎', NULL, 'العربية‏', 'rtl', 'SAU', 'ARA', 'empty.png'),
(6, 'ar-DZ', 'Arabic', 'Algeria', 'العربية (الجزائر)‏', 'rtl', 'DZA', 'ARG', 'dz.png'),
(7, 'ar-BH', 'Arabic', 'Bahrain', 'العربية (البحرين)‏', 'rtl', 'BHR', 'ARH', 'bh.png'),
(8, 'ar-EG', 'Arabic', 'Egypt', 'العربية (مصر)‏', 'rtl', 'EGY', 'ARE', 'eg.png'),
(9, 'ar-IQ', 'Arabic', 'Iraq', 'العربية (العراق)‏', 'rtl', 'IRQ', 'ARI', 'iq.png'),
(10, 'ar-JO', 'Arabic', 'Jordan', 'العربية (الأردن)‏', 'rtl', 'JOR', 'ARJ', 'jo.png'),
(11, 'ar-KW', 'Arabic', 'Kuwait', 'العربية (الكويت)‏', 'rtl', 'KWT', 'ARK', 'kw.png'),
(12, 'ar-LB', 'Arabic', 'Lebanon', 'العربية (لبنان)‏', 'rtl', 'LBN', 'ARB', 'lb.png'),
(13, 'ar-LY', 'Arabic', 'Libya', 'العربية (ليبيا)‏', 'rtl', 'LBY', 'ARL', 'ly.png'),
(14, 'ar-MA', 'Arabic', 'Morocco', 'العربية (المملكة المغربية)‏', 'rtl', 'MAR', 'ARM', 'ma.png'),
(15, 'ar-OM', 'Arabic', 'Oman', 'العربية (عمان)‏', 'rtl', 'OMN', 'ARO', 'om.png'),
(16, 'ar-QA', 'Arabic', 'Qatar', 'العربية (قطر)‏', 'rtl', 'QAT', 'ARQ', 'qa.png'),
(17, 'ar-SA', 'Arabic', 'Saudi Arabia', 'العربية (المملكة العربية السعودية)‏', 'rtl', 'SAU', 'ARA', 'sa.png'),
(18, 'ar-SY', 'Arabic', 'Syria', 'العربية (سوريا)‏', 'rtl', 'SYR', 'ARS', 'sy.png'),
(19, 'ar-TN', 'Arabic', 'Tunisia', 'العربية (تونس)‏', 'rtl', 'TUN', 'ART', 'tn.png'),
(20, 'ar-AE', 'Arabic', 'U.A.E.', 'العربية (الإمارات العربية المتحدة)‏', 'rtl', 'ARE', 'ARU', 'ae.png'),
(21, 'ar-YE', 'Arabic', 'Yemen', 'العربية (اليمن)‏', 'rtl', 'YEM', 'ARY', 'ye.png'),
(22, 'hy-AM', 'Armenian', 'Armenia', 'Հայերեն (Հայաստան)', 'ltr', 'ARM', 'HYE', 'am.png'),
(23, 'as-IN', 'Assamese', 'India', 'অসমীয়া (ভাৰত)', 'ltr', 'IND', 'ASM', 'in.png'),
(24, 'az', 'Azeri', NULL, 'Azərbaycan­ılı', 'rtl', 'AZE', 'AZE', 'empty.png'),
(25, 'az-Cyrl', 'Azeri', 'Cyrillic', 'Азәрбајҹан дили', 'rtl', 'AZE', 'AZC', 'az.png'),
(26, 'az-Cyrl-AZ', 'Azeri', 'Cyrillic, Azerbaijan', 'Азәрбајҹан (Азәрбајҹан)', 'rtl', 'AZE', 'AZC', 'az.png'),
(27, 'az-Latn', 'Azeri', 'Latin', 'Azərbaycan­ılı', 'rtl', 'AZE', 'AZE', 'az.png'),
(28, 'az-Latn-AZ', 'Azeri', 'Latin, Azerbaijan', 'Azərbaycan­ılı (Azərbaycan)', 'rtl', 'AZE', 'AZE', 'az.png'),
(29, 'ba-RU', 'Bashkir', 'Russia', 'Башҡорт (Россия)', 'ltr', 'RUS', 'BAS', 'ru.png'),
(30, 'eu-ES', 'Basque', 'Basque', 'euskara (euskara)', 'ltr', 'ESP', 'EUQ', 'es.png'),
(31, 'be-BY', 'Belarusian', 'Belarus', 'Беларускі (Беларусь)', 'ltr', 'BLR', 'BEL', 'by.png'),
(32, 'bn', 'Bengali', NULL, 'বাংলা', 'ltr', 'IND', 'BNG', 'empty.png'),
(33, 'bn-BD', 'Bengali', 'Bangladesh', 'বাংলা (বাংলাদেশ)', 'ltr', 'BGD', 'BNB', 'bd.png'),
(34, 'bn-IN', 'Bengali', 'India', 'বাংলা (ভারত)', 'ltr', 'IND', 'BNG', 'in.png'),
(35, 'bs', 'Bosnian', NULL, 'bosanski', 'ltr', 'BIH', 'BSB', 'empty.png'),
(36, 'bs-Cyrl', 'Bosnian', 'Cyrillic', 'босански (Ћирилица)', 'ltr', 'BIH', 'BSC', 'ba.png'),
(37, 'bs-Cyrl-BA', 'Bosnian', 'Cyrillic, Bosnia and Herzegovina', 'босански (Босна и Херцеговина)', 'ltr', 'BIH', 'BSC', 'ba.png'),
(38, 'bs-Latn', 'Bosnian', 'Latin', 'bosanski (Latinica)', 'ltr', 'BIH', 'BSB', 'ba.png'),
(39, 'bs-Latn-BA', 'Bosnian', 'Latin, Bosnia and Herzegovina', 'bosanski (Bosna i Hercegovina)', 'ltr', 'BIH', 'BSB', 'ba.png'),
(40, 'br-FR', 'Breton', 'France', 'brezhoneg (Frañs)', 'ltr', 'FRA', 'BRE', 'fr.png'),
(41, 'bg-BG', 'Bulgarian', 'Bulgaria', 'български (България)', 'ltr', 'BGR', 'BGR', 'bg.png'),
(42, 'ca-ES', 'Catalan', 'Catalan', 'català (català)', 'ltr', 'ESP', 'CAT', 'es.png'),
(43, 'zh', 'Chinese', NULL, '中文', 'ltr', 'CHN', 'CHS', 'empty.png'),
(44, 'zh-Hans', 'Chinese', 'Simplified', '中文(简体)', 'ltr', 'CHN', 'CHS', 'cn.png'),
(45, 'zh-CN', 'Chinese', 'Simplified, PRC', '中文(中华人民共和国)', 'ltr', 'CHN', 'CHS', 'cn.png'),
(46, 'zh-SG', 'Chinese', 'Simplified, Singapore', '中文(新加坡)', 'ltr', 'SGP', 'ZHI', 'sg.png'),
(47, 'zh-Hant', 'Chinese', 'Traditional', '中文(繁體)', 'ltr', 'HKG', 'ZHH', 'hk.png'),
(48, 'zh-HK', 'Chinese', 'Traditional, Hong Kong S.A.R.', '中文(香港特別行政區)', 'ltr', 'HKG', 'ZHH', 'hk.png'),
(49, 'zh-MO', 'Chinese', 'Traditional, Macao S.A.R.', '中文(澳門特別行政區)', 'ltr', 'MCO', 'ZHM', 'mc.png'),
(50, 'zh-TW', 'Chinese', 'Traditional, Taiwan', '中文(台灣)', 'ltr', 'TWN', 'CHT', 'tw.png'),
(51, 'co-FR', 'Corsican', 'France', 'Corsu (France)', 'ltr', 'FRA', 'COS', 'fr.png'),
(52, 'hr', 'Croatian', NULL, 'hrvatski', 'ltr', 'HRV', 'HRV', 'empty.png'),
(53, 'hr-HR', 'Croatian', 'Croatia', 'hrvatski (Hrvatska)', 'ltr', 'HRV', 'HRV', 'hr.png'),
(54, 'hr-BA', 'Croatian', 'Latin, Bosnia and Herzegovina', 'hrvatski (Bosna i Hercegovina)', 'ltr', 'BIH', 'HRB', 'ba.png'),
(55, 'cs-CZ', 'Czech', 'Czech Republic', 'čeština (Česká republika)', 'ltr', 'CZE', 'CSY', 'cz.png'),
(56, 'da-DK', 'Danish', 'Denmark', 'dansk (Danmark)', 'ltr', 'DNK', 'DAN', 'dk.png'),
(57, 'prs-AF', 'Dari', 'Afghanistan', 'درى (افغانستان)‏', 'ltr', 'AFG', 'PRS', 'af.png'),
(58, 'dv-MV', 'Divehi', 'Maldives', 'ދިވެހިބަސް (ދިވެހި ރާއްޖެ)‏', 'rtl', 'MDV', 'DIV', 'mv.png'),
(59, 'nl', 'Dutch', NULL, 'Nederlands', 'ltr', 'NLD', 'NLD', 'empty.png'),
(60, 'nl-BE', 'Dutch', 'Belgium', 'Nederlands (België)', 'ltr', 'BEL', 'NLB', 'be.png'),
(61, 'nl-NL', 'Dutch', 'Netherlands', 'Nederlands (Nederland)', 'ltr', 'NLD', 'NLD', 'nl.png'),
(62, 'en', 'English', NULL, 'English', 'ltr', 'USA', 'ENU', 'empty.png'),
(63, 'en-AU', 'English', 'Australia', 'English (Australia)', 'ltr', 'AUS', 'ENA', 'au.png'),
(64, 'en-BZ', 'English', 'Belize', 'English (Belize)', 'ltr', 'BLZ', 'ENL', 'bz.png'),
(65, 'en-CA', 'English', 'Canada', 'English (Canada)', 'ltr', 'CAN', 'ENC', 'ca.png'),
(66, 'en-029', 'English', 'Caribbean', 'English (Caribbean)', 'ltr', 'CAR', 'ENB', 'en.png'),
(67, 'en-IN', 'English', 'India', 'English (India)', 'ltr', 'IND', 'ENN', 'in.png'),
(68, 'en-IE', 'English', 'Ireland', 'English (Ireland)', 'ltr', 'IRL', 'ENI', 'ie.png'),
(69, 'en-JM', 'English', 'Jamaica', 'English (Jamaica)', 'ltr', 'JAM', 'ENJ', 'jm.png'),
(70, 'en-MY', 'English', 'Malaysia', 'English (Malaysia)', 'ltr', 'MYS', 'ENM', 'my.png'),
(71, 'en-NZ', 'English', 'New Zealand', 'English (New Zealand)', 'ltr', 'NZL', 'ENZ', 'nz.png'),
(72, 'en-PH', 'English', 'Republic of the Philippines', 'English (Philippines)', 'ltr', 'PHL', 'ENP', 'ph.png'),
(73, 'en-SG', 'English', 'Singapore', 'English (Singapore)', 'ltr', 'SGP', 'ENE', 'sg.png'),
(74, 'en-ZA', 'English', 'South Africa', 'English (South Africa)', 'ltr', 'ZAF', 'ENS', 'za.png'),
(75, 'en-TT', 'English', 'Trinidad and Tobago', 'English (Trinidad y Tobago)', 'ltr', 'TTO', 'ENT', 'tt.png'),
(76, 'en-GB', 'English', 'United Kingdom', 'English (United Kingdom)', 'ltr', 'GBR', 'ENG', 'gb.png'),
(77, 'en-US', 'English', 'United States', 'English (United States)', 'ltr', 'USA', 'ENU', 'us.png'),
(78, 'en-ZW', 'English', 'Zimbabwe', 'English (Zimbabwe)', 'ltr', 'ZWE', 'ENW', 'zw.png'),
(79, 'et-EE', 'Estonian', 'Estonia', 'eesti (Eesti)', 'ltr', 'EST', 'ETI', 'ee.png'),
(80, 'fo-FO', 'Faroese', 'Faroe Islands', 'føroyskt (Føroyar)', 'ltr', 'FRO', 'FOS', 'fo.png'),
(81, 'fil-PH', 'Filipino', 'Philippines', 'Filipino (Pilipinas)', 'ltr', 'PHL', 'FPO', 'ph.png'),
(82, 'fi-FI', 'Finnish', 'Finland', 'suomi (Suomi)', 'ltr', 'FIN', 'FIN', 'fi.png'),
(83, 'fr', 'French', NULL, 'français', 'ltr', 'FRA', 'FRA', 'empty.png'),
(84, 'fr-BE', 'French', 'Belgium', 'français (Belgique)', 'ltr', 'BEL', 'FRB', 'be.png'),
(85, 'fr-CA', 'French', 'Canada', 'français (Canada)', 'ltr', 'CAN', 'FRC', 'ca.png'),
(86, 'fr-FR', 'French', 'France', 'français (France)', 'ltr', 'FRA', 'FRA', 'fr.png'),
(87, 'fr-LU', 'French', 'Luxembourg', 'français (Luxembourg)', 'ltr', 'LUX', 'FRL', 'lu.png'),
(88, 'fr-MC', 'French', 'Monaco', 'français (Principauté de Monaco)', 'ltr', 'MCO', 'FRM', 'mc.png'),
(89, 'fr-CH', 'French', 'Switzerland', 'français (Suisse)', 'ltr', 'CHE', 'FRS', 'ch.png'),
(90, 'fy-NL', 'Frisian', 'Netherlands', 'Frysk (Nederlân)', 'ltr', 'NLD', 'FYN', 'nl.png'),
(91, 'gl-ES', 'Galician', 'Galician', 'galego (galego)', 'ltr', 'ESP', 'GLC', 'es.png'),
(92, 'ka-GE', 'Georgian', 'Georgia', 'ქართული (საქართველო)', 'ltr', 'GEO', 'KAT', 'ge.png'),
(93, 'de', 'German', NULL, 'Deutsch', 'ltr', 'DEU', 'DEU', 'empty.png'),
(94, 'de-AT', 'German', 'Austria', 'Deutsch (Österreich)', 'ltr', 'AUT', 'DEA', 'at.png'),
(95, 'de-DE', 'German', 'Germany', 'Deutsch (Deutschland)', 'ltr', 'DEU', 'DEU', 'de.png'),
(96, 'de-LI', 'German', 'Liechtenstein', 'Deutsch (Liechtenstein)', 'ltr', 'LIE', 'DEC', 'li.png'),
(97, 'de-LU', 'German', 'Luxembourg', 'Deutsch (Luxemburg)', 'ltr', 'LUX', 'DEL', 'lu.png'),
(98, 'de-CH', 'German', 'Switzerland', 'Deutsch (Schweiz)', 'ltr', 'CHE', 'DES', 'ch.png'),
(99, 'el-GR', 'Greek', 'Greece', 'Ελληνικά (Ελλάδα)', 'ltr', 'GRC', 'ELL', 'gr.png'),
(100, 'kl-GL', 'Greenlandic', 'Greenland', 'kalaallisut (Kalaallit Nunaat)', 'ltr', 'GRL', 'KAL', 'gl.png'),
(101, 'gu-IN', 'Gujarati', 'India', 'ગુજરાતી (ભારત)', 'ltr', 'IND', 'GUJ', 'in.png'),
(102, 'ha', 'Hausa', NULL, 'Hausa', 'ltr', 'NGA', 'HAU', 'empty.png'),
(103, 'ha-Latn', 'Hausa', 'Latin', 'Hausa (Latin)', 'ltr', 'NGA', 'HAU', 'ng.png'),
(104, 'ha-Latn-NG', 'Hausa', 'Latin, Nigeria', 'Hausa (Nigeria)', 'ltr', 'NGA', 'HAU', 'ng.png'),
(105, 'he-IL', 'Hebrew', 'Israel', 'עברית (ישראל)‏', 'rtl', 'ISR', 'HEB', 'il.png'),
(106, 'hi-IN', 'Hindi', 'India', 'हिंदी (भारत)', 'ltr', 'IND', 'HIN', 'in.png'),
(107, 'hu-HU', 'Hungarian', 'Hungary', 'magyar (Magyarország)', 'ltr', 'HUN', 'HUN', 'hu.png'),
(108, 'is-IS', 'Icelandic', 'Iceland', 'íslenska (Ísland)', 'ltr', 'ISL', 'ISL', 'is.png'),
(109, 'ig-NG', 'Igbo', 'Nigeria', 'Igbo (Nigeria)', 'ltr', 'NGA', 'IBO', 'ng.png'),
(110, 'id-ID', 'Indonesian', 'Indonesia', 'Bahasa Indonesia (Indonesia)', 'ltr', 'IDN', 'IND', 'id.png'),
(111, 'iu', 'Inuktitut', NULL, 'Inuktitut', 'ltr', 'CAN', 'IUK', 'empty.png'),
(112, 'iu-Latn', 'Inuktitut', 'Latin', 'Inuktitut (Qaliujaaqpait)', 'ltr', 'CAN', 'IUK', 'ca.png'),
(113, 'iu-Latn-CA', 'Inuktitut', 'Latin, Canada', 'Inuktitut', 'ltr', 'CAN', 'IUK', 'ca.png'),
(114, 'iu-Cans', 'Inuktitut', 'Syllabics', 'ᐃᓄᒃᑎᑐᑦ (ᖃᓂᐅᔮᖅᐸᐃᑦ)', 'ltr', 'CAN', 'IUS', 'ca.png'),
(115, 'iu-Cans-CA', 'Inuktitut', 'Syllabics, Canada', 'ᐃᓄᒃᑎᑐᑦ (ᑲᓇᑕᒥ)', 'ltr', 'CAN', 'IUS', 'ca.png'),
(116, 'ga-IE', 'Irish', 'Ireland', 'Gaeilge (Éire)', 'ltr', 'IRL', 'IRE', 'ie.png'),
(117, 'xh-ZA', 'isiXhosa', 'South Africa', 'isiXhosa (uMzantsi Afrika)', 'ltr', 'ZAF', 'XHO', 'za.png'),
(118, 'zu-ZA', 'isiZulu', 'South Africa', 'isiZulu (iNingizimu Afrika)', 'ltr', 'ZAF', 'ZUL', 'za.png'),
(119, 'it', 'Italian', NULL, 'italiano', 'ltr', 'ITA', 'ITA', 'empty.png'),
(120, 'it-IT', 'Italian', 'Italy', 'italiano (Italia)', 'ltr', 'ITA', 'ITA', 'it.png'),
(121, 'it-CH', 'Italian', 'Switzerland', 'italiano (Svizzera)', 'ltr', 'CHE', 'ITS', 'ch.png'),
(122, 'ja-JP', 'Japanese', 'Japan', '日本語 (日本)', 'ltr', 'JPN', 'JPN', 'jp.png'),
(123, 'kn-IN', 'Kannada', 'India', 'ಕನ್ನಡ (ಭಾರತ)', 'ltr', 'IND', 'KDI', 'in.png'),
(124, 'kk-KZ', 'Kazakh', 'Kazakhstan', 'Қазақ (Қазақстан)', 'rtl', 'KAZ', 'KKZ', 'kz.png'),
(125, 'km-KH', 'Khmer', 'Cambodia', 'ខ្មែរ (កម្ពុជា)', 'ltr', 'KHM', 'KHM', 'kh.png'),
(126, 'qut-GT', 'K''iche', 'Guatemala', 'K''iche (Guatemala)', 'ltr', 'GTM', 'QUT', 'gt.png'),
(127, 'rw-RW', 'Kinyarwanda', 'Rwanda', 'Kinyarwanda (Rwanda)', 'ltr', 'RWA', 'KIN', 'rw.png'),
(128, 'sw-KE', 'Kiswahili', 'Kenya', 'Kiswahili (Kenya)', 'ltr', 'KEN', 'SWK', 'ke.png'),
(129, 'kok-IN', 'Konkani', 'India', 'कोंकणी (भारत)', 'ltr', 'IND', 'KNK', 'in.png'),
(130, 'ko-KR', 'Korean', 'Korea', '한국어 (대한민국)', 'ltr', 'KOR', 'KOR', 'kr.png'),
(131, 'ky-KG', 'Kyrgyz', 'Kyrgyzstan', 'Кыргыз (Кыргызстан)', 'ltr', 'KGZ', 'KYR', 'kg.png'),
(132, 'lo-LA', 'Lao', 'Lao P.D.R.', 'ລາວ (ສ.ປ.ປ. ລາວ)', 'ltr', 'LAO', 'LAO', 'la.png'),
(133, 'lv-LV', 'Latvian', 'Latvia', 'latviešu (Latvija)', 'ltr', 'LVA', 'LVI', 'lv.png'),
(134, 'lt-LT', 'Lithuanian', 'Lithuania', 'lietuvių (Lietuva)', 'ltr', 'LTU', 'LTH', 'lt.png'),
(135, 'dsb-DE', 'Lower Sorbian', 'Germany', 'dolnoserbšćina (Nimska)', 'ltr', 'GER', 'DSB', 'de.png'),
(136, 'lb-LU', 'Luxembourgish', 'Luxembourg', 'Lëtzebuergesch (Luxembourg)', 'ltr', 'LUX', 'LBX', 'lu.png'),
(137, 'mk-MK', 'Macedonian', 'Former Yugoslav Republic of Macedonia', 'македонски јазик (Македонија)', 'ltr', 'MKD', 'MKI', 'mk.png'),
(138, 'mk', 'Macedonian', 'FYROM', 'македонски јазик', 'ltr', 'MKD', 'MKI', 'mk.png'),
(139, 'ms', 'Malay', NULL, 'Bahasa Melayu', 'ltr', 'MYS', 'MSL', 'empty.png'),
(140, 'ms-BN', 'Malay', 'Brunei Darussalam', 'Bahasa Melayu (Brunei Darussalam)', 'ltr', 'BRN', 'MSB', 'bn.png'),
(141, 'ms-MY', 'Malay', 'Malaysia', 'Bahasa Melayu (Malaysia)', 'ltr', 'MYS', 'MSL', 'my.png'),
(142, 'ml-IN', 'Malayalam', 'India', 'മലയാളം (ഭാരതം)', 'rtl', 'IND', 'MYM', 'in.png'),
(143, 'mt-MT', 'Maltese', 'Malta', 'Malti (Malta)', 'ltr', 'MLT', 'MLT', 'mt.png'),
(144, 'mi-NZ', 'Maori', 'New Zealand', 'Reo Māori (Aotearoa)', 'ltr', 'NZL', 'MRI', 'nz.png'),
(145, 'arn-CL', 'Mapudungun', 'Chile', 'Mapudungun (Chile)', 'ltr', 'CHL', 'MPD', 'cl.png'),
(146, 'mr-IN', 'Marathi', 'India', 'मराठी (भारत)', 'ltr', 'IND', 'MAR', 'in.png'),
(147, 'moh-CA', 'Mohawk', 'Mohawk', 'Kanien''kéha', 'ltr', 'CAN', 'MWK', 'ca.png'),
(148, 'mn', 'Mongolian', 'Cyrillic', 'Монгол хэл', 'ltr', 'MNG', 'MNN', 'mn.png'),
(149, 'mn-Cyrl', 'Mongolian', 'Cyrillic', 'Монгол хэл', 'ltr', 'MNG', 'MNN', 'mn.png'),
(150, 'mn-MN', 'Mongolian', 'Cyrillic, Mongolia', 'Монгол хэл (Монгол улс)', 'ltr', 'MNG', 'MNN', 'mn.png'),
(151, 'mn-Mong', 'Mongolian', 'Traditional Mongolian', 'ᠮᠤᠨᠭᠭᠤᠯ ᠬᠡᠯᠡ', 'ltr', 'CHN', 'MNG', 'cn.png'),
(152, 'mn-Mong-CN', 'Mongolian', 'Traditional Mongolian, PRC', 'ᠮᠤᠨᠭᠭᠤᠯ ᠬᠡᠯᠡ (ᠪᠦᠭᠦᠳᠡ ᠨᠠᠢᠷᠠᠮᠳᠠᠬᠤ ᠳᠤᠮᠳᠠᠳᠤ ᠠᠷᠠᠳ ᠣᠯᠣᠰ)', 'ltr', 'CHN', 'MNG', 'cn.png'),
(153, 'ne-NP', 'Nepali', 'Nepal', 'नेपाली (नेपाल)', 'ltr', 'NEP', 'NEP', 'np.png'),
(154, 'no', 'Norwegian', NULL, 'norsk', 'ltr', 'NOR', 'NOR', 'empty.png'),
(155, 'nb', 'Norwegian', 'Bokmål', 'norsk (bokmål)', 'ltr', 'NOR', 'NOR', 'no.png'),
(156, 'nn', 'Norwegian', 'Nynorsk', 'norsk (nynorsk)', 'ltr', 'NOR', 'NON', 'no.png'),
(157, 'nb-NO', 'Norwegian, Bokmål', 'Norway', 'norsk, bokmål (Norge)', 'ltr', 'NOR', 'NOR', 'no.png'),
(158, 'nn-NO', 'Norwegian, Nynorsk', 'Norway', 'norsk, nynorsk (Noreg)', 'ltr', 'NOR', 'NON', 'no.png'),
(159, 'oc-FR', 'Occitan', 'France', 'Occitan (França)', 'ltr', 'FRA', 'OCI', 'fr.png'),
(160, 'or-IN', 'Oriya', 'India', 'ଓଡ଼ିଆ (ଭାରତ)', 'ltr', 'IND', 'ORI', 'in.png'),
(161, 'ps-AF', 'Pashto', 'Afghanistan', 'پښتو (افغانستان)‏', 'rtl', 'AFG', 'PAS', 'af.png'),
(162, 'fa-IR', 'Persian‎', NULL, 'فارسى (ایران)‏', 'rtl', 'IRN', 'FAR', 'empty.png'),
(163, 'pl-PL', 'Polish', 'Poland', 'polski (Polska)', 'ltr', 'POL', 'PLK', 'pl.png'),
(164, 'pt', 'Portuguese', NULL, 'Português', 'ltr', 'BRA', 'PTB', 'empty.png'),
(165, 'pt-BR', 'Portuguese', 'Brazil', 'Português (Brasil)', 'ltr', 'BRA', 'PTB', 'br.png'),
(166, 'pt-PT', 'Portuguese', 'Portugal', 'português (Portugal)', 'ltr', 'PRT', 'PTG', 'pt.png'),
(167, 'pa-IN', 'Punjabi', 'India', 'ਪੰਜਾਬੀ (ਭਾਰਤ)', 'rtl', 'IND', 'PAN', 'in.png'),
(168, 'quz', 'Quechua', NULL, 'runasimi', 'ltr', 'BOL', 'QUB', 'empty.png'),
(169, 'quz-BO', 'Quechua', 'Bolivia', 'runasimi (Qullasuyu)', 'ltr', 'BOL', 'QUB', 'bo.png'),
(170, 'quz-EC', 'Quechua', 'Ecuador', 'runasimi (Ecuador)', 'ltr', 'ECU', 'QUE', 'ec.png'),
(171, 'quz-PE', 'Quechua', 'Peru', 'runasimi (Piruw)', 'ltr', 'PER', 'QUP', 'pe.png'),
(172, 'ro-RO', 'Romanian', 'Romania', 'română (România)', 'ltr', 'ROM', 'ROM', 'ro.png'),
(173, 'rm-CH', 'Romansh', 'Switzerland', 'Rumantsch (Svizra)', 'ltr', 'CHE', 'RMC', 'ch.png'),
(174, 'ru-RU', 'Russian', 'Russia', 'русский (Россия)', 'ltr', 'RUS', 'RUS', 'ru.png'),
(175, 'smn', 'Sami', 'Inari', 'sämikielâ', 'ltr', 'FIN', 'SMN', 'fi.png'),
(176, 'smj', 'Sami', 'Lule', 'julevusámegiella', 'ltr', 'SWE', 'SMK', 'se.png'),
(177, 'se', 'Sami', 'Northern', 'davvisámegiella', 'ltr', 'NOR', 'SME', 'no.png'),
(178, 'sms', 'Sami', 'Skolt', 'sääm´ǩiõll', 'ltr', 'FIN', 'SMS', 'fi.png'),
(179, 'sma', 'Sami', 'Southern', 'åarjelsaemiengiele', 'ltr', 'SWE', 'SMB', 'se.png'),
(180, 'smn-FI', 'Sami, Inari', 'Finland', 'sämikielâ (Suomâ)', 'ltr', 'FIN', 'SMN', 'fi.png'),
(181, 'smj-NO', 'Sami, Lule', 'Norway', 'julevusámegiella (Vuodna)', 'ltr', 'NOR', 'SMJ', 'no.png'),
(182, 'smj-SE', 'Sami, Lule', 'Sweden', 'julevusámegiella (Svierik)', 'ltr', 'SWE', 'SMK', 'se.png'),
(183, 'se-FI', 'Sami, Northern', 'Finland', 'davvisámegiella (Suopma)', 'ltr', 'FIN', 'SMG', 'fi.png'),
(184, 'se-NO', 'Sami, Northern', 'Norway', 'davvisámegiella (Norga)', 'ltr', 'NOR', 'SME', 'no.png'),
(185, 'se-SE', 'Sami, Northern', 'Sweden', 'davvisámegiella (Ruoŧŧa)', 'ltr', 'SWE', 'SMF', 'se.png'),
(186, 'sms-FI', 'Sami, Skolt', 'Finland', 'sääm´ǩiõll (Lää´ddjânnam)', 'ltr', 'FIN', 'SMS', 'fi.png'),
(187, 'sma-NO', 'Sami, Southern', 'Norway', 'åarjelsaemiengiele (Nöörje)', 'ltr', 'NOR', 'SMA', 'no.png'),
(188, 'sma-SE', 'Sami, Southern', 'Sweden', 'åarjelsaemiengiele (Sveerje)', 'ltr', 'SWE', 'SMB', 'se.png'),
(189, 'sa-IN', 'Sanskrit', 'India', 'संस्कृत (भारतम्)', 'ltr', 'IND', 'SAN', 'in.png'),
(190, 'gd-GB', 'Scottish Gaelic', 'United Kingdom', 'Gàidhlig (An Rìoghachd Aonaichte)', 'ltr', 'GBR', 'GLA', 'gb.png'),
(191, 'sr', 'Serbian', NULL, 'srpski', 'ltr', 'SRB', 'SRM', 'empty.png'),
(192, 'sr-Cyrl', 'Serbian', 'Cyrillic', 'српски (Ћирилица)', 'ltr', 'SRB', 'SRO', 'rs.png'),
(193, 'sr-Cyrl-BA', 'Serbian', 'Cyrillic, Bosnia and Herzegovina', 'српски (Босна и Херцеговина)', 'ltr', 'BIH', 'SRN', 'ba.png'),
(194, 'sr-Cyrl-ME', 'Serbian', 'Cyrillic, Montenegro', 'српски (Црна Гора)', 'ltr', 'MNE', 'SRQ', 'me.png'),
(195, 'sr-Cyrl-CS', 'Serbian', 'Cyrillic, Serbia and Montenegro (Former)', 'српски (Србија и Црна Гора (Претходно))', 'ltr', 'SCG', 'SRB', 'rs.png'),
(196, 'sr-Cyrl-RS', 'Serbian', 'Cyrillic, Serbia', 'српски (Србија)', 'ltr', 'SRB', 'SRO', 'rs.png'),
(197, 'sr-Latn', 'Serbian', 'Latin', 'srpski (Latinica)', 'ltr', 'SRB', 'SRM', 'rs.png'),
(198, 'sr-Latn-BA', 'Serbian', 'Latin, Bosnia and Herzegovina', 'srpski (Bosna i Hercegovina)', 'ltr', 'BIH', 'SRS', 'ba.png'),
(199, 'sr-Latn-ME', 'Serbian', 'Latin, Montenegro', 'srpski (Crna Gora)', 'ltr', 'MNE', 'SRP', 'me.png'),
(200, 'sr-Latn-CS', 'Serbian', 'Latin, Serbia and Montenegro (Former)', 'srpski (Srbija i Crna Gora (Prethodno))', 'ltr', 'SCG', 'SRL', 'rs.png'),
(201, 'sr-Latn-RS', 'Serbian', 'Latin, Serbia', 'srpski (Srbija)', 'ltr', 'SRB', 'SRM', 'rs.png'),
(202, 'nso-ZA', 'Sesotho sa Leboa', 'South Africa', 'Sesotho sa Leboa (Afrika Borwa)', 'ltr', 'ZAF', 'NSO', 'za.png'),
(203, 'tn-ZA', 'Setswana', 'South Africa', 'Setswana (Aforika Borwa)', 'ltr', 'ZAF', 'TSN', 'za.png'),
(204, 'si-LK', 'Sinhala', 'Sri Lanka', 'සිංහ (ශ්‍රී ලංකා)', 'ltr', 'LKA', 'SIN', 'lk.png'),
(205, 'sk-SK', 'Slovak', 'Slovakia', 'slovenčina (Slovenská republika)', 'ltr', 'SVK', 'SKY', 'sk.png'),
(206, 'sl-SI', 'Slovenian', 'Slovenia', 'slovenski (Slovenija)', 'ltr', 'SVN', 'SLV', 'si.png'),
(207, 'es', 'Spanish', NULL, 'español', 'ltr', 'ESP', 'ESN', 'empty.png'),
(208, 'es-AR', 'Spanish', 'Argentina', 'Español (Argentina)', 'ltr', 'ARG', 'ESS', 'ar.png'),
(209, 'es-BO', 'Spanish', 'Bolivia', 'Español (Bolivia)', 'ltr', 'BOL', 'ESB', 'bo.png'),
(210, 'es-CL', 'Spanish', 'Chile', 'Español (Chile)', 'ltr', 'CHL', 'ESL', 'cl.png'),
(211, 'es-CO', 'Spanish', 'Colombia', 'Español (Colombia)', 'ltr', 'COL', 'ESO', 'co.png'),
(212, 'es-CR', 'Spanish', 'Costa Rica', 'Español (Costa Rica)', 'ltr', 'CRI', 'ESC', 'cr.png'),
(213, 'es-DO', 'Spanish', 'Dominican Republic', 'Español (República Dominicana)', 'ltr', 'DOM', 'ESD', 'do.png'),
(214, 'es-EC', 'Spanish', 'Ecuador', 'Español (Ecuador)', 'ltr', 'ECU', 'ESF', 'ec.png'),
(215, 'es-SV', 'Spanish', 'El Salvador', 'Español (El Salvador)', 'ltr', 'SLV', 'ESE', 'sv.png'),
(216, 'es-GT', 'Spanish', 'Guatemala', 'Español (Guatemala)', 'ltr', 'GTM', 'ESG', 'gt.png'),
(217, 'es-HN', 'Spanish', 'Honduras', 'Español (Honduras)', 'ltr', 'HND', 'ESH', 'hn.png'),
(218, 'es-MX', 'Spanish', 'Mexico', 'Español (México)', 'ltr', 'MEX', 'ESM', 'mx.png'),
(219, 'es-NI', 'Spanish', 'Nicaragua', 'Español (Nicaragua)', 'ltr', 'NIC', 'ESI', 'ni.png'),
(220, 'es-PA', 'Spanish', 'Panama', 'Español (Panamá)', 'ltr', 'PAN', 'ESA', 'pa.png'),
(221, 'es-PY', 'Spanish', 'Paraguay', 'Español (Paraguay)', 'ltr', 'PRY', 'ESZ', 'py.png'),
(222, 'es-PE', 'Spanish', 'Peru', 'Español (Perú)', 'ltr', 'PER', 'ESR', 'pe.png'),
(223, 'es-PR', 'Spanish', 'Puerto Rico', 'Español (Puerto Rico)', 'ltr', 'PRI', 'ESU', 'pr.png'),
(224, 'es-ES', 'Spanish', 'Spain, International Sort', 'Español (España, alfabetización internacional)', 'ltr', 'ESP', 'ESN', 'es.png'),
(225, 'es-US', 'Spanish', 'United States', 'Español (Estados Unidos)', 'ltr', 'USA', 'EST', 'us.png'),
(226, 'es-UY', 'Spanish', 'Uruguay', 'Español (Uruguay)', 'ltr', 'URY', 'ESY', 'uy.png'),
(227, 'es-VE', 'Spanish', 'Venezuela', 'Español (Republica Bolivariana de Venezuela)', 'ltr', 'VEN', 'ESV', 've.png'),
(228, 'sv', 'Swedish', NULL, 'svenska', 'ltr', 'SWE', 'SVE', 'empty.png'),
(229, 'sv-FI', 'Swedish', 'Finland', 'svenska (Finland)', 'ltr', 'FIN', 'SVF', 'fi.png'),
(230, 'sv-SE', 'Swedish', 'Sweden', 'svenska (Sverige)', 'ltr', 'SWE', 'SVE', 'se.png'),
(231, 'syr-SY', 'Syriac', 'Syria', 'ܣܘܪܝܝܐ (سوريا)‏', 'rtl', 'SYR', 'SYR', 'sy.png'),
(232, 'tg', 'Tajik', 'Cyrillic', 'Тоҷикӣ', 'ltr', 'TAJ', 'TAJ', 'tj.png'),
(233, 'tg-Cyrl', 'Tajik', 'Cyrillic', 'Тоҷикӣ', 'ltr', 'TAJ', 'TAJ', 'tj.png'),
(234, 'tg-Cyrl-TJ', 'Tajik', 'Cyrillic, Tajikistan', 'Тоҷикӣ (Тоҷикистон)', 'ltr', 'TAJ', 'TAJ', 'tj.png'),
(235, 'tzm', 'Tamazight', NULL, 'Tamazight', 'ltr', 'DZA', 'TZM', 'empty.png'),
(236, 'tzm-Latn', 'Tamazight', 'Latin', 'Tamazight (Latin)', 'ltr', 'DZA', 'TZM', 'dz.png'),
(237, 'tzm-Latn-DZ', 'Tamazight', 'Latin, Algeria', 'Tamazight (Djazaïr)', 'ltr', 'DZA', 'TZM', 'dz.png'),
(238, 'ta-IN', 'Tamil', 'India', 'தமிழ் (இந்தியா)', 'ltr', 'IND', 'TAM', 'in.png'),
(239, 'tt-RU', 'Tatar', 'Russia', 'Татар (Россия)', 'ltr', 'RUS', 'TTT', 'ru.png'),
(240, 'te-IN', 'Telugu', 'India', 'తెలుగు (భారత దేశం)', 'ltr', 'IND', 'TEL', 'in.png'),
(241, 'th-TH', 'Thai', 'Thailand', 'ไทย (ไทย)', 'ltr', 'THA', 'THA', 'th.png'),
(242, 'bo-CN', 'Tibetan', 'PRC', 'བོད་ཡིག (ཀྲུང་ཧྭ་མི་དམངས་སྤྱི་མཐུན་རྒྱལ་ཁབ།)', 'ltr', 'CHN', 'BOB', 'cn.png'),
(243, 'tr-TR', 'Turkish', 'Turkey', 'Türkçe (Türkiye)', 'ltr', 'TUR', 'TRK', 'tr.png'),
(244, 'tk-TM', 'Turkmen', 'Turkmenistan', 'türkmençe (Türkmenistan)', 'rtl', 'TKM', 'TUK', 'tm.png'),
(245, 'uk-UA', 'Ukrainian', 'Ukraine', 'українська (Україна)', 'ltr', 'UKR', 'UKR', 'ua.png'),
(246, 'hsb-DE', 'Upper Sorbian', 'Germany', 'hornjoserbšćina (Němska)', 'ltr', 'GER', 'HSB', 'de.png'),
(247, 'ur-PK', 'Urdu', 'Islamic Republic of Pakistan', 'اُردو (پاکستان)‏', 'rtl', 'PAK', 'URD', 'pk.png'),
(248, 'ug-CN', 'Uyghur', 'PRC', '(ئۇيغۇر يېزىقى (جۇڭخۇا خەلق جۇمھۇرىيىتى‏', 'rtl', 'CHN', 'UIG', 'cn.png'),
(249, 'uz-Cyrl', 'Uzbek', 'Cyrillic', 'Ўзбек', 'ltr', 'UZB', 'UZB', 'uz.png'),
(250, 'uz-Cyrl-UZ', 'Uzbek', 'Cyrillic, Uzbekistan', 'Ўзбек (Ўзбекистон)', 'ltr', 'UZB', 'UZB', 'uz.png'),
(251, 'uz', 'Uzbek', 'Latin', 'U''zbek', 'ltr', 'UZB', 'UZB', 'uz.png'),
(252, 'uz-Latn', 'Uzbek', 'Latin', 'U''zbek', 'ltr', 'UZB', 'UZB', 'uz.png'),
(253, 'uz-Latn-UZ', 'Uzbek', 'Latin, Uzbekistan', 'U''zbek (U''zbekiston Respublikasi)', 'ltr', 'UZB', 'UZB', 'uz.png'),
(254, 'vi-VN', 'Vietnamese', 'Vietnam', 'Tiếng Việt (Việt Nam)', 'ltr', 'VNM', 'VIT', 'vn.png'),
(255, 'cy-GB', 'Welsh', 'United Kingdom', 'Cymraeg (y Deyrnas Unedig)', 'ltr', 'GBR', 'CYM', 'gb.png'),
(256, 'wo-SN', 'Wolof', 'Senegal', 'Wolof (Sénégal)', 'ltr', 'SEN', 'WOL', 'sn.png'),
(257, 'sah-RU', 'Yakut', 'Russia', 'саха (Россия)', 'ltr', 'RUS', 'SAH', 'ru.png'),
(258, 'ii-CN', 'Yi', 'PRC', 'ꆈꌠꁱꂷ (ꍏꉸꏓꂱꇭꉼꇩ)', 'ltr', 'CHN', 'III', 'cn.png'),
(259, 'yo-NG', 'Yoruba', 'Nigeria', 'Yoruba (Nigeria)', 'ltr', 'NGA', 'YOR', 'ng.png');

INSERT IGNORE INTO `plugin_base_countries` (`id`, `alpha_2`, `alpha_3`, `status`) VALUES
(1, 'AF', 'AFG', 'T'),
(2, 'AX', 'ALA', 'T'),
(3, 'AL', 'ALB', 'T'),
(4, 'DZ', 'DZA', 'T'),
(5, 'AS', 'ASM', 'T'),
(6, 'AD', 'AND', 'T'),
(7, 'AO', 'AGO', 'T'),
(8, 'AI', 'AIA', 'T'),
(9, 'AQ', 'ATA', 'T'),
(10, 'AG', 'ATG', 'T'),
(11, 'AR', 'ARG', 'T'),
(12, 'AM', 'ARM', 'T'),
(13, 'AW', 'ABW', 'T'),
(14, 'AU', 'AUS', 'T'),
(15, 'AT', 'AUT', 'T'),
(16, 'AZ', 'AZE', 'T'),
(17, 'BS', 'BHS', 'T'),
(18, 'BH', 'BHR', 'T'),
(19, 'BD', 'BGD', 'T'),
(20, 'BB', 'BRB', 'T'),
(21, 'BY', 'BLR', 'T'),
(22, 'BE', 'BEL', 'T'),
(23, 'BZ', 'BLZ', 'T'),
(24, 'BJ', 'BEN', 'T'),
(25, 'BM', 'BMU', 'T'),
(26, 'BT', 'BTN', 'T'),
(27, 'BO', 'BOL', 'T'),
(28, 'BQ', 'BES', 'T'),
(29, 'BA', 'BIH', 'T'),
(30, 'BW', 'BWA', 'T'),
(31, 'BV', 'BVT', 'T'),
(32, 'BR', 'BRA', 'T'),
(33, 'IO', 'IOT', 'T'),
(34, 'BN', 'BRN', 'T'),
(35, 'BG', 'BGR', 'T'),
(36, 'BF', 'BFA', 'T'),
(37, 'BI', 'BDI', 'T'),
(38, 'KH', 'KHM', 'T'),
(39, 'CM', 'CMR', 'T'),
(40, 'CA', 'CAN', 'T'),
(41, 'CV', 'CPV', 'T'),
(42, 'KY', 'CYM', 'T'),
(43, 'CF', 'CAF', 'T'),
(44, 'TD', 'TCD', 'T'),
(45, 'CL', 'CHL', 'T'),
(46, 'CN', 'CHN', 'T'),
(47, 'CX', 'CXR', 'T'),
(48, 'CC', 'CCK', 'T'),
(49, 'CO', 'COL', 'T'),
(50, 'KM', 'COM', 'T'),
(51, 'CG', 'COG', 'T'),
(52, 'CD', 'COD', 'T'),
(53, 'CK', 'COK', 'T'),
(54, 'CR', 'CRI', 'T'),
(55, 'CI', 'CIV', 'T'),
(56, 'HR', 'HRV', 'T'),
(57, 'CU', 'CUB', 'T'),
(58, 'CW', 'CUW', 'T'),
(59, 'CY', 'CYP', 'T'),
(60, 'CZ', 'CZE', 'T'),
(61, 'DK', 'DNK', 'T'),
(62, 'DJ', 'DJI', 'T'),
(63, 'DM', 'DMA', 'T'),
(64, 'DO', 'DOM', 'T'),
(65, 'EC', 'ECU', 'T'),
(66, 'EG', 'EGY', 'T'),
(67, 'SV', 'SLV', 'T'),
(68, 'GQ', 'GNQ', 'T'),
(69, 'ER', 'ERI', 'T'),
(70, 'EE', 'EST', 'T'),
(71, 'ET', 'ETH', 'T'),
(72, 'FK', 'FLK', 'T'),
(73, 'FO', 'FRO', 'T'),
(74, 'FJ', 'FJI', 'T'),
(75, 'FI', 'FIN', 'T'),
(76, 'FR', 'FRA', 'T'),
(77, 'GF', 'GUF', 'T'),
(78, 'PF', 'PYF', 'T'),
(79, 'TF', 'ATF', 'T'),
(80, 'GA', 'GAB', 'T'),
(81, 'GM', 'GMB', 'T'),
(82, 'GE', 'GEO', 'T'),
(83, 'DE', 'DEU', 'T'),
(84, 'GH', 'GHA', 'T'),
(85, 'GI', 'GIB', 'T'),
(86, 'GR', 'GRC', 'T'),
(87, 'GL', 'GRL', 'T'),
(88, 'GD', 'GRD', 'T'),
(89, 'GP', 'GLP', 'T'),
(90, 'GU', 'GUM', 'T'),
(91, 'GT', 'GTM', 'T'),
(92, 'GG', 'GGY', 'T'),
(93, 'GN', 'GIN', 'T'),
(94, 'GW', 'GNB', 'T'),
(95, 'GY', 'GUY', 'T'),
(96, 'HT', 'HTI', 'T'),
(97, 'HM', 'HMD', 'T'),
(98, 'VA', 'VAT', 'T'),
(99, 'HN', 'HND', 'T'),
(100, 'HK', 'HKG', 'T'),
(101, 'HU', 'HUN', 'T'),
(102, 'IS', 'ISL', 'T'),
(103, 'IN', 'IND', 'T'),
(104, 'ID', 'IDN', 'T'),
(105, 'IR', 'IRN', 'T'),
(106, 'IQ', 'IRQ', 'T'),
(107, 'IE', 'IRL', 'T'),
(108, 'IM', 'IMN', 'T'),
(109, 'IL', 'ISR', 'T'),
(110, 'IT', 'ITA', 'T'),
(111, 'JM', 'JAM', 'T'),
(112, 'JP', 'JPN', 'T'),
(113, 'JE', 'JEY', 'T'),
(114, 'JO', 'JOR', 'T'),
(115, 'KZ', 'KAZ', 'T'),
(116, 'KE', 'KEN', 'T'),
(117, 'KI', 'KIR', 'T'),
(118, 'KP', 'PRK', 'T'),
(119, 'KR', 'KOR', 'T'),
(120, 'KW', 'KWT', 'T'),
(121, 'KG', 'KGZ', 'T'),
(122, 'LA', 'LAO', 'T'),
(123, 'LV', 'LVA', 'T'),
(124, 'LB', 'LBN', 'T'),
(125, 'LS', 'LSO', 'T'),
(126, 'LR', 'LBR', 'T'),
(127, 'LY', 'LBY', 'T'),
(128, 'LI', 'LIE', 'T'),
(129, 'LT', 'LTU', 'T'),
(130, 'LU', 'LUX', 'T'),
(131, 'MO', 'MAC', 'T'),
(132, 'MK', 'MKD', 'T'),
(133, 'MG', 'MDG', 'T'),
(134, 'MW', 'MWI', 'T'),
(135, 'MY', 'MYS', 'T'),
(136, 'MV', 'MDV', 'T'),
(137, 'ML', 'MLI', 'T'),
(138, 'MT', 'MLT', 'T'),
(139, 'MH', 'MHL', 'T'),
(140, 'MQ', 'MTQ', 'T'),
(141, 'MR', 'MRT', 'T'),
(142, 'MU', 'MUS', 'T'),
(143, 'YT', 'MYT', 'T'),
(144, 'MX', 'MEX', 'T'),
(145, 'FM', 'FSM', 'T'),
(146, 'MD', 'MDA', 'T'),
(147, 'MC', 'MCO', 'T'),
(148, 'MN', 'MNG', 'T'),
(149, 'ME', 'MNE', 'T'),
(150, 'MS', 'MSR', 'T'),
(151, 'MA', 'MAR', 'T'),
(152, 'MZ', 'MOZ', 'T'),
(153, 'MM', 'MMR', 'T'),
(154, 'NA', 'NAM', 'T'),
(155, 'NR', 'NRU', 'T'),
(156, 'NP', 'NPL', 'T'),
(157, 'NL', 'NLD', 'T'),
(158, 'NC', 'NCL', 'T'),
(159, 'NZ', 'NZL', 'T'),
(160, 'NI', 'NIC', 'T'),
(161, 'NE', 'NER', 'T'),
(162, 'NG', 'NGA', 'T'),
(163, 'NU', 'NIU', 'T'),
(164, 'NF', 'NFK', 'T'),
(165, 'MP', 'MNP', 'T'),
(166, 'NO', 'NOR', 'T'),
(167, 'OM', 'OMN', 'T'),
(168, 'PK', 'PAK', 'T'),
(169, 'PW', 'PLW', 'T'),
(170, 'PS', 'PSE', 'T'),
(171, 'PA', 'PAN', 'T'),
(172, 'PG', 'PNG', 'T'),
(173, 'PY', 'PRY', 'T'),
(174, 'PE', 'PER', 'T'),
(175, 'PH', 'PHL', 'T'),
(176, 'PN', 'PCN', 'T'),
(177, 'PL', 'POL', 'T'),
(178, 'PT', 'PRT', 'T'),
(179, 'PR', 'PRI', 'T'),
(180, 'QA', 'QAT', 'T'),
(181, 'RE', 'REU', 'T'),
(182, 'RO', 'ROU', 'T'),
(183, 'RU', 'RUS', 'T'),
(184, 'RW', 'RWA', 'T'),
(185, 'BL', 'BLM', 'T'),
(186, 'SH', 'SHN', 'T'),
(187, 'KN', 'KNA', 'T'),
(188, 'LC', 'LCA', 'T'),
(189, 'MF', 'MAF', 'T'),
(190, 'PM', 'SPM', 'T'),
(191, 'VC', 'VCT', 'T'),
(192, 'WS', 'WSM', 'T'),
(193, 'SM', 'SMR', 'T'),
(194, 'ST', 'STP', 'T'),
(195, 'SA', 'SAU', 'T'),
(196, 'SN', 'SEN', 'T'),
(197, 'RS', 'SRB', 'T'),
(198, 'SC', 'SYC', 'T'),
(199, 'SL', 'SLE', 'T'),
(200, 'SG', 'SGP', 'T'),
(201, 'SX', 'SXM', 'T'),
(202, 'SK', 'SVK', 'T'),
(203, 'SI', 'SVN', 'T'),
(204, 'SB', 'SLB', 'T'),
(205, 'SO', 'SOM', 'T'),
(206, 'ZA', 'ZAF', 'T'),
(207, 'GS', 'SGS', 'T'),
(208, 'SS', 'SSD', 'T'),
(209, 'ES', 'ESP', 'T'),
(210, 'LK', 'LKA', 'T'),
(211, 'SD', 'SDN', 'T'),
(212, 'SR', 'SUR', 'T'),
(213, 'SJ', 'SJM', 'T'),
(214, 'SZ', 'SWZ', 'T'),
(215, 'SE', 'SWE', 'T'),
(216, 'CH', 'CHE', 'T'),
(217, 'SY', 'SYR', 'T'),
(218, 'TW', 'TWN', 'T'),
(219, 'TJ', 'TJK', 'T'),
(220, 'TZ', 'TZA', 'T'),
(221, 'TH', 'THA', 'T'),
(222, 'TL', 'TLS', 'T'),
(223, 'TG', 'TGO', 'T'),
(224, 'TK', 'TKL', 'T'),
(225, 'TO', 'TON', 'T'),
(226, 'TT', 'TTO', 'T'),
(227, 'TN', 'TUN', 'T'),
(228, 'TR', 'TUR', 'T'),
(229, 'TM', 'TKM', 'T'),
(230, 'TC', 'TCA', 'T'),
(231, 'TV', 'TUV', 'T'),
(232, 'UG', 'UGA', 'T'),
(233, 'UA', 'UKR', 'T'),
(234, 'AE', 'ARE', 'T'),
(235, 'GB', 'GBR', 'T'),
(236, 'US', 'USA', 'T'),
(237, 'UM', 'UMI', 'T'),
(238, 'UY', 'URY', 'T'),
(239, 'UZ', 'UZB', 'T'),
(240, 'VU', 'VUT', 'T'),
(241, 'VE', 'VEN', 'T'),
(242, 'VN', 'VNM', 'T'),
(243, 'VG', 'VGB', 'T'),
(244, 'VI', 'VIR', 'T'),
(245, 'WF', 'WLF', 'T'),
(246, 'EH', 'ESH', 'T'),
(247, 'YE', 'YEM', 'T'),
(248, 'ZM', 'ZMB', 'T'),
(249, 'ZW', 'ZWE', 'T');

INSERT INTO `plugin_base_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_auto_backup', 9, 'Yes|No::Yes', 'Yes|No', 'enum', 1, 0, NULL),
(1, 'o_base_theme', 2, 'theme1|theme2|theme3::theme1', 'Theme 1|Theme 2|Theme 3', 'enum', 1, 1, NULL),
(1, 'o_captcha_background', 8, 'plain', NULL, 'string', 3, 1, NULL),
(1, 'o_captcha_background_front', 8, 'plain', NULL, 'string', 3, 1, NULL),
(1, 'o_captcha_length', 8, '6', NULL, 'int', 5, 1, NULL),
(1, 'o_captcha_length_front', 8, '6', NULL, 'int', 5, 1, NULL),
(1, 'o_captcha_location', 8, 'admin|front::admin', 'Administrator page|Front-end', 'enum', 1, 1, NULL),
(1, 'o_captcha_mode', 8, 'string|addition|subtraction|random_math::random_math', NULL, 'enum', 4, 1, NULL),
(1, 'o_captcha_mode_front', 8, 'string|addition|subtraction|random_math::addition', NULL, 'enum', 4, 1, NULL),
(1, 'o_captcha_secret_key', 8, NULL, NULL, 'string', 7, 1, NULL),
(1, 'o_captcha_secret_key_front', 8, NULL, NULL, 'string', 7, 1, NULL),
(1, 'o_captcha_site_key', 8, NULL, NULL, 'string', 6, 1, NULL),
(1, 'o_captcha_site_key_front', 8, NULL, NULL, 'string', 6, 1, NULL),
(1, 'o_captcha_type', 8, 'system|google::system', 'System|Google', 'enum', 2, 1, NULL),
(1, 'o_captcha_type_front', 8, 'system|google::system', 'System|Google', 'enum', 2, 1, NULL),
(1, 'o_cron_start_time', 99, '00:00:00', NULL, 'string', NULL, 0, NULL),
(1, 'o_currency', 1, 'AED|AFN|ALL|AMD|ANG|AOA|ARS|AUD|AWG|AZN|BAM|BBD|BDT|BGN|BHD|BIF|BMD|BND|BOB|BOV|BRL|BSD|BTN|BWP|BYR|BZD|CAD|CDF|CHE|CHF|CHW|CLF|CLP|CNY|COP|COU|CRC|CUC|CUP|CVE|CZK|DJF|DKK|DOP|DZD|EEK|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHS|GIP|GMD|GNF|GTQ|GYD|HKD|HNL|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LTL|LVL|LYD|MAD|MDL|MGA|MKD|MMK|MNT|MOP|MRO|MUR|MVR|MWK|MXN|MXV|MYR|MZN|NAD|NGN|NIO|NOK|NPR|NZD|OMR|PAB|PEN|PGK|PHP|PKR|PLN|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SLL|SOS|SRD|STD|SYP|SZL|THB|TJS|TMT|TND|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|USN|USS|UYU|UZS|VEF|VND|VUV|WST|XAF|XAG|XAU|XBA|XBB|XBC|XBD|XCD|XDR|XFU|XOF|XPD|XPF|XPT|XTS|XXX|YER|ZAR|ZMK|ZWL::USD', NULL, 'enum', 5, 1, NULL),
(1, 'o_currency_place', 1, 'front|back::back', 'At the front|At the back', 'enum', 7, 1, NULL),
(1, 'o_dashboard', 99, 'index.php?controller=pjAdmin&action=pjActionIndex', NULL, 'string', NULL, 0, NULL),
(1, 'o_date_format', 1, 'd.m.Y|m.d.Y|Y.m.d|j.n.Y|n.j.Y|Y.n.j|d/m/Y|m/d/Y|Y/m/d|j/n/Y|n/j/Y|Y/n/j|d-m-Y|m-d-Y|Y-m-d|j-n-Y|n-j-Y|Y-n-j::d.m.Y', 'd.m.Y (25.09.2012)|m.d.Y (09.25.2012)|Y.m.d (2012.09.25)|j.n.Y (25.9.2012)|n.j.Y (9.25.2012)|Y.n.j (2012.9.25)|d/m/Y (25/09/2012)|m/d/Y (09/25/2012)|Y/m/d (2012/09/25)|j/n/Y (25/9/2012)|n/j/Y (9/25/2012)|Y/n/j (2012/9/25)|d-m-Y (25-09-2012)|m-d-Y (09-25-2012)|Y-m-d (2012-09-25)|j-n-Y (25-9-2012)|n-j-Y (9-25-2012)|Y-n-j (2012-9-25)', 'enum', 1, 1, NULL),
(1, 'o_failed_login_disable_form', 6, '2', NULL, 'int', 12, 1, NULL),
(1, 'o_failed_login_disable_form_after', 6, '5', NULL, 'int', 14, 1, NULL),
(1, 'o_failed_login_disbale_form_unit', 6, 'minutes|hours|days|weeks|months::minutes', 'Minutes|Hours|Days|Weeks|Months', 'enum', 13, 1, NULL),
(1, 'o_failed_login_lock_after', 6, NULL, NULL, 'int', 11, 1, NULL),
(1, 'o_failed_login_required_captcha_after', 6, '3', NULL, 'int', 15, 1, NULL),
(1, 'o_failed_login_send_email', 6, 'Yes|No::Yes', 'Yes|No', 'enum', 16, 1, NULL),
(1, 'o_failed_login_send_email_after', 6, '5', NULL, 'int', 17, 1, NULL),
(1, 'o_failed_login_send_email_message', 6, '<p>Dear {Name},</p>\r\n<p>We''ve detected {LoginAttempts} unsuccessful attempts to login your account.</p>\r\n<p>For security reasons we locked down your account.</p>\r\n<p>To unlock your account please contact us.</p>\r\n<p>Regards!</p>', NULL, 'text', 19, 1, NULL),
(1, 'o_failed_login_send_email_subject', 6, 'Your account has been locked!', NULL, 'string', 18, 1, NULL),
(1, 'o_failed_login_send_sms', 6, 'Yes|No::No', 'Yes|No', 'enum', 20, 1, NULL),
(1, 'o_failed_login_send_sms_after', 6, '2', NULL, 'int', 21, 1, NULL),
(1, 'o_failed_login_send_sms_message', 6, 'Dear {Name}, your account has been locked. For more details contact us.', NULL, 'text', 22, 1, NULL),
(1, 'o_fields_index', 99, 'a6e23523c09096d50e73c174b47c03bd', NULL, 'string', NULL, 0, NULL),
(1, 'o_footer_text', 2, NULL, NULL, 'string', 4, 1, NULL),
(1, 'o_forgot_contact_admin', 7, 'Yes|No::No', 'Yes|No', 'enum', 23, 1, NULL),
(1, 'o_forgot_contact_admin_message', 7, '<p>Password reminder was sent to {Name} with email {Email}.</p>', NULL, 'text', 24, 1, NULL),
(1, 'o_forgot_contact_admin_subject', 7, 'Password reminder was used', NULL, 'string', 23, 1, NULL),
(1, 'o_forgot_email_confirmation', 7, 'Yes|No::Yes', 'Yes|No', 'enum', 18, 1, NULL),
(1, 'o_forgot_email_message', 7, '<p>Dear {Name},</p>\r\n<p>We''ve just received a request to reset your password.</p>\r\n<p>To confirm this process is initiated from you please click the following link:<br /><a href="{URL}">{URL}</a></p>\r\n<p>Otherwise, you don''t need to do anything and ignore this email.</p>\r\n<p>Regards!</p>', NULL, 'text', 20, 1, NULL),
(1, 'o_forgot_email_subject', 7, 'Password reminder', NULL, 'string', 19, 1, NULL),
(1, 'o_forgot_sms_confirmation', 7, 'Yes|No::No', 'Yes|No', 'enum', 21, 1, NULL),
(1, 'o_forgot_sms_message', 7, 'Reset your password: {URL}', NULL, 'text', 22, 1, NULL),
(1, 'o_forgot_use_captcha', 7, 'Yes|No::No', 'Yes|No', 'enum', 25, 1, NULL),
(1, 'o_google_maps_api_key', 10, NULL, NULL, 'string', 1, 1, NULL),
(1, 'o_hide_footer', 2, 'Yes|No::No', 'Yes|No', 'enum', 3, 1, NULL),
(1, 'o_hide_page', 2, 'Yes|No::No', 'Yes|No', 'enum', 5, 1, NULL),
(1, 'o_hide_phpjabbers_logo', 2, 'Yes|No::No', 'Yes|No', 'enum', 2, 1, NULL),
(1, 'o_multi_lang', 99, '1|0::1', NULL, 'enum', NULL, 0, NULL),
(1, 'o_password_capital_letter', 4, 'Yes|No::No', 'Yes|No', 'enum', 4, 1, NULL),
(1, 'o_password_change_every', 4, '2', NULL, 'int', 5, 1, NULL),
(1, 'o_password_change_every_unit', 4, 'days|weeks|months::weeks', 'Days|Weeks|Months', 'enum', 6, 1, NULL),
(1, 'o_password_chars_used', 4, 'letters|digits|both::letters', 'Letters only|Digits only|Letter & Digits', 'enum', 2, 1, NULL),
(1, 'o_password_min_length', 4, '4', NULL, 'int', 1, 1, NULL),
(1, 'o_password_special_symbol', 4, 'Yes|No::No', 'Yes|No', 'enum', 3, 1, NULL),
(1, 'o_price_format', 1, '1|2|3|4|5|6::4', '1000|1000.00|1,000|1,000.00|1 000|1 000.00', 'enum', 6, 1, NULL),
(1, 'o_secure_login_1_active_login', 5, 'Yes|No::No', 'Yes|No', 'enum', 8, 1, NULL),
(1, 'o_secure_login_2factor_auth', 5, 'Yes|No::No', 'Yes|No', 'enum', 9, 1, NULL),
(1, 'o_secure_login_send_password_to', 5, 'email|sms::email', 'Email|SMS', 'enum', 10, 1, NULL),
(1, 'o_secure_login_send_password_to_email_message', 5, '<p>Here is your temporary password: {Password}</p>', NULL, 'text', 12, 1, NULL),
(1, 'o_secure_login_send_password_to_email_subject', 5, 'Temporary password', NULL, 'string', 11, 1, NULL),
(1, 'o_secure_login_send_password_to_sms_message', 5, 'Here is your temporary password: {Password}', NULL, 'text', 11, 1, NULL),
(1, 'o_secure_login_use_captcha', 5, 'Yes|No::No', 'Yes|No', 'enum', 7, 1, NULL),
(1, 'o_sender_email', 3, NULL, NULL, 'string', 7, 1, NULL),
(1, 'o_sender_name', 3, NULL, NULL, 'string', 8, 1, NULL),
(1, 'o_send_email', 3, 'mail|smtp::mail', 'PHP mail()|SMTP', 'enum', 1, 1, NULL),
(1, 'o_smtp_auth', 3, 'LOGIN|PLAIN::LOGIN', 'LOGIN|PLAIN', 'enum', 7, 1, NULL),
(1, 'o_smtp_host', 3, NULL, NULL, 'string', 2, 1, NULL),
(1, 'o_smtp_pass', 3, NULL, NULL, 'string', 5, 1, NULL),
(1, 'o_smtp_port', 3, '25', NULL, 'int', 3, 1, NULL),
(1, 'o_smtp_secure', 3, 'none|ssl|tls::none', 'None|SSL|TLS', 'enum', 6, 1, NULL),
(1, 'o_smtp_user', 3, NULL, NULL, 'string', 4, 1, NULL),
(1, 'o_spam_banned_ip', 8, NULL, NULL, 'text', 9, 1, NULL),
(1, 'o_spam_banned_words', 8, NULL, NULL, 'text', 8, 1, NULL),
(1, 'o_timezone', 1, 'Europe/London', NULL, 'string', 3, 1, NULL),
(1, 'o_time_format', 1, 'H:i|G:i|h:i a|h:i A|g:i a|g:i A::H:i', 'H:i (09:45)|G:i (9:45)|h:i a (09:45 am)|h:i A (09:45 AM)|g:i a (9:45 am)|g:i A (9:45 AM)', 'enum', 2, 1, NULL),
(1, 'o_week_start', 1, '0|1|2|3|4|5|6::1', 'Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday', 'enum', 4, 1, NULL),
(1, 'plugin_sms_api_key', 99, NULL, NULL, 'string', NULL, 0, 'string');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_dashboard', 'backend', 'Plugin Base / Menu / Dashboard', 'plugin', '2017-11-20 10:31:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_system_options', 'backend', 'Plugin Base / Menu / System Options', 'plugin', '2017-11-20 10:44:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'System Options', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_general', 'backend', 'Plugin Base / Menu / General', 'plugin', '2017-11-20 10:46:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'General', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_general_title', 'backend', 'Plugin Base / Infobox / General Options', 'plugin', '2017-11-20 11:20:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'General Options', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_general_desc', 'backend', 'Plugin Base / Infobox / General Options', 'plugin', '2017-11-20 11:20:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Here you can set the General Options for the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS01', 'arrays', 'plugin_base_error_titles_ARRAY_PBS01', 'plugin', '2017-11-20 11:24:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS01', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS01', 'plugin', '2017-11-20 11:24:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'General options have been successfully updated. ', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_date_format', 'backend', 'Plugin Base / Options / Date format', 'plugin', '2017-11-20 11:31:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date format', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_time_format', 'backend', 'Plugin Base / Options / Time format', 'plugin', '2017-11-20 11:31:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Time format', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_timezone', 'backend', 'Plugin Base / Options / Timezone', 'plugin', '2017-11-20 11:31:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Timezone', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_week_start', 'backend', 'Plugin Base / Options / First day of week', 'plugin', '2017-11-20 11:31:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First day of week', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_currency', 'backend', 'Plugin Base / Options / Currency', 'plugin', '2017-11-20 11:32:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currency', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_price_format', 'backend', 'Plugin Base / Options / Price format', 'plugin', '2017-11-20 11:32:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price format', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_currency_place', 'backend', 'Plugin Base / Options / Currency symbol place', 'plugin', '2017-11-20 11:33:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currency symbol place', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_currency_places_ARRAY_front', 'arrays', 'plugin_base_currency_places_ARRAY_front', 'plugin', '2017-11-20 11:34:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Before amount', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_currency_places_ARRAY_back', 'arrays', 'plugin_base_currency_places_ARRAY_back', 'plugin', '2017-11-20 11:34:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'After amount', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_save', 'backend', 'Plugin Base / Buttons / Save', 'plugin', '2017-11-20 11:58:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_delete', 'backend', 'Plugin Base / Buttons / Delete', 'plugin', '2017-11-20 11:58:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_reset', 'backend', 'Plugin Base / Buttons / Reset', 'plugin', '2017-11-20 05:37:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_backup', 'backend', 'Plugin Base / Menu / Back-up', 'plugin', '2017-11-20 05:27:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_backup_title', 'backend', 'Plugin Base / Infobox / Back-up', 'plugin', '2017-11-20 05:37:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_backup_desc', 'backend', 'Plugin Base / Infobox / Back-up', 'plugin', '2017-11-20 05:37:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set auto back-up or manually back-up your data. We recommend you to regularly back up your database and files to prevent any loss of information.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBU01', 'arrays', 'plugin_base_error_titles_ARRAY_PBU01', 'plugin', '2017-11-20 05:50:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup complete!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBU01', 'arrays', 'plugin_base_error_bodies_ARRAY_PBU01', 'plugin', '2017-11-20 05:50:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All backup files have been saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_yesno_ARRAY_T', 'arrays', 'plugin_base_yesno_ARRAY_T', 'plugin', '2017-11-20 05:54:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_yesno_ARRAY_F', 'arrays', 'plugin_base_yesno_ARRAY_F', 'plugin', '2017-11-20 05:55:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_create_backup', 'backend', 'Plugin Base / Label / Make back-up', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Make back-up', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_database', 'backend', 'Plugin Base / Label / Back-up database', 'plugin', '2017-11-20 05:56:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup database', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_files', 'backend', 'Plugin Base / Label / Back-up files', 'plugin', '2017-11-20 05:56:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup files', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_backup', 'backend', 'Plugin Base / Buttons / Back-up', 'plugin', '2017-11-20 05:57:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBU03', 'arrays', 'plugin_base_error_titles_ARRAY_PBU03', 'plugin', '2017-11-20 06:05:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBU03', 'arrays', 'plugin_base_error_bodies_ARRAY_PBU03', 'plugin', '2017-11-20 06:06:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No option was selected.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBU04', 'arrays', 'plugin_base_error_titles_ARRAY_PBU04', 'plugin', '2017-11-20 06:07:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBU04', 'arrays', 'plugin_base_error_bodies_ARRAY_PBU04', 'plugin', '2017-11-20 06:08:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up not performed.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBU05', 'arrays', 'plugin_base_error_titles_ARRAY_PBU05', 'plugin', '2017-11-20 06:08:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBU05', 'arrays', 'plugin_base_error_bodies_ARRAY_PBU05', 'plugin', '2017-11-20 06:08:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up folder not found. Please ensure that "app/web/backup" folder exists.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBU06', 'arrays', 'plugin_base_error_titles_ARRAY_PBU06', 'plugin', '2017-11-20 06:09:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBU06', 'arrays', 'plugin_base_error_bodies_ARRAY_PBU06', 'plugin', '2017-11-20 06:09:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You need to set write permissions (chmod 777) to "app/web/backup" folder.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_data_type', 'backend', 'Plugin Base / Backup / Data type', 'plugin', '2017-11-20 06:38:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Data type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_file_size', 'backend', 'Plugin Base / Backup / File size', 'plugin', '2017-11-20 06:39:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File size', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_delete_confirmation', 'backend', 'Plugin Base / Backup / Delete confirmation', 'plugin', '2017-11-20 06:40:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete the selected file?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_delete_selected', 'backend', 'Plugin Base / Backup / Delete selected', 'plugin', '2017-11-20 06:41:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_backup_made', 'backend', 'Plugin Base / Backup / Back-up made', 'plugin', '2017-11-20 06:46:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-up made', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_file_name', 'backend', 'Plugin Base / Backup / File name', 'plugin', '2017-11-20 06:52:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File name', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_sms_settings', 'backend', 'Plugin Base / Menu / SMS Settings', 'plugin', '2017-11-20 07:17:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS Settings', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_sms_settings_title', 'backend', 'Plugin Base / Infobox / SMS Settings', 'plugin', '2017-11-20 07:23:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS Settings', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_sms_settings_desc', 'backend', 'Plugin Base / Infobox / SMS Settings', 'plugin', '2017-11-20 07:23:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter your SMS API key and view messages sent by the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_tab_settings', 'backend', 'Plugin Base / Tab / Settings', 'plugin', '2017-11-20 07:37:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Settings', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_tab_messages_sent', 'backend', 'Plugin Base / Tab / Messages sent', 'plugin', '2017-11-20 07:37:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_infobox_api_settings', 'backend', 'Plugin Base / Tab / API settings infobox', 'plugin', '2017-11-20 07:43:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To send SMS you need a valid API Key. If you have one, enter it in the box below. Click on "Verify your key" button to check if key is valid. Click on "Send a test message" button to send a test message to your phone.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_send_test_message', 'backend', 'Plugin Base / Buttons / Send a test message', 'plugin', '2017-11-20 07:45:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send a test message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_api_key', 'backend', 'Plugin Base / Label / SMS API Key', 'plugin', '2017-11-20 07:46:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS API Key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_verify_your_key', 'backend', 'Plugin Base / Label / Verify your key', 'plugin', '2017-11-20 07:47:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Verify your key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_this_field_is_required', 'backend', 'Plugin Base / Label / This field is required.', 'plugin', '2017-11-20 07:56:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This field is required.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PSS01', 'arrays', 'plugin_base_error_titles_ARRAY_PSS01', 'plugin', '2017-11-20 08:07:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS API key saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PSS01', 'arrays', 'plugin_base_error_bodies_ARRAY_PSS01', 'plugin', '2017-11-20 08:07:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS API key has been successfully saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_0', 'arrays', 'plugin_base_sms_statuses_ARRAY_0', 'plugin', '2017-11-20 08:11:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account limit reached', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_1', 'arrays', 'plugin_base_sms_statuses_ARRAY_1', 'plugin', '2017-11-20 08:11:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message sent', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_2', 'arrays', 'plugin_base_sms_statuses_ARRAY_2', 'plugin', '2017-11-20 08:11:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message not sent', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_3', 'arrays', 'plugin_base_sms_statuses_ARRAY_3', 'plugin', '2017-11-20 08:11:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account not confirmed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_4', 'arrays', 'plugin_base_sms_statuses_ARRAY_4', 'plugin', '2017-11-20 08:12:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Incorrect API key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_statuses_ARRAY_6', 'arrays', 'plugin_base_sms_statuses_ARRAY_6', 'plugin', '2017-11-20 08:12:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account is disabled', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_search', 'backend', 'Plugin Base / Button / Search', 'plugin', '2017-11-20 08:23:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_date_time_sent', 'backend', 'Plugin Base / Date/time sent', 'plugin', '2017-11-20 08:27:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date/time sent', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_number', 'backend', 'Plugin Base / Labe / Number', 'plugin', '2017-11-20 08:27:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_message', 'backend', 'Plugin Base / Labe / Message', 'plugin', '2017-11-20 08:28:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_status', 'backend', 'Plugin Base / Labe / Status', 'plugin', '2017-11-20 08:28:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_key_is_correct', 'backend', 'Plugin Base / Labe / Key is correct.', 'plugin', '2017-11-20 08:43:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Key is correct.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_key_is_invalid', 'backend', 'Plugin Base / Labe / Key is not valid.', 'plugin', '2017-11-20 08:45:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Key is not valid.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_test_message', 'backend', 'Plugin Base / Labe / Test message', 'plugin', '2017-11-20 08:58:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test message for SMS API key.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_test_sms_sent_to', 'backend', 'Plugin Base / Labe / Test SMS has been sent to', 'plugin', '2017-11-20 09:15:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test SMS has been sent to', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_test_sms_title', 'backend', 'Plugin Base / Labe / Send Test SMS', 'plugin', '2017-11-20 09:05:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Test SMS', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_test_sms_text', 'backend', 'Plugin Base / Labe / Send Test SMS text', 'plugin', '2017-11-20 09:06:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter your mobile phone number and system will send a test message to it. Include international country code too!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_send_sms', 'backend', 'Plugin Base / Button / Send SMS', 'plugin', '2017-11-20 09:10:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_cancel', 'backend', 'Plugin Base / Button / Cancel', 'plugin', '2017-11-20 09:10:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_sent', 'backend', 'Plugin Base / Label / SMS sent!', 'plugin', '2017-11-20 09:16:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS sent!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_failed_to_send', 'backend', 'Plugin Base / Label / SMS failed to send!', 'plugin', '2017-11-20 09:17:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS failed to send!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_visual_branding', 'backend', 'Plugin Base / Label / Visual & Branding', 'plugin', '2017-11-21 06:19:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Visual & Branding', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS02', 'arrays', 'plugin_base_error_titles_ARRAY_PBS02', 'plugin', '2017-11-21 06:21:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS02', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS02', 'plugin', '2017-11-21 06:21:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes on Visual & Branding have been saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_visual_branding_title', 'backend', 'Plugin Base / Infobox / Visual & Branding', 'plugin', '2017-11-21 06:22:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Visual & Branding', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_visual_branding_desc', 'backend', 'Plugin Base / Infobox / Visual & Branding', 'plugin', '2017-11-21 06:22:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose a preferred color theme for the back-end of the system and change system branding.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_theme', 'backend', 'Plugin Base / Options / Color theme', 'plugin', '2017-11-21 06:24:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Color theme', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_hide_phpjabbers_logo', 'backend', 'Plugin Base / Options / Hide PHPJabbers.com logo', 'plugin', '2017-11-21 06:25:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide PHPJabbers.com logo', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_hide_footer', 'backend', 'Plugin Base / Options / Hide footer script version', 'plugin', '2017-11-21 06:25:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide footer text', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_footer_text', 'backend', 'Plugin Base / Options / Footer text', 'plugin', '2017-11-21 06:25:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Custom footer text', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_email_settings', 'backend', 'Plugin Base / Label / Email Settings', 'plugin', '2017-11-21 07:34:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email Settings', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS03', 'arrays', 'plugin_base_error_titles_ARRAY_PBS03', 'plugin', '2017-11-21 07:42:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email settings saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS03', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS03', 'plugin', '2017-11-21 07:42:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email settings have been successfully saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_email_settings_title', 'backend', 'Plugin Base / Infobox / Email Settings', 'plugin', '2017-11-21 07:43:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email Settings', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_email_settings_desc', 'backend', 'Plugin Base / Infobox / Email Settings', 'plugin', '2017-11-21 07:44:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the form below to define the settings for sending emails.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_send_email', 'backend', 'Plugin Base / Options / Sending method', 'plugin', '2017-11-21 07:46:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sending method', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_host', 'backend', 'Plugin Base / Options / SMTP Host', 'plugin', '2017-11-21 07:46:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Host', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_port', 'backend', 'Plugin Base / Options / SMTP Port', 'plugin', '2017-11-21 07:46:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Port', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_user', 'backend', 'Plugin Base / Options / SMTP Username', 'plugin', '2017-11-21 07:46:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Username', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_pass', 'backend', 'Plugin Base / Options / SMTP Password', 'plugin', '2017-11-21 07:47:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_auth', 'backend', 'Plugin Base / Options / SMTP Auth Type', 'plugin', '2017-11-21 07:47:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Auth Type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_sender_email', 'backend', 'Plugin Base / Options / Email address ("From" header)', 'plugin', '2017-11-21 07:47:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address ("From" header)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_test_connection', 'backend', 'Plugin Base / Label / Test connection', 'plugin', '2017-11-21 07:51:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test connection', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_send_test_email', 'backend', 'Plugin Base / Label / Send test email', 'plugin', '2017-11-21 07:51:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send test email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_test_smtp_title', 'backend', 'Plugin Base / Label / Test SMTP', 'plugin', '2017-11-21 08:08:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test SMTP', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_test_smtp_text', 'backend', 'Plugin Base / Label / Are you sure you want to test the SMTP connection?', 'plugin', '2017-11-21 08:09:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to test the SMTP connection?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_yes_connect', 'backend', 'Plugin Base / Button / Yes, connect', 'plugin', '2017-11-21 08:09:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes, connect', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_smtp_secure', 'backend', 'Plugin Base / Options / SMTP Secure', 'plugin', '2017-11-21 08:18:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Secure', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_send_test_email_title', 'backend', 'Plugin Base / Label / Send Test Email', 'plugin', '2017-11-21 08:42:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Test Email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_send_email', 'backend', 'Plugin Base / Button / Send Email', 'plugin', '2017-11-21 08:43:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_send_test_email_text', 'backend', 'Plugin Base / Label / Send Test Email text', 'plugin', '2017-11-21 08:44:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter your email address and a test message will be sent to it to verify that system is able to send emails.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_send_test_email_address', 'backend', 'Plugin Base / Label / Email Address', 'plugin', '2017-11-21 08:45:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email Address', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_test_email_subject', 'backend', 'Plugin Base / Label / Test email subject', 'plugin', '2017-11-21 09:06:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test email subject', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_test_email_message', 'backend', 'Plugin Base / Label / Test email message', 'plugin', '2017-11-21 09:09:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Test email message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_languages', 'backend', 'Plugin Base / Menu / Languages', 'plugin', '2017-11-22 04:36:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_languages_title', 'backend', 'Plugin Base / Infobox / Languages', 'plugin', '2017-11-22 06:00:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_languages_desc', 'backend', 'Plugin Base / Infobox / Languages', 'plugin', '2017-11-22 06:01:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add as many languages as you need to your script. For each of the languages added you need to translate all the text titles.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_tab_languages', 'backend', 'Plugin Base / Tab / Languages', 'plugin', '2017-11-22 06:05:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_tab_labels', 'backend', 'Plugin Base / Tab / Labels', 'plugin', '2017-11-22 06:05:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Labels', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_add_language', 'backend', 'Plugin Base / Buttons / Add Language', 'plugin', '2017-11-22 06:08:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add Language', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_language', 'backend', 'Plugin Base / Label / Language', 'plugin', '2017-11-22 06:13:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Language', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_frontend_title', 'backend', 'Plugin Base / Label / Front-end title', 'plugin', '2017-11-22 06:14:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end title', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_flag', 'backend', 'Plugin Base / Label / Flag', 'plugin', '2017-11-22 06:14:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flag', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_text_direction', 'backend', 'Plugin Base / Label / Text direction', 'plugin', '2017-11-22 06:15:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Text direction', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_dir_ARRAY_ltr', 'arrays', 'plugin_base_locale_dir_ARRAY_ltr', 'plugin', '2017-11-22 06:16:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Left to Right', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_dir_ARRAY_rtl', 'arrays', 'plugin_base_locale_dir_ARRAY_rtl', 'plugin', '2017-11-22 06:17:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Right to Left', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_is_default', 'backend', 'Plugin Base / Label / Is default', 'plugin', '2017-11-22 06:17:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is default', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_order', 'backend', 'Plugin Base / Label / Order', 'plugin', '2017-11-22 06:17:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Order', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_btn_reset', 'backend', 'Plugin Base / Button / Reset', 'plugin', '2017-11-22 06:18:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_close', 'backend', 'Plugin Base / Button / Close', 'plugin', '2017-11-22 06:18:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Close', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_tooltip_reset', 'backend', 'Plugin Base / Label / Click to reset', 'plugin', '2017-11-22 06:19:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Click to reset', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_tooltip_upload', 'backend', 'Plugin Base / Label / Upload tooltip', 'plugin', '2017-11-22 06:19:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Click to upload', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_labels_title', 'backend', 'Plugin Base / Infobox / Labels', 'plugin', '2017-11-22 07:07:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Labels', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_labels_desc', 'backend', 'Plugin Base / Infobox / Labels', 'plugin', '2017-11-22 07:09:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Using the form below you can edit all the text in the software.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_lbl_search', 'backend', 'Plugin Base / Label / Search', 'plugin', '2017-11-22 07:12:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_advanced_on', 'backend', 'Plugin Base / Label / Advanced Translation is ON', 'plugin', '2017-11-22 07:14:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Advanced Translation is ON', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_advanced_off', 'backend', 'Plugin Base / Label / Advanced Translation is OFF', 'plugin', '2017-11-22 07:15:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Advanced Translation is OFF', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_advanced_title', 'backend', 'Plugin Base / Label / Info', 'plugin', '2017-11-22 07:20:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Info', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_advanced_desc', 'backend', 'Plugin Base / Label / Info', 'plugin', '2017-11-22 07:20:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Each piece of text used in the software is saved in the database and has its own unique ID. To show these IDs in the script itself turn on the "Show labels ID" switch. This will show the corresponding :ID: for each label in the script. Please, note that ONLY you will see these IDs. Now you can search for any ID and easily change and/or translate the text. Have in the mind that you should use : before and after the ID when you search for it.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_advanced_show_id', 'backend', 'Plugin Base / Label / Show labels ID', 'plugin', '2017-11-22 07:20:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show labels ID', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_confirm', 'backend', 'Plugin Base / Button / Confirm', 'plugin', '2017-11-22 07:21:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirm', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_showid_dialog_title', 'backend', 'Plugin Base / Label / Show IDs', 'plugin', '2017-11-22 07:22:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Show IDs', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_showid_dialog_desc', 'backend', 'Plugin Base / Label / Show IDs', 'plugin', '2017-11-22 07:22:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID will be displayed next to each text found in the software. You can then search for an ID to easily change or translate the text.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_translate_to', 'backend', 'Plugin Base / Label / Translate to', 'plugin', '2017-11-22 07:52:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Translate to', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_id', 'backend', 'Plugin Base / Label / ID', 'plugin', '2017-11-22 07:53:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_default_language', 'backend', 'Plugin Base / Label / Default language', 'plugin', '2017-11-22 08:14:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default language', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_hide_page', 'backend', 'Plugin Base / Options / Hide this page', 'plugin', '2017-11-22 08:34:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide this page', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_login_protection', 'backend', 'Plugin Base / Menu / Login & Protection', 'plugin', '2017-11-22 09:02:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login & Protection', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_login_protection_title', 'backend', 'Plugin Base / Infobox / Login & Protection', 'plugin', '2017-11-22 09:36:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login & Protection', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_login_protection_desc', 'backend', 'Plugin Base / Infobox / Login & Protection', 'plugin', '2017-11-22 09:36:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Configure system login and security settings.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS04', 'arrays', 'plugin_base_error_titles_ARRAY_PBS04', 'plugin', '2017-11-22 09:37:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login & Protection saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS04', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS04', 'plugin', '2017-11-22 09:37:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login & Protection settings have been successfully saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_password_title', 'backend', 'Plugin Base / Infobox / Password', 'plugin', '2017-11-22 09:43:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_password_desc', 'backend', 'Plugin Base / Infobox / Password', 'plugin', '2017-11-22 09:43:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set various settings related to the password used by users to login the backend of the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_secure_login_title', 'backend', 'Plugin Base / Infobox / Secure Login', 'plugin', '2017-11-22 09:44:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Secure Login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_secure_login_desc', 'backend', 'Plugin Base / Infobox / Secure Login description', 'plugin', '2017-11-22 09:45:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set various settings related to system login.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_failed_login_title', 'backend', 'Plugin Base / Infobox / Failed Login', 'plugin', '2017-11-22 09:45:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Failed Login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_failed_login_desc', 'backend', 'Plugin Base / Infobox / Failed Login description', 'plugin', '2017-11-22 09:46:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set various settings related to what happens when user fails to login.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_forgot_password_title', 'backend', 'Plugin Base / Infobox / Forgot Password', 'plugin', '2017-11-22 09:46:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_forgot_password_desc', 'backend', 'Plugin Base / Infobox / Forgot Pasword description', 'plugin', '2017-11-22 09:47:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set various settings related to forgot password feature.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_password_min_length', 'backend', 'Plugin Base / Options / Minimum length', 'plugin', '2017-11-22 09:50:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Minimum length', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_password_chars_used', 'backend', 'Plugin Base / Options / Characters used', 'plugin', '2017-11-22 09:51:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Characters used', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_password_special_symbol', 'backend', 'Plugin Base / Options / Require special symbol', 'plugin', '2017-11-22 10:02:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Require special symbol', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_password_capital_letter', 'backend', 'Plugin Base / Options / Require capital letter', 'plugin', '2017-11-22 10:02:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Require capital letter', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_password_change_every', 'backend', 'Plugin Base / Options / Require users to change password every', 'plugin', '2017-11-22 10:03:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Require users to change password every', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_password_every_ARRAY_days', 'arrays', 'plugin_base_password_every_ARRAY_days', 'plugin', '2017-11-22 10:17:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'days', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_password_every_ARRAY_weeks', 'arrays', 'plugin_base_password_every_ARRAY_weeks', 'plugin', '2017-11-22 10:17:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'weeks', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_password_every_ARRAY_months', 'arrays', 'plugin_base_password_every_ARRAY_months', 'plugin', '2017-11-22 10:17:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'months', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_use_captcha', 'backend', 'Plugin Base / Options / Use captcha', 'plugin', '2017-11-22 10:18:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use captcha', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_1_active_login', 'backend', 'Plugin Base / Options / Allow only 1 active login per user', 'plugin', '2017-11-22 10:18:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow only 1 active login per user', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_2factor_auth', 'backend', 'Plugin Base / Options / Two-Factor Authentication', 'plugin', '2017-11-22 10:19:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Two-Factor Authentication', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_send_password_to', 'backend', 'Plugin Base / Options / Send temporary password to', 'plugin', '2017-11-22 10:21:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send temporary password to', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_send_to_ARRAY_email', 'arrays', 'plugin_base_password_every_ARRAY_email', 'plugin', '2017-11-22 10:24:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_send_to_ARRAY_sms', 'arrays', 'plugin_base_password_every_ARRAY_sms', 'plugin', '2017-11-22 10:24:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_lock_after', 'backend', 'Plugin Base / Options / Lock account after', 'plugin', '2017-11-22 10:27:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Lock account after', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_disable_form', 'backend', 'Plugin Base / Options / Disable login form for', 'plugin', '2017-11-22 10:27:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Disable login form for', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_required_captcha_after', 'backend', 'Plugin Base / Options / Temporary require Captcha after', 'plugin', '2017-11-22 10:28:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Temporary require Captcha after', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_email_after', 'backend', 'Plugin Base / Options / Send email to account owner after', 'plugin', '2017-11-22 10:28:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send notification to account owner after', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_sms_after', 'backend', 'Plugin Base / Options / Send SMS to account owner after', 'plugin', '2017-11-22 10:28:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS to account owner after', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_failed_login_attempts', 'backend', 'Plugin Base / Label / failed login attempts', 'plugin', '2017-11-22 10:34:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'failed login attempts', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_disable_units_ARRAY_hours', 'arrays', 'plugin_base_enum_disable_units_ARRAY_hours', 'plugin', '2017-11-22 10:37:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hours', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_disable_units_ARRAY_minutes', 'arrays', 'plugin_base_enum_disable_units_ARRAY_minutes', 'plugin', '2017-11-22 10:37:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'minutes', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_disable_units_ARRAY_days', 'arrays', 'plugin_base_enum_disable_units_ARRAY_days', 'plugin', '2017-11-22 10:38:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'days', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_disable_units_ARRAY_weeks', 'arrays', 'plugin_base_enum_disable_units_ARRAY_weeks', 'plugin', '2017-11-22 10:38:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'weeks', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_disable_units_ARRAY_months', 'arrays', 'plugin_base_enum_disable_units_ARRAY_months', 'plugin', '2017-11-22 10:38:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'months', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_label_after', 'backend', 'Plugin Base / Label / after', 'plugin', '2017-11-22 10:39:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'after', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_email_confirmation', 'backend', 'Plugin Base / Options / Email confirmation', 'plugin', '2017-11-22 10:43:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_sms_confirmation', 'backend', 'Plugin Base / Options / SMS confirmation', 'plugin', '2017-11-22 10:43:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password SMS', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_contact_admin', 'backend', 'Plugin Base / Options / Contact admin', 'plugin', '2017-11-22 10:44:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Contact admin', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_use_captcha', 'backend', 'Plugin Base / Options / Use captcha on forgot password page', 'plugin', '2017-11-22 10:44:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use captcha on forgot password page', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_captcha_spam', 'backend', 'Plugin Base / Menu / Captcha &  Spam', 'plugin', '2017-11-23 02:42:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha &  Spam', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS05', 'arrays', 'plugin_base_error_titles_ARRAY_PBS05', 'plugin', '2017-11-23 02:45:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha & Spam settings saved!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS05', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS05', 'plugin', '2017-11-23 02:45:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes on Captcha & Spam settings have been successfully saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_location', 'backend', 'Plugin Base / Options / Captcha Location', 'plugin', '2017-11-23 03:02:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha Location', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_type', 'backend', 'Plugin Base / Options / Type', 'plugin', '2017-11-23 03:02:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_background', 'backend', 'Plugin Base / Options / Background', 'plugin', '2017-11-23 03:03:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Background', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_mode', 'backend', 'Plugin Base / Options / Mode', 'plugin', '2017-11-23 03:03:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mode', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_length', 'backend', 'Plugin Base / Options / Length', 'plugin', '2017-11-23 03:03:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Length', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_spam_banned_words', 'backend', 'Plugin Base / Options / Banned words', 'plugin', '2017-11-23 03:03:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Banned words', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_spam_banned_ip', 'backend', 'Plugin Base / Options / Banned IP addresses', 'plugin', '2017-11-23 03:04:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Banned IP addresses', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_captcha_title', 'backend', 'Plugin Base / Infobox / Captcha', 'plugin', '2017-11-23 03:06:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha (Back-end)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_captcha_desc', 'backend', 'Plugin Base / Infobox / Captcha description', 'plugin', '2017-11-23 03:06:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set options for the captcha used on the back-end login page.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_spam_title', 'backend', 'Plugin Base / Infobox / SPAM Protection', 'plugin', '2017-11-23 03:07:20');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SPAM Protection', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_spam_desc', 'backend', 'Plugin Base / Infobox / SPAM Protection description', 'plugin', '2017-11-23 03:07:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter IP addresses that you want to prevent from accessing back-end and front-end of the system. Enter one IP address per line.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_lbl_symbols', 'backend', 'Plugin Base / Label / symbols', 'plugin', '2017-11-23 03:11:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'symbols', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_captcha_spam_title', 'backend', 'Plugin Base / Infobox / Captcha & SPAM', 'plugin', '2017-11-23 03:12:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha & SPAM', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_captcha_spam_desc', 'backend', 'Plugin Base / Infobox / Captcha & SPAM description', 'plugin', '2017-11-23 03:12:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set captcha and spam protection settings.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_captcha_location_ARRAY_admin', 'arrays', 'plugin_base_enum_captcha_location_ARRAY_admin', 'plugin', '2017-11-23 03:21:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administration page', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_captcha_location_ARRAY_front', 'arrays', 'plugin_base_enum_captcha_location_ARRAY_front', 'plugin', '2017-11-23 03:21:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_captcha_types_ARRAY_system', 'arrays', 'plugin_base_enum_captcha_location_ARRAY_system', 'plugin', '2017-11-23 03:22:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'System', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_captcha_types_ARRAY_google', 'arrays', 'plugin_base_enum_captcha_location_ARRAY_google', 'plugin', '2017-11-23 03:22:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_background_ARRAY_plain', 'arrays', 'plugin_base_enum_background_ARRAY_plain', 'plugin', '2017-11-23 03:23:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Plain', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_background_ARRAY_pattern', 'arrays', 'plugin_base_enum_background_ARRAY_pattern', 'plugin', '2017-11-23 03:23:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pattern', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_modes_ARRAY_string', 'arrays', 'plugin_base_enum_modes_ARRAY_string', 'plugin', '2017-11-23 03:24:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'String', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_modes_ARRAY_addition', 'arrays', 'plugin_base_enum_modes_ARRAY_addition', 'plugin', '2017-11-23 03:24:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Addition', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_modes_ARRAY_subtraction', 'arrays', 'plugin_base_enum_modes_ARRAY_subtraction', 'plugin', '2017-11-23 03:25:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subtraction', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_enum_modes_ARRAY_random_math', 'arrays', 'plugin_base_enum_modes_ARRAY_random_math', 'plugin', '2017-11-23 03:25:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Random math', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_site_key', 'backend', 'Plugin Base / Options / Google reCaptcha site key', 'plugin', '2017-11-23 04:21:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google reCaptcha site key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_secret_key', 'backend', 'Plugin Base / Options / Google reCaptcha secret key', 'plugin', '2017-11-23 04:21:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google reCaptcha secret key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_email', 'backend', 'Plugin Base / Label / Email', 'plugin', '2017-11-24 04:22:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_password', 'backend', 'Plugin Base / Label / Password', 'plugin', '2017-11-24 04:22:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_email_invalid', 'backend', 'Plugin Base / Label / Email address is not valid.', 'plugin', '2017-11-24 04:22:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address is not valid.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_login', 'backend', 'Plugin Base / Buttons / Login', 'plugin', '2017-11-24 04:23:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_link_forgot_password', 'backend', 'Plugin Base / Links / Forgot password', 'plugin', '2017-11-24 04:23:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_4', 'arrays', 'plugin_base_login_err_ARRAY_4', 'plugin', '2017-11-24 06:22:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Parameters are missing.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_5', 'arrays', 'plugin_base_login_err_ARRAY_5', 'plugin', '2017-11-24 06:22:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your account has been locked after %u failed login attempts.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_6', 'arrays', 'plugin_base_login_err_ARRAY_6', 'plugin', '2017-11-24 07:36:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address does not exist.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_7', 'arrays', 'plugin_base_login_err_ARRAY_7', 'plugin', '2017-11-24 07:38:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password is not correct.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_disable_form_message', 'backend', 'Plugin Base / Label / Disable form message', 'plugin', '2017-11-24 09:10:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login form is disabled after failed login attempts.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_captcha', 'backend', 'Plugin Base / Label / Captcha', 'plugin', '2017-11-24 09:25:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_captcha_incorrect', 'backend', 'Plugin Base / Label / Captcha is not correct.', 'plugin', '2017-11-24 09:26:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is not correct.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_users', 'backend', 'Plugin Base / Menu / Users', 'plugin', '2017-11-30 06:11:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_users_title', 'backend', 'Plugin Base / Infobox / Users', 'plugin', '2017-11-30 06:16:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_users_desc', 'backend', 'Plugin Base / Infobox / Users description', 'plugin', '2017-11-30 06:17:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add and manage system users. Set users as ''Inactive'' if you wish to temporarily restrict their access to the system without deleting them. Click on permissions icon to configure user permission levels.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PU01', 'arrays', 'plugin_base_error_titles_ARRAY_PU01', 'plugin', '2017-11-30 06:23:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User updated!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PU01', 'arrays', 'plugin_base_error_bodies_ARRAY_PU01', 'plugin', '2017-11-30 06:24:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this user have been saved. ', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PU03', 'arrays', 'plugin_base_error_titles_ARRAY_PU03', 'plugin', '2017-11-30 06:24:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User added!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PU03', 'arrays', 'plugin_base_error_bodies_ARRAY_PU03', 'plugin', '2017-11-30 06:25:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The user has been added into the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PU04', 'arrays', 'plugin_base_error_titles_ARRAY_PU04', 'plugin', '2017-11-30 06:25:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User failed to add!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PU04', 'arrays', 'plugin_base_error_bodies_ARRAY_PU04', 'plugin', '2017-11-30 06:26:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The user could not be added into the system successfully.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PU08', 'arrays', 'plugin_base_error_titles_ARRAY_PU08', 'plugin', '2017-11-30 06:26:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User not found!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PU08', 'arrays', 'plugin_base_error_bodies_ARRAY_PU08', 'plugin', '2017-11-30 06:26:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The user you are looking for is missing. Please try again.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_add_user', 'backend', 'Plugin Base / Buttons / Add user', 'plugin', '2017-11-30 06:28:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add user', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_lbl_all', 'backend', 'Plugin Base / Label / All', 'plugin', '2017-11-30 06:29:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_filter_ARRAY_active', 'arrays', 'plugin_base_filter_ARRAY_active', 'plugin', '2017-11-30 06:30:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_filter_ARRAY_inactive', 'arrays', 'plugin_base_filter_ARRAY_inactive', 'plugin', '2017-11-30 06:30:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_name', 'backend', 'Plugin Base / Label / Name', 'plugin', '2017-11-30 06:41:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_email', 'backend', 'Plugin Base / Label / Email', 'plugin', '2017-11-30 06:41:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_last_login', 'backend', 'Plugin Base / Label / Last login', 'plugin', '2017-11-30 06:42:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_role', 'backend', 'Plugin Base / Label / Role', 'plugin', '2017-11-30 06:42:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Role', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_status', 'backend', 'Plugin Base / Label / Status', 'plugin', '2017-11-30 06:42:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_revert_status', 'backend', 'Plugin Base / Label / Revert status', 'plugin', '2017-11-30 06:42:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_export', 'backend', 'Plugin Base / Label / Export', 'plugin', '2017-11-30 06:43:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_delete_selected', 'backend', 'Plugin Base / Label / Delete selected', 'plugin', '2017-11-30 06:43:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_delete_confirmation', 'backend', 'Plugin Base / Label / Delete confirmation', 'plugin', '2017-11-30 06:43:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete the selected record(s)?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_add_user_title', 'backend', 'Plugin Base / Infobox / Add User', 'plugin', '2017-11-30 08:13:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add User', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_add_user_desc', 'backend', 'Plugin Base / Infobox / Add User', 'plugin', '2017-11-30 08:14:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill out the fields and click on ''Save'' button to add new user to the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_choose', 'backend', 'Plugin Base / Label / Choose', 'plugin', '2017-11-30 08:20:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_password', 'backend', 'Plugin Base / Label / Password', 'plugin', '2017-11-30 08:22:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_phone', 'backend', 'Plugin Base / Label / Phone', 'plugin', '2017-11-30 08:27:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_email_in_used', 'backend', 'Plugin Base / Label / Email address was already used.', 'plugin', '2017-11-30 08:29:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address was already used.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_invalid_password_title', 'backend', 'Plugin Base / Label / Invalid Password', 'plugin', '2017-11-30 09:05:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid Password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_ok', 'backend', 'Plugin Base / Buttons / OK', 'plugin', '2017-11-30 09:07:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'OK', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_update_user_title', 'backend', 'Plugin Base / Infobox / Update User', 'plugin', '2017-11-30 09:16:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update User', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_update_user_desc', 'backend', 'Plugin Base / Infobox / Update User', 'plugin', '2017-11-30 09:17:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Review and update User''s data.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_registration_date_time', 'backend', 'Plugin Base / Label / Registration date/time', 'plugin', '2017-11-30 09:23:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Registration date/time', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_ip_address', 'backend', 'Plugin Base / Label / IP address', 'plugin', '2017-11-30 09:23:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'IP address', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PPR01', 'arrays', 'plugin_base_error_titles_ARRAY_PPR01', 'plugin', '2017-12-01 05:07:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Permission updated!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PPR01', 'arrays', 'plugin_base_error_bodies_ARRAY_PPR01', 'plugin', '2017-12-01 05:07:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Permission changes have been saved successfully.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_permissions_title', 'backend', 'Plugin Base / Infobox / Permissions', 'plugin', '2017-12-01 05:09:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Permissions', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_permissions_desc', 'backend', 'Plugin Base / Infobox / Permissions', 'plugin', '2017-12-01 05:10:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can see below the list of permissions.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_permission_title', 'backend', 'Plugin Base / Infobox / Title', 'plugin', '2017-12-01 05:10:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_permission_key', 'backend', 'Plugin Base / Infobox / Key', 'plugin', '2017-12-01 05:11:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_set_role_permission', 'backend', 'Plugin Base / Buttons / Set permissions for role', 'plugin', '2017-12-01 05:16:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set permissions for role', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_role_permissions_title', 'backend', 'Plugin Base / Infobox / Set permissions for role', 'plugin', '2017-12-01 05:23:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set permissions for role', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_role_permissions_desc', 'backend', 'Plugin Base / Infobox / Set permissions for role', 'plugin', '2017-12-01 05:24:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can set the permission for the selected role by using the form below.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_set_permissions', 'backend', 'Plugin Base / Buttons / Set permissions', 'plugin', '2017-12-01 08:25:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set permissions', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_reset_permissions', 'backend', 'Plugin Base / Buttons / Reset permissions', 'plugin', '2017-12-01 05:16:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset permissions', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_reset_user_permissions_title', 'backend', 'Plugin Base / Reset user permissions title', 'plugin', '2017-12-01 05:16:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset user permissions', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_reset_user_permissions_text', 'backend', 'Plugin Base / Reset user permissions text', 'plugin', '2017-12-01 05:16:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to reset the permissions of this user? If yes, the current permissions will be replaced with the default role permissions based on user''s role.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_user_permissions_title', 'backend', 'Plugin Base / Infobox / Set permissions for user', 'plugin', '2017-12-01 08:33:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set permissions for user', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_user_permissions_desc', 'backend', 'Plugin Base / Infobox / Set permissions for user', 'plugin', '2017-12-01 08:33:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can set the permission for the selected user by using the form below.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_access_denied_title', 'backend', 'Plugin Base / Label / Access denied', 'plugin', '2017-12-01 09:28:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Access denied', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_access_denied_desc', 'backend', 'Plugin Base / Label / Access denied', 'plugin', '2017-12-01 09:30:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You don''t have requisite rights to access this page.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_type_front', 'backend', 'Plugin Base / Options / Type', 'plugin', '2017-12-04 07:15:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_background_front', 'backend', 'Plugin Base / Options / Background', 'plugin', '2017-12-04 07:15:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Background', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_mode_front', 'backend', 'Plugin Base / Options / Mode', 'plugin', '2017-12-04 07:15:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mode', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_length_front', 'backend', 'Plugin Base / Options / Length', 'plugin', '2017-12-04 07:16:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Length', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_site_key_front', 'backend', 'Plugin Base / Options / Google reCaptcha site key', 'plugin', '2017-12-04 07:16:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google reCaptcha site key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_captcha_secret_key_front', 'backend', 'Plugin Base / Options / Google reCaptcha secret key', 'plugin', '2017-12-04 07:16:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google reCaptcha secret key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_enable_auto_backup', 'backend', 'Plugin Base / Label / Enable auto-backup', 'plugin', '2017-12-04 09:15:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enable auto-backup', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PBS06', 'arrays', 'plugin_base_error_titles_ARRAY_PBS06', 'plugin', '2017-12-04 09:31:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API Keys updated!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PBS06', 'arrays', 'plugin_base_error_bodies_ARRAY_PBS06', 'plugin', '2017-12-04 09:32:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API keys have been saved successfully!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_api_keys', 'backend', 'Plugin Base / Label / API Keys', 'plugin', '2017-12-04 09:36:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API Keys', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_api_keys_title', 'backend', 'Plugin Base / Infobox / API Keys', 'plugin', '2017-12-04 09:37:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API Keys', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_api_keys_desc', 'backend', 'Plugin Base / Infobox / API Keys', 'plugin', '2017-12-04 09:38:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set API keys for third-party services used by the system.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_no_api_keys_added', 'backend', 'Plugin Base / Label / No API keys added!', 'plugin', '2017-12-04 09:43:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No API keys added!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_verify_key', 'backend', 'Plugin Base / Button / Verify Key', 'plugin', '2017-12-04 09:50:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Verify Key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_cron_jobs', 'backend', 'Plugin Base / Menu / Cron jobs', 'plugin', '2017-12-05 07:08:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cron jobs', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_cron_jobs_title', 'backend', 'Plugin Base / Infobox / Cron Jobs', 'plugin', '2017-12-05 07:12:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cron Jobs', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_infobox_cron_jobs_desc', 'backend', 'Plugin Base / Infobox / Cron Jobs', 'plugin', '2017-12-05 07:12:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cron jobs are scheduled tasks that will automatically be run at specific times. In order to enable cron jobs you need to configure a cron script using your hosting account control panel. Depending on the software your server uses you will need either server path or URL to set the cron jobs. Set this cron.php script to run every 5 minutes!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_url', 'backend', 'Plugin Base / Menu / Cron URL', 'plugin', '2017-12-05 07:23:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_type', 'backend', 'Plugin Base / Menu / Cron Type', 'plugin', '2017-12-05 07:27:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cron Type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_interval', 'backend', 'Plugin Base / Menu / Interval', 'plugin', '2017-12-05 07:27:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Interval', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_next_run', 'backend', 'Plugin Base / Label / Next run', 'plugin', '2017-12-05 07:28:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next run', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_last_run', 'backend', 'Plugin Base / Label / Last run', 'plugin', '2017-12-05 07:28:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last run', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_status', 'backend', 'Plugin Base / Label / Status', 'plugin', '2017-12-05 07:29:03');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_no_cron_jobs', 'backend', 'Plugin Base / Label / There are no cron jobs found.', 'plugin', '2017-12-05 07:52:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are no cron jobs found.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_periods_ARRAY_minute', 'arrays', 'plugin_base_cron_periods_ARRAY_minute', 'plugin', '2017-12-05 07:54:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'minute(s)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_periods_ARRAY_hour', 'arrays', 'plugin_base_cron_periods_ARRAY_hour', 'plugin', '2017-12-05 07:55:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hour(s)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_periods_ARRAY_day', 'arrays', 'plugin_base_cron_periods_ARRAY_day', 'plugin', '2017-12-05 07:55:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'day(s)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_periods_ARRAY_week', 'arrays', 'plugin_base_cron_periods_ARRAY_week', 'plugin', '2017-12-05 07:55:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'week(s)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_periods_ARRAY_month', 'arrays', 'plugin_base_cron_periods_ARRAY_month', 'plugin', '2017-12-05 07:55:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'month(s)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cron_run_now', 'backend', 'Plugin Base / Label / Run now', 'plugin', '2017-12-05 07:56:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Run now', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_lbl_na', 'backend', 'Plugin Base / Label / N/A', 'plugin', '2017-12-05 08:04:19');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'N/A', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cront_alert_title', 'backend', 'Plugin Base / Label / Run cron job?', 'plugin', '2017-12-05 08:27:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Run cron job?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_cront_alert_text', 'backend', 'Plugin Base / Label / Are you sure that you want to run this cron job?', 'plugin', '2017-12-05 08:28:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to run this cron job?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_languages_tab_import_export', 'backend', 'Plugin Base / Tab / Import / Export', 'plugin', '2017-12-06 08:32:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import / Export', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_ie_title', 'backend', 'Plugin Base / Infobox / Import / Export', 'plugin', '2017-12-06 08:37:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import / Export', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_infobox_ie_desc', 'backend', 'Plugin Base / Infobox / Import / Export', 'plugin', '2017-12-06 08:37:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use form below to Import or Export CSV with all titles. Please, do not change first row and first and second column in the CSV file.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_import', 'backend', 'Plugin Base / Label / Import', 'plugin', '2017-12-06 08:50:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_delimiter', 'backend', 'Plugin Base / Label / Delimiter', 'plugin', '2017-12-06 08:53:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delimiter', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_separators_ARRAY_comma', 'arrays', 'plugin_base_locale_separators_ARRAY_comma', 'plugin', '2017-12-06 08:54:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Comma', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_separators_ARRAY_semicolon', 'arrays', 'plugin_base_locale_separators_ARRAY_semicolon', 'plugin', '2017-12-06 08:54:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Semicolon', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_separators_ARRAY_tab', 'arrays', 'plugin_base_locale_separators_ARRAY_tab', 'plugin', '2017-12-06 08:54:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tab', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_browse_csv_file', 'backend', 'Plugin Base / Label / Browse CSV file', 'plugin', '2017-12-06 08:58:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Browse CSV file', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_select_file', 'backend', 'Plugin Base / Label / Select File', 'plugin', '2017-12-06 08:59:09');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select File', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_change_file', 'backend', 'Plugin Base / Label / Change File', 'plugin', '2017-12-06 08:59:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change File', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_import', 'backend', 'Plugin Base / Buttons / Import', 'plugin', '2017-12-06 09:02:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_lbl_export', 'backend', 'Plugin Base / Label / Export', 'plugin', '2017-12-06 09:04:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_export', 'backend', 'Plugin Base / Buttons / Export', 'plugin', '2017-12-06 09:05:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL01', 'arrays', 'Locale plugin / Status title', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Titles Updated', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL01', 'arrays', 'Locale plugin / Status body', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to titles have been saved.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL02', 'arrays', 'Locale plugin / Status title', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL02', 'arrays', 'Locale plugin / Status body', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed due missing parameters.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL03', 'arrays', 'Locale plugin / Status title', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import complete', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL03', 'arrays', 'Locale plugin / Status body', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The import was performed successfully.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL04', 'arrays', 'Locale plugin / Status title', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL04', 'arrays', 'Locale plugin / Status body', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed due empty data.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL05', 'arrays', 'Locale plugin / Status title', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import error', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL05', 'arrays', 'Locale plugin / Status body', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed because file cannot be open.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL20', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL20', 'plugin', '2014-07-21 07:54:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The following languages have been found. Select those you want to import.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL20', 'arrays', 'plugin_base_error_titles_ARRAY_PAL20', 'plugin', '2014-07-21 07:55:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import confirmation', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL11', 'arrays', 'plugin_base_error_titles_ARRAY_PAL11', 'plugin', '2014-07-21 07:58:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL11', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL11', 'plugin', '2014-07-21 07:58:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing, empty or invalid parameters.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL12', 'arrays', 'plugin_base_error_titles_ARRAY_PAL12', 'plugin', '2014-07-21 07:59:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL12', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL12', 'plugin', '2014-07-21 07:59:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File have not been uploaded.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL13', 'arrays', 'plugin_base_error_titles_ARRAY_PAL13', 'plugin', '2014-07-21 08:00:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL13', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL13', 'plugin', '2014-07-21 08:01:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Uploaded file cannot open for reading.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL14', 'arrays', 'plugin_base_error_titles_ARRAY_PAL14', 'plugin', '2014-07-21 08:01:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL14', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL14', 'plugin', '2014-07-21 08:01:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New line(s) have been found.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL15', 'arrays', 'plugin_base_error_titles_ARRAY_PAL15', 'plugin', '2014-07-21 08:01:51');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL15', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL15', 'plugin', '2014-07-21 08:04:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Uploaded file doesn''t contain the necessary columns.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL16', 'arrays', 'plugin_base_error_titles_ARRAY_PAL16', 'plugin', '2014-07-21 08:04:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL16', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL16', 'plugin', '2014-07-21 08:05:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number of columns are not equal on every row.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL17', 'arrays', 'plugin_base_error_titles_ARRAY_PAL17', 'plugin', '2014-07-21 08:06:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL17', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL17', 'plugin', '2014-07-21 08:06:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid data found.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL18', 'arrays', 'plugin_base_error_titles_ARRAY_PAL18', 'plugin', '2014-07-21 08:26:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL18', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL18', 'plugin', '2014-07-21 08:27:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing columns.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PAL19', 'arrays', 'plugin_base_error_titles_ARRAY_PAL19', 'plugin', '2014-07-21 08:27:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Import failed', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PAL19', 'arrays', 'plugin_base_error_bodies_ARRAY_PAL19', 'plugin', '2014-07-21 08:27:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid data found.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_error_line', 'backend', 'Plugin Base / Label / Error line', 'plugin', '2017-12-06 09:25:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The error was found at line: %s', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_profile', 'backend', 'Plugin Base / Menu Profile', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_menu_logout', 'backend', 'Plugin Base / Menu Logout', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Log out', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_header_welcome', 'backend', 'Plugin Base / Header / Welcome', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Welcome, {NAME}.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_admin_login', 'backend', 'Plugin Base / Admin Login', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Admin Login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_dashboard', 'backend', 'Plugin Base / Options / Dashboard page URL', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard page URL', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_log_menu_log', 'backend', 'Plugin Base / Menu Log', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Log', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_log_menu_config', 'backend', 'Plugin Base / Menu Config', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Config log', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_log_btn_empty', 'backend', 'Plugin Base / Empty button', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Empty log', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_titles_ARRAY_PLG01', 'arrays', 'plugin_base_error_titles_ARRAY_PLG01', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Config log updated.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_error_bodies_ARRAY_PLG01', 'arrays', 'plugin_base_error_bodies_ARRAY_PLG01', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The config log have been updated.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_api_key', 'backend', 'Plugin Base / API key', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'API key', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_phone_portrait', 'backend', 'Plugin Base / Editor / Phone portrait', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone Portrait View', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_phone_landscape', 'backend', 'Plugin Base / Editor / Phone landscape', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone Landscape View', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_tablet_portrait', 'backend', 'Plugin Base / Editor / Tablet portrait', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tablet Portrait View', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_tablet_landscape', 'backend', 'Plugin Base / Editor / Tablet landscape', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tablet Landscape View', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_phone_portrait_info', 'backend', 'Plugin Base / Editor / Phone portrait info', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'See how your website looks on mobile phone in portrait mode - 320px x 490px.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_phone_landscape_info', 'backend', 'Plugin Base / Editor / Phone landscape info', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'See how your website looks on mobile phone in landscape mode - 490px x 320px.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_tablet_portrait_info', 'backend', 'Plugin Base / Editor / Tablet portrait info', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'See how your website looks on a tablet in portrait mode - 770px x 990px.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_editor_tablet_landscape_info', 'backend', 'Plugin Base / Editor / Tablet landscape info', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'See how your website looks on a tablet in landscape mode - 990px x 770px.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_hide_page_text', 'backend', 'Plugin Base / Options / Hide this page text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'If you choose to hide this page then it will not be available in the menu and you can only access it by using its URL: {URL}', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_backup_enable_auto_backup_text', 'backend', 'Plugin Base / Label / Enable auto-backup text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please, make sure CRON jobs are configured. Please, go to <a href="index.php?controller=pjBaseCron&action=pjActionIndex">System Options - Cron jobs</a> and follow the instructions.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_server_path', 'backend', 'Plugin Base / Label / Server path', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Server path', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_account_locked', 'backend', 'Plugin Base / Account locked', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account locked', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_available_tokens', 'backend', 'Plugin Base / Available tokens', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_email_subject', 'backend', 'Plugin Base / Options / Failed login email subject', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email subject', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_email_message', 'backend', 'Plugin Base / Options / Failed login email message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_sms_message', 'backend', 'Plugin Base / Options / Failed login SMS message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS message sent to account owner', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_link_resend_password', 'backend', 'Plugin Base / Links / Resend password', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Not received your password? Click here to resend', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_two_factor_auth_email_title', 'backend', 'Plugin Base / Label / Two factor authentication title (email)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter the temporary password that was sent to your email to login.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_two_factor_auth_sms_title', 'backend', 'Plugin Base / Label / Two factor authentication title (SMS)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter the temporary password that was sent to you as SMS to login.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_send_password_to_email_subject', 'backend', 'Plugin Base / Options / Temporary password email subject', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email subject', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_send_password_to_email_message', 'backend', 'Plugin Base / Options / Temporary password email message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_secure_login_send_password_to_sms_message', 'backend', 'Plugin Base / Options / Temporary password SMS message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_disabled_login_form_text', 'backend', 'Plugin Base / Disabled login form text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The form is disabled because of too many failed login attempts. Please try again after {REMAINING_TIME}.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_admin_forgot', 'backend', 'Plugin Base / Forgot Password?', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot Password?', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_link_login', 'backend', 'Plugin Base / User login', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User login', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_email_subject', 'backend', 'Plugin Base / Options / Forgot password email subject', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email subject', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_email_message', 'backend', 'Plugin Base / Options / Forgot password email message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_sms_message', 'backend', 'Plugin Base / Options / Forgot password SMS message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_8', 'arrays', 'plugin_base_login_err_ARRAY_8', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The password reminder email has been sent successfully.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_9', 'arrays', 'plugin_base_login_err_ARRAY_9', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The password reminder SMS has been sent successfully.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_10', 'arrays', 'plugin_base_login_err_ARRAY_10', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password reminder failed to send!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_field_type', 'backend', 'Plugin Base / Field type', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Field type', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_type_backend', 'backend', 'Plugin Base / Back-end', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-end', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_type_frontend', 'backend', 'Plugin Base / Front-end', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_type_arrays', 'backend', 'Plugin Base / Special title (Array)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Special title (Array)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_type_script', 'backend', 'Plugin Base / Script', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Script', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_locale_type_plugin', 'backend', 'Plugin Base / Plugin', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Plugin', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_contact_admin_message', 'backend', 'Plugin Base / Options / Contact admin email message', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Contact admin email message', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_11', 'arrays', 'plugin_base_login_err_ARRAY_11', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your IP address was already blocked.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_12', 'arrays', 'plugin_base_login_err_ARRAY_12', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password SMS cannot be sent.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_13', 'arrays', 'plugin_base_login_err_ARRAY_13', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password SMS cannot be sent, user''s phone number is not added.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_14', 'arrays', 'plugin_base_login_err_ARRAY_14', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password SMS cannot be sent, SMS message is not added.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_google_maps_api_key', 'backend', 'Plugin Base / Options / Google Maps', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google Maps', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_google_maps_api_key_text', 'backend', 'Plugin Base / Options / Google Maps', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter your Google maps API key here in order for Google maps to work with your system. If you do not have such key <a href="https://developers.google.com/maps/documentation/javascript/get-api-key" target="_blank">get a key here.</a>', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_15', 'arrays', 'plugin_base_login_err_ARRAY_15', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email could not be sent.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_16', 'arrays', 'plugin_base_login_err_ARRAY_16', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email could not be sent because the email template is empty.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_17', 'arrays', 'plugin_base_login_err_ARRAY_17', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS could not be sent beause the SMS key is not set.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_18', 'arrays', 'plugin_base_login_err_ARRAY_18', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS could not be sent beause the SMS template is empty.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_19', 'arrays', 'plugin_base_login_err_ARRAY_19', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS could not be sent beause the phone number is missing.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_30', 'arrays', 'plugin_base_login_err_ARRAY_30', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS could not be sent.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_forgot_contact_admin_subject', 'backend', 'Plugin Base / Options / Contact admin email subject', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Contact admin email subject', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_btn_send_password_reminder', 'backend', 'Plugin Base / Label / Send Password Reminder', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Password Reminder', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_email', 'backend', 'Plugin Base / Options / Send notification to account owner', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send notification to account owner', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_failed_login_send_sms', 'backend', 'Plugin Base / Options / Send SMS to account owner', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS to account owner', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_create_backup_title', 'backend', 'Plugin Base / Label / Manually make a back-up', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Manually make a back-up', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_new_password', 'backend', 'Plugin Base / Label / New password', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New password', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_33', 'arrays', 'plugin_base_login_err_ARRAY_33', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing, empty or invalid URL parameters.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_32', 'arrays', 'plugin_base_login_err_ARRAY_32', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account not found.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_31', 'arrays', 'plugin_base_login_err_ARRAY_31', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid URL parameters.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_admin_reset_success', 'backend', 'Plugin Base / New password generated', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New password generated!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_captcha_desc_front', 'backend', 'Plugin Base / Infobox / Captcha description (front-end)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set options for the captcha used on the front-end.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_options_captcha_title_front', 'backend', 'Plugin Base / Infobox / Captcha (front-end)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha (Front-end)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_base_theme', 'backend', 'Plugin Base / Options / Color theme', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Color theme', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_sms_warning', 'backend', 'Plugin Base / Options / SMS warning', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please make sure you have set an SMS key. More details <a href="index.php?controller=pjBaseSms&action=pjActionIndex">here</a>.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_change_pswd_title', 'backend', 'Plugin Base / Infobox / Change password', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notice!', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_change_pswd_desc', 'backend', 'Plugin Base / Infobox / Change password', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Since you have not changed your password recently we recommend you to change your password.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_opt_o_sender_name', 'backend', 'Plugin Base / Options / Name ("From" header)', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name ("From" header)', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_captcha_reload', 'backend', 'Plugin Base / Captcha / Reload', 'plugin', '2018-06-11 10:40:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Can''t read the text? Click to reload.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_welcome', 'backend', 'Plugin Base / Login / Welcome', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Welcome back.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_welcome_prefix', 'backend', 'Plugin Base / Login / Welcome prefix', 'plugin', '2018-06-11 10:51:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Log in', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_welcome_suffix', 'backend', 'Plugin Base / Login / Welcome suffix', 'plugin', '2018-06-11 10:52:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'administration page', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'plugin_base_login_err_ARRAY_44', 'arrays', 'plugin_base_login_err_ARRAY_44', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha doesn''t match.', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_secure_login_send_password_to_email_message_text', 'backend', 'Plugin Base / Options / Temporary password email message text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class="col-xs-6">\r\n<p>{Name}</p>\r\n<p>{Email}</p>\r\n<p>{Phone}</p>\r\n<p>{Password}</p>\r\n</div>\r\n', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_secure_login_send_password_to_sms_message_text', 'backend', 'Plugin Base / Options / Temporary password SMS message text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class="col-xs-6">\r\n<p>{Name}</p>\r\n<p>{Email}</p>\r\n<p>{Phone}</p>\r\n<p>{Password}</p>\r\n</div>\r\n', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_failed_login_send_email_message_text', 'backend', 'Plugin Base / Options / Failed login email message text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class="col-xs-6">\r\n<p>{Name}</p>\r\n<p>{Email}</p>\r\n<p>{Phone}</p>\r\n</div>\r\n<div class="col-xs-6">\r\n<p>{LoginAttempts}</p>\r\n<p>{LoginAttemptsToLock}</p>\r\n</div>\r\n', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_failed_login_send_sms_message_text', 'backend', 'Plugin Base / Options / Failed login SMS message text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class="col-xs-6">\r\n<p>{Name}</p>\r\n<p>{Email}</p>\r\n<p>{Phone}</p>\r\n</div>\r\n<div class="col-xs-6">\r\n<p>{LoginAttempts}</p>\r\n<p>{LoginAttemptsToLock}</p>\r\n</div>\r\n', 'plugin');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_forgot_email_message_text', 'backend', 'Plugin Base / Options / Forgot password email message text', 'plugin', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<div class="col-xs-6"><p>{Name}</p><p>{Email}</p><p>{Phone}</p><p>{URL}</p></div>', 'plugin');
