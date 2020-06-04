<?php
if (isset($tpl['status']))
{
	$status = __('status', true);
	switch ($tpl['status'])
	{
		case 2:
			pjUtil::printNotice(NULL, $status[2]);
			break;
	}
} else {
	$titles = __('error_titles', true);
	$bodies = __('error_bodies', true);
	$filter = __('filter', true, true);
	$bodies = str_replace("{SIZE}", ini_get('post_max_size'), $bodies);
	?>
	<div class="row wrapper border-bottom white-bg page-heading">
	    <div class="col-sm-12">
	        <div class="row">
	            <div class="col-sm-10">
	                <h2><?php echo @$titles['AE11']; ; ?></h2>
	            </div>
	        </div><!-- /.row -->
	
	        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AE11'];?></p>
	    </div><!-- /.col-md-12 -->
	</div>
	
	<div class="wrapper wrapper-content animated fadeInRight">
		<?php
		$error_code = $controller->_get->toString('err');
		if (!empty($error_code))
	    {
	    	switch (true)
	    	{
	    		case in_array($error_code, array('AE01', 'AE03')):
	    			?>
	    			<div class="alert alert-success">
	    				<i class="fa fa-check m-r-xs"></i>
	    				<strong><?php echo @$titles[$error_code]; ?></strong>
	    				<?php echo @$bodies[$error_code]; ?>
	    			</div>
	    			<?php 
	    			break;
	            case in_array($error_code, array('AE04', 'AE08', 'AE12', 'AE13', 'AE14', 'AE15')):	
	    			?>
	    			<div class="alert alert-danger">
	    				<i class="fa fa-exclamation-triangle m-r-xs"></i>
	    				<strong><?php echo @$titles[$error_code]; ?></strong>
	    				<?php echo @$bodies[$error_code]; ?>
	    			</div>
	    			<?php
	    			break;
	    	}
	    }
	    ?>
	    <div class="row">
	        <div class="col-lg-12">
	            <div class="ibox float-e-margins">
	                <div class="ibox-content">
	                    <div class="row m-b-md">
	                        <div class="col-md-4 col-sm-4">
	                        <?php 
	                        if ($tpl['has_create'])
	                        {
	                        	?>
	                            <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus"></i> <?php __('btnAddEmployee');?></a>
	                            <?php 
	                        }
	                        ?>
	                        </div>
	    
	                        <div class="col-md-4 col-sm-8">
	                        	<form action="" method="get" class="form-horizontal frm-filter">
									<div class="input-group">
										<input type="text" name="q" placeholder="<?php __('btnSearch', false, true); ?>" class="form-control">
										<div class="input-group-btn">
											<button class="btn btn-primary" type="submit">
												<i class="fa fa-search"></i>
											</button>
										</div>
									</div>
								</form>
	                        </div><!-- /.col-md-3 -->
	    
	                        <div class="col-md-4 text-right">
	                            <div class="btn-group" role="group" aria-label="...">
	                                <button type="button" class="btn btn-primary btn-all active"><?php __('lblAll');?></button>
	                                <button type="button" class="btn btn-default btn-filter" data-column="is_active" data-value="T"><i class="fa fa-check"></i> <?php echo $filter['active']; ?></button>
	                                <button type="button" class="btn btn-default btn-filter" data-column="is_active" data-value="F"><i class="fa fa-times"></i> <?php echo $filter['inactive']; ?></button>
	                            </div>
	                        </div><!-- /.col-md-6 -->
	                    </div>
	    
	                    <div id="grid"></div>
	                    
	                </div>
	            </div>
	        </div><!-- /.col-lg-12 -->
	    </div><!-- /.row -->
	</div>
	
	<script type="text/javascript">
	var pjGrid = pjGrid || {};
	pjGrid.queryString = "";
	<?php
	if ($controller->_get->toInt('service_id'))
	{
	    ?>pjGrid.queryString += "&service_id=<?php echo $controller->_get->toInt('service_id'); ?>";<?php
	}
	?>
	var myLabel = myLabel || {};
	myLabel.menu = "<?php __('menu', false, true); ?>";
	myLabel.view_bookings = "<?php __('employee_view_bookings', false, true); ?>";
	myLabel.working_time = "<?php __('employee_working_time', false, true); ?>";
	myLabel.name = "<?php __('employee_name', false, true); ?>";
	myLabel.emailphone = "<?php __('lblEmailPhone', false, true); ?>";
	myLabel.phone = "<?php __('employee_phone', false, true); ?>";
	myLabel.services = "<?php __('employee_services', false, true); ?>";
	myLabel.avatar = "<?php __('employee_avatar', false, true); ?>";
	myLabel.status = "<?php __('employee_status', false, true); ?>";
	myLabel.active = "<?php echo $filter['active']; ?>";
	myLabel.inactive = "<?php echo $filter['inactive']; ?>";
	myLabel.delete_selected = "<?php __('delete_selected', false, true); ?>";
	myLabel.delete_confirmation = "<?php __('delete_confirmation', false, true); ?>";
	myLabel.has_update = <?php echo (int) $tpl['has_update']; ?>;
	myLabel.has_delete = <?php echo (int) $tpl['has_delete']; ?>;
	myLabel.has_delete_bulk = <?php echo (int) $tpl['has_delete_bulk']; ?>;
	</script>
	<?php
}
?>