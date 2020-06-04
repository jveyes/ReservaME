
START TRANSACTION;

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = "service_tip_length");
UPDATE `plugin_base_multi_lang` SET `content` = 'Set the time required to complete this service.' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = "service_tip_before");
UPDATE `plugin_base_multi_lang` SET `content` = 'Set the time you need to block before booking start time for this service.' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = "service_tip_after");
UPDATE `plugin_base_multi_lang` SET `content` = 'Set the time you need to block after booking end time for this service.' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

INSERT INTO `plugin_base_fields` VALUES (NULL, 'infoServiceExample', 'backend', 'Infobox / Service example', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Example: Set Length 30 minutes; Before 10 minutes; After 20 minutes. If you are available from 8am then first booking will be possible at 8:10am and the next will be at 9am (8am + 10 minutes blocked before the booking + 30 minutes service time + 20 minutes blocked after the booking)', 'script');

COMMIT;