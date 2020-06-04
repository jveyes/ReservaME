<?php
$controller_name = $controller->_get->toString('controller');
$action_name = $controller->_get->toString('action');

// Dashboard
$isScriptDashboard = in_array($controller_name, array('pjAdmin')) && in_array($action_name, array('pjActionIndex'));

// Profile
$isScriptProfile = in_array($controller_name, array('pjAdmin')) && in_array($action_name, array('pjActionProfile'));

// Schedule
$isScriptScheduleController = in_array($controller_name, array('pjAdminSchedule'));

$isScriptScheduleWeekly = $isScriptScheduleController && in_array($action_name, array('pjActionWeekly'));
$isScriptScheduleMonthly = $isScriptScheduleController && in_array($action_name, array('pjActionMonthly'));

// Bookings
$isScriptBookingsController = in_array($controller_name, array('pjAdminBookings'));

$isScriptBookingsIndex = $isScriptBookingsController && in_array($action_name, array('pjActionIndex', 'pjActionCreate', 'pjActionUpdate'));
$isScriptBookingsExport = $isScriptBookingsController && in_array($action_name, array('pjActionExport'));

// Services
$isScriptServices = in_array($controller_name, array('pjAdminServices'));

// Employees
$isScriptEmployees = in_array($controller_name, array('pjAdminEmployees'));

// Time
$isScriptTimeController = in_array($controller_name, array('pjAdminTime'));

// Restaurant
$isScriptReportController     = in_array($controller_name, array('pjAdminReports'));

$isScriptReportsEmployees     = $isScriptReportController && in_array($action_name, array('pjActionEmployees'));
$isScriptReportsServices      = $isScriptReportController && in_array($action_name, array('pjActionServices'));

// Settings
$isScriptOptionsController = in_array($controller_name, array('pjAdminOptions', 'pjAdminTime')) && !in_array($action_name, array('pjActionPreview', 'pjActionInstall')) && (!$controller->_get->check('type') || ($controller->_get->check('type') && $controller->_get->toString('type') == 'calendar'));

$isScriptOptionsBooking         = $isScriptOptionsController && in_array($action_name, array('pjActionBooking'));
$isScriptOptionsPayments        = $isScriptOptionsController && in_array($action_name, array('pjActionPayments'));
$isScriptOptionsBookingForm     = $isScriptOptionsController && in_array($action_name, array('pjActionBookingForm'));
$isScriptOptionsTerm            = $isScriptOptionsController && in_array($action_name, array('pjActionTerm'));
$isScriptOptionsNotifications   = $isScriptOptionsController && in_array($action_name, array('pjActionNotifications'));
$isScriptOptionsReminder        = $isScriptOptionsController && in_array($action_name, array('pjActionReminder'));
$isScriptTime       			= in_array($controller_name, array('pjAdminTime'));

// Permissions - Dashboard
$hasAccessScriptDashboard = pjAuth::factory('pjAdmin', 'pjActionIndex')->hasAccess();

// Permissions - Profile
$hasAccessScriptProfile = pjAuth::factory('pjAdmin', 'pjActionProfile')->hasAccess();

// Permissions - Schedule
$hasAccessScriptSchedule          = pjAuth::factory('pjAdminSchedule')->hasAccess();
$hasAccessScriptScheduleWeekly    = pjAuth::factory('pjAdminSchedule', 'pjActionWeekly')->hasAccess();
$hasAccessScriptScheduleMonthly   = pjAuth::factory('pjAdminSchedule', 'pjActionMonthly')->hasAccess();

// Permissions - Bookings
$hasAccessScriptBookings          = pjAuth::factory('pjAdminBookings')->hasAccess();
$hasAccessScriptBookingsIndex     = pjAuth::factory('pjAdminBookings', 'pjActionIndex')->hasAccess();
$hasAccessScriptBookingsExport     = pjAuth::factory('pjAdminBookings', 'pjActionExport')->hasAccess();
$hasAccessScriptBookingsList      = pjAuth::factory('pjAdminBookings', 'pjActionList')->hasAccess();

