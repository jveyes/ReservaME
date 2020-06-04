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
		<div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
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
		</div><!-- /.col-lg-4 col-md-4 col-sm-12 col-xs-12 -->
		<div class="col-lg-8 col-md-8 col-sm-12 col-xs-12">
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
							<li id="pjAsEmployeeWrapper_<?php echo $employee['id'];?>" class="list-group-item pjAsListElement pjAsEmployee">
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
										if((!$controller->_get->check('employee_id') || ($controller->_get->check('employee_id') && $employee['id'] != $controller->_get->toInt('employee_id'))) && !isset($tpl['unavailable']))
										{ 
											?>
											<a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsEmployeeAppointment" data-iso="<?php echo $controller->_get->toString('date'); ?>" data-eid="<?php echo $employee['id']; ?>" data-slug="<?php echo $slug;?>"><?php __('front_make_appointment');?></a>
											<?php
										} 
										?>
									</div><!-- /.col-lg-9 col-md-9 col-sm-9 col-xs-12 -->
								</div><!-- /.row -->
								<?php
								if(!isset($tpl['unavailable']))
								{
									if($controller->_get->check('employee_id') && $employee['id'] == $controller->_get->toInt('employee_id'))
									{
										list($year, $month, $day) = explode("-", $controller->_get->toString('date'));
										if(!empty($tpl['service_arr']))
										{ 
											if ((int) $tpl['option_arr']['o_seo_url'] === 1)
											{
												$slug = sprintf("%s/%s/%s/%s/%s-%u.html", 'Employee', $year, $month, $day, $controller->friendlyURL($employee['name']), $employee['id']);
											} else {
												$slug = NULL;
											}
											
											$in_cart = false;
											$cell = array();
											$time_table = '';
											$key_in_cart = null;
											if(isset($tpl['service']))
											{
												include PJ_VIEWS_PATH . 'pjFrontEnd/elements/time.php';
											}
											?>
											<div class="form-horizontal asEmployeeInfo">
												<form class="pjAsAddToCartForm" action="" method="post">
													<div class="form-group">
														<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('front_single_service');?>: </label>
														<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
															<?php
															if($in_cart == false)
															{ 
																if(count($tpl['service_arr'] ) > 1)
																{
																	?>
																	<select name="service_id" class="form-control pjAsSelectorService" data-iso="<?php echo $controller->_get->toString('date');?>" data-employee_id="<?php echo $employee['id'];?>" >
																		<option value="" data-eid="<?php echo (int) $employee['id']; ?>" data-sid="" data-slug="<?php echo $slug;?>">-- <?php __('front_choose')?> --</option>
																		<?php
																		foreach($tpl['service_arr'] as $service)
																		{
																			if ((int) $tpl['option_arr']['o_seo_url'] === 1)
																			{
																				$slug = sprintf("%s/%s/%s/%s/%s-%u/%s-%u.html", 'Employee', $year, $month, $day, $controller->friendlyURL($employee['name']), $employee['id'], $controller->friendlyURL($service['name']), $service['id']);
																			} else {
																				$slug = NULL;
																			}
																			if(isset($tpl['service']))
																			{
																				?><option value="<?php echo $service['id'];?>"<?php echo (int) $tpl['service']['id'] == $service['id'] ? ' selected="selected"' : null;?> data-eid="<?php echo $employee['id']; ?>" data-sid="<?php echo $service['id']; ?>" data-slug="<?php echo $slug;?>"><?php echo pjSanitize::html($service['name']);?></option><?php
																			}else{
																				?><option value="<?php echo $service['id'];?>" data-eid="<?php echo (int) $employee['id']; ?>" data-sid="<?php echo $service['id']; ?>" data-slug="<?php echo $slug;?>"><?php echo pjSanitize::html($service['name']);?></option><?php
																			}
																		} 
																		?>
																	</select>
																	<?php
																}else{
																	?>
																	<input type="hidden" name="service_id" value="<?php echo $tpl['service_arr'][0]['id'];?>" />
																	<label class="form-control-static"><?php echo pjSanitize::html($tpl['service_arr'][0]['name']);?></label>
																	<?php
																}
															}else{
																?><p class="form-control-static"><?php echo pjSanitize::html($tpl['service']['name']);?></p><?php
															} 
															?>
														</div>
													</div>
													
													<div class="form-group" style="display:<?php echo $in_cart == false && isset($tpl['service']) ? ' block' : ' none'; ?>">
														<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('front_time');?>: </label>
														<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
															<div class="pjAsTableTimes">
																<?php
																echo $time_table;
																?>
															</div><!-- /.pjAsTableTimes -->
														</div><!-- /.col-lg-8 col-md-8 col-sm-8 col-sx-12 -->
													</div><!-- /.form-group -->
													
													<div class="row pjAsEmployeeTimes" style="display:<?php echo $in_cart == false ? ' none' : ' block';?>">
														<label for="" class="col-lg-3 col-md-3 col-sm-3 col-sx-12 control-label text-capitalize"><?php __('front_time');?>: </label>
														<div class="col-lg-9 col-md-9 col-sm-9 col-sx-12">
															<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
																<div class="form-group pjAsEmployeeTime asEmployeeTime" style="display:<?php echo $in_cart == false ? ' none' : ' block';?>">
																	<div class="well well-sm pjAsBox pjAsBoxTimeStart">
																		<dl class="dl-horizontal">
																			<dt class="text-capitalize"><?php __('front_start_time'); ?></dt><!-- /.text-capitalize -->
																							
																			<dd class="text-uppercase asEmployeeTimeValue"><?php echo $in_cart == true ? $cell['time'] : null; ?></dd><!-- /.text-uppercase -->
																		</dl><!-- /.dl-horizontal -->
																	</div><!-- /.well well-sm pjAsBox pjAsBoxTimeStart -->
																</div><!-- /.form-group -->
															</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-6 -->
	
															<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
																<div class="form-group pjAsEmployeeTime asEmployeeTime" style="display:<?php echo $in_cart == false ? ' none' : ' block';?>">
																	<div class="well well-sm pjAsBox pjAsBoxTimeEnd">
																		<dl class="dl-horizontal">
																			<dt class="text-capitalize"><?php __('front_end_time'); ?></dt><!-- /.text-capitalize -->
																							
																			<dd class="text-uppercase asEmployeeTimeValue"><?php echo $in_cart == true ? $cell['data_end'] : null; ?></dd><!-- /.text-uppercase -->
																		</dl><!-- /.dl-horizontal -->
																	</div><!-- /.well well-sm pjAsBox pjAsBoxTimeEnd -->
																</div><!-- /.form-group -->
															</div><!-- /.col-lg-6 col-md-6 col-sm-6 col-xs-6 -->
														</div><!-- /.col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12 -->
													</div><!-- /.row pjAsEmployeeTimes -->
													<?php
													if($in_cart == false)
													{ 
														?>
														<div class="form-group">
															<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
																<input class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsBtnAppointment" value="<?php __('front_btn_book_slot', false, true); ?>"<?php echo $in_cart == false ? ' disabled="disabled"' : true;?> type="submit">
																<a href="#" class="btn btn-default pjAsBtn pjAsBtnSecondary pjAsBtnBackToEmployees"><?php __('btnCancel'); ?></a>
															</div><!-- /.col-lg-8 col-lg-offset-4 col-md-8 col-md-offset-4 col-sm-8 col-sm-offset-4 col-sx-12 -->
														</div><!-- /.form-group -->
														<?php
													}else{
														list($cid, $date, $service_id, $start_ts, $end_ts, $employee_id) = explode("|", $key_in_cart);
														?>
														<div class="form-group">
															<div class="col-lg-9 col-lg-offset-3 col-md-9 col-md-offset-3 col-sm-9 col-sm-offset-3 col-sx-12">
																<a href="#" class="btn btn-default pjAsBtn pjAsBtnPrimary pjAsBtnGotoCheckout"><?php __('front_checkout');?></a>
																<a href="#" class="btn btn-default pjAsBtn pjAsBtnSecondary pjAsBtnRemoveFromCart" data-start_ts="<?php echo $start_ts; ?>" data-end_ts="<?php echo $end_ts; ?>" data-date="<?php echo $date; ?>" data-service_id="<?php echo $service_id; ?>" data-employee_id="<?php echo $employee_id; ?>"><?php __('btnCancelAppointment'); ?></a>
															</div><!-- /.col-lg-8 col-lg-offset-4 col-md-8 col-md-offset-4 col-sm-8 col-sm-offset-4 col-sx-12 -->
														</div><!-- /.form-group -->
														<?php
													} 
													?>
													
													<input type="hidden" name="date" value="<?php echo date($tpl['option_arr']['o_date_format'], strtotime($controller->_get->toString('date')));?>" />
													<input type="hidden" name="employee_id" value="<?php echo (int) $tpl['employee']['id']; ?>" />
													<input type="hidden" name="start_ts" value="<?php echo $in_cart == true ? $cell['data_start_ts'] : null; ?>" />
													<input type="hidden" name="end_ts" value="<?php echo $in_cart == true ? $cell['data_end_ts'] : null; ?>" />
												</form>
											</div><!-- /.form-horizontal asEmployeeInfo -->
											<?php
										}
									} 
								}
								?>
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
		</div><!-- /.col-lg-8 col-md-8 col-sm-12 col-xs-12 -->
	</div>
</div><!-- /.container-fluid -->