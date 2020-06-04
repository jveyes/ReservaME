
START TRANSACTION;

SET @id := (SELECT `id` FROM `fields` WHERE `key` = "opt_o_email_body_text");
UPDATE `multi_lang` SET `content` = '<div class="col-xs-6">
<div><small>{Name}</small></div>
<div><small>{Phone}</small></div>
<div><small>{Email}</small></div>
<div><small>{Notes}</small></div>
<div><small>{Address1}</small></div>
<div><small>{Address2}</small></div>
<div><small>{City}</small></div>
<div><small>{State}</small></div>
<div><small>{Zip}</small></div>
<div><small>{Country}</small></div>

</div>
<div class="col-xs-6">
<div><small>{BookingID}</small></div>
<div><small>{Services}</small></div>
<div><small>{PaymentMethod}</small></div>
<div><small>{Price}</small></div>
<div><small>{Deposit}</small></div>
<div><small>{Tax}</small></div>
<div><small>{Total}</small></div>
<div><small>{CancelURL}</small></div>
 </div>
' WHERE `foreign_id` = @id AND `model` = "pjField" AND `field` = "title";

COMMIT;