// Permissions - Services
$hasAccessScriptServices          = pjAuth::factory('pjAdminServices')->hasAccess();

// Permissions - Employees
$hasAccessScriptEmployees         = pjAuth::factory('pjAdminEmployees')->hasAccess();

// Permissions - Time
$hasAccessScriptTime          	  = pjAuth::factory('pjAdminTime')->hasAccess();
$hasAccessScriptEmployeesTime    = pjAuth::factory('pjAdminEmployees', 'pjActionTime')->hasAccess();

// Permissions - Reports
$hasAccessScriptReports            	= pjAuth::factory('pjAdminReports')->hasAccess();
$hasAccessScriptReportsEmployees    = pjAuth::factory('pjAdminReports', 'pjActionEmployees')->hasAccess();
$hasAccessScriptReportsServices     = pjAuth::factory('pjAdminReports', 'pjActionServices')->hasAccess();

// Permissions - Settings
$hasAccessScriptOptions                 = pjAuth::factory('pjAdminOptions')->hasAccess();
$hasAccessScriptOptionsBooking          = pjAuth::factory('pjAdminOptions', 'pjActionBooking')->hasAccess();
$hasAccessScriptOptionsPayments         = pjAuth::factory('pjAdminOptions', 'pjActionPayments')->hasAccess();
$hasAccessScriptOptionsBookingForm      = pjAuth::factory('pjAdminOptions', 'pjActionBookingForm')->hasAccess();
$hasAccessScriptOptionsTerm             = pjAuth::factory('pjAdminOptions', 'pjActionTerm')->hasAccess();
$hasAccessScriptOptionsNotifications    = pjAuth::factory('pjAdminOptions', 'pjActionNotifications')->hasAccess();
$hasAccessScriptOptionsReminder         = pjAuth::factory('pjAdminOptions', 'pjActionReminder')->hasAccess();
?>

<?php if ($hasAccessScriptDashboard): ?>
    <li<?php echo $isScriptDashboard ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdmin&amp;action=pjActionIndex"><i class="fa fa-th-large"></i> <span class="nav-label"><?php __('plugin_base_menu_dashboard');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptSchedule): ?>
    <li<?php echo $isScriptScheduleWeekly || $isScriptScheduleMonthly ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminSchedule&amp;action=pjActionWeekly"><i class="fa fa-calendar"></i> <span class="nav-label"><?php __('menuSchedule');?></span></a>
    </li>
<?php endif; ?>

<?php
if ($controller->isAdmin()) :
	if ($hasAccessScriptBookings): 
		?>
		    <li<?php echo $isScriptBookingsController ? ' class="active"' : NULL; ?>>
		        <a href="#"><i class="fa fa-cog"></i> <span class="nav-label"><?php __('menuBookings');?></span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level collapse">
                    <?php if ($hasAccessScriptBookings): ?>
                        <li<?php echo $isScriptBookingsIndex ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex"><?php __('menuBookings');?></a></li>
                    <?php endif; ?>
                    <?php if ($hasAccessScriptBookingsExport): ?>
                        <li<?php echo $isScriptBookingsExport ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionExport"><?php __('menuExport');?></a></li>
                    <?php endif; ?>
        		</ul>
		    </li>
		<?php 
	endif;
elseif ($controller->isEditor()) :
	if ($hasAccessScriptBookings): 
		?>
		    <li<?php echo $isScriptBookingsController ? ' class="active"' : NULL; ?>>
		        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionIndex"><i class="fa fa-cog"></i> <span class="nav-label"><?php __('menuBookings');?></span></a>
		    </li>
		<?php 
	endif;
