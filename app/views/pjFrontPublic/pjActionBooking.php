<!DOCTYPE HTML>
<html lang="es-CO">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="3; url=https://citas.jmvb.co/app/preview.php">
        <script type="text/javascript">
            window.location.href = "https://citas.jmvb.co/app/preview.php"
        </script>
        <title>Reserva finalizada</title>
    </head>
    <body>
        
      <?php
            if (isset($tpl['status']) && $tpl['status'] == "OK")
            {
            	?>
            	<div class="panel-heading pjAsHead">
            		<div class="row">
            			<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            				<div class="alert alert-warning" role="alert">
            					<?php
            					$status = __('front_booking_status', true);
            					if (isset($tpl['booking_arr']))
            					{
            						if(isset($tpl['params']['plugin']) && !empty($tpl['params']['plugin']))
            						{
            							$payment_messages = __('payment_plugin_messages');
            							?><p class="text-center pjRbSectionSubTitle"><?php echo isset($payment_messages[$tpl['booking_arr']['payment_method']]) ? $payment_messages[$tpl['booking_arr']['payment_method']]: ''; ?><p><?php
            	                        if (pjObject::getPlugin($tpl['params']['plugin']) !== NULL)
            	                        {
            	                            $controller->requestAction(array('controller' => $tpl['params']['plugin'], 'action' => 'pjActionForm', 'params' => $tpl['params']));
            	                        }
            	                    }else{
            					        switch ($tpl['booking_arr']['payment_method'])
            	                        {
            	                            case 'bank':
            	                            	echo $status[1] . '<br/>' .  pjSanitize::html($tpl['bank_account']);
            	                            	?><br/><a href="#" class="alert-link pjAsBtnBackToServices"><?php __('front_start_over');?></a><?php
            	                            	break;
            	                            case 'creditcard':
            	                            case 'cash':
            	                            default:
            	                                echo $status[1];
            									?><br/><br/><a href="#" class="alert-link pjAsBtnBackToServices"><?php __('front_start_over');?></a><?php
            									break;
            	                        }
            	                    }
            					} else {
            						echo $status[4];
            					}
            					?>
            				</div>
            			</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
            		</div>
            	</div>
            	<?php
            } elseif (isset($tpl['status']) && $tpl['status'] == 'ERR') {
            	?>
            	<div class="panel-heading pjAsHead">
            		<div class="row">
            			<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            				<div class="alert alert-warning" role="alert">
            				  	<?php __('front_system_msg'); ?><br/><?php __('front_checkout_na'); ?><br/><a href="#" class="alert-link pjAsBtnBackToServices"><?php __('front_return_back');?></a>
            				</div>
            			</div><!-- /.col-lg-12 col-md-12 col-sm-12 col-xs-12 -->
            		</div><!-- /.row -->
            	</div><!-- /.panel-heading pjAsHead -->
            	<?php
            }
    ?>  
        
    </body>
</html>