var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		$(document).on("click", "#lastest_bookings tbody tr", function (e) {
			var href = $(this).find("a").attr("href");
	        if(href) {
	            window.location = href;
	        }
		})
	});
})(jQuery_1_8_2);