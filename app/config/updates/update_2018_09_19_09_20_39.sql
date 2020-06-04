
START TRANSACTION;

INSERT INTO `plugin_base_fields` VALUES (NULL, 'menuExport', 'backend', 'Menu Export', 'script', '2018-09-19 07:20:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

COMMIT;