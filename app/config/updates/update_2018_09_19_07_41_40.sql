
START TRANSACTION;

SET @id := (SELECT `id` FROM `plugin_base_fields` WHERE `key` = "error_bodies_ARRAY_ABK14");
UPDATE `plugin_base_multi_lang` SET `content` = 'You need to have at least one service.' WHERE `foreign_id` = @id AND `model` = "pjBaseField" AND `field` = "title";

COMMIT;