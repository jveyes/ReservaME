<?php
$STORAGE = &$_SESSION[$controller->defaultInstaller];
?>

<form action="index.php?controller=pjInstaller&amp;action=pjActionStep3&amp;install=1" method="post" id="frmStep2" class="wizard-big">
    <h2>Requires</h2>

    <fieldset></fieldset>

    <h2>License key</h2>

    <fieldset>
        <?php
        $hasErrors = FALSE;
        $err = $controller->_get->toString('err');
        if ($err && isset($_SESSION[$controller->defaultErrors][$err]))
        {
            ?>
            <div class="alert alert-danger">
                <i class="fa fa-exclamation-triangle m-r-xs"></i>
                <strong>Installation error!</strong>
                <?php echo $_SESSION[$controller->defaultErrors][$err]; ?>
            </div>
            <?php
            $hasErrors = TRUE;
            $alert = array('status' => 'ERR', 'text' => strip_tags($_SESSION[$controller->defaultErrors][$err]));
        }
        ?>

        <input type="hidden" name="step2" value="1" />
        <input type="submit" style="display: none;">

        <div class="m-b-md">
            <p>Enter your licence key. You can find your key under Profile page in your <a href="https://www.phpjabbers.com/accounts/login" target="_blank">PHPJabbers.com account</a>.</p>
	        <p>Please, note that it is against our licence policy to install our products without providing valid licence key. You can check our our Licence policy <a href="licence.html" target="_blank">here</a>.</p>
        </div><!-- /.m-b-md -->

        <div class="hr-line-dashed"></div>

        <div class="row">
            <div class="col-lg-6">
                <div class="form-group">
                    <label>License key <span class="text-danger">*</span></label>

                    <input type="text" tabindex="1" name="license_key" class="form-control required" value="<?php echo isset($STORAGE['license_key']) ? htmlspecialchars($STORAGE['license_key']) : NULL; ?>">
                </div>
            </div>
        </div>

        <div class="hr-line-dashed"></div>

        <p>Need help? <a href="https://www.phpjabbers.com/contact.php" target="_blank">Contact us</a></p>
    </fieldset>

    <h2>MySQL Details</h2>

    <fieldset></fieldset>

    <h2>Install Paths</h2>

    <fieldset></fieldset>

    <h2>Admin Login</h2>

    <fieldset></fieldset>

    <h2>Install Progress</h2>

    <fieldset></fieldset>

    <h2>Finish</h2>

    <fieldset></fieldset>
</form>