<div class="panel-heading pjAsHead">
	<img src="https://citas.jmvb.co/wp-content/uploads/2020/05/SuLogotipo.png" alt="" class="img-responsive center-block">
</div><!-- /.panel-heading pjAsHead -->

<?php
$cart = $controller->cart->getAll();
$cart_arr = $tpl['cart_arr'];
include PJ_VIEWS_PATH . 'pjFrontPublic/elements/car_layout2.php';
?>