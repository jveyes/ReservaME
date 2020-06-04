
START TRANSACTION;

INSERT INTO `options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_pending_time', 1, '30', NULL, 'int', 6, 1, NULL);

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_pending_time', 'backend', 'Options / Booking pending time', 'script', '2018-09-19 09:41:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking pending time', 'script');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'opt_o_pending_time_text', 'backend', 'Options / Booking pending time text', 'script', '2018-09-19 09:50:14');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'A period of time, while slots assigned to new bookings with Pending status will not be available for other bookings. ', 'script');

COMMIT;