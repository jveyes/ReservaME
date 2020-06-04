<div class="panel-heading pjAsHead">
	<img src="https://citas.jmvb.co/wp-content/uploads/2020/05/SuLogotipo.png" alt="" class="img-responsive center-block">
</div><!-- /.panel-heading pjAsHead -->

<?php
$acceptBookings = (int) $tpl['option_arr']['o_accept_bookings'] === 1;
list($n, $j) = explode("-", date("n-j", strtotime($controller->_get->toString('date'))));
$months = __('months', true);
$suffix = __('front_day_suffix', true);
$cart = $controller->cart->getAll();
?>

<div class="container-fluid">
	<div class="row">
		<div class="col-lg-12 text-right">
			<?php include PJ_VIEWS_PATH . 'pjFrontEnd/elements/locale.php';?>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
			<div class="panel panel-default pjAsContainer pjAsAside">
				<div class="panel-heading pjAsHead">
					<h2 class="pjAsHeadTitle"><?php __('front_select_date'); ?></h2><!-- /.pjAsHeadTitle -->
				</div><!-- /.panel-heading pjAsHead -->

				<div class="panel-body pjAsCalendarInline">
					<?php include PJ_VIEWS_PATH . 'pjFrontEnd/elements/calendar.php'; ?>
				</div><!-- /.panel-body pjAsCalendarInline -->

				<ul class="list-group pjAsAsideServices">
					<?php
					$cart = $controller->cart->getAll();
					$cart_arr = $tpl['cart_arr'];
					include PJ_VIEWS_PATH . 'pjFrontPublic/elements/cart_layout2.php';
					?>
				</ul><!-- /.list-group pjAsAsideServices -->
			</div><!-- /.panel panel-default pjAsContainer pjAsAside -->
		</div><!-- /.col-lg-4 col-md-4 col-sm-4 col-xs-12 -->
		<div id="pjAsEmployeesWrapper" class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
			<div class="panel panel-default pjAsContainer">
				<?php include PJ_VIEWS_PATH . 'pjFrontPublic/elements/header.php';?>
				
				<ul class="list-group pjAsListElements pjAsEmployees">
					<?php
					if(!empty($tpl['employee_arr']))
					{
						list($year, $month, $day) = explode("-", $controller->_get->toString('date'));
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
								$slug = sprintf("%s/%s/%s/%s/%s-%u.html", 'Employee', $year, $month, $day, $controller->friendlyURL($employee['name']), $employee['id']);
							} else {
								$slug = NULL;
							}							
							?>
							<li class="list-group-item pjAsListElement pjAsEmployee">
								<div class="row">
									<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
										<a href="#" class="pjAsEmployeeAppointment" data-iso="<?php echo $controller->_get->toString('date'); ?>" data-eid="<?php echo $employee['id']; ?>" data-slug="<?php echo $slug;?>">
											<img src="<?php echo $src;?>" alt="" class="img-responsive center-block">
										</a>
									</div><!-- /.col-lg-3 col-md-3 col-sm-3 col-xs-12 -->
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">
										<h2 class="pjAsListElementTitle text-capitalize"><?php echo pjSanitize::html($employee['name']); ?></h2><!-- /.pjAsListElementTitle -->
										
										<h3 class="pjAsEmployeePosition text-capitalize"><?php echo pjSanitize::html($employee['services']); ?></h3><!-- /.pjAsEmployeePosition -->
										
										<p><?php echo nl2br(pjSanitize::html($employee['notes'])); ?></p>
										<?php
										if(!empty($employee['services']) && !isset($tpl['unavailable'])) 
										{
											?>
											<a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsEmployeeAppointment" data-iso="<?php echo $controller->_get->toString('date'); ?>" data-eid="<?php echo $employee['id']; ?>" data-slug="<?php echo $slug;?>"><?php __('front_make_appointment');?></a>
											<?php
										} 
										?>
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
				</ul><!-- /.list-group pjAsListElements pjAsEmployees -->
						
			</div><!-- /.panel panel-default pjAsContainer -->
		</div><!-- /.col-lg-8 col-md-8 col-sm-8 col-xs-12 -->
	</div>
</div><!-- /.container-fluid -->