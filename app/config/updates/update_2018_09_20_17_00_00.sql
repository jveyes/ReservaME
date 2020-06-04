
START TRANSACTION;

SET @id := (SELECT `id` FROM `fields` WHERE `key` = "opt_o_thankyou_page");
UPDATE `multi_lang` SET `content` = 'URL for the web page where your clients will be redirected after online payment' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

COMMIT;