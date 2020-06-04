(function ($, undefined) {
    $(function () {
        $(document).on("change", 'select[name^="plugin_payment_options["][data-box]', function (e) {
            var box = $('[class="' + $(this).attr('data-box') + '"]'),
                is_active = parseInt($(this).val(), 10) == 1;
            box.toggle(is_active);
            box.find('input:not(.optional-po)').toggleClass('required', is_active);
            box.find('input[name$="merchant_email]"]').toggleClass('email', is_active);
        });
    });
})(jQuery_1_8_2);