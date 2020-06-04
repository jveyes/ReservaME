<div class="form-group">
    <label class="control-label col-lg-4"><?php __('plugin_authorize_allow'); ?></label>

    <div class="col-lg-8">
        <div class="switch m-t-xs">
            <div class="onoffswitch onoffswitch-data">
                <input id="payment_is_active" name="plugin_payment_options[authorize][is_active]" value="<?php echo @$tpl['arr']['is_active'];?>"  type="hidden" />
                <input class="onoffswitch-checkbox" id="enablePayment" name="enablePayment" type="checkbox"<?php echo @$tpl['arr']['is_active'] == '1' ? ' checked="checked"' : NULL; ?>>
                <label class="onoffswitch-label" for="enablePayment">
                    <span class="onoffswitch-inner" data-on="<?php __('plugin_authorize_yesno_ARRAY_T', false, true);?>" data-off="<?php __('plugin_authorize_yesno_ARRAY_F', false, true);?>"></span>
                    <span class="onoffswitch-switch"></span>
                </label>
            </div>
        </div>
    </div>
</div>

<div class="hidden-area" style="display: <?php echo $tpl['arr']['is_active'] == '1' ? 'block' : 'none'; ?>">
<?php
if (defined("PJ_WEBSITE_VERSION"))
{
	?>
	<div class="form-group">
		<label class="control-label col-lg-4"><?php __('plugin_authorize_payment_label'); ?></label>
		<div class="col-lg-8">
			<div class="i18n-group">
			<?php
			foreach ($tpl['lp_arr'] as $v)
			{
				?>
				<input 
					type="text" 
					class="form-control i18n-control<?php echo $v['id'] != @$tpl['locale_id'] ? ' hidden' : NULL; ?><?php echo $v['is_default'] ? ' required' : NULL; ?>"
					data-id="<?php echo $v['id']; ?>"
					data-iso="<?php echo $v['language_iso']; ?>" 
					name="i18n[<?php echo $v['id']; ?>][authorize]" 
					value="<?php echo pjSanitize::html(@$tpl['i18n'][$v['id']]['authorize']); ?>">
				<?php
			}
			?>
			</div>
		</div>
	</div>
    <?php
} else {
    foreach ($tpl['lp_arr'] as $v)
    {
        ?>
        <div class="form-group pj-multilang-wrap" data-index="<?php echo $v['id']; ?>" style="display: <?php echo (int) $v['is_default'] === 1 ? 'block' : 'none'; ?>">
            <label class="control-label col-lg-4"><?php __('plugin_authorize_payment_label'); ?></label>
            <div class="col-lg-8">
                <div class="input-group">
                    <input type="text" class="form-control" name="i18n[<?php echo $v['id']; ?>][authorize]" value="<?php echo pjSanitize::html(@$tpl['i18n'][$v['id']]['authorize']); ?>">
                    <?php if ($tpl['is_flag_ready']) : ?>
                    <span class="input-group-addon pj-multilang-input"><img src="<?php echo PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $v['file']; ?>" alt="<?php echo pjSanitize::html($v['name']); ?>"></span>
                    <?php endif; ?>
                </div>
            </div>
        </div>
        <?php
    }
}
?>
</div>
<div class="form-group hidden-area" style="display: <?php echo $tpl['arr']['is_active'] == '1' ? 'block' : 'none'; ?>">
    <label class="control-label col-lg-4"><?php __('plugin_authorize_merchant_id'); ?></label>

    <div class="col-lg-8">
        <input type="text" name="plugin_payment_options[authorize][merchant_id]" value="<?php echo pjSanitize::html(@$tpl['arr']['merchant_id']); ?>" class="form-control required">
        <p class="small"><?php __('plugin_authorize_merchant_id_text'); ?></p>
    </div>
</div>
<div class="form-group hidden-area" style="display: <?php echo $tpl['arr']['is_active'] == '1' ? 'block' : 'none'; ?>">
    <label class="control-label col-lg-4"><?php __('plugin_authorize_public_key'); ?></label>

    <div class="col-lg-8">
        <input type="text" name="plugin_payment_options[authorize][public_key]" value="<?php echo pjSanitize::html(@$tpl['arr']['public_key']); ?>" class="form-control required">
        <p class="small"><?php __('plugin_authorize_public_key_text'); ?></p>
    </div>
</div>
<div class="form-group hidden-area" style="display: <?php echo $tpl['arr']['is_active'] == '1' ? 'block' : 'none'; ?>">
    <label class="control-label col-lg-4"><?php __('plugin_authorize_private_key'); ?></label>

    <div class="col-lg-8">
        <input type="text" name="plugin_payment_options[authorize][private_key]" value="<?php echo pjSanitize::html(@$tpl['arr']['private_key']); ?>" class="form-control required">
        <p class="small"><?php __('plugin_authorize_private_key_text'); ?></p>
    </div>
</div>
<div class="form-group hidden-area" style="display: <?php echo $tpl['arr']['is_active'] == '1' ? 'block' : 'none'; ?>">
    <label class="control-label col-lg-4"><?php __('plugin_authorize_tz'); ?></label>

    <div class="col-lg-8">
        <select name="plugin_payment_options[authorize][tz]" class="form-control required">
            <?php
            $locations = array();
            $zones = timezone_identifiers_list();
            foreach ($zones as $zone_name)
            {
                $zone = explode('/', $zone_name);
                if ($zone[0] == 'Africa' || $zone[0] == 'America' || $zone[0] == 'Antarctica' || $zone[0] == 'Arctic' || $zone[0] == 'Asia' || $zone[0] == 'Atlantic' || $zone[0] == 'Australia' || $zone[0] == 'Europe' || $zone[0] == 'Indian' || $zone[0] == 'Pacific')
                {
                    if (isset($zone[1]) != '')
                    {
                        $locations[$zone[0]][$zone[0]. '/' . $zone[1]] = str_replace('_', ' ', $zone[1]) . ' (UTC' . pjTimezone::getTimezoneOffset($zone_name) . ')';
                    }
                }
            }

            foreach($locations as $continent => $cities)
            {
                ?>
                <optgroup label="<?php echo pjSanitize::html($continent);?>">
                    <?php
                    foreach($cities as $pair => $city)
                    {
                        ?>
                        <option value="<?php echo $pair;?>"<?php echo $pair == $tpl['arr']['tz'] ? ' selected="selected"' : NULL;?>><?php echo $city;?></option>
                        <?php
                    }
                    ?>
                </optgroup>
                <?php
            }
            ?>
        </select>
        <p class="small"><?php __('plugin_authorize_tz_text'); ?></p>
    </div>
</div>