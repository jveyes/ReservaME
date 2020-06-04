<?php
$show_locale_bar = 0;
if (isset($tpl['locale_arr']) && is_array($tpl['locale_arr']) && !empty($tpl['locale_arr']) && count($tpl['locale_arr']) > 1)
{
	$show_locale_bar = 1;
	
	$locale_id = $controller->pjActionGetLocale();
	$selected_title = null;
	$selected_src = NULL;
	foreach ($tpl['locale_arr'] as $locale)
	{
		if($locale_id == $locale['id'])
		{
			$selected_title = $locale['language_iso'];
			$lang_iso = explode("-", $selected_title);
			if(isset($lang_iso[1]))
			{
				$selected_title = $lang_iso[1];
			}
			if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
			{
				$selected_src = PJ_INSTALL_URL . $locale['flag'];
			} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
				$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
			}
			break;
		}
	}
	?>
	<div class="btn-group pull-right pjAsLanguage">
		<button type="button" class="btn dropdown-toggle pjAsBtnLanguageTrigger" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><?php echo $selected_title;?></button>
	
		<ul class="dropdown-menu">
			<?php
			foreach ($tpl['locale_arr'] as $locale)
			{ 
				$selected_src = NULL;
				if (!empty($locale['flag']) && is_file(PJ_INSTALL_PATH . $locale['flag']))
				{
					$selected_src = PJ_INSTALL_URL . $locale['flag'];
				} elseif (!empty($locale['file']) && is_file(PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'])) {
					$selected_src = PJ_INSTALL_URL . PJ_FRAMEWORK_LIBS_PATH . 'pj/img/flags/' . $locale['file'];
				}
				?>
				<li class="<?php echo $locale_id == $locale['id'] ? 'current' : NULL; ?>">
					<a href="#" class="asSelectorLocale" data-layout="<?php echo $controller->_get->toString('layout'); ?>" data-id="<?php echo $locale['id']; ?>"><?php echo pjSanitize::html($locale['name']); ?><img src="<?php echo $selected_src; ?>" alt=""></a>
				</li>
				<?php
			} 
			?>
		</ul><!-- /.dropdown-menu -->
	</div><!-- /.btn-group pull-right pjRbLaunguage -->
	<?php
} 
?>