<?php
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$filter = __('filter', true, true);
$bodies = str_replace("{SIZE}", ini_get('post_max_size'), $bodies);
?>
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-sm-12">
        <div class="row">
            <div class="col-sm-10">
                <h2><?php echo @$titles['AS11']; ; ?></h2>
            </div>
        </div><!-- /.row -->

        <p class="m-b-none"><i class="fa fa-info-circle"></i> <?php echo @$bodies['AS11'];?></p>
    </div><!-- /.col-md-12 -->
</div>

<div class="wrapper wrapper-content animated fadeInRight">
	<?php
	$error_code = $controller->_get->toString('err');
	if (!empty($error_code))
    {
    	switch (true)
    	{
    		case in_array($error_code, array('AS01', 'AS03')):
    			?>
    			<div class="alert alert-success">
    				<i class="fa fa-check m-r-xs"></i>
    				<strong><?php echo @$titles[$error_code]; ?></strong>
    				<?php echo @$bodies[$error_code]; ?>
    			</div>
    			<?php 
    			break;
            case in_array($error_code, array('AS04', 'AS08', 'AS12', 'AS13', 'AS14', 'AS15')):	
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
                            <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminServices&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus"></i> <?php __('btnAddService');?></a>
                            <?php 
                        }
                        ?>
                        </div><!-- /.col-md-6 -->
    
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
                                <button type="button" class="btn btn-default btn-filter" data-column="is_active" data-value="1"><i class="fa fa-check"></i> <?php echo $filter['active']; ?></button>
                                <button type="button" class="btn btn-default btn-filter" data-column="is_active" data-value="0"><i class="fa fa-times"></i> <?php echo $filter['inactive']; ?></button>
                            </div>
                        </div>
                    </div>
                    <div id="grid"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
var pjGrid = pjGrid || {};
var myLabel = myLabel || {};
myLabel.name = "<?php __('service_name', false, true); ?>";
myLabel.price = "<?php __('service_price', false, true); ?>";
myLabel.len = "<?php __('service_service_length', false, true); ?>";
myLabel.total = "<?php __('service_total_minutes', false, true); ?>";
myLabel.employees = "<?php __('service_employees', false, true); ?>";
myLabel.status = "<?php __('service_status', false, true); ?>";
myLabel.active = "<?php echo $filter['active']; ?>";
myLabel.inactive = "<?php echo $filter['inactive']; ?>";
myLabel.delete_selected = "<?php __('delete_selected', false, true); ?>";
myLabel.delete_confirmation = "<?php __('delete_confirmation', false, true); ?>";
myLabel.has_update = <?php echo (int) $tpl['has_update']; ?>;
myLabel.has_delete = <?php echo (int) $tpl['has_delete']; ?>;
myLabel.has_delete_bulk = <?php echo (int) $tpl['has_delete_bulk']; ?>;
</script>