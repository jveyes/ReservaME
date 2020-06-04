<?php 
$booking_status = __('booking_statuses', true);
$cnt_today = count($tpl['today_service_arr']);
?>		
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
		<div class="col-lg-8">
			<div class="row">
				<div class="col-sm-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<span class="label label-primary pull-right"><?php __('dash_next_7_days');?></span>

							<h5><?php __('dash_upcoming_bookings');?></h5>
						</div>

						<div class="ibox-content">
							<div class="row m-t-md m-b-sm">
								<div class="col-xs-6">
									<p class="h1 no-margins"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=<?php echo ($controller->isAdmin() || $controller->isEditor()) ? 'pjActionIndex' : 'pjActionList'; ?>&amp;status=confirmed"><?php echo (int) $tpl['cnt_confirmed'];?></a></p>
									<small class="text-info"><?php __('dash_confirmed');?></small>        
								</div>

								<div class="col-xs-6">
									<p class="h1 no-margins"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=<?php echo ($controller->isAdmin() || $controller->isEditor()) ? 'pjActionIndex' : 'pjActionList'; ?>&amp;status=pending"><?php echo (int) $tpl['cnt_pending'];?></a></p>
									<small class="text-info"><?php __('dash_pending');?></small>        
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="col-sm-6">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<span class="label label-primary pull-right"><?php __('dash_this_month');?></span>

							<h5><?php __('dash_all_bookings');?></h5>
						</div>

						<div class="ibox-content">
							<div class="row m-t-md m-b-sm">
								<div class="col-xs-6">
									<p class="h1 no-margins"><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=<?php echo ($controller->isAdmin() || $controller->isEditor()) ? 'pjActionIndex' : 'pjActionList'; ?>"><?php echo (int) $tpl['cnt_bookings'];?></a></p>
									<small class="text-info"><?php (int) $tpl['cnt_bookings'] == 1 ? __('dash_singular_booking') : __('dash_plural_bookings');?></small>        
								</div>
			    
								<div class="col-xs-6">
									<p class="h1 no-margins"><?php echo pjCurrency::formatPrice($tpl['total_amount']['total_amount'])?></p>
									<small class="text-info"><?php __('dash_total_amount');?></small>        
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>    

			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('dash_latest_bookings');?></h3>
						<small><?php __('dash_total');?> <strong><?php echo $tpl['total_bookings'];?></strong> <?php $tpl['total_bookings'] != 1 ? __('dash_bookings_made') : __('dash_booking_made');?></small>
					</div>

					<div class="pull-right m-t-md">
						<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=<?php echo ($controller->isAdmin() || $controller->isEditor()) ? 'pjActionIndex' : 'pjActionList'; ?>" class="btn btn-primary btn-sm btn-outline m-n"><?php __('dash_view_all_bookings');?></a>
					</div>
				</div>

				<div class="ibox-content">
					<div class="table-responsive table-responsive-secondary">
						<table id="lastest_bookings" class="table table-striped table-hover no-margins">
							<thead>
								<tr>
									<th><?php __('dash_date_time');?></th>
									<th><?php __('dash_client');?></th>
									<th><?php __('dash_service');?></th>
									<th><?php __('dash_duration');?></th>
									<th><?php __('dash_status');?></th>
									<th><?php __('dash_price');?></th>
								</tr>
							</thead>

							<tbody>
								<?php
                            	if(!empty($tpl['latest_bookings']))
                            	{
                                	foreach($tpl['latest_bookings'] as $v)
                                	{
                                	    $seconds = $v['duration'] * 60;
                                	    $time_result = pjUtil::getHourMinFromSeconds($seconds);
                                	    $time_arr = array();
                                	    if($time_result['hours'] > 0)
                                	    {
                                	        $time_arr[] = $time_result['hours'] . ' ' . ($time_result['hours'] != 1 ? __('dash_hours', true) : __('dash_hour', true));
                                	    }
                                	    if($time_result['mins'] > 0)
                                	    {
                                	        $time_arr[] = $time_result['mins'] . ' ' . ($time_result['mins'] != 1 ? __('dash_mins', true) : __('dash_min', true));
                                	    }
                                	    $icon_status = '';
                                	    $badge_status = '';
                                	    switch ($v['booking_status']) {
                                	        case 'confirmed':
                                	            $badge_status = ' bg-confirmed';
                                	            $icon_status = ' fa-check';
                                	            break;
                                	            
                                	        case 'pending':
                                	            $badge_status = ' bg-pending';
                                	            $icon_status = ' fa-exclamation-triangle';
                                	            break;
                                	        case 'cancelled':
                                	            $badge_status = ' bg-canceled';
                                	            $icon_status = ' fa-times';
                                	            break;
                                	    }
                                    	?>
                                        <tr>
                                            <td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id=<?php echo $v['id'];?>"><?php echo date($tpl['option_arr']['o_date_format'] . ', ' . $tpl['option_arr']['o_time_format'], strtotime($v['created']));?></a></td>
                                            <td><?php echo pjSanitize::html($v['c_name']);?></td>
                                            <td><?php echo stripslashes($v['service_package']);?></td>
                                            <td><?php echo join(' ', $time_arr);?></td>
                                            <td><div class="btn<?php echo $badge_status;?> btn-xs no-margin"><i class="fa<?php echo $icon_status;?>"></i> <?php echo $booking_status[$v['booking_status']];?></div></td>
                                            <td><?php echo pjCurrency::formatPrice($v['booking_total']);?></td>
                                        </tr>
                                        <?php
                                	}
                            	}else{
                            	    ?>
                            	    <tr>
                            	    	<td colspan="6"><?php __('dash_no_bookings_found');?></td>
                            	    </tr>
                            	    <?php
                            	}
                                ?>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>

		<div class="col-lg-4 col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content ibox-heading clearfix">
					<div class="pull-left">
						<h3><?php __('dash_what_on_today');?></h3>
						<small><?php __('dash_you_have');?> <strong><?php echo $cnt_today;?></strong> <?php $cnt_today == 1 ? __('dash_booking_today') : __('dash_bookings_today');?></small>
					</div>

					<div class="pull-right m-t-md">
						<?php
						if ($controller->isAdmin() || $controller->isEditor())
						{
							?>
							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionWeekly" class="btn btn-primary btn-sm btn-outline m-n"><?php __('dash_view_schedule');?></a>
							<?php 
						}
						?>
					</div>
				</div>

				<div class="ibox-content inspinia-timeline">
					<?php
					if($cnt_today > 0)
					{
						foreach($tpl['today_service_arr'] as $k => $v)
                    	{
                    	    $seconds = $v['total'] * 60;
                    	    $time_result = pjUtil::getHourMinFromSeconds($seconds);
                    	    $time_arr = array();
                    	    if($time_result['hours'] > 0)
                    	    {
                    	        $time_arr[] = $time_result['hours'] . ' ' . ($time_result['hours'] != 1 ? __('dash_hours', true) : __('dash_hour', true));
                    	    }
                    	    if($time_result['mins'] > 0)
                    	    {
                    	        $time_arr[] = $time_result['mins'] . ' ' . ($time_result['mins'] != 1 ? __('dash_mins', true) : __('dash_min', true));
                    	    }
                    	    $badge_status = '';
                    	    switch ($v['booking_status']) {
                    	        case 'confirmed':
                    	            $badge_status = ' bg-confirmed';
                    	        break;
                    	        
                    	        case 'pending':
                    	            $badge_status = ' bg-pending';
                	            break;
                    	        case 'cancelled':
                    	            $badge_status = ' bg-canceled';
                	            break;
                    	    }
                        	?>
                            <div class="timeline-item">
                                <div class="row">
                                    <div class="col-xs-3 date">
                                        <i class="fa fa-clock-o"></i>
                                        <?php echo date($tpl['option_arr']['o_date_format'] . ', ' . $tpl['option_arr']['o_time_format'], $v['start_ts']);?>
                                    </div>
        
                                    <div class="col-xs-7 content">
                                        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionUpdate&amp;id=<?php echo $v['booking_id'];?>">
                                            <p class="m-b-xs"><strong><?php echo pjSanitize::html($v['client_name']);?></strong></p>
                                            <p class="m-n"><?php __('dash_service');?>: <em><?php echo pjSanitize::html($v['service_name']);?></em></p>
                                            <p class="m-n"><?php __('dash_duration');?>: <em><?php echo join(" ", $time_arr);?></em></p>
                                            <p class="m-b-sm"><?php __('dash_price');?>: <em><?php echo pjCurrency::formatPrice($v['service_price']);?></em></p>
                                        </a>
                                    </div>
                                    
                                    <div class="badge<?php echo $badge_status;?> b-r-sm pull-right m-t-md m-r-sm"><?php echo $booking_status[$v['booking_status']];?></div>
                                </div>
                            </div>
                            <?php
                    	}
                	}else{
                	    ?><p><?php __('dash_no_bookings_found');?></p><?php
                	}
                    ?>
				</div>
			</div>
		</div>
	</div>
</div>