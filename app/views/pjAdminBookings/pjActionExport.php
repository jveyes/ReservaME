<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);

$export_formats = __('export_formats', true, false);
$export_types = __('export_types', true, false);
$export_periods = __('export_periods', true, false);
?>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php echo @$titles['AR21']; ?></h2>
			</div>
		</div>
		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php echo @$bodies['AR21']; ?></p>
	</div>
</div>

<div class="row wrapper wrapper-content animated fadeInRight">
	<div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
            	<form action="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionExport" method="post" class="form-horizontal" id="frmExportBookings">
            		<input type="hidden" name="bookings_export" value="1" />
            		<div class="form-group">
            			<label class="col-sm-3 control-label"><?php __('lblFormat'); ?></label>
            			<div class="col-lg-5 col-sm-7">
            				<div class="row">
                            	<div class="col-sm-6">
                        			<select name="format" id="format" class="form-control">
                    					<?php
                    					foreach ($export_formats as $k => $v)
                    					{
                    					    ?><option value="<?php echo $k; ?>"<?php echo $controller->_post->check('format') && $controller->_post->toString('format') == $k ? ' selected="selected"' : null; ?>><?php echo pjSanitize::html($v); ?></option><?php
                    					}
                    					?>
                    				</select>
                    			</div>
                    		</div>
            			</div>
            		</div><!-- /.form-group -->
            		<div class="form-group">
            			<label class="col-sm-3 control-label"><?php __('lblType'); ?></label>
            			<div class="col-lg-5 col-sm-7">
            				<div class="row">
                            	<div class="col-sm-6">
                            		<div class="radio radio-inline">
                                      	<input type="radio" id="file"  name="type" value="file"<?php echo $controller->_post->check('type') ? ($controller->_post->toString('type') == 'file' ? ' checked="checked"' : null) : ' checked="checked"'; ?>/>
                        				<label for="file"><?php echo $export_types['file'];?></label>
                                    </div>
                                    <div class="radio radio-inline">
                                      	<input type="radio" id="feed" name="type" value="feed"<?php echo $controller->_post->check('type') ? ($controller->_post->toString('type') == 'feed' ? ' checked="checked"' : null) : null; ?>/>
                                    	<label for="feed"><?php echo $export_types['feed'];?></label>
                                    </div>
                    			</div>
                    		</div>
            			</div>
            		</div><!-- /.form-group -->
            		<div class="form-group tsPassowrdContainer" style="display:<?php echo $controller->_post->check('type') ? ($controller->_post->toString('type') == 'file' ? ' none' : ' block' ) : ' none'; ?>">
            			<label class="col-sm-3 control-label"><?php __('lblEnterPassword'); ?></label>
            			<div class="col-lg-5 col-sm-7">
            				<div class="row">
                            	<div class="col-sm-6">
                        			<input type="text" id="feed_password" name="password" class="form-control" value="<?php echo $controller->_post->check('password') ? $controller->_post->toString('password') : null; ?>"/>
                    			</div>
                    		</div>
            			</div>
            		</div><!-- /.form-group -->
            		<div class="form-group">
            			<label class="col-sm-3 control-label"><?php __('lblBookings'); ?></label>
            			<div class="col-lg-5 col-sm-7">
            				<div class="row">
                            	<div class="col-sm-6">
                        			<select name="period" id="export_period" class="form-control">
                						<option value="next"<?php echo $controller->_post->check('period') ? ($controller->_post->toString('period') == 'next' ? ' selected="selected"' : null) : ' selected="selected"'; ?>><?php echo pjSanitize::html($export_periods['next']); ?></option>
                						<option value="last"<?php echo $controller->_post->check('period') ? ($controller->_post->toString('period') == 'last' ? ' selected="selected"' : null) : null; ?>><?php echo pjSanitize::html($export_periods['last']); ?></option>
                					</select>
                    			</div>
                    			<div id="next_label" class="col-sm-6" style="display:<?php echo $controller->_post->check('period') ? ($controller->_post->toString('period') == 'next' ? ' block' : ' none') : ' block'; ?>;">
                    				<select name="coming_period" id="coming_period" class="form-control">
                						<?php
                						foreach(__('coming_arr', true) as $k => $v)
                						{
                						    ?><option value="<?php echo $k;?>"<?php echo $controller->_post->check('coming_period') ? ($controller->_post->toString('coming_period') == $k ? ' selected="selected"' : null) : null; ?>><?php echo $v;?></option><?php 
                						} 
                						?>
                					</select>
                    			</div>
                    			<div id="last_label" class="col-sm-6" style="display:<?php echo $controller->_post->check('period') ? ($controller->_post->toString('period') == 'last' ? ' block' : ' none') : ' none'; ?>;">
                    				<select name="made_period" id="made_period" class="form-control">
                						<?php
                						foreach(__('made_arr', true) as $k => $v)
                						{
                						    ?><option value="<?php echo $k;?>"<?php echo $controller->_post->check('made_period') ? ($controller->_post->toString('made_period') == $k ? ' selected="selected"' : null) : null; ?>><?php echo $v;?></option><?php 
                						} 
                						?>
                					</select>
                    			</div>
                    		</div>
            			</div>
            		</div><!-- /.form-group -->
            		<?php
            		if($controller->_post->check('type') && $controller->_post->toString('type') == 'feed')
            		{
            		    ?>
            		    <div class="form-group tsFeedContainer">
                			<label class="col-sm-3 control-label">&nbsp;</label>
                			<div class="col-lg-5 col-sm-7">
                				<p class="alert alert-info alert-with-icon m-t-xs"><i class="fa fa-info-circle"></i> <?php __('infoBookingFeedDesc', false, true);?></p>
                				<textarea id="bookings_feed" name="bookings_feed" class="form-control" rows="5"><?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFront&amp;action=pjActionExportFeed&amp;format=<?php echo $controller->_post->toString('format'); ?>&amp;type=<?php echo $controller->_post->toString('period') == 'next' ? '1' : '2'; ?>&amp;period=<?php echo $controller->_post->toString('period') == 'next' ? $controller->_post->toString('coming_period') : $controller->_post->toString('made_period'); ?>&amp;p=<?php echo isset($tpl['password']) ? $tpl['password'] : null;?></textarea>
                			</div>
                		</div><!-- /.form-group -->
            		    <?php
            		}
            		?>
            		<div class="hr-line-dashed"></div>
					
                    <div class="clearfix">
                        <button class="ladda-button btn btn-primary btn-lg pull-left btn-phpjabbers-loader" data-style="zoom-in">
                            <span id="tsSubmitButton" class="ladda-label"><?php $controller->_post->check('type') ? ($controller->_post->toString('type') == 'file' ? __('btnExport') : __('btnGetFeedURL') ) :  __('btnExport'); ?></span>
                            <?php include $controller->getConstant('pjBase', 'PLUGIN_VIEWS_PATH') . 'pjLayouts/elements/button-animation.php'; ?>
                        </button>
                    </div>
            	</form>
            </div><!-- /.ibox-content -->
       	</div><!-- /.ibox float-e-margins -->
    </div><!-- /.ibox float-e-margins -->
</div><!-- /.row wrapper wrapper-content animated fadeInRight -->

<script type="text/javascript">
var myLabel = myLabel || {};
myLabel.btn_export = "<?php __('btnExport'); ?>";
myLabel.btn_get_url = "<?php __('btnGetFeedURL'); ?>";
</script>