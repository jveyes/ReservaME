
START TRANSACTION;

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = 'infoServiceExample');
UPDATE `plugin_base_multi_lang` SET `content` = '"Before" and "After" are added to "Length" and together represent "Total minutes" of the service. The available slots are calculated based on "Total minutes" of the service.' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

COMMIT;