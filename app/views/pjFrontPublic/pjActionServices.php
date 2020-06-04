<div class="panel-heading pjAsHead">
	<img src="https://citas.jmvb.co/wp-content/uploads/2020/05/SuLogotipo.png" alt="" class="img-responsive center-block">
</div><!-- /.panel-heading pjAsHead -->

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

		<div id="pjAsServicesWrapper" class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
			<div class="panel panel-default pjAsContainer">
				<?php include PJ_VIEWS_PATH . 'pjFrontPublic/elements/header.php';?>
				
				<ul class="list-group pjAsListElements pjAsServices">
					<?php
					if(!empty($tpl['service_arr']))
					{
						list($year, $month, $day) = explode("-", $controller->_get->toString('date'));
						foreach($tpl['service_arr'] as $service)
						{
							if ((int) $tpl['option_arr']['o_seo_url'] === 1)
							{
								$slug = sprintf("%s/%s/%s/%s/%s-%u.html", 'Service', $year, $month, $day, $controller->friendlyURL($service['name']), $service['id']);
							} else {
								$slug = NULL;
							}
							if (isset($service['image']) && is_file($service['image']))
							{
								$src = PJ_INSTALL_URL . $service['image'];
							} else {
								$src = PJ_INSTALL_URL . PJ_IMG_PATH . 'frontend/service.gif';
							}
							?>
							<li class="list-group-item pjAsListElement pjAsService">
								<div class="row">
									<div class="col-lg-3 col-md-3 col-sm-3 col-xs-12">
										<a href="#" class="pjAsServiceAppointment" data-iso="<?php echo $controller->_get->toString('date'); ?>" data-id="<?php echo $service['id'];?>" data-slug="<?php echo $slug;?>">
											<img src="<?php echo $src;?>" alt="" class="img-responsive center-block">
										</a>
									</div><!-- /.col-lg-3 col-md-3 col-sm-3 col-xs-12 -->
									<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">
										<h2 class="pjAsListElementTitle text-capitalize"><?php echo pjSanitize::html($service['name']); ?></h2><!-- /.pjAsListElementTitle -->
			
										<ul class="list-unstyled pjAsServiceMeta">
											<li>
												<dl class="dl-horizontal">
													<dt class="text-capitalize"><?php __('single_price');?>: </dt>
													<dd class="text-capitalize"><?php echo pjCurrency::formatPrice($service['price']); ?></dd>
												</dl><!-- /.dl-horizontal -->
											</li>
			
											<li>
												<dl class="dl-horizontal">
													<dt class="text-capitalize"><?php __('front_duration');?>: </dt>
													<dd><?php echo $service['length']; ?> <?php __('front_minutes'); ?></dd>
												</dl><!-- /.dl-horizontal -->
											</li>
										</ul><!-- /.list-unstyled pjAsServiceMeta -->
			
										<p><?php echo nl2br(pjSanitize::html($service['description'])); ?></p>
										<?php
										if(isset($tpl['service_id_arr'][$service['id']]) && !isset($tpl['unavailable']))
										{
											?><a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsServiceAppointment" data-iso="<?php echo $controller->_get->toString('date'); ?>" data-id="<?php echo $service['id'];?>" data-slug="<?php echo $slug;?>"><?php __('front_make_appointment');?></a><?php
										} 
										?>
									</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
								</div><!-- /.row -->
							</li><!-- /.list-group-item pjAsListElement pjAsService -->
							<?php
						}
					} else {
						?>
						<li class="list-group-item pjAsListElement pjAsService">
							<div class="row">
								<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12"><?php __('front_no_services_found');?></div>
							</div>
						</li>
						<?php
					}
					?>
				</ul><!-- /.list-group pjAsListElements pjAsEmployees -->
						
			</div><!-- /.panel panel-default pjAsContainer -->
		</div><!-- /.col-lg-8 col-md-8 col-sm-8 col-xs-12 -->
	</div><!-- /.row -->
</div><!-- /.container-fluid -->