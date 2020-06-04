
START TRANSACTION;

INSERT INTO `plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABK17', 'arrays', 'error_bodies_ARRAY_ABK17', 'script', '2018-09-19 04:20:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are not any available employees.', 'script');

COMMIT;