else :
	if ($hasAccessScriptBookingsList): 
		?>
		    <li<?php echo $isScriptBookingsController ? ' class="active"' : NULL; ?>>
		        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionList"><i class="fa fa-cog"></i> <span class="nav-label"><?php __('menuBookings');?></span></a>
		    </li>
		<?php 
	endif;
	if ($hasAccessScriptEmployeesTime): 
		?>
		    <li<?php echo $isScriptTimeController ? ' class="active"' : NULL; ?>>
		        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionTime"><i class="fa fa-clock-o"></i> <span class="nav-label"><?php __('menuTime');?></span></a>
		    </li>
		<?php 
	endif;
	if ($hasAccessScriptProfile):
		?>
	    <li<?php echo $isScriptProfile ? ' class="active"' : NULL; ?>>
	        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdmin&amp;action=pjActionProfile"><i class="fa fa-user"></i> <span class="nav-label"><?php __('menuProfile');?></span></a>
	    </li>
	    <?php 
	endif;
endif;
?>

<?php if ($hasAccessScriptServices): ?>
    <li<?php echo $isScriptServices ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminServices&amp;action=pjActionIndex"><i class="fa fa-list"></i> <span class="nav-label"><?php __('menuServices');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptEmployees): ?>
    <li<?php echo $isScriptEmployees || ($isScriptTime && $controller->_get->check('type') && $controller->_get->toString('type') == 'employee') ? ' class="active"' : NULL; ?>>
        <a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminEmployees&amp;action=pjActionIndex"><i class="fa fa-user"></i> <span class="nav-label"><?php __('menuEmployees');?></span></a>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptReports): ?>
    <li<?php echo $isScriptReportController ? ' class="active"' : NULL; ?>>
    	<a href="#"><i class="fa fa-files-o"></i> <span class="nav-label"><?php __('menuReports');?></span><span class="fa arrow"></span></a>
        <ul class="nav nav-second-level collapse">
            <?php if ($hasAccessScriptReportsEmployees): ?>
                <li<?php echo $isScriptReportsEmployees ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminReports&amp;action=pjActionEmployees"><?php __('report_menu_employees');?></a></li>
            <?php endif; ?>
            <?php if ($hasAccessScriptReportsServices): ?>
                <li<?php echo $isScriptReportsServices ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminReports&amp;action=pjActionServices"><?php __('report_menu_services');?></a></li>
            <?php endif; ?>
		</ul>
    </li>
<?php endif; ?>

<?php if ($hasAccessScriptOptions || $hasAccessScriptTime): ?>
    <li<?php echo $isScriptOptionsController || $isScriptTime ? ' class="active"' : NULL; ?>>
        <a href="#"><i class="fa fa-cogs"></i> <span class="nav-label"><?php __('menuOptions');?></span><span class="fa arrow"></span></a>
        <ul class="nav nav-second-level collapse">
            <?php if ($hasAccessScriptOptionsBooking): ?>
                <li<?php echo $isScriptOptionsBooking ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBooking"><?php __('menuBookings');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsPayments): ?>
                <li<?php echo $isScriptOptionsPayments ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionPayments"><?php __('menuPayments');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsBookingForm): ?>
                <li<?php echo $isScriptOptionsBookingForm ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionBookingForm"><?php __('menuBookingForm');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsNotifications): ?>
                <li<?php echo $isScriptOptionsNotifications ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionNotifications&amp;recipient=client&transport=email&amp;variant=confirmation"><?php __('tabEmailNotifications');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsTerm): ?>
                <li<?php echo $isScriptOptionsTerm ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionTerm"><?php __('menuTerms');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptOptionsReminder): ?>
                <li<?php echo $isScriptOptionsReminder ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminOptions&amp;action=pjActionReminder"><?php __('menuReminder');?></a></li>
            <?php endif; ?>

            <?php if ($hasAccessScriptTime): ?>
                <li<?php echo $isScriptTime && (!$controller->_get->check('type') || ($controller->_get->check('type') && $controller->_get->toString('type') == 'calendar')) ? ' class="active"' : NULL; ?>><a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminTime&amp;action=pjActionIndex"><?php __('menuTime');?></a></li>
            <?php endif; ?>
        </ul>
    </li>
<?php endif; ?>