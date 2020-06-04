<?php
if(!empty($tpl['employee_arr']))
{
	foreach($tpl['employee_arr'] as $k => $employee)
	{
		if (!empty($employee['avatar']) && is_file($employee['avatar']))
		{
			$src = PJ_INSTALL_URL . $employee['avatar'];
		} else {
			$src = PJ_INSTALL_URL . PJ_IMG_PATH . 'frontend/professional.gif';
		}
		if ((int) $tpl['option_arr']['o_seo_url'] === 1)
		{
			$slug = sprintf("%s-%u.html", pjAppController::friendlyURL($employee['name']), $employee['id']);
		} else {
			$slug = NULL;
		}
		?>
		<li class="list-group-item pjAsListElement pjAsEmployee">
			<div class="row">
				<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
					<a href="#" class="pjAsEmployeeAppointment" data-iso="" data-eid="<?php echo $employee['id']; ?>" data-slug="<?php echo $slug;?>">
						<img src="<?php echo $src;?>" alt="" class="img-responsive center-block">
					</a>
				</div><!-- /.col-lg-3 col-md-3 col-sm-3 col-xs-12 -->
				<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">
					<h2 class="pjAsListElementTitle text-capitalize"><?php echo pjSanitize::html($employee['name']); ?></h2><!-- /.pjAsListElementTitle -->
					
					<h3 class="pjAsEmployeePosition text-capitalize"><?php echo pjSanitize::html($employee['services']); ?></h3><!-- /.pjAsEmployeePosition -->
					
					<p><?php echo nl2br(pjSanitize::html($employee['notes'])); ?></p>
					
					<a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsEmployeeAppointment" data-iso="" data-eid="<?php echo $employee['id']; ?>" data-slug="<?php echo $slug;?>"><?php __('front_make_appointment');?></a>
				</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-xs-12 -->
			</div><!-- /.row -->
		</li><!-- /.list-group-item pjAsListElement pjAsEmployee -->
		<?php
	}
}else{ 
	?>
	<li class="list-group-item pjAsListElement pjAsEmployee">
		<div class="row">
			<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"><?php __('front_no_employees_found');?></div>
		</div>
	</li>
	<?php
}  
?>