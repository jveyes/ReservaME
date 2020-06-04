
START TRANSACTION;

INSERT INTO `plugin_base_fields` VALUES (NULL, 'service_service_length', 'backend', 'Services / Service length', 'script', '2018-09-18 09:30:32');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Service length', 'script');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'service_total_minutes', 'backend', 'Services / Total minutes', 'script', '2018-09-18 09:31:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total minutes', 'script');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'service_minutes_unit', 'backend', 'Services / minutes', 'script', '2018-09-18 09:40:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'minutes', 'script');

INSERT INTO `plugin_base_fields` VALUES (NULL, 'service_hours_unit', 'backend', 'Services / hours', 'script', '2018-09-18 09:40:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hours', 'script');

COMMIT;