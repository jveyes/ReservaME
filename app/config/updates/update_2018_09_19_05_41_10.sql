
START TRANSACTION;

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = "service_tip_length");
UPDATE `plugin_base_multi_lang` SET `content` = 'In Lenght field you can set the service lenght. In Before field set the break time before the service. In After field set a break time after the service. If you do not have break times before and after the service, leave these fields set to 0' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";


COMMIT;