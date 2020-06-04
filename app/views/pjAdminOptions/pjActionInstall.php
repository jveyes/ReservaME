<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php __('lblInstallJs1_title'); ?></h2>
            </div>
        </div>

        <p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('lblInstallJs1_body'); ?></p>
    </div>
</div>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="tabs-container tabs-reservations m-b-lg">
       	<ul class="nav nav-tabs" role="tablist">
			<li role="presentation" class="active"><a href="#install" aria-controls="settings" role="tab" data-toggle="tab" aria-expanded="true"><?php __('menuInstall'); ?></a></li>
			<li role="presentation" class=""><a href="#seo" aria-controls="message-sent" role="tab" data-toggle="tab" aria-expanded="false"><?php __('menuSeo'); ?></a></li>
		</ul>

		<div class="tab-content">
			<div role="tabpanel" class="tab-pane active" id="install">
				<div class="panel-body">
					<form action="" method="get" class="form-horizontal">
						<?php if (count($tpl['menu_locale_arr']) > 1) : ?>
						<div class="row">
                            <div class="col-lg-8">
                                <div class="form-group">
                                    <label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallConfigLocale');?></label>

                                    <div class="col-lg-5 col-md-8">
                                        <select name="install_locale" id="install_locale" class="form-control">
                                            <option value="">-- <?php __('plugin_base_choose'); ?> --</option>
                                            <?php
                                            foreach ($tpl['menu_locale_arr'] as $locale)
                                            {
                                                ?><option value="<?php echo $locale['id']; ?>"><?php echo pjSanitize::html($locale['title']); ?></option><?php
                                            }
                                            ?>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallConfigHide');?></label>

                                    <div class="col-lg-5 col-md-8">
                                        <div class="clearfix">
                                            <div class="switch onoffswitch-data pull-left">
                                                <div class="onoffswitch">
                                                    <input type="checkbox" class="onoffswitch-checkbox" id="install_hide" name="install_hide">
                                                    <label class="onoffswitch-label" for="install_hide">
                                                        <span class="onoffswitch-inner" data-on="<?php __('plugin_base_yesno_ARRAY_T', false, true); ?>" data-off="<?php __('plugin_base_yesno_ARRAY_F', false, true); ?>"></span>
                                                        <span class="onoffswitch-switch"></span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php endif; ?>
                        
						<div class="row">
							<div class="col-lg-8">
								<div class="form-group">
									<label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallServicesProfessionals');?></label>
	
									<div class="col-lg-5 col-md-8">
										<select name="install_option" id="install_option" class="form-control">
											<?php
											foreach (__('install_opt', true) as $k => $v)
											{
												?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
											}
											?>
										</select>
									</div>
									<div class="col-lg-2 col-md-2">
									</div>
								</div>
							</div>
						</div>
	
						<div class="hr-line-dashed"></div>
						
						<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('lblInstallCode') ?></p>

						<div class="row">
							<div class="col-lg-8">
								<div class="form-group">
									<label class="col-lg-3 col-md-4 control-label"><?php __('lblInstallJs1_1');?></label>

									<div class="col-lg-9 col-md-8">
	<textarea class="form-control textarea_install" id="install_code" rows="8">
&lt;link href="<?php echo PJ_INSTALL_URL.PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'; ?>pj.bootstrap.min.css" type="text/css" rel="stylesheet" /&gt;
&lt;link href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionLoadCss" type="text/css" rel="stylesheet" /&gt;
&lt;script type="text/javascript" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionLoad"&gt;&lt;/script&gt;</textarea>
									</div>
                            	</div>
							</div>

							<div style="display:none" id="hidden_code">&lt;link href="<?php echo PJ_INSTALL_URL.PJ_FRAMEWORK_LIBS_PATH . 'pj/css/'; ?>pj.bootstrap.min.css" type="text/css" rel="stylesheet" /&gt;
&lt;link href="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionLoadCss" type="text/css" rel="stylesheet" /&gt;
&lt;script type="text/javascript" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&action=pjActionLoadJS"&gt;&lt;/script&gt;</div>
						</div>
					</form>
				</div>
			</div>
            
			<div role="tabpanel" class="tab-pane" id="seo">
				<div class="panel-body">
					<form action="" method="get" class="">
						<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AO30']; ?></p>
						<div class="form-group">
							<label class="control-label"><?php __('lblInstallSeo_1');?></label>

							<input type="text" id="uri_page" class="form-control" value="myPage.php" />
						</div>
						<div class="form-group">
							<label class="control-label"><?php __('lblInstallSeo_2');?></label>

							<textarea class="form-control textarea_install" style="overflow: auto; height:30px">
&lt;meta name="fragment" content="!"&gt;</textarea>
						</div>
						<div class="form-group">
							<label class="control-label"><?php __('lblInstallSeo_3');?></label>

							<textarea class="form-control textarea_install" id="install_htaccess" style="overflow: auto; height:80px">
RewriteEngine On
RewriteCond %{QUERY_STRING} _escaped_fragment_=(.*)
RewriteRule ^myPage.php <?php echo PJ_INSTALL_FOLDER; ?>index.php?controller=pjFrontPublic&action=pjActionRouter&_escaped_fragment_=%1 [L,NC]</textarea>

			<div style="display: none" id="hidden_htaccess">RewriteEngine On
RewriteCond %{QUERY_STRING} _escaped_fragment_=(.*)
RewriteRule ^::URI_PAGE:: <?php echo PJ_INSTALL_FOLDER; ?>index.php?controller=pjFrontPublic&action=pjActionRouter&_escaped_fragment_=%1 [L,NC]</div>
						</div>
						<div class="form-group">
							<label class="control-label"><?php __('lblInstallSeo_4');?></label>

							<textarea class="form-control textarea_install" id="install_htaccess_remote" style="overflow: auto; height:80px">
RewriteEngine On
RewriteCond %{QUERY_STRING} _escaped_fragment_=(.*)
RewriteRule ^myPage.php <?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontPublic&action=pjActionRouter&_escaped_fragment_=%1 [L,NC,R=302]</textarea>

			<div style="display: none" id="hidden_htaccess_remote">RewriteEngine On
RewriteCond %{QUERY_STRING} _escaped_fragment_=(.*)
RewriteRule ^::URI_PAGE:: <?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontPublic&action=pjActionRouter&_escaped_fragment_=%1 [L,NC,R=302]</div>
						</div>
					</form>
				</div>
			</div>
		</div>
    </div>
</div>