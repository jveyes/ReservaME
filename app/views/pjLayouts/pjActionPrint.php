<!doctype html>
<html>
	<head>
		<title>Gestion de reservas</title>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
		<link type="text/css" rel="stylesheet" href="<?php echo PJ_INSTALL_URL . PJ_CSS_PATH?>print.css" />
		<style type="text/css">
		html, body{
			background-image: none;
			background-color: #fff;
		}
		</style>
		<!--[if gte IE 9]>
  		<style type="text/css">.gradient {filter: none}</style>
		<![endif]-->
	</head>
	<body style="background-image: none; background-color: #fff;">
		<div style="width: 912px; margin: 0 auto;">
		<?php require $content_tpl; ?>
        </div>
        <script type="text/javascript">
        window.onload = function () {
			window.print();
        };
        </script>
	</body>
</html>