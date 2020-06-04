<?php
if(!isset($_SESSION[$controller->defaultView]) || (isset($_SESSION[$controller->defaultView]) && $_SESSION[$controller->defaultView] == 'both') )
{ 
	$show_both = true;
	?>
	<div class="panel-heading pjAsHead">
		<div class="row">
			
			<div class="col-lg-9 col-md-9 col-sm-8 col-xs-12">
				<ul class="nav nav-pills pjAsNav">
					<li<?php echo $controller->_get->toString('layout') == 2 ? ' class="active"' : NULL;?>><a href="#" class="btn btn-default pjAsBtn pjAsSwitchLayout" data-layout="2"><?php __('front_browse_services');?></a></li>
					<li<?php echo $controller->_get->toString('layout') == 1 ? ' class="active"' : NULL;?>><a href="#" class="btn btn-default pjAsBtn pjAsSwitchLayout"  data-layout="1"><?php __('front_browse_professionalists');?></a></li>
				</ul><!-- /.nav nav-pills pjAsNav -->
			</div><!-- /.col-lg-9 col-md-9 col-sm-8 col-xs-12 -->
				
			<div class="col-lg-3 col-md-3 col-sm-4 col-xs-12">
				<?php
				if(count($cart) > 0)
				{ 
					?>
					<a href="#" class="btn btn-link pjAsBtnLink pjAsBtnCart" data-cnt="<?php echo count($cart);?>">
						<span class="badge"><?php echo count($cart);?> </span>
						<?php echo count($cart) != 1 ? __('front_appointments', true) : __('front_appointment', true);?>
					</a>
					<?php
				} 
				?>
			</div><!-- /.col-lg-3 col-md-3 col-sm-4 col-xs-12 -->
		</div><!-- /.row -->
	</div><!-- /.panel-heading pjAsHead -->
<?php
}
if($controller->_get->check('date'))
{
	?>
	<ul class="list-group pjAsSelectedDateWrapper">
		<li class="list-group-item">
			<div class="row">
				<div class="col-lg-9 col-md-9 col-sm-8 col-xs-12 pjAsSelectedDate">
					<?php __('front_selected_date');?>: <strong><?php echo date($tpl['option_arr']['o_date_format'], strtotime($controller->_get->toString('date')));?></strong>
				</div>
				<?php
				if(!isset($show_both))
				{ 
					if(count($cart) > 0)
					{
						?>
						<div class="col-lg-3 col-md-3 col-sm-4 col-xs-12">
							<a href="#" class="btn btn-link pjAsBtnLink pjAsBtnCart" data-cnt="<?php echo count($cart);?>">
								<span class="badge"><?php echo count($cart);?> </span>
								<?php echo count($cart) != 1 ? __('front_appointments', true) : __('front_appointment', true);?>
							</a>
						</div>
						<?php
					}
				} 
				?>
			</div>
		</li><!-- /.list-group-item -->
		<?php
		if(isset($tpl['unavailable']))
		{
			?>
			<li class="list-group-item">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 text-danger">
						<?php __('front_unavailable_making_appiontment');?>
					</div>
				</div>
			</li>
			<?php
		} 
		?>
	</ul><!-- /.list-group .pjAsSelectedDateWrapper -->
	<?php
} 
?>