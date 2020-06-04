var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var validator,
			$modalView = $("#modalView"),
			$modalItemEmail = $("#modalItemEmail"),
			$modalItemSms = $("#modalItemSms"),
			dialog = ($.fn.dialog !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			datepicker = ($.fn.datepicker !== undefined);
		
		function myTinyMceDestroy() {
			
			if (window.tinymce === undefined) {
				return;
			}
			
			var iCnt = tinymce.editors.length;
			
			if (!iCnt) {
				return;
			}
			
			for (var i = 0; i < iCnt; i++) {
				tinymce.remove(tinymce.editors[i]);
			}
		}
		
		function myTinyMceInit(pSelector) {
			
			if (window.tinymce === undefined) {
				return;
			}
			
			tinymce.init({
				relative_urls : false,
				remove_script_host : false,
				convert_urls : true,
				browser_spellcheck : true,
			    contextmenu: false,
			    selector: pSelector,
			    theme: "modern",
			    height: 480,
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
		}
		
		if (datepicker) {
			$.fn.datepicker.dates['en'] = {
	        	days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
	        	daysMin: myLabel.days.split("_"),
	        	daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
	        	months: myLabel.months.split("_"),
	        	monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    		}
		}
		
		if($('.frm-filter-advanced .date').length > 0 && datepicker)
        {
            $('.frm-filter-advanced .date').datepicker();
        }
		
		function formatClient (str, obj) {
			return [obj.c_name, 
			        (obj.c_email && obj.c_email.length > 0 ? ['<br><a href="mailto:', obj.c_email, '">', obj.c_email, '</a>'].join('') : ''), 
			        (obj.c_phone && obj.c_phone.length > 0 ? ['<br>', obj.c_phone].join('') : '')
			        ].join("");
		}
		
		function formatCustom(str, obj) {
			return ['<a href="#" class="btn btn-primary btn-outline btn-sm m-l-xs item-email"><i class="fa fa-envelope"></i></a><a href="#" class="btn btn-primary btn-outline btn-sm m-l-xs item-sms"><i class="fa fa-phone"></i></a>'].join('');
		}
		
		function formatDt(str, obj) {
			return obj.time;
		}
		
		function formatStatus (str, obj) {
			switch (obj.status)
            {
                case 'confirmed':
                    return '<i class="fa fa-check"></i> ' + str;
                    break;
                case 'pending':
                    return '<i class="fa fa-exclamation-triangle"></i> ' + str;
                    break;
                case 'cancelled':
                    return '<i class="fa fa-times"></i> ' + str;
                    break;
            }

			return str;
		}
		
		if ($("#grid_list").length > 0 && datagrid) {
			
			var $grid_list = $("#grid_list").datagrid({
				buttons: [{type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"}],
				columns: [{text: myLabel.uuid, type: "text", sortable: true, editable: false},
				          {text: myLabel.service, type: "text", sortable: true, editable: false},
				          {text: myLabel.dt, type: "text", sortable: true, editable: false, renderer: formatDt},
				          {text: myLabel.customer, type: "text", sortable: true, editable: false, renderer: formatClient},
				          {text: myLabel.status, type: "select", sortable: true, editable: true, renderer: formatStatus, options: [
				              				                                                                                     {label: myLabel.confirmed, value: 'confirmed'},
				              				                                                                                     {label: myLabel.pending, value: 'pending'},
				              				                                                                                     {label: myLabel.cancelled, value: 'cancelled'}
				              				                                                                                     ], applyClass: "btn btn-xs no-margin bg"},
				          {text: "", type: "text", sortable: false, editable: false, renderer: formatCustom}
				],
				dataUrl: "index.php?controller=pjAdminBookings&action=pjActionGetBookingService",
				dataType: "json",
				fields: ['uuid', 'service_name', 'start_ts', 'c_name', 'booking_status', 'id']
			});
		}
		
		$(document).on("change", ".btn-filter", function () {
			
			var $this = $(this),
				content = $grid_list.datagrid("option", "content"),
				cache = $grid_list.datagrid("option", "cache"),
				obj = {};
			
			obj.booking_status = $this.val();
			$.extend(cache, obj);
			$grid_list.datagrid("option", "cache", cache);
			$grid_list.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBookingService", "date", "DESC", content.page, content.rowCount);
			
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid_list.datagrid("option", "content"),
				cache = $grid_list.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid_list.datagrid("option", "cache", cache);
			$grid_list.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBookingService", "date", "DESC", content.page, content.rowCount);
			return false;
		}).on("submit", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var obj = {},
				$this = $(this),
				arr = $this.serializeArray(),
				content = $grid_list.datagrid("option", "content"),
				cache = $grid_list.datagrid("option", "cache");
			for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
				obj[arr[i].name] = arr[i].value;
			}
			cache.q = "";
			$.extend(cache, obj);
			$grid_list.datagrid("option", "cache", cache);
			$grid_list.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBookingService", "date", "DESC", content.page, content.rowCount);
			return false;
		}).on("click", ".pj-table-icon-edit", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionViewBookingService", {
				"id": $(this).data("id").id
			}).done(function (data) {
				$modalView.find(".modal-content").html(data);
				$modalView.modal('show');
			});
		}).on("click", ".employee-booking", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionViewBookingService", {
				"id": $(this).data("id")
			}).done(function (data) {
				$modalView.find(".modal-content").html(data);
				$modalView.modal('show');
			});
		}).on("click", ".item-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemEmail", {
				"id": $(this).closest("tr").data("object").id
			}).done(function (data) {
				$modalItemEmail.find(".modal-content").html(data);
				$modalItemEmail.modal('show');
				
				if ($('.mceEditor').length > 0) {
					myTinyMceDestroy.call(null);
					myTinyMceInit.call(null, 'textarea.mceEditor');
		        }
				
				validator = $modalItemEmail.find("form").validate({
					errorClass: "error_clean"
				});
			});
		}).on("click", ".btnItemEmail", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.post("index.php?controller=pjAdminBookings&action=pjActionItemEmail", $modalItemEmail.find("form").serialize()).done(function (data) {
				$modalItemEmail.modal('hide');
			});
		}).on("click", ".item-sms", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemSms", {
				"id": $(this).closest("tr").data("object").id
			}).done(function (data) {
				$modalItemSms.find(".modal-content").html(data);
				$modalItemSms.modal('show');
				validator = $modalItemSms.find("form").validate({
					errorClass: "error_clean"
				});
			});
			return false;
		}).on("click", ".btnItemSms", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.post("index.php?controller=pjAdminBookings&action=pjActionItemSms", $modalItemSms.find("form").serialize()).done(function (data) {
				$modalItemSms.modal('hide');
			});
		});
	});
})(jQuery_1_8_2);