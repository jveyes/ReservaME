var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		function myTinyMceInit(pSelector, pValue) {
			tinymce.init({
				relative_urls : false,
				remove_script_host : false,
				convert_urls : true,
				browser_spellcheck : true,
			    contextmenu: false,
			    selector: pSelector,
			    theme: "modern",
			    height: 300,
			    plugins: [
			         "advlist autolink link image lists charmap print preview hr anchor pagebreak",
			         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
			         "save table contextmenu directionality emoticons template paste textcolor"
			    ],
			    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons",
			    image_advtab: true,
			    menubar: "file edit insert view table tools",
			    setup: function (editor) {
			    	editor.on('change', function (e) {
			    		editor.editorManager.triggerSave();
			    	});
			    }
			});
			if (tinymce.editors.length) {							
				tinymce.execCommand('mceAddEditor', true, pValue);
			}
		}
		$("#reminderModal").on("hidden.bs.modal", function () {
        	if (tinymce.editors.length > 0) 
			{
		        tinymce.execCommand('mceRemoveEditor',true, "mceEditor");
		    }
        });
		$(document).on('change', '#jumb_to', function(e){
			var date = $(this).val();
			var action = $(this).attr('data-type');
			var employee = $('#employee_id').val() != '' ? '&employee_id=' + $('#employee_id').val() : '';
			window.location.href='index.php?controller=pjAdminSchedule&action=pjAction'+action+'&date=' + date + employee;
		}).on('change', '#employee_id', function(e){
			var date = $('#jumb_to').val();
			var action = $(this).attr('data-type');
			var employee = $(this).val() != '' ? '&employee_id=' + $(this).val() : '';
			window.location.href='index.php?controller=pjAdminSchedule&action=pjAction'+action+'&date=' + date + employee;
		}).on("change", ".onoffswitch-checkbox", function (e) {
			if ($(this).prop('checked')) {
				window.location.href='index.php?controller=pjAdminSchedule&action=pjActionWeekly';
            } else {
            	window.location.href='index.php?controller=pjAdminSchedule&action=pjActionMonthly';
            }
		}).on('click', '.btn-delete', function(e){
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var id = $(this).attr('data-id');
			var booking_id = $(this).attr('data-booking_id');
			var action = $("#jumb_to").attr('data-type');
			swal({
                title: myLabel.are_you_sure,
                text: myLabel.cancel_text,
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: myLabel.btn_confirm_cancel,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
            	$.post('index.php?controller=pjAdminSchedule&action=pjActionCancelService' + action, {id: id, booking_id: booking_id}).done(function (data) {
            		swal.close();
            		location.reload();
				});
            });
		}).on('click', '.btn-reminder', function(e){
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var booking_id = $(this).attr('data-booking_id');
			var $emailContentWrapper = $('#emailContentWrapper');
			var action = $("#jumb_to").attr('data-type');
			$('#btnSendReminder').attr('data-booking_id', booking_id);
			$emailContentWrapper.html("");
			$.get("index.php?controller=pjAdminSchedule&action=pjActionReminderEmail" + action, {
				"id": booking_id,
			}).done(function (data) {
				$emailContentWrapper.html(data);
				myTinyMceInit.call(null, 'textarea#mceEditor', 'mceEditor');
				validator = $emailContentWrapper.find("form").validate({
					
				});
				$('#reminderModal').modal('show');
			});
		}).on("click", "#btnSendReminder", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this);
			var action = $("#jumb_to").attr('data-type');
			var $emailContentWrapper = $('#emailContentWrapper');
			if (validator.form()) {
				$('#mceEditor').html( tinymce.get('mceEditor').getContent() );
				$(this).attr("disabled", true);
				var l = Ladda.create(this);
			 	l.start();
				$.post("index.php?controller=pjAdminSchedule&action=pjActionReminderEmail" + action, $emailContentWrapper.find("form").serialize()).done(function (data) {
					if (data.status == "OK") {
						$('#reminderModal').modal('hide');
					} else {
						$('#reminderModal').modal('hide');
					}
					$this.attr("disabled", false);
					l.stop();
				});
			}
			return false;
		});
	});
})(jQuery_1_8_